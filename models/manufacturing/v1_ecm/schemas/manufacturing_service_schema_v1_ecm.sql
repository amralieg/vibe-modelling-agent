-- Schema for Domain: service | Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:37

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`service` COMMENT 'Manages after-sales service and aftermarket operations including field service dispatch, warranty claims, spare parts management, service contracts, SLA tracking, installation, commissioning, technical support, and customer support cases. Tracks NPS and service KPIs for the installed base of automation and electrification products.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`request` (
    `request_id` BIGINT COMMENT 'Unique system-generated identifier for each customer service request or support case record in the aftermarket domain.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Service requests are logged against specific equipment experiencing issues. Customer service and technicians need equipment context to diagnose problems and schedule appropriate service response.',
    `line_id` BIGINT COMMENT 'Foreign key linking to production.production_line. Business justification: Service requests for production equipment maintenance/repair must reference the specific production line to schedule downtime, dispatch technicians with correct skills, and track line-specific reliabi',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Service request for product SKU - normalize by replacing product_sku text with FK to product.sku',
    `assigned_engineer` STRING COMMENT 'Full name of the support engineer or field service technician currently assigned as the primary owner responsible for resolving this service request.',
    `assigned_team` STRING COMMENT 'Name of the support team or service group to which the service request is currently assigned, used for workload distribution and team-level SLA reporting.',
    `capa_reference` STRING COMMENT 'Reference number of the associated Corrective and Preventive Action (CAPA) record initiated as a result of this service request, linking aftermarket feedback to quality management processes.',
    `case_number` STRING COMMENT 'Human-readable, business-facing case reference number assigned at case creation, used for customer communication and cross-system tracking.. Valid values are `^SR-[0-9]{8,12}$`',
    `category` STRING COMMENT 'High-level classification of the service request type, used for routing, reporting, and SLA assignment. Distinguishes warranty claims, technical support, installation, and other aftermarket case types.. Valid values are `technical_support|warranty_claim|product_defect|installation|commissioning|complaint|spare_parts|software|preventive_maintenance|billing|general_inquiry`',
    `closed_timestamp` TIMESTAMP COMMENT 'Date and time when the service request was formally closed after customer confirmation or automatic closure timeout, marking the end of the case lifecycle.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer site or installation location where the service request originated, used for regional SLA management and regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `customer_satisfaction_score` DECIMAL(18,2) COMMENT 'Customer satisfaction score collected via post-resolution survey, typically on a 1-5 or 1-10 scale. Used for service quality KPI reporting and Net Promoter Score (NPS) correlation analysis.',
    `description` STRING COMMENT 'Full narrative description of the reported issue, complaint, or inquiry as provided by the customer or captured by the support agent during case intake.',
    `entitlement_name` STRING COMMENT 'Name of the service entitlement or service contract under which this request is being handled, defining the SLA terms, response times, and coverage scope applicable to this case.',
    `escalation_level` STRING COMMENT 'Current escalation level of the service request (0=not escalated, 1=first-level escalation, 2=management escalation, 3=executive escalation), tracking how far the case has been elevated.. Valid values are `0|1|2|3`',
    `escalation_reason` STRING COMMENT 'Reason code explaining why the service request was escalated, used for root cause analysis of escalation patterns and process improvement.. Valid values are `sla_breach|customer_dissatisfaction|technical_complexity|safety_risk|repeat_issue|management_request|regulatory_requirement`',
    `external_reference_number` STRING COMMENT 'Customer-provided reference number or ticket number from the customers own system, used for cross-referencing and customer communication.',
    `first_response_timestamp` TIMESTAMP COMMENT 'Date and time when the first substantive response was provided to the customer, used to measure first response time against SLA targets.',
    `is_escalated` BOOLEAN COMMENT 'Flag indicating whether the service request has been escalated beyond the initial support tier, triggering escalation workflows and management notifications.. Valid values are `true|false`',
    `is_sla_breached` BOOLEAN COMMENT 'Flag indicating whether the service request has breached its contractual SLA resolution target, used for SLA compliance reporting and customer penalty tracking.. Valid values are `true|false`',
    `is_warranty_claim` BOOLEAN COMMENT 'Flag indicating whether this service request has been formally classified as a warranty claim, triggering warranty claim processing workflows and cost recovery from manufacturing.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'ISO 639-1 language code of the language used by the customer in this service request, used for routing to language-appropriate support agents and multilingual reporting.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the service request record in the source system, used for incremental data loading and audit trail purposes.',
    `opened_timestamp` TIMESTAMP COMMENT 'Date and time when the service request was officially opened and entered into the system, marking the start of SLA clock for response and resolution time measurement.',
    `origin_channel` STRING COMMENT 'The channel through which the customer initiated the service request (e.g., phone, email, web portal, field technician). Used for channel analytics and SLA routing.. Valid values are `phone|email|web_portal|field|chat|fax|edi|partner_portal|mobile_app`',
    `priority` STRING COMMENT 'Operational priority level assigned to the service request for queue management and dispatch scheduling, distinct from severity which reflects business impact.. Valid values are `p1|p2|p3|p4`',
    `product_line` STRING COMMENT 'The product line or family of the automation, electrification, or smart infrastructure product associated with the service request (e.g., Motion Control, Low Voltage Drives, Building Automation).',
    `resolution_description` STRING COMMENT 'Detailed description of the steps taken and actions performed to resolve the service request, including any parts replaced, configuration changes, or software updates applied.',
    `resolution_type` STRING COMMENT 'Classification of the resolution method applied to close the service request, used for service cost analysis and field service optimization.. Valid values are `remote_fix|field_repair|part_replacement|software_update|configuration_change|customer_training|no_fault_found|workaround|escalated_to_engineering|return_to_depot`',
    `resolved_timestamp` TIMESTAMP COMMENT 'Date and time when the service request issue was technically resolved and the resolution was communicated to the customer, used for resolution time SLA measurement.',
    `root_cause_category` STRING COMMENT 'Categorized root cause of the reported issue as determined during investigation, used for quality trend analysis, Corrective and Preventive Action (CAPA) initiation, and product improvement.. Valid values are `design_defect|manufacturing_defect|installation_error|operator_error|wear_and_tear|software_bug|environmental|supplier_component|unknown|no_fault_found`',
    `root_cause_description` STRING COMMENT 'Detailed narrative description of the identified root cause of the issue, as documented by the support engineer or field technician following investigation.',
    `serial_number` STRING COMMENT 'Serial number of the specific physical unit of the product reported in the service request, used to identify the exact installed asset and retrieve its service history.',
    `severity` STRING COMMENT 'Business impact severity classification of the service request, used to prioritize response and determine SLA tier. Critical indicates production stoppage or safety risk.. Valid values are `critical|high|medium|low`',
    `site_region` STRING COMMENT 'Geographic sales or service region (e.g., EMEA, Americas, APAC) of the customer installation site, used for regional performance reporting and service resource planning.',
    `sla_resolution_target_hours` DECIMAL(18,2) COMMENT 'Contractual target number of hours within which the service request must be fully resolved, as defined by the applicable SLA tier and service contract.',
    `sla_response_target_hours` DECIMAL(18,2) COMMENT 'Contractual target number of hours within which the first response to the customer must be provided, as defined by the applicable SLA tier and service contract.',
    `sla_tier` STRING COMMENT 'The Service Level Agreement (SLA) tier applicable to this service request, determining contractual response and resolution time targets. Derived from the customers service contract.. Valid values are `platinum|gold|silver|bronze|standard|none`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this service request record was sourced, supporting data lineage and multi-system reconciliation in the Silver layer.. Valid values are `salesforce_service_cloud|sap_s4hana|maximo|manual|partner_portal`',
    `status` STRING COMMENT 'Current lifecycle status of the service request, tracking progression from initial receipt through resolution and closure. Drives SLA monitoring and workload management.. Valid values are `new|open|in_progress|pending_customer|pending_parts|escalated|resolved|closed|cancelled`',
    `sub_category` STRING COMMENT 'Secondary classification providing more granular categorization within the primary case category (e.g., under technical_support: hardware_failure, software_bug, configuration_issue).',
    `subject` STRING COMMENT 'Brief one-line summary or title of the service request issue, as entered by the customer or support agent at case creation.',
    `warranty_status` STRING COMMENT 'Warranty coverage status of the product at the time the service request was created, determining whether repair or replacement costs are covered under warranty terms.. Valid values are `in_warranty|out_of_warranty|extended_warranty|warranty_expired|not_applicable`',
    CONSTRAINT pk_request PRIMARY KEY(`request_id`)
) COMMENT 'Customer-initiated service and support case records capturing post-sale technical issues, complaints, warranty claims, product defects, and general after-sales inquiries for automation systems, electrification solutions, and smart infrastructure components. Tracks case origin channel (phone, email, portal, field), severity classification, case category, assigned support engineer, escalation history, resolution steps, root cause, and closure details. Sourced from Salesforce Service Cloud. Serves as the primary SSOT for customer support interactions in the aftermarket domain.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`warranty_claim` (
    `warranty_claim_id` BIGINT COMMENT 'Unique system-generated identifier for each warranty claim record in the Manufacturing service domain.',
    `batch_id` BIGINT COMMENT 'Foreign key linking to production.batch. Business justification: Warranty claims for defective products must trace back to the production batch for quality investigation, recall management, and identifying systemic manufacturing defects affecting entire batches.',
    `capa_record_id` BIGINT COMMENT 'Foreign key linking to compliance.capa_record. Business justification: Warranty claims revealing systemic product defects trigger Corrective and Preventive Action (CAPA) records to address root causes and prevent recurrence per ISO 9001 requirements.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Warranty claims must identify the specific component that failed. Service teams reference engineering component data daily to validate warranty coverage and process claims.',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: Warranty claims reference specific equipment CIs to validate warranty coverage, installation date, and service history. Finance and service teams verify eligibility against CI purchase and deployment ',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Warranty costs must be allocated to specific cost centers for financial reporting and variance analysis. Controllers track warranty expense by cost center monthly.',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: Warranty claims use standardized defect codes for root cause classification. Service and quality teams share defect taxonomy to enable trend analysis and failure mode tracking.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Warranty claims are filed for specific equipment under warranty. Service teams validate warranty coverage, track claim history, and link to equipment purchase/installation records for claim processing',
    `ncr_id` BIGINT COMMENT 'Foreign key linking to quality.ncr. Business justification: Warranty claims frequently trigger NCRs (Non-Conformance Reports) when field failures indicate manufacturing defects. Quality teams use this to track systemic issues from field service data.',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Warranty claims on defective components are filed against the original supplier. Service teams coordinate with procurement to process supplier warranty claims and replacements daily.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: Warranty claims revealing systemic defects trigger R&D projects for product redesign or corrective engineering. Quality teams route high-impact warranty issues to engineering for resolution.',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Warranty claims trace back to the original equipment sale. Service teams validate warranty coverage against the opportunity that sold the equipment. Critical for determining warranty terms and coverag',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Warranty claims must reference the original sales order to validate warranty coverage, determine warranty start date, and verify purchased products. Critical for warranty administration and claim appr',
    `serialized_unit_id` BIGINT COMMENT 'Foreign key linking to inventory.serialized_unit. Business justification: Warranty claim for serialized unit - normalize by replacing product_serial_number text with FK to inventory.serialized_unit',
    `warranty_id` BIGINT COMMENT 'Foreign key linking to asset.asset_warranty. Business justification: Warranty claims reference the specific warranty agreement covering the equipment. Service teams validate coverage terms, expiration dates, and claim eligibility against the warranty record.',
    `approved_amount` DECIMAL(18,2) COMMENT 'The monetary amount approved by Manufacturing for warranty settlement after claim review and validation. May differ from claimed amount due to partial approvals or deductibles.. Valid values are `^d+(.d{1,2})?$`',
    `claim_number` STRING COMMENT 'Human-readable business reference number for the warranty claim, used in customer communications and cross-system tracking. Formatted as WC-YYYY-NNNNNNNN.. Valid values are `^WC-[0-9]{4}-[0-9]{8}$`',
    `claim_type` STRING COMMENT 'Classification of the warranty claim resolution type requested: repair of the defective unit, replacement with a new unit, credit note issuance, cash refund, on-site field service, or product exchange.. Valid values are `repair|replacement|credit_note|refund|field_service|exchange`',
    `claimed_amount` DECIMAL(18,2) COMMENT 'The total monetary amount claimed by the customer for warranty coverage, including repair costs, replacement parts, labor, and logistics.. Valid values are `^d+(.d{1,2})?$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer site where the product failure occurred. Used for regional warranty analytics, regulatory compliance, and statutory warranty obligations.. Valid values are `^[A-Z]{3}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts on the warranty claim (claimed, approved, repair cost, settlement). Supports multi-currency global operations.. Valid values are `^[A-Z]{3}$`',
    `decision` STRING COMMENT 'Final or interim adjudication decision on the warranty claim indicating whether the claim has been approved, rejected, or partially approved for coverage.. Valid values are `pending|approved|partially_approved|rejected|escalated`',
    `defect_location` STRING COMMENT 'Specific component, assembly, or functional area of the product where the defect was identified, such as power supply module, CPU board, or terminal block.',
    `external_claim_reference` STRING COMMENT 'Customer-provided or third-party reference number for the warranty claim, such as a customers internal purchase order or insurance claim number.',
    `failure_date` DATE COMMENT 'The date on which the product failure or defect was first observed by the customer or field technician.. Valid values are `^d{4}-d{2}-d{2}$`',
    `failure_description` STRING COMMENT 'Detailed narrative description of the product failure or defect as reported by the customer or field technician, including symptoms, conditions, and observed behavior.',
    `failure_mode` STRING COMMENT 'Standardized classification of the type of failure experienced by the product, aligned with FMEA failure mode taxonomy. Used for quality trending and root cause analysis.. Valid values are `electrical_failure|mechanical_failure|software_fault|communication_error|overheating|corrosion|physical_damage|premature_wear|intermittent_fault|no_fault_found|other`',
    `inspection_date` DATE COMMENT 'Date on which the defective product was physically inspected by a qualified technician to validate the warranty claim and determine root cause.. Valid values are `^d{4}-d{2}-d{2}$`',
    `is_within_warranty` BOOLEAN COMMENT 'Indicates whether the product was within its active warranty period at the time the claim was submitted. Determined during claim validation against warranty start and end dates.. Valid values are `true|false`',
    `manufacture_date` DATE COMMENT 'Date on which the claimed product unit was manufactured. Used to validate warranty period eligibility and identify production batch issues.. Valid values are `^d{4}-d{2}-d{2}$`',
    `product_category` STRING COMMENT 'High-level product category of the claimed item, used for warranty analytics, defect trending, and product quality reporting.. Valid values are `plc|drive|switchgear|hmi|sensor|motor|transformer|circuit_breaker|automation_system|electrification_component|other`',
    `product_description` STRING COMMENT 'Human-readable description of the product under warranty claim, such as SIMATIC S7-1500 PLC Controller or SINAMICS G120 Variable Speed Drive.',
    `product_model_number` STRING COMMENT 'Model or part number of the product under warranty claim, identifying the product family and configuration from the product catalog.',
    `rejection_reason` STRING COMMENT 'Standardized reason code explaining why a warranty claim was rejected or partially rejected. Required for customer communication and CAPA analysis.. Valid values are `warranty_expired|misuse_or_abuse|unauthorized_modification|physical_damage|out_of_scope|no_defect_found|missing_documentation|other`',
    `repair_cost` DECIMAL(18,2) COMMENT 'Actual cost incurred to repair the defective product under warranty, including labor, parts, and overhead. Used for warranty reserve accounting and cost of quality reporting.. Valid values are `^d+(.d{1,2})?$`',
    `replacement_part_number` STRING COMMENT 'Part number of the replacement component or unit provided under the warranty claim. Applicable when claim type is replacement or repair requiring parts.',
    `replacement_serial_number` STRING COMMENT 'Serial number of the replacement unit dispatched to the customer under the warranty claim. Used to update the installed base and transfer warranty coverage.',
    `resolution_date` DATE COMMENT 'The date on which the warranty claim was operationally resolved (repair completed, replacement shipped, or service performed), distinct from financial settlement date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `return_material_authorization` STRING COMMENT 'Return Material Authorization (RMA) number issued to the customer for returning the defective product. Required for logistics tracking and goods receipt processing.',
    `root_cause` STRING COMMENT 'Determined root cause of the product failure following investigation. Used for CAPA initiation, supplier chargebacks, and product quality improvement programs.. Valid values are `design_defect|manufacturing_defect|material_defect|software_bug|installation_error|customer_misuse|environmental_factor|supplier_component_failure|unknown|other`',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for the original product sale, used to allocate warranty costs and manage intercompany chargebacks.',
    `service_technician_name` STRING COMMENT 'Name of the field service technician or engineer who performed the warranty inspection, repair, or replacement. Used for accountability and service quality tracking.',
    `settlement_date` DATE COMMENT 'The date on which the warranty claim was financially settled, either through credit note issuance, payment, or repair completion confirmation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the warranty claim, tracking progression from initial submission through resolution and settlement.. Valid values are `draft|submitted|under_review|pending_inspection|approved|rejected|in_repair|replacement_ordered|settled|closed|cancelled`',
    `submission_date` DATE COMMENT 'The date on which the warranty claim was formally submitted by the customer or service partner. Used to determine warranty coverage validity and SLA start.. Valid values are `^d{4}-d{2}-d{2}$`',
    `submission_timestamp` TIMESTAMP COMMENT 'Precise date and time when the warranty claim was submitted, including timezone offset. Used for SLA tracking and audit trail.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `supplier_chargeback_amount` DECIMAL(18,2) COMMENT 'Monetary amount to be recovered from the supplier responsible for the defective component or material that caused the warranty claim.. Valid values are `^d+(.d{1,2})?$`',
    `supplier_chargeback_flag` BOOLEAN COMMENT 'Indicates whether the warranty claim cost has been or will be charged back to a supplier due to a supplier-caused defect. Triggers supplier quality management and procurement processes.. Valid values are `true|false`',
    CONSTRAINT pk_warranty_claim PRIMARY KEY(`warranty_claim_id`)
) COMMENT 'Transactional records for warranty claims submitted against Manufacturing products including automation systems, PLCs, drives, switchgear, and electrification components. Captures claim submission date, product serial number, failure description, failure mode, defect code, claim type (repair, replacement, credit), claim status, approved/rejected decision, warranty coverage validation, repair cost, replacement part details, and claim settlement amount. Linked to the installed base and product catalog. Managed in SAP S/4HANA QM and Salesforce Service Cloud.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`contract_line` (
    `contract_line_id` BIGINT COMMENT 'Unique system-generated identifier for each individual line item within a service contract. Serves as the primary key for the service_contract_line entity.',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: service_contract_line is the child line-item entity of service_contract. Each line item belongs to exactly one service contract. No contract_number or contract reference column is visible in service_c',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Service contract lines specify which equipment is covered under service agreements. Defines scope of coverage, response times, and entitlements for specific assets. Used in contract management and ser',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Service contract lines specify which products are covered. Links to SKU for accurate service scope definition, parts eligibility, and contract pricing calculations.',
    `availability_target_percent` DECIMAL(18,2) COMMENT 'Contractually committed equipment or system availability percentage for the covered asset on this line (e.g., 99.5%). Used for SLA compliance reporting and penalty/bonus calculations.',
    `billing_frequency` STRING COMMENT 'Frequency at which this contract line is invoiced to the customer (e.g., monthly, quarterly, annually, or one-time). Drives the billing plan and revenue recognition schedule.. Valid values are `monthly|quarterly|semi_annual|annual|one_time|milestone_based`',
    `billing_plan_type` STRING COMMENT 'Type of billing plan applied to this contract line, indicating whether billing is periodic (time-based), milestone-driven, on-demand, prepaid, or postpaid. Determines the invoicing logic in SAP SD.. Valid values are `periodic|milestone|on_demand|prepaid|postpaid`',
    `cost_center` STRING COMMENT 'SAP cost center code associated with the delivery of services on this contract line. Used for cost allocation and margin analysis at the service delivery unit level.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the covered equipment is installed and service is to be delivered. Determines applicable regulatory requirements, tax rules, and service resource allocation.. Valid values are `^[A-Z]{3}$`',
    `coverage_end_date` DATE COMMENT 'Date on which service coverage for this specific contract line expires. Used for renewal tracking, SLA enforcement, and billing period management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `coverage_hours` STRING COMMENT 'Service coverage window for this contract line, defining the hours and days during which the SLA obligations apply (e.g., 8x5 for 8 hours/5 days, 24x7 for round-the-clock coverage).. Valid values are `8x5|12x5|16x5|24x7|24x5|business_hours|custom`',
    `coverage_start_date` DATE COMMENT 'Date on which service coverage for this specific contract line becomes effective. May differ from the parent contract start date if coverage for individual assets is staggered.. Valid values are `^d{4}-d{2}-d{2}$`',
    `covered_equipment_serial_number` STRING COMMENT 'Serial number of the specific physical equipment or asset covered by this contract line. Links the service obligation to a unique installed asset in the field. Corresponds to the installed base serial number.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when this service contract line record was first created in the system. Used for audit trail, data lineage, and contract administration tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary values on this contract line (e.g., USD, EUR, GBP). Supports multi-currency contract management for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `discount_percent` DECIMAL(18,2) COMMENT 'Percentage discount applied to the unit price for this contract line, reflecting negotiated pricing agreements, volume discounts, or promotional terms. Expressed as a percentage (e.g., 10.00 for 10%).',
    `escalation_level` STRING COMMENT 'Defines the escalation tier for service issues related to this contract line, determining the support team level (L1 through L4) that handles escalated cases. Aligns with the service delivery model.. Valid values are `L1|L2|L3|L4`',
    `installed_base_reference` STRING COMMENT 'Reference identifier for the installed base record associated with this contract line. Used when coverage applies to an installed base entry rather than a single serialized asset, supporting multi-unit or fleet coverage scenarios.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this service contract line record. Supports change tracking, audit compliance, and incremental data loading in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `line_description` STRING COMMENT 'Free-text description of the service scope, covered equipment, or service bundle for this specific contract line item. Provides human-readable context for the contracted service.',
    `line_number` STRING COMMENT 'Sequential line item number within the parent service contract, used to identify and order individual line items. Typically increments by 10 (e.g., 10, 20, 30) following SAP SD conventions.. Valid values are `^[0-9]{1,5}$`',
    `line_value` DECIMAL(18,2) COMMENT 'Total monetary value of this contract line, calculated as net price multiplied by quantity. Represents the contracted revenue for this specific line item over the coverage period.',
    `net_price` DECIMAL(18,2) COMMENT 'Unit price after application of the discount percentage for this contract line. Represents the effective per-unit price used for billing and revenue recognition.',
    `penalty_clause_applicable` BOOLEAN COMMENT 'Indicates whether financial penalties apply to this contract line if SLA targets (response time, resolution time, availability) are not met. Triggers penalty calculation workflows upon SLA breach.. Valid values are `true|false`',
    `penalty_rate_percent` DECIMAL(18,2) COMMENT 'Percentage of the line value that is deducted as a financial penalty per SLA breach event or per period of non-compliance. Only applicable when penalty_clause_applicable is true.',
    `preventive_visits_per_year` STRING COMMENT 'Number of scheduled preventive maintenance visits included in this contract line per year. Drives field service scheduling and resource planning for the covered asset.',
    `product_number` STRING COMMENT 'Material or product number identifying the service product, spare part bundle, or equipment model covered by this contract line. Aligns with the product catalog in SAP S/4HANA MM.',
    `profit_center` STRING COMMENT 'SAP profit center code to which the revenue from this contract line is attributed. Enables contract profitability analysis at the organizational unit level.',
    `quantity` DECIMAL(18,2) COMMENT 'Number of units, assets, or service instances covered by this contract line. For example, a line covering 5 identical machines would have a quantity of 5. Used in conjunction with unit price to calculate line value.',
    `remote_monitoring_included` BOOLEAN COMMENT 'Indicates whether remote monitoring and diagnostics via IIoT connectivity (e.g., Siemens MindSphere) is included in the scope of this contract line. Enables proactive fault detection and predictive maintenance.. Valid values are `true|false`',
    `resolution_time_hours` DECIMAL(18,2) COMMENT 'Maximum number of hours within which a service issue must be fully resolved for the covered equipment on this line. Defines the contractual obligation for mean time to repair (MTTR) compliance.',
    `response_time_hours` DECIMAL(18,2) COMMENT 'Maximum number of hours within which a service response must be initiated after a fault or service request is raised for the covered equipment on this line. A key SLA parameter for field service dispatch.',
    `service_category` STRING COMMENT 'High-level category grouping for the service line, aligning with the companys service portfolio structure (e.g., hardware maintenance, software support, electrification services). Used for revenue reporting and portfolio analysis.. Valid values are `hardware|software|electrification|automation|infrastructure|lifecycle|digital_services`',
    `service_type` STRING COMMENT 'Classification of the service being contracted on this line item, such as preventive maintenance, corrective maintenance, remote monitoring, or full-service coverage. Determines the nature of service obligations and resource requirements.. Valid values are `preventive_maintenance|corrective_maintenance|remote_monitoring|field_service|technical_support|spare_parts|installation|commissioning|inspection|training|software_update|full_service`',
    `sla_tier` STRING COMMENT 'SLA tier assigned to this contract line, defining the overall level of service commitment (e.g., Platinum, Gold, Silver). Determines the applicable response time, resolution time, and availability targets.. Valid values are `platinum|gold|silver|bronze|standard|custom`',
    `software_updates_included` BOOLEAN COMMENT 'Indicates whether firmware and software updates for the covered equipment are included in the scope of this contract line. Relevant for PLC, SCADA, HMI, and automation system contracts.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this contract line record originated (e.g., SAP S/4HANA SD, Salesforce CRM). Supports data lineage and reconciliation in the lakehouse silver layer.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL|LEGACY`',
    `spare_parts_included` BOOLEAN COMMENT 'Indicates whether spare parts and replacement components are included in the scope of this contract line at no additional charge. Affects cost-to-serve calculations and parts inventory planning.. Valid values are `true|false`',
    `status` STRING COMMENT 'Current lifecycle status of the service contract line item, indicating whether the line is active, suspended, cancelled, or in another state. Drives billing eligibility and SLA enforcement.. Valid values are `draft|active|suspended|cancelled|expired|pending_approval|closed`',
    `tax_code` STRING COMMENT 'Tax classification code applied to this contract line for VAT, GST, or sales tax calculation purposes. Determined by the service type, customer tax status, and jurisdiction of service delivery.',
    `unit_of_measure` STRING COMMENT 'Unit of measure applicable to the quantity on this contract line (e.g., EA for each unit, HR for hours of service, MON for months of coverage). Follows ISO 80000 and SAP UOM standards.. Valid values are `EA|HR|DAY|MON|YR|KG|SET|LOT|VISIT`',
    `unit_price` DECIMAL(18,2) COMMENT 'Price per unit of service or covered asset for this contract line, expressed in the contract currency. Forms the basis for line value calculation before discounts.',
    CONSTRAINT pk_contract_line PRIMARY KEY(`contract_line_id`)
) COMMENT 'Individual line items within a customer service contract defining the specific covered equipment, service scope, and pricing for each covered asset or service bundle. Captures line item number, covered equipment serial number or installed base reference, service type, unit price, quantity, discount, line value, coverage start and end dates, and SLA parameters applicable to that line. Enables granular tracking of multi-equipment service contracts and supports contract profitability analysis at the line level.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`sla_commitment` (
    `sla_commitment_id` BIGINT COMMENT 'Unique system-generated identifier for each SLA commitment record. Serves as the primary key for the sla_commitment data product.',
    `applicable_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code specifying the country to which this SLA commitment applies when geographic_scope is set to country. Supports country-specific regulatory and operational SLA variations.. Valid values are `^[A-Z]{3}$`',
    `applicable_product_category` STRING COMMENT 'The product or equipment category to which this SLA commitment applies, such as automation systems, electrification solutions, smart infrastructure components, or MRO spare parts. Allows SLA commitments to be scoped to specific product lines within the installed base.',
    `applicable_service_request_category` STRING COMMENT 'The type of service request or work order category to which this SLA commitment applies. Enables different SLA targets for different service activities (e.g., emergency breakdown response vs. scheduled preventive maintenance).. Valid values are `corrective_maintenance|preventive_maintenance|installation|commissioning|technical_support|emergency_breakdown|software_update|inspection|warranty_repair`',
    `breach_count_period` STRING COMMENT 'The time window over which breach counts are accumulated for the purpose of evaluating max_breach_count_before_termination and penalty caps. Defines the rolling or calendar period for breach tracking.. Valid values are `monthly|quarterly|annually|rolling_90_days|rolling_12_months`',
    `breach_threshold_value` DECIMAL(18,2) COMMENT 'The numeric value at which the SLA is considered breached. For time-based SLAs, this is the maximum allowable duration before a breach is triggered. For rate-based SLAs, this is the minimum acceptable performance level below which a breach is declared.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `category` STRING COMMENT 'Categorizes the SLA commitment by its origin and enforceability. Contractual SLAs are legally binding per customer agreements; Operational SLAs are internal performance targets; Regulatory SLAs are mandated by industry or government standards; Internal SLAs govern cross-functional service delivery.. Valid values are `operational|contractual|regulatory|internal`',
    `code` STRING COMMENT 'Short alphanumeric business code uniquely identifying the SLA commitment for use in contracts, service orders, and system integrations (e.g., SLA-GOLD-RSP-4H).. Valid values are `^[A-Z0-9_-]{2,30}$`',
    `coverage_hours_type` STRING COMMENT 'Defines the operational coverage window within which the SLA commitment is measured and enforced. 24x7 means the SLA clock runs continuously; Business Hours means only standard working hours count; Extended Hours covers evenings and weekends; Custom requires reference to a defined schedule.. Valid values are `24x7|business_hours|extended_hours|custom`',
    `coverage_timezone` STRING COMMENT 'The IANA timezone identifier used as the reference timezone for measuring SLA coverage hours and breach calculations (e.g., America/New_York, Europe/Berlin, Asia/Singapore). Critical for multinational operations where service delivery spans multiple time zones.',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time when this SLA commitment record was first created in the system. Used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to monetary penalty values (e.g., USD, EUR, GBP, JPY). Supports multi-currency operations across global service contracts.. Valid values are `^[A-Z]{3}$`',
    `customer_tier` STRING COMMENT 'The customer segment or tier to which this SLA commitment applies. Enables differentiated service levels based on customer value, contract type, or strategic importance. Platinum and Gold tiers typically receive more aggressive response and resolution commitments.. Valid values are `platinum|gold|silver|bronze|standard`',
    `description` STRING COMMENT 'Full narrative description of the SLA commitment, including its business purpose, scope, conditions, and any special terms or exclusions. Provides the human-readable context for the structured SLA parameters.',
    `effective_date` DATE COMMENT 'The date from which this SLA commitment version becomes active and enforceable. Used to determine which SLA version applies to a given service event based on the event date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `escalation_trigger_unit` STRING COMMENT 'Unit of measure for the escalation_trigger_value, defining how the escalation threshold is quantified (e.g., hours elapsed, percent of target consumed).. Valid values are `hours|minutes|days|percent|count`',
    `escalation_trigger_value` DECIMAL(18,2) COMMENT 'The numeric threshold at which an escalation action is automatically triggered, typically set before the breach threshold to provide a warning window. For example, escalate at 3 hours for a 4-hour response SLA. Enables proactive intervention before a formal breach occurs.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `exclusion_conditions` STRING COMMENT 'Describes conditions under which the SLA commitment is suspended or excluded from measurement, such as force majeure events, customer-caused delays, scheduled maintenance windows, or third-party infrastructure outages. Critical for accurate SLA compliance reporting.',
    `expiry_date` DATE COMMENT 'The date on which this SLA commitment version ceases to be active. After this date, the commitment is no longer enforceable unless renewed or superseded by a new version.. Valid values are `^d{4}-d{2}-d{2}$`',
    `geographic_scope` STRING COMMENT 'Defines the geographic applicability of this SLA commitment. Global applies uniformly across all regions; Regional applies to a specific geographic region; Country applies to a specific country; Site-Specific applies only to a defined customer installation site.. Valid values are `global|regional|country|site_specific`',
    `is_regulatory_mandated` BOOLEAN COMMENT 'Indicates whether this SLA commitment is mandated by a regulatory body or government authority (e.g., OSHA safety response requirements, EPA environmental incident response). Regulatory-mandated SLAs may carry legal penalties beyond contractual penalties.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time when this SLA commitment record was most recently updated. Supports change tracking, audit compliance, and data freshness monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `max_breach_count_before_termination` STRING COMMENT 'The maximum number of SLA breaches within a defined period before the customer is contractually entitled to terminate the service contract. Provides a quantitative threshold for contract termination rights.. Valid values are `^[0-9]+$`',
    `measurement_start_event` STRING COMMENT 'Defines the business event that starts the SLA clock for measurement purposes. Case Creation starts the timer when the service request is logged; Case Assignment starts when a technician is assigned; Customer Notification starts when the customer is informed; Engineer Dispatch starts when a field engineer is dispatched.. Valid values are `case_creation|case_assignment|customer_notification|parts_order_placed|engineer_dispatch`',
    `measurement_stop_event` STRING COMMENT 'Defines the business event that stops the SLA clock for measurement purposes. Case Resolved stops the timer when the service case is closed; Customer Confirmed stops when the customer acknowledges resolution; System Restored stops when the equipment is returned to operational status.. Valid values are `case_resolved|customer_confirmed|parts_delivered|engineer_on_site|system_restored`',
    `measurement_unit` STRING COMMENT 'Unit of measure for the target_metric_value. Defines how the SLA performance target is quantified (e.g., hours for response/resolution time, percent for uptime or first-time fix rate, count for parts availability).. Valid values are `hours|minutes|days|percent|count|ratio`',
    `name` STRING COMMENT 'Descriptive business name for the SLA commitment, such as Gold Tier 4-Hour Response SLA or Critical Equipment Uptime Guarantee. Used for display and reporting purposes.',
    `next_review_date` DATE COMMENT 'The scheduled date for the next formal review of this SLA commitment. Triggers review workflows and ensures SLA definitions are kept current with operational and contractual changes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `penalty_cap_period` STRING COMMENT 'The time period over which the penalty_cap_value is applied and reset. Defines the accumulation window for penalty calculations (e.g., monthly cap resets at the start of each calendar month).. Valid values are `monthly|quarterly|annually|per_incident`',
    `penalty_cap_value` DECIMAL(18,2) COMMENT 'The maximum cumulative penalty amount or percentage that can be applied within a defined period (typically per month or per contract year). Protects against unlimited liability exposure from repeated SLA breaches. Classified as confidential due to commercial sensitivity.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `penalty_type` STRING COMMENT 'Defines the type of penalty or remedy applicable when this SLA commitment is breached. Service Credit provides a credit against future invoices; Financial Penalty imposes a monetary charge; Contract Termination Right grants the customer the right to exit the contract; None indicates no contractual penalty applies.. Valid values are `service_credit|financial_penalty|contract_termination_right|none`',
    `penalty_unit` STRING COMMENT 'Defines how the penalty_value is applied and measured. Percent of Monthly Fee applies the penalty as a percentage of the monthly service fee; Fixed Amount applies a flat monetary penalty; Percent Per Hour Breach applies a compounding penalty for each hour of breach duration.. Valid values are `percent_of_monthly_fee|percent_of_annual_fee|fixed_amount|percent_per_hour_breach`',
    `penalty_value` DECIMAL(18,2) COMMENT 'The numeric value of the penalty applied upon SLA breach. For financial penalties and service credits, this represents the monetary amount or percentage of contract value. Interpreted in conjunction with penalty_unit. Classified as confidential due to commercial sensitivity.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `priority_level` STRING COMMENT 'Priority classification associated with this SLA commitment, indicating the urgency and business impact level for which this commitment applies. Critical typically maps to production-down or safety-critical scenarios; High to significant operational impact; Medium to moderate disruption; Low to minor or cosmetic issues.. Valid values are `critical|high|medium|low`',
    `regulatory_reference` STRING COMMENT 'The specific regulatory standard, directive, or legal requirement that mandates this SLA commitment when is_regulatory_mandated is true (e.g., ISO 45001 Clause 8.2, OSHA 29 CFR 1910.147, EU Machinery Directive 2006/42/EC).',
    `review_frequency` STRING COMMENT 'Defines how frequently this SLA commitment is scheduled for review and potential revision. Supports continuous improvement processes and ensures SLA targets remain aligned with operational capabilities and customer expectations.. Valid values are `monthly|quarterly|semi_annually|annually|as_needed`',
    `service_delivery_channel` STRING COMMENT 'Specifies the mode of service delivery to which this SLA commitment applies. On-Site requires a field engineer dispatch; Remote covers telephone, email, or digital support; Hybrid combines remote and on-site; Parts Only covers spare part delivery without labor.. Valid values are `on_site|remote|hybrid|parts_only`',
    `status` STRING COMMENT 'Current lifecycle status of the SLA commitment record. Draft indicates the commitment is being defined; Active indicates it is in use; Deprecated indicates it has been superseded; Retired indicates it is no longer applicable; Under Review indicates it is being assessed for update.. Valid values are `draft|active|deprecated|retired|under_review`',
    `target_metric_value` DECIMAL(18,2) COMMENT 'The numeric performance target defined for this SLA commitment. For example, 4 (hours) for a response time SLA, 99.5 (percent) for an uptime guarantee, or 85 (percent) for a first-time fix rate. Interpreted in conjunction with measurement_unit.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `type` STRING COMMENT 'Classifies the nature of the SLA performance commitment. Response Time defines the maximum time to acknowledge a service request; Resolution Time defines the maximum time to fully resolve an issue; Uptime Guarantee defines minimum system availability; First-Time Fix Rate (FTFR) defines the percentage of issues resolved on first visit; Mean Time to Repair (MTTR) defines average repair duration; Parts Availability defines spare part delivery commitment.. Valid values are `response_time|resolution_time|uptime_guarantee|first_time_fix_rate|mean_time_to_repair|preventive_maintenance_interval|parts_availability|remote_support_availability`',
    `version_number` STRING COMMENT 'Version identifier for the SLA commitment definition, following semantic versioning conventions (e.g., 1.0, 2.1, 3.0.1). Enables tracking of changes to SLA terms over time and ensures historical service performance is measured against the correct version.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?$`',
    CONSTRAINT pk_sla_commitment PRIMARY KEY(`sla_commitment_id`)
) COMMENT 'Defines the specific SLA performance commitments and thresholds applicable to service contracts, service request categories, and customer tiers. Captures SLA name, SLA type (response time, resolution time, uptime guarantee, first-time fix rate), target metric value, measurement unit, breach threshold, escalation trigger, applicable customer segment, applicable product category, and penalty terms for breach. Serves as the reference standard against which actual service performance is measured. Distinct from customer.sla_agreement which records the contractual SLA agreement at the customer account level.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`sla_tracking` (
    `sla_tracking_id` BIGINT COMMENT 'Unique system-generated identifier for each SLA tracking record. Serves as the primary key for the sla_tracking data product in the Databricks Silver Layer.',
    `technician_id` BIGINT COMMENT 'Employee identifier of the field service technician or support engineer currently assigned to resolve the service request or field service order. Used for individual-level SLA performance tracking.',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: sla_tracking.service_contract_number (STRING) is a denormalized reference to service_contract.contract_number. SLA tracking is governed by the terms of the service contract. Adding service_contract_id',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: SLA tracking for customer account - normalize by replacing account_number text with FK',
    `field_service_order_id` BIGINT COMMENT 'Foreign key linking to service.field_service_order. Business justification: sla_tracking.field_service_order_number (STRING) is a denormalized reference to field_service_order.order_number. SLA tracking also monitors compliance for field service orders (response and resolutio',
    `request_id` BIGINT COMMENT 'Foreign key linking to service.service_request. Business justification: sla_tracking.service_request_number (STRING) is a denormalized reference to service_request.case_number. SLA tracking records monitor real-time SLA compliance for service requests. Adding service_requ',
    `sla_commitment_id` BIGINT COMMENT 'Foreign key linking to service.sla_commitment. Business justification: sla_tracking.sla_agreement_number (STRING) is a denormalized reference to sla_commitment. SLA tracking records monitor compliance against specific SLA commitment definitions. Adding sla_commitment_id ',
    `actual_resolution_timestamp` TIMESTAMP COMMENT 'The actual date and time at which the service issue was fully resolved and the case or field service order was closed. Null if resolution has not yet occurred. Used to determine resolution SLA compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `actual_response_timestamp` TIMESTAMP COMMENT 'The actual date and time at which the service team provided the initial response or acknowledgement to the customer. Null if the response has not yet been made. Used to determine response SLA compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `assigned_team` STRING COMMENT 'Name or code of the service team or queue currently responsible for resolving the service request or field service order. Used for workload analysis and team-level SLA performance reporting.',
    `breach_duration_minutes` STRING COMMENT 'The number of minutes by which the SLA target was exceeded at the time of resolution or as of the current timestamp for open breaches. Zero or null for records that have not breached. Used for breach severity analysis and penalty calculations.. Valid values are `^[0-9]*$`',
    `breach_reason_code` STRING COMMENT 'Standardized reason code explaining why the SLA was breached. Used for root cause analysis, CAPA (Corrective and Preventive Action) workflows, and service improvement initiatives.. Valid values are `resource_unavailability|parts_shortage|customer_delay|technical_complexity|access_restriction|third_party_dependency|force_majeure|incorrect_prioritization|escalation_delay|other`',
    `breach_reason_description` STRING COMMENT 'Free-text narrative providing additional context for the SLA breach beyond the standardized breach reason code. Captures specific circumstances, contributing factors, and corrective actions taken.',
    `business_hours_calendar` STRING COMMENT 'Name or code of the business hours calendar applied to this SLA tracking record. Determines which hours count toward SLA elapsed time (e.g., 24x7, 8x5, regional business hours). Critical for multinational operations with varying time zones.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer site or service location where the service request or field service order applies. Used for regional SLA compliance reporting and regulatory alignment.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The date and time at which this SLA tracking record was created in the source system. Used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the penalty amount. Supports multi-currency operations across global service contracts.. Valid values are `^[A-Z]{3}$`',
    `escalation_level` STRING COMMENT 'The escalation tier reached for this SLA tracking record. Level 1 indicates team lead escalation; Level 2 indicates service manager escalation; Level 3 indicates regional director escalation; Executive indicates C-level or key account escalation.. Valid values are `level_1|level_2|level_3|executive`',
    `escalation_timestamp` TIMESTAMP COMMENT 'The date and time at which the SLA tracking record was escalated. Null if no escalation has occurred. Used to measure escalation response time and management intervention effectiveness.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `installed_base_reference` STRING COMMENT 'Reference identifier of the installed base asset (automation or electrification product) for which the service request or field service order was raised. Enables SLA performance analysis by product line and asset type.',
    `is_escalated` BOOLEAN COMMENT 'Indicates whether this SLA tracking record has been escalated to a higher support tier, management, or the customer success team due to at-risk or breached status. True when escalation has been triggered.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The date and time at which this SLA tracking record was last updated in the source system. Used for incremental data loading, change detection, and audit trail in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `notification_sent` BOOLEAN COMMENT 'Indicates whether an at-risk or breach warning notification has been sent to the assigned team, service manager, or customer for this SLA tracking record. Used to prevent duplicate notifications and track proactive communication.. Valid values are `true|false`',
    `pause_duration_minutes` STRING COMMENT 'Total accumulated minutes for which the SLA clock was paused for this tracking record. Used to adjust effective SLA elapsed time and ensure fair compliance measurement when delays are customer-attributable.. Valid values are `^[0-9]*$`',
    `pause_reason` STRING COMMENT 'Reason for pausing the SLA clock. Used to distinguish customer-attributable delays from service team delays in SLA compliance reporting.. Valid values are `awaiting_customer_response|awaiting_parts|awaiting_access|customer_requested_hold|pending_approval|other`',
    `pause_start_timestamp` TIMESTAMP COMMENT 'The date and time at which the SLA clock was paused, typically due to awaiting customer response, pending parts delivery, or other customer-side dependencies. Null if the SLA clock has not been paused.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `penalty_amount` DECIMAL(18,2) COMMENT 'The financial penalty or service credit amount applicable for the SLA breach, expressed in the contract currency. Populated only when penalty_applicable is true and the breach has been confirmed. Used for financial reporting and customer credit processing.. Valid values are `^-?[0-9]+(.[0-9]{1,2})?$`',
    `penalty_applicable` BOOLEAN COMMENT 'Indicates whether a financial penalty or service credit is contractually applicable for a breach of this SLA commitment. Determined by the terms of the governing service contract.. Valid values are `true|false`',
    `priority` STRING COMMENT 'Priority level assigned to the service request or field service order, which influences the applicable SLA targets. Critical priority cases carry the most stringent SLA commitments.. Valid values are `critical|high|medium|low`',
    `record_source` STRING COMMENT 'Identifies the operational system of record from which this SLA tracking record originated. Used for data lineage, reconciliation, and audit purposes in the Databricks Silver Layer.. Valid values are `salesforce_service_cloud|sap_s4hana|manual_entry|api_integration`',
    `region_code` STRING COMMENT 'Internal business region code (e.g., EMEA, APAC, AMER) for the customer site or service location. Used for regional SLA performance aggregation and management reporting.',
    `resolution_due_timestamp` TIMESTAMP COMMENT 'The committed deadline by which the service issue must be fully resolved and the case or field service order closed. Calculated from the SLA start timestamp plus the contracted resolution time target.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `resolution_status` STRING COMMENT 'Specific compliance status for the resolution SLA milestone. Indicates whether the service issue was resolved within the committed resolution target time.. Valid values are `pending|met|breached|not_applicable`',
    `resolution_target_minutes` STRING COMMENT 'The contracted SLA target for full resolution, expressed in minutes. Derived from the applicable SLA tier and priority combination. Used as the baseline for resolution compliance measurement.. Valid values are `^[0-9]+$`',
    `response_due_timestamp` TIMESTAMP COMMENT 'The committed deadline by which the service team must provide an initial response or acknowledgement to the customer. Calculated from the SLA start timestamp plus the contracted response time target.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `response_status` STRING COMMENT 'Specific compliance status for the response SLA milestone. Indicates whether the initial response was provided within the committed response target time.. Valid values are `pending|met|breached|not_applicable`',
    `response_target_minutes` STRING COMMENT 'The contracted SLA target for initial response, expressed in minutes. Derived from the applicable SLA tier and priority combination. Used as the baseline for response compliance measurement.. Valid values are `^[0-9]+$`',
    `service_category` STRING COMMENT 'Category of service associated with the tracked request or order. Used to segment SLA performance by service type and align with service contract entitlements.. Valid values are `technical_support|field_service|warranty_repair|installation|commissioning|preventive_maintenance|spare_parts|remote_support|emergency_response`',
    `sla_start_timestamp` TIMESTAMP COMMENT 'The exact date and time at which the SLA clock started for this tracking record. Typically corresponds to the moment the service request was created or the field service order was dispatched, after any applicable business hours calendar adjustments.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `sla_tier` STRING COMMENT 'Service tier classification that determines the SLA target thresholds applicable to this tracking record. Higher tiers (e.g., Platinum, Gold) carry stricter response and resolution time commitments.. Valid values are `platinum|gold|silver|bronze|standard|premium|critical`',
    `sla_type` STRING COMMENT 'Classification of the SLA commitment being tracked. Distinguishes between response SLAs (time to acknowledge), resolution SLAs (time to close), on-site arrival SLAs (field dispatch), and other commitment types.. Valid values are `response|resolution|first_contact_resolution|on_site_arrival|parts_delivery|preventive_maintenance`',
    `status` STRING COMMENT 'Current real-time SLA compliance status for this tracking record. On-track indicates the SLA is within target; at-risk indicates the deadline is approaching; breached indicates the SLA target has been missed; completed indicates the SLA was met; paused indicates the clock is stopped (e.g., awaiting customer); cancelled indicates the SLA tracking was voided.. Valid values are `on_track|at_risk|breached|completed|paused|cancelled`',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the customer site or service location relevant to this SLA tracking record. Used to correctly apply business hours calendars and display SLA deadlines in local time for field service teams.',
    `tracking_number` STRING COMMENT 'Human-readable business reference number for the SLA tracking record, used in communications and reporting. Follows the format SLA-{YEAR}-{SEQUENCE}.. Valid values are `^SLA-[0-9]{4}-[0-9]{8}$`',
    `warning_threshold_percent` DECIMAL(18,2) COMMENT 'The percentage of the SLA target time elapsed at which the status transitions from on-track to at-risk, triggering proactive warning notifications. Typically set at 75-80% of the target time.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    CONSTRAINT pk_sla_tracking PRIMARY KEY(`sla_tracking_id`)
) COMMENT 'Transactional records tracking real-time SLA compliance status for individual service requests and field service orders against their committed SLA targets. Captures the associated service request or field service order reference, SLA commitment reference, SLA start timestamp, response due timestamp, resolution due timestamp, actual response timestamp, actual resolution timestamp, current SLA status (on-track, at-risk, breached), breach duration, breach reason code, and escalation flag. Enables proactive SLA management and breach prevention workflows in Salesforce Service Cloud.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`technician` (
    `technician_id` BIGINT COMMENT 'Unique surrogate identifier for the field service technician or service engineer record within the service domain. Serves as the primary key for dispatch, work order assignment, and competency tracking.',
    `employee_id` BIGINT COMMENT 'Cross-reference identifier linking the technician to the HR master record in the workforce system (Kronos / SAP HCM). Enables join to workforce.employee for payroll, benefits, and HR data without duplicating HR attributes in the service domain.. Valid values are `^EMP-[A-Z0-9]{6,12}$`',
    `training_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_training. Business justification: Technicians must complete mandatory compliance training (electrical safety, OSHA, arc flash, confined space) before servicing industrial manufacturing equipment to meet regulatory and insurance requir',
    `active_work_order_count` STRING COMMENT 'Current number of open or in-progress work orders assigned to the technician. Used by the dispatch scheduling engine to assess workload capacity before assigning new work orders. Updated in near-real-time from the field service management system.. Valid values are `^d+$`',
    `availability_status` STRING COMMENT 'Real-time operational availability of the technician for new dispatch assignments. Distinct from employment status — a technician may be active but currently dispatched on an existing work order. Used by the field service scheduling engine for optimal dispatch.. Valid values are `available|dispatched|on_site|traveling|on_break|unavailable`',
    `base_location_city` STRING COMMENT 'City of the technicians primary base location. Used for geographic dispatch optimization, travel time calculations, and regional reporting.',
    `base_location_name` STRING COMMENT 'Name of the technicians primary base location or service depot (e.g., Chicago Service Center, Frankfurt Depot, Singapore Hub). Represents the physical facility from which the technician is dispatched and to which they return after field assignments.',
    `base_location_state_province` STRING COMMENT 'State or province of the technicians primary base location. Used for regional dispatch grouping, labor law compliance determination, and territory management.',
    `cost_center_code` STRING COMMENT 'SAP cost center code to which the technicians labor costs are allocated. Used for financial controlling, service profitability reporting, and OPEX tracking by service region or product line.. Valid values are `^CC-[A-Z0-9]{4,10}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the technicians primary base of operations. Used for regulatory compliance (work permits, labor law), currency determination for expense reporting, and international dispatch authorization.. Valid values are `^[A-Z]{3}$`',
    `data_source_system` STRING COMMENT 'Identifies the operational system of record from which this technician record was sourced or last updated. Supports data lineage tracking and conflict resolution when records are updated from multiple upstream systems.. Valid values are `salesforce_field_service|kronos|sap_s4hana|manual`',
    `electrical_safety_cert_expiry` DATE COMMENT 'Expiration date of the technicians electrical safety certification. Dispatch systems must validate this date before assigning electrical work orders. Triggers recertification workflow when within 30 days of expiry.. Valid values are `^d{4}-d{2}-d{2}$`',
    `electrical_safety_certified` BOOLEAN COMMENT 'Indicates whether the technician holds a current electrical safety certification required for work on live electrical panels, switchgear, and high-voltage automation equipment. Mandatory for compliance with OSHA 29 CFR 1910.333 and NFPA 70E. Blocks assignment to electrical work orders if false.. Valid values are `true|false`',
    `hire_date` DATE COMMENT 'Date on which the technician was hired or onboarded into the service organization. Used to calculate tenure, determine eligibility for advanced certifications, and support workforce analytics.. Valid values are `^d{4}-d{2}-d{2}$`',
    `installation_authorized` BOOLEAN COMMENT 'Indicates whether the technician is certified and authorized to perform new product installation and commissioning at customer sites. Installation work requires completion of product-specific commissioning training and safety certifications.. Valid values are `true|false`',
    `labor_rate_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the technicians standard labor rate (e.g., USD, EUR, GBP). Required for multi-currency service order costing in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `languages_spoken` STRING COMMENT 'Pipe-delimited list of ISO 639-1 language codes representing languages the technician can communicate in (e.g., en|de|fr|zh). Used for customer-facing dispatch matching in multinational operations to ensure effective on-site communication.',
    `last_certification_review_date` DATE COMMENT 'Date of the most recent formal review of the technicians skill certifications and competency records. Used to trigger periodic recertification workflows and ensure compliance with ISO 9001 competence management requirements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `max_concurrent_work_orders` STRING COMMENT 'Maximum number of work orders the technician is authorized to hold simultaneously, based on role, seniority, and service agreement requirements. Used as a capacity constraint in the dispatch scheduling algorithm.. Valid values are `^[1-9]d*$`',
    `next_certification_due_date` DATE COMMENT 'Date by which the technician must complete their next certification renewal or competency assessment. Drives automated recertification reminders and dispatch eligibility checks for regulated work types.. Valid values are `^d{4}-d{2}-d{2}$`',
    `overtime_eligible` BOOLEAN COMMENT 'Indicates whether the technician is eligible for overtime compensation under applicable labor law and employment contract terms. Used by scheduling to determine availability for after-hours and weekend emergency dispatch.. Valid values are `true|false`',
    `product_line_competency` STRING COMMENT 'Pipe-delimited list of product lines the technician is qualified to service (e.g., drives|PLCs|HMI|switchgear|motors|robotics). Derived from completed product-specific training and certification programs. Used by dispatch to match technician competency to the product requiring service.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the technician record was first created in the Silver Layer lakehouse. Used for data lineage, audit trail, and incremental load processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the technician record in the Silver Layer. Used for change detection, incremental processing, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `remote_support_capable` BOOLEAN COMMENT 'Indicates whether the technician is equipped and authorized to provide remote technical support via digital tools (e.g., Siemens MindSphere, remote desktop, AR-assisted support). Enables routing of remote support cases to qualified technicians without physical dispatch.. Valid values are `true|false`',
    `seniority_level` STRING COMMENT 'Experience and seniority classification of the technician within the service organization. Used for work order complexity routing, mentoring assignments, and labor cost tier determination.. Valid values are `junior|mid|senior|lead|principal`',
    `service_contract_eligible` BOOLEAN COMMENT 'Indicates whether the technician is authorized to perform work under contracted service agreements (SLAs). Technicians without this flag may only be assigned to time-and-material or warranty work orders, not to SLA-governed service contracts.. Valid values are `true|false`',
    `service_start_date` DATE COMMENT 'Date on which the technician was activated in the service domain system (Salesforce Field Service). May differ from hire_date if the technician transferred from another department or was onboarded to field service after initial employment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `service_territory` STRING COMMENT 'Geographic service territory assigned to the technician, defining the primary operational region for field dispatch (e.g., Northeast_US, DACH_Region, Southeast_Asia). Used by the scheduling engine to minimize travel time and optimize dispatch. A technician may be dispatched outside their territory with override authorization.',
    `shift_pattern` STRING COMMENT 'Standard shift pattern assigned to the technician, defining their regular working hours for scheduling and dispatch planning. on_call indicates availability outside standard hours for emergency response.. Valid values are `day|night|rotating|on_call|flexible`',
    `skill_certifications` STRING COMMENT 'Pipe-delimited list of technical skill certifications held by the technician (e.g., PLC_programming|drive_commissioning|HMI_configuration|electrical_safety|SCADA_configuration|CNC_maintenance). Each certification corresponds to a validated competency assessment. Used for skill-based dispatch routing.',
    `standard_labor_rate` DECIMAL(18,2) COMMENT 'Standard hourly billing rate for the technicians labor, used for service order costing, customer invoice generation, and profitability analysis. Expressed in the technicians base currency. Classified as confidential business data.. Valid values are `^d{1,8}.d{2}$`',
    `status` STRING COMMENT 'Current employment and service-domain status of the technician. Controls eligibility for dispatch scheduling and work order assignment. active indicates available for deployment; on_leave excludes from scheduling; terminated marks end of service engagement.. Valid values are `active|inactive|on_leave|suspended|terminated`',
    `travel_authorized` BOOLEAN COMMENT 'Indicates whether the technician is authorized for international travel assignments. Requires valid passport, work visa eligibility, and completion of international travel safety training. Used to filter eligible technicians for cross-border dispatch.. Valid values are `true|false`',
    `type` STRING COMMENT 'Classification of the technician role within the service organization. Determines the nature of work orders assignable, billing rate category, and required certification level. Commissioning engineers handle initial product startup; warranty technicians focus on in-warranty repair claims.. Valid values are `field_service_engineer|service_technician|installation_specialist|commissioning_engineer|remote_support_engineer|warranty_technician`',
    `vehicle_code` STRING COMMENT 'Identifier of the company vehicle assigned to the technician for field service operations. Used for fleet management, GPS tracking integration, and parts/tools inventory carried in the vehicle. Null if the technician operates without a dedicated vehicle assignment.. Valid values are `^VEH-[A-Z0-9]{4,10}$`',
    `warranty_work_authorized` BOOLEAN COMMENT 'Indicates whether the technician is authorized to perform warranty repair and replacement work. Warranty work requires specific product training and authorization to ensure compliance with warranty terms and avoid voiding customer warranty coverage.. Valid values are `true|false`',
    CONSTRAINT pk_technician PRIMARY KEY(`technician_id`)
) COMMENT 'Master records for field service technicians and service engineers deployed to customer sites for installation, commissioning, repair, and maintenance of automation and electrification products. Captures technician employee ID, name, skill certifications (PLC programming, drive commissioning, HMI configuration, electrical safety), product line competencies, geographic service territory, current availability status, base location, vehicle assignment, and active work order count. Distinct from workforce.employee which is the HR master — this entity captures service-domain-specific competency and dispatch attributes not held in the HR system.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`service_territory` (
    `service_territory_id` BIGINT COMMENT 'Unique system-generated identifier for a geographic service territory used in field service dispatch and technician assignment.',
    `employee_id` BIGINT COMMENT 'FK to workforce.employee',
    `active_technician_count` STRING COMMENT 'Current number of active field service technicians assigned to this territory, used for capacity planning, workload balancing, and dispatch optimization.. Valid values are `^[0-9]+$`',
    `area_size_km2` DECIMAL(18,2) COMMENT 'Total geographic area of the service territory measured in square kilometers, used for workload density analysis, technician travel time estimation, and territory rebalancing.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `city` STRING COMMENT 'Primary city or metropolitan area associated with the service territory, used for dispatch routing and technician proximity matching.',
    `code` STRING COMMENT 'Short alphanumeric code uniquely identifying the service territory, used in dispatch systems, reporting, and routing logic (e.g., EMEA-DE-SOUTH, NA-MW-01).. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the country in which this service territory operates (e.g., DEU, USA, CHN).. Valid values are `^[A-Z]{3}$`',
    `coverage_days` STRING COMMENT 'Comma-separated list of days of the week on which field service coverage is provided in this territory (e.g., MON,TUE,WED,THU,FRI). Supports SLA scheduling and dispatch availability checks.. Valid values are `MON|TUE|WED|THU|FRI|SAT|SUN`',
    `coverage_hours_end` STRING COMMENT 'Daily end time (HH:MM, 24-hour format) of standard field service coverage for this territory, used in SLA scheduling and dispatch window enforcement.. Valid values are `^([01][0-9]|2[0-3]):[0-5][0-9]$`',
    `coverage_hours_start` STRING COMMENT 'Daily start time (HH:MM, 24-hour format) of standard field service coverage for this territory, used in SLA scheduling and dispatch window enforcement.. Valid values are `^([01][0-9]|2[0-3]):[0-5][0-9]$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the service territory record was first created in the system, used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the primary currency used in service billing and cost tracking within this territory (e.g., USD, EUR, CNY).. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Detailed narrative description of the service territory including geographic scope, special coverage notes, and operational context.',
    `dispatch_priority` STRING COMMENT 'Numeric priority ranking used by the dispatch engine to sequence territory-based assignments when multiple territories overlap or compete for the same technician resource. Lower values indicate higher priority.. Valid values are `^[1-9][0-9]*$`',
    `effective_date` DATE COMMENT 'Date on which this service territory definition became or becomes operationally effective. Used for territory versioning, historical analysis, and transition planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date on which this service territory definition expires or is decommissioned. Null indicates an indefinitely active territory. Used for territory lifecycle management and transition planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `hierarchy_level` STRING COMMENT 'Numeric level of this territory within the service territory hierarchy (e.g., 1=Global, 2=Region, 3=Country, 4=State, 5=City). Supports hierarchical rollup in analytics and reporting.. Valid values are `^[1-9][0-9]*$`',
    `is_24x7_coverage` BOOLEAN COMMENT 'Indicates whether this service territory provides round-the-clock, 24 hours a day, 7 days a week field service coverage. Relevant for critical infrastructure and high-priority SLA contracts.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'IETF BCP 47 language tag representing the primary language used for field service communications, work orders, and customer interactions in this territory (e.g., de-DE, en-US, zh-CN).. Valid values are `^[a-z]{2,3}(-[A-Z]{2})?$`',
    `last_reviewed_date` DATE COMMENT 'Date on which the territory boundaries, technician assignments, and coverage parameters were last formally reviewed and validated by the territory manager or service operations team.. Valid values are `^d{4}-d{2}-d{2}$`',
    `latitude` DECIMAL(18,2) COMMENT 'Latitude coordinate of the geographic centroid of the service territory, used for map visualization, proximity calculations, and optimal dispatch routing.. Valid values are `^-?([0-8]?[0-9]|90)(.[0-9]{1,6})?$`',
    `longitude` DECIMAL(18,2) COMMENT 'Longitude coordinate of the geographic centroid of the service territory, used for map visualization, proximity calculations, and optimal dispatch routing.. Valid values are `^-?((1[0-7][0-9]|[0-9]{1,2})(.[0-9]{1,6})?|180(.0{1,6})?)$`',
    `max_technician_capacity` STRING COMMENT 'Maximum number of technicians this territory is designed to support based on geographic size, workload projections, and service center capacity. Used for workforce planning and territory expansion decisions.. Valid values are `^[0-9]+$`',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the service territory record, used for change tracking, data synchronization, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `name` STRING COMMENT 'Human-readable name of the service territory used in scheduling interfaces, reports, and customer-facing communications (e.g., Germany South, US Midwest Region).',
    `postal_code_end` STRING COMMENT 'Ending postal code defining the upper bound of the postal code range covered by this service territory, used in conjunction with postal_code_start for boundary definition.. Valid values are `^[A-Z0-9 -]{3,10}$`',
    `postal_code_start` STRING COMMENT 'Starting postal code defining the lower bound of the postal code range covered by this service territory, used for geographic boundary enforcement in dispatch.. Valid values are `^[A-Z0-9 -]{3,10}$`',
    `region` STRING COMMENT 'High-level geographic region grouping for the territory used in global reporting and capacity planning (e.g., EMEA, APAC, AMER, DACH).',
    `service_center_code` STRING COMMENT 'Alphanumeric code identifying the service center assigned to this territory, used for cross-system integration with SAP S/4HANA and Maximo EAM.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `service_center_name` STRING COMMENT 'Name of the primary service center or depot responsible for dispatching technicians and managing spare parts inventory for this territory.',
    `sla_resolution_time_hours` DECIMAL(18,2) COMMENT 'Standard SLA resolution time commitment in hours for completing field service repairs within this territory. Used for SLA compliance reporting and customer contract management.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `sla_response_time_hours` DECIMAL(18,2) COMMENT 'Standard SLA response time commitment in hours for initial field service response within this territory. Drives dispatch prioritization and SLA compliance tracking.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this service territory record originated, supporting data lineage and integration traceability in the Databricks Silver Layer.. Valid values are `salesforce_field_service|sap_s4hana|maximo_eam|manual`',
    `state_province` STRING COMMENT 'State, province, or administrative subdivision within the country covered by this service territory (e.g., Bavaria, California, Ontario).',
    `status` STRING COMMENT 'Current operational status of the service territory indicating whether it is actively used for dispatch and scheduling.. Valid values are `active|inactive|pending|suspended`',
    `time_zone` STRING COMMENT 'IANA time zone identifier for the service territory (e.g., Europe/Berlin, America/Chicago), used for scheduling, SLA time calculations, and coverage hour enforcement.',
    `travel_time_limit_minutes` STRING COMMENT 'Maximum acceptable one-way travel time in minutes for a technician dispatched from the service center to a customer site within this territory. Used in dispatch optimization and SLA feasibility checks.. Valid values are `^[0-9]+$`',
    `type` STRING COMMENT 'Classification of the territory indicating its role in the field service network. Primary territories are standard assignments; secondary and overflow handle spillover; temporary territories support project-based deployments.. Valid values are `primary|secondary|overflow|temporary|virtual`',
    CONSTRAINT pk_service_territory PRIMARY KEY(`service_territory_id`)
) COMMENT 'Geographic service territory definitions used to assign field service orders and technicians to customer sites based on location. Captures territory name, territory code, geographic boundaries (country, region, state, city, postal code ranges), assigned service center, territory manager, active technician count, and coverage hours. Supports optimal dispatch routing and workload balancing across the field service network. Used in Salesforce Field Service for territory-based scheduling and capacity planning.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` (
    `dispatch_schedule_id` BIGINT COMMENT 'Unique system-generated identifier for each dispatch schedule record assigning a field service technician to a field service order.',
    `employee_id` BIGINT COMMENT 'Identifier of the dispatcher or scheduling user who created or last modified this dispatch schedule record.',
    `field_service_order_id` BIGINT COMMENT 'Foreign key linking to service.field_service_order. Business justification: dispatch_schedule.field_service_order_number (STRING) is a denormalized reference to field_service_order.order_number. A dispatch schedule record belongs to exactly one field service order — it is the',
    `service_territory_id` BIGINT COMMENT 'Foreign key linking to service.service_territory. Business justification: dispatch_schedule.service_territory (STRING) is a denormalized reference to service_territory. Dispatch scheduling is geographically scoped to a service territory. Adding service_territory_id FK norma',
    `technician_employee_id` BIGINT COMMENT 'Employee identifier of the field service technician assigned to this dispatch schedule, sourced from the workforce management system.',
    `technician_id` BIGINT COMMENT 'Foreign key linking to service.technician. Business justification: Dispatch schedules assign specific technicians to service orders. Links to technician skills, availability, location, and certifications for optimal dispatch decisions and workload balancing.',
    `actual_arrival` TIMESTAMP COMMENT 'Actual datetime when the field service technician arrived at the customer site, captured via mobile check-in or GPS confirmation. Used for SLA adherence measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `actual_departure` TIMESTAMP COMMENT 'Actual datetime when the field service technician departed the customer site after completing or suspending the service activity.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `actual_duration_min` STRING COMMENT 'Actual time in minutes the technician spent on-site performing the service activity, calculated from actual arrival and departure timestamps.. Valid values are `^[0-9]+$`',
    `actual_travel_time_min` STRING COMMENT 'Actual travel time in minutes recorded for the technicians journey to the customer site, used for route optimization analysis and workforce utilization reporting.. Valid values are `^[0-9]+$`',
    `cancellation_reason` STRING COMMENT 'Reason code explaining why a dispatch schedule was cancelled, used for operational analysis, SLA impact assessment, and process improvement.. Valid values are `customer_request|technician_unavailable|parts_unavailable|weather|duplicate|rescheduled|other`',
    `created_timestamp` TIMESTAMP COMMENT 'Datetime when the dispatch schedule record was first created in the source system, used for audit trail and scheduling lead time analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_signature_obtained` BOOLEAN COMMENT 'Indicates whether a customer signature was obtained upon completion of the field service visit, confirming service delivery acceptance.. Valid values are `true|false`',
    `customer_site_name` STRING COMMENT 'Name of the customer facility or site where the field service activity is to be performed, used for dispatch routing and on-site coordination.',
    `dispatcher_notes` STRING COMMENT 'Free-text notes entered by the dispatcher providing additional context, special instructions, or site access information for the assigned technician.',
    `estimated_travel_time_min` STRING COMMENT 'Estimated travel time in minutes from the technicians current location or previous job site to the customer site, calculated by the scheduling optimization engine.. Valid values are `^[0-9]+$`',
    `is_sla_breached` BOOLEAN COMMENT 'Indicates whether the dispatch schedule resulted in an SLA breach, where the actual arrival or completion exceeded the contractual SLA due datetime.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Datetime when the dispatch schedule record was most recently updated in the source system, supporting change tracking and data freshness monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `parts_required` BOOLEAN COMMENT 'Indicates whether spare parts or materials are required to complete the field service activity, used for pre-dispatch parts staging and inventory coordination.. Valid values are `true|false`',
    `priority` STRING COMMENT 'Priority level of the dispatch assignment, influencing scheduling order and resource allocation. Critical priority typically indicates safety or production-impacting issues.. Valid values are `critical|high|medium|low`',
    `required_skill` STRING COMMENT 'Primary skill or certification required to perform the field service activity, used to validate technician qualification and support skill-based scheduling.',
    `reschedule_count` STRING COMMENT 'Number of times this dispatch schedule has been rescheduled, used to identify problematic service orders and measure scheduling stability.. Valid values are `^[0-9]+$`',
    `schedule_number` STRING COMMENT 'Human-readable business reference number for the dispatch schedule record, used for communication between dispatchers, technicians, and customers.. Valid values are `^DSP-[0-9]{4}-[0-9]{6}$`',
    `scheduled_duration_min` STRING COMMENT 'Planned duration in minutes allocated for the service activity, derived from the work type standard duration and used for capacity planning.. Valid values are `^[0-9]+$`',
    `scheduled_end` TIMESTAMP COMMENT 'Planned datetime when the field service technician is expected to complete the service activity, used for scheduling window management and technician utilization.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `scheduled_start` TIMESTAMP COMMENT 'Planned datetime when the field service technician is scheduled to begin the service activity at the customer site, used for SLA compliance and workforce planning.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `scheduling_method` STRING COMMENT 'Method by which the dispatch was scheduled — manual assignment by a dispatcher, auto-optimized by the scheduling engine, or semi-automated with dispatcher override.. Valid values are `manual|auto_optimized|semi_automated`',
    `service_type` STRING COMMENT 'Classification of the field service activity being dispatched, used for workforce planning, SLA tracking, and service analytics.. Valid values are `installation|commissioning|preventive_maintenance|corrective_maintenance|inspection|technical_support|warranty_repair|upgrade|decommissioning`',
    `site_address` STRING COMMENT 'Full street address of the customer site where the field service technician is dispatched, used for navigation and geographic reporting.',
    `site_city` STRING COMMENT 'City of the customer site where the field service activity is scheduled, used for geographic dispatch analysis and territory management.',
    `site_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer site, supporting multinational dispatch operations and regional compliance reporting.. Valid values are `^[A-Z]{3}$`',
    `sla_due` TIMESTAMP COMMENT 'Contractual deadline by which the field service activity must be completed per the applicable SLA agreement, used for breach detection and escalation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `source_system` STRING COMMENT 'Operational system of record from which this dispatch schedule record originated, supporting data lineage and integration traceability.. Valid values are `salesforce_field_service|sap_pm|maximo|manual`',
    `status` STRING COMMENT 'Current operational status of the dispatch schedule, tracking the technicians progression from assignment through completion or cancellation.. Valid values are `scheduled|en_route|on_site|completed|cancelled|rescheduled`',
    `technician_notes` STRING COMMENT 'Free-text notes entered by the field service technician during or after the service visit, capturing observations, actions taken, or follow-up requirements.',
    CONSTRAINT pk_dispatch_schedule PRIMARY KEY(`dispatch_schedule_id`)
) COMMENT 'Scheduling and dispatch records assigning field service technicians to field service orders within defined time windows. Captures the assigned technician, field service order reference, scheduled start datetime, scheduled end datetime, estimated travel time, actual arrival datetime, actual departure datetime, dispatch status (scheduled, en-route, on-site, completed, cancelled), scheduling method (manual, auto-optimized), and dispatcher notes. Sourced from Salesforce Field Service scheduling engine. Enables real-time visibility into technician deployment and field workforce utilization.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`spare_parts_request` (
    `spare_parts_request_id` BIGINT COMMENT 'Unique system-generated identifier for each spare parts request record within the aftermarket service domain.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Field technicians request specific components for repairs. Links service requests to engineering component master to ensure correct parts are dispatched for equipment maintenance.',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: Parts requests specify which equipment CI needs components. Ensures correct part compatibility by referencing CI specifications, and tracks parts consumption per asset for lifecycle cost analysis.',
    `field_service_order_id` BIGINT COMMENT 'Foreign key linking to service.field_service_order. Business justification: spare_parts_request.field_service_order_number (STRING) is a denormalized reference to field_service_order.order_number. Spare parts are requested to fulfill specific field service orders. Adding fiel',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Spare parts consumption posts to specific GL accounts for inventory relief and expense recognition. Finance reconciles parts usage to GL monthly.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Urgent spare parts requests generate emergency POs. Service teams track which PO fulfills their parts request to monitor delivery and expedite critical repairs.',
    `procurement_purchase_requisition_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_requisition. Business justification: Field technicians request spare parts that trigger procurement requisitions. Service operations create PRs daily for parts not in stock to fulfill service orders.',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Field technicians request specific spare parts by SKU for service orders. Links to master product data for accurate fulfillment, pricing, and inventory allocation.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Spare parts requests reference the original equipment sales order to identify correct parts, verify warranty status, and ensure compatibility with installed automation systems. Critical for parts iden',
    `shipment_id` BIGINT COMMENT 'Foreign key linking to logistics.shipment. Business justification: Spare parts for field service must be shipped to technician or customer site. Service operations track shipment status daily to coordinate technician dispatch and customer appointments.',
    `spare_part_id` BIGINT COMMENT 'Foreign key linking to asset.spare_part. Business justification: Service parts requests reference the master spare parts catalog. Links to part specifications, inventory locations, pricing, and compatibility data. Critical for parts fulfillment and inventory manage',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Spare parts requests specify which warehouse to pull inventory from based on technician location and part availability. Dispatch systems use this to optimize routing and minimize service delays.',
    `warranty_claim_id` BIGINT COMMENT 'Foreign key linking to service.warranty_claim. Business justification: spare_parts_request.warranty_claim_number (STRING) is a denormalized reference to warranty_claim.claim_number. Parts may be requested specifically for warranty repair fulfillment. Adding warranty_clai',
    `actual_delivery_date` DATE COMMENT 'Date on which the spare part was physically delivered to the field service technician or service site, used for SLA performance measurement and on-time delivery KPI reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approval_status` STRING COMMENT 'Approval workflow status for the spare parts request, particularly relevant for high-value or restricted parts requiring managerial authorization before warehouse release.. Valid values are `pending|approved|rejected|auto_approved`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time when the spare parts request was approved by the authorized approver, used for SLA measurement of approval cycle time.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `approved_by` STRING COMMENT 'Name or employee ID of the service manager or authorized approver who approved the spare parts request, supporting audit trail and authorization compliance.',
    `bom_position` STRING COMMENT 'Position or item number of the spare part within the equipments Bill of Materials (BOM), enabling structured parts identification and supporting BOM-driven service parts planning.',
    `cost_center` STRING COMMENT 'SAP cost center code to which the spare parts cost is allocated, enabling financial reporting of aftermarket service costs by organizational unit.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the unit cost and total cost are expressed, supporting multi-currency operations across global service regions.. Valid values are `^[A-Z]{3}$`',
    `delivery_address` STRING COMMENT 'Full delivery address for the spare part shipment, which may be the customer site, field technician staging location, or service depot, as specified at the time of request.',
    `delivery_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the delivery destination, used for export compliance, customs documentation, and cross-border logistics management.. Valid values are `^[A-Z]{3}$`',
    `equipment_serial_number` STRING COMMENT 'Serial number of the specific customer equipment unit requiring the spare part, enabling precise asset-level parts consumption tracking and failure pattern analysis.',
    `fulfillment_notes` STRING COMMENT 'Free-text notes entered by warehouse staff or service coordinators regarding fulfillment exceptions, substitutions, partial shipments, or special handling instructions for the spare parts request.',
    `installed_base_reference` STRING COMMENT 'Reference identifier of the customer-installed automation or electrification equipment for which the spare part is being requested, linking the parts demand to the specific asset in the installed base.',
    `part_category` STRING COMMENT 'Technical category of the spare part, used for inventory classification, procurement routing, and aftermarket analytics on parts consumption by category.. Valid values are `mechanical|electrical|electronic|pneumatic|hydraulic|consumable|lubricant|fastener|sensor|software|safety|mro_general`',
    `promised_delivery_date` DATE COMMENT 'Date confirmed by the warehouse or logistics team as the committed delivery date for the spare part, which may differ from the requested delivery date based on stock availability and shipping lead times.. Valid values are `^d{4}-d{2}-d{2}$`',
    `quantity_backordered` DECIMAL(18,2) COMMENT 'Quantity of the spare part that could not be fulfilled from current stock and has been placed on backorder, requiring procurement or inter-warehouse transfer to satisfy the demand.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `quantity_issued` DECIMAL(18,2) COMMENT 'Actual number of units of the spare part physically issued from the warehouse against this request, which may differ from the quantity requested due to partial availability or substitution.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `quantity_requested` DECIMAL(18,2) COMMENT 'Number of units of the spare part requested to fulfill the service order or warranty repair, expressed in the parts base unit of measure.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `request_date` DATE COMMENT 'Calendar date on which the spare parts request was formally submitted by the field service technician or service coordinator.. Valid values are `^d{4}-d{2}-d{2}$`',
    `request_number` STRING COMMENT 'Human-readable business reference number assigned to the spare parts request, used for cross-system tracking and communication with field technicians and warehouse teams.. Valid values are `^SPR-[0-9]{4}-[0-9]{6}$`',
    `request_timestamp` TIMESTAMP COMMENT 'Precise date and time (with timezone) when the spare parts request was created in the system, supporting SLA tracking and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `request_type` STRING COMMENT 'Classification of the spare parts request by the nature of the service demand, distinguishing between field service, warranty repair, preventive maintenance, emergency breakdown, commissioning, upgrade, and MRO replenishment scenarios.. Valid values are `field_service|warranty_repair|preventive_maintenance|emergency_breakdown|commissioning|upgrade|mro_replenishment`',
    `requested_delivery_date` DATE COMMENT 'Date by which the requesting field technician or service coordinator requires the spare part to be delivered to the service site or staging location, used for SLA compliance and logistics planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `service_contract_number` STRING COMMENT 'Reference number of the service contract under which the spare parts request is fulfilled, used to validate entitlement, apply contract pricing, and track contract consumption.',
    `shipment_reference` STRING COMMENT 'Reference number of the outbound shipment or delivery document associated with the physical dispatch of the spare part to the field service location, enabling end-to-end logistics traceability.',
    `shipping_method` STRING COMMENT 'Mode of transportation selected for delivering the spare part to the field service location, influencing freight cost, delivery lead time, and SLA compliance.. Valid values are `standard|express|overnight|same_day|courier|will_call|inter_warehouse_transfer`',
    `source_storage_location` STRING COMMENT 'Specific storage location or bin within the source warehouse from which the spare part is picked, supporting precise inventory management and warehouse execution.',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which the spare parts request originated, supporting data lineage, reconciliation, and multi-system integration in the lakehouse silver layer.. Valid values are `SAP_S4HANA|SALESFORCE_FSM|MAXIMO_EAM|MANUAL|INFOR_WMS`',
    `source_warehouse_code` STRING COMMENT 'Code identifying the warehouse or storage location from which the spare part is to be issued, enabling multi-warehouse fulfillment routing and inventory depletion tracking.',
    `status` STRING COMMENT 'Current lifecycle status of the spare parts request, tracking progression from initial submission through warehouse fulfillment and delivery to the field service location.. Valid values are `draft|submitted|approved|picking|partially_issued|fully_issued|shipped|delivered|cancelled|closed`',
    `substitute_part_number` STRING COMMENT 'Part number of an approved substitute or alternative spare part used when the originally requested part is unavailable, supporting continuity of service and backorder resolution.',
    `total_cost` DECIMAL(18,2) COMMENT 'Total cost of the spare parts request calculated as unit cost multiplied by quantity issued, representing the actual parts cost charged to the service order or warranty claim.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `unit_cost` DECIMAL(18,2) COMMENT 'Standard or moving average cost per unit of the spare part at the time of the request, used for service cost tracking, warranty cost recovery, and aftermarket profitability analysis.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `unit_of_measure` STRING COMMENT 'Standard unit of measure in which the spare part quantity is expressed (e.g., EA for each, KG for kilogram, L for litre), aligned with the material master unit of measure.. Valid values are `EA|PC|KG|L|M|M2|M3|SET|BOX|ROLL|PAIR|PKG`',
    `urgency_level` STRING COMMENT 'Priority classification indicating the operational urgency of the spare parts request, used to drive warehouse picking priority, expedited shipping decisions, and SLA compliance management.. Valid values are `critical|high|medium|low|planned`',
    `warranty_covered` BOOLEAN COMMENT 'Indicates whether the spare part request is covered under an active warranty agreement, determining whether the cost is charged to the customer or absorbed as a warranty liability.. Valid values are `true|false`',
    CONSTRAINT pk_spare_parts_request PRIMARY KEY(`spare_parts_request_id`)
) COMMENT 'Transactional records for spare parts and MRO materials requested to fulfill field service orders and warranty repairs for customer-installed automation and electrification equipment. Captures the originating field service order or warranty claim, requested part number, part description, quantity requested, urgency level, requested delivery date, source warehouse, fulfillment status, actual quantity issued, and shipment reference. Distinct from inventory domain stock management — this entity captures the service-driven demand signal and fulfillment tracking specific to aftermarket operations.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` (
    `spare_parts_catalog_id` BIGINT COMMENT 'Unique surrogate identifier for each spare part record in the aftermarket catalog. Serves as the primary key for the spare_parts_catalog data product in the Databricks Silver Layer.',
    `compliance_reach_substance_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.reach_substance_declaration. Business justification: Parts catalog must declare REACH substances of very high concern (SVHC) in components for EU manufacturing compliance and customer safety data sheet requirements.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Spare parts catalogs list serviceable components from engineering. Service operations reference engineering master data to ensure correct parts are stocked and ordered for field repairs.',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Spare parts catalog entries reference master product SKUs to maintain consistent part numbers, specifications, and inventory tracking across service and manufacturing operations.',
    `rohs_compliance_record_id` BIGINT COMMENT 'Foreign key linking to compliance.rohs_compliance_record. Business justification: Spare parts catalog must track RoHS compliance for electronic components to ensure replacement parts meet EU hazardous substance restrictions for manufacturing equipment.',
    `availability_status` STRING COMMENT 'Current commercial availability status of the spare part in the aftermarket catalog. Drives ordering eligibility, customer portal display, and field service planning. Phase_out indicates the part is being discontinued; on_request means it requires special ordering.. Valid values are `active|phase_out|discontinued|on_request|limited_availability|new|blocked`',
    `catalog_effective_date` DATE COMMENT 'Date from which this spare part record is commercially active and available for ordering in the aftermarket catalog. Used for catalog versioning and price list validity management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `catalog_expiry_date` DATE COMMENT 'Date after which this spare part record is no longer commercially active in the aftermarket catalog. Null if the part has no planned expiry. Used for catalog lifecycle management and phase-out planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `compatible_product_lines` STRING COMMENT 'Comma-separated list or free-text description of specific product lines, model numbers, or series within the product family that are compatible with this spare part. Supports cross-reference lookups in field service and customer portals.',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the spare part was manufactured or substantially transformed. Required for customs declarations, import/export compliance, and trade preference programs.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the spare part record was first created in the aftermarket catalog system. Used for data lineage, audit trails, and catalog change history reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customs_tariff_number` STRING COMMENT 'Harmonized System (HS) tariff classification code assigned to the spare part for customs and import/export compliance. Used in trade documentation, duty calculation, and cross-border shipment declarations.. Valid values are `^[0-9]{6,10}$`',
    `ecn_reference` STRING COMMENT 'Reference to the Engineering Change Notice (ECN) or Engineering Change Order (ECO) that introduced or last modified this spare part in the catalog. Provides traceability to the product engineering change management process.. Valid values are `^ECN-[A-Z0-9-]{3,30}$`',
    `export_control_classification` STRING COMMENT 'Export Control Classification Number (ECCN) or equivalent classification code indicating whether the spare part is subject to export control regulations (e.g., EAR, ITAR). Required for multinational shipments of automation and electrification components.',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether the spare part contains or constitutes a hazardous material requiring special handling, packaging, labeling, and shipping documentation under applicable regulations (e.g., REACH, RoHS, OSHA HazCom, IATA DGR).. Valid values are `true|false`',
    `last_price_update_date` DATE COMMENT 'Date on which the list price for this spare part was last updated in the aftermarket catalog. Supports price audit trails and annual price list revision tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `list_price` DECIMAL(18,2) COMMENT 'Standard commercial list price for the spare part as published in the aftermarket catalog. Represents the base price before any customer-specific discounts or contract pricing. Used as the reference price for quotations and service orders.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `list_price_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the list price (e.g., USD, EUR, GBP). Supports multi-currency operations across global aftermarket regions.. Valid values are `^[A-Z]{3}$`',
    `manufacturer_name` STRING COMMENT 'Name of the original equipment manufacturer (OEM) or approved manufacturer of the spare part. Used for supplier traceability, approved manufacturer list (AML) compliance, and procurement sourcing.',
    `manufacturer_part_number` STRING COMMENT 'The original manufacturers part number for cross-reference purposes. Enables procurement teams and field engineers to source parts from approved manufacturers and verify interchangeability.. Valid values are `^[A-Z0-9-.]{2,50}$`',
    `minimum_order_quantity` DECIMAL(18,2) COMMENT 'Minimum quantity of the spare part that must be ordered per transaction, as defined by the supplier or manufacturing constraints. Enforced during order entry in the service portal and ERP.. Valid values are `^[0-9]+(.[0-9]{1,3})?$`',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the spare part record was last updated in the aftermarket catalog system. Used for incremental data loads, change detection, and audit trail maintenance in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `part_category` STRING COMMENT 'Business category grouping for the spare part within the aftermarket catalog hierarchy (e.g., Electrical, Mechanical, Hydraulic, Electronic, Pneumatic, Safety). Supports catalog navigation and reporting.',
    `part_type` STRING COMMENT 'Classification of the spare part by its functional category within the aftermarket catalog. Drives stocking strategy, pricing rules, and service contract coverage.. Valid values are `consumable|wear_part|spare_part|assembly|kit|tool|accessory|software_license|documentation`',
    `product_family` STRING COMMENT 'The automation system, electrification solution, or smart infrastructure product family for which this spare part is applicable (e.g., SIMATIC S7, SINUMERIK, SINAMICS, SIVACON). Enables field service engineers to filter parts by installed base product family.',
    `reach_compliant_flag` BOOLEAN COMMENT 'Indicates whether the spare part complies with the EU REACH regulation for chemical substance registration, evaluation, and authorization. Required for sale and distribution within the European Union.. Valid values are `true|false`',
    `rohs_compliant_flag` BOOLEAN COMMENT 'Indicates whether the spare part complies with the EU RoHS Directive restricting the use of specific hazardous substances in electrical and electronic equipment. Required for CE Marking and sale in the European Union.. Valid values are `true|false`',
    `service_contract_eligible_flag` BOOLEAN COMMENT 'Indicates whether this spare part is eligible for coverage under service contracts and maintenance agreements. Drives entitlement checks during field service dispatch and warranty claim processing.. Valid values are `true|false`',
    `shelf_life_days` STRING COMMENT 'Maximum number of days the spare part can be stored before it is considered expired or unfit for use, measured from the date of manufacture or receipt. Null if the part has no shelf life restriction. Used by warehouse management for FEFO (First Expired First Out) picking.. Valid values are `^[0-9]{1,5}$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this spare part catalog record originated (e.g., SAP S/4HANA MM, Siemens Teamcenter PLM). Supports data lineage tracking and reconciliation in the lakehouse Silver Layer.. Valid values are `SAP_S4HANA|TEAMCENTER_PLM|SALESFORCE_CRM|MANUAL`',
    `standard_cost` DECIMAL(18,2) COMMENT 'Internal standard cost of the spare part used for inventory valuation, margin analysis, and cost of goods sold (COGS) reporting. Maintained in the ERP cost center and updated during standard cost runs.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `standard_cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the standard cost value (e.g., USD, EUR). Supports multi-currency cost reporting across global manufacturing entities.. Valid values are `^[A-Z]{3}$`',
    `standard_lead_time_days` STRING COMMENT 'Standard number of calendar days from order placement to delivery for this spare part under normal supply conditions. Used for Available-to-Promise (ATP) calculations and customer delivery commitments.. Valid values are `^[0-9]{1,4}$`',
    `storage_conditions` STRING COMMENT 'Prescribed storage requirements for the spare part, including temperature range, humidity limits, light exposure restrictions, and special handling instructions (e.g., Store at 15-25°C, <60% RH, away from direct sunlight). Ensures part integrity during warehousing.',
    `superseded_by_part_number` STRING COMMENT 'Part number of the newer replacement part that supersedes this part in the aftermarket catalog. Represents the forward link in the supersession chain (old part to new part). Null if this part has not been superseded.. Valid values are `^[A-Z0-9-.]{3,40}$`',
    `supersedes_part_number` STRING COMMENT 'Part number of the older part that this part replaces in the aftermarket catalog. Represents the backward link in the supersession chain. Null if this part does not supersede a prior part.. Valid values are `^[A-Z0-9-.]{3,40}$`',
    `unit_of_measure` STRING COMMENT 'Base unit of measure in which the spare part is sold and stocked (e.g., EA=Each, PC=Piece, KG=Kilogram, SET=Set). Drives order quantity calculations and inventory management.. Valid values are `EA|PC|KG|M|L|SET|BOX|ROLL|PAIR|PACK`',
    `warranty_duration_months` STRING COMMENT 'Standard warranty period in months provided for the spare part from the date of installation or delivery. Used to set warranty expiry dates on installed base records and manage warranty claims.. Valid values are `^[0-9]{1,3}$`',
    `weight_kg` DECIMAL(18,2) COMMENT 'Gross weight of the spare part in kilograms, including standard packaging. Used for freight cost calculation, shipping documentation, and dangerous goods declarations.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    CONSTRAINT pk_spare_parts_catalog PRIMARY KEY(`spare_parts_catalog_id`)
) COMMENT 'Master catalog of spare parts and aftermarket components available for service and repair of Manufacturings automation systems, electrification solutions, and smart infrastructure products. Captures part number, part description, compatible product families, supersession chain (old part to new part), list price, lead time, minimum order quantity, hazardous material flag, shelf life, storage conditions, and availability status. Serves as the aftermarket parts reference for field service engineers and customer self-service portals. Complements inventory.sku which manages stock positions — this entity manages the commercial aftermarket catalog definition.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`installation_record` (
    `installation_record_id` BIGINT COMMENT 'Unique system-generated identifier for each installation and commissioning record within the service domain.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Installation records document which components were installed at customer sites. Critical for warranty tracking, service history, and lifecycle management of manufactured equipment.',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: Installation records document deployment of equipment that becomes a tracked configuration item. Creates the initial CI record in CMDB with installation details, establishing asset lifecycle tracking ',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Installation record for customer account - normalize by replacing customer_name text with FK',
    `delivery_id` BIGINT COMMENT 'Foreign key linking to logistics.delivery. Business justification: Equipment installation by field technicians depends on successful delivery of automation systems and components. Installation scheduling directly tied to confirmed delivery completion to avoid technic',
    `environmental_permit_id` BIGINT COMMENT 'Foreign key linking to hse.environmental_permit. Business justification: Equipment installations may require environmental permits (emissions equipment, chemical storage systems, wastewater treatment). Installation record references permit for regulatory compliance verific',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Installation records document when and how equipment was installed. Creates the initial asset record and is referenced for warranty start dates, commissioning data, and baseline configuration.',
    `fai_record_id` BIGINT COMMENT 'Foreign key linking to quality.fai_record. Business justification: First Article Inspection records verify initial production units meet specifications. Installation teams reference FAI records when commissioning first-of-kind installations to ensure quality complian',
    `functional_location_id` BIGINT COMMENT 'Foreign key linking to asset.functional_location. Business justification: Installation records capture where equipment is physically installed. Links equipment to functional location for asset tracking, maintenance planning, and future service dispatch.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Installation work must be traceable to the specific employee who performed it for quality control, warranty validation, safety compliance, and labor cost allocation in manufacturing equipment installa',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Installation records reference the PO that procured the equipment being installed. Required for warranty validation, asset tracking, and compliance documentation in manufacturing installations.',
    `product_certification_id` BIGINT COMMENT 'Foreign key linking to compliance.product_certification. Business justification: Installation records must document that installed equipment has required safety and regulatory certifications (UL, CE, ISO) before commissioning in manufacturing facilities.',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Installation records document which specific product SKU was installed at customer sites. Critical for warranty tracking, maintenance scheduling, and compliance documentation.',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Installation records track equipment deployment from won opportunities. Field service teams install automation systems and infrastructure sold by sales. Links installation to original deal for warrant',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Installation records track commissioning of equipment from specific sales orders. Links installation activities to the original purchase for warranty activation, service history, and project completio',
    `serialized_unit_id` BIGINT COMMENT 'Foreign key linking to inventory.serialized_unit. Business justification: Installation records document which serialized unit was installed at customer site. Essential for tracking equipment lifecycle from inventory through deployment and ongoing service operations.',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to production.work_center. Business justification: Installation records for new equipment/machinery document which work center received the installation. Essential for asset tracking, capacity planning, and warranty service tied to specific work cente',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Exact date and time when the installation and commissioning activity was completed on site, used for duration calculation and service performance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Exact date and time when the installation activity physically commenced on site, used for duration tracking and SLA compliance measurement.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `ce_marking_verified` BOOLEAN COMMENT 'Indicates whether CE marking compliance was verified for the installed product at the time of commissioning, required for products sold in the European Economic Area.. Valid values are `true|false`',
    `checklist_completion_percentage` DECIMAL(18,2) COMMENT 'Percentage of commissioning checklist items that have been completed and verified, providing a quantitative measure of commissioning progress.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `checklist_completion_status` STRING COMMENT 'Status indicating whether the commissioning checklist has been fully completed, partially completed, or completed with noted exceptions, ensuring all installation steps are verified.. Valid values are `not_started|in_progress|completed|completed_with_exceptions`',
    `commissioning_engineer` STRING COMMENT 'Full name or employee identifier of the field engineer responsible for performing the commissioning activity, used for accountability and certification tracking.',
    `commissioning_engineer_certification` STRING COMMENT 'Certification or qualification code held by the commissioning engineer for the specific product type being installed, ensuring regulatory and safety compliance.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the installation record was first created in the system, used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_sign_off_timestamp` TIMESTAMP COMMENT 'Exact date and time when the customer formally signed off on the installation, marking the official acceptance and triggering warranty activation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_signatory_name` STRING COMMENT 'Full name of the customer representative who signed off on the installation acceptance, used for legal and contractual documentation.',
    `fai_date` DATE COMMENT 'Date on which the First Article Inspection (FAI) was conducted at the customer site during commissioning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `fai_report_reference` STRING COMMENT 'Document reference number or URL for the FAI report generated during commissioning, stored in the document management system for traceability.',
    `fai_result` STRING COMMENT 'Outcome of the First Article Inspection (FAI) performed during commissioning to verify that the installed product meets all design and specification requirements before handover.. Valid values are `pass|fail|conditional_pass|not_required|pending`',
    `firmware_version` STRING COMMENT 'Version of the firmware or software loaded onto the product at the time of commissioning, critical for support, patch management, and cybersecurity compliance.',
    `functional_location_code` STRING COMMENT 'Structured code identifying the functional location within the customer plant or facility where the asset is installed, aligned with SAP PM and Maximo EAM hierarchies.',
    `handover_document_reference` STRING COMMENT 'Reference number or document management system link for the installation handover package, including as-built drawings, test reports, manuals, and certificates.',
    `installation_notes` STRING COMMENT 'Free-text field capturing any notable observations, deviations from standard installation procedures, site-specific conditions, or exceptions recorded by the commissioning engineer.',
    `installation_type` STRING COMMENT 'Classification of the installation activity indicating whether it is a new installation, an upgrade to existing equipment, a replacement of a failed unit, a relocation, or a decommission.. Valid values are `new_installation|upgrade|replacement|relocation|decommission`',
    `is_customer_signed_off` BOOLEAN COMMENT 'Indicates whether the customer has formally signed off on the completed installation and commissioning, confirming acceptance of the installed product.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'IETF BCP 47 language code representing the language in which the installation documentation and handover materials were prepared (e.g., en-US, de-DE, zh-CN).. Valid values are `^[a-z]{2}-[A-Z]{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the installation record, supporting audit trail requirements and change tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `ncr_reference` STRING COMMENT 'Reference number of any Non-Conformance Report (NCR) raised during the installation or commissioning process, linking to the quality management system for CAPA tracking.',
    `product_category` STRING COMMENT 'Category of the automation or electrification product being installed, used for service analytics and installed base segmentation.. Valid values are `automation_system|electrification_solution|plc_panel|drive|switchgear|smart_infrastructure|hmi|sensor|motor|transformer|other`',
    `product_sku` STRING COMMENT 'Stock Keeping Unit (SKU) code identifying the specific product model being installed, aligned with the product catalog and ERP master data.',
    `project_reference` STRING COMMENT 'Reference to the associated project or sales order under which the installation was contracted, linking the installation record to the commercial transaction.',
    `record_number` STRING COMMENT 'Human-readable business reference number for the installation record, used in customer communications, handover documents, and service reports.. Valid values are `^IR-[0-9]{4}-[0-9]{6}$`',
    `safety_check_completed` BOOLEAN COMMENT 'Indicates whether all mandatory safety checks and electrical safety tests were completed prior to energizing or commissioning the installed equipment.. Valid values are `true|false`',
    `scheduled_date` DATE COMMENT 'Planned calendar date on which the installation and commissioning activity is scheduled to begin, used for resource planning and customer coordination.. Valid values are `^d{4}-d{2}-d{2}$`',
    `site_address_line1` STRING COMMENT 'Primary street address line of the customer installation site, used for field engineer dispatch and logistics.',
    `site_address_line2` STRING COMMENT 'Secondary address line (suite, floor, building number) of the customer installation site.',
    `site_city` STRING COMMENT 'City where the customer installation site is located, used for regional service analytics and engineer routing.',
    `site_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code of the customer installation site, used for multi-country regulatory compliance and reporting.. Valid values are `^[A-Z]{3}$`',
    `site_name` STRING COMMENT 'Name or designation of the customer site or facility where the product is installed (e.g., Plant A, Building 3, Substation North).',
    `site_postal_code` STRING COMMENT 'Postal or ZIP code of the customer installation site, used for geographic segmentation and field service dispatch optimization.',
    `site_state_province` STRING COMMENT 'State or province of the customer installation site, used for regional compliance and service territory management.',
    `status` STRING COMMENT 'Current lifecycle status of the installation and commissioning activity, from scheduling through customer sign-off and completion.. Valid values are `scheduled|in_progress|commissioned|pending_sign_off|completed|cancelled|on_hold`',
    `warranty_activation_date` DATE COMMENT 'Date on which the product warranty is activated following successful installation and customer sign-off, marking the start of the warranty coverage period.. Valid values are `^d{4}-d{2}-d{2}$`',
    `warranty_expiry_date` DATE COMMENT 'Date on which the product warranty expires, calculated from the warranty activation date based on the contracted warranty period.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_installation_record PRIMARY KEY(`installation_record_id`)
) COMMENT 'Records of product installation and commissioning activities performed at customer sites for automation systems, electrification solutions, PLC panels, drives, switchgear, and smart infrastructure components. Captures installation date, site address, installed product serial number, installation type (new installation, upgrade, replacement), commissioning engineer, commissioning checklist completion status, FAI (First Article Inspection) result, customer sign-off status, handover documentation reference, and warranty activation date. Feeds the installed base registry and triggers warranty start.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`remote_support_session` (
    `remote_support_session_id` BIGINT COMMENT 'Unique system-generated identifier for each remote technical support session conducted by a service engineer to diagnose and resolve issues on customer-installed equipment.',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: Remote support sessions troubleshoot specific equipment tracked as CIs. Support engineers access CI configuration data, firmware versions, and maintenance history to diagnose issues remotely without s',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: remote_support_session.service_contract_number (STRING) is a denormalized reference to service_contract.contract_number. Remote support entitlement and SLA terms are governed by the service contract. ',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Remote support session for customer account - normalize by replacing customer_account_number text with FK',
    `employee_id` BIGINT COMMENT 'Employee identifier of the service engineer assigned to conduct the remote support session, used for workload management, skill utilization reporting, and performance analytics.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Remote support sessions connect to specific equipment for diagnostics and troubleshooting. Technicians access equipment telemetry, configuration, and maintenance history during remote sessions.',
    `ot_system_id` BIGINT COMMENT 'Foreign key linking to technology.ot_system. Business justification: Remote sessions troubleshoot operational technology systems like SCADA, PLCs, and HMIs. Support engineers need OT system architecture, network topology, and control logic to diagnose automation issues',
    `request_id` BIGINT COMMENT 'Foreign key linking to service.service_request. Business justification: remote_support_session.case_number (STRING) is a denormalized reference to service_request.case_number. Remote support sessions are conducted to diagnose and resolve service request cases. Adding serv',
    `support_engineer_employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Remote support sessions for automation systems and smart infrastructure require tracking which engineer provided support for time billing, expertise validation, performance metrics, and customer satis',
    `assigned_engineer_name` STRING COMMENT 'Full name of the service engineer who conducted the remote support session, used for session records, customer communications, and engineer performance reporting.',
    `billing_type` STRING COMMENT 'Billing classification for the remote support session, indicating whether the session is covered under a service contract, billed on time-and-material basis, covered under warranty, or provided as goodwill.. Valid values are `contract_covered|time_and_material|warranty_covered|goodwill|internal|not_billable`',
    `capa_reference` STRING COMMENT 'Reference number of any Corrective and Preventive Action (CAPA) initiated as a result of findings from this remote support session, linking service data to the quality management system.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the remote support session record was created in the system, used for data lineage, audit trail, and Silver layer ingestion tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to the service cost of this remote support session, supporting multi-currency financial reporting in global operations.. Valid values are `^[A-Z]{3}$`',
    `customer_consent_obtained` BOOLEAN COMMENT 'Flag indicating whether explicit customer consent was obtained before initiating remote access to the customers equipment or systems, required for GDPR compliance and cybersecurity audit trails.. Valid values are `true|false`',
    `customer_contact_email` STRING COMMENT 'Email address of the customer contact for the remote support session, used for session notifications, follow-up communications, and satisfaction survey delivery.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `customer_contact_name` STRING COMMENT 'Full name of the customer-side contact person who participated in or authorized the remote support session, required for session records and GDPR-compliant data handling.',
    `customer_satisfaction_score` DECIMAL(18,2) COMMENT 'Post-session customer satisfaction rating collected via survey, scored on a 0-10 scale, used for service quality monitoring, Net Promoter Score (NPS) correlation, and engineer performance evaluation.. Valid values are `^([0-9]|10)(.d{1,2})?$`',
    `diagnostic_steps_performed` STRING COMMENT 'Structured narrative of the diagnostic procedures and troubleshooting steps executed by the support engineer during the remote session, forming the technical audit trail for the session.',
    `equipment_model` STRING COMMENT 'Model designation of the customer-installed equipment being supported remotely, used for routing to the correct specialist engineer and for product-level service analytics.',
    `equipment_serial_number` STRING COMMENT 'Serial number of the specific customer-installed automation or electrification equipment that is the subject of the remote support session, enabling traceability to the installed base record.',
    `escalation_level` STRING COMMENT 'Numeric escalation tier of the remote support session (0=no escalation, 1=team lead, 2=senior engineer, 3=product engineering), tracking escalation depth for service quality and knowledge gap analysis.. Valid values are `^[0-3]$`',
    `follow_up_action_required` STRING COMMENT 'Specifies the type of follow-up action required after the remote support session, such as field technician dispatch, spare part shipment, or scheduled software update, driving downstream work order creation.. Valid values are `none|field_dispatch_required|spare_part_shipment|software_update_scheduled|monitoring_required|customer_training|capa_initiated|other`',
    `is_field_dispatch_required` BOOLEAN COMMENT 'Flag indicating whether a field service technician dispatch is required as a result of this remote support session, directly measuring the remote deflection effectiveness and triggering field service order creation.. Valid values are `true|false`',
    `is_resolved` BOOLEAN COMMENT 'Flag indicating whether the reported issue was fully resolved during the remote support session without requiring a field technician dispatch, the primary metric for remote resolution rate and deflection rate KPIs.. Valid values are `true|false`',
    `is_sla_breached` BOOLEAN COMMENT 'Flag indicating whether the remote support session breached the applicable SLA response or resolution target, used for SLA compliance reporting and customer penalty management.. Valid values are `true|false`',
    `issue_category` STRING COMMENT 'Standardized classification of the technical issue type addressed during the remote support session, enabling trend analysis, root cause categorization, and product quality feedback.. Valid values are `hardware_fault|software_error|configuration_issue|communication_failure|performance_degradation|operator_error|firmware_issue|network_issue|other`',
    `issue_description` STRING COMMENT 'Detailed description of the technical issue or fault reported by the customer that prompted the remote support session, capturing the symptom as observed by the customer or field team.',
    `language_code` STRING COMMENT 'IETF BCP 47 language code representing the language in which the remote support session was conducted (e.g., en-US, de-DE, zh-CN), supporting multilingual service operations in a multinational context.. Valid values are `^[a-z]{2}-[A-Z]{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the remote support session record was last updated, used for change tracking, incremental data pipeline processing, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `priority` STRING COMMENT 'Business priority level assigned to the remote support session, influencing engineer assignment and response urgency in alignment with the customers SLA tier.. Valid values are `critical|high|medium|low`',
    `product_line` STRING COMMENT 'Product line or family to which the supported equipment belongs (e.g., automation systems, electrification solutions, smart infrastructure), used for service analytics and engineer skill routing.',
    `remote_access_method` STRING COMMENT 'Technology or protocol used to establish the remote connection to the customers equipment, such as VPN, SCADA remote access, Siemens MindSphere remote access, or other remote desktop tools. Critical for cybersecurity compliance and session audit trails.. Valid values are `VPN|SCADA_remote|MindSphere_remote_access|TeamViewer|WebEx|RDP|SSH|other`',
    `resolution_code` STRING COMMENT 'Standardized code categorizing the type of resolution applied during the remote support session, enabling resolution pattern analytics and deflection rate measurement.. Valid values are `configuration_change|software_patch|parameter_reset|firmware_update|remote_reboot|operator_guidance|workaround_applied|no_fault_found|escalated_to_field|other`',
    `resolution_description` STRING COMMENT 'Detailed description of the corrective action or fix applied during the remote support session to resolve the reported issue, used for knowledge base population and recurring issue analysis.',
    `root_cause_category` STRING COMMENT 'Standardized classification of the root cause identified for the issue addressed in the remote support session, feeding into CAPA processes and product quality improvement programs.. Valid values are `design_defect|manufacturing_defect|installation_error|operator_error|software_bug|environmental_factor|wear_and_tear|configuration_error|unknown|other`',
    `scheduled_start_timestamp` TIMESTAMP COMMENT 'Date and time when the remote support session was originally scheduled to begin, used for SLA response compliance measurement and comparing planned versus actual session timing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `session_cost` DECIMAL(18,2) COMMENT 'Internal cost of delivering the remote support session including engineer labor time, expressed in the applicable currency, used for service profitability analysis and contract cost tracking.. Valid values are `^[0-9]+(.[0-9]{1,4})?$`',
    `session_duration_minutes` STRING COMMENT 'Total elapsed time in minutes for the remote support session from start to end, captured as a business field from the session management system for engineer utilization and service cost analysis.. Valid values are `^[0-9]+$`',
    `session_end_timestamp` TIMESTAMP COMMENT 'Date and time when the remote support session was formally closed, used together with session start timestamp to calculate session duration and engineer utilization metrics.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `session_number` STRING COMMENT 'Human-readable business reference number for the remote support session, used in customer communications, reporting, and cross-referencing with service requests and field service orders.. Valid values are `^RSS-[0-9]{4}-[0-9]{6}$`',
    `session_recording_available` BOOLEAN COMMENT 'Flag indicating whether a recording of the remote support session is available for quality assurance review, engineer training, or dispute resolution purposes.. Valid values are `true|false`',
    `session_start_timestamp` TIMESTAMP COMMENT 'Date and time when the remote support session was initiated and the engineer established connection to the customers equipment, used for SLA response time measurement and session duration calculation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `session_type` STRING COMMENT 'Classification of the remote support session by its primary purpose, distinguishing between diagnostic, configuration, software update, commissioning support, training, troubleshooting, and preventive check activities.. Valid values are `diagnostic|configuration|software_update|commissioning_support|training|troubleshooting|preventive_check`',
    `site_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer site where the supported equipment is installed, used for regional service reporting, regulatory compliance, and multi-country SLA management.. Valid values are `^[A-Z]{3}$`',
    `site_name` STRING COMMENT 'Name of the customer facility or plant site where the supported equipment is installed, used for geographic service analytics and territory management.',
    `sla_response_target_minutes` STRING COMMENT 'Maximum number of minutes within which a service engineer must initiate the remote support session after the case is raised, as defined by the applicable SLA tier.. Valid values are `^[0-9]+$`',
    `sla_tier` STRING COMMENT 'Service Level Agreement tier applicable to this remote support session, determining response time targets and resolution commitments for the customer.. Valid values are `platinum|gold|silver|bronze|standard|none`',
    `software_version` STRING COMMENT 'Firmware or software version running on the customers equipment at the time of the remote support session, critical for diagnosing software-related issues and determining patch applicability.',
    `status` STRING COMMENT 'Current lifecycle status of the remote support session, tracking progression from scheduling through completion or escalation to field service.. Valid values are `scheduled|in_progress|completed|cancelled|follow_up_required|escalated`',
    `support_team` STRING COMMENT 'Name or code of the service team responsible for the remote support session (e.g., Automation Tier 2, Electrification Remote Support), used for team-level workload and performance analytics.',
    CONSTRAINT pk_remote_support_session PRIMARY KEY(`remote_support_session_id`)
) COMMENT 'Records of remote technical support sessions conducted by service engineers to diagnose and resolve issues on customer-installed automation and electrification equipment without dispatching a field technician. Captures session start and end timestamps, support engineer, customer contact, connected equipment serial number, remote access method (VPN, SCADA remote, MindSphere remote access), issue description, diagnostic steps performed, resolution achieved flag, session outcome, and follow-up action required. Supports deflection rate tracking and remote resolution KPIs.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`report` (
    `report_id` BIGINT COMMENT 'Unique system-generated identifier for the field service completion report. Serves as the primary key for this record across all downstream systems.',
    `employee_id` BIGINT COMMENT 'Foreign key linking to workforce.employee. Business justification: Service reports document who completed the work for accountability, quality audits, customer billing verification, and performance tracking. Critical for warranty claims and compliance documentation i',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Service reports document component performance and failures in the field. Engineering uses this feedback for reliability analysis and design improvements.',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: Service reports document work performed on specific equipment CIs. Creates maintenance history trail in CMDB, enabling predictive maintenance analytics and compliance reporting for industrial equipmen',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: service_report.service_contract_number (STRING) is a denormalized reference to service_contract.contract_number. Service reports reference the governing service contract for billing type determination',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Service report for customer account - normalize by replacing customer_account_number and customer_name with FK',
    `defect_code_id` BIGINT COMMENT 'Foreign key linking to quality.defect_code. Business justification: Field service reports document observed defects using quality defect codes. This enables quality teams to analyze field failure patterns and prioritize improvement initiatives.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Service reports document work performed on specific equipment. Maintenance teams review service history for troubleshooting, reliability analysis, and warranty validation. Core to asset maintenance re',
    `incident_id` BIGINT COMMENT 'Foreign key linking to hse.incident. Business justification: Field service reports document incidents occurring during service delivery (technician injury, equipment damage, customer site incidents). Links service documentation to formal HSE incident investigat',
    `technician_id` BIGINT COMMENT 'Employee or contractor identifier of the primary field service technician who performed the work and authored this report. Used for labor cost allocation, certification tracking, and performance analytics.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the service report was internally approved by a service manager or quality reviewer. Required before invoicing and warranty claim submission.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `billing_type` STRING COMMENT 'Classification of how the service visit will be billed to the customer or charged internally. Determines the invoicing process, revenue recognition treatment, and cost allocation.. Valid values are `contract|time_and_material|warranty|goodwill|internal|no_charge`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which service costs and billing amounts are denominated. Supports multi-currency operations across global service territories.. Valid values are `^[A-Z]{3}$`',
    `customer_acceptance_notes` STRING COMMENT 'Any comments, reservations, or conditions noted by the customer representative at the time of signing the service report. Captures partial acceptance or outstanding concerns that may affect billing or follow-up.',
    `customer_signature_name` STRING COMMENT 'Full name of the customer representative who signed and accepted the service report on-site. Constitutes legal acknowledgment of service completion and is required for billing and warranty claim substantiation.',
    `customer_signed_timestamp` TIMESTAMP COMMENT 'Date and time when the customer representative signed and accepted the service report on-site. Constitutes formal proof of service delivery and triggers billing eligibility.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `date` DATE COMMENT 'Calendar date on which the field service report was completed and submitted by the technician. Used for billing period determination, warranty claim dating, and SLA compliance measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `equipment_condition_found` STRING COMMENT 'Condition of the equipment as assessed by the technician upon arrival at the site, prior to performing any work. Used for failure analysis, warranty assessment, and FMEA data collection.. Valid values are `operational|degraded|failed|unsafe|unknown`',
    `equipment_condition_left` STRING COMMENT 'Condition of the equipment as assessed by the technician upon completion of the service visit. Indicates whether the equipment was fully restored to operational status or requires further action.. Valid values are `operational|degraded|failed|unsafe|requires_follow_up`',
    `equipment_model` STRING COMMENT 'Model or part number of the equipment serviced. Used for spare parts lookup, technical documentation retrieval, and warranty eligibility determination.',
    `equipment_serial_number` STRING COMMENT 'Manufacturer serial number of the primary equipment or asset on which service was performed. Links the report to the installed base record and warranty entitlement.',
    `failure_description` STRING COMMENT 'Technicians description of the fault or failure mode observed on the equipment. Feeds into root cause analysis, FMEA updates, and quality improvement processes.',
    `is_follow_up_required` BOOLEAN COMMENT 'Indicates whether the technician has identified the need for a follow-up service visit or additional work order. When true, a new field service order should be created based on the recommendations.. Valid values are `true|false`',
    `is_safety_incident_reported` BOOLEAN COMMENT 'Indicates whether a safety incident or near-miss was observed and formally reported during the service visit. Triggers mandatory safety incident management workflow per ISO 45001 and OSHA requirements.. Valid values are `true|false`',
    `is_warranty_applicable` BOOLEAN COMMENT 'Indicates whether the service performed is covered under an active product or service warranty. Determines billing treatment and triggers warranty claim processing workflow.. Valid values are `true|false`',
    `labor_hours_total` DECIMAL(18,2) COMMENT 'Total number of labor hours expended by the technician(s) during the service visit, including all activity types. Used for billing, SLA compliance measurement, and workforce productivity analytics.. Valid values are `^d{1,5}(.d{1,2})?$`',
    `language_code` STRING COMMENT 'IETF BCP 47 language code indicating the language in which the service report was authored and presented to the customer (e.g., en-US, de-DE, fr-FR). Supports multinational operations and customer communication requirements.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `number` STRING COMMENT 'Human-readable, business-facing unique identifier for the service report, used in customer communications, billing, and warranty claim substantiation. Typically formatted as SR-YYYY-NNNNNN.. Valid values are `^SR-[0-9]{4}-[0-9]{6}$`',
    `parts_consumed_cost` DECIMAL(18,2) COMMENT 'Total cost of all spare parts and materials consumed during the service visit, in the transaction currency. Used for service billing, warranty cost tracking, and COGS reporting.',
    `parts_replaced_description` STRING COMMENT 'Narrative listing of all spare parts replaced during the service visit, including part numbers, descriptions, and quantities. Used for inventory reconciliation, warranty claim substantiation, and billing.',
    `recommendations` STRING COMMENT 'Technicians recommendations for follow-up work, preventive maintenance actions, spare parts to be stocked, or equipment upgrades identified during the service visit. Drives future service order creation and proactive maintenance planning.',
    `resolution_code` STRING COMMENT 'Standardized code indicating the type of resolution applied during the service visit. Used for service analytics, spare parts consumption reporting, and billing classification.. Valid values are `repaired|replaced|adjusted|cleaned|lubricated|software_updated|calibrated|no_fault_found|deferred|escalated`',
    `root_cause_code` STRING COMMENT 'Standardized code categorizing the root cause of the equipment failure or service need. Used for CAPA initiation, warranty chargeback decisions, and quality trend analysis.. Valid values are `design_defect|manufacturing_defect|installation_error|operator_misuse|wear_and_tear|environmental|software_fault|unknown|other`',
    `safety_observations` STRING COMMENT 'Technicians documented observations regarding safety conditions at the customer site or on the equipment, including hazards identified, PPE used, and any safety incidents or near-misses during the service visit.',
    `site_address` STRING COMMENT 'Full street address of the customer site where the field service was performed. Required for logistics, travel time calculation, and customer-facing documentation.',
    `site_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code of the customer site where service was performed. Drives regulatory compliance requirements, currency, and tax treatment.. Valid values are `^[A-Z]{3}$`',
    `site_name` STRING COMMENT 'Name of the physical location or facility where the field service was performed (e.g., plant name, building name). Used for geographic reporting and installed base management.',
    `status` STRING COMMENT 'Current lifecycle status of the service report, from initial draft by the technician through customer signature, internal approval, and final archival. Drives billing eligibility and warranty claim processing.. Valid values are `draft|submitted|customer_signed|approved|rejected|cancelled`',
    `submitted_timestamp` TIMESTAMP COMMENT 'Precise date and time when the technician formally submitted the completed service report, including timezone offset. Used for SLA resolution time calculation and audit trail.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `technician_certification_number` STRING COMMENT 'Professional certification or qualification number of the technician performing the service, demonstrating competency for the specific equipment type. Required for regulatory compliance and warranty validity.',
    `test_outcome` STRING COMMENT 'Overall outcome of post-service functional testing. A pass result is required for equipment release to operation and warranty validation. Fail or conditional_pass triggers follow-up action.. Valid values are `pass|fail|conditional_pass|not_tested`',
    `test_results_description` STRING COMMENT 'Narrative description of all functional tests, measurements, and performance verifications conducted on the equipment after service completion. Includes pass/fail outcomes and measured values. Required for commissioning sign-off and warranty validation.',
    `travel_time_hours` DECIMAL(18,2) COMMENT 'Number of hours spent by the technician traveling to and from the customer site. Used for billing (if billable travel is included in the service contract), cost allocation, and territory optimization.. Valid values are `^d{1,3}(.d{1,2})?$`',
    `type` STRING COMMENT 'Classification of the service activity documented in this report. Determines applicable billing rates, warranty eligibility, and regulatory documentation requirements.. Valid values are `installation|commissioning|preventive_maintenance|corrective_repair|inspection|warranty_repair|upgrade|decommissioning|technical_support`',
    `work_performed_description` STRING COMMENT 'Detailed narrative of all work performed by the technician during the service visit, including diagnostic steps, repairs, adjustments, and tests conducted. Serves as the official record of service delivery for warranty substantiation and customer proof of service.',
    CONSTRAINT pk_report PRIMARY KEY(`report_id`)
) COMMENT 'Field service completion reports generated by technicians upon completing a field service order at a customer site. Captures the associated field service order, work performed narrative, equipment condition found, parts replaced (part numbers and quantities), labor hours by activity type, test results and measurements, safety observations, customer signature and acceptance, and recommendations for follow-up work. Serves as the official record of service delivery and is shared with the customer as proof of service. Required for warranty claim substantiation and service billing.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`escalation` (
    `escalation_id` BIGINT COMMENT 'Unique system-generated identifier for each service escalation record in the lakehouse silver layer.',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: service_escalation.service_contract_number (STRING) is a denormalized reference to service_contract.contract_number. Escalations are tracked in the context of service contracts, particularly for SLA b',
    `field_service_order_id` BIGINT COMMENT 'Foreign key linking to service.field_service_order. Business justification: Service escalations track field service orders requiring management intervention due to SLA breaches, complexity, or customer dissatisfaction. Critical for service recovery and quality management.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: Critical field failures escalated to R&D trigger investigation projects for root cause analysis and design improvements. Manufacturing quality feedback loop from service to engineering.',
    `service_ticket_id` BIGINT COMMENT 'Foreign key linking to technology.service_ticket. Business justification: Service escalations reference IT service tickets when field service issues require IT infrastructure support. Links operational service problems to IT incident management for integrated resolution tra',
    `business_impact_description` STRING COMMENT 'Narrative description of the business impact on the customer, such as production downtime, safety risk, or revenue loss, used to justify escalation level and prioritization.',
    `capa_reference` STRING COMMENT 'Reference number of the associated Corrective and Preventive Action (CAPA) record raised as a result of this escalation, linking service escalations to the quality management system.',
    `category` STRING COMMENT 'High-level classification of the escalation type, enabling routing to the appropriate resolution team and trend analysis by category.. Valid values are `technical|commercial|logistics|safety|compliance|relationship|warranty|contractual`',
    `closed_timestamp` TIMESTAMP COMMENT 'Date and time when the escalation record was administratively closed after customer confirmation or timeout, completing the escalation lifecycle.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to the estimated revenue at risk and any financial exposure values on the escalation record.. Valid values are `^[A-Z]{3}$`',
    `customer_account_number` STRING COMMENT 'Business account number of the customer associated with the escalation, enabling customer-level escalation trend analysis and account management visibility.',
    `customer_name` STRING COMMENT 'Name of the customer organization associated with the escalation, used for management reporting and executive visibility into high-impact customer situations.',
    `de_escalation_timestamp` TIMESTAMP COMMENT 'Date and time when the escalation was formally de-escalated, meaning the situation was sufficiently resolved to return to normal service handling.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `equipment_serial_number` STRING COMMENT 'Serial number of the specific equipment or asset involved in the escalation, enabling traceability to the installed base and asset history.',
    `escalated_by_name` STRING COMMENT 'Name of the person (service agent, technician, or manager) who formally raised the escalation.',
    `escalated_by_role` STRING COMMENT 'Job role or title of the individual who raised the escalation, providing organizational context for escalation pattern analysis.',
    `escalated_to_individual` STRING COMMENT 'Name of the specific person (senior engineer, manager, or executive) to whom the escalation has been personally assigned.',
    `escalated_to_role` STRING COMMENT 'Job role or title of the individual to whom the escalation is assigned, used for organizational accountability reporting.',
    `escalated_to_team` STRING COMMENT 'Name of the team or group to which the escalation has been assigned for resolution, such as Senior Engineering, Product Support, or Executive Escalations.',
    `estimated_revenue_at_risk` DECIMAL(18,2) COMMENT 'Estimated monetary value of revenue at risk due to the escalation, such as potential contract cancellation or penalty exposure, used for commercial prioritization.',
    `executive_sponsor` STRING COMMENT 'Name of the executive sponsor assigned to oversee the escalation at L3 or L4 level, ensuring senior accountability for high-impact customer situations.',
    `first_response_timestamp` TIMESTAMP COMMENT 'Date and time when the escalated-to team or individual first acknowledged and responded to the escalation, used to measure escalation response time.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `is_customer_notified` BOOLEAN COMMENT 'Indicates whether the customer has been formally notified of the escalation status and actions being taken, supporting customer communication compliance.. Valid values are `true|false`',
    `is_sla_breached` BOOLEAN COMMENT 'Indicates whether the escalation was triggered by or is associated with a breach of the contracted SLA response or resolution time.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time when the escalation record was last updated, supporting audit trail requirements and change tracking in the service management system.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `level` STRING COMMENT 'Severity tier of the escalation ranging from L1 (first-line supervisor) to L4 (executive/C-suite), indicating the organizational level to which the issue has been escalated.. Valid values are `L1|L2|L3|L4`',
    `number` STRING COMMENT 'Human-readable business reference number for the escalation, used in communications, reports, and cross-system tracking.. Valid values are `^ESC-[0-9]{4}-[0-9]{6}$`',
    `priority` STRING COMMENT 'Business priority assigned to the escalation, used to drive response urgency and resource allocation across the service organization.. Valid values are `critical|high|medium|low`',
    `product_line` STRING COMMENT 'Product line or family of the equipment involved in the escalation, used for product-level escalation trend analysis and engineering feedback.',
    `resolution_actions` STRING COMMENT 'Detailed description of the corrective and remediation actions taken to resolve the escalation, including technical fixes, commercial concessions, or process changes.',
    `resolution_type` STRING COMMENT 'Categorized type of resolution applied to close the escalation, enabling analysis of resolution patterns and recurring escalation drivers.. Valid values are `technical_fix|software_patch|part_replacement|on_site_visit|remote_support|commercial_concession|process_change|escalation_to_engineering|workaround|no_fault_found|customer_education`',
    `resolved_timestamp` TIMESTAMP COMMENT 'Date and time when the escalation issue was technically resolved and the resolution was confirmed, marking the end of active escalation work.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `root_cause_category` STRING COMMENT 'High-level categorization of the root cause identified for the escalation, used for CAPA tracking and systemic issue identification across the product portfolio.. Valid values are `product_defect|software_bug|installation_error|operator_error|design_flaw|supply_chain|process_gap|documentation_error|environmental|unknown`',
    `site_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer site where the escalated service issue is occurring, supporting regional escalation reporting and compliance.. Valid values are `^[A-Z]{3}$`',
    `site_region` STRING COMMENT 'Geographic sales or service region of the customer site (e.g., EMEA, APAC, Americas), used for regional management escalation dashboards.',
    `sla_breach_type` STRING COMMENT 'Specifies whether the SLA breach was on the initial response time, the resolution time, or both, enabling targeted SLA performance analysis.. Valid values are `response_breach|resolution_breach|both|none`',
    `sla_tier` STRING COMMENT 'The SLA tier applicable to the originating service request or field service order, determining the contractual response and resolution time obligations.. Valid values are `platinum|gold|silver|bronze|standard`',
    `source_record_number` STRING COMMENT 'The business reference number (case number or field service order number) of the originating service request or field service order that triggered this escalation.',
    `source_record_type` STRING COMMENT 'Indicates whether the escalation originated from a Service Request (case) or a Field Service Order, enabling correct linkage to the originating transaction.. Valid values are `service_request|field_service_order`',
    `status` STRING COMMENT 'Current lifecycle status of the escalation record, tracking its progression from initial raise through resolution and closure.. Valid values are `open|in_progress|pending_customer|pending_engineering|resolved|de_escalated|closed|cancelled`',
    `target_resolution_timestamp` TIMESTAMP COMMENT 'Committed date and time by which the escalation must be resolved, derived from the SLA tier and escalation level, used for management accountability tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `timestamp` TIMESTAMP COMMENT 'Date and time when the escalation was formally raised, used as the start point for escalation response time measurement and SLA tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `trigger_description` STRING COMMENT 'Free-text narrative describing the specific circumstances and context that triggered the escalation, providing detail beyond the trigger reason code.',
    `trigger_reason` STRING COMMENT 'Primary business reason that caused the escalation to be raised, such as SLA breach, customer dissatisfaction, technical complexity, or safety risk.. Valid values are `sla_breach|customer_dissatisfaction|technical_complexity|high_revenue_impact|safety_risk|repeat_failure|executive_request|regulatory_compliance|contractual_penalty|escalation_by_customer`',
    CONSTRAINT pk_escalation PRIMARY KEY(`escalation_id`)
) COMMENT 'Records of formal escalations raised when service requests or field service orders breach SLA thresholds, require senior technical expertise, or involve high-impact customer situations. Captures the originating service request or field service order, escalation trigger reason, escalation level (L1 to L4), escalated-to team or individual, escalation timestamp, target resolution timestamp, escalation status, resolution actions taken, and de-escalation timestamp. Enables management visibility into critical service situations and drives accountability for high-priority customer issues.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`nps_survey` (
    `nps_survey_id` BIGINT COMMENT 'Unique system-generated identifier for each NPS survey record in the service domain. Serves as the primary key for the nps_survey data product.',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: nps_survey.service_contract_number (STRING) is a denormalized reference to service_contract.contract_number. NPS surveys are triggered by service events and are contextually linked to the governing se',
    `field_service_order_id` BIGINT COMMENT 'Foreign key linking to service.field_service_order. Business justification: NPS surveys measure customer satisfaction after field service completion. Links survey responses to specific service interactions for service quality analysis and improvement initiatives.',
    `business_unit` STRING COMMENT 'The internal business unit or division responsible for the service interaction that triggered this NPS survey (e.g., Automation Systems, Electrification Solutions, Smart Infrastructure). Supports BU-level NPS performance management.',
    `campaign_code` STRING COMMENT 'Unique alphanumeric code identifying the NPS campaign. Used for programmatic filtering, segmentation, and integration with CRM campaign management in Salesforce Service Cloud.. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `campaign_name` STRING COMMENT 'Name of the NPS survey campaign under which this survey was dispatched. Campaigns group surveys by service program, product line, or periodic initiative (e.g., Q3-2024 Field Service NPS, Warranty Resolution NPS FY2024).',
    `consent_obtained` BOOLEAN COMMENT 'Indicates whether valid consent was obtained from the customer contact to receive NPS survey communications. Required for GDPR and CCPA compliance in applicable jurisdictions.. Valid values are `true|false`',
    `contact_email` STRING COMMENT 'Email address of the customer contact to whom the NPS survey was dispatched. Used as the primary delivery address for email-channel surveys and for follow-up communications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `contact_name` STRING COMMENT 'Full name of the individual customer contact to whom the NPS survey was dispatched. Used for personalization of survey communications and follow-up actions.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer site where the triggering service event occurred (e.g., DEU, USA, CHN). Supports country-level NPS analysis and regulatory compliance reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the NPS survey record was created in the system. Used for audit trail, data lineage, and compliance with record-keeping requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `customer_account_number` STRING COMMENT 'The business account number of the customer organization associated with this NPS survey. Links the survey to the customer master record for account-level NPS aggregation and reporting.',
    `customer_name` STRING COMMENT 'The name of the customer organization or account associated with this NPS survey. Retained for reporting and operational context without requiring a join to the customer master.',
    `dispatch_channel` STRING COMMENT 'The communication channel through which the NPS survey was sent to the customer contact. Used to analyze response rates and NPS scores by channel to optimize survey delivery strategy.. Valid values are `email|sms|in_app|portal|manual`',
    `dispatch_timestamp` TIMESTAMP COMMENT 'The exact date and time when the NPS survey was dispatched to the customer contact. Used to calculate response lag time and to enforce survey expiry windows.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `expiry_timestamp` TIMESTAMP COMMENT 'The date and time after which the survey link is no longer valid for response submission. Typically set to a fixed window (e.g., 14 or 30 days) after dispatch to ensure timely feedback collection.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `feedback_language_code` STRING COMMENT 'ISO 639-1 language code of the verbatim feedback text (e.g., en, de, fr, zh). Supports multilingual NPS programs across global operations and enables language-specific text analytics.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `follow_up_completed_date` DATE COMMENT 'The date on which the follow-up action with the customer was completed. Used to measure service recovery cycle time and SLA adherence for detractor follow-up programs.. Valid values are `^d{4}-d{2}-d{2}$`',
    `follow_up_owner` STRING COMMENT 'Name or employee identifier of the person responsible for executing the follow-up action with the customer. Assigned when follow_up_required is True, typically a service account manager or customer success representative.',
    `follow_up_required` BOOLEAN COMMENT 'Indicates whether a follow-up action is required based on the survey response. Typically set to True for detractors or responses containing critical feedback keywords. Drives the service recovery workflow.. Valid values are `true|false`',
    `follow_up_status` STRING COMMENT 'Current status of the follow-up action associated with this NPS survey response. Tracks the service recovery process from initiation through resolution for detractor and critical feedback cases.. Valid values are `not_required|pending|in_progress|completed|escalated|cancelled`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent update to the NPS survey record. Used for change tracking, incremental data loading in the Databricks Silver layer, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_reminder_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent reminder notification sent to the customer contact for this survey. Used to enforce minimum intervals between reminders and to prevent over-communication.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `nps_score` STRING COMMENT 'The numeric score provided by the customer on a 0-to-10 scale in response to the standard NPS question: How likely are you to recommend our service to a colleague or partner? Null if no response received.. Valid values are `^([0-9]|10)$`',
    `product_line` STRING COMMENT 'The product line or product family associated with the equipment or solution covered by the triggering service event. Enables NPS analysis by product line to identify product-specific service quality issues.',
    `reminder_count` STRING COMMENT 'Number of reminder notifications sent to the customer contact for this survey. Used to monitor survey fatigue, optimize reminder cadence, and ensure compliance with communication consent policies.. Valid values are `^[0-9]+$`',
    `respondent_category` STRING COMMENT 'Classification of the survey respondent based on their NPS score: Promoter (9-10), Passive (7-8), Detractor (0-6), or No Response. Derived from nps_score at ingestion time and stored for efficient segmentation and reporting.. Valid values are `promoter|passive|detractor|no_response`',
    `response_timestamp` TIMESTAMP COMMENT 'The exact date and time when the customer submitted their NPS survey response. Null if no response has been received. Used to calculate response lag and time-to-respond analytics.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for the customer account associated with this NPS survey. Enables NPS performance reporting aligned to commercial organizational structures.',
    `service_region` STRING COMMENT 'The geographic service region associated with the triggering service event (e.g., EMEA-West, APAC-North, Americas-South). Enables regional NPS benchmarking and performance management.',
    `sla_tier` STRING COMMENT 'The SLA tier applicable to the service contract or entitlement under which the triggering service event was delivered. Enables correlation analysis between SLA tier and NPS outcome.. Valid values are `platinum|gold|silver|bronze|standard|none`',
    `source_system` STRING COMMENT 'The operational system of record from which this NPS survey record originated or was triggered (e.g., Salesforce Service Cloud, SAP S/4HANA). Supports data lineage tracking and audit requirements.. Valid values are `salesforce_service_cloud|sap_s4hana|siemens_opcenter|manual|other`',
    `status` STRING COMMENT 'Current lifecycle status of the NPS survey record. Tracks progression from dispatch through response collection to closure, enabling operational monitoring of survey completion rates.. Valid values are `draft|dispatched|opened|responded|expired|cancelled|closed`',
    `survey_language_code` STRING COMMENT 'ISO 639-1 language code in which the survey was presented to the respondent. Supports localized survey delivery across multinational operations.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `survey_number` STRING COMMENT 'Human-readable business reference number for the NPS survey record, used in communications, reporting, and cross-system traceability. Follows the format NPS-YYYY-NNNNNN.. Valid values are `^NPS-[0-9]{4}-[0-9]{6}$`',
    `trigger_event_reference` STRING COMMENT 'The business reference number of the service event that triggered this survey (e.g., field service order number, warranty claim number, service contract number). Enables traceability back to the originating service transaction.',
    `trigger_event_type` STRING COMMENT 'The type of service event that triggered the dispatch of this NPS survey. Enables segmentation of NPS scores by service interaction type to identify which service touchpoints drive promoter or detractor behavior.. Valid values are `field_service_order_completed|warranty_claim_resolved|service_contract_renewed|installation_completed|commissioning_completed|technical_support_resolved|preventive_maintenance_completed|other`',
    `verbatim_feedback` STRING COMMENT 'Free-text qualitative feedback provided by the customer in response to the open-ended follow-up question (e.g., What is the primary reason for your score?). Used for root cause analysis, service improvement initiatives, and CAPA identification.',
    CONSTRAINT pk_nps_survey PRIMARY KEY(`nps_survey_id`)
) COMMENT 'Net Promoter Score survey campaign definitions and response records collected from customer contacts following key service events such as field service order completion, warranty claim resolution, and service contract renewal. Captures survey trigger event type, survey dispatch timestamp, customer contact reference, NPS score (0-10), promoter/passive/detractor classification, verbatim feedback text, follow-up action flag, and follow-up owner. Distinct from customer.nps_response which captures NPS at the account relationship level — this entity captures service-event-triggered NPS specifically tied to aftermarket service interactions.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`entitlement` (
    `entitlement_id` BIGINT COMMENT 'Unique system-generated identifier for the service entitlement record. Serves as the primary key for the service_entitlement data product in the Databricks Silver Layer.',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: service_entitlement.service_contract_number (STRING) is a denormalized reference to service_contract.contract_number. Service entitlements are granted to customers based on their active service contra',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Service entitlement for customer account - normalize by replacing customer_account_number and customer_name with FK',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Service entitlements define which equipment is eligible for service under warranties or contracts. Service teams validate entitlements before dispatching technicians or processing warranty claims.',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Service entitlements define which specific products customers are entitled to receive service for. Essential for validating service requests and warranty coverage eligibility.',
    `warranty_claim_id` BIGINT COMMENT 'Foreign key linking to service.warranty_claim. Business justification: service_entitlement.warranty_claim_number (STRING) is a denormalized reference to warranty_claim.claim_number. Entitlements can be granted or activated based on warranty claims (e.g., extended warrant',
    `activation_date` DATE COMMENT 'The actual date on which the entitlement was activated and made available for service consumption. May differ from start_date if activation was delayed pending installation or commissioning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether this entitlement is configured to automatically renew upon expiry. Drives renewal workflow triggers in Salesforce Service Cloud and SAP S/4HANA SD.. Valid values are `true|false`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer site or jurisdiction where this entitlement is valid. Supports regional SLA enforcement, regulatory compliance, and territory-based service routing.. Valid values are `^[A-Z]{3}$`',
    `coverage_scope` STRING COMMENT 'Defines what services are covered under this entitlement: parts and labor, labor only, parts only, remote support only, on-site and remote, or preventive maintenance only. Drives billing and dispatch decisions.. Valid values are `parts_and_labor|labor_only|parts_only|remote_support_only|on_site_and_remote|preventive_maintenance_only`',
    `covered_product_family` STRING COMMENT 'The product family or product line covered under this entitlement when coverage applies to a group of products rather than a single SKU (e.g., SIMATIC S7 PLC Series, SINAMIC Drive Family).',
    `covered_product_sku` STRING COMMENT 'The specific product SKU covered under this entitlement. When populated, entitlement validation in Salesforce Service Cloud checks that the case product matches this SKU.',
    `covered_serial_number` STRING COMMENT 'The specific equipment serial number covered under this entitlement. When populated, restricts entitlement consumption to service cases for that specific installed asset.',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when the service entitlement record was first created in the source system. Used for audit trail, data lineage, and entitlement lifecycle reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code applicable to monetary values within this entitlement record (e.g., USD, EUR, GBP). Supports multi-currency operations across global regions.. Valid values are `^[A-Z]{3}$`',
    `end_date` DATE COMMENT 'The date on which the service entitlement expires and the customer is no longer eligible for covered services. Cases submitted after this date are flagged as out-of-entitlement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `incidents_consumed` STRING COMMENT 'The number of service incidents consumed against this entitlement to date. Updated each time a case is validated and accepted under this entitlement. Used to calculate remaining incident balance.. Valid values are `^[0-9]+$`',
    `incidents_remaining` STRING COMMENT 'The number of service incidents remaining available for consumption under this entitlement (total_incidents_allowed minus incidents_consumed). A null value indicates unlimited incidents remain.. Valid values are `^[0-9]+$`',
    `is_transferable` BOOLEAN COMMENT 'Indicates whether this entitlement can be transferred to a new owner upon sale or transfer of the covered equipment. Relevant for installed base management and secondary market support.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent modification to the service entitlement record in the source system. Used for incremental data loading, change detection, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `name` STRING COMMENT 'Descriptive name of the service entitlement as defined in the service contract or warranty agreement (e.g., Gold Support - Automation Line A, Standard Warranty - Drive Series X).',
    `number` STRING COMMENT 'Human-readable business identifier for the service entitlement, used in Salesforce Service Cloud and customer-facing communications to reference a specific entitlement record.. Valid values are `^ENT-[0-9]{4}-[0-9]{6}$`',
    `on_site_support_flag` BOOLEAN COMMENT 'Indicates whether on-site field service visits are included in this entitlement. When true, field service orders can be dispatched under this entitlement without additional billing authorization.. Valid values are `true|false`',
    `owning_business_unit` STRING COMMENT 'The internal business unit or division responsible for fulfilling service obligations under this entitlement (e.g., Automation Services, Electrification Services). Used for cost allocation and P&L reporting.',
    `region` STRING COMMENT 'Geographic service region associated with this entitlement (e.g., EMEA, APAC, AMER). Used for territory management, service capacity planning, and regional KPI reporting.',
    `remote_support_flag` BOOLEAN COMMENT 'Indicates whether remote technical support (phone, email, or remote access) is included in this entitlement. Drives routing logic in Salesforce Service Cloud for case assignment.. Valid values are `true|false`',
    `renewal_date` DATE COMMENT 'The date on which this entitlement is scheduled for renewal review or automatic renewal. Used to trigger renewal notifications and sales follow-up activities.. Valid values are `^d{4}-d{2}-d{2}$`',
    `resolution_time_hours` DECIMAL(18,2) COMMENT 'The maximum number of hours within which a case validated under this entitlement must be fully resolved, as defined by the associated SLA tier.',
    `response_time_hours` DECIMAL(18,2) COMMENT 'The maximum number of hours within which the service team must provide an initial response to a case validated under this entitlement, as defined by the associated SLA tier.',
    `sales_organization` STRING COMMENT 'SAP S/4HANA sales organization code responsible for the service contract or warranty from which this entitlement originates. Supports revenue attribution and organizational reporting.',
    `service_hours_coverage` STRING COMMENT 'The hours of service coverage included in this entitlement (e.g., 24x7 for round-the-clock support, 8x5 for standard business hours). Determines when SLA clocks run and when dispatches can be scheduled.. Valid values are `24x7|business_hours|extended_hours|8x5|8x7|custom`',
    `sla_tier` STRING COMMENT 'The SLA tier associated with this entitlement, defining response and resolution time commitments. Drives automatic SLA milestone assignment when a case is validated against this entitlement in Salesforce Service Cloud.. Valid values are `platinum|gold|silver|bronze|standard|basic`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this entitlement record was sourced (e.g., Salesforce Service Cloud, SAP S/4HANA SD). Supports data lineage tracking in the Databricks Silver Layer.. Valid values are `salesforce|sap_s4hana|manual|migration`',
    `spare_parts_coverage_flag` BOOLEAN COMMENT 'Indicates whether spare parts consumed during service are covered under this entitlement at no additional charge to the customer. Drives parts billing decisions in SAP S/4HANA SD.. Valid values are `true|false`',
    `spare_parts_coverage_limit` DECIMAL(18,2) COMMENT 'Maximum monetary value of spare parts covered under this entitlement per contract period. When the limit is reached, additional parts are billed to the customer. Null indicates no monetary cap.',
    `start_date` DATE COMMENT 'The date on which the service entitlement becomes effective and the customer is eligible to consume entitled services. Used for date-range validation during case entitlement checks.. Valid values are `^d{4}-d{2}-d{2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the service entitlement. Active entitlements allow case creation and service dispatch. Expired or cancelled entitlements block unauthorized service consumption in Salesforce Service Cloud.. Valid values are `active|inactive|expired|pending_activation|suspended|cancelled`',
    `total_incidents_allowed` STRING COMMENT 'The total number of service incidents (cases or field service visits) included in this entitlement. A null value indicates unlimited incidents. Used to enforce consumption limits in Salesforce Service Cloud.. Valid values are `^[0-9]+$`',
    `type` STRING COMMENT 'Classification of the entitlement source: warranty (manufacturer or supplier warranty), service_contract (paid service agreement), support_tier (tiered support subscription), subscription (recurring support plan), extended_warranty (purchased warranty extension), or preventive_maintenance (scheduled PM coverage).. Valid values are `warranty|service_contract|support_tier|subscription|extended_warranty|preventive_maintenance`',
    `value` DECIMAL(18,2) COMMENT 'The total monetary value of services covered under this entitlement for its full duration. Used for revenue recognition, contract profitability analysis, and COGS reporting.',
    CONSTRAINT pk_entitlement PRIMARY KEY(`entitlement_id`)
) COMMENT 'Defines the specific service entitlements granted to customer accounts based on their active service contracts, product warranties, or support tier subscriptions. Captures entitlement name, entitlement type (warranty, contract, support tier), covered product or product family, number of service incidents included, remaining incident balance, entitlement start and end dates, SLA tier reference, and entitlement status. Used in Salesforce Service Cloud to automatically validate whether a customer is entitled to service before a case is accepted, preventing unauthorized service consumption.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`service_price_list` (
    `service_price_list_id` BIGINT COMMENT 'Unique surrogate identifier for each service price list record in the Databricks Silver Layer. Serves as the primary key for all downstream joins and references.',
    `approval_date` DATE COMMENT 'Date on which this service price list entry was formally approved by the designated pricing authority. Required for audit trail and pricing governance compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by` STRING COMMENT 'Name or employee ID of the pricing authority who approved this service price list entry. Supports pricing governance, audit trails, and delegation-of-authority compliance.',
    `condition_type` STRING COMMENT 'SAP S/4HANA SD condition type code that governs how this price list entry is applied in the pricing procedure (e.g., PR00 for base price, ZSU1 for surcharge, ZDI1 for discount). Critical for billing validation.',
    `cost_center` STRING COMMENT 'SAP S/4HANA CO cost center to which service revenue or cost associated with this price list entry is allocated. Supports profitability analysis and COGS tracking for aftermarket service operations.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the geographic market for which this price list is applicable. Supports country-specific labor rates, tax treatment, and regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when this service price list record was first created in the source system. Used for audit trail, data lineage, and change management tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the list price is denominated (e.g., USD, EUR, GBP). Supports multi-currency pricing for global aftermarket operations.. Valid values are `^[A-Z]{3}$`',
    `customer_segment` STRING COMMENT 'Customer classification segment to which this price list applies. Enables differentiated pricing strategies for strategic accounts, OEM partners, distributors, government customers, and standard commercial customers.. Valid values are `all|strategic|preferred|standard|distributor|oem|government|internal`',
    `discount_eligible` BOOLEAN COMMENT 'Indicates whether this price list item is eligible for customer-specific or volume-based discounts. When false, the list price is non-negotiable and applied as-is in service quotations and billing.. Valid values are `true|false`',
    `distribution_channel` STRING COMMENT 'SAP S/4HANA distribution channel for which this price list is valid. Supports differentiated pricing across direct sales, partner/distributor channels, and internal service delivery.. Valid values are `direct|indirect|online|partner|internal`',
    `language_code` STRING COMMENT 'IETF BCP 47 language code for the locale in which the price list name and service item description are maintained (e.g., en, de, fr, zh-CN). Supports multilingual service quotation generation for global operations.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this service price list record in the source system. Supports incremental data loading, change detection, and audit compliance in the Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `list_price` DECIMAL(18,2) COMMENT 'Standard published price for the service item per unit of measure, before any customer-specific discounts or surcharges. Used as the baseline for service quotation generation and billing validation in SAP S/4HANA SD.',
    `max_discount_percent` DECIMAL(18,2) COMMENT 'Maximum allowable discount percentage that can be applied to this price list item during service quotation or billing. Enforces pricing governance and margin protection policies.',
    `minimum_charge` DECIMAL(18,2) COMMENT 'Minimum billable amount for this service item regardless of actual quantity consumed. Commonly applied to call-out fees, minimum labor hours, or minimum parts order values in time-and-material service orders.',
    `name` STRING COMMENT 'Descriptive name of the service price list (e.g., EMEA Field Service Labor FY2025, North America Emergency Surcharge Rate Card). Used for human-readable identification in quotation tools and billing systems.',
    `number` STRING COMMENT 'Business-facing unique identifier for the service price list record, sourced from SAP S/4HANA SD condition record key. Used for referencing in service quotations, billing validation, and audit trails.. Valid values are `^SPL-[A-Z0-9]{4,20}$`',
    `pricing_scale_type` STRING COMMENT 'Indicates whether tiered or volume-based pricing scales apply to this price list entry. Quantity scales reduce unit price at higher volumes; value scales apply at cumulative spend thresholds; time scales apply for extended engagements.. Valid values are `none|quantity_scale|value_scale|time_scale`',
    `product_line` STRING COMMENT 'Product line or portfolio to which this service price list entry applies (e.g., Automation Systems, Electrification Solutions, Smart Infrastructure). Enables product-line-specific pricing for aftermarket services.',
    `profit_center` STRING COMMENT 'SAP S/4HANA CO profit center associated with this price list entry. Enables segment-level profitability reporting for aftermarket service business units.',
    `region` STRING COMMENT 'Geographic region or service territory grouping for which this price list applies (e.g., EMEA, APAC, North America). Used for regional pricing governance and territory-based rate card management.',
    `sales_organization` STRING COMMENT 'SAP S/4HANA sales organization code to which this price list is assigned. Determines the legal entity and organizational unit responsible for the service pricing and revenue booking.',
    `scale_quantity_from` DECIMAL(18,2) COMMENT 'Minimum quantity threshold from which this price list entrys list price applies when pricing scales are in use. Enables volume-based pricing tiers for spare parts and labor hours.',
    `service_category` STRING COMMENT 'Broad category grouping for the service offering, used for reporting, revenue segmentation, and SLA alignment. Distinguishes between on-site field service, remote support, depot-based repair, and managed service contracts.. Valid values are `field_service|remote_service|depot_repair|training|consulting|managed_service`',
    `service_item_code` STRING COMMENT 'SAP S/4HANA material or service item number corresponding to this price list entry. Links the price list to the service product catalog for billing and order management.',
    `service_item_description` STRING COMMENT 'Human-readable description of the service item or spare part associated with this price list entry. Used in customer-facing service quotations and invoices.',
    `service_type` STRING COMMENT 'Classification of the aftermarket service type to which this price list entry applies. Drives pricing logic in time-and-material service orders and service package quotations.. Valid values are `labor|spare_parts|service_package|travel_expense|emergency_surcharge|out_of_hours_surcharge|remote_support|preventive_maintenance|commissioning|inspection`',
    `source_system` STRING COMMENT 'Operational system of record from which this price list record was sourced. Supports data lineage tracking and reconciliation in the Databricks Silver Layer.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL`',
    `status` STRING COMMENT 'Current lifecycle status of the service price list. Controls whether the price list is eligible for use in service quotation generation and billing validation. Superseded indicates a newer version has replaced this record.. Valid values are `draft|active|expired|superseded|withdrawn`',
    `superseded_by` STRING COMMENT 'Price list number of the successor record that replaces this entry when status is superseded. Enables version chain traceability for pricing audit and historical billing validation.',
    `surcharge_percent` DECIMAL(18,2) COMMENT 'Percentage surcharge applied on top of the base list price for emergency, out-of-hours, or hazardous-location service calls. Expressed as a decimal percentage (e.g., 50.00 = 50%). Used in SAP SD condition pricing steps.',
    `tax_classification` STRING COMMENT 'Tax classification of the service item for VAT/GST determination. Drives tax condition determination in SAP S/4HANA SD billing and ensures compliance with local tax regulations across jurisdictions.. Valid values are `taxable|exempt|zero_rated|reduced_rate`',
    `technician_skill_tier` STRING COMMENT 'Skill or certification tier of the field service technician for which this labor rate applies. Enables differentiated billing based on technician competency level, aligned with workforce grading in Kronos and SAP HR.. Valid values are `junior|standard|senior|specialist|master`',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the priced service item. Determines how the list price is applied in billing (e.g., per hour for labor, per unit for spare parts, flat rate for service packages, per km for travel).. Valid values are `hour|day|flat_rate|per_unit|per_km|per_trip|per_visit|per_month|per_year`',
    `valid_from_date` DATE COMMENT 'Start date from which this price list record is effective and can be applied to service quotations and billing. Aligns with SAP S/4HANA SD condition record validity period start.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'End date after which this price list record expires and can no longer be applied to new service quotations or billing. Aligns with SAP S/4HANA SD condition record validity period end.. Valid values are `^d{4}-d{2}-d{2}$`',
    `version_number` STRING COMMENT 'Version identifier for the price list record, supporting change management and audit traceability. Incremented when prices are revised or conditions are updated (e.g., 1.0, 2.3).. Valid values are `^[0-9]+.[0-9]+$`',
    CONSTRAINT pk_service_price_list PRIMARY KEY(`service_price_list_id`)
) COMMENT 'Reference master for aftermarket service pricing including labor rates by technician skill tier and geography, standard service package prices, spare parts list prices, travel and expense rate cards, and emergency/out-of-hours surcharges. Captures price list name, validity period, currency, applicable customer segment or region, service type, unit of measure, list price, and discount eligibility. Used to generate service quotations and validate billing for time-and-material service orders. Managed in SAP S/4HANA SD condition records.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`service_quotation` (
    `service_quotation_id` BIGINT COMMENT 'Unique surrogate identifier for the service quotation record in the lakehouse silver layer. Used as the primary key for all downstream joins and references.',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: service_quotation.service_contract_reference (STRING) is a denormalized reference to service_contract.contract_number. Quotations may be generated for services covered or partially covered under exist',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Service quotation for customer account - normalize by replacing customer_account_number and customer_name with FK',
    `field_service_order_id` BIGINT COMMENT 'Foreign key linking to service.field_service_order. Business justification: service_quotation.service_order_reference (STRING) is a denormalized reference to field_service_order.order_number. Quotations are generated for time-and-material or out-of-warranty service orders. Ad',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Service quotations include specific products or parts being quoted. Links to SKU for accurate pricing, availability, and technical specification inclusion in quotes.',
    `proforma_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.proforma_invoice. Business justification: Service quotations convert to proforma invoices for advance payment requests on large installation or retrofit projects. Service teams reference the proforma to track payment prerequisites before work',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: Service quotations for major maintenance, retrofits, or upgrades link to sales opportunities. Large service projects go through formal sales process. Tracks service quotes that become capital sales op',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Service quotations for upgrades, retrofits, or additional work often reference the original equipment sales order. Provides context on installed base, customer history, and existing configuration for ',
    `service_price_list_id` BIGINT COMMENT 'Foreign key linking to service.service_price_list. Business justification: Service quotations are priced using the service price list (labor rates by skill tier, parts pricing, travel rates). Adding service_price_list_id FK links quotations to the governing price list, enabl',
    `warranty_claim_id` BIGINT COMMENT 'Foreign key linking to service.warranty_claim. Business justification: service_quotation.warranty_claim_reference (STRING) is a denormalized reference to warranty_claim.claim_number. Quotations may be generated for repair work associated with warranty claims that require',
    `accepted_timestamp` TIMESTAMP COMMENT 'Date and time when the customer formally accepted the quotation. Used to measure sales cycle duration, conversion velocity, and to trigger service order creation in SAP S/4HANA.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `assigned_sales_representative` STRING COMMENT 'Name or employee ID of the sales or service account manager responsible for preparing and managing this quotation. Used for pipeline ownership, commission calculation, and performance reporting.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer site or delivery location for the quoted service. Supports regional revenue reporting, tax jurisdiction determination, and regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when the service quotation record was first created in SAP S/4HANA SD. Used for audit trail, data lineage, and pipeline aging calculations.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the quotation amounts are expressed (e.g., USD, EUR, GBP). Supports multi-currency operations across global service territories.. Valid values are `^[A-Z]{3}$`',
    `customer_reference_number` STRING COMMENT 'Customer-provided purchase order number, inquiry reference, or internal reference number associated with this quotation request. Enables cross-referencing with customer procurement systems and facilitates order conversion.',
    `date` DATE COMMENT 'Calendar date on which the service quotation was formally created and issued to the customer. Used for pipeline aging analysis and revenue forecasting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Absolute monetary value of the discount applied to the quotation. Derived from discount percentage applied to gross amount; stored explicitly for reporting and audit purposes.',
    `discount_percent` DECIMAL(18,2) COMMENT 'Percentage discount applied to the gross quotation amount as approved per pricing authority guidelines. Supports discount governance, margin protection, and pricing analytics.. Valid values are `^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$`',
    `distribution_channel` STRING COMMENT 'SAP distribution channel through which the service or spare parts are being offered. Influences pricing conditions, commission structures, and revenue reporting segmentation.. Valid values are `direct|partner|distributor|online|field_service`',
    `division` STRING COMMENT 'SAP division representing the product or service line being quoted (e.g., automation, electrification, smart infrastructure). Supports P&L reporting and aftermarket revenue attribution by business unit.',
    `equipment_serial_number` STRING COMMENT 'Serial number of the primary piece of equipment or installed base asset for which the service is being quoted. Links the quotation to the asset lifecycle and warranty records.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign exchange rate applied to convert the quotation currency to the company code local currency at the time of quotation creation. Required for multi-currency financial consolidation and reporting.',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total gross value of the quotation before application of any discounts or taxes. Sum of all line item values (labor, parts, travel, and other charges). Used as the baseline for discount and margin calculations.',
    `incoterms` STRING COMMENT 'International Commercial Terms (Incoterms) defining the transfer of risk and responsibility for spare parts delivery included in the quotation. Applicable for quotations involving physical goods shipment.. Valid values are `EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF`',
    `labor_amount` DECIMAL(18,2) COMMENT 'Total quoted value for labor line items including field engineer time, technician hours, and remote support. Component of the overall quotation value used for cost-of-service analysis.',
    `language_code` STRING COMMENT 'ISO 639-1 language code in which the quotation document is issued to the customer (e.g., en, de, fr, zh). Supports multi-language document generation for global aftermarket operations.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp of the most recent update to the service quotation record. Supports incremental data loading in the Databricks lakehouse silver layer and change data capture.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `net_amount` DECIMAL(18,2) COMMENT 'Total net value of the quotation after discount, excluding taxes. Represents the commercial value of the service engagement and is the primary metric for aftermarket revenue pipeline reporting.',
    `number` STRING COMMENT 'Business-facing unique quotation number generated by SAP S/4HANA SD at the time of quotation creation. Used for customer communication, order conversion tracking, and aftermarket revenue pipeline reporting.. Valid values are `^QT-[0-9]{4}-[0-9]{6}$`',
    `parts_amount` DECIMAL(18,2) COMMENT 'Total quoted value for spare parts and materials line items. Supports aftermarket parts revenue tracking and margin analysis by service type.',
    `payment_terms` STRING COMMENT 'Commercial payment terms offered to the customer for this quotation (e.g., Net 30, 50% advance + 50% on completion). Influences cash flow forecasting and credit risk assessment.',
    `product_model_number` STRING COMMENT 'Model or part number of the primary product or equipment being serviced. Used for spare parts compatibility checks, service catalog pricing, and installed base analytics.',
    `rejection_reason` STRING COMMENT 'Reason code capturing why the quotation was rejected or lost. Supports win/loss analysis, competitive intelligence, and pricing strategy refinement for aftermarket services.. Valid values are `price_too_high|competitor_selected|budget_constraints|scope_mismatch|no_response|internal_cancellation|other`',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for issuing and managing this quotation. Determines pricing procedures, output determination, and revenue booking entity for aftermarket sales.',
    `service_scope_description` STRING COMMENT 'Free-text description of the service scope included in the quotation, covering work to be performed, equipment covered, deliverables, and any exclusions. Serves as the commercial basis for the service order upon acceptance.',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this quotation record was ingested into the lakehouse. Supports data lineage tracking and multi-source reconciliation.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL`',
    `status` STRING COMMENT 'Current lifecycle status of the service quotation. Drives pipeline stage reporting, win/loss analysis, and conversion rate KPIs for aftermarket revenue management.. Valid values are `draft|submitted|accepted|rejected|expired|cancelled|revised`',
    `submitted_timestamp` TIMESTAMP COMMENT 'Date and time when the quotation was formally submitted to the customer. Used for SLA compliance tracking on quotation turnaround time and pipeline velocity analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applicable to the quotation based on the customers tax jurisdiction and applicable tax codes. Required for statutory reporting and customer invoice accuracy.',
    `travel_amount` DECIMAL(18,2) COMMENT 'Total quoted value for travel and expenses line items including transportation, accommodation, and per diem costs. Enables travel cost recovery tracking and profitability analysis.',
    `type` STRING COMMENT 'Classification of the service engagement being quoted. Distinguishes between out-of-warranty repairs, time-and-material (T&M) engagements, service contract renewals, and spare parts supply to support aftermarket revenue segmentation.. Valid values are `out_of_warranty_repair|time_and_material|service_contract_renewal|spare_parts_supply|commissioning|upgrade|inspection`',
    `validity_end_date` DATE COMMENT 'Date after which the quotation expires and is no longer commercially binding. Drives automated expiry status transitions and pipeline cleanup in aftermarket revenue tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `validity_start_date` DATE COMMENT 'Date from which the quoted prices, terms, and scope are commercially valid and binding. Marks the beginning of the acceptance window.. Valid values are `^d{4}-d{2}-d{2}$`',
    `version_number` STRING COMMENT 'Incremental version counter tracking revisions to the quotation. Enables audit trail of changes to scope, pricing, or terms across the quotation lifecycle.. Valid values are `^[0-9]+$`',
    CONSTRAINT pk_service_quotation PRIMARY KEY(`service_quotation_id`)
) COMMENT 'Commercial quotation records generated for customers for out-of-warranty repairs, time-and-material service engagements, service contract renewals, and spare parts supply. Captures quotation number, quotation date, validity date, customer reference, quoted service scope, line items (labor, parts, travel), total quoted value, currency, discount applied, quotation status (draft, submitted, accepted, rejected, expired), and conversion to service order reference. Managed in SAP S/4HANA SD. Supports aftermarket revenue pipeline tracking.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`service_invoice` (
    `service_invoice_id` BIGINT COMMENT 'Unique surrogate identifier for the service invoice record in the lakehouse silver layer. Primary key for this entity.',
    `ar_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ar_invoice. Business justification: Service invoices generate accounts receivable entries that finance tracks for revenue recognition and collections. Billing department reconciles service charges to AR daily.',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: service_invoice.service_contract_number (STRING) is a denormalized reference to service_contract.contract_number. Service invoices are generated for billable services rendered under service contracts.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Service invoice for customer account - normalize by replacing customer_account_number and customer_name with FK',
    `field_service_order_id` BIGINT COMMENT 'Foreign key linking to service.field_service_order. Business justification: service_invoice.field_service_order_number (STRING) is a denormalized reference to field_service_order.order_number. Invoices are generated to bill for labor, parts, and travel costs incurred during f',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Service invoices for warranty work, installation, or commissioning reference the original sales order for billing validation, warranty cost allocation, and revenue recognition in manufacturing service',
    `warranty_claim_id` BIGINT COMMENT 'Foreign key linking to service.warranty_claim. Business justification: service_invoice.warranty_claim_number (STRING) is a denormalized reference to warranty_claim.claim_number. Invoices may be generated for out-of-warranty or partially covered warranty claim resolutions',
    `billing_category` STRING COMMENT 'Primary category of aftermarket service being billed. Enables revenue segmentation by service type for aftermarket P&L reporting.. Valid values are `field_service_labor|spare_parts|travel_expense|contract_periodic|installation|commissioning|remote_support|training|inspection`',
    `billing_period_end_date` DATE COMMENT 'End date of the service period covered by this invoice. Used alongside billing_period_start_date to define the service delivery window for contract billing.. Valid values are `^d{4}-d{2}-d{2}$`',
    `billing_period_start_date` DATE COMMENT 'Start date of the service period covered by this invoice. Critical for periodic service contract charges and revenue recognition alignment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `company_code` STRING COMMENT 'SAP company code representing the legal entity issuing the invoice. Determines the chart of accounts, fiscal year variant, and tax jurisdiction for the invoice.. Valid values are `^[A-Z0-9]{1,10}$`',
    `cost_center` STRING COMMENT 'SAP cost center associated with the service delivery costs for this invoice. Used for cost of goods sold (COGS) allocation in aftermarket service reporting.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer site where the service was rendered. Determines tax jurisdiction, regulatory compliance, and regional reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the invoice record was first created in SAP S/4HANA SD/FI. Used for audit trail, SLA measurement, and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `discount_amount` DECIMAL(18,2) COMMENT 'Total discount applied to the invoice, including contract-based discounts, volume rebates, or promotional deductions.',
    `dispute_reason` STRING COMMENT 'Reason code for customer-raised invoice disputes. Supports dispute resolution workflows and root cause analysis for billing quality improvement.. Valid values are `pricing_error|service_not_rendered|duplicate_invoice|warranty_coverage|parts_quality|quantity_discrepancy|other`',
    `dunning_date` DATE COMMENT 'Date on which the most recent dunning notice was issued to the customer for this overdue invoice. Null if no dunning has been triggered.. Valid values are `^d{4}-d{2}-d{2}$`',
    `dunning_level` STRING COMMENT 'Current dunning escalation level for overdue invoices (0=no dunning, 1-4=escalating reminder levels). Drives automated payment reminder and collections workflows in SAP FI.. Valid values are `^[0-4]$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'Foreign currency exchange rate applied at invoice creation time for conversion to company code currency. Required for multi-currency financial consolidation.',
    `gl_account_code` STRING COMMENT 'SAP general ledger account to which the service revenue is posted. Ensures correct financial statement classification for aftermarket revenue.. Valid values are `^[0-9]{1,10}$`',
    `gross_amount` DECIMAL(18,2) COMMENT 'Total invoice amount inclusive of all taxes. Represents the total amount payable by the customer.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the invoice record in the source system. Supports incremental data loading and change data capture in the lakehouse pipeline.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `net_amount` DECIMAL(18,2) COMMENT 'Total invoice amount before taxes and after all discounts. Represents the net revenue recognized for the service rendered.',
    `paid_amount` DECIMAL(18,2) COMMENT 'Cumulative amount received against this invoice to date. Enables partial payment tracking and outstanding balance calculation for accounts receivable.',
    `payment_date` DATE COMMENT 'Date on which full or final payment was received and cleared against this invoice in SAP FI. Null if invoice is unpaid or partially paid.. Valid values are `^d{4}-d{2}-d{2}$`',
    `payment_due_date` DATE COMMENT 'Date by which the customer must remit payment to avoid late payment penalties or dunning actions. Derived from invoice date and payment terms.. Valid values are `^d{4}-d{2}-d{2}$`',
    `payment_terms` STRING COMMENT 'SAP payment terms key defining the due date calculation and early payment discount conditions (e.g., NT30, 2/10NET30). Drives accounts receivable dunning.. Valid values are `^[A-Z0-9]{1,10}$`',
    `profit_center` STRING COMMENT 'SAP profit center to which the service revenue is attributed. Enables aftermarket service P&L reporting by business unit or product line.. Valid values are `^[A-Z0-9-]{1,20}$`',
    `reference_document_number` STRING COMMENT 'Reference to the originating SAP document (e.g., sales order, service order, or delivery note) that triggered this invoice. Provides end-to-end order-to-cash traceability.. Valid values are `^[A-Z0-9-]{1,40}$`',
    `sales_organization` STRING COMMENT 'SAP sales organization responsible for the service sale. Determines pricing procedures, revenue assignment, and regional reporting hierarchy.. Valid values are `^[A-Z0-9]{1,10}$`',
    `source_system` STRING COMMENT 'Identifier of the operational system of record from which this invoice record originated. Supports data lineage and multi-system reconciliation in the silver layer.. Valid values are `SAP_S4HANA|SALESFORCE_CRM|MANUAL`',
    `status` STRING COMMENT 'Current lifecycle status of the service invoice. Drives accounts receivable workflows, dunning processes, and revenue recognition in SAP FI.. Valid values are `draft|posted|sent|partially_paid|paid|overdue|cancelled|disputed|written_off`',
    `tax_amount` DECIMAL(18,2) COMMENT 'Total tax amount applied to the invoice, including VAT, GST, or sales tax as applicable by jurisdiction. Calculated based on tax codes assigned in SAP FI.',
    `tax_code` STRING COMMENT 'SAP tax code determining the applicable tax rate and tax account assignment for the invoice. Varies by country and service type for VAT/GST compliance.. Valid values are `^[A-Z0-9]{1,10}$`',
    `type` STRING COMMENT 'Classification of the invoice document type. Distinguishes standard billing, credit/debit adjustments, proforma invoices for customs, cancellations, and periodic contract charges.. Valid values are `standard|credit_memo|debit_memo|proforma|cancellation|periodic_contract`',
    CONSTRAINT pk_service_invoice PRIMARY KEY(`service_invoice_id`)
) COMMENT 'Billing records for aftermarket services rendered including field service labor, spare parts supplied, travel expenses, and service contract periodic charges. Captures invoice number, invoice date, billing period, customer account reference, service contract or field service order reference, line items (service type, quantity, unit price, amount), total amount, tax amount, currency, payment terms, payment due date, and payment status. Managed in SAP S/4HANA SD/FI. Distinct from billing.invoice which is the enterprise-wide billing SSOT — this entity captures service-domain-specific invoice origination data before consolidation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`knowledge_article` (
    `knowledge_article_id` BIGINT COMMENT 'Unique system-generated identifier for each knowledge article in the technical knowledge base.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the article author, used for accountability tracking and author performance analytics.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Knowledge articles provide troubleshooting and repair procedures for specific components. Service teams reference engineering component data to access correct technical documentation.',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Knowledge articles provide troubleshooting and repair guidance for specific products. Linking to SKU enables technicians to find relevant documentation quickly during service calls.',
    `applicable_firmware_version` STRING COMMENT 'Firmware or software version range to which this article applies, ensuring technicians apply the correct resolution for the installed firmware on the equipment.',
    `applicable_product_skus` STRING COMMENT 'Comma-separated list of specific Stock Keeping Unit (SKU) identifiers for products to which this article applies, enabling precise product-level filtering in service workflows.',
    `article_number` STRING COMMENT 'Human-readable business identifier for the knowledge article, used for cross-referencing in service cases, field service orders, and customer portals.. Valid values are `^KA-[0-9]{8}$`',
    `author_name` STRING COMMENT 'Full name of the service engineer or product specialist who authored the knowledge article.',
    `country_code` STRING COMMENT 'ISO 3166-1 Alpha-3 country code indicating the primary country context for which this article was authored, relevant for country-specific regulatory or product variants.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the knowledge article record was first created in the source system, used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `error_codes` STRING COMMENT 'Comma-separated list of system error codes, fault codes, or alarm identifiers (from PLC, SCADA, MES, or HMI systems) that this article addresses, enabling automated article suggestion.',
    `expiry_date` DATE COMMENT 'Date after which the knowledge article is considered outdated and must be reviewed, updated, or retired. Supports document lifecycle management per ISO 9001.. Valid values are `^d{4}-d{2}-d{2}$`',
    `helpful_votes` STRING COMMENT 'Number of times users have rated the article as helpful, used to assess article quality and prioritize content improvement efforts.. Valid values are `^[0-9]+$`',
    `language_code` STRING COMMENT 'IETF BCP 47 language tag indicating the language in which the article is authored (e.g., en-US, de-DE, zh-CN), supporting multinational service operations.. Valid values are `^[a-z]{2}-[A-Z]{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the knowledge article record, supporting change tracking and content freshness monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_reviewed_date` DATE COMMENT 'Date on which the article was most recently reviewed for technical accuracy and relevance by a subject matter expert.. Valid values are `^d{4}-d{2}-d{2}$`',
    `linked_case_count` STRING COMMENT 'Number of service request cases that have referenced or been resolved using this knowledge article, indicating its operational impact on first-call resolution rates.. Valid values are `^[0-9]+$`',
    `not_helpful_votes` STRING COMMENT 'Number of times users have rated the article as not helpful, used to identify articles requiring revision or retirement.. Valid values are `^[0-9]+$`',
    `product_category` STRING COMMENT 'Broader product category classification (e.g., Automation Systems, Electrification Solutions, Smart Infrastructure) to support cross-product knowledge discovery.',
    `product_family` STRING COMMENT 'The product family or product line to which this knowledge article applies (e.g., SIMATIC S7 PLCs, SINAMIC Drives, SIVACON Switchgear), enabling filtering by product scope.',
    `publication_date` DATE COMMENT 'Date on which the knowledge article was officially published and made available to its intended audience.. Valid values are `^d{4}-d{2}-d{2}$`',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether the article addresses regulatory compliance requirements such as CE Marking, RoHS, REACH, or UL certification procedures.. Valid values are `true|false`',
    `related_part_numbers` STRING COMMENT 'Comma-separated list of spare part numbers or Bill of Materials (BOM) components referenced in the resolution steps, linking the article to the spare parts catalog.',
    `resolution_steps` STRING COMMENT 'Step-by-step instructions for resolving the issue, performing the repair procedure, or executing the described process, authored by service engineers or product specialists.',
    `review_comments` STRING COMMENT 'Reviewer feedback, revision notes, or approval comments recorded during the technical review process.',
    `review_status` STRING COMMENT 'Current status of the editorial and technical review process for the knowledge article prior to publication.. Valid values are `pending_review|under_review|approved|rejected|revision_required`',
    `reviewer_name` STRING COMMENT 'Full name of the subject matter expert or quality reviewer who approved the article for publication.',
    `root_cause` STRING COMMENT 'Documented root cause of the issue or failure addressed by this article, derived from field investigations and Corrective and Preventive Action (CAPA) analysis.',
    `safety_advisory_flag` BOOLEAN COMMENT 'Indicates whether this article contains safety-critical information requiring mandatory compliance, such as electrical safety warnings, lockout/tagout procedures, or OSHA-regulated hazard notifications.. Valid values are `true|false`',
    `search_keywords` STRING COMMENT 'Comma-separated list of keywords and tags that enhance discoverability of the article in knowledge base search, including error codes, product names, and symptom terms.',
    `service_territory_scope` STRING COMMENT 'Geographic or regional scope for which this article is applicable (e.g., specific country codes or regions), supporting localized service delivery and regulatory variation.',
    `source_system` STRING COMMENT 'Operational system of record from which this knowledge article was sourced or ingested into the lakehouse (e.g., Salesforce Knowledge, Siemens Teamcenter PLM).. Valid values are `salesforce_knowledge|teamcenter|manual|migrated`',
    `status` STRING COMMENT 'Current lifecycle status of the knowledge article from authoring through publication and eventual retirement.. Valid values are `draft|in_review|approved|published|archived|retired`',
    `symptom_description` STRING COMMENT 'Detailed description of the observable symptoms, fault conditions, or error codes that trigger the need for this knowledge article, used for search and first-call resolution matching.',
    `title` STRING COMMENT 'Descriptive title of the knowledge article summarizing the issue, procedure, or topic covered.',
    `type` STRING COMMENT 'Classification of the article by its content purpose: troubleshooting guide, repair procedure, product bulletin, FAQ, installation guide, best practice, safety advisory, or software release note.. Valid values are `troubleshooting_guide|repair_procedure|product_bulletin|faq|installation_guide|best_practice|safety_advisory|software_release_note`',
    `usage_count` STRING COMMENT 'Total number of times the knowledge article has been accessed or referenced by service engineers and customers, used to measure article effectiveness and first-call resolution impact.. Valid values are `^[0-9]+$`',
    `version_number` STRING COMMENT 'Version identifier of the knowledge article following major.minor versioning convention, tracking revisions and updates over the article lifecycle.. Valid values are `^d+.d+$`',
    `visibility` STRING COMMENT 'Defines the audience scope for the article: internal service engineers only, partner network, customer self-service portal, or publicly accessible.. Valid values are `internal_only|partner|customer_portal|public`',
    CONSTRAINT pk_knowledge_article PRIMARY KEY(`knowledge_article_id`)
) COMMENT 'Technical knowledge base articles authored by service engineers and product specialists to document solutions to common field issues, troubleshooting procedures, product-specific repair guides, and best practices for automation and electrification products. Captures article title, article type (troubleshooting guide, repair procedure, product bulletin, FAQ), applicable product family, symptom description, root cause, resolution steps, related part numbers, author, review status, publication date, and usage count. Enables first-call resolution improvement and supports self-service customer portals.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`feedback` (
    `feedback_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each service feedback record in the Silver layer lakehouse.',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: service_feedback.service_contract_number (STRING) is a denormalized reference to service_contract.contract_number. Customer feedback is collected in the context of service interactions governed by ser',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Service feedback from customer account - normalize by replacing customer_account_number and customer_name with FK',
    `field_service_order_id` BIGINT COMMENT 'Foreign key linking to service.field_service_order. Business justification: Customer feedback is collected for completed field service orders. Links satisfaction ratings and comments to specific service events for quality tracking and technician performance evaluation.',
    `innovation_pipeline_id` BIGINT COMMENT 'Foreign key linking to research.innovation_pipeline. Business justification: Customer feedback from field service drives innovation pipeline entries for product enhancements and new features. Voice-of-customer input directly feeds R&D prioritization in manufacturing.',
    `assigned_technician_name` STRING COMMENT 'Name of the field service technician or support engineer who delivered the service interaction, used for technician-level performance analysis and coaching.',
    `capa_reference` STRING COMMENT 'Reference number of the Corrective and Preventive Action (CAPA) record initiated as a result of this feedback, linking service quality issues to formal improvement actions.',
    `collection_channel` STRING COMMENT 'Channel through which the customer feedback was solicited and received (e.g., email survey, web portal, automated IVR call, mobile app).. Valid values are `email|sms|web_portal|mobile_app|phone|in_person|automated_ivr`',
    `collection_date` DATE COMMENT 'Calendar date on which the customer satisfaction feedback was collected following the service interaction.. Valid values are `^d{4}-d{2}-d{2}$`',
    `collection_timestamp` TIMESTAMP COMMENT 'Precise date and time at which the feedback was submitted or recorded, supporting SLA measurement and response time analytics.',
    `communication_rating` STRING COMMENT 'Customer rating (1–5) of the clarity, timeliness, and quality of communication throughout the service interaction, including updates and explanations.. Valid values are `^[1-5]$`',
    `consent_to_publish_flag` BOOLEAN COMMENT 'Indicates whether the customer has provided explicit consent for their feedback or testimonial to be used in marketing or public-facing communications, required under GDPR and CCPA.. Valid values are `true|false`',
    `contact_email` STRING COMMENT 'Email address of the customer contact who submitted the feedback, used for follow-up communication and survey delivery tracking.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `contact_name` STRING COMMENT 'Full name of the individual customer contact who provided the feedback, used for personalized follow-up and PII governance.',
    `contact_phone` STRING COMMENT 'Phone number of the customer contact who provided the feedback, used for follow-up calls when escalation or clarification is required.. Valid values are `^+?[0-9s-().]{7,20}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer site where the service was delivered, enabling geographic CSAT analysis and regional service quality benchmarking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the feedback record was first created in the source system, used for data lineage, audit trail, and SLA measurement.',
    `equipment_serial_number` STRING COMMENT 'Serial number of the specific equipment or installed asset that was serviced, linking feedback to the installed base for asset-level service quality tracking.',
    `follow_up_completed_date` DATE COMMENT 'Date on which the follow-up action for this feedback was completed and closed, used to measure responsiveness to customer dissatisfaction.. Valid values are `^d{4}-d{2}-d{2}$`',
    `follow_up_required_flag` BOOLEAN COMMENT 'Indicates whether the feedback response requires a follow-up action by the service team, typically triggered by low satisfaction ratings or negative verbatim comments.. Valid values are `true|false`',
    `follow_up_status` STRING COMMENT 'Current status of the follow-up action triggered by the feedback, tracking resolution of customer concerns raised in low-rated or negative feedback.. Valid values are `not_required|pending|in_progress|completed|escalated`',
    `is_first_time_fix` BOOLEAN COMMENT 'Indicates whether the service issue was resolved on the first visit or interaction without requiring a repeat visit, a key field service KPI correlated with customer satisfaction.. Valid values are `true|false`',
    `language_code` STRING COMMENT 'ISO 639-1 language code (optionally with ISO 3166-1 country subtag) of the language in which the feedback was provided, supporting multilingual analytics in global operations.. Valid values are `^[a-z]{2}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the feedback record in the source system, supporting change tracking and Silver layer incremental load processing.',
    `number` STRING COMMENT 'Human-readable business identifier for the feedback record, used for cross-system reference and customer communication (e.g., SFB-2024-000123).. Valid values are `^SFB-[0-9]{4}-[0-9]{6}$`',
    `overall_satisfaction_rating` STRING COMMENT 'Overall customer satisfaction score on a 1–5 scale (1=Very Dissatisfied, 5=Very Satisfied), representing the primary CSAT metric for the service interaction.. Valid values are `^[1-5]$`',
    `parts_availability_rating` STRING COMMENT 'Customer rating (1–5) of the availability and timely delivery of spare parts required during the service event, relevant for aftermarket operations.. Valid values are `^[1-5]$`',
    `problem_resolution_rating` STRING COMMENT 'Customer rating (1–5) of the quality and completeness of the problem resolution, indicating whether the issue was fully and correctly addressed.. Valid values are `^[1-5]$`',
    `product_line` STRING COMMENT 'Product line or family of the equipment or solution that was serviced, enabling CSAT analysis by product category to identify product-specific service quality issues.',
    `repeat_visit_flag` BOOLEAN COMMENT 'Indicates whether this service event was a repeat visit for the same issue, providing context for satisfaction ratings and identifying recurring service failures.. Valid values are `true|false`',
    `response_time_rating` STRING COMMENT 'Customer rating (1–5) of the speed of initial response and dispatch following the service request, reflecting SLA performance perception.. Valid values are `^[1-5]$`',
    `service_event_reference` STRING COMMENT 'Business reference number of the associated service event (e.g., field service order number, case number, or warranty claim number) that prompted this feedback.',
    `service_event_type` STRING COMMENT 'Classification of the service interaction that triggered this feedback collection, enabling dimension-level CSAT analysis by service type.. Valid values are `field_service_visit|remote_support|warranty_claim_resolution|installation|commissioning|preventive_maintenance|technical_support|spare_parts_delivery`',
    `site_region` STRING COMMENT 'Geographic region or sales territory of the customer site (e.g., EMEA, APAC, Americas), used for regional service performance reporting and benchmarking.',
    `sla_tier` STRING COMMENT 'SLA tier applicable to the service interaction, used to contextualize satisfaction ratings against the contracted service level and identify tier-specific quality gaps.. Valid values are `platinum|gold|silver|bronze|standard`',
    `source_system` STRING COMMENT 'Operational system of record from which this feedback record was ingested into the Silver layer, supporting data lineage and audit traceability.. Valid values are `salesforce_service_cloud|sap_s4hana|siemens_opcenter|manual_entry|third_party_survey`',
    `status` STRING COMMENT 'Current processing status of the feedback record, tracking its lifecycle from initial submission through acknowledgement, follow-up, and closure.. Valid values are `pending|submitted|acknowledged|closed|invalid|escalated`',
    `survey_template_version` STRING COMMENT 'Version identifier of the feedback survey template used to collect this response, enabling longitudinal comparability as survey questions evolve over time.',
    `technician_professionalism_rating` STRING COMMENT 'Customer rating (1–5) of the field service technicians professionalism, conduct, and expertise during the service interaction.. Valid values are `^[1-5]$`',
    `verbatim_comment` STRING COMMENT 'Free-text verbatim comment provided by the customer describing their service experience, used for qualitative analysis, root cause identification, and service improvement initiatives.',
    `would_recommend_flag` BOOLEAN COMMENT 'Indicates whether the customer stated they would recommend the companys service to others, serving as a qualitative loyalty indicator complementing the NPS score.. Valid values are `true|false`',
    CONSTRAINT pk_feedback PRIMARY KEY(`feedback_id`)
) COMMENT 'Structured customer satisfaction feedback records collected after service interactions including field service visits, remote support sessions, and warranty claim resolutions. Captures feedback collection date, associated service event type and reference, customer contact, overall satisfaction rating, individual dimension ratings (technician professionalism, response time, problem resolution quality, communication), verbatim comments, and follow-up action required flag. Complements nps_survey by capturing multi-dimensional CSAT data beyond the single NPS score, enabling granular service quality improvement.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`service`.`product_return` (
    `product_return_id` BIGINT COMMENT 'Unique surrogate identifier for each Return Material Authorization (RMA) record in the silver layer lakehouse. Serves as the primary key for the product_return data product.',
    `ap_invoice_id` BIGINT COMMENT 'Foreign key linking to finance.ap_invoice. Business justification: Product returns may trigger AP credit memos when returning to suppliers or adjusting vendor invoices. Accounts payable processes return credits against original invoices.',
    `batch_id` BIGINT COMMENT 'Foreign key linking to production.batch. Business justification: Product returns link to production batch for quality analysis. Manufacturing teams investigate if defects are batch-specific, triggering holds on remaining inventory from same batch.',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Product returns identify failed components for RMA processing. Engineering analyzes returned components for quality issues, requiring direct linkage to component master data.',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: Product returns reference the specific CI being returned for RMA processing. Updates CI status to decommissioned/returned, maintains asset tracking continuity, and triggers warranty/refurbishment work',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Product return from customer account - normalize by replacing customer_account_number and customer_name with FK',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Product returns track equipment returned for repair, replacement, or credit. Links to asset records for warranty validation, refurbishment tracking, and asset lifecycle management.',
    `inspection_lot_id` BIGINT COMMENT 'Foreign key linking to quality.inspection_lot. Business justification: Returned products undergo quality inspection to determine root cause. Service teams create inspection lots for returned items to assess defects and determine warranty validity.',
    `logistics_inbound_delivery_id` BIGINT COMMENT 'Foreign key linking to logistics.inbound_delivery. Business justification: Defective equipment returns from field service require inbound logistics tracking. Warehouse and service teams coordinate receiving, inspection, and warranty processing based on inbound delivery statu',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to procurement.supplier. Business justification: Defective products returned from field service are sent back to suppliers. Service and procurement collaborate on RMA processing and supplier quality issues.',
    `product_sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Product returns must identify the exact SKU being returned for proper restocking, refund calculation, quality analysis, and warranty processing in manufacturing operations.',
    `sales_order_id` BIGINT COMMENT 'Foreign key linking to order.sales_order. Business justification: Product returns must reference the original sales order for return authorization, refund processing, and inventory reconciliation. Essential for validating return eligibility and processing credits in',
    `usage_decision_id` BIGINT COMMENT 'Foreign key linking to quality.usage_decision. Business justification: Quality inspectors make usage decisions on returned products (scrap, rework, return to stock). This determines whether items can be refurbished or must be scrapped.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Product returns specify which warehouse receives the returned goods. Logistics teams use this for routing returned items and updating inventory positions at the correct facility.',
    `warranty_claim_id` BIGINT COMMENT 'Foreign key linking to service.warranty_claim. Business justification: product_return.warranty_claim_number (STRING) is a denormalized reference to warranty_claim.claim_number. RMA/product returns are frequently initiated as part of a warranty claim resolution process. A',
    `authorization_date` DATE COMMENT 'Calendar date on which the return was formally authorized and the RMA number was issued to the customer. Marks the start of the return lifecycle and is used for SLA and turnaround time calculations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `capa_reference` STRING COMMENT 'Reference number of the Corrective and Preventive Action (CAPA) record initiated as a result of the defect identified during return inspection. Links the RMA to the quality management system for systemic defect resolution tracking.',
    `condition_on_receipt` STRING COMMENT 'Physical condition of the returned product as assessed by the receiving warehouse or repair center upon arrival. Determines eligibility for repair, replacement, or credit and is used in supplier chargeback decisions.. Valid values are `intact|damaged_packaging|physically_damaged|incomplete|missing_accessories|beyond_repair|not_received`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the customer site from which the product is being returned. Used for regional return volume analysis, customs and export control compliance, and RoHS/REACH regulatory tracking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the RMA record was first created in SAP S/4HANA SD. Used for audit trail, data lineage tracking, and SLA measurement from authorization to closure.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the transaction currency used in credit amount and repair cost fields (e.g., USD, EUR, GBP). Supports multi-currency financial reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `customer_reference_number` STRING COMMENT 'Customer-provided reference number (e.g., customer PO number, internal ticket number, or RMA reference from the customers own system) associated with the return. Enables cross-referencing between Manufacturings RMA and the customers internal tracking.',
    `defect_code` STRING COMMENT 'Standardized defect classification code assigned during inspection, identifying the specific type of failure or non-conformance found in the returned product (e.g., electrical failure, mechanical damage, firmware fault). Supports FMEA analysis and CAPA initiation.',
    `disposition` STRING COMMENT 'Final disposition decision made after inspection, determining what action will be taken with the returned product. Drives downstream processes: repair routing, replacement shipment creation, financial credit memo issuance, or scrap processing.. Valid values are `repair|replace|scrap|credit|return_to_customer|refurbish|pending`',
    `disposition_date` DATE COMMENT 'Date on which the disposition decision was formally recorded and approved. Used to measure decision cycle time from receipt to disposition and to track compliance with internal quality process timelines.. Valid values are `^d{4}-d{2}-d{2}$`',
    `goods_receipt_date` DATE COMMENT 'Date on which the returned product was physically received and goods receipt was posted in SAP S/4HANA. Marks the start of the inspection and repair cycle and is used to calculate total return cycle time.. Valid values are `^d{4}-d{2}-d{2}$`',
    `inspection_date` DATE COMMENT 'Date on which the quality inspection of the returned product was completed at the repair center. Used to calculate inspection turnaround time and monitor compliance with internal SLA targets.. Valid values are `^d{4}-d{2}-d{2}$`',
    `inspection_result` STRING COMMENT 'Outcome of the quality inspection performed on the returned product at the repair center. Drives the disposition decision and is recorded in SAP QM as part of the returns quality process.. Valid values are `pass|fail|partial_pass|pending|not_required`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the RMA record in the source system. Used for incremental data loading in the lakehouse pipeline and audit trail compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `ncr_reference` STRING COMMENT 'Reference number of the Non-Conformance Report (NCR) raised against the returned product during quality inspection. Provides traceability to the formal non-conformance documentation required under ISO 9001 quality management processes.',
    `original_delivery_number` STRING COMMENT 'SAP outbound delivery document number associated with the original shipment of the returned product. Used to verify shipment details, confirm the correct item was shipped, and support incorrect-shipment return investigations.',
    `original_sales_order_number` STRING COMMENT 'SAP sales order number from the original outbound transaction that supplied the product now being returned. Used to trace the return back to the originating sale for financial reversal, warranty validation, and order history analysis.',
    `product_category` STRING COMMENT 'High-level product category classification of the returned item (e.g., automation system, electrification solution, smart infrastructure component). Used for return volume analysis by product line and routing to the appropriate repair center.. Valid values are `automation_system|electrification_solution|smart_infrastructure|drive_system|control_panel|sensor|actuator|power_supply|hmi|plc|other`',
    `product_description` STRING COMMENT 'Short description of the returned product as defined in the SAP material master. Provides human-readable product identification for operational staff and reporting without requiring a join to the product catalog.',
    `product_sku` STRING COMMENT 'SAP material number or Stock Keeping Unit (SKU) identifying the specific product being returned. Used for inventory reintegration, spare parts catalog lookup, and defect trend analysis by product line.',
    `quantity_returned` STRING COMMENT 'Number of units authorized for return under this RMA. Typically 1 for serialized products but may be greater for non-serialized bulk returns of spare parts or consumables.. Valid values are `^[1-9][0-9]*$`',
    `receiving_warehouse_code` STRING COMMENT 'Code identifying the Manufacturing repair center or warehouse that physically received the returned product. Used for workload distribution analysis, repair center capacity planning, and geographic routing optimization.',
    `repair_cost` DECIMAL(18,2) COMMENT 'Total cost incurred by Manufacturing to repair the returned product, including labor, parts, and overhead. Used for warranty cost analysis, supplier chargeback calculations, and service profitability reporting.',
    `repair_turnaround_days` STRING COMMENT 'Number of calendar days elapsed from receipt of the returned product at the repair center to completion of repair and readiness for return shipment. Key service KPI used to measure repair center performance against SLA commitments.. Valid values are `^[0-9]+$`',
    `replacement_shipment_reference` STRING COMMENT 'SAP outbound delivery or shipment document number for the replacement unit dispatched to the customer when the disposition decision is replace. Enables end-to-end traceability from return receipt to replacement fulfillment.',
    `return_reason_code` STRING COMMENT 'Standardized SAP SD reason code identifying the specific cause for the product return (e.g., Z001 - Defective on Arrival, Z002 - Wrong Item Shipped, Z003 - Warranty Failure). Used for defect trend analysis and supplier chargeback processing.',
    `return_reason_description` STRING COMMENT 'Free-text description provided by the customer or service agent elaborating on the specific reason for returning the product. Supplements the structured reason code with contextual detail for engineering and quality review.',
    `return_shipment_tracking_number` STRING COMMENT 'Carrier tracking number for the inbound shipment of the returned product from the customer site to the Manufacturing repair center. Used to monitor transit status and confirm receipt.',
    `return_type` STRING COMMENT 'Classification of the reason category driving the product return. Distinguishes warranty-driven returns from commercial returns such as incorrect shipments or customer rejections, enabling root cause analysis and financial routing.. Valid values are `warranty_return|defective_return|incorrect_shipment|customer_rejection|end_of_life|upgrade_exchange|loaner_return`',
    `rma_number` STRING COMMENT 'Business-facing Return Material Authorization number assigned by SAP S/4HANA SD at the time of return authorization. Used as the primary cross-system reference for tracking the physical return of products from customer sites.. Valid values are `^RMA-[0-9]{4}-[0-9]{6}$`',
    `sales_organization` STRING COMMENT 'SAP sales organization code responsible for the original sale and the return processing. Determines the financial entity for credit memo posting, revenue adjustment, and regional P&L reporting.',
    `serial_number` STRING COMMENT 'Unique serial number of the specific physical unit being returned. Critical for traceability to the installed base record, warranty entitlement verification, repair history lookup, and regulatory compliance tracking.',
    `status` STRING COMMENT 'Current lifecycle status of the Return Material Authorization record, tracking the return from initial authorization through receipt, inspection, disposition, and closure.. Valid values are `open|in_transit|received|under_inspection|disposition_pending|closed|cancelled`',
    `supplier_chargeback_flag` BOOLEAN COMMENT 'Indicates whether the defect identified in the returned product is attributable to a supplier component, triggering a supplier chargeback claim through SAP Ariba procurement processes. Supports supplier quality management and cost recovery.. Valid values are `true|false`',
    CONSTRAINT pk_product_return PRIMARY KEY(`product_return_id`)
) COMMENT 'Return Material Authorization (RMA) records managing the physical return of defective, warranty-claimed, or incorrectly shipped automation and electrification products from customer sites back to Manufacturings repair centers or warehouses. Captures RMA number, return authorization date, customer reference, returned product serial number, return reason code, condition on receipt, inspection result, disposition decision (repair, replace, scrap, credit), repair turnaround time, and replacement shipment reference. Managed in SAP S/4HANA SD returns processing.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ADD CONSTRAINT `fk_service_sla_tracking_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `manufacturing_ecm`.`service`.`technician`(`technician_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ADD CONSTRAINT `fk_service_sla_tracking_request_id` FOREIGN KEY (`request_id`) REFERENCES `manufacturing_ecm`.`service`.`request`(`request_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ADD CONSTRAINT `fk_service_sla_tracking_sla_commitment_id` FOREIGN KEY (`sla_commitment_id`) REFERENCES `manufacturing_ecm`.`service`.`sla_commitment`(`sla_commitment_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ADD CONSTRAINT `fk_service_dispatch_schedule_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `manufacturing_ecm`.`service`.`service_territory`(`service_territory_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ADD CONSTRAINT `fk_service_dispatch_schedule_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `manufacturing_ecm`.`service`.`technician`(`technician_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_warranty_claim_id` FOREIGN KEY (`warranty_claim_id`) REFERENCES `manufacturing_ecm`.`service`.`warranty_claim`(`warranty_claim_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ADD CONSTRAINT `fk_service_remote_support_session_request_id` FOREIGN KEY (`request_id`) REFERENCES `manufacturing_ecm`.`service`.`request`(`request_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `manufacturing_ecm`.`service`.`technician`(`technician_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ADD CONSTRAINT `fk_service_entitlement_warranty_claim_id` FOREIGN KEY (`warranty_claim_id`) REFERENCES `manufacturing_ecm`.`service`.`warranty_claim`(`warranty_claim_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ADD CONSTRAINT `fk_service_service_quotation_service_price_list_id` FOREIGN KEY (`service_price_list_id`) REFERENCES `manufacturing_ecm`.`service`.`service_price_list`(`service_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ADD CONSTRAINT `fk_service_service_quotation_warranty_claim_id` FOREIGN KEY (`warranty_claim_id`) REFERENCES `manufacturing_ecm`.`service`.`warranty_claim`(`warranty_claim_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ADD CONSTRAINT `fk_service_service_invoice_warranty_claim_id` FOREIGN KEY (`warranty_claim_id`) REFERENCES `manufacturing_ecm`.`service`.`warranty_claim`(`warranty_claim_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_warranty_claim_id` FOREIGN KEY (`warranty_claim_id`) REFERENCES `manufacturing_ecm`.`service`.`warranty_claim`(`warranty_claim_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`service` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `manufacturing_ecm`.`service` SET TAGS ('dbx_domain' = 'service');
ALTER TABLE `manufacturing_ecm`.`service`.`request` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`request` SET TAGS ('dbx_subdomain' = 'customer_support');
ALTER TABLE `manufacturing_ecm`.`service`.`request` SET TAGS ('dbx_original_name' = 'service_request');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `request_id` SET TAGS ('dbx_business_glossary_term' = 'Service Request ID');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `line_id` SET TAGS ('dbx_business_glossary_term' = 'Production Line Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Product Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `assigned_engineer` SET TAGS ('dbx_business_glossary_term' = 'Assigned Support Engineer');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `assigned_team` SET TAGS ('dbx_business_glossary_term' = 'Assigned Support Team');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `capa_reference` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `case_number` SET TAGS ('dbx_business_glossary_term' = 'Case Number');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `case_number` SET TAGS ('dbx_value_regex' = '^SR-[0-9]{8,12}$');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Case Category');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'technical_support|warranty_claim|product_defect|installation|commissioning|complaint|spare_parts|software|preventive_maintenance|billing|general_inquiry');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Case Closed Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `customer_satisfaction_score` SET TAGS ('dbx_business_glossary_term' = 'Customer Satisfaction (CSAT) Score');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Case Description');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `entitlement_name` SET TAGS ('dbx_business_glossary_term' = 'Service Entitlement Name');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `escalation_level` SET TAGS ('dbx_business_glossary_term' = 'Escalation Level');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `escalation_level` SET TAGS ('dbx_value_regex' = '0|1|2|3');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `escalation_reason` SET TAGS ('dbx_business_glossary_term' = 'Escalation Reason');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `escalation_reason` SET TAGS ('dbx_value_regex' = 'sla_breach|customer_dissatisfaction|technical_complexity|safety_risk|repeat_issue|management_request|regulatory_requirement');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `external_reference_number` SET TAGS ('dbx_business_glossary_term' = 'External Reference Number');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `first_response_timestamp` SET TAGS ('dbx_business_glossary_term' = 'First Response Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `is_escalated` SET TAGS ('dbx_business_glossary_term' = 'Escalation Indicator');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `is_escalated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `is_sla_breached` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Indicator');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `is_sla_breached` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `is_warranty_claim` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Indicator');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `is_warranty_claim` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Case Language Code');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `opened_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Case Opened Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `origin_channel` SET TAGS ('dbx_business_glossary_term' = 'Case Origin Channel');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `origin_channel` SET TAGS ('dbx_value_regex' = 'phone|email|web_portal|field|chat|fax|edi|partner_portal|mobile_app');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Case Priority');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'p1|p2|p3|p4');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `product_line` SET TAGS ('dbx_business_glossary_term' = 'Product Line');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `resolution_description` SET TAGS ('dbx_business_glossary_term' = 'Resolution Description');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `resolution_type` SET TAGS ('dbx_business_glossary_term' = 'Resolution Type');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `resolution_type` SET TAGS ('dbx_value_regex' = 'remote_fix|field_repair|part_replacement|software_update|configuration_change|customer_training|no_fault_found|workaround|escalated_to_engineering|return_to_depot');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `resolved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Case Resolved Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'design_defect|manufacturing_defect|installation_error|operator_error|wear_and_tear|software_bug|environmental|supplier_component|unknown|no_fault_found');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `root_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Product Serial Number');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Case Severity');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `site_region` SET TAGS ('dbx_business_glossary_term' = 'Site Region');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `sla_resolution_target_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Resolution Target Hours');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `sla_response_target_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Response Target Hours');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard|none');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_service_cloud|sap_s4hana|maximo|manual|partner_portal');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Case Status');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'new|open|in_progress|pending_customer|pending_parts|escalated|resolved|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `sub_category` SET TAGS ('dbx_business_glossary_term' = 'Case Sub-Category');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `subject` SET TAGS ('dbx_business_glossary_term' = 'Case Subject');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `warranty_status` SET TAGS ('dbx_business_glossary_term' = 'Warranty Status');
ALTER TABLE `manufacturing_ecm`.`service`.`request` ALTER COLUMN `warranty_status` SET TAGS ('dbx_value_regex' = 'in_warranty|out_of_warranty|extended_warranty|warranty_expired|not_applicable');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` SET TAGS ('dbx_subdomain' = 'customer_support');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim ID');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `batch_id` SET TAGS ('dbx_business_glossary_term' = 'Batch Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `capa_record_id` SET TAGS ('dbx_business_glossary_term' = 'Capa Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `ncr_id` SET TAGS ('dbx_business_glossary_term' = 'Ncr Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `serialized_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Product Serial Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `warranty_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Warranty Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `approved_amount` SET TAGS ('dbx_business_glossary_term' = 'Approved Settlement Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `approved_amount` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `approved_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `claim_number` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Number');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `claim_number` SET TAGS ('dbx_value_regex' = '^WC-[0-9]{4}-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `claim_type` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Type');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `claim_type` SET TAGS ('dbx_value_regex' = 'repair|replacement|credit_note|refund|field_service|exchange');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `claimed_amount` SET TAGS ('dbx_business_glossary_term' = 'Claimed Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `claimed_amount` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `claimed_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Claim Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `decision` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Decision');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `decision` SET TAGS ('dbx_value_regex' = 'pending|approved|partially_approved|rejected|escalated');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `defect_location` SET TAGS ('dbx_business_glossary_term' = 'Defect Location');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `external_claim_reference` SET TAGS ('dbx_business_glossary_term' = 'External Claim Reference Number');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `failure_date` SET TAGS ('dbx_business_glossary_term' = 'Product Failure Date');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `failure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `failure_description` SET TAGS ('dbx_business_glossary_term' = 'Failure Description');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `failure_mode` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `failure_mode` SET TAGS ('dbx_value_regex' = 'electrical_failure|mechanical_failure|software_fault|communication_error|overheating|corrosion|physical_damage|premature_wear|intermittent_fault|no_fault_found|other');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Inspection Date');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `inspection_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `is_within_warranty` SET TAGS ('dbx_business_glossary_term' = 'Within Warranty Coverage Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `is_within_warranty` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `manufacture_date` SET TAGS ('dbx_business_glossary_term' = 'Product Manufacture Date');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `manufacture_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `product_category` SET TAGS ('dbx_business_glossary_term' = 'Product Category');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `product_category` SET TAGS ('dbx_value_regex' = 'plc|drive|switchgear|hmi|sensor|motor|transformer|circuit_breaker|automation_system|electrification_component|other');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `product_description` SET TAGS ('dbx_business_glossary_term' = 'Product Description');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `product_model_number` SET TAGS ('dbx_business_glossary_term' = 'Product Model Number');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Claim Rejection Reason');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_value_regex' = 'warranty_expired|misuse_or_abuse|unauthorized_modification|physical_damage|out_of_scope|no_defect_found|missing_documentation|other');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `repair_cost` SET TAGS ('dbx_business_glossary_term' = 'Repair Cost');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `repair_cost` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `repair_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `replacement_part_number` SET TAGS ('dbx_business_glossary_term' = 'Replacement Part Number');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `replacement_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Replacement Unit Serial Number');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `resolution_date` SET TAGS ('dbx_business_glossary_term' = 'Claim Resolution Date');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `resolution_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `return_material_authorization` SET TAGS ('dbx_business_glossary_term' = 'Return Material Authorization (RMA) Number');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `root_cause` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Classification');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `root_cause` SET TAGS ('dbx_value_regex' = 'design_defect|manufacturing_defect|material_defect|software_bug|installation_error|customer_misuse|environmental_factor|supplier_component_failure|unknown|other');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `service_technician_name` SET TAGS ('dbx_business_glossary_term' = 'Service Technician Name');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `settlement_date` SET TAGS ('dbx_business_glossary_term' = 'Claim Settlement Date');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `settlement_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Status');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|pending_inspection|approved|rejected|in_repair|replacement_ordered|settled|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Claim Submission Date');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Claim Submission Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `submission_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `supplier_chargeback_amount` SET TAGS ('dbx_business_glossary_term' = 'Supplier Chargeback Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `supplier_chargeback_amount` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `supplier_chargeback_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `supplier_chargeback_flag` SET TAGS ('dbx_business_glossary_term' = 'Supplier Chargeback Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ALTER COLUMN `supplier_chargeback_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` SET TAGS ('dbx_subdomain' = 'contract_management');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` SET TAGS ('dbx_original_name' = 'service_contract_line');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `contract_line_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Line ID');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `availability_target_percent` SET TAGS ('dbx_business_glossary_term' = 'Availability Target Percentage');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_business_glossary_term' = 'Billing Frequency');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `billing_frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annual|annual|one_time|milestone_based');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `billing_plan_type` SET TAGS ('dbx_business_glossary_term' = 'Billing Plan Type');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `billing_plan_type` SET TAGS ('dbx_value_regex' = 'periodic|milestone|on_demand|prepaid|postpaid');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `coverage_end_date` SET TAGS ('dbx_business_glossary_term' = 'Coverage End Date');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `coverage_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `coverage_hours` SET TAGS ('dbx_business_glossary_term' = 'Coverage Hours');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `coverage_hours` SET TAGS ('dbx_value_regex' = '8x5|12x5|16x5|24x7|24x5|business_hours|custom');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `coverage_start_date` SET TAGS ('dbx_business_glossary_term' = 'Coverage Start Date');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `coverage_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `covered_equipment_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Covered Equipment Serial Number');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `discount_percent` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `discount_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `escalation_level` SET TAGS ('dbx_business_glossary_term' = 'Escalation Level');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `escalation_level` SET TAGS ('dbx_value_regex' = 'L1|L2|L3|L4');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `installed_base_reference` SET TAGS ('dbx_business_glossary_term' = 'Installed Base Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `line_description` SET TAGS ('dbx_business_glossary_term' = 'Contract Line Description');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'Contract Line Number');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `line_value` SET TAGS ('dbx_business_glossary_term' = 'Contract Line Value');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `line_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `net_price` SET TAGS ('dbx_business_glossary_term' = 'Net Price');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `net_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `penalty_clause_applicable` SET TAGS ('dbx_business_glossary_term' = 'Penalty Clause Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `penalty_clause_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `penalty_rate_percent` SET TAGS ('dbx_business_glossary_term' = 'SLA Penalty Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `penalty_rate_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `preventive_visits_per_year` SET TAGS ('dbx_business_glossary_term' = 'Preventive Maintenance Visits Per Year');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `product_number` SET TAGS ('dbx_business_glossary_term' = 'Product Number');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Contract Line Quantity');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `remote_monitoring_included` SET TAGS ('dbx_business_glossary_term' = 'Remote Monitoring Included Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `remote_monitoring_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `resolution_time_hours` SET TAGS ('dbx_business_glossary_term' = 'SLA Resolution Time (Hours)');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `response_time_hours` SET TAGS ('dbx_business_glossary_term' = 'SLA Response Time (Hours)');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `service_category` SET TAGS ('dbx_business_glossary_term' = 'Service Category');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `service_category` SET TAGS ('dbx_value_regex' = 'hardware|software|electrification|automation|infrastructure|lifecycle|digital_services');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'preventive_maintenance|corrective_maintenance|remote_monitoring|field_service|technical_support|spare_parts|installation|commissioning|inspection|training|software_update|full_service');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard|custom');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `software_updates_included` SET TAGS ('dbx_business_glossary_term' = 'Software Updates Included Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `software_updates_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL|LEGACY');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `spare_parts_included` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Included Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `spare_parts_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Contract Line Status');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|suspended|cancelled|expired|pending_approval|closed');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|HR|DAY|MON|YR|KG|SET|LOT|VISIT');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `unit_price` SET TAGS ('dbx_business_glossary_term' = 'Unit Price');
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ALTER COLUMN `unit_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` SET TAGS ('dbx_subdomain' = 'contract_management');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `sla_commitment_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Commitment ID');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `applicable_country_code` SET TAGS ('dbx_business_glossary_term' = 'Applicable Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `applicable_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `applicable_product_category` SET TAGS ('dbx_business_glossary_term' = 'Applicable Product Category');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `applicable_service_request_category` SET TAGS ('dbx_business_glossary_term' = 'Applicable Service Request Category');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `applicable_service_request_category` SET TAGS ('dbx_value_regex' = 'corrective_maintenance|preventive_maintenance|installation|commissioning|technical_support|emergency_breakdown|software_update|inspection|warranty_repair');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `breach_count_period` SET TAGS ('dbx_business_glossary_term' = 'Breach Count Measurement Period');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `breach_count_period` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|annually|rolling_90_days|rolling_12_months');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `breach_threshold_value` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Threshold Value');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `breach_threshold_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'SLA Commitment Category');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'operational|contractual|regulatory|internal');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'SLA Commitment Code');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,30}$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `coverage_hours_type` SET TAGS ('dbx_business_glossary_term' = 'SLA Coverage Hours Type');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `coverage_hours_type` SET TAGS ('dbx_value_regex' = '24x7|business_hours|extended_hours|custom');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `coverage_timezone` SET TAGS ('dbx_business_glossary_term' = 'SLA Coverage Timezone');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'SLA Commitment Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Penalty Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `customer_tier` SET TAGS ('dbx_business_glossary_term' = 'Applicable Customer Tier');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `customer_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'SLA Commitment Description');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'SLA Commitment Effective Date');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `escalation_trigger_unit` SET TAGS ('dbx_business_glossary_term' = 'SLA Escalation Trigger Unit');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `escalation_trigger_unit` SET TAGS ('dbx_value_regex' = 'hours|minutes|days|percent|count');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `escalation_trigger_value` SET TAGS ('dbx_business_glossary_term' = 'SLA Escalation Trigger Value');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `escalation_trigger_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `exclusion_conditions` SET TAGS ('dbx_business_glossary_term' = 'SLA Exclusion Conditions');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'SLA Commitment Expiry Date');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_business_glossary_term' = 'SLA Geographic Scope');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'global|regional|country|site_specific');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `is_regulatory_mandated` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Mandated SLA Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `is_regulatory_mandated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'SLA Commitment Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `max_breach_count_before_termination` SET TAGS ('dbx_business_glossary_term' = 'Maximum Breach Count Before Termination Right');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `max_breach_count_before_termination` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `measurement_start_event` SET TAGS ('dbx_business_glossary_term' = 'SLA Measurement Start Event');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `measurement_start_event` SET TAGS ('dbx_value_regex' = 'case_creation|case_assignment|customer_notification|parts_order_placed|engineer_dispatch');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `measurement_stop_event` SET TAGS ('dbx_business_glossary_term' = 'SLA Measurement Stop Event');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `measurement_stop_event` SET TAGS ('dbx_value_regex' = 'case_resolved|customer_confirmed|parts_delivered|engineer_on_site|system_restored');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_business_glossary_term' = 'SLA Measurement Unit');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_value_regex' = 'hours|minutes|days|percent|count|ratio');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'SLA Commitment Name');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'SLA Commitment Next Review Date');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `penalty_cap_period` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Penalty Cap Period');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `penalty_cap_period` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|annually|per_incident');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `penalty_cap_value` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Penalty Cap Value');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `penalty_cap_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `penalty_cap_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `penalty_type` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Penalty Type');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `penalty_type` SET TAGS ('dbx_value_regex' = 'service_credit|financial_penalty|contract_termination_right|none');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `penalty_unit` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Penalty Unit');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `penalty_unit` SET TAGS ('dbx_value_regex' = 'percent_of_monthly_fee|percent_of_annual_fee|fixed_amount|percent_per_hour_breach');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `penalty_value` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Penalty Value');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `penalty_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `penalty_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `priority_level` SET TAGS ('dbx_business_glossary_term' = 'SLA Priority Level');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `priority_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `regulatory_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `review_frequency` SET TAGS ('dbx_business_glossary_term' = 'SLA Commitment Review Frequency');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annually|annually|as_needed');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `service_delivery_channel` SET TAGS ('dbx_business_glossary_term' = 'Service Delivery Channel');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `service_delivery_channel` SET TAGS ('dbx_value_regex' = 'on_site|remote|hybrid|parts_only');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'SLA Commitment Status');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|deprecated|retired|under_review');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `target_metric_value` SET TAGS ('dbx_business_glossary_term' = 'SLA Target Metric Value');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `target_metric_value` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'SLA Commitment Type');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'response_time|resolution_time|uptime_guarantee|first_time_fix_rate|mean_time_to_repair|preventive_maintenance_interval|parts_availability|remote_support_availability');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'SLA Commitment Version Number');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_commitment` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` SET TAGS ('dbx_subdomain' = 'contract_management');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `sla_tracking_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tracking ID');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `technician_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Technician Employee ID');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `field_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Field Service Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `request_id` SET TAGS ('dbx_business_glossary_term' = 'Service Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `sla_commitment_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Commitment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `actual_resolution_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Resolution Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `actual_resolution_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `actual_response_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Response Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `actual_response_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `assigned_team` SET TAGS ('dbx_business_glossary_term' = 'Assigned Service Team');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `breach_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Duration (Minutes)');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `breach_duration_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]*$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `breach_reason_code` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Reason Code');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `breach_reason_code` SET TAGS ('dbx_value_regex' = 'resource_unavailability|parts_shortage|customer_delay|technical_complexity|access_restriction|third_party_dependency|force_majeure|incorrect_prioritization|escalation_delay|other');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `breach_reason_description` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Reason Description');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `business_hours_calendar` SET TAGS ('dbx_business_glossary_term' = 'Business Hours Calendar');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `escalation_level` SET TAGS ('dbx_business_glossary_term' = 'Escalation Level');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `escalation_level` SET TAGS ('dbx_value_regex' = 'level_1|level_2|level_3|executive');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `escalation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Escalation Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `escalation_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `installed_base_reference` SET TAGS ('dbx_business_glossary_term' = 'Installed Base Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `is_escalated` SET TAGS ('dbx_business_glossary_term' = 'SLA Escalation Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `is_escalated` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `notification_sent` SET TAGS ('dbx_business_glossary_term' = 'SLA Warning Notification Sent Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `notification_sent` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `pause_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'SLA Clock Pause Duration (Minutes)');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `pause_duration_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]*$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `pause_reason` SET TAGS ('dbx_business_glossary_term' = 'SLA Clock Pause Reason');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `pause_reason` SET TAGS ('dbx_value_regex' = 'awaiting_customer_response|awaiting_parts|awaiting_access|customer_requested_hold|pending_approval|other');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `pause_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'SLA Clock Pause Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `pause_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `penalty_amount` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Penalty Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `penalty_amount` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `penalty_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `penalty_applicable` SET TAGS ('dbx_business_glossary_term' = 'SLA Penalty Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `penalty_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Service Request Priority');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `record_source` SET TAGS ('dbx_business_glossary_term' = 'Record Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `record_source` SET TAGS ('dbx_value_regex' = 'salesforce_service_cloud|sap_s4hana|manual_entry|api_integration');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `region_code` SET TAGS ('dbx_business_glossary_term' = 'Region Code');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `resolution_due_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Resolution Due Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `resolution_due_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `resolution_status` SET TAGS ('dbx_business_glossary_term' = 'Resolution SLA Status');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `resolution_status` SET TAGS ('dbx_value_regex' = 'pending|met|breached|not_applicable');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `resolution_target_minutes` SET TAGS ('dbx_business_glossary_term' = 'Resolution Target Time (Minutes)');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `resolution_target_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `response_due_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Response Due Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `response_due_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `response_status` SET TAGS ('dbx_business_glossary_term' = 'Response SLA Status');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `response_status` SET TAGS ('dbx_value_regex' = 'pending|met|breached|not_applicable');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `response_target_minutes` SET TAGS ('dbx_business_glossary_term' = 'Response Target Time (Minutes)');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `response_target_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `service_category` SET TAGS ('dbx_business_glossary_term' = 'Service Category');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `service_category` SET TAGS ('dbx_value_regex' = 'technical_support|field_service|warranty_repair|installation|commissioning|preventive_maintenance|spare_parts|remote_support|emergency_response');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `sla_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'SLA Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `sla_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard|premium|critical');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `sla_type` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Type');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `sla_type` SET TAGS ('dbx_value_regex' = 'response|resolution|first_contact_resolution|on_site_arrival|parts_delivery|preventive_maintenance');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'SLA Compliance Status');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'on_track|at_risk|breached|completed|paused|cancelled');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `time_zone` SET TAGS ('dbx_business_glossary_term' = 'Time Zone');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `tracking_number` SET TAGS ('dbx_business_glossary_term' = 'SLA Tracking Number');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `tracking_number` SET TAGS ('dbx_value_regex' = '^SLA-[0-9]{4}-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `warning_threshold_percent` SET TAGS ('dbx_business_glossary_term' = 'SLA Warning Threshold Percentage');
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ALTER COLUMN `warning_threshold_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` SET TAGS ('dbx_subdomain' = 'field_operations');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `technician_id` SET TAGS ('dbx_business_glossary_term' = 'Technician ID');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Employee ID');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `employee_id` SET TAGS ('dbx_value_regex' = '^EMP-[A-Z0-9]{6,12}$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `employee_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `training_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Training Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `active_work_order_count` SET TAGS ('dbx_business_glossary_term' = 'Active Work Order Count');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `active_work_order_count` SET TAGS ('dbx_value_regex' = '^d+$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `availability_status` SET TAGS ('dbx_business_glossary_term' = 'Technician Availability Status');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `availability_status` SET TAGS ('dbx_value_regex' = 'available|dispatched|on_site|traveling|on_break|unavailable');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `base_location_city` SET TAGS ('dbx_business_glossary_term' = 'Base Location City');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `base_location_name` SET TAGS ('dbx_business_glossary_term' = 'Base Location Name');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `base_location_state_province` SET TAGS ('dbx_business_glossary_term' = 'Base Location State or Province');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_value_regex' = '^CC-[A-Z0-9]{4,10}$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Base Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `data_source_system` SET TAGS ('dbx_business_glossary_term' = 'Data Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `data_source_system` SET TAGS ('dbx_value_regex' = 'salesforce_field_service|kronos|sap_s4hana|manual');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `electrical_safety_cert_expiry` SET TAGS ('dbx_business_glossary_term' = 'Electrical Safety Certification Expiry Date');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `electrical_safety_cert_expiry` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `electrical_safety_certified` SET TAGS ('dbx_business_glossary_term' = 'Electrical Safety Certified Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `electrical_safety_certified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `hire_date` SET TAGS ('dbx_business_glossary_term' = 'Hire Date');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `hire_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `installation_authorized` SET TAGS ('dbx_business_glossary_term' = 'Installation Authorized Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `installation_authorized` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `labor_rate_currency` SET TAGS ('dbx_business_glossary_term' = 'Labor Rate Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `labor_rate_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `languages_spoken` SET TAGS ('dbx_business_glossary_term' = 'Languages Spoken');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `last_certification_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Certification Review Date');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `last_certification_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `max_concurrent_work_orders` SET TAGS ('dbx_business_glossary_term' = 'Maximum Concurrent Work Orders');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `max_concurrent_work_orders` SET TAGS ('dbx_value_regex' = '^[1-9]d*$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `next_certification_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Certification Due Date');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `next_certification_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `overtime_eligible` SET TAGS ('dbx_business_glossary_term' = 'Overtime Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `overtime_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `product_line_competency` SET TAGS ('dbx_business_glossary_term' = 'Product Line Competency');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `remote_support_capable` SET TAGS ('dbx_business_glossary_term' = 'Remote Support Capable Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `remote_support_capable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `seniority_level` SET TAGS ('dbx_business_glossary_term' = 'Technician Seniority Level');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `seniority_level` SET TAGS ('dbx_value_regex' = 'junior|mid|senior|lead|principal');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `service_contract_eligible` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `service_contract_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `service_start_date` SET TAGS ('dbx_business_glossary_term' = 'Service Domain Start Date');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `service_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `service_territory` SET TAGS ('dbx_business_glossary_term' = 'Service Territory');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_business_glossary_term' = 'Shift Pattern');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `shift_pattern` SET TAGS ('dbx_value_regex' = 'day|night|rotating|on_call|flexible');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `skill_certifications` SET TAGS ('dbx_business_glossary_term' = 'Skill Certifications');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `standard_labor_rate` SET TAGS ('dbx_business_glossary_term' = 'Standard Labor Rate');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `standard_labor_rate` SET TAGS ('dbx_value_regex' = '^d{1,8}.d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `standard_labor_rate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Technician Status');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|on_leave|suspended|terminated');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `travel_authorized` SET TAGS ('dbx_business_glossary_term' = 'International Travel Authorized Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `travel_authorized` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Technician Type');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'field_service_engineer|service_technician|installation_specialist|commissioning_engineer|remote_support_engineer|warranty_technician');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `vehicle_code` SET TAGS ('dbx_business_glossary_term' = 'Assigned Vehicle ID');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `vehicle_code` SET TAGS ('dbx_value_regex' = '^VEH-[A-Z0-9]{4,10}$');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `warranty_work_authorized` SET TAGS ('dbx_business_glossary_term' = 'Warranty Work Authorized Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ALTER COLUMN `warranty_work_authorized` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` SET TAGS ('dbx_subdomain' = 'field_operations');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` SET TAGS ('dbx_original_name' = 'service_territory');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `service_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Service Territory ID');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `employee_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `active_technician_count` SET TAGS ('dbx_business_glossary_term' = 'Active Technician Count');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `active_technician_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `area_size_km2` SET TAGS ('dbx_business_glossary_term' = 'Territory Area Size (Square Kilometers)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `area_size_km2` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'City');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Service Territory Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `coverage_days` SET TAGS ('dbx_business_glossary_term' = 'Coverage Days');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `coverage_days` SET TAGS ('dbx_value_regex' = 'MON|TUE|WED|THU|FRI|SAT|SUN');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `coverage_hours_end` SET TAGS ('dbx_business_glossary_term' = 'Coverage Hours End Time');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `coverage_hours_end` SET TAGS ('dbx_value_regex' = '^([01][0-9]|2[0-3]):[0-5][0-9]$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `coverage_hours_start` SET TAGS ('dbx_business_glossary_term' = 'Coverage Hours Start Time');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `coverage_hours_start` SET TAGS ('dbx_value_regex' = '^([01][0-9]|2[0-3]):[0-5][0-9]$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Service Territory Description');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `dispatch_priority` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Priority');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `dispatch_priority` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Territory Effective Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Territory Expiry Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_business_glossary_term' = 'Territory Hierarchy Level');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `hierarchy_level` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `is_24x7_coverage` SET TAGS ('dbx_business_glossary_term' = '24x7 Coverage Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `is_24x7_coverage` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Primary Language Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2,3}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Last Territory Review Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `latitude` SET TAGS ('dbx_business_glossary_term' = 'Territory Centroid Latitude');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `latitude` SET TAGS ('dbx_value_regex' = '^-?([0-8]?[0-9]|90)(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `latitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `latitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `longitude` SET TAGS ('dbx_business_glossary_term' = 'Territory Centroid Longitude');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `longitude` SET TAGS ('dbx_value_regex' = '^-?((1[0-7][0-9]|[0-9]{1,2})(.[0-9]{1,6})?|180(.0{1,6})?)$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `longitude` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `longitude` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `max_technician_capacity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Technician Capacity');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `max_technician_capacity` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Service Territory Name');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `postal_code_end` SET TAGS ('dbx_business_glossary_term' = 'Postal Code Range End');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `postal_code_end` SET TAGS ('dbx_value_regex' = '^[A-Z0-9 -]{3,10}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `postal_code_end` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `postal_code_end` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `postal_code_start` SET TAGS ('dbx_business_glossary_term' = 'Postal Code Range Start');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `postal_code_start` SET TAGS ('dbx_value_regex' = '^[A-Z0-9 -]{3,10}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `postal_code_start` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `postal_code_start` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `service_center_code` SET TAGS ('dbx_business_glossary_term' = 'Assigned Service Center Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `service_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `service_center_name` SET TAGS ('dbx_business_glossary_term' = 'Assigned Service Center Name');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `sla_resolution_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Resolution Time Hours');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `sla_resolution_time_hours` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `sla_response_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Response Time Hours');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `sla_response_time_hours` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_field_service|sap_s4hana|maximo_eam|manual');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `state_province` SET TAGS ('dbx_business_glossary_term' = 'State or Province');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Service Territory Status');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending|suspended');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `time_zone` SET TAGS ('dbx_business_glossary_term' = 'Territory Time Zone');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `travel_time_limit_minutes` SET TAGS ('dbx_business_glossary_term' = 'Maximum Travel Time Limit (Minutes)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `travel_time_limit_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Service Territory Type');
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'primary|secondary|overflow|temporary|virtual');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` SET TAGS ('dbx_subdomain' = 'field_operations');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `dispatch_schedule_id` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Schedule ID');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Dispatcher ID');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `field_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Field Service Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `service_territory_id` SET TAGS ('dbx_business_glossary_term' = 'Service Territory Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `technician_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Technician Employee ID');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `technician_id` SET TAGS ('dbx_business_glossary_term' = 'Technician Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `actual_arrival` SET TAGS ('dbx_business_glossary_term' = 'Actual Arrival Datetime');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `actual_arrival` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `actual_departure` SET TAGS ('dbx_business_glossary_term' = 'Actual Departure Datetime');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `actual_departure` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `actual_duration_min` SET TAGS ('dbx_business_glossary_term' = 'Actual Duration (Minutes)');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `actual_duration_min` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `actual_travel_time_min` SET TAGS ('dbx_business_glossary_term' = 'Actual Travel Time (Minutes)');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `actual_travel_time_min` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_value_regex' = 'customer_request|technician_unavailable|parts_unavailable|weather|duplicate|rescheduled|other');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `customer_signature_obtained` SET TAGS ('dbx_business_glossary_term' = 'Customer Signature Obtained Indicator');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `customer_signature_obtained` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `customer_site_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Site Name');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `dispatcher_notes` SET TAGS ('dbx_business_glossary_term' = 'Dispatcher Notes');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `estimated_travel_time_min` SET TAGS ('dbx_business_glossary_term' = 'Estimated Travel Time (Minutes)');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `estimated_travel_time_min` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `is_sla_breached` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Indicator');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `is_sla_breached` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `parts_required` SET TAGS ('dbx_business_glossary_term' = 'Parts Required Indicator');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `parts_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Priority');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `required_skill` SET TAGS ('dbx_business_glossary_term' = 'Required Skill');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `reschedule_count` SET TAGS ('dbx_business_glossary_term' = 'Reschedule Count');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `reschedule_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `schedule_number` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Schedule Number');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `schedule_number` SET TAGS ('dbx_value_regex' = '^DSP-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `scheduled_duration_min` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Duration (Minutes)');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `scheduled_duration_min` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `scheduled_end` SET TAGS ('dbx_business_glossary_term' = 'Scheduled End Datetime');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `scheduled_end` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `scheduled_start` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Start Datetime');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `scheduled_start` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `scheduling_method` SET TAGS ('dbx_business_glossary_term' = 'Scheduling Method');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `scheduling_method` SET TAGS ('dbx_value_regex' = 'manual|auto_optimized|semi_automated');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'installation|commissioning|preventive_maintenance|corrective_maintenance|inspection|technical_support|warranty_repair|upgrade|decommissioning');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `site_address` SET TAGS ('dbx_business_glossary_term' = 'Service Site Address');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `site_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `site_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `site_city` SET TAGS ('dbx_business_glossary_term' = 'Service Site City');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `site_country_code` SET TAGS ('dbx_business_glossary_term' = 'Service Site Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `site_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `sla_due` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Due Datetime');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `sla_due` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_field_service|sap_pm|maximo|manual');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Dispatch Status');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'scheduled|en_route|on_site|completed|cancelled|rescheduled');
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ALTER COLUMN `technician_notes` SET TAGS ('dbx_business_glossary_term' = 'Technician Field Notes');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` SET TAGS ('dbx_subdomain' = 'parts_inventory');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `spare_parts_request_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Request ID');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `field_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Field Service Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `procurement_purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `shipment_id` SET TAGS ('dbx_business_glossary_term' = 'Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `spare_part_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Delivery Date');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `actual_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|auto_approved');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `bom_position` SET TAGS ('dbx_business_glossary_term' = 'Bill of Materials (BOM) Position');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `delivery_address` SET TAGS ('dbx_business_glossary_term' = 'Delivery Address');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `delivery_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `delivery_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `delivery_country_code` SET TAGS ('dbx_business_glossary_term' = 'Delivery Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `delivery_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `equipment_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Serial Number');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `fulfillment_notes` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Notes');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `installed_base_reference` SET TAGS ('dbx_business_glossary_term' = 'Installed Base Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `part_category` SET TAGS ('dbx_business_glossary_term' = 'Part Category');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `part_category` SET TAGS ('dbx_value_regex' = 'mechanical|electrical|electronic|pneumatic|hydraulic|consumable|lubricant|fastener|sensor|software|safety|mro_general');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `promised_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Promised Delivery Date');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `promised_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `quantity_backordered` SET TAGS ('dbx_business_glossary_term' = 'Quantity Backordered');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `quantity_backordered` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `quantity_issued` SET TAGS ('dbx_business_glossary_term' = 'Quantity Issued');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `quantity_issued` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `quantity_requested` SET TAGS ('dbx_business_glossary_term' = 'Quantity Requested');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `quantity_requested` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `request_date` SET TAGS ('dbx_business_glossary_term' = 'Request Date');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `request_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `request_number` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Request Number');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `request_number` SET TAGS ('dbx_value_regex' = '^SPR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `request_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Request Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `request_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `request_type` SET TAGS ('dbx_business_glossary_term' = 'Request Type');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `request_type` SET TAGS ('dbx_value_regex' = 'field_service|warranty_repair|preventive_maintenance|emergency_breakdown|commissioning|upgrade|mro_replenishment');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_business_glossary_term' = 'Requested Delivery Date');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `requested_delivery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `service_contract_number` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Number');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `shipment_reference` SET TAGS ('dbx_business_glossary_term' = 'Shipment Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `shipping_method` SET TAGS ('dbx_business_glossary_term' = 'Shipping Method');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `shipping_method` SET TAGS ('dbx_value_regex' = 'standard|express|overnight|same_day|courier|will_call|inter_warehouse_transfer');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `source_storage_location` SET TAGS ('dbx_business_glossary_term' = 'Source Storage Location');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_FSM|MAXIMO_EAM|MANUAL|INFOR_WMS');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `source_warehouse_code` SET TAGS ('dbx_business_glossary_term' = 'Source Warehouse Code');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Request Status');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|approved|picking|partially_issued|fully_issued|shipped|delivered|cancelled|closed');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `substitute_part_number` SET TAGS ('dbx_business_glossary_term' = 'Substitute Part Number');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `total_cost` SET TAGS ('dbx_business_glossary_term' = 'Total Cost');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `total_cost` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `total_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `unit_cost` SET TAGS ('dbx_business_glossary_term' = 'Unit Cost');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `unit_cost` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `unit_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|PC|KG|L|M|M2|M3|SET|BOX|ROLL|PAIR|PKG');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `urgency_level` SET TAGS ('dbx_business_glossary_term' = 'Urgency Level');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `urgency_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|planned');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `warranty_covered` SET TAGS ('dbx_business_glossary_term' = 'Warranty Covered Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ALTER COLUMN `warranty_covered` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` SET TAGS ('dbx_subdomain' = 'parts_inventory');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `spare_parts_catalog_id` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Catalog ID');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `compliance_reach_substance_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Reach Substance Declaration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `rohs_compliance_record_id` SET TAGS ('dbx_business_glossary_term' = 'Rohs Compliance Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `availability_status` SET TAGS ('dbx_business_glossary_term' = 'Availability Status');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `availability_status` SET TAGS ('dbx_value_regex' = 'active|phase_out|discontinued|on_request|limited_availability|new|blocked');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `catalog_effective_date` SET TAGS ('dbx_business_glossary_term' = 'Catalog Effective Date');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `catalog_effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `catalog_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Catalog Expiry Date');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `catalog_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `compatible_product_lines` SET TAGS ('dbx_business_glossary_term' = 'Compatible Product Lines');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `customs_tariff_number` SET TAGS ('dbx_business_glossary_term' = 'Customs Tariff Number (HS Code)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `customs_tariff_number` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `ecn_reference` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `ecn_reference` SET TAGS ('dbx_value_regex' = '^ECN-[A-Z0-9-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification Number (ECCN)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material (HazMat) Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `last_price_update_date` SET TAGS ('dbx_business_glossary_term' = 'Last Price Update Date');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `last_price_update_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `list_price` SET TAGS ('dbx_business_glossary_term' = 'List Price');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `list_price` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `list_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `list_price_currency` SET TAGS ('dbx_business_glossary_term' = 'List Price Currency');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `list_price_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `manufacturer_name` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Name');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `manufacturer_part_number` SET TAGS ('dbx_business_glossary_term' = 'Manufacturer Part Number (MPN)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `manufacturer_part_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{2,50}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_business_glossary_term' = 'Minimum Order Quantity (MOQ)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `minimum_order_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,3})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `part_category` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Category');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `part_type` SET TAGS ('dbx_business_glossary_term' = 'Spare Part Type');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `part_type` SET TAGS ('dbx_value_regex' = 'consumable|wear_part|spare_part|assembly|kit|tool|accessory|software_license|documentation');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `product_family` SET TAGS ('dbx_business_glossary_term' = 'Compatible Product Family');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `reach_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `reach_compliant_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `rohs_compliant_flag` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `rohs_compliant_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `service_contract_eligible_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `service_contract_eligible_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `shelf_life_days` SET TAGS ('dbx_business_glossary_term' = 'Shelf Life (Days)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `shelf_life_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER_PLM|SALESFORCE_CRM|MANUAL');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `standard_cost` SET TAGS ('dbx_business_glossary_term' = 'Standard Cost');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `standard_cost` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `standard_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `standard_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Standard Cost Currency');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `standard_cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `standard_lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Standard Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `standard_lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `storage_conditions` SET TAGS ('dbx_business_glossary_term' = 'Storage Conditions');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `superseded_by_part_number` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Part Number');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `superseded_by_part_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{3,40}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `supersedes_part_number` SET TAGS ('dbx_business_glossary_term' = 'Supersedes Part Number');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `supersedes_part_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-.]{3,40}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|PC|KG|M|L|SET|BOX|ROLL|PAIR|PACK');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `warranty_duration_months` SET TAGS ('dbx_business_glossary_term' = 'Warranty Duration (Months)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `warranty_duration_months` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Weight (Kilograms)');
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ALTER COLUMN `weight_kg` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` SET TAGS ('dbx_subdomain' = 'field_operations');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `installation_record_id` SET TAGS ('dbx_business_glossary_term' = 'Installation Record ID');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Delivery Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `environmental_permit_id` SET TAGS ('dbx_business_glossary_term' = 'Environmental Permit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `fai_record_id` SET TAGS ('dbx_business_glossary_term' = 'Fai Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `functional_location_id` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Installer Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `product_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Certification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `serialized_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Serialized Unit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Installation End Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Installation Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `ce_marking_verified` SET TAGS ('dbx_business_glossary_term' = 'CE Marking Verified Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `ce_marking_verified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `checklist_completion_percentage` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Checklist Completion Percentage');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `checklist_completion_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `checklist_completion_status` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Checklist Completion Status');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `checklist_completion_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|completed_with_exceptions');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `commissioning_engineer` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Engineer Name');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `commissioning_engineer_certification` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Engineer Certification Code');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `customer_sign_off_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Customer Sign-Off Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `customer_sign_off_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `customer_signatory_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Signatory Name');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `customer_signatory_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `fai_date` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Date');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `fai_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `fai_report_reference` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Report Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `fai_result` SET TAGS ('dbx_business_glossary_term' = 'First Article Inspection (FAI) Result');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `fai_result` SET TAGS ('dbx_value_regex' = 'pass|fail|conditional_pass|not_required|pending');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `firmware_version` SET TAGS ('dbx_business_glossary_term' = 'Installed Firmware Version');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `functional_location_code` SET TAGS ('dbx_business_glossary_term' = 'Functional Location Code');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `handover_document_reference` SET TAGS ('dbx_business_glossary_term' = 'Handover Documentation Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `installation_notes` SET TAGS ('dbx_business_glossary_term' = 'Installation Notes');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `installation_type` SET TAGS ('dbx_business_glossary_term' = 'Installation Type');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `installation_type` SET TAGS ('dbx_value_regex' = 'new_installation|upgrade|replacement|relocation|decommission');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `is_customer_signed_off` SET TAGS ('dbx_business_glossary_term' = 'Customer Sign-Off Status');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `is_customer_signed_off` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}-[A-Z]{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `ncr_reference` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Report (NCR) Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `product_category` SET TAGS ('dbx_business_glossary_term' = 'Installed Product Category');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `product_category` SET TAGS ('dbx_value_regex' = 'automation_system|electrification_solution|plc_panel|drive|switchgear|smart_infrastructure|hmi|sensor|motor|transformer|other');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `product_sku` SET TAGS ('dbx_business_glossary_term' = 'Product Stock Keeping Unit (SKU)');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `project_reference` SET TAGS ('dbx_business_glossary_term' = 'Project Reference Number');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `record_number` SET TAGS ('dbx_business_glossary_term' = 'Installation Record Number');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `record_number` SET TAGS ('dbx_value_regex' = '^IR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `safety_check_completed` SET TAGS ('dbx_business_glossary_term' = 'Safety Check Completed Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `safety_check_completed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `scheduled_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Installation Date');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `scheduled_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_address_line1` SET TAGS ('dbx_business_glossary_term' = 'Site Address Line 1');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_address_line1` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_address_line1` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_address_line2` SET TAGS ('dbx_business_glossary_term' = 'Site Address Line 2');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_address_line2` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_address_line2` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_city` SET TAGS ('dbx_business_glossary_term' = 'Site City');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_country_code` SET TAGS ('dbx_business_glossary_term' = 'Site Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_name` SET TAGS ('dbx_business_glossary_term' = 'Installation Site Name');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_postal_code` SET TAGS ('dbx_business_glossary_term' = 'Site Postal Code');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_postal_code` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_postal_code` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `site_state_province` SET TAGS ('dbx_business_glossary_term' = 'Site State or Province');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Installation Status');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|commissioned|pending_sign_off|completed|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `warranty_activation_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Activation Date');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `warranty_activation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiry Date');
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` SET TAGS ('dbx_subdomain' = 'customer_support');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `remote_support_session_id` SET TAGS ('dbx_business_glossary_term' = 'Remote Support Session ID');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Support Engineer ID');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `ot_system_id` SET TAGS ('dbx_business_glossary_term' = 'Ot System Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `request_id` SET TAGS ('dbx_business_glossary_term' = 'Service Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `support_engineer_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Support Engineer Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `assigned_engineer_name` SET TAGS ('dbx_business_glossary_term' = 'Assigned Support Engineer Name');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `billing_type` SET TAGS ('dbx_business_glossary_term' = 'Billing Type');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `billing_type` SET TAGS ('dbx_value_regex' = 'contract_covered|time_and_material|warranty_covered|goodwill|internal|not_billable');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `capa_reference` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `customer_consent_obtained` SET TAGS ('dbx_business_glossary_term' = 'Customer Remote Access Consent Obtained Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `customer_consent_obtained` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `customer_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Customer Contact Email Address');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `customer_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `customer_contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `customer_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `customer_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Contact Name');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `customer_contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `customer_contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `customer_satisfaction_score` SET TAGS ('dbx_business_glossary_term' = 'Customer Satisfaction Score');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `customer_satisfaction_score` SET TAGS ('dbx_value_regex' = '^([0-9]|10)(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `diagnostic_steps_performed` SET TAGS ('dbx_business_glossary_term' = 'Diagnostic Steps Performed');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `equipment_model` SET TAGS ('dbx_business_glossary_term' = 'Equipment Model');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `equipment_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Serial Number');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `escalation_level` SET TAGS ('dbx_business_glossary_term' = 'Escalation Level');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `escalation_level` SET TAGS ('dbx_value_regex' = '^[0-3]$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `follow_up_action_required` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Required');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `follow_up_action_required` SET TAGS ('dbx_value_regex' = 'none|field_dispatch_required|spare_part_shipment|software_update_scheduled|monitoring_required|customer_training|capa_initiated|other');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `is_field_dispatch_required` SET TAGS ('dbx_business_glossary_term' = 'Field Dispatch Required Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `is_field_dispatch_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `is_resolved` SET TAGS ('dbx_business_glossary_term' = 'Issue Resolved Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `is_resolved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `is_sla_breached` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Indicator');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `is_sla_breached` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `issue_category` SET TAGS ('dbx_business_glossary_term' = 'Issue Category');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `issue_category` SET TAGS ('dbx_value_regex' = 'hardware_fault|software_error|configuration_issue|communication_failure|performance_degradation|operator_error|firmware_issue|network_issue|other');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `issue_description` SET TAGS ('dbx_business_glossary_term' = 'Issue Description');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Session Language Code');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}-[A-Z]{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Session Priority');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `product_line` SET TAGS ('dbx_business_glossary_term' = 'Product Line');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `remote_access_method` SET TAGS ('dbx_business_glossary_term' = 'Remote Access Method');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `remote_access_method` SET TAGS ('dbx_value_regex' = 'VPN|SCADA_remote|MindSphere_remote_access|TeamViewer|WebEx|RDP|SSH|other');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `resolution_code` SET TAGS ('dbx_business_glossary_term' = 'Resolution Code');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `resolution_code` SET TAGS ('dbx_value_regex' = 'configuration_change|software_patch|parameter_reset|firmware_update|remote_reboot|operator_guidance|workaround_applied|no_fault_found|escalated_to_field|other');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `resolution_description` SET TAGS ('dbx_business_glossary_term' = 'Resolution Description');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'design_defect|manufacturing_defect|installation_error|operator_error|software_bug|environmental_factor|wear_and_tear|configuration_error|unknown|other');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `scheduled_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Session Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `scheduled_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_cost` SET TAGS ('dbx_business_glossary_term' = 'Remote Support Session Cost');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_cost` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Session Duration Minutes');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_duration_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Session End Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_end_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_number` SET TAGS ('dbx_business_glossary_term' = 'Remote Support Session Number');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_number` SET TAGS ('dbx_value_regex' = '^RSS-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_recording_available` SET TAGS ('dbx_business_glossary_term' = 'Session Recording Available Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_recording_available` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Session Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_type` SET TAGS ('dbx_business_glossary_term' = 'Remote Session Type');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `session_type` SET TAGS ('dbx_value_regex' = 'diagnostic|configuration|software_update|commissioning_support|training|troubleshooting|preventive_check');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `site_country_code` SET TAGS ('dbx_business_glossary_term' = 'Site Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `site_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `site_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Site Name');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `sla_response_target_minutes` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Response Target Minutes');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `sla_response_target_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard|none');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `software_version` SET TAGS ('dbx_business_glossary_term' = 'Equipment Software Version');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Session Status');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'scheduled|in_progress|completed|cancelled|follow_up_required|escalated');
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ALTER COLUMN `support_team` SET TAGS ('dbx_business_glossary_term' = 'Support Team');
ALTER TABLE `manufacturing_ecm`.`service`.`report` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`report` SET TAGS ('dbx_subdomain' = 'field_operations');
ALTER TABLE `manufacturing_ecm`.`service`.`report` SET TAGS ('dbx_original_name' = 'service_report');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `report_id` SET TAGS ('dbx_business_glossary_term' = 'Service Report ID');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Completed By Employee Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `defect_code_id` SET TAGS ('dbx_business_glossary_term' = 'Defect Code Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `incident_id` SET TAGS ('dbx_business_glossary_term' = 'Incident Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `technician_id` SET TAGS ('dbx_business_glossary_term' = 'Service Technician ID');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Report Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `billing_type` SET TAGS ('dbx_business_glossary_term' = 'Billing Type');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `billing_type` SET TAGS ('dbx_value_regex' = 'contract|time_and_material|warranty|goodwill|internal|no_charge');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `customer_acceptance_notes` SET TAGS ('dbx_business_glossary_term' = 'Customer Acceptance Notes');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `customer_signature_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Signatory Name');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `customer_signature_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `customer_signature_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `customer_signed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Customer Signed Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `customer_signed_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `date` SET TAGS ('dbx_business_glossary_term' = 'Service Report Date');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `equipment_condition_found` SET TAGS ('dbx_business_glossary_term' = 'Equipment Condition Found');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `equipment_condition_found` SET TAGS ('dbx_value_regex' = 'operational|degraded|failed|unsafe|unknown');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `equipment_condition_left` SET TAGS ('dbx_business_glossary_term' = 'Equipment Condition Left');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `equipment_condition_left` SET TAGS ('dbx_value_regex' = 'operational|degraded|failed|unsafe|requires_follow_up');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `equipment_model` SET TAGS ('dbx_business_glossary_term' = 'Equipment Model Number');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `equipment_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Serial Number');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `failure_description` SET TAGS ('dbx_business_glossary_term' = 'Failure Description');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `is_follow_up_required` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Required Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `is_follow_up_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `is_safety_incident_reported` SET TAGS ('dbx_business_glossary_term' = 'Safety Incident Reported Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `is_safety_incident_reported` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `is_warranty_applicable` SET TAGS ('dbx_business_glossary_term' = 'Warranty Applicable Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `is_warranty_applicable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `labor_hours_total` SET TAGS ('dbx_business_glossary_term' = 'Total Labor Hours');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `labor_hours_total` SET TAGS ('dbx_value_regex' = '^d{1,5}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Report Language Code');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Service Report Number');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^SR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `parts_consumed_cost` SET TAGS ('dbx_business_glossary_term' = 'Parts Consumed Cost');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `parts_consumed_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `parts_replaced_description` SET TAGS ('dbx_business_glossary_term' = 'Parts Replaced Description');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `recommendations` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Recommendations');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `resolution_code` SET TAGS ('dbx_business_glossary_term' = 'Resolution Code');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `resolution_code` SET TAGS ('dbx_value_regex' = 'repaired|replaced|adjusted|cleaned|lubricated|software_updated|calibrated|no_fault_found|deferred|escalated');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Code');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `root_cause_code` SET TAGS ('dbx_value_regex' = 'design_defect|manufacturing_defect|installation_error|operator_misuse|wear_and_tear|environmental|software_fault|unknown|other');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `safety_observations` SET TAGS ('dbx_business_glossary_term' = 'Safety Observations');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `site_address` SET TAGS ('dbx_business_glossary_term' = 'Service Site Address');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `site_address` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `site_address` SET TAGS ('dbx_pii_address' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `site_country_code` SET TAGS ('dbx_business_glossary_term' = 'Service Site Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `site_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `site_name` SET TAGS ('dbx_business_glossary_term' = 'Service Site Name');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Service Report Status');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|customer_signed|approved|rejected|cancelled');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `submitted_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Report Submitted Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `submitted_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `technician_certification_number` SET TAGS ('dbx_business_glossary_term' = 'Technician Certification Number');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `test_outcome` SET TAGS ('dbx_business_glossary_term' = 'Test Outcome');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `test_outcome` SET TAGS ('dbx_value_regex' = 'pass|fail|conditional_pass|not_tested');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `test_results_description` SET TAGS ('dbx_business_glossary_term' = 'Test Results Description');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `travel_time_hours` SET TAGS ('dbx_business_glossary_term' = 'Travel Time Hours');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `travel_time_hours` SET TAGS ('dbx_value_regex' = '^d{1,3}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Service Report Type');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'installation|commissioning|preventive_maintenance|corrective_repair|inspection|warranty_repair|upgrade|decommissioning|technical_support');
ALTER TABLE `manufacturing_ecm`.`service`.`report` ALTER COLUMN `work_performed_description` SET TAGS ('dbx_business_glossary_term' = 'Work Performed Description');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` SET TAGS ('dbx_subdomain' = 'customer_support');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` SET TAGS ('dbx_original_name' = 'service_escalation');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `escalation_id` SET TAGS ('dbx_business_glossary_term' = 'Service Escalation ID');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `field_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Field Service Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `service_ticket_id` SET TAGS ('dbx_business_glossary_term' = 'Service Ticket Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `business_impact_description` SET TAGS ('dbx_business_glossary_term' = 'Business Impact Description');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `capa_reference` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Escalation Category');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'technical|commercial|logistics|safety|compliance|relationship|warranty|contractual');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Closed Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `customer_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Name');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `customer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `de_escalation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'De-Escalation Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `de_escalation_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `equipment_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Serial Number');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `escalated_by_name` SET TAGS ('dbx_business_glossary_term' = 'Escalated By Name');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `escalated_by_role` SET TAGS ('dbx_business_glossary_term' = 'Escalated By Role');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `escalated_to_individual` SET TAGS ('dbx_business_glossary_term' = 'Escalated To Individual');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `escalated_to_role` SET TAGS ('dbx_business_glossary_term' = 'Escalated To Role');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `escalated_to_team` SET TAGS ('dbx_business_glossary_term' = 'Escalated To Team');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `estimated_revenue_at_risk` SET TAGS ('dbx_business_glossary_term' = 'Estimated Revenue at Risk');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `estimated_revenue_at_risk` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `executive_sponsor` SET TAGS ('dbx_business_glossary_term' = 'Executive Sponsor');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `first_response_timestamp` SET TAGS ('dbx_business_glossary_term' = 'First Response Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `first_response_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `is_customer_notified` SET TAGS ('dbx_business_glossary_term' = 'Customer Notified Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `is_customer_notified` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `is_sla_breached` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breached Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `is_sla_breached` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `level` SET TAGS ('dbx_business_glossary_term' = 'Escalation Level');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `level` SET TAGS ('dbx_value_regex' = 'L1|L2|L3|L4');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Escalation Number');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^ESC-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Escalation Priority');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `product_line` SET TAGS ('dbx_business_glossary_term' = 'Product Line');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `resolution_actions` SET TAGS ('dbx_business_glossary_term' = 'Resolution Actions Taken');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `resolution_type` SET TAGS ('dbx_business_glossary_term' = 'Resolution Type');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `resolution_type` SET TAGS ('dbx_value_regex' = 'technical_fix|software_patch|part_replacement|on_site_visit|remote_support|commercial_concession|process_change|escalation_to_engineering|workaround|no_fault_found|customer_education');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `resolved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Resolved Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `resolved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'product_defect|software_bug|installation_error|operator_error|design_flaw|supply_chain|process_gap|documentation_error|environmental|unknown');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `site_country_code` SET TAGS ('dbx_business_glossary_term' = 'Site Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `site_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `site_region` SET TAGS ('dbx_business_glossary_term' = 'Site Region');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `sla_breach_type` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Type');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `sla_breach_type` SET TAGS ('dbx_value_regex' = 'response_breach|resolution_breach|both|none');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `source_record_number` SET TAGS ('dbx_business_glossary_term' = 'Source Record Number');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `source_record_type` SET TAGS ('dbx_business_glossary_term' = 'Source Record Type');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `source_record_type` SET TAGS ('dbx_value_regex' = 'service_request|field_service_order');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Escalation Status');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|in_progress|pending_customer|pending_engineering|resolved|de_escalated|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `target_resolution_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Target Resolution Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `target_resolution_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `timestamp` SET TAGS ('dbx_business_glossary_term' = 'Escalation Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `trigger_description` SET TAGS ('dbx_business_glossary_term' = 'Escalation Trigger Description');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `trigger_reason` SET TAGS ('dbx_business_glossary_term' = 'Escalation Trigger Reason');
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ALTER COLUMN `trigger_reason` SET TAGS ('dbx_value_regex' = 'sla_breach|customer_dissatisfaction|technical_complexity|high_revenue_impact|safety_risk|repeat_failure|executive_request|regulatory_compliance|contractual_penalty|escalation_by_customer');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` SET TAGS ('dbx_subdomain' = 'customer_support');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `nps_survey_id` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS) Survey ID');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `field_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Field Service Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `business_unit` SET TAGS ('dbx_business_glossary_term' = 'Business Unit');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `campaign_code` SET TAGS ('dbx_business_glossary_term' = 'NPS Survey Campaign Code');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `campaign_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `campaign_name` SET TAGS ('dbx_business_glossary_term' = 'NPS Survey Campaign Name');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `consent_obtained` SET TAGS ('dbx_business_glossary_term' = 'Customer Communication Consent Obtained Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `consent_obtained` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `contact_email` SET TAGS ('dbx_business_glossary_term' = 'Customer Contact Email Address');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `contact_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Contact Full Name');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Number');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `customer_account_number` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `customer_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Name');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `customer_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `customer_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `dispatch_channel` SET TAGS ('dbx_business_glossary_term' = 'Survey Dispatch Channel');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `dispatch_channel` SET TAGS ('dbx_value_regex' = 'email|sms|in_app|portal|manual');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `dispatch_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Survey Dispatch Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `dispatch_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `expiry_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Survey Expiry Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `expiry_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `feedback_language_code` SET TAGS ('dbx_business_glossary_term' = 'Feedback Language Code');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `feedback_language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `follow_up_completed_date` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Completed Date');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `follow_up_completed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `follow_up_owner` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Owner');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `follow_up_required` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Required Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `follow_up_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `follow_up_status` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Status');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `follow_up_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|in_progress|completed|escalated|cancelled');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `last_reminder_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Survey Reminder Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `last_reminder_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `nps_score` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS) Rating');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `nps_score` SET TAGS ('dbx_value_regex' = '^([0-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `product_line` SET TAGS ('dbx_business_glossary_term' = 'Product Line');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `reminder_count` SET TAGS ('dbx_business_glossary_term' = 'Survey Reminder Count');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `reminder_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `respondent_category` SET TAGS ('dbx_business_glossary_term' = 'NPS Respondent Category');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `respondent_category` SET TAGS ('dbx_value_regex' = 'promoter|passive|detractor|no_response');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `response_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Survey Response Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `response_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization Code');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `service_region` SET TAGS ('dbx_business_glossary_term' = 'Service Region');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard|none');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_service_cloud|sap_s4hana|siemens_opcenter|manual|other');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'NPS Survey Status');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|dispatched|opened|responded|expired|cancelled|closed');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `survey_language_code` SET TAGS ('dbx_business_glossary_term' = 'Survey Language Code');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `survey_language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `survey_number` SET TAGS ('dbx_business_glossary_term' = 'NPS Survey Number');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `survey_number` SET TAGS ('dbx_value_regex' = '^NPS-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `trigger_event_reference` SET TAGS ('dbx_business_glossary_term' = 'Survey Trigger Event Reference Number');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `trigger_event_type` SET TAGS ('dbx_business_glossary_term' = 'Survey Trigger Event Type');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `trigger_event_type` SET TAGS ('dbx_value_regex' = 'field_service_order_completed|warranty_claim_resolved|service_contract_renewed|installation_completed|commissioning_completed|technical_support_resolved|preventive_maintenance_completed|other');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `verbatim_feedback` SET TAGS ('dbx_business_glossary_term' = 'Verbatim Customer Feedback');
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ALTER COLUMN `verbatim_feedback` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` SET TAGS ('dbx_subdomain' = 'contract_management');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` SET TAGS ('dbx_original_name' = 'service_entitlement');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `entitlement_id` SET TAGS ('dbx_business_glossary_term' = 'Service Entitlement ID');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `activation_date` SET TAGS ('dbx_business_glossary_term' = 'Entitlement Activation Date');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `activation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto-Renewal Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `coverage_scope` SET TAGS ('dbx_business_glossary_term' = 'Coverage Scope');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `coverage_scope` SET TAGS ('dbx_value_regex' = 'parts_and_labor|labor_only|parts_only|remote_support_only|on_site_and_remote|preventive_maintenance_only');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `covered_product_family` SET TAGS ('dbx_business_glossary_term' = 'Covered Product Family');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `covered_product_sku` SET TAGS ('dbx_business_glossary_term' = 'Covered Product Stock Keeping Unit (SKU)');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `covered_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Covered Equipment Serial Number');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Entitlement End Date');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `incidents_consumed` SET TAGS ('dbx_business_glossary_term' = 'Service Incidents Consumed');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `incidents_consumed` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `incidents_remaining` SET TAGS ('dbx_business_glossary_term' = 'Service Incidents Remaining');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `incidents_remaining` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `is_transferable` SET TAGS ('dbx_business_glossary_term' = 'Entitlement Transferable Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `is_transferable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Entitlement Name');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Entitlement Number');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^ENT-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `on_site_support_flag` SET TAGS ('dbx_business_glossary_term' = 'On-Site Support Included Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `on_site_support_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `owning_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Owning Business Unit');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Service Region');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `remote_support_flag` SET TAGS ('dbx_business_glossary_term' = 'Remote Support Included Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `remote_support_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `renewal_date` SET TAGS ('dbx_business_glossary_term' = 'Entitlement Renewal Date');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `renewal_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `resolution_time_hours` SET TAGS ('dbx_business_glossary_term' = 'SLA Resolution Time Hours');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `response_time_hours` SET TAGS ('dbx_business_glossary_term' = 'SLA Response Time Hours');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `service_hours_coverage` SET TAGS ('dbx_business_glossary_term' = 'Service Hours Coverage');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `service_hours_coverage` SET TAGS ('dbx_value_regex' = '24x7|business_hours|extended_hours|8x5|8x7|custom');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard|basic');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce|sap_s4hana|manual|migration');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `spare_parts_coverage_flag` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Coverage Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `spare_parts_coverage_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `spare_parts_coverage_limit` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Coverage Limit');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `spare_parts_coverage_limit` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Entitlement Start Date');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Entitlement Status');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|expired|pending_activation|suspended|cancelled');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `total_incidents_allowed` SET TAGS ('dbx_business_glossary_term' = 'Total Service Incidents Allowed');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `total_incidents_allowed` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Entitlement Type');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'warranty|service_contract|support_tier|subscription|extended_warranty|preventive_maintenance');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `value` SET TAGS ('dbx_business_glossary_term' = 'Entitlement Value');
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ALTER COLUMN `value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` SET TAGS ('dbx_subdomain' = 'contract_management');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` SET TAGS ('dbx_original_name' = 'service_price_list');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `service_price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Service Price List ID');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `condition_type` SET TAGS ('dbx_business_glossary_term' = 'SAP Condition Type');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `customer_segment` SET TAGS ('dbx_business_glossary_term' = 'Customer Segment');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `customer_segment` SET TAGS ('dbx_value_regex' = 'all|strategic|preferred|standard|distributor|oem|government|internal');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `discount_eligible` SET TAGS ('dbx_business_glossary_term' = 'Discount Eligibility Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `discount_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = 'direct|indirect|online|partner|internal');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `list_price` SET TAGS ('dbx_business_glossary_term' = 'List Price');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `list_price` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `max_discount_percent` SET TAGS ('dbx_business_glossary_term' = 'Maximum Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `max_discount_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `minimum_charge` SET TAGS ('dbx_business_glossary_term' = 'Minimum Charge');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `minimum_charge` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Price List Name');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Service Price List Number');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^SPL-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `pricing_scale_type` SET TAGS ('dbx_business_glossary_term' = 'Pricing Scale Type');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `pricing_scale_type` SET TAGS ('dbx_value_regex' = 'none|quantity_scale|value_scale|time_scale');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `product_line` SET TAGS ('dbx_business_glossary_term' = 'Product Line');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `scale_quantity_from` SET TAGS ('dbx_business_glossary_term' = 'Scale Quantity From');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `service_category` SET TAGS ('dbx_business_glossary_term' = 'Service Category');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `service_category` SET TAGS ('dbx_value_regex' = 'field_service|remote_service|depot_repair|training|consulting|managed_service');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `service_item_code` SET TAGS ('dbx_business_glossary_term' = 'Service Item Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `service_item_description` SET TAGS ('dbx_business_glossary_term' = 'Service Item Description');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'Service Type');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'labor|spare_parts|service_package|travel_expense|emergency_surcharge|out_of_hours_surcharge|remote_support|preventive_maintenance|commissioning|inspection');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Price List Status');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|expired|superseded|withdrawn');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `superseded_by` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Price List Number');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `surcharge_percent` SET TAGS ('dbx_business_glossary_term' = 'Surcharge Percentage');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `surcharge_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `tax_classification` SET TAGS ('dbx_business_glossary_term' = 'Tax Classification');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `tax_classification` SET TAGS ('dbx_value_regex' = 'taxable|exempt|zero_rated|reduced_rate');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `technician_skill_tier` SET TAGS ('dbx_business_glossary_term' = 'Technician Skill Tier');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `technician_skill_tier` SET TAGS ('dbx_value_regex' = 'junior|standard|senior|specialist|master');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UOM)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'hour|day|flat_rate|per_unit|per_km|per_trip|per_visit|per_month|per_year');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Price List Valid From Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Price List Valid To Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Price List Version Number');
ALTER TABLE `manufacturing_ecm`.`service`.`service_price_list` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` SET TAGS ('dbx_subdomain' = 'contract_management');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` SET TAGS ('dbx_original_name' = 'service_quotation');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `service_quotation_id` SET TAGS ('dbx_business_glossary_term' = 'Service Quotation ID');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `field_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Field Service Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `proforma_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Proforma Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `service_price_list_id` SET TAGS ('dbx_business_glossary_term' = 'Service Price List Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `accepted_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Quotation Accepted Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `accepted_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `assigned_sales_representative` SET TAGS ('dbx_business_glossary_term' = 'Assigned Sales Representative');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `customer_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Reference Number');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `date` SET TAGS ('dbx_business_glossary_term' = 'Quotation Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `discount_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `discount_percent` SET TAGS ('dbx_business_glossary_term' = 'Discount Percentage');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `discount_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|d{1,2}(.d{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `discount_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_business_glossary_term' = 'Distribution Channel');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `distribution_channel` SET TAGS ('dbx_value_regex' = 'direct|partner|distributor|online|field_service');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `division` SET TAGS ('dbx_business_glossary_term' = 'Division');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `equipment_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Serial Number');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Quoted Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `gross_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `incoterms` SET TAGS ('dbx_business_glossary_term' = 'Incoterms');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `incoterms` SET TAGS ('dbx_value_regex' = 'EXW|FCA|CPT|CIP|DAP|DPU|DDP|FAS|FOB|CFR|CIF');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `labor_amount` SET TAGS ('dbx_business_glossary_term' = 'Quoted Labor Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `labor_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Quoted Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `net_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Service Quotation Number');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^QT-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `parts_amount` SET TAGS ('dbx_business_glossary_term' = 'Quoted Parts Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `parts_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `product_model_number` SET TAGS ('dbx_business_glossary_term' = 'Product Model Number');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Quotation Rejection Reason');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_value_regex' = 'price_too_high|competitor_selected|budget_constraints|scope_mismatch|no_response|internal_cancellation|other');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `service_scope_description` SET TAGS ('dbx_business_glossary_term' = 'Quoted Service Scope Description');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Quotation Status');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|accepted|rejected|expired|cancelled|revised');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `submitted_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Quotation Submitted Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `submitted_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `travel_amount` SET TAGS ('dbx_business_glossary_term' = 'Quoted Travel Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `travel_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Quotation Type');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'out_of_warranty_repair|time_and_material|service_contract_renewal|spare_parts_supply|commissioning|upgrade|inspection');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_business_glossary_term' = 'Quotation Validity End Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `validity_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_business_glossary_term' = 'Quotation Validity Start Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `validity_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Quotation Version Number');
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` SET TAGS ('dbx_subdomain' = 'contract_management');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` SET TAGS ('dbx_original_name' = 'service_invoice');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `service_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Service Invoice ID');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `ar_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ar Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `field_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Field Service Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `billing_category` SET TAGS ('dbx_business_glossary_term' = 'Billing Category');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `billing_category` SET TAGS ('dbx_value_regex' = 'field_service_labor|spare_parts|travel_expense|contract_periodic|installation|commissioning|remote_support|training|inspection');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `billing_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Period End Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `billing_period_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `billing_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Billing Period Start Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `billing_period_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `company_code` SET TAGS ('dbx_business_glossary_term' = 'Company Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `company_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Invoice Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_business_glossary_term' = 'Discount Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `discount_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_business_glossary_term' = 'Invoice Dispute Reason');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `dispute_reason` SET TAGS ('dbx_value_regex' = 'pricing_error|service_not_rendered|duplicate_invoice|warranty_coverage|parts_quality|quantity_discrepancy|other');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `dunning_date` SET TAGS ('dbx_business_glossary_term' = 'Last Dunning Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `dunning_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `dunning_level` SET TAGS ('dbx_business_glossary_term' = 'Dunning Level');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `dunning_level` SET TAGS ('dbx_value_regex' = '^[0-4]$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_value_regex' = '^[0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_business_glossary_term' = 'Gross Invoice Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `gross_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_business_glossary_term' = 'Net Invoice Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `net_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `paid_amount` SET TAGS ('dbx_business_glossary_term' = 'Paid Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `paid_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `payment_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `payment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `payment_due_date` SET TAGS ('dbx_business_glossary_term' = 'Payment Due Date');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `payment_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `profit_center` SET TAGS ('dbx_business_glossary_term' = 'Profit Center');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `profit_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,20}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_business_glossary_term' = 'Reference Document Number');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `reference_document_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{1,40}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `sales_organization` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SALESFORCE_CRM|MANUAL');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Invoice Status');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|posted|sent|partially_paid|paid|overdue|cancelled|disputed|written_off');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_business_glossary_term' = 'Tax Amount');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `tax_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `tax_code` SET TAGS ('dbx_business_glossary_term' = 'Tax Code');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `tax_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,10}$');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Invoice Type');
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'standard|credit_memo|debit_memo|proforma|cancellation|periodic_contract');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` SET TAGS ('dbx_subdomain' = 'parts_inventory');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `knowledge_article_id` SET TAGS ('dbx_business_glossary_term' = 'Knowledge Article ID');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Author Employee ID');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `applicable_firmware_version` SET TAGS ('dbx_business_glossary_term' = 'Applicable Firmware Version');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `applicable_product_skus` SET TAGS ('dbx_business_glossary_term' = 'Applicable Product Stock Keeping Units (SKUs)');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `article_number` SET TAGS ('dbx_business_glossary_term' = 'Knowledge Article Number');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `article_number` SET TAGS ('dbx_value_regex' = '^KA-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `author_name` SET TAGS ('dbx_business_glossary_term' = 'Article Author Name');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `author_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `error_codes` SET TAGS ('dbx_business_glossary_term' = 'Associated Error Codes');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Article Expiry Date');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `helpful_votes` SET TAGS ('dbx_business_glossary_term' = 'Helpful Votes Count');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `helpful_votes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Language Code');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}-[A-Z]{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Last Reviewed Date');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `linked_case_count` SET TAGS ('dbx_business_glossary_term' = 'Linked Service Case Count');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `linked_case_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `not_helpful_votes` SET TAGS ('dbx_business_glossary_term' = 'Not Helpful Votes Count');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `not_helpful_votes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `product_category` SET TAGS ('dbx_business_glossary_term' = 'Applicable Product Category');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `product_family` SET TAGS ('dbx_business_glossary_term' = 'Applicable Product Family');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `publication_date` SET TAGS ('dbx_business_glossary_term' = 'Publication Date');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `publication_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `related_part_numbers` SET TAGS ('dbx_business_glossary_term' = 'Related Part Numbers');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `resolution_steps` SET TAGS ('dbx_business_glossary_term' = 'Resolution Steps');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `review_comments` SET TAGS ('dbx_business_glossary_term' = 'Review Comments');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `review_status` SET TAGS ('dbx_business_glossary_term' = 'Review Status');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `review_status` SET TAGS ('dbx_value_regex' = 'pending_review|under_review|approved|rejected|revision_required');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `reviewer_name` SET TAGS ('dbx_business_glossary_term' = 'Article Reviewer Name');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `reviewer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `root_cause` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `safety_advisory_flag` SET TAGS ('dbx_business_glossary_term' = 'Safety Advisory Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `safety_advisory_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `search_keywords` SET TAGS ('dbx_business_glossary_term' = 'Search Keywords');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `service_territory_scope` SET TAGS ('dbx_business_glossary_term' = 'Service Territory Scope');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_knowledge|teamcenter|manual|migrated');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Knowledge Article Status');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|in_review|approved|published|archived|retired');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `symptom_description` SET TAGS ('dbx_business_glossary_term' = 'Symptom Description');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Knowledge Article Title');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Knowledge Article Type');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'troubleshooting_guide|repair_procedure|product_bulletin|faq|installation_guide|best_practice|safety_advisory|software_release_note');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `usage_count` SET TAGS ('dbx_business_glossary_term' = 'Article Usage Count');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `usage_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Article Version Number');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^d+.d+$');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `visibility` SET TAGS ('dbx_business_glossary_term' = 'Knowledge Article Visibility');
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ALTER COLUMN `visibility` SET TAGS ('dbx_value_regex' = 'internal_only|partner|customer_portal|public');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` SET TAGS ('dbx_subdomain' = 'customer_support');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` SET TAGS ('dbx_original_name' = 'service_feedback');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `feedback_id` SET TAGS ('dbx_business_glossary_term' = 'Service Feedback ID');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `field_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Field Service Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `innovation_pipeline_id` SET TAGS ('dbx_business_glossary_term' = 'Innovation Pipeline Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `assigned_technician_name` SET TAGS ('dbx_business_glossary_term' = 'Assigned Technician Name');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `capa_reference` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `collection_channel` SET TAGS ('dbx_business_glossary_term' = 'Feedback Collection Channel');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `collection_channel` SET TAGS ('dbx_value_regex' = 'email|sms|web_portal|mobile_app|phone|in_person|automated_ivr');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `collection_date` SET TAGS ('dbx_business_glossary_term' = 'Feedback Collection Date');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `collection_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `collection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Feedback Collection Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `communication_rating` SET TAGS ('dbx_business_glossary_term' = 'Communication Quality Rating');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `communication_rating` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `consent_to_publish_flag` SET TAGS ('dbx_business_glossary_term' = 'Customer Consent to Publish Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `consent_to_publish_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `contact_email` SET TAGS ('dbx_business_glossary_term' = 'Customer Contact Email Address');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `contact_name` SET TAGS ('dbx_business_glossary_term' = 'Customer Contact Full Name');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `contact_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Customer Contact Phone Number');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `contact_phone` SET TAGS ('dbx_value_regex' = '^+?[0-9s-().]{7,20}$');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `equipment_serial_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Serial Number');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `follow_up_completed_date` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Completion Date');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `follow_up_completed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `follow_up_required_flag` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Required Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `follow_up_required_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `follow_up_status` SET TAGS ('dbx_business_glossary_term' = 'Follow-Up Action Status');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `follow_up_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|in_progress|completed|escalated');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `is_first_time_fix` SET TAGS ('dbx_business_glossary_term' = 'First Time Fix Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `is_first_time_fix` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Feedback Language Code');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Service Feedback Number');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^SFB-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `overall_satisfaction_rating` SET TAGS ('dbx_business_glossary_term' = 'Overall Customer Satisfaction (CSAT) Rating');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `overall_satisfaction_rating` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `parts_availability_rating` SET TAGS ('dbx_business_glossary_term' = 'Spare Parts Availability Rating');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `parts_availability_rating` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `problem_resolution_rating` SET TAGS ('dbx_business_glossary_term' = 'Problem Resolution Quality Rating');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `problem_resolution_rating` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `product_line` SET TAGS ('dbx_business_glossary_term' = 'Product Line');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `repeat_visit_flag` SET TAGS ('dbx_business_glossary_term' = 'Repeat Visit Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `repeat_visit_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `response_time_rating` SET TAGS ('dbx_business_glossary_term' = 'Response Time Rating');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `response_time_rating` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `service_event_reference` SET TAGS ('dbx_business_glossary_term' = 'Service Event Reference Number');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `service_event_type` SET TAGS ('dbx_business_glossary_term' = 'Service Event Type');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `service_event_type` SET TAGS ('dbx_value_regex' = 'field_service_visit|remote_support|warranty_claim_resolution|installation|commissioning|preventive_maintenance|technical_support|spare_parts_delivery');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `site_region` SET TAGS ('dbx_business_glossary_term' = 'Service Site Region');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'salesforce_service_cloud|sap_s4hana|siemens_opcenter|manual_entry|third_party_survey');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Feedback Status');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'pending|submitted|acknowledged|closed|invalid|escalated');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `survey_template_version` SET TAGS ('dbx_business_glossary_term' = 'Survey Template Version');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `technician_professionalism_rating` SET TAGS ('dbx_business_glossary_term' = 'Technician Professionalism Rating');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `technician_professionalism_rating` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `verbatim_comment` SET TAGS ('dbx_business_glossary_term' = 'Verbatim Customer Comment');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `verbatim_comment` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `would_recommend_flag` SET TAGS ('dbx_business_glossary_term' = 'Would Recommend Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ALTER COLUMN `would_recommend_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` SET TAGS ('dbx_subdomain' = 'customer_support');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `product_return_id` SET TAGS ('dbx_business_glossary_term' = 'Product Return ID');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `ap_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Ap Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `batch_id` SET TAGS ('dbx_business_glossary_term' = 'Batch Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Customer Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `inspection_lot_id` SET TAGS ('dbx_business_glossary_term' = 'Inspection Lot Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `logistics_inbound_delivery_id` SET TAGS ('dbx_business_glossary_term' = 'Inbound Shipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Supplier Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `product_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `sales_order_id` SET TAGS ('dbx_business_glossary_term' = 'Sales Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `usage_decision_id` SET TAGS ('dbx_business_glossary_term' = 'Usage Decision Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `warranty_claim_id` SET TAGS ('dbx_business_glossary_term' = 'Warranty Claim Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `authorization_date` SET TAGS ('dbx_business_glossary_term' = 'Return Authorization Date');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `authorization_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `capa_reference` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `condition_on_receipt` SET TAGS ('dbx_business_glossary_term' = 'Condition on Receipt');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `condition_on_receipt` SET TAGS ('dbx_value_regex' = 'intact|damaged_packaging|physically_damaged|incomplete|missing_accessories|beyond_repair|not_received');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `customer_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Customer Reference Number');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `defect_code` SET TAGS ('dbx_business_glossary_term' = 'Defect Code');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `disposition` SET TAGS ('dbx_business_glossary_term' = 'Disposition Decision');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `disposition` SET TAGS ('dbx_value_regex' = 'repair|replace|scrap|credit|return_to_customer|refurbish|pending');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `disposition_date` SET TAGS ('dbx_business_glossary_term' = 'Disposition Decision Date');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `disposition_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `goods_receipt_date` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Date');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `goods_receipt_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `inspection_date` SET TAGS ('dbx_business_glossary_term' = 'Inspection Date');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `inspection_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `inspection_result` SET TAGS ('dbx_business_glossary_term' = 'Inspection Result');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `inspection_result` SET TAGS ('dbx_value_regex' = 'pass|fail|partial_pass|pending|not_required');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `ncr_reference` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Report (NCR) Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `original_delivery_number` SET TAGS ('dbx_business_glossary_term' = 'Original Delivery Number');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `original_sales_order_number` SET TAGS ('dbx_business_glossary_term' = 'Original Sales Order Number');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `product_category` SET TAGS ('dbx_business_glossary_term' = 'Product Category');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `product_category` SET TAGS ('dbx_value_regex' = 'automation_system|electrification_solution|smart_infrastructure|drive_system|control_panel|sensor|actuator|power_supply|hmi|plc|other');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `product_description` SET TAGS ('dbx_business_glossary_term' = 'Product Description');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `product_sku` SET TAGS ('dbx_business_glossary_term' = 'Product Stock Keeping Unit (SKU)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `quantity_returned` SET TAGS ('dbx_business_glossary_term' = 'Quantity Returned');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `quantity_returned` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `receiving_warehouse_code` SET TAGS ('dbx_business_glossary_term' = 'Receiving Warehouse Code');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `repair_cost` SET TAGS ('dbx_business_glossary_term' = 'Repair Cost');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `repair_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `repair_turnaround_days` SET TAGS ('dbx_business_glossary_term' = 'Repair Turnaround Time (Days)');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `repair_turnaround_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `replacement_shipment_reference` SET TAGS ('dbx_business_glossary_term' = 'Replacement Shipment Reference');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `return_reason_code` SET TAGS ('dbx_business_glossary_term' = 'Return Reason Code');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `return_reason_description` SET TAGS ('dbx_business_glossary_term' = 'Return Reason Description');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `return_shipment_tracking_number` SET TAGS ('dbx_business_glossary_term' = 'Return Shipment Tracking Number');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `return_type` SET TAGS ('dbx_business_glossary_term' = 'Return Type');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `return_type` SET TAGS ('dbx_value_regex' = 'warranty_return|defective_return|incorrect_shipment|customer_rejection|end_of_life|upgrade_exchange|loaner_return');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `rma_number` SET TAGS ('dbx_business_glossary_term' = 'Return Material Authorization (RMA) Number');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `rma_number` SET TAGS ('dbx_value_regex' = '^RMA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `sales_organization` SET TAGS ('dbx_business_glossary_term' = 'Sales Organization');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Product Serial Number');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'RMA Status');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|in_transit|received|under_inspection|disposition_pending|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `supplier_chargeback_flag` SET TAGS ('dbx_business_glossary_term' = 'Supplier Chargeback Flag');
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ALTER COLUMN `supplier_chargeback_flag` SET TAGS ('dbx_value_regex' = 'true|false');
