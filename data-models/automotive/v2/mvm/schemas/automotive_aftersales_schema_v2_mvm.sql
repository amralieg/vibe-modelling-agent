-- Schema for Domain: aftersales | Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-14 04:30:39

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_automotive_v1`.`aftersales` COMMENT 'Post-sale customer support including warranty management, service campaigns, recall execution, and parts distribution. Manages service appointments, repair orders, TSB (Technical Service Bulletin) distribution, DTC (Diagnostic Trouble Code) analysis, and labor time standards. Tracks warranty claims, parts consumption, service revenue, and customer retention. Includes field service operations and authorized service center network management. Integrates with CDK Global DMS and OBD (On-Board Diagnostics) systems.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` (
    `aftersales_repair_order_id` BIGINT COMMENT 'Unique identifier for the repair_order data product (auto-inserted pre-linking).',
    `aftersales_service_appointment_id` BIGINT COMMENT 'Foreign key linking to aftersales.aftersales_service_appointment. Business justification: A repair order is typically created from a service appointment. The appointment is the precursor event that triggers the RO. ARO already has appointment_scheduled_timestamp, appointment_arrival_timest',
    `fleet_contract_id` BIGINT COMMENT 'Foreign key linking to sales.fleet_contract. Business justification: Fleet contracts include maintenance and service SLA terms. Repair orders for fleet vehicles must reference the fleet contract for billing against contract rates, SLA compliance reporting, and fleet ac',
    `loyalty_membership_id` BIGINT COMMENT 'Foreign key linking to customer.loyalty_membership. Business justification: Loyalty point accrual at service: repair orders are the primary aftersales transaction that earns loyalty points. The RO must reference the membership to post points correctly and support loyalty prog',
    `organization_account_id` BIGINT COMMENT 'Foreign key linking to customer.customer_fleet_account. Business justification: Fleet billing: corporate fleet repair orders must be invoiced to the fleet account, not the individual driver. Fleet account managers require this link for consolidated billing, fleet maintenance cost',
    `plant_id` BIGINT COMMENT 'Identifier of the service advisor who created the repair order.',
    `party_id` BIGINT COMMENT 'Identifier of the customer who owns the vehicle.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer/service center handling the repair.',
    `service_campaign_id` BIGINT COMMENT 'Identifier of a service campaign (e.g., TSB) associated with this repair.',
    `service_center_id` BIGINT COMMENT 'Identifier of the physical service location.',
    `technician_id` BIGINT COMMENT 'Identifier of the primary technician assigned to perform the work.',
    `trade_in_id` BIGINT COMMENT 'Foreign key linking to sales.trade_in. Business justification: Trade-in vehicles require reconditioning repair orders before CPO resale. Linking the repair order to the trade_in record enables reconditioning cost tracking, CPO certification workflows, and used-ve',
    `telemetry_event_id` BIGINT COMMENT 'Foreign key linking to sales.telemetry_event. Business justification: Repair orders created directly from remote diagnostics or OTA fault detection must reference the triggering telemetry event for root-cause traceability, warranty claim substantiation, and connected-ve',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Required for warranty eligibility and service cost attribution; repair orders must reference the original vehicle order to verify coverage and allocate service revenue.',
    `vehicle_warranty_id` BIGINT COMMENT 'Foreign key linking to aftersales.vehicle_warranty. Business justification: When a repair order is processed under warranty, it should reference the specific VIN-level vehicle_warranty entitlement record. ARO currently has warranty_flag and warranty_type (execution-specific, ',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Required for warranty verification and recall tracking in the Repair Order processing workflow, linking each order to the vehicles VIN registry record.',
    `warranty_claim_id` BIGINT COMMENT 'Foreign key linking to aftersales.aftersales_warranty_claim. Business justification: ARO has warranty_claim_number as a STRING denormalized reference to the warranty claim. Replacing this with a proper FK to aftersales_warranty_claim normalizes the relationship and enables referential',
    `actual_completion_time` TIMESTAMP COMMENT 'Actual date and time when the repair was completed.',
    `aftersales_repair_order_status` STRING COMMENT 'Current lifecycle status of the repair order.. Valid values are `open|in_progress|quality_check|closed|invoiced|cancelled`',
    `appointment_arrival_timestamp` TIMESTAMP COMMENT 'Timestamp when the vehicle arrived at the service center.',
    `appointment_departure_timestamp` TIMESTAMP COMMENT 'Timestamp when the vehicle left the service center.',
    `appointment_scheduled_timestamp` TIMESTAMP COMMENT 'Date and time when the service appointment was scheduled.',
    `close_timestamp` TIMESTAMP COMMENT 'Date and time when the repair order was closed.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the repair order record was first created in the system.',
    `currency_code` STRING COMMENT 'Three-letter ISO currency code for monetary values.. Valid values are `USD|CAD|EUR|GBP|JPY`',
    `customer_feedback_score` STRING COMMENT 'Numeric rating (1-5) provided by the customer after service.',
    `customer_signature_flag` BOOLEAN COMMENT 'Indicates whether the customer signed off on the repair order.',
    `diagnostic_code` STRING COMMENT 'Standard OBD diagnostic code recorded during service.. Valid values are `^[0-9]{4}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount applied to the repair order.',
    `is_estimate` BOOLEAN COMMENT 'Indicates whether the record is an estimate prior to work being performed.',
    `labor_rate_per_hour` DECIMAL(18,2) COMMENT 'Standard labor rate applied per hour.',
    `labor_total_cost` DECIMAL(18,2) COMMENT 'Total cost of labor before taxes and discounts.',
    `labor_total_hours` DECIMAL(18,2) COMMENT 'Total labor hours recorded for the repair order.',
    `mileage_at_service` STRING COMMENT 'Vehicle odometer reading at the time of service.',
    `net_amount` DECIMAL(18,2) COMMENT 'Final amount after tax and discount.',
    `open_timestamp` TIMESTAMP COMMENT 'Date and time when the repair order was opened.',
    `parts_total_cost` DECIMAL(18,2) COMMENT 'Total cost of parts consumed before taxes and discounts.',
    `payment_method` STRING COMMENT 'Method used by the customer to settle the repair order.. Valid values are `cash|credit_card|debit_card|bank_transfer|mobile_payment|check`',
    `payment_status` STRING COMMENT 'Current status of the payment for the repair order.. Valid values are `pending|paid|failed|refunded`',
    `promised_completion_time` TIMESTAMP COMMENT 'Scheduled date and time promised to the customer for repair completion.',
    `ro_number` STRING COMMENT 'External repair order number assigned by the service center.',
    `service_center_region` STRING COMMENT 'Geographic region where the service center is located.. Valid values are `North|South|East|West|Central`',
    `service_notes` STRING COMMENT 'Free-text notes entered by service advisor describing work performed.',
    `service_priority` STRING COMMENT 'Priority level assigned to the repair order.. Valid values are `high|medium|low|critical`',
    `service_type` STRING COMMENT 'Category of service performed.. Valid values are `maintenance|repair|recall|campaign|diagnostic`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax applied to the repair order.',
    `technician_notes` STRING COMMENT 'Free-text notes entered by the technician during repair.',
    `total_amount` DECIMAL(18,2) COMMENT 'Gross amount of the repair order before tax and discount.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the repair order record.',
    `warranty_flag` BOOLEAN COMMENT 'Indicates whether the repair is covered under warranty.',
    `warranty_type` STRING COMMENT 'Type of warranty covering the repair.. Valid values are `manufacturer|extended|service_contract`',
    CONSTRAINT pk_aftersales_repair_order PRIMARY KEY(`aftersales_repair_order_id`)
) COMMENT 'Core transactional record capturing a vehicle service or repair event at an authorized service center or dealership. Tracks RO number, vehicle VIN, customer, service advisor, open/close dates, labor operations performed, parts consumed, total labor cost, total parts cost, total RO value, payment method, warranty vs. customer pay vs. internal pay type, DMS source (CDK Global), mileage at write-up, promised completion time, actual completion time, technician assignments, and RO status lifecycle (open, in-progress, quality-check, closed, invoiced).';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` (
    `repair_order_line_id` BIGINT COMMENT 'System-generated unique identifier for the repair order line.',
    `aftersales_repair_order_id` BIGINT COMMENT 'Identifier of the parent repair order header to which this line belongs.',
    `aftersales_service_appointment_id` BIGINT COMMENT 'Identifier of the service appointment linked to this line.',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: REQUIRED: Parts Traceability Report for warranty investigations needs to link each repair line to the inbound part record it originated from.',
    `service_center_id` BIGINT COMMENT 'Identifier of the authorized service center where work was performed.',
    `service_part_id` BIGINT COMMENT 'Foreign key linking to aftersales.service_part. Business justification: ROL captures parts consumed during a repair (part_price, part_quantity, parts_used_flag) but has no FK to the in-domain service_part master record. ROL already has cross-domain FKs to inventory.sku_ma',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: REQUIRED: Parts used in a repair order line must be tracked against the inventory SKU master for cost, stock deduction, and compliance reporting.',
    `storage_location_id` BIGINT COMMENT 'Foreign key linking to inventory.storage_location. Business justification: REQUIRED: Service parts are issued from a specific warehouse bin; linking to storage_location enables inventory location traceability for service.',
    `technician_id` BIGINT COMMENT 'Identifier of the technician who performed the labor.',
    `warranty_claim_id` BIGINT COMMENT 'Identifier of the warranty claim associated with this line, if applicable.',
    `actual_technician_hours` DECIMAL(18,2) COMMENT 'Actual labor hours logged by the technician for this line.',
    `cause_complaint` STRING COMMENT 'Narrative describing the customer complaint or issue that initiated the service.',
    `correction` STRING COMMENT 'Narrative describing the corrective action taken to resolve the complaint.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the repair order line record was created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 currency code for monetary values on the line.. Valid values are `USD|CAD|EUR|GBP|JPY|CNY`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Monetary discount applied to this line, if any.',
    `labor_category` STRING COMMENT 'Broad classification of the labor type performed.. Valid values are `mechanical|electrical|diagnostic|body|software`',
    `labor_rate` DECIMAL(18,2) COMMENT 'Hourly labor rate applied to the technician for this operation.',
    `labor_skill_level` STRING COMMENT 'Skill level required for the technician to perform the operation.. Valid values are `apprentice|journeyman|master|specialist`',
    `labor_time_standard` DECIMAL(18,2) COMMENT 'Flat‑rate standard labor time in hours for the operation code.',
    `line_sequence` STRING COMMENT 'Sequential number of the line within the repair order for ordering.',
    `line_status` STRING COMMENT 'Current processing status of the repair order line.. Valid values are `open|in_progress|completed|closed|canceled`',
    `line_total` DECIMAL(18,2) COMMENT 'Total monetary amount for the line (labor_rate * actual_technician_hours) before discounts and taxes.',
    `notes` STRING COMMENT 'Additional free‑form notes entered by the technician or service advisor.',
    `operation_code` STRING COMMENT 'Standard code representing the specific labor operation performed (e.g., oil change, brake inspection).',
    `overtime_flag` BOOLEAN COMMENT 'True if overtime rates were applied to this labor line.',
    `overtime_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to the labor_rate when overtime_flag is true (e.g., 1.5).',
    `part_price` DECIMAL(18,2) COMMENT 'Standard price per unit of the part at the time of service.',
    `part_quantity` DECIMAL(18,2) COMMENT 'Quantity of the part used for this line.',
    `parts_used_flag` BOOLEAN COMMENT 'Indicates whether any parts were consumed on this line.',
    `service_date` DATE COMMENT 'Date on which the service work was performed.',
    `sublet_cost` DECIMAL(18,2) COMMENT 'Total cost charged by the sublet vendor for this line.',
    `sublet_flag` BOOLEAN COMMENT 'True if the work was performed by an external subcontractor.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Tax applied to the line total.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the repair order line record.',
    `vehicle_vin` STRING COMMENT 'Unique 17‑character identifier of the vehicle serviced.. Valid values are `^[A-HJ-NPR-Z0-9]{17}$`',
    `warranty_flag` BOOLEAN COMMENT 'Indicates whether the labor line is covered under warranty (true) or not (false).',
    CONSTRAINT pk_repair_order_line PRIMARY KEY(`repair_order_line_id`)
) COMMENT 'Individual labor operation or job line within a repair order. Captures operation code, labor time standard (flat-rate hours), actual technician hours, labor rate, line total, technician ID, cause/complaint/correction (3C) narrative, warranty flag, sublet flag, and line status. Supports granular cost analysis and technician productivity tracking per CDK Global DMS job line structure.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` (
    `warranty_claim_id` BIGINT COMMENT 'Unique identifier for the warranty_claim data product (auto-inserted pre-linking).',
    `plant_id` BIGINT COMMENT 'Foreign key linking to manufacturing.plant. Business justification: Associates warranty claim creation with the responsible employee for accountability and claim processing KPI.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier. Business justification: OEMs recover warranty costs from suppliers whose parts caused failures (supplier warranty chargebacks). The warranty claim header needs a direct responsible-supplier FK to drive chargeback processing,',
    `root_cause_analysis_id` BIGINT COMMENT 'Foreign key linking to quality.root_cause_analysis. Business justification: Warranty claims drive the 8D/root cause analysis process. Warranty adjudication teams reference the RCA record during claim review and supplier chargeback decisions. This is a core named business proc',
    `service_campaign_id` BIGINT COMMENT 'Identifier of the recall or service campaign linked to the claim.',
    `service_center_id` BIGINT COMMENT 'Identifier of the authorized service center performing the repair.',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: Warranty Claim Settlement process requires linking each claim to the supplier contract that governs parts coverage.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.sales_contract. Business justification: Warranty claims must reference the originating sales contract to verify coverage terms and reconcile financials between sales and aftersales.',
    `vehicle_ownership_id` BIGINT COMMENT 'Foreign key linking to customer.vehicle_ownership. Business justification: Claims processing must reference the specific ownership period to determine coverage limits and calculate accurate claim payouts.',
    `vehicle_warranty_id` BIGINT COMMENT 'Foreign key linking to aftersales.vehicle_warranty. Business justification: A warranty claim is filed against a specific VIN-level vehicle_warranty entitlement record. AWC currently references warranty_policy (the master policy definition) but lacks a FK to vehicle_warranty (',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Needed for claim eligibility validation against the vehicles VIN registry during Warranty Claim adjudication.',
    `party_id` BIGINT COMMENT 'Identifier of the vehicle owner who is the warranty claimant.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer or service center submitting the claim.',
    `warranty_aftersales_dealership_id` BIGINT COMMENT 'Identifier of the dealer or service center submitting the claim.',
    `warranty_aftersales_party_id` BIGINT COMMENT 'Identifier of the vehicle owner who is the warranty claimant.',
    `warranty_policy_id` BIGINT COMMENT 'Foreign key linking to aftersales.warranty_policy. Business justification: A warranty claim is filed under a specific warranty policy; linking directly to warranty_policy provides direct access to policy terms without needing to traverse vehicle_warranty.',
    `adjudication_outcome` STRING COMMENT 'Result of the OEMs review of the claim.. Valid values are `approved|rejected|partial|pending`',
    `adjusted_amount` DECIMAL(18,2) COMMENT 'Monetary amount of the adjustment applied to the claim.',
    `approved_labor_cost` DECIMAL(18,2) COMMENT 'Monetary amount approved for labor services.',
    `approved_labor_hours` DECIMAL(18,2) COMMENT 'Number of labor hours approved for reimbursement.',
    `approved_parts_cost` DECIMAL(18,2) COMMENT 'Monetary amount approved for parts used in the repair.',
    `claim_adjusted_flag` BOOLEAN COMMENT 'Indicates whether the claim amount was later adjusted.',
    `claim_category` STRING COMMENT 'High‑level classification of the claim type.. Valid values are `repair|recall|service_campaign|maintenance`',
    `claim_created_by` STRING COMMENT 'User identifier of the employee who entered the claim.',
    `claim_number` STRING COMMENT 'External claim identifier assigned by the OEM or dealer for tracking.',
    `claim_status` STRING COMMENT 'Current lifecycle status of the warranty claim.. Valid values are `submitted|approved|rejected|adjusted|paid`',
    `claim_submission_timestamp` TIMESTAMP COMMENT 'Exact timestamp when the warranty claim was submitted to the OEM.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for the claim amounts.. Valid values are `USD|EUR|JPY|CAD|GBP|CNY`',
    `failure_date` DATE COMMENT 'Date the vehicle failure that triggered the warranty claim occurred.',
    `goodwill_flag` BOOLEAN COMMENT 'Indicates whether the claim is processed as goodwill (no reimbursement).',
    `labor_rate_per_hour` DECIMAL(18,2) COMMENT 'Standard labor rate used for calculating labor cost.',
    `notes` STRING COMMENT 'Free‑form text notes entered by the service advisor or adjudicator.',
    `parts_tax_amount` DECIMAL(18,2) COMMENT 'Tax amount applied to the approved parts cost.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the claim record was first created in the system.',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the claim record.',
    `rejection_reason_code` STRING COMMENT 'Code indicating why a claim was rejected, if applicable.',
    `repair_date` DATE COMMENT 'Date the repair work was performed on the vehicle.',
    `repair_order_number` STRING COMMENT 'Reference number of the service repair order linked to the claim.',
    `total_claim_amount` DECIMAL(18,2) COMMENT 'Total monetary value of the claim (labor + parts).',
    `warranty_end_date` DATE COMMENT 'Date when the vehicles warranty coverage expires.',
    `warranty_start_date` DATE COMMENT 'Date when the vehicles warranty coverage began.',
    `warranty_type` STRING COMMENT 'Category of warranty coverage applicable to the claim.. Valid values are `bumper_to_bumper|powertrain|corrosion|roadside_assistance`',
    CONSTRAINT pk_warranty_claim PRIMARY KEY(`warranty_claim_id`)
) COMMENT 'Warranty claim submitted by a dealer or authorized service center to the OEM for reimbursement of warranty-covered repairs. Tracks claim number, VIN, repair order reference, failure date, repair date, claim submission date, claim status (submitted, approved, rejected, adjusted, paid), approved labor hours, approved parts cost, total claim amount, rejection reason code, goodwill flag, campaign/recall linkage, and OEM adjudication outcome. Integrates with SAP SD warranty module and CDK Global DMS.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` (
    `warranty_policy_id` BIGINT COMMENT 'System-generated unique identifier for the warranty policy record.',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Warranty policies in automotive OEMs are authored per model and model year. Policy lookup during claim adjudication, warranty program reporting, and customer-facing warranty documentation all require ',
    `authorized_dealer_required_flag` BOOLEAN COMMENT 'Indicates whether warranty service must be performed at an authorized dealer (true) or can be performed at any qualified service center (false).',
    `claim_limit_per_year` STRING COMMENT 'Maximum number of warranty claims allowed per vehicle per calendar year.',
    `claim_limit_total` STRING COMMENT 'Overall maximum number of warranty claims permitted during the policy term.',
    `country_code` STRING COMMENT 'ISO 3166‑1 alpha‑3 country code indicating the primary country of warranty applicability.',
    `coverage_description` STRING COMMENT 'Free‑text description of what components or systems are covered under the policy.',
    `coverage_type` STRING COMMENT 'Category of coverage provided by the warranty (e.g., basic, powertrain, corrosion, emissions, EV battery, ADAS).. Valid values are `basic|powertrain|corrosion|emissions|ev_battery|adas`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the warranty policy record was first created in the system.',
    `deductible_amount` DECIMAL(18,2) COMMENT 'Fixed monetary amount the customer must pay for each covered repair under the warranty.',
    `duration_months` STRING COMMENT 'Length of the warranty coverage expressed in calendar months.',
    `effective_end_date` TIMESTAMP COMMENT 'Date and time when the warranty coverage expires (typically EOP or calculated from duration).',
    `effective_start_date` TIMESTAMP COMMENT 'Date and time when the warranty coverage becomes effective (typically SOP).',
    `eop_date` DATE COMMENT 'The production end date of the vehicle model to which the warranty applies.',
    `exclusions` STRING COMMENT 'List of components, conditions, or events excluded from coverage.',
    `extension_allowed_flag` BOOLEAN COMMENT 'True if the warranty may be extended beyond the original term under defined conditions.',
    `extension_terms` STRING COMMENT 'Free‑text description of the conditions, cost, and duration for extending the warranty.',
    `inclusions` STRING COMMENT 'List of components, systems, or services explicitly covered.',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the warranty policy record.',
    `market_region` STRING COMMENT 'Geographic market or region where the warranty is offered (e.g., North America, EU).',
    `mileage_limit` STRING COMMENT 'Maximum distance the vehicle may travel while the warranty remains valid, expressed in miles.',
    `model_year` STRING COMMENT 'Model year of the vehicle for which the warranty is defined.',
    `notes` STRING COMMENT 'Additional free‑form notes or remarks about the warranty policy.',
    `policy_number` STRING COMMENT 'External business identifier assigned to the warranty policy, used in contracts and customer communications.',
    `policy_status` STRING COMMENT 'Current lifecycle status of the warranty policy.. Valid values are `active|expired|suspended|terminated`',
    `powertrain_type` STRING COMMENT 'Type of powertrain the warranty applies to (e.g., ICE, HEV, PHEV, EV).',
    `regulatory_body` STRING COMMENT 'Governing authority that mandates or oversees the warranty (e.g., NHTSA, EPA).',
    `regulatory_reference_number` STRING COMMENT 'Identifier of the regulatory filing or certification linked to the warranty.',
    `renewal_allowed_flag` BOOLEAN COMMENT 'Indicates whether the warranty can be renewed after expiration.',
    `renewal_terms` STRING COMMENT 'Details of renewal options, pricing, and eligibility.',
    `service_center_network` STRING COMMENT 'Identifier of the service‑center network eligible for warranty work (e.g., OEM network, third‑party network).',
    `sop_date` DATE COMMENT 'The production start date of the vehicle model to which the warranty applies.',
    `transferable_flag` BOOLEAN COMMENT 'Indicates whether the warranty can be transferred to a subsequent owner (true) or is non‑transferable (false).',
    CONSTRAINT pk_warranty_policy PRIMARY KEY(`warranty_policy_id`)
) COMMENT 'Master definition of warranty coverage terms applicable to a vehicle nameplate, model year, powertrain type, or market. Captures warranty type (basic/bumper-to-bumper, powertrain, corrosion, emissions, EV battery, ADAS), coverage duration in months, coverage distance in miles/km, deductible amount, transferability flag, market/region applicability, SOP and EOP dates, and governing regulatory body (NHTSA, EPA). Serves as the authoritative reference for warranty eligibility determination.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` (
    `vehicle_warranty_id` BIGINT COMMENT 'Unique surrogate key for the vehicle warranty record.',
    `warranty_policy_id` BIGINT COMMENT 'Foreign key linking to aftersales.warranty_policy. Business justification: Vehicle warranty must reference the applicable warranty policy; adds inbound to warranty_policy and outbound from vehicle_warranty.',
    `configuration_id` BIGINT COMMENT 'Foreign key linking to vehicle.configuration. Business justification: Warranty coverage eligibility (duration, mileage limits, inclusions/exclusions) is configuration-specific in automotive OEM operations. Warranty administrators and claim adjudication systems must reso',
    `delivery_appointment_id` BIGINT COMMENT 'Foreign key linking to sales.delivery_appointment. Business justification: Warranty coverage start date is legally defined as the vehicle delivery date recorded in the delivery appointment. This link enables precise warranty period calculation, dispute resolution, and regula',
    `party_id` BIGINT COMMENT 'Foreign key linking to customer.party. Business justification: Warranty administration requires linking each warranty to the owning party for eligibility verification and regulatory compliance reporting.',
    `powertrain_variant_id` BIGINT COMMENT 'Foreign key linking to vehicle.powertrain_variant. Business justification: Powertrain warranties (EV battery 8yr/100k, ICE drivetrain 5yr/60k) are a distinct coverage type tied to specific powertrain variants. Supplier recovery claims, EV battery warranty tracking, and power',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer that sold the vehicle or issued the warranty.',
    `service_center_id` BIGINT COMMENT 'Identifier of the authorized service center handling warranty work.',
    `vehicle_order_id` BIGINT COMMENT 'Foreign key linking to sales.vehicle_order. Business justification: Warranty activation is directly tied to the vehicle order: coverage start date, eligible model year, and incentive-linked warranty extensions all trace to the originating order. Warranty auditors and ',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Connects warranty contracts to the VIN registry to validate coverage periods and claim eligibility.',
    `claims_last_amount` DECIMAL(18,2) COMMENT 'Monetary amount of the most recent warranty claim.',
    `claims_last_date` DATE COMMENT 'Date of the most recent warranty claim.',
    `coverage_area` STRING COMMENT 'Geographic scope of the warranty coverage.. Valid values are `domestic|international`',
    `coverage_description` STRING COMMENT 'Free‑text description of what components and services are covered.',
    `coverage_end_mileage` STRING COMMENT 'Maximum mileage at which warranty coverage ends.',
    `coverage_start_mileage` STRING COMMENT 'Mileage reading at which warranty coverage begins.',
    `cpo_warranty_flag` BOOLEAN COMMENT 'True if the warranty applies to a Certified Pre‑Owned vehicle.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the warranty record was first created in the system.',
    `duration_months` STRING COMMENT 'Total length of the warranty in months.',
    `eligible_for_recall` BOOLEAN COMMENT 'Indicates whether the vehicle is eligible for a safety recall under this warranty.',
    `end_date` DATE COMMENT 'Date the warranty coverage ends.',
    `exclusions` STRING COMMENT 'Text describing items or conditions excluded from coverage.',
    `extended_warranty_flag` BOOLEAN COMMENT 'Indicates whether the warranty has been extended beyond the original terms.',
    `last_transfer_date` DATE COMMENT 'Date of the most recent warranty transfer.',
    `mileage_limit` STRING COMMENT 'Maximum mileage allowed under the warranty.',
    `original_purchase_date` DATE COMMENT 'Date the vehicle was originally purchased by the first owner.',
    `policy_code` STRING COMMENT 'Internal code representing the warranty policy.',
    `program_category` STRING COMMENT 'Broad category of the warranty program.. Valid values are `new_vehicle|used_vehicle|cpo|extended`',
    `program_name` STRING COMMENT 'Name of the warranty program (e.g., New Vehicle, CPO, Extended).',
    `remaining_mileage` STRING COMMENT 'Mileage remaining before the warranty limit is reached.',
    `remaining_months` STRING COMMENT 'Number of months remaining before warranty expiration.',
    `renewal_date` DATE COMMENT 'Date on which the warranty was renewed or is scheduled to renew.',
    `renewal_flag` BOOLEAN COMMENT 'Indicates whether the warranty is eligible for renewal.',
    `service_plan` STRING COMMENT 'Name of the service plan associated with the warranty.',
    `start_date` DATE COMMENT 'Date the warranty coverage became effective (in‑service date).',
    `status_reason` STRING COMMENT 'Reason why the warranty is in its current status.. Valid values are `normal|customer_cancel|manufacturer_recall|non_payment`',
    `transfer_allowed` BOOLEAN COMMENT 'True if the warranty may be transferred to a subsequent owner.',
    `transfer_count` STRING COMMENT 'Number of times the warranty has been transferred to a new owner.',
    `transfer_fee` DECIMAL(18,2) COMMENT 'Fee charged for transferring the warranty to a new owner.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the warranty record.',
    `vehicle_warranty_status` STRING COMMENT 'Current lifecycle status of the warranty.. Valid values are `active|expired|voided|suspended|transferred`',
    `warranty_claims_amount` DECIMAL(18,2) COMMENT 'Cumulative monetary value of all warranty claims.',
    `warranty_claims_count` STRING COMMENT 'Total number of warranty claims filed to date.',
    `warranty_document_url` STRING COMMENT 'Link to the electronic copy of the warranty contract.',
    `warranty_number` STRING COMMENT 'External warranty contract number assigned by the manufacturer or dealer.',
    `warranty_terms_version` STRING COMMENT 'Version identifier of the warranty terms document.',
    `warranty_type` STRING COMMENT 'Category of coverage provided by the warranty.. Valid values are `bumper_to_bumper|powertrain|corrosion|roadside_assistance|extended`',
    CONSTRAINT pk_vehicle_warranty PRIMARY KEY(`vehicle_warranty_id`)
) COMMENT 'VIN-level warranty entitlement record linking a specific vehicle to its applicable warranty policies. Tracks warranty start date (in-service date), expiration date, remaining months, remaining mileage, warranty status (active, expired, voided), extended warranty flag, CPO (Certified Pre-Owned) warranty flag, and any warranty transfer history. This is the SSOT for whether a specific vehicle is under warranty at any point in time.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` (
    `service_campaign_id` BIGINT COMMENT 'Unique surrogate key for the service campaign record.',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: Safety recalls and TSBs are triggered by defects in specific inbound parts. Automotive regulatory requirements (NHTSA, UNECE R94) mandate traceability from a recall campaign to the specific part numbe',
    `model_id` BIGINT COMMENT 'Foreign key linking to vehicle.model. Business justification: Service campaigns (recalls, TSBs, field actions) are scoped to specific vehicle models and model years. NHTSA regulatory reporting, affected-VIN population identification, and campaign cost estimation',
    `plant_id` BIGINT COMMENT '',
    `platform_id` BIGINT COMMENT 'Foreign key linking to vehicle.platform. Business justification: Platform-wide recalls are a documented OEM practice where a structural or systemic defect affects all models sharing a platform. Regulatory filings, affected-VIN population queries, and campaign cost ',
    `production_line_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_line. Business justification: Recalls and service campaigns are frequently triggered by defects traced to a specific production line or production run. Regulatory reporting (NHTSA, UNECE) and root-cause analysis require direct tra',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_supplier. Business justification: Service campaigns (recalls, safety TSBs) are frequently caused by a specific suppliers defective component. Linking to procurement_supplier enables supplier quality root-cause reporting, recall cost ',
    `supplier_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier_contract. Business justification: Recall and TSB campaigns often involve supplier-funded or cost-shared remedies governed by a supplier contract. Linking service_campaign to supplier_contract enables recall cost recovery, supplier acc',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Recall and TSB campaigns are frequently caused by supplier-sourced defective parts. Automotive OEMs must link service campaigns to the responsible supplier for NHTSA/UNECE regulatory reporting, suppli',
    `affected_model_year_end` STRING COMMENT 'Last model year in the range of vehicles covered.',
    `affected_model_year_start` STRING COMMENT 'First model year in the range of vehicles covered.',
    `affected_vin_population` BIGINT COMMENT 'Estimated count of VINs that fall within the campaign scope.',
    `campaign_cost_estimate` DECIMAL(18,2) COMMENT 'Projected total cost to execute the campaign (currency assumed USD).',
    `campaign_notes` STRING COMMENT 'Free‑form notes or comments from campaign managers.',
    `campaign_priority` STRING COMMENT 'Priority level for resource allocation and scheduling.. Valid values are `high|medium|low`',
    `campaign_region` STRING COMMENT 'Primary geographic region(s) affected; uses ISO‑3 country codes.. Valid values are `USA|CAN|MEX|EU|JP|KR`',
    `campaign_status` STRING COMMENT 'Current lifecycle status of the campaign.. Valid values are `open|closed|suspended|completed|cancelled`',
    `campaign_type` STRING COMMENT 'Classification of the campaign: safety recall, emissions recall, customer satisfaction program, or technical service bulletin action.. Valid values are `safety_recall|emissions_recall|customer_satisfaction|technical_service_bulletin`',
    `compliance_status` STRING COMMENT 'Overall compliance status of the campaign with applicable regulations.. Valid values are `compliant|non_compliant|pending`',
    `customer_satisfaction_flag` BOOLEAN COMMENT 'True if the campaign is a voluntary customer‑satisfaction program.',
    `effective_end_date` DATE COMMENT 'Date when the campaign is closed or no longer applicable (nullable).',
    `effective_start_date` DATE COMMENT 'Date when the campaign becomes effective for affected vehicles.',
    `emissions_recall_flag` BOOLEAN COMMENT 'True if the campaign addresses emissions compliance.',
    `estimated_repair_time_minutes` STRING COMMENT 'Average time, in minutes, required to complete the repair per vehicle.',
    `nhtsa_compliance_flag` BOOLEAN COMMENT 'Indicates whether the campaign meets NHTSA requirements.',
    `parts_cost_estimate` DECIMAL(18,2) COMMENT 'Estimated cost of parts required for the campaign.',
    `record_audit_created` TIMESTAMP COMMENT 'Timestamp when the campaign record was first created in the data lake.',
    `record_audit_updated` TIMESTAMP COMMENT 'Timestamp of the most recent update to the campaign record.',
    `regulatory_reporting_date` DATE COMMENT 'Date on which the campaign was reported to the regulator.',
    `regulatory_reporting_status` STRING COMMENT 'Current status of the campaigns regulatory filing with NHTSA/UNECE.. Valid values are `pending|submitted|approved|rejected`',
    `remedy_description` STRING COMMENT 'Detailed description of the repair or corrective action required.',
    `safety_recall_flag` BOOLEAN COMMENT 'True if the campaign is a safety‑related recall.',
    `technical_service_bulletin_flag` BOOLEAN COMMENT 'True if the campaign originates from a TSB.',
    `unece_compliance_flag` BOOLEAN COMMENT 'Indicates whether the campaign meets UNECE regulations.',
    `warranty_impact_flag` BOOLEAN COMMENT 'Indicates whether the campaign affects warranty coverage.',
    CONSTRAINT pk_service_campaign PRIMARY KEY(`service_campaign_id`)
) COMMENT 'Master record for a service campaign (recall or non-safety field action) issued by the OEM. Captures NHTSA recall number, campaign code, campaign type (safety recall, emissions recall, customer satisfaction program, technical service bulletin action), affected nameplate/model year range, affected VIN population count, remedy description, estimated repair time, parts required, campaign open date, campaign close date, regulatory reporting status, and NHTSA/UNECE compliance flags. Integrates with NHTSA recall database and SAP QM.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` (
    `aftersales_service_appointment_id` BIGINT COMMENT 'Unique identifier for the service_appointment data product (auto-inserted pre-linking).',
    `delivery_appointment_id` BIGINT COMMENT 'Foreign key linking to sales.delivery_appointment. Business justification: At vehicle delivery, dealers schedule the first service appointment. Linking aftersales_service_appointment to the originating delivery_appointment enables first-service compliance tracking, customer ',
    `fleet_contract_id` BIGINT COMMENT 'Foreign key linking to sales.fleet_contract. Business justification: Fleet contracts define scheduled maintenance intervals and preferred service centers. Service appointments for fleet vehicles reference the fleet contract to validate eligibility, apply contract labor',
    `loyalty_membership_id` BIGINT COMMENT 'Foreign key linking to customer.loyalty_membership. Business justification: Loyalty redemption at appointment booking: customers redeem points for service discounts at appointment time. Aftersales scheduling systems must reference the loyalty membership to apply tier benefits',
    `organization_account_id` BIGINT COMMENT 'Foreign key linking to customer.customer_fleet_account. Business justification: Fleet service scheduling: fleet account managers book and manage service appointments across their entire fleet. This link enables fleet utilization reporting and ensures appointments are authorized u',
    `party_id` BIGINT COMMENT 'Identifier of the vehicle owner or service requester.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealership or authorized service center hosting the appointment.',
    `service_center_id` BIGINT COMMENT 'Foreign key linking to aftersales.service_center. Business justification: Every service appointment is scheduled at a specific authorized service center. ASA currently has dealership references (aftersales_dealer_dealership_id, aftersales_dealership_id) but critically lacks',
    `technician_id` BIGINT COMMENT 'Foreign key linking to aftersales.technician. Business justification: Service appointments are assigned to specific technicians for scheduling and capacity management. ASA currently has no technician assignment FK, creating a gap in the scheduling data model. This FK en',
    `telemetry_event_id` BIGINT COMMENT 'Foreign key linking to sales.telemetry_event. Business justification: Connected-vehicle telemetry (fault codes, battery alerts, predictive maintenance signals) triggers proactive service appointments. Linking the appointment to the originating telemetry event enables OT',
    `vin_registry_id` BIGINT COMMENT 'Foreign key linking to vehicle.vin_registry. Business justification: Ensures service appointment scheduling aligns with the correct vehicle record for service history and recall compliance.',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Timestamp when the service work was completed.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Timestamp when the vehicle actually entered service.',
    `aftersales_service_appointment_status` STRING COMMENT 'Current lifecycle status of the appointment.. Valid values are `scheduled|confirmed|completed|cancelled|no_show`',
    `appointment_number` STRING COMMENT 'Business identifier assigned to the service appointment, used in dealer and customer communications.',
    `appointment_source` STRING COMMENT 'Origin channel through which the appointment was booked.. Valid values are `online|phone|dms|mobile_app`',
    `bay_number` STRING COMMENT 'Identifier of the service bay where the vehicle will be serviced.',
    `check_in_timestamp` TIMESTAMP COMMENT 'Timestamp when the customer checked in at the service center.',
    `confirmation_status` STRING COMMENT 'Current confirmation state of the appointment.. Valid values are `pending|confirmed|declined`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the appointment record was first created in the system.',
    `currency_code` STRING COMMENT 'Three‑letter ISO currency code for monetary values.. Valid values are `^[A-Z]{3}$`',
    `customer_feedback_score` STRING COMMENT 'Numeric rating (0‑10) provided by the customer after service.',
    `estimated_duration_minutes` STRING COMMENT 'Planned length of the service appointment in minutes.',
    `estimated_gross_amount` DECIMAL(18,2) COMMENT 'Projected total charge before taxes and discounts.',
    `estimated_net_amount` DECIMAL(18,2) COMMENT 'Projected total charge after taxes and discounts.',
    `estimated_tax_amount` DECIMAL(18,2) COMMENT 'Projected tax component of the service charge.',
    `invoice_number` STRING COMMENT 'Identifier of the invoice generated for the service appointment.',
    `is_first_time_customer` BOOLEAN COMMENT 'True if this is the customers first service appointment with the dealer.',
    `is_repeat_service` BOOLEAN COMMENT 'True if the vehicle has previously received the same service type.',
    `labor_time_actual_minutes` STRING COMMENT 'Actual labor minutes recorded for the service.',
    `no_show_flag` BOOLEAN COMMENT 'Indicates whether the customer failed to appear for the scheduled appointment.',
    `parts_actual_amount` DECIMAL(18,2) COMMENT 'Total cost of parts actually used during service.',
    `recall_flag` BOOLEAN COMMENT 'True if the appointment is part of a manufacturer recall campaign.',
    `required_parts_flag` BOOLEAN COMMENT 'Indicates whether specific parts must be ordered before the appointment.',
    `scheduled_timestamp` TIMESTAMP COMMENT 'Planned date and time when the service is to start.',
    `service_category` STRING COMMENT 'Higher‑level grouping of the service (e.g., oil change, brake service, battery replacement).',
    `service_notes` STRING COMMENT 'Free‑form notes entered by the service advisor or technician.',
    `service_priority` STRING COMMENT 'Priority level assigned to the appointment for scheduling.. Valid values are `low|medium|high`',
    `service_type` STRING COMMENT 'Classification of the service (e.g., routine maintenance, warranty repair, recall, pre‑delivery inspection, customer‑pay).. Valid values are `maintenance|warranty_repair|recall|pdi|customer_pay`',
    `total_actual_amount` DECIMAL(18,2) COMMENT 'Final charge for the appointment after labor, parts, taxes, and discounts.',
    `transportation_option` STRING COMMENT 'Customer transportation provision during service.. Valid values are `loaner|shuttle|wait|none`',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the appointment record.',
    `vehicle_mileage` BIGINT COMMENT 'Odometer reading at the time of service appointment.',
    `warranty_flag` BOOLEAN COMMENT 'True if the appointment is covered under a warranty agreement.',
    CONSTRAINT pk_aftersales_service_appointment PRIMARY KEY(`aftersales_service_appointment_id`)
) COMMENT 'Scheduled service appointment record for a vehicle at a dealership or authorized service center. Captures appointment date/time, customer contact, VIN, service type (maintenance, warranty repair, recall, PDI, customer pay), service advisor assigned, estimated duration, transportation option (loaner, shuttle, wait), appointment source (online, phone, DMS, mobile app), confirmation status, check-in time, and no-show flag. Sourced from CDK Global DMS scheduling module.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`aftersales`.`service_part` (
    `service_part_id` BIGINT COMMENT 'Unique surrogate key for the service part record.',
    `inbound_part_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_part. Business justification: REQUIRED: Service Part Origin Traceability needed for regulatory compliance (NHTSA/UNECE) links service parts to their inbound part records.',
    `production_bom_id` BIGINT COMMENT 'Foreign key linking to manufacturing.production_bom. Business justification: Parts engineering cross-references service parts to production BOM versions for supersession tracking, warranty eligibility validation, and supplier cost recovery. A domain expert expects service part',
    `sku_master_id` BIGINT COMMENT 'Foreign key linking to inventory.sku_master. Business justification: Aftersales parts catalog must tie to the inventory SKU master for stock availability checks, replenishment triggering, standard costing, and procurement. Automotive parts managers expect every service',
    `supply_ppap_submission_id` BIGINT COMMENT 'Foreign key linking to supply.supply_ppap_submission. Business justification: PPAP approval is a mandatory quality gate before a service part can be used in warranty repairs in automotive. Linking service_part to its PPAP submission enables quality audits, warranty claim valida',
    `supply_supplier_id` BIGINT COMMENT 'Foreign key linking to supply.supply_supplier. Business justification: Required for parts traceability report linking service inventory to engineering part master specs, essential for compliance and quality analysis.',
    `compliance_certification` STRING COMMENT 'Regulatory certification(s) applicable to the part (e.g., EPA, DOT).',
    `core_charge` DECIMAL(18,2) COMMENT 'Refundable deposit required for parts that are returned for reuse.',
    `country_of_origin` STRING COMMENT 'Three‑letter ISO country code indicating where the part was manufactured.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date‑time when the service part record was first created in the system.',
    `dealer_net_price` DECIMAL(18,2) COMMENT 'Price offered to authorized dealers after standard discounts.',
    `service_part_description` STRING COMMENT 'Full textual description of the part, including fitment notes.',
    `effective_end_date` DATE COMMENT 'Date when the part is retired from the service catalog (null if open‑ended).',
    `effective_start_date` DATE COMMENT 'Date when the part becomes valid for use in service operations.',
    `epa_hazardous_material_code` STRING COMMENT 'EPA classification code for hazardous parts, if applicable.',
    `hazardous_classification` STRING COMMENT 'Regulatory classification code for hazardous parts (e.g., UN number).',
    `hazmat_flag` BOOLEAN COMMENT 'Indicates whether the part is classified as hazardous material.',
    `height_mm` DECIMAL(18,2) COMMENT 'Physical height of the part in millimetres.',
    `inventory_status` STRING COMMENT 'Current inventory availability status of the part.. Valid values are `in_stock|out_of_stock|backordered|discontinued`',
    `last_used_timestamp` TIMESTAMP COMMENT 'Date‑time when the part was last consumed in a service transaction.',
    `length_mm` DECIMAL(18,2) COMMENT 'Physical length of the part in millimetres.',
    `lifecycle_status` STRING COMMENT 'Current lifecycle state of the part within the after‑sales catalog.. Valid values are `active|superseded|discontinued|obsolete`',
    `list_price` DECIMAL(18,2) COMMENT 'Manufacturer suggested retail price before any discounts.',
    `manufacturer_name` STRING COMMENT 'Name of the original equipment manufacturer that produces the part.',
    `part_category` STRING COMMENT 'High‑level classification of the part type.. Valid values are `mechanical|electrical|body|consumable|accessory`',
    `part_name` STRING COMMENT 'Human‑readable name or description of the part.',
    `part_number` STRING COMMENT 'Manufacturer-assigned part number used to uniquely identify the part across the enterprise.',
    `part_revision` STRING COMMENT 'Revision identifier for engineering changes to the part.',
    `superseded_by_part_number` STRING COMMENT 'Part number that replaces this part when it is superseded.',
    `unit_of_measure` STRING COMMENT 'Standard unit used for inventory and transaction quantities (e.g., EA, SET).',
    `updated_timestamp` TIMESTAMP COMMENT 'Date‑time of the most recent update to the service part record.',
    `warranty_eligible_flag` BOOLEAN COMMENT 'Indicates whether the part is covered under the standard warranty program.',
    `warranty_period_months` STRING COMMENT 'Number of months the part is covered by warranty from the date of installation.',
    `weight_kg` DECIMAL(18,2) COMMENT 'Net weight of the part in kilograms.',
    `width_mm` DECIMAL(18,2) COMMENT 'Physical width of the part in millimetres.',
    CONSTRAINT pk_service_part PRIMARY KEY(`service_part_id`)
) COMMENT 'Aftersales service parts master record for parts stocked and consumed in dealer service and repair operations. Captures OEM part number, supersession chain (current and all prior part numbers), part description, part category (mechanical, electrical, body, consumable, fluid, accessory), unit of measure, standard list price, dealer net price, core charge amount, weight, hazmat flag, country of origin, minimum order quantity, and lifecycle status (active, superseded, discontinued, obsolete). Serves as the aftersales-specific view of the parts catalog optimized for service ordering and warranty claims — distinct from the manufacturing BOM parts master in the engineering domain.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` (
    `parts_order_id` BIGINT COMMENT 'Unique identifier for the parts_order data product (auto-inserted pre-linking).',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Aftersales parts orders are fulfilled from specific inventory warehouses. Linking to warehouse enables warehouse-level fulfillment tracking, capacity planning, and parts availability reporting. fulfil',
    `inbound_shipment_id` BIGINT COMMENT 'Foreign key linking to supply.inbound_shipment. Business justification: Aftersales parts receiving process: service centers must reconcile parts orders against inbound shipments to confirm delivery, resolve discrepancies, and manage backorders. Automotive aftersales opera',
    `dealership_id` BIGINT COMMENT 'Unique identifier of the dealer or service center that placed the parts order.',
    `scheduling_agreement_id` BIGINT COMMENT 'Foreign key linking to supply.scheduling_agreement. Business justification: High-volume aftersales parts (filters, brake pads, fluids) are ordered against long-term scheduling agreements rather than spot POs. Automotive aftersales supply planning requires linking parts orders',
    `service_center_id` BIGINT COMMENT 'Foreign key linking to aftersales.service_center. Business justification: Parts orders are placed by specific service centers to replenish their parts inventory from the OEM PDC or regional warehouse. APO currently has primary_aftersales_dealership_id (cross-domain FK to de',
    `actual_delivery_date` DATE COMMENT 'Date the parts were actually received at the dealer.',
    `backorder_flag` BOOLEAN COMMENT 'Indicates whether any line items are on backorder.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the parts order record was first created in the data lake.',
    `currency_code` STRING COMMENT 'Three‑letter ISO 4217 code of the currency used for the order.. Valid values are `^[A-Z]{3}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount granted on the order.',
    `freight_cost` DECIMAL(18,2) COMMENT 'Cost of shipping the parts from the fulfillment location to the dealer.',
    `freight_terms` STRING COMMENT 'Terms governing freight cost responsibility.. Valid values are `prepaid|collect|third_party`',
    `net_total` DECIMAL(18,2) COMMENT 'Final amount payable after applying discounts, taxes, and freight.',
    `order_number` STRING COMMENT 'External business identifier assigned to the parts order by the dealer or OEM system.',
    `order_status` STRING COMMENT 'Current lifecycle state of the parts order (e.g., submitted, confirmed, picked, shipped, received, invoiced, cancelled). [ENUM-REF-CANDIDATE: submitted|confirmed|picked|shipped|received|invoiced|cancelled — promote to reference product]',
    `order_timestamp` TIMESTAMP COMMENT 'Date and time when the parts order was placed by the dealer.',
    `order_type` STRING COMMENT 'Classification of the order based on business need.. Valid values are `stock|emergency|campaign|special`',
    `payment_terms` STRING COMMENT 'Agreed payment condition for the order.. Valid values are `net30|net45|net60|cod`',
    `priority_flag` BOOLEAN COMMENT 'Indicates if the order is marked as high priority.',
    `requested_delivery_date` DATE COMMENT 'Date requested by the dealer for parts to be delivered.',
    `shipping_method` STRING COMMENT 'Mode of transportation used to deliver the parts.. Valid values are `ground|air|sea|rail`',
    `special_instructions` STRING COMMENT 'Free‑text field for any additional handling or delivery instructions.',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax applied to the order.',
    `total_order_value` DECIMAL(18,2) COMMENT 'Gross monetary value of the order before discounts, taxes, and freight.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the parts order record.',
    CONSTRAINT pk_parts_order PRIMARY KEY(`parts_order_id`)
) COMMENT 'Parts order placed by a dealer or service center to the OEM parts distribution center (PDC) or regional warehouse. Captures order number, ordering dealer code, PDC fulfillment location, order date, requested delivery date, order type (stock, emergency, campaign/recall, special), order status (submitted, confirmed, picked, shipped, received, invoiced), total order value, freight terms, and backorder flags. Integrates with SAP MM and dealer DMS parts ordering module.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`aftersales`.`service_center` (
    `service_center_id` BIGINT COMMENT 'Unique surrogate key for the service center record.',
    `dealership_id` BIGINT COMMENT 'Identifier of the dealer group to which the service center belongs.',
    `adas_calibration_authorized` BOOLEAN COMMENT 'Indicates whether the center can calibrate Advanced Driver Assistance Systems.',
    `address_line1` STRING COMMENT 'Primary street address of the service center.',
    `address_line2` STRING COMMENT 'Secondary address information (suite, floor, etc.).',
    `authorization_level` STRING COMMENT 'Combined classification of services the center is authorized to perform.. Valid values are `warranty|recall|collision|ev_certified|adas_calibration|none`',
    `average_service_time_minutes` DECIMAL(18,2) COMMENT 'Mean duration from service order start to completion, expressed in minutes.',
    `city` STRING COMMENT 'City where the service center is located.',
    `service_center_code` STRING COMMENT 'External business code used to reference the service center in dealer and OEM systems.',
    `collision_authorized` BOOLEAN COMMENT 'Indicates whether the center is certified to perform collision repairs.',
    `country` STRING COMMENT 'Three‑letter ISO country code.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the service center record was first created.',
    `dsk_instance_code` BIGINT COMMENT 'Identifier of the CDK Global DMS instance that manages this service center.',
    `effective_end_date` DATE COMMENT 'Date when the service center ceased operations (null if still active).',
    `effective_start_date` DATE COMMENT 'Date when the service center became active in the network.',
    `ev_certified` BOOLEAN COMMENT 'Indicates whether the center is qualified to service electric vehicles.',
    `iatf_certified` BOOLEAN COMMENT 'Indicates compliance with IATF 16949 quality management standards.',
    `is_primary_center` BOOLEAN COMMENT 'Indicates if this center is the primary hub for its dealer group.',
    `iso9001_certified` BOOLEAN COMMENT 'Indicates compliance with ISO 9001 quality management standards.',
    `last_audit_date` DATE COMMENT 'Date when the most recent compliance audit was performed.',
    `latitude` DOUBLE COMMENT 'Latitude coordinate of the service center location.',
    `loaner_fleet_size` STRING COMMENT 'Number of loaner vehicles maintained for customer use.',
    `longitude` DOUBLE COMMENT 'Longitude coordinate of the service center location.',
    `market` STRING COMMENT 'Market segment served (e.g., premium, mass‑market, commercial).',
    `service_center_name` STRING COMMENT 'Human‑readable name of the authorized service center.',
    `network_status` STRING COMMENT 'Current participation status of the center in the OEM service network.. Valid values are `active|suspended|terminated`',
    `notes` STRING COMMENT 'Free‑form field for any supplemental information about the service center.',
    `operating_hours` STRING COMMENT 'Standard weekly operating hours (e.g., Mon‑Fri 08:00‑18:00).',
    `postal_code` STRING COMMENT 'Postal or ZIP code.. Valid values are `^[A-Z0-9]{3,10}$`',
    `recall_authorized` BOOLEAN COMMENT 'Indicates whether the center can execute manufacturer recall campaigns.',
    `region` STRING COMMENT 'Regional grouping (e.g., North America, EMEA) used for reporting.',
    `regulatory_status` STRING COMMENT 'Current status of the centers compliance with automotive regulations.. Valid values are `compliant|non_compliant|under_review`',
    `service_bay_count` STRING COMMENT 'Total count of service bays available for vehicle work.',
    `service_center_type` STRING COMMENT 'Category of the service center based on ownership and relationship to OEM.. Valid values are `dealership|independent|authorized|factory`',
    `service_orders_processed` BIGINT COMMENT 'Cumulative count of service orders completed at the center.',
    `state` STRING COMMENT 'State or province abbreviation.. Valid values are `^[A-Z]{2}$`',
    `technician_headcount` STRING COMMENT 'Number of technicians employed at the service center.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the service center record.',
    `warranty_authorized` BOOLEAN COMMENT 'Indicates whether the center can perform warranty repairs.',
    `warranty_claims_processed` BIGINT COMMENT 'Cumulative count of warranty claims handled by the center.',
    CONSTRAINT pk_service_center PRIMARY KEY(`service_center_id`)
) COMMENT 'Master record for authorized service centers and dealership service departments in the OEM aftersales network. Captures service center code, name, address, dealer group affiliation, authorization level (warranty, recall, certified collision, EV-certified, ADAS-calibration), service bay count, technician headcount, CDK Global DMS instance ID, operating hours, loaner fleet size, and network status (active, suspended, terminated). Distinct from the dealer domains dealer profile — this is the service-operations-specific view.';

CREATE OR REPLACE TABLE `vibe_automotive_v1`.`aftersales`.`technician` (
    `technician_id` BIGINT COMMENT 'System-generated unique identifier for the service technician.',
    `dealership_id` BIGINT COMMENT 'Foreign key linking to dealer.dealership. Business justification: Technicians are employees; linking enables HR skill tracking and labor cost allocation.',
    `service_center_id` BIGINT COMMENT 'Identifier of the service center to which the technician is assigned.',
    `availability_status` STRING COMMENT 'Current availability of the technician for new assignments.. Valid values are `available|unavailable|on_leave|scheduled`',
    `certification_expiry_date` DATE COMMENT 'Date on which the technicians current certification expires.',
    `certification_level` STRING COMMENT 'Level of certification achieved by the technician.. Valid values are `level1|level2|master|expert`',
    `certification_type` STRING COMMENT 'Type of certification held by the technician (e.g., ASE, OEM, EV, ADAS).. Valid values are `ASE|OEM|EV|ADAS|HV|GENERAL`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the technician record was first created.',
    `current_active_ro_count` STRING COMMENT 'Number of repair orders currently assigned to the technician.',
    `email_address` STRING COMMENT 'Primary email address used for communication with the technician.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `flat_rate_efficiency_rating` DECIMAL(18,2) COMMENT 'Efficiency rating expressed as a percentage of flat‑rate labor productivity.',
    `full_name` STRING COMMENT 'Legal full name of the technician.',
    `hire_date` DATE COMMENT 'Date the technician was hired by the organization.',
    `last_training_date` DATE COMMENT 'Date of the most recent training session attended by the technician.',
    `max_concurrent_ro` STRING COMMENT 'Maximum number of repair orders the technician can handle simultaneously.',
    `notes` STRING COMMENT 'Free‑form notes about the technician (e.g., performance comments, special accommodations).',
    `overtime_eligible` BOOLEAN COMMENT 'Indicates whether the technician is eligible for overtime pay.',
    `overtime_rate_multiplier` DECIMAL(18,2) COMMENT 'Multiplier applied to the base labor rate for overtime work.',
    `phone_number` STRING COMMENT 'Primary telephone number for the technician.',
    `shift_type` STRING COMMENT 'Work shift classification for the technician.. Valid values are `day|night|flex|rotating`',
    `skill_level` STRING COMMENT 'Skill tier of the technician based on experience and performance.. Valid values are `junior|mid|senior|lead`',
    `specialization` STRING COMMENT 'Technical area of expertise for the technician.. Valid values are `powertrain|electrical|body|diagnostics|software|hvac`',
    `technician_status` STRING COMMENT 'Current employment status of the technician.. Valid values are `active|inactive|suspended|retired`',
    `training_hours_completed` STRING COMMENT 'Cumulative hours of formal training completed by the technician.',
    `updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the technician record.',
    `years_of_experience` STRING COMMENT 'Total number of years the technician has worked in automotive service.',
    CONSTRAINT pk_technician PRIMARY KEY(`technician_id`)
) COMMENT 'Master record for service technicians employed at authorized service centers. Captures technician ID, name, service center assignment, certification level (ASE, OEM-certified, EV-certified, ADAS-certified), specialization (powertrain, electrical, body, diagnostics), flat-rate efficiency rating, current active RO count, hire date, and certification expiry dates. This is the aftersales-specific technician profile focused on service capacity and certification — distinct from the workforce domains employee record.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_aftersales_service_appointment_id` FOREIGN KEY (`aftersales_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment`(`aftersales_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_service_campaign_id` FOREIGN KEY (`service_campaign_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_campaign`(`service_campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_service_center_id` FOREIGN KEY (`service_center_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_center`(`service_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`technician`(`technician_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_vehicle_warranty_id` FOREIGN KEY (`vehicle_warranty_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`vehicle_warranty`(`vehicle_warranty_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_warranty_claim_id` FOREIGN KEY (`warranty_claim_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`warranty_claim`(`warranty_claim_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_aftersales_repair_order_id` FOREIGN KEY (`aftersales_repair_order_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order`(`aftersales_repair_order_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_aftersales_service_appointment_id` FOREIGN KEY (`aftersales_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment`(`aftersales_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_service_center_id` FOREIGN KEY (`service_center_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_center`(`service_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_service_part_id` FOREIGN KEY (`service_part_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_part`(`service_part_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`technician`(`technician_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_warranty_claim_id` FOREIGN KEY (`warranty_claim_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`warranty_claim`(`warranty_claim_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_service_campaign_id` FOREIGN KEY (`service_campaign_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_campaign`(`service_campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_service_center_id` FOREIGN KEY (`service_center_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_center`(`service_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_vehicle_warranty_id` FOREIGN KEY (`vehicle_warranty_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`vehicle_warranty`(`vehicle_warranty_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_warranty_policy_id` FOREIGN KEY (`warranty_policy_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`warranty_policy`(`warranty_policy_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ADD CONSTRAINT `fk_aftersales_vehicle_warranty_warranty_policy_id` FOREIGN KEY (`warranty_policy_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`warranty_policy`(`warranty_policy_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ADD CONSTRAINT `fk_aftersales_vehicle_warranty_service_center_id` FOREIGN KEY (`service_center_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_center`(`service_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_service_center_id` FOREIGN KEY (`service_center_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_center`(`service_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`technician`(`technician_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ADD CONSTRAINT `fk_aftersales_parts_order_service_center_id` FOREIGN KEY (`service_center_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_center`(`service_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ADD CONSTRAINT `fk_aftersales_technician_service_center_id` FOREIGN KEY (`service_center_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_center`(`service_center_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_automotive_v1`.`aftersales` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_automotive_v1`.`aftersales` SET TAGS ('dbx_domain' = 'aftersales');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` SET TAGS ('dbx_subdomain' = 'service_operations');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `aftersales_repair_order_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for repair_order');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `aftersales_service_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Service Appointment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Membership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `organization_account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Fleet Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Service Advisor ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `service_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Service Campaign ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `service_center_id` SET TAGS ('dbx_business_glossary_term' = 'Service Center ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `technician_id` SET TAGS ('dbx_business_glossary_term' = 'Technician ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `trade_in_id` SET TAGS ('dbx_business_glossary_term' = 'Trade In Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `telemetry_event_id` SET TAGS ('dbx_business_glossary_term' = 'Triggering Telemetry Event Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `vehicle_warranty_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Warranty Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Warranty Claim Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `actual_completion_time` SET TAGS ('dbx_business_glossary_term' = 'Actual Completion Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `aftersales_repair_order_status` SET TAGS ('dbx_business_glossary_term' = 'Repair Order Status');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `aftersales_repair_order_status` SET TAGS ('dbx_value_regex' = 'open|in_progress|quality_check|closed|invoiced|cancelled');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `appointment_arrival_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Appointment Arrival Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `appointment_departure_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Appointment Departure Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `appointment_scheduled_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Appointment Scheduled Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `close_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Repair Order Close Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|CAD|EUR|GBP|JPY');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `customer_feedback_score` SET TAGS ('dbx_business_glossary_term' = 'Customer Feedback Score');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `customer_signature_flag` SET TAGS ('dbx_business_glossary_term' = 'Customer Signature Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `customer_signature_flag` SET TAGS ('dbx_pii_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `diagnostic_code` SET TAGS ('dbx_business_glossary_term' = 'Diagnostic Trouble Code (DTC)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `diagnostic_code` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount (USD)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `is_estimate` SET TAGS ('dbx_business_glossary_term' = 'Estimate Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `labor_rate_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Labor Rate per Hour (USD)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `labor_total_cost` SET TAGS ('dbx_business_glossary_term' = 'Labor Total Cost (USD)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `labor_total_hours` SET TAGS ('dbx_business_glossary_term' = 'Labor Total Hours');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `mileage_at_service` SET TAGS ('dbx_business_glossary_term' = 'Mileage at Service (MILEAGE)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Amount (USD)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `open_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Repair Order Open Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `parts_total_cost` SET TAGS ('dbx_business_glossary_term' = 'Parts Total Cost (USD)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `payment_method` SET TAGS ('dbx_business_glossary_term' = 'Payment Method');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `payment_method` SET TAGS ('dbx_value_regex' = 'cash|credit_card|debit_card|bank_transfer|mobile_payment|check');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `payment_status` SET TAGS ('dbx_business_glossary_term' = 'Payment Status');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `payment_status` SET TAGS ('dbx_value_regex' = 'pending|paid|failed|refunded');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `promised_completion_time` SET TAGS ('dbx_business_glossary_term' = 'Promised Completion Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `ro_number` SET TAGS ('dbx_business_glossary_term' = 'Repair Order Number (RO)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `service_center_region` SET TAGS ('dbx_business_glossary_term' = 'Service Center Region');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `service_center_region` SET TAGS ('dbx_value_regex' = 'North|South|East|West|Central');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `service_notes` SET TAGS ('dbx_business_glossary_term' = 'Service Notes');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `service_priority` SET TAGS ('dbx_business_glossary_term' = 'Service Priority');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `service_priority` SET TAGS ('dbx_value_regex' = 'high|medium|low|critical');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'maintenance|repair|recall|campaign|diagnostic');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount (USD)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `technician_notes` SET TAGS ('dbx_business_glossary_term' = 'Technician Notes');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `total_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Amount (USD)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `warranty_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `warranty_type` SET TAGS ('dbx_business_glossary_term' = 'Warranty Type');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ALTER COLUMN `warranty_type` SET TAGS ('dbx_value_regex' = 'manufacturer|extended|service_contract');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` SET TAGS ('dbx_subdomain' = 'service_operations');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `repair_order_line_id` SET TAGS ('dbx_business_glossary_term' = 'Repair Order Line ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `aftersales_repair_order_id` SET TAGS ('dbx_business_glossary_term' = 'Repair Order ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `aftersales_service_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Appointment ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `service_center_id` SET TAGS ('dbx_business_glossary_term' = 'Service Center ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `service_part_id` SET TAGS ('dbx_business_glossary_term' = 'Service Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `storage_location_id` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `technician_id` SET TAGS ('dbx_business_glossary_term' = 'Technician ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `actual_technician_hours` SET TAGS ('dbx_business_glossary_term' = 'Actual Technician Hours');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `cause_complaint` SET TAGS ('dbx_business_glossary_term' = 'Cause / Complaint Description');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `correction` SET TAGS ('dbx_business_glossary_term' = 'Correction Description');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|CAD|EUR|GBP|JPY|CNY');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `labor_category` SET TAGS ('dbx_business_glossary_term' = 'Labor Category');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `labor_category` SET TAGS ('dbx_value_regex' = 'mechanical|electrical|diagnostic|body|software');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `labor_rate` SET TAGS ('dbx_business_glossary_term' = 'Labor Rate (Currency per Hour)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `labor_skill_level` SET TAGS ('dbx_business_glossary_term' = 'Labor Skill Level');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `labor_skill_level` SET TAGS ('dbx_value_regex' = 'apprentice|journeyman|master|specialist');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `labor_time_standard` SET TAGS ('dbx_business_glossary_term' = 'Labor Time Standard (Hours)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `line_sequence` SET TAGS ('dbx_business_glossary_term' = 'Line Sequence Number');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `line_status` SET TAGS ('dbx_business_glossary_term' = 'Line Status');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `line_status` SET TAGS ('dbx_value_regex' = 'open|in_progress|completed|closed|canceled');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `line_total` SET TAGS ('dbx_business_glossary_term' = 'Line Total Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Line Notes');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `operation_code` SET TAGS ('dbx_business_glossary_term' = 'Labor Operation Code');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `overtime_flag` SET TAGS ('dbx_business_glossary_term' = 'Overtime Applied Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `overtime_multiplier` SET TAGS ('dbx_business_glossary_term' = 'Overtime Multiplier');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `part_price` SET TAGS ('dbx_business_glossary_term' = 'Part Unit Price');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `part_quantity` SET TAGS ('dbx_business_glossary_term' = 'Part Quantity');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `parts_used_flag` SET TAGS ('dbx_business_glossary_term' = 'Parts Used Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `service_date` SET TAGS ('dbx_business_glossary_term' = 'Service Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `sublet_cost` SET TAGS ('dbx_business_glossary_term' = 'Sublet Cost Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `sublet_flag` SET TAGS ('dbx_business_glossary_term' = 'Sublet Service Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Identification Number (VIN)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_value_regex' = '^[A-HJ-NPR-Z0-9]{17}$');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `vehicle_vin` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ALTER COLUMN `warranty_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Covered Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` SET TAGS ('dbx_subdomain' = 'warranty_management');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for warranty_claim');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `plant_id` SET TAGS ('dbx_business_glossary_term' = 'Claim Created By Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `plant_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `plant_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Procurement Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `root_cause_analysis_id` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Analysis Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `service_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Campaign ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `service_center_id` SET TAGS ('dbx_business_glossary_term' = 'Service Center ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `vehicle_ownership_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Ownership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `vehicle_warranty_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Warranty Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `warranty_aftersales_dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `warranty_aftersales_party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `warranty_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `adjudication_outcome` SET TAGS ('dbx_business_glossary_term' = 'Adjudication Outcome');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `adjudication_outcome` SET TAGS ('dbx_value_regex' = 'approved|rejected|partial|pending');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `adjusted_amount` SET TAGS ('dbx_business_glossary_term' = 'Adjusted Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `approved_labor_cost` SET TAGS ('dbx_business_glossary_term' = 'Approved Labor Cost');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `approved_labor_hours` SET TAGS ('dbx_business_glossary_term' = 'Approved Labor Hours');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `approved_parts_cost` SET TAGS ('dbx_business_glossary_term' = 'Approved Parts Cost');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `claim_adjusted_flag` SET TAGS ('dbx_business_glossary_term' = 'Claim Adjusted Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `claim_category` SET TAGS ('dbx_business_glossary_term' = 'Claim Category');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `claim_category` SET TAGS ('dbx_value_regex' = 'repair|recall|service_campaign|maintenance');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `claim_created_by` SET TAGS ('dbx_business_glossary_term' = 'Claim Created By');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `claim_number` SET TAGS ('dbx_business_glossary_term' = 'Claim Number');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `claim_status` SET TAGS ('dbx_business_glossary_term' = 'Claim Status');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `claim_status` SET TAGS ('dbx_value_regex' = 'submitted|approved|rejected|adjusted|paid');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `claim_submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Claim Submission Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = 'USD|EUR|JPY|CAD|GBP|CNY');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `failure_date` SET TAGS ('dbx_business_glossary_term' = 'Failure Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `goodwill_flag` SET TAGS ('dbx_business_glossary_term' = 'Goodwill Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `labor_rate_per_hour` SET TAGS ('dbx_business_glossary_term' = 'Labor Rate Per Hour');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Claim Notes');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `parts_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Parts Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `rejection_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason Code');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `repair_date` SET TAGS ('dbx_business_glossary_term' = 'Repair Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `repair_order_number` SET TAGS ('dbx_business_glossary_term' = 'Repair Order Number');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `total_claim_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Claim Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `warranty_end_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty End Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `warranty_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Start Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `warranty_type` SET TAGS ('dbx_business_glossary_term' = 'Warranty Type');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ALTER COLUMN `warranty_type` SET TAGS ('dbx_value_regex' = 'bumper_to_bumper|powertrain|corrosion|roadside_assistance');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` SET TAGS ('dbx_subdomain' = 'warranty_management');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `warranty_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `authorized_dealer_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Authorized Dealer Required Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `claim_limit_per_year` SET TAGS ('dbx_business_glossary_term' = 'Annual Warranty Claim Limit');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `claim_limit_total` SET TAGS ('dbx_business_glossary_term' = 'Total Warranty Claim Limit');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `coverage_description` SET TAGS ('dbx_business_glossary_term' = 'Warranty Coverage Description');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `coverage_type` SET TAGS ('dbx_business_glossary_term' = 'Warranty Coverage Type');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `coverage_type` SET TAGS ('dbx_value_regex' = 'basic|powertrain|corrosion|emissions|ev_battery|adas');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `deductible_amount` SET TAGS ('dbx_business_glossary_term' = 'Warranty Deductible Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `duration_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Duration (Months)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `eop_date` SET TAGS ('dbx_business_glossary_term' = 'End of Production Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `exclusions` SET TAGS ('dbx_business_glossary_term' = 'Warranty Exclusions');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `extension_allowed_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Extension Allowed Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `extension_terms` SET TAGS ('dbx_business_glossary_term' = 'Warranty Extension Terms');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `inclusions` SET TAGS ('dbx_business_glossary_term' = 'Warranty Inclusions');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `market_region` SET TAGS ('dbx_business_glossary_term' = 'Market Region');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `mileage_limit` SET TAGS ('dbx_business_glossary_term' = 'Warranty Mileage Limit');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `model_year` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Model Year');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Notes');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `policy_number` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Number');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `policy_status` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Status');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `policy_status` SET TAGS ('dbx_value_regex' = 'active|expired|suspended|terminated');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `powertrain_type` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Type');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `regulatory_body` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Body');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `regulatory_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reference Number');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `renewal_allowed_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Renewal Allowed Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `renewal_terms` SET TAGS ('dbx_business_glossary_term' = 'Warranty Renewal Terms');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `service_center_network` SET TAGS ('dbx_business_glossary_term' = 'Service Center Network');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `sop_date` SET TAGS ('dbx_business_glossary_term' = 'Start of Production Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ALTER COLUMN `transferable_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Transferability Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` SET TAGS ('dbx_subdomain' = 'warranty_management');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `vehicle_warranty_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Warranty ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `warranty_policy_id` SET TAGS ('dbx_business_glossary_term' = 'Aftersales Warranty Policy Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `configuration_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `delivery_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Appointment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Party Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `powertrain_variant_id` SET TAGS ('dbx_business_glossary_term' = 'Powertrain Variant Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `service_center_id` SET TAGS ('dbx_business_glossary_term' = 'Service Center Identifier');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `vehicle_order_id` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Order Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `claims_last_amount` SET TAGS ('dbx_business_glossary_term' = 'Last Warranty Claim Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `claims_last_date` SET TAGS ('dbx_business_glossary_term' = 'Last Warranty Claim Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `coverage_area` SET TAGS ('dbx_business_glossary_term' = 'Warranty Coverage Area');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `coverage_area` SET TAGS ('dbx_value_regex' = 'domestic|international');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `coverage_description` SET TAGS ('dbx_business_glossary_term' = 'Coverage Description');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `coverage_end_mileage` SET TAGS ('dbx_business_glossary_term' = 'Warranty Coverage End Mileage');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `coverage_start_mileage` SET TAGS ('dbx_business_glossary_term' = 'Warranty Coverage Start Mileage');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `cpo_warranty_flag` SET TAGS ('dbx_business_glossary_term' = 'Certified Pre‑Owned Warranty Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `duration_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Duration (Months)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `eligible_for_recall` SET TAGS ('dbx_business_glossary_term' = 'Eligibility for Recall');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiration Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `exclusions` SET TAGS ('dbx_business_glossary_term' = 'Warranty Exclusions');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `extended_warranty_flag` SET TAGS ('dbx_business_glossary_term' = 'Extended Warranty Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `last_transfer_date` SET TAGS ('dbx_business_glossary_term' = 'Last Warranty Transfer Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `mileage_limit` SET TAGS ('dbx_business_glossary_term' = 'Warranty Mileage Limit');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `original_purchase_date` SET TAGS ('dbx_business_glossary_term' = 'Original Purchase Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `policy_code` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Code');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `program_category` SET TAGS ('dbx_business_glossary_term' = 'Warranty Program Category');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `program_category` SET TAGS ('dbx_value_regex' = 'new_vehicle|used_vehicle|cpo|extended');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `program_name` SET TAGS ('dbx_business_glossary_term' = 'Warranty Program Name');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `remaining_mileage` SET TAGS ('dbx_business_glossary_term' = 'Remaining Warranty Mileage');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `remaining_months` SET TAGS ('dbx_business_glossary_term' = 'Remaining Warranty Months');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `renewal_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Renewal Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Renewal Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `service_plan` SET TAGS ('dbx_business_glossary_term' = 'Warranty Service Plan');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `status_reason` SET TAGS ('dbx_business_glossary_term' = 'Warranty Status Reason');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `status_reason` SET TAGS ('dbx_value_regex' = 'normal|customer_cancel|manufacturer_recall|non_payment');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `transfer_allowed` SET TAGS ('dbx_business_glossary_term' = 'Warranty Transfer Allowed');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `transfer_count` SET TAGS ('dbx_business_glossary_term' = 'Warranty Transfer Count');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `transfer_fee` SET TAGS ('dbx_business_glossary_term' = 'Warranty Transfer Fee');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `vehicle_warranty_status` SET TAGS ('dbx_business_glossary_term' = 'Warranty Status');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `vehicle_warranty_status` SET TAGS ('dbx_value_regex' = 'active|expired|voided|suspended|transferred');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `warranty_claims_amount` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claims Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `warranty_claims_count` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claims Count');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `warranty_document_url` SET TAGS ('dbx_business_glossary_term' = 'Warranty Document URL');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `warranty_number` SET TAGS ('dbx_business_glossary_term' = 'Warranty Policy Number');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `warranty_terms_version` SET TAGS ('dbx_business_glossary_term' = 'Warranty Terms Version');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `warranty_type` SET TAGS ('dbx_business_glossary_term' = 'Warranty Type');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ALTER COLUMN `warranty_type` SET TAGS ('dbx_value_regex' = 'bumper_to_bumper|powertrain|corrosion|roadside_assistance|extended');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` SET TAGS ('dbx_subdomain' = 'warranty_management');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `service_campaign_id` SET TAGS ('dbx_business_glossary_term' = 'Service Campaign ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `model_id` SET TAGS ('dbx_business_glossary_term' = 'Model Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `platform_id` SET TAGS ('dbx_business_glossary_term' = 'Platform Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `production_line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Procurement Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `supplier_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Supplier Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `affected_model_year_end` SET TAGS ('dbx_business_glossary_term' = 'Affected Model Year End');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `affected_model_year_start` SET TAGS ('dbx_business_glossary_term' = 'Affected Model Year Start');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `affected_vin_population` SET TAGS ('dbx_business_glossary_term' = 'Affected VIN Population');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `campaign_cost_estimate` SET TAGS ('dbx_business_glossary_term' = 'Campaign Cost Estimate');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `campaign_notes` SET TAGS ('dbx_business_glossary_term' = 'Campaign Notes');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `campaign_priority` SET TAGS ('dbx_business_glossary_term' = 'Campaign Priority');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `campaign_priority` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `campaign_region` SET TAGS ('dbx_business_glossary_term' = 'Campaign Region');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `campaign_region` SET TAGS ('dbx_value_regex' = 'USA|CAN|MEX|EU|JP|KR');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `campaign_status` SET TAGS ('dbx_business_glossary_term' = 'Campaign Status');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `campaign_status` SET TAGS ('dbx_value_regex' = 'open|closed|suspended|completed|cancelled');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `campaign_type` SET TAGS ('dbx_business_glossary_term' = 'Campaign Type');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `campaign_type` SET TAGS ('dbx_value_regex' = 'safety_recall|emissions_recall|customer_satisfaction|technical_service_bulletin');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|pending');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `customer_satisfaction_flag` SET TAGS ('dbx_business_glossary_term' = 'Customer Satisfaction Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `emissions_recall_flag` SET TAGS ('dbx_business_glossary_term' = 'Emissions Recall Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `estimated_repair_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Estimated Repair Time (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `nhtsa_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'NHTSA Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `parts_cost_estimate` SET TAGS ('dbx_business_glossary_term' = 'Parts Cost Estimate');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `record_audit_created` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Created');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `record_audit_updated` SET TAGS ('dbx_business_glossary_term' = 'Record Audit Updated');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `regulatory_reporting_date` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reporting Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `regulatory_reporting_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reporting Status');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `regulatory_reporting_status` SET TAGS ('dbx_value_regex' = 'pending|submitted|approved|rejected');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `remedy_description` SET TAGS ('dbx_business_glossary_term' = 'Remedy Description');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `safety_recall_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Recall Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `technical_service_bulletin_flag` SET TAGS ('dbx_business_glossary_term' = 'Technical Service Bulletin Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `unece_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'UNECE Compliance Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ALTER COLUMN `warranty_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Impact Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` SET TAGS ('dbx_subdomain' = 'service_operations');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `aftersales_service_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for service_appointment');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `delivery_appointment_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Appointment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `fleet_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Fleet Contract Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `loyalty_membership_id` SET TAGS ('dbx_business_glossary_term' = 'Loyalty Membership Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `organization_account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Fleet Account Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `party_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `service_center_id` SET TAGS ('dbx_business_glossary_term' = 'Service Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `technician_id` SET TAGS ('dbx_business_glossary_term' = 'Technician Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `telemetry_event_id` SET TAGS ('dbx_business_glossary_term' = 'Triggering Telemetry Event Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `vin_registry_id` SET TAGS ('dbx_business_glossary_term' = 'Vin Registry Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Service End Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Service Start Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `aftersales_service_appointment_status` SET TAGS ('dbx_business_glossary_term' = 'Appointment Status');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `aftersales_service_appointment_status` SET TAGS ('dbx_value_regex' = 'scheduled|confirmed|completed|cancelled|no_show');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `appointment_number` SET TAGS ('dbx_business_glossary_term' = 'Appointment Number (APPT_NO)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `appointment_source` SET TAGS ('dbx_business_glossary_term' = 'Appointment Source');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `appointment_source` SET TAGS ('dbx_value_regex' = 'online|phone|dms|mobile_app');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `bay_number` SET TAGS ('dbx_business_glossary_term' = 'Service Bay Number');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `check_in_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Check‑In Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `confirmation_status` SET TAGS ('dbx_business_glossary_term' = 'Confirmation Status');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `confirmation_status` SET TAGS ('dbx_value_regex' = 'pending|confirmed|declined');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (ISO 4217)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `customer_feedback_score` SET TAGS ('dbx_business_glossary_term' = 'Customer Feedback Score');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `estimated_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Estimated Duration (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `estimated_gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Estimated Gross Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `estimated_net_amount` SET TAGS ('dbx_business_glossary_term' = 'Estimated Net Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `estimated_tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Estimated Tax Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `invoice_number` SET TAGS ('dbx_business_glossary_term' = 'Invoice Number');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `is_first_time_customer` SET TAGS ('dbx_business_glossary_term' = 'First‑Time Customer Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `is_repeat_service` SET TAGS ('dbx_business_glossary_term' = 'Repeat Service Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `labor_time_actual_minutes` SET TAGS ('dbx_business_glossary_term' = 'Actual Labor Time (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `no_show_flag` SET TAGS ('dbx_business_glossary_term' = 'No‑Show Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `parts_actual_amount` SET TAGS ('dbx_business_glossary_term' = 'Actual Parts Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `recall_flag` SET TAGS ('dbx_business_glossary_term' = 'Recall Service Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `required_parts_flag` SET TAGS ('dbx_business_glossary_term' = 'Required Parts Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `scheduled_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Appointment Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `service_category` SET TAGS ('dbx_business_glossary_term' = 'Service Category');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `service_notes` SET TAGS ('dbx_business_glossary_term' = 'Service Notes');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `service_priority` SET TAGS ('dbx_business_glossary_term' = 'Service Priority');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `service_priority` SET TAGS ('dbx_value_regex' = 'low|medium|high');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'maintenance|warranty_repair|recall|pdi|customer_pay');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `total_actual_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Actual Amount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `transportation_option` SET TAGS ('dbx_business_glossary_term' = 'Transportation Option');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `transportation_option` SET TAGS ('dbx_value_regex' = 'loaner|shuttle|wait|none');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `vehicle_mileage` SET TAGS ('dbx_business_glossary_term' = 'Vehicle Mileage');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ALTER COLUMN `warranty_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Service Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` SET TAGS ('dbx_subdomain' = 'parts_distribution');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `service_part_id` SET TAGS ('dbx_business_glossary_term' = 'Service Part ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `inbound_part_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Part Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `production_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Production Bom Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `sku_master_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `supply_ppap_submission_id` SET TAGS ('dbx_business_glossary_term' = 'Supply Ppap Submission Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `supply_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Part Master Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `compliance_certification` SET TAGS ('dbx_business_glossary_term' = 'Compliance Certification (CCERT)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `core_charge` SET TAGS ('dbx_business_glossary_term' = 'Core Charge (CC)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin (COO)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp (CT)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `dealer_net_price` SET TAGS ('dbx_business_glossary_term' = 'Dealer Net Price (DNP)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `service_part_description` SET TAGS ('dbx_business_glossary_term' = 'Part Description (DESC)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date (EED)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date (ESD)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `epa_hazardous_material_code` SET TAGS ('dbx_business_glossary_term' = 'EPA Hazardous Material Code (EPA_HAZ)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `hazardous_classification` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Classification (HC)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `hazmat_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag (HM)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `height_mm` SET TAGS ('dbx_business_glossary_term' = 'Height (MM)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `inventory_status` SET TAGS ('dbx_business_glossary_term' = 'Inventory Status (INV_ST)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `inventory_status` SET TAGS ('dbx_value_regex' = 'in_stock|out_of_stock|backordered|discontinued');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `last_used_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Used Timestamp (LUT)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `length_mm` SET TAGS ('dbx_business_glossary_term' = 'Length (MM)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_business_glossary_term' = 'Lifecycle Status (LS)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `lifecycle_status` SET TAGS ('dbx_value_regex' = 'active|superseded|discontinued|obsolete');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `list_price` SET TAGS ('dbx_business_glossary_term' = 'Standard List Price (SLP)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `manufacturer_name` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Name (MFR)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `part_category` SET TAGS ('dbx_business_glossary_term' = 'Part Category (CAT)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `part_category` SET TAGS ('dbx_value_regex' = 'mechanical|electrical|body|consumable|accessory');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `part_name` SET TAGS ('dbx_business_glossary_term' = 'Part Name (DES)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `part_number` SET TAGS ('dbx_business_glossary_term' = 'Part Number (OEM)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `part_revision` SET TAGS ('dbx_business_glossary_term' = 'Part Revision (REV)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `superseded_by_part_number` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Part Number (SUP)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Updated Timestamp (UT)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `warranty_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Warranty Eligible Flag (WEF)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `warranty_period_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Period (Months)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight (KG)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ALTER COLUMN `width_mm` SET TAGS ('dbx_business_glossary_term' = 'Width (MM)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` SET TAGS ('dbx_subdomain' = 'parts_distribution');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `parts_order_id` SET TAGS ('dbx_business_glossary_term' = 'Primary Key for parts_order');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Warehouse Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `inbound_shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Shipment Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Identifier (DEALER_ID)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `scheduling_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Agreement Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `service_center_id` SET TAGS ('dbx_business_glossary_term' = 'Service Center Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date (ACT_DELIV_DT)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `backorder_flag` SET TAGS ('dbx_business_glossary_term' = 'Backorder Flag (BACKORDER_FLG)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp (REC_CRE_TS)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code (CURR_CD)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount (DISC_AMT)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `freight_cost` SET TAGS ('dbx_business_glossary_term' = 'Freight Cost (FRGT_COST)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `freight_terms` SET TAGS ('dbx_business_glossary_term' = 'Freight Terms (FRGT_TRMS)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `freight_terms` SET TAGS ('dbx_value_regex' = 'prepaid|collect|third_party');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `net_total` SET TAGS ('dbx_business_glossary_term' = 'Net Order Total (NET_ORD_TOT)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `order_number` SET TAGS ('dbx_business_glossary_term' = 'Order Number (ORD_NUM)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `order_status` SET TAGS ('dbx_business_glossary_term' = 'Order Status (ORD_STS)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `order_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Order Timestamp (ORD_TS)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `order_type` SET TAGS ('dbx_business_glossary_term' = 'Order Type (ORD_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `order_type` SET TAGS ('dbx_value_regex' = 'stock|emergency|campaign|special');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms (PAY_TERM)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'net30|net45|net60|cod');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `priority_flag` SET TAGS ('dbx_business_glossary_term' = 'Priority Flag (PRIORITY_FLG)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date (REQ_DELIV_DT)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `shipping_method` SET TAGS ('dbx_business_glossary_term' = 'Shipping Method (SHIP_MTHD)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `shipping_method` SET TAGS ('dbx_value_regex' = 'ground|air|sea|rail');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `special_instructions` SET TAGS ('dbx_business_glossary_term' = 'Special Instructions (SPEC_INSTR)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount (TAX_AMT)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `total_order_value` SET TAGS ('dbx_business_glossary_term' = 'Total Order Value (TOT_ORD_VAL)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp (REC_UPD_TS)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` SET TAGS ('dbx_subdomain' = 'service_operations');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `service_center_id` SET TAGS ('dbx_business_glossary_term' = 'Service Center Identifier');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Dealer Group Identifier');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `adas_calibration_authorized` SET TAGS ('dbx_business_glossary_term' = 'ADAS Calibration Service Authorization Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `address_line1` SET TAGS ('dbx_business_glossary_term' = 'Address Line 1');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `address_line2` SET TAGS ('dbx_business_glossary_term' = 'Address Line 2');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `authorization_level` SET TAGS ('dbx_business_glossary_term' = 'Service Authorization Level');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `authorization_level` SET TAGS ('dbx_value_regex' = 'warranty|recall|collision|ev_certified|adas_calibration|none');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `average_service_time_minutes` SET TAGS ('dbx_business_glossary_term' = 'Average Service Time per Order (Minutes)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `city` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `city` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `service_center_code` SET TAGS ('dbx_business_glossary_term' = 'Service Center Code');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `collision_authorized` SET TAGS ('dbx_business_glossary_term' = 'Certified Collision Service Authorization Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `country` SET TAGS ('dbx_business_glossary_term' = 'Country Code (ISO 3166‑1 alpha‑3)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `country` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `country` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `dsk_instance_code` SET TAGS ('dbx_business_glossary_term' = 'CDK Global DMS Instance Identifier');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Effective End Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Start Date');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `ev_certified` SET TAGS ('dbx_business_glossary_term' = 'Electric Vehicle Service Certification Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `iatf_certified` SET TAGS ('dbx_business_glossary_term' = 'IATF 16949 Certification Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `is_primary_center` SET TAGS ('dbx_business_glossary_term' = 'Primary Service Center Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `iso9001_certified` SET TAGS ('dbx_business_glossary_term' = 'ISO 9001 Certification Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Date of Last Regulatory Audit');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Geographic Latitude');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `loaner_fleet_size` SET TAGS ('dbx_business_glossary_term' = 'Loaner Vehicle Fleet Size');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Geographic Longitude');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `market` SET TAGS ('dbx_business_glossary_term' = 'Service Center Market Segment');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `service_center_name` SET TAGS ('dbx_business_glossary_term' = 'Service Center Name');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `network_status` SET TAGS ('dbx_business_glossary_term' = 'Service Center Network Status');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `network_status` SET TAGS ('dbx_value_regex' = 'active|suspended|terminated');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Additional Notes');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `operating_hours` SET TAGS ('dbx_business_glossary_term' = 'Operating Hours Schedule');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `postal_code` SET TAGS ('dbx_business_glossary_term' = 'Postal Code');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `postal_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{3,10}$');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `postal_code` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `recall_authorized` SET TAGS ('dbx_business_glossary_term' = 'Recall Service Authorization Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Service Center Geographic Region');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `regulatory_status` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Status');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `regulatory_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|under_review');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `service_bay_count` SET TAGS ('dbx_business_glossary_term' = 'Number of Service Bays');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `service_center_type` SET TAGS ('dbx_business_glossary_term' = 'Service Center Type');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `service_center_type` SET TAGS ('dbx_value_regex' = 'dealership|independent|authorized|factory');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `service_orders_processed` SET TAGS ('dbx_business_glossary_term' = 'Total Service Orders Processed');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `state` SET TAGS ('dbx_business_glossary_term' = 'State/Province');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `state` SET TAGS ('dbx_value_regex' = '^[A-Z]{2}$');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `state` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `state` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `technician_headcount` SET TAGS ('dbx_business_glossary_term' = 'Technician Headcount');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `warranty_authorized` SET TAGS ('dbx_business_glossary_term' = 'Warranty Service Authorization Flag');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ALTER COLUMN `warranty_claims_processed` SET TAGS ('dbx_business_glossary_term' = 'Total Warranty Claims Processed');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` SET TAGS ('dbx_subdomain' = 'service_operations');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `technician_id` SET TAGS ('dbx_business_glossary_term' = 'Technician ID');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `dealership_id` SET TAGS ('dbx_business_glossary_term' = 'Employee Id (Foreign Key)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `dealership_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `dealership_id` SET TAGS ('dbx_pii' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `service_center_id` SET TAGS ('dbx_business_glossary_term' = 'Service Center ID (SC_ID)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `availability_status` SET TAGS ('dbx_business_glossary_term' = 'Availability Status (AVAIL_STATUS)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `availability_status` SET TAGS ('dbx_value_regex' = 'available|unavailable|on_leave|scheduled');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `certification_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Expiry Date (CERT_EXPIRY)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `certification_level` SET TAGS ('dbx_business_glossary_term' = 'Certification Level (CERT_LEVEL)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `certification_level` SET TAGS ('dbx_value_regex' = 'level1|level2|master|expert');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `certification_type` SET TAGS ('dbx_business_glossary_term' = 'Certification Type (CERT_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `certification_type` SET TAGS ('dbx_value_regex' = 'ASE|OEM|EV|ADAS|HV|GENERAL');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp (CREATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `current_active_ro_count` SET TAGS ('dbx_business_glossary_term' = 'Current Active Repair Order Count (ACTIVE_RO_COUNT)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `email_address` SET TAGS ('dbx_business_glossary_term' = 'Technician Email Address (TECH_EMAIL)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `email_address` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `email_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `email_address` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `flat_rate_efficiency_rating` SET TAGS ('dbx_business_glossary_term' = 'Flat‑Rate Efficiency Rating (EFF_RATING)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `full_name` SET TAGS ('dbx_business_glossary_term' = 'Technician Full Name (TECH_NAME)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `full_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `full_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `hire_date` SET TAGS ('dbx_business_glossary_term' = 'Hire Date (HIRE_DATE)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `last_training_date` SET TAGS ('dbx_business_glossary_term' = 'Last Training Date (LAST_TRAIN_DATE)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `max_concurrent_ro` SET TAGS ('dbx_business_glossary_term' = 'Maximum Concurrent Repair Orders (MAX_CONCURRENT_RO)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Technician Notes (NOTES)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `overtime_eligible` SET TAGS ('dbx_business_glossary_term' = 'Overtime Eligible (OT_ELIGIBLE)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `overtime_rate_multiplier` SET TAGS ('dbx_business_glossary_term' = 'Overtime Rate Multiplier (OT_MULTIPLIER)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `phone_number` SET TAGS ('dbx_business_glossary_term' = 'Technician Phone Number (TECH_PHONE)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `phone_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `phone_number` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `shift_type` SET TAGS ('dbx_business_glossary_term' = 'Shift Type (SHIFT_TYPE)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `shift_type` SET TAGS ('dbx_value_regex' = 'day|night|flex|rotating');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `skill_level` SET TAGS ('dbx_business_glossary_term' = 'Skill Level (SKILL_LEVEL)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `skill_level` SET TAGS ('dbx_value_regex' = 'junior|mid|senior|lead');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `specialization` SET TAGS ('dbx_business_glossary_term' = 'Technician Specialization (SPECIALIZATION)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `specialization` SET TAGS ('dbx_value_regex' = 'powertrain|electrical|body|diagnostics|software|hvac');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `technician_status` SET TAGS ('dbx_business_glossary_term' = 'Technician Status (STATUS)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `technician_status` SET TAGS ('dbx_value_regex' = 'active|inactive|suspended|retired');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `training_hours_completed` SET TAGS ('dbx_business_glossary_term' = 'Training Hours Completed (TRAIN_HRS)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp (UPDATED_TS)');
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ALTER COLUMN `years_of_experience` SET TAGS ('dbx_business_glossary_term' = 'Years of Experience (YEARS_EXP)');
