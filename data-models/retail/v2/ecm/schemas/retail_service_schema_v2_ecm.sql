-- Schema for Domain: service | Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 13:53:25

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `vibe_retail_v1`.`service` COMMENT 'Reviewer-directed domain for rehomed products.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `vibe_retail_v1`.`service`.`service_case` (
    `service_case_id` BIGINT COMMENT 'Unique identifier for the customer service case record. Primary key.',
    `associate_id` BIGINT COMMENT 'Identifier of the customer service agent or representative currently assigned to handle this case.',
    `buyer_id` BIGINT COMMENT 'Foreign key linking to merchandising.buyer. Business justification: Complex product quality issues, specification disputes, or vendor-related complaints escalated to merchandise buyers for resolution and vendor coordination. Real escalation path in retail operations f',
    `fulfillment_order_id` BIGINT COMMENT 'Foreign key linking to fulfillment.fulfillment_order. Business justification: Service cases frequently track delivery issues, damaged shipments, missing packages, and late deliveries. Linking case to fulfillment_order enables agents to view fulfillment status, tracking, and exc',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: Service cases requiring financial remedies (refunds, credits, write-offs) must post to specific GL accounts. Retail operations track the financial impact of service resolutions for accurate P&L and ba',
    `header_id` BIGINT COMMENT 'Identifier of the customer order associated with this service case, if the case relates to a specific order transaction.',
    `location_id` BIGINT COMMENT 'Identifier of the retail store location involved in the case, if the issue originated from or relates to a specific store.',
    `parent_case_service_case_id` BIGINT COMMENT 'Identifier of the parent service case if this case is a child or follow-up case. Supports hierarchical case relationships and tracking of related issues.',
    `profile_id` BIGINT COMMENT 'Identifier of the customer who initiated or is associated with this service case. Links to the customer master record.',
    `redemption_id` BIGINT COMMENT 'Foreign key linking to loyalty.redemption. Business justification: Service cases frequently involve loyalty redemption disputes (points not credited, voucher not working, reward not received). CSRs need direct link to redemption record to investigate complaints, proc',
    `sku_id` BIGINT COMMENT 'Foreign key linking to product.sku. Business justification: Service cases for returns, defects, warranty claims reference specific products. Quality tracking, recall management, and vendor chargebacks require linking cases to SKUs. Existing product_sku text',
    `vendor_id` BIGINT COMMENT 'Foreign key linking to supplier.vendor. Business justification: When customer service cases involve product defects, quality issues, or recalls, retailers must track the originating vendor to manage RTV requests, chargebacks, vendor scorecards, and supplier accoun',
    `violation_notice_id` BIGINT COMMENT 'Foreign key linking to compliance.violation_notice. Business justification: Regulatory violations (health department citations, safety violations) often trigger customer service cases for remediation communication. Links violation to customer impact management and response tr',
    `assigned_team` STRING COMMENT 'Name or code of the service team or queue to which this case is assigned for resolution.',
    `case_number` STRING COMMENT 'Externally visible unique case number assigned by the service system for customer reference and tracking.. Valid values are `^[A-Z0-9]{8,20}$`',
    `case_owner_type` STRING COMMENT 'Type of owner currently assigned to the case: individual agent, team queue, or automated system. Used for workload distribution analytics.. Valid values are `agent|queue|automated_system`',
    `case_status` STRING COMMENT 'Current lifecycle status of the service case. Tracks progression from new through resolution to closure. [ENUM-REF-CANDIDATE: new|open|in_progress|pending_customer|pending_vendor|escalated|resolved|closed|cancelled — 9 candidates stripped; promote to reference product]',
    `case_type` STRING COMMENT 'Classification of the service case by the nature of the customer issue or inquiry. Includes return inquiry, billing dispute, product complaint, delivery issue, loyalty query, order inquiry, technical support, and general inquiry. [ENUM-REF-CANDIDATE: return_inquiry|billing_dispute|product_complaint|delivery_issue|loyalty_query|order_inquiry|technical_support|general_inquiry — 8 candidates stripped; promote to reference product]',
    `channel` STRING COMMENT 'The customer interaction channel through which the service case was initiated. Supports omnichannel service analytics. [ENUM-REF-CANDIDATE: phone|email|chat|in_store|mobile_app|web_portal|social_media — 7 candidates stripped; promote to reference product]',
    `closed_timestamp` TIMESTAMP COMMENT 'Timestamp when the case was formally closed in the system. May differ from resolution timestamp if additional verification or customer confirmation was required.',
    `contact_attempts` STRING COMMENT 'Number of times the service team attempted to contact the customer during the case lifecycle. Used for tracking customer engagement and responsiveness.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the service case record was first created in the system. Represents the initiation of the service workflow.',
    `currency_code` STRING COMMENT 'Three-letter ISO 4217 currency code for any monetary amounts associated with the case, such as refunds or credits.. Valid values are `^[A-Z]{3}$`',
    `customer_satisfaction_rating` STRING COMMENT 'Customer satisfaction score provided by the customer after case resolution, typically on a scale of 1 to 5. Used to calculate CSAT and NPS metrics.',
    `service_case_description` STRING COMMENT 'Detailed narrative description of the customer issue, inquiry, or complaint as captured by the service agent or customer.',
    `escalation_flag` BOOLEAN COMMENT 'Boolean indicator of whether the case was escalated to a higher support tier, supervisor, or specialized team during its lifecycle.',
    `escalation_reason` STRING COMMENT 'Reason or justification for escalating the case, such as complexity, customer request, or SLA breach.',
    `first_response_timestamp` TIMESTAMP COMMENT 'Timestamp when the first agent response was provided to the customer after case creation. Key metric for measuring initial response time SLA.',
    `interaction_count` STRING COMMENT 'Total number of customer-agent interactions or touchpoints recorded during the lifecycle of this case. Includes calls, emails, chats, and in-person contacts.',
    `is_closed` BOOLEAN COMMENT 'Boolean indicator of whether the case is currently in a closed status. Simplifies filtering for open vs closed case analytics.',
    `modified_timestamp` TIMESTAMP COMMENT 'Timestamp when the service case record was last modified or updated. Used for audit trail and change tracking.',
    `nps_score` STRING COMMENT 'Net Promoter Score provided by the customer, typically on a scale of 0 to 10, indicating likelihood to recommend the business based on the service experience.',
    `priority` STRING COMMENT 'Business priority level assigned to the case based on urgency and impact to the customer or business operations.. Valid values are `low|medium|high|critical`',
    `refund_amount` DECIMAL(18,2) COMMENT 'Monetary amount refunded to the customer as part of the case resolution, if applicable. Denominated in the transaction currency.',
    `resolution_code` STRING COMMENT 'Standardized code indicating the type of resolution or action taken to close the service case. Used for resolution analytics and process improvement. [ENUM-REF-CANDIDATE: refund_issued|replacement_sent|information_provided|escalated_to_vendor|no_action_required|customer_withdrew|policy_exception_approved — 7 candidates stripped; promote to reference product]',
    `resolution_notes` STRING COMMENT 'Free-text notes documenting the resolution details, actions taken, and any follow-up required for the case.',
    `resolution_timestamp` TIMESTAMP COMMENT 'Timestamp when the case was marked as resolved by the service agent. Represents the point at which the issue was addressed.',
    `rma_number` STRING COMMENT 'Return Merchandise Authorization number issued for return-related cases. Links the service case to the formal return process and inventory tracking.. Valid values are `^RMA[A-Z0-9]{8,15}$`',
    `sla_breach_flag` BOOLEAN COMMENT 'Boolean indicator of whether the case resolution exceeded the SLA target time, triggering a service level breach.',
    `sla_target_hours` DECIMAL(18,2) COMMENT 'Target number of hours within which the case should be resolved according to the applicable SLA policy based on case type and priority.',
    `subject` STRING COMMENT 'Brief summary or subject line describing the nature of the customer service case.',
    CONSTRAINT pk_service_case PRIMARY KEY(`service_case_id`)
) COMMENT 'Customer service and support case records managed through the case management system. Stores case number, case type (return inquiry, billing dispute, product complaint, delivery issue, loyalty query), case status (open/in-progress/resolved/closed), priority, channel of origin (phone/chat/email/in-store), assigned agent, store or fulfillment node involved, resolution code, resolution timestamp, customer satisfaction rating, and RMA reference for return-related cases. Distinct from interaction (which captures all touchpoints) — service_case tracks formal support workflows with SLAs.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ADD CONSTRAINT `fk_service_service_case_parent_case_service_case_id` FOREIGN KEY (`parent_case_service_case_id`) REFERENCES `vibe_retail_v1`.`service`.`service_case`(`service_case_id`);

-- ========= TAGS =========
ALTER SCHEMA `vibe_retail_v1`.`service` SET TAGS ('dbx_division' = 'business');
ALTER SCHEMA `vibe_retail_v1`.`service` SET TAGS ('dbx_domain' = 'service');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `service_case_id` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `associate_id` SET TAGS ('dbx_business_glossary_term' = 'Assigned Agent ID');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `associate_id` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `buyer_id` SET TAGS ('dbx_business_glossary_term' = 'Buyer Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `buyer_id` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `fulfillment_order_id` SET TAGS ('dbx_business_glossary_term' = 'Fulfillment Order Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `fulfillment_order_id` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `header_id` SET TAGS ('dbx_business_glossary_term' = 'Order ID');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `header_id` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `location_id` SET TAGS ('dbx_business_glossary_term' = 'Store ID');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `location_id` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `parent_case_service_case_id` SET TAGS ('dbx_business_glossary_term' = 'Parent Case ID');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `parent_case_service_case_id` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `profile_id` SET TAGS ('dbx_business_glossary_term' = 'Customer ID');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `profile_id` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `redemption_id` SET TAGS ('dbx_business_glossary_term' = 'Redemption Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `redemption_id` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `sku_id` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `vendor_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `vendor_id` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `violation_notice_id` SET TAGS ('dbx_business_glossary_term' = 'Related Violation Notice Id (Foreign Key)');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `violation_notice_id` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `assigned_team` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `case_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{8,20}$');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `case_number` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `case_owner_type` SET TAGS ('dbx_value_regex' = 'agent|queue|automated_system');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `case_owner_type` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `case_status` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `case_type` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `channel` SET TAGS ('dbx_business_glossary_term' = 'Channel of Origin');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `channel` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `contact_attempts` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `currency_code` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `customer_satisfaction_rating` SET TAGS ('dbx_business_glossary_term' = 'Customer Satisfaction (CSAT) Rating');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `customer_satisfaction_rating` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `service_case_description` SET TAGS ('dbx_business_glossary_term' = 'Case Description');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `service_case_description` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `escalation_flag` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `escalation_reason` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `first_response_timestamp` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `interaction_count` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `is_closed` SET TAGS ('dbx_business_glossary_term' = 'Is Closed Flag');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `is_closed` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `nps_score` SET TAGS ('dbx_business_glossary_term' = 'Net Promoter Score (NPS)');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `nps_score` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Case Priority');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `priority` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `refund_amount` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `resolution_code` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `resolution_notes` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `resolution_timestamp` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `rma_number` SET TAGS ('dbx_business_glossary_term' = 'Return Merchandise Authorization (RMA) Number');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `rma_number` SET TAGS ('dbx_value_regex' = '^RMA[A-Z0-9]{8,15}$');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `rma_number` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Flag');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `sla_target_hours` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Target Hours');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `sla_target_hours` SET TAGS ('dbx_subdomain' = 'service.service_case');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `subject` SET TAGS ('dbx_business_glossary_term' = 'Case Subject');
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ALTER COLUMN `subject` SET TAGS ('dbx_subdomain' = 'service.service_case');
