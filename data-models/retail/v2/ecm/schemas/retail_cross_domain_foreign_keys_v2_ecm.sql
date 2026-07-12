-- Cross-Domain Foreign Keys for Business:  | Version: v2_ecm
-- Generated on: 2026-07-12 13:53:27
-- Total cross-domain FK constraints: 1580
--
-- EXECUTION ORDER:
--   1. Run ALL domain schema files first (any order).
--   2. Run this file LAST.
--
-- PREREQUISITE DOMAINS: analytics, compliance, customer, ecommerce, finance, fulfillment, inventory, loyalty, marketing, merchandising, order, pricing, product, promotion, returns, service, store, supplier, supplychain, workforce

-- ========= analytics --> compliance (11 constraint(s)) =========
-- Requires: analytics schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ADD CONSTRAINT `fk_analytics_kpi_definition_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_definition` ADD CONSTRAINT `fk_analytics_report_definition_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ADD CONSTRAINT `fk_analytics_dashboard_widget_audit_event_id` FOREIGN KEY (`audit_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_event`(`audit_event_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_rule` ADD CONSTRAINT `fk_analytics_dq_rule_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ADD CONSTRAINT `fk_analytics_dq_result_audit_event_id` FOREIGN KEY (`audit_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_event`(`audit_event_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ADD CONSTRAINT `fk_analytics_report_subscription_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_finding`(`audit_finding_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_osha_incident_id` FOREIGN KEY (`osha_incident_id`) REFERENCES `vibe_retail_v1`.`compliance`.`osha_incident`(`osha_incident_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ADD CONSTRAINT `fk_analytics_glossary_term_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `vibe_retail_v1`.`compliance`.`obligation`(`obligation_id`);

-- ========= analytics --> customer (5 constraint(s)) =========
-- Requires: analytics schema, customer schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ADD CONSTRAINT `fk_analytics_dq_issue_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ADD CONSTRAINT `fk_analytics_report_subscription_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`workspace` ADD CONSTRAINT `fk_analytics_workspace_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);

-- ========= analytics --> ecommerce (1 constraint(s)) =========
-- Requires: analytics schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ADD CONSTRAINT `fk_analytics_self_service_query_web_session_id` FOREIGN KEY (`web_session_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`web_session`(`web_session_id`);

-- ========= analytics --> finance (17 constraint(s)) =========
-- Requires: analytics schema, finance schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ADD CONSTRAINT `fk_analytics_dq_result_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ADD CONSTRAINT `fk_analytics_semantic_metric_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ADD CONSTRAINT `fk_analytics_semantic_metric_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ADD CONSTRAINT `fk_analytics_report_subscription_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`retail_calendar` ADD CONSTRAINT `fk_analytics_retail_calendar_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ADD CONSTRAINT `fk_analytics_glossary_term_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ADD CONSTRAINT `fk_analytics_glossary_term_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ADD CONSTRAINT `fk_analytics_glossary_term_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);

-- ========= analytics --> fulfillment (8 constraint(s)) =========
-- Requires: analytics schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ADD CONSTRAINT `fk_analytics_dq_result_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ADD CONSTRAINT `fk_analytics_dq_result_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);

-- ========= analytics --> inventory (12 constraint(s)) =========
-- Requires: analytics schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_adjustment_id` FOREIGN KEY (`adjustment_id`) REFERENCES `vibe_retail_v1`.`inventory`.`adjustment`(`adjustment_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_cycle_count_id` FOREIGN KEY (`cycle_count_id`) REFERENCES `vibe_retail_v1`.`inventory`.`cycle_count`(`cycle_count_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_stock_ledger_id` FOREIGN KEY (`stock_ledger_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_ledger`(`stock_ledger_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ADD CONSTRAINT `fk_analytics_dq_result_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ADD CONSTRAINT `fk_analytics_dq_issue_replenishment_order_id` FOREIGN KEY (`replenishment_order_id`) REFERENCES `vibe_retail_v1`.`inventory`.`replenishment_order`(`replenishment_order_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ADD CONSTRAINT `fk_analytics_dq_issue_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ADD CONSTRAINT `fk_analytics_report_subscription_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_adjustment_id` FOREIGN KEY (`adjustment_id`) REFERENCES `vibe_retail_v1`.`inventory`.`adjustment`(`adjustment_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_cycle_count_id` FOREIGN KEY (`cycle_count_id`) REFERENCES `vibe_retail_v1`.`inventory`.`cycle_count`(`cycle_count_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);

-- ========= analytics --> loyalty (7 constraint(s)) =========
-- Requires: analytics schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ADD CONSTRAINT `fk_analytics_kpi_definition_member_segment_id` FOREIGN KEY (`member_segment_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`member_segment`(`member_segment_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_engagement_campaign_id` FOREIGN KEY (`engagement_campaign_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`engagement_campaign`(`engagement_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_member_segment_id` FOREIGN KEY (`member_segment_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`member_segment`(`member_segment_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_layer_entity` ADD CONSTRAINT `fk_analytics_semantic_layer_entity_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ADD CONSTRAINT `fk_analytics_self_service_query_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);

-- ========= analytics --> marketing (4 constraint(s)) =========
-- Requires: analytics schema, marketing schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ADD CONSTRAINT `fk_analytics_dashboard_widget_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ADD CONSTRAINT `fk_analytics_report_subscription_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);

-- ========= analytics --> pricing (8 constraint(s)) =========
-- Requires: analytics schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_price_change_id` FOREIGN KEY (`price_change_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_change`(`price_change_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`semantic_metric` ADD CONSTRAINT `fk_analytics_semantic_metric_price_strategy_id` FOREIGN KEY (`price_strategy_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_strategy`(`price_strategy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_margin_target_id` FOREIGN KEY (`margin_target_id`) REFERENCES `vibe_retail_v1`.`pricing`.`margin_target`(`margin_target_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_margin_target_id` FOREIGN KEY (`margin_target_id`) REFERENCES `vibe_retail_v1`.`pricing`.`margin_target`(`margin_target_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);

-- ========= analytics --> product (8 constraint(s)) =========
-- Requires: analytics schema, product schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ADD CONSTRAINT `fk_analytics_dq_result_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ADD CONSTRAINT `fk_analytics_dq_issue_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`glossary_term` ADD CONSTRAINT `fk_analytics_glossary_term_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= analytics --> returns (5 constraint(s)) =========
-- Requires: analytics schema, returns schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_disposition_id` FOREIGN KEY (`disposition_id`) REFERENCES `vibe_retail_v1`.`returns`.`disposition`(`disposition_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_liquidation_batch_id` FOREIGN KEY (`liquidation_batch_id`) REFERENCES `vibe_retail_v1`.`returns`.`liquidation_batch`(`liquidation_batch_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_return_request_id` FOREIGN KEY (`return_request_id`) REFERENCES `vibe_retail_v1`.`returns`.`return_request`(`return_request_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_rma_id` FOREIGN KEY (`rma_id`) REFERENCES `vibe_retail_v1`.`returns`.`rma`(`rma_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ADD CONSTRAINT `fk_analytics_dq_issue_return_fraud_case_id` FOREIGN KEY (`return_fraud_case_id`) REFERENCES `vibe_retail_v1`.`returns`.`return_fraud_case`(`return_fraud_case_id`);

-- ========= analytics --> store (9 constraint(s)) =========
-- Requires: analytics schema, store schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ADD CONSTRAINT `fk_analytics_kpi_definition_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_definition` ADD CONSTRAINT `fk_analytics_kpi_definition_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`workspace` ADD CONSTRAINT `fk_analytics_workspace_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);

-- ========= analytics --> supplychain (15 constraint(s)) =========
-- Requires: analytics schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`kpi_value` ADD CONSTRAINT `fk_analytics_kpi_value_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ADD CONSTRAINT `fk_analytics_dq_result_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_result` ADD CONSTRAINT `fk_analytics_dq_result_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ADD CONSTRAINT `fk_analytics_dq_issue_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dq_issue` ADD CONSTRAINT `fk_analytics_dq_issue_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ADD CONSTRAINT `fk_analytics_report_subscription_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_plan_id` FOREIGN KEY (`plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`plan`(`plan_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`sla_kpi_measurement` ADD CONSTRAINT `fk_analytics_sla_kpi_measurement_sla_definition_id` FOREIGN KEY (`sla_definition_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`sla_definition`(`sla_definition_id`);

-- ========= analytics --> workforce (13 constraint(s)) =========
-- Requires: analytics schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ADD CONSTRAINT `fk_analytics_dashboard_widget_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ADD CONSTRAINT `fk_analytics_dashboard_widget_dashboard_created_by_user_associate_id` FOREIGN KEY (`dashboard_created_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`dashboard_widget` ADD CONSTRAINT `fk_analytics_dashboard_widget_dashboard_modified_by_user_associate_id` FOREIGN KEY (`dashboard_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ADD CONSTRAINT `fk_analytics_report_subscription_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ADD CONSTRAINT `fk_analytics_report_subscription_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`report_subscription` ADD CONSTRAINT `fk_analytics_report_subscription_tertiary_report_last_modified_by_user_associate_id` FOREIGN KEY (`tertiary_report_last_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`access_policy` ADD CONSTRAINT `fk_analytics_access_policy_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_target_owner_user_associate_id` FOREIGN KEY (`target_owner_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`analytics_kpi_target` ADD CONSTRAINT `fk_analytics_analytics_kpi_target_tertiary_analytics_last_updated_by_user_associate_id` FOREIGN KEY (`tertiary_analytics_last_updated_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`alert` ADD CONSTRAINT `fk_analytics_alert_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`self_service_query` ADD CONSTRAINT `fk_analytics_self_service_query_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`analytics`.`workspace` ADD CONSTRAINT `fk_analytics_workspace_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);

-- ========= compliance --> customer (2 constraint(s)) =========
-- Requires: compliance schema, customer schema
ALTER TABLE `vibe_retail_v1`.`compliance`.`privacy_assessment` ADD CONSTRAINT `fk_compliance_privacy_assessment_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`consent` ADD CONSTRAINT `fk_compliance_consent_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= compliance --> finance (6 constraint(s)) =========
-- Requires: compliance schema, finance schema
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ADD CONSTRAINT `fk_compliance_audit_event_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ADD CONSTRAINT `fk_compliance_pci_assessment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ADD CONSTRAINT `fk_compliance_license_permit_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ADD CONSTRAINT `fk_compliance_environmental_event_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ADD CONSTRAINT `fk_compliance_violation_notice_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= compliance --> product (6 constraint(s)) =========
-- Requires: compliance schema, product schema
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ADD CONSTRAINT `fk_compliance_corrective_action_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ADD CONSTRAINT `fk_compliance_food_safety_log_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ADD CONSTRAINT `fk_compliance_license_permit_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ADD CONSTRAINT `fk_compliance_certification_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ADD CONSTRAINT `fk_compliance_violation_notice_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= compliance --> promotion (1 constraint(s)) =========
-- Requires: compliance schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ADD CONSTRAINT `fk_compliance_training_completion_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);

-- ========= compliance --> store (12 constraint(s)) =========
-- Requires: compliance schema, store schema
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ADD CONSTRAINT `fk_compliance_audit_schedule_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ADD CONSTRAINT `fk_compliance_audit_event_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ADD CONSTRAINT `fk_compliance_corrective_action_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ADD CONSTRAINT `fk_compliance_food_safety_log_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ADD CONSTRAINT `fk_compliance_osha_incident_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ADD CONSTRAINT `fk_compliance_safety_inspection_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ADD CONSTRAINT `fk_compliance_certification_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ADD CONSTRAINT `fk_compliance_environmental_event_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ADD CONSTRAINT `fk_compliance_training_completion_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ADD CONSTRAINT `fk_compliance_violation_notice_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= compliance --> supplier (8 constraint(s)) =========
-- Requires: compliance schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ADD CONSTRAINT `fk_compliance_audit_event_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ADD CONSTRAINT `fk_compliance_corrective_action_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ADD CONSTRAINT `fk_compliance_food_safety_plan_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`haccp_control_point` ADD CONSTRAINT `fk_compliance_haccp_control_point_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ADD CONSTRAINT `fk_compliance_pci_assessment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ADD CONSTRAINT `fk_compliance_training_completion_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ADD CONSTRAINT `fk_compliance_third_party_assessment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= compliance --> supplychain (15 constraint(s)) =========
-- Requires: compliance schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ADD CONSTRAINT `fk_compliance_corrective_action_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_plan` ADD CONSTRAINT `fk_compliance_food_safety_plan_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ADD CONSTRAINT `fk_compliance_food_safety_log_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ADD CONSTRAINT `fk_compliance_osha_incident_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ADD CONSTRAINT `fk_compliance_safety_inspection_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`pci_assessment` ADD CONSTRAINT `fk_compliance_pci_assessment_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ADD CONSTRAINT `fk_compliance_license_permit_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ADD CONSTRAINT `fk_compliance_certification_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ADD CONSTRAINT `fk_compliance_environmental_event_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ADD CONSTRAINT `fk_compliance_training_completion_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ADD CONSTRAINT `fk_compliance_violation_notice_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`facility_training_requirement` ADD CONSTRAINT `fk_compliance_facility_training_requirement_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`facility_compliance_certification` ADD CONSTRAINT `fk_compliance_facility_compliance_certification_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= compliance --> workforce (30 constraint(s)) =========
-- Requires: compliance schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ADD CONSTRAINT `fk_compliance_audit_schedule_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_schedule` ADD CONSTRAINT `fk_compliance_audit_schedule_tertiary_audit_modified_by_user_associate_id` FOREIGN KEY (`tertiary_audit_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ADD CONSTRAINT `fk_compliance_audit_event_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_event` ADD CONSTRAINT `fk_compliance_audit_event_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`audit_finding` ADD CONSTRAINT `fk_compliance_audit_finding_tertiary_audit_verified_by_associate_id` FOREIGN KEY (`tertiary_audit_verified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`corrective_action` ADD CONSTRAINT `fk_compliance_corrective_action_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`food_safety_log` ADD CONSTRAINT `fk_compliance_food_safety_log_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ADD CONSTRAINT `fk_compliance_osha_incident_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`osha_incident` ADD CONSTRAINT `fk_compliance_osha_incident_tertiary_osha_investigator_employee_associate_id` FOREIGN KEY (`tertiary_osha_investigator_employee_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`safety_inspection` ADD CONSTRAINT `fk_compliance_safety_inspection_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`license_permit` ADD CONSTRAINT `fk_compliance_license_permit_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ADD CONSTRAINT `fk_compliance_certification_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ADD CONSTRAINT `fk_compliance_certification_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`certification` ADD CONSTRAINT `fk_compliance_certification_tertiary_certification_modified_by_user_associate_id` FOREIGN KEY (`tertiary_certification_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`environmental_event` ADD CONSTRAINT `fk_compliance_environmental_event_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_program` ADD CONSTRAINT `fk_compliance_training_program_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ADD CONSTRAINT `fk_compliance_training_completion_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ADD CONSTRAINT `fk_compliance_training_completion_tertiary_training_waiver_approved_by_associate_id` FOREIGN KEY (`tertiary_training_waiver_approved_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`training_completion` ADD CONSTRAINT `fk_compliance_training_completion_training_associate_id` FOREIGN KEY (`training_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`violation_notice` ADD CONSTRAINT `fk_compliance_violation_notice_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ADD CONSTRAINT `fk_compliance_policy_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ADD CONSTRAINT `fk_compliance_policy_primary_policy_associate_id` FOREIGN KEY (`primary_policy_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`policy` ADD CONSTRAINT `fk_compliance_policy_tertiary_policy_modified_by_user_associate_id` FOREIGN KEY (`tertiary_policy_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ADD CONSTRAINT `fk_compliance_risk_register_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ADD CONSTRAINT `fk_compliance_risk_register_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`risk_register` ADD CONSTRAINT `fk_compliance_risk_register_tertiary_risk_identified_by_associate_id` FOREIGN KEY (`tertiary_risk_identified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ADD CONSTRAINT `fk_compliance_third_party_assessment_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`compliance`.`third_party_assessment` ADD CONSTRAINT `fk_compliance_third_party_assessment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= customer --> ecommerce (2 constraint(s)) =========
-- Requires: customer schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_web_session_id` FOREIGN KEY (`web_session_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`web_session`(`web_session_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`segment_banner_targeting` ADD CONSTRAINT `fk_customer_segment_banner_targeting_promotion_banner_id` FOREIGN KEY (`promotion_banner_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`promotion_banner`(`promotion_banner_id`);

-- ========= customer --> finance (1 constraint(s)) =========
-- Requires: customer schema, finance schema
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_payment_method_id` FOREIGN KEY (`payment_method_id`) REFERENCES `vibe_retail_v1`.`finance`.`payment_method`(`payment_method_id`);

-- ========= customer --> loyalty (1 constraint(s)) =========
-- Requires: customer schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ADD CONSTRAINT `fk_customer_privacy_request_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);

-- ========= customer --> marketing (5 constraint(s)) =========
-- Requires: customer schema, marketing schema
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_email_send_id` FOREIGN KEY (`email_send_id`) REFERENCES `vibe_retail_v1`.`marketing`.`email_send`(`email_send_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ADD CONSTRAINT `fk_customer_targeting_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`targeting` ADD CONSTRAINT `fk_customer_targeting_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`segment`(`segment_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`segment_banner_targeting` ADD CONSTRAINT `fk_customer_segment_banner_targeting_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`segment`(`segment_id`);

-- ========= customer --> merchandising (3 constraint(s)) =========
-- Requires: customer schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ADD CONSTRAINT `fk_customer_wishlist_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` ADD CONSTRAINT `fk_customer_customer_attribute_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);

-- ========= customer --> order (2 constraint(s)) =========
-- Requires: customer schema, order schema
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);

-- ========= customer --> pricing (2 constraint(s)) =========
-- Requires: customer schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`b2b_contract` ADD CONSTRAINT `fk_customer_b2b_contract_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);

-- ========= customer --> product (4 constraint(s)) =========
-- Requires: customer schema, product schema
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ADD CONSTRAINT `fk_customer_wishlist_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` ADD CONSTRAINT `fk_customer_customer_attribute_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`customer_attribute` ADD CONSTRAINT `fk_customer_customer_attribute_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= customer --> promotion (2 constraint(s)) =========
-- Requires: customer schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`issuance` ADD CONSTRAINT `fk_customer_issuance_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `vibe_retail_v1`.`promotion`.`coupon`(`coupon_id`);

-- ========= customer --> returns (1 constraint(s)) =========
-- Requires: customer schema, returns schema
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_rma_id` FOREIGN KEY (`rma_id`) REFERENCES `vibe_retail_v1`.`returns`.`rma`(`rma_id`);

-- ========= customer --> service (1 constraint(s)) =========
-- Requires: customer schema, service schema
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_service_case_id` FOREIGN KEY (`service_case_id`) REFERENCES `vibe_retail_v1`.`service`.`service_case`(`service_case_id`);

-- ========= customer --> store (7 constraint(s)) =========
-- Requires: customer schema, store schema
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ADD CONSTRAINT `fk_customer_profile_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`household` ADD CONSTRAINT `fk_customer_household_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ADD CONSTRAINT `fk_customer_wishlist_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`issuance` ADD CONSTRAINT `fk_customer_issuance_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`b2b_contract` ADD CONSTRAINT `fk_customer_b2b_contract_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `vibe_retail_v1`.`store`.`sales_territory`(`sales_territory_id`);

-- ========= customer --> workforce (8 constraint(s)) =========
-- Requires: customer schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`corporate_account` ADD CONSTRAINT `fk_customer_corporate_account_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`wishlist` ADD CONSTRAINT `fk_customer_wishlist_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`privacy_request` ADD CONSTRAINT `fk_customer_privacy_request_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`client_relationship` ADD CONSTRAINT `fk_customer_client_relationship_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`b2b_contract` ADD CONSTRAINT `fk_customer_b2b_contract_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`b2b_contract` ADD CONSTRAINT `fk_customer_b2b_contract_b2b_associate_id` FOREIGN KEY (`b2b_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= ecommerce --> compliance (5 constraint(s)) =========
-- Requires: ecommerce schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_pci_assessment_id` FOREIGN KEY (`pci_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`pci_assessment`(`pci_assessment_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_license_permit_id` FOREIGN KEY (`license_permit_id`) REFERENCES `vibe_retail_v1`.`compliance`.`license_permit`(`license_permit_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`ab_test` ADD CONSTRAINT `fk_ecommerce_ab_test_privacy_assessment_id` FOREIGN KEY (`privacy_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`privacy_assessment`(`privacy_assessment_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`personalization_rule` ADD CONSTRAINT `fk_ecommerce_personalization_rule_privacy_assessment_id` FOREIGN KEY (`privacy_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`privacy_assessment`(`privacy_assessment_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`recommendation` ADD CONSTRAINT `fk_ecommerce_recommendation_privacy_assessment_id` FOREIGN KEY (`privacy_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`privacy_assessment`(`privacy_assessment_id`);

-- ========= ecommerce --> customer (13 constraint(s)) =========
-- Requires: ecommerce schema, customer schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_page_view` ADD CONSTRAINT `fk_ecommerce_product_page_view_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`search_query` ADD CONSTRAINT `fk_ecommerce_search_query_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`ab_test` ADD CONSTRAINT `fk_ecommerce_ab_test_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`abandoned_cart_recovery` ADD CONSTRAINT `fk_ecommerce_abandoned_cart_recovery_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`recommendation` ADD CONSTRAINT `fk_ecommerce_recommendation_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`site_notification` ADD CONSTRAINT `fk_ecommerce_site_notification_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= ecommerce --> finance (9 constraint(s)) =========
-- Requires: ecommerce schema, finance schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `vibe_retail_v1`.`finance`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_payment_method_id` FOREIGN KEY (`payment_method_id`) REFERENCES `vibe_retail_v1`.`finance`.`payment_method`(`payment_method_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`recommendation` ADD CONSTRAINT `fk_ecommerce_recommendation_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`promotion_banner` ADD CONSTRAINT `fk_ecommerce_promotion_banner_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`promotion_banner` ADD CONSTRAINT `fk_ecommerce_promotion_banner_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);

-- ========= ecommerce --> fulfillment (7 constraint(s)) =========
-- Requires: ecommerce schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_page_view` ADD CONSTRAINT `fk_ecommerce_product_page_view_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`recommendation` ADD CONSTRAINT `fk_ecommerce_recommendation_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`site_notification` ADD CONSTRAINT `fk_ecommerce_site_notification_bopis_appointment_id` FOREIGN KEY (`bopis_appointment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`bopis_appointment`(`bopis_appointment_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`site_notification` ADD CONSTRAINT `fk_ecommerce_site_notification_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`site_notification` ADD CONSTRAINT `fk_ecommerce_site_notification_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`catalog_node_inventory` ADD CONSTRAINT `fk_ecommerce_catalog_node_inventory_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= ecommerce --> inventory (5 constraint(s)) =========
-- Requires: ecommerce schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`site_notification` ADD CONSTRAINT `fk_ecommerce_site_notification_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);

-- ========= ecommerce --> loyalty (1 constraint(s)) =========
-- Requires: ecommerce schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_program`(`loyalty_program_id`);

-- ========= ecommerce --> marketing (6 constraint(s)) =========
-- Requires: ecommerce schema, marketing schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`ab_test` ADD CONSTRAINT `fk_ecommerce_ab_test_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`abandoned_cart_recovery` ADD CONSTRAINT `fk_ecommerce_abandoned_cart_recovery_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`personalization_rule` ADD CONSTRAINT `fk_ecommerce_personalization_rule_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`segment`(`segment_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`recommendation` ADD CONSTRAINT `fk_ecommerce_recommendation_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`promotion_banner` ADD CONSTRAINT `fk_ecommerce_promotion_banner_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);

-- ========= ecommerce --> merchandising (13 constraint(s)) =========
-- Requires: ecommerce schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_page_view` ADD CONSTRAINT `fk_ecommerce_product_page_view_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`search_query` ADD CONSTRAINT `fk_ecommerce_search_query_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`search_query` ADD CONSTRAINT `fk_ecommerce_search_query_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`personalization_rule` ADD CONSTRAINT `fk_ecommerce_personalization_rule_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`recommendation` ADD CONSTRAINT `fk_ecommerce_recommendation_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront_assortment` ADD CONSTRAINT `fk_ecommerce_storefront_assortment_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront_responsibility` ADD CONSTRAINT `fk_ecommerce_storefront_responsibility_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);

-- ========= ecommerce --> order (9 constraint(s)) =========
-- Requires: ecommerce schema, order schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`search_query` ADD CONSTRAINT `fk_ecommerce_search_query_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`abandoned_cart_recovery` ADD CONSTRAINT `fk_ecommerce_abandoned_cart_recovery_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`recommendation` ADD CONSTRAINT `fk_ecommerce_recommendation_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`site_notification` ADD CONSTRAINT `fk_ecommerce_site_notification_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);

-- ========= ecommerce --> pricing (5 constraint(s)) =========
-- Requires: ecommerce schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);

-- ========= ecommerce --> product (7 constraint(s)) =========
-- Requires: ecommerce schema, product schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_page_view` ADD CONSTRAINT `fk_ecommerce_product_page_view_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`recommendation` ADD CONSTRAINT `fk_ecommerce_recommendation_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`site_notification` ADD CONSTRAINT `fk_ecommerce_site_notification_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= ecommerce --> promotion (6 constraint(s)) =========
-- Requires: ecommerce schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`promotion_banner` ADD CONSTRAINT `fk_ecommerce_promotion_banner_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);

-- ========= ecommerce --> returns (1 constraint(s)) =========
-- Requires: ecommerce schema, returns schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_refund_id` FOREIGN KEY (`refund_id`) REFERENCES `vibe_retail_v1`.`returns`.`refund`(`refund_id`);

-- ========= ecommerce --> store (7 constraint(s)) =========
-- Requires: ecommerce schema, store schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`site_notification` ADD CONSTRAINT `fk_ecommerce_site_notification_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= ecommerce --> supplier (1 constraint(s)) =========
-- Requires: ecommerce schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= ecommerce --> supplychain (2 constraint(s)) =========
-- Requires: ecommerce schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`recommendation` ADD CONSTRAINT `fk_ecommerce_recommendation_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront_fulfillment_network` ADD CONSTRAINT `fk_ecommerce_storefront_fulfillment_network_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= ecommerce --> workforce (15 constraint(s)) =========
-- Requires: ecommerce schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_page_view` ADD CONSTRAINT `fk_ecommerce_product_page_view_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`search_query` ADD CONSTRAINT `fk_ecommerce_search_query_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`ab_test` ADD CONSTRAINT `fk_ecommerce_ab_test_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`abandoned_cart_recovery` ADD CONSTRAINT `fk_ecommerce_abandoned_cart_recovery_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`recommendation` ADD CONSTRAINT `fk_ecommerce_recommendation_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`site_notification` ADD CONSTRAINT `fk_ecommerce_site_notification_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront_fulfillment_network` ADD CONSTRAINT `fk_ecommerce_storefront_fulfillment_network_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront_assortment` ADD CONSTRAINT `fk_ecommerce_storefront_assortment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`message_template` ADD CONSTRAINT `fk_ecommerce_message_template_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`message_template` ADD CONSTRAINT `fk_ecommerce_message_template_message_last_modified_by_user_associate_id` FOREIGN KEY (`message_last_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= finance --> compliance (4 constraint(s)) =========
-- Requires: finance schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_violation_notice_id` FOREIGN KEY (`violation_notice_id`) REFERENCES `vibe_retail_v1`.`compliance`.`violation_notice`(`violation_notice_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`finance_budget` ADD CONSTRAINT `fk_finance_finance_budget_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`lease_contract` ADD CONSTRAINT `fk_finance_lease_contract_environmental_event_id` FOREIGN KEY (`environmental_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`environmental_event`(`environmental_event_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`lease_contract` ADD CONSTRAINT `fk_finance_lease_contract_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `vibe_retail_v1`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);

-- ========= finance --> customer (5 constraint(s)) =========
-- Requires: finance schema, customer schema
ALTER TABLE `vibe_retail_v1`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`revenue_recognition_event` ADD CONSTRAINT `fk_finance_revenue_recognition_event_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`tax_posting` ADD CONSTRAINT `fk_finance_tax_posting_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`payment_method` ADD CONSTRAINT `fk_finance_payment_method_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`payment_method` ADD CONSTRAINT `fk_finance_payment_method_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= finance --> order (1 constraint(s)) =========
-- Requires: finance schema, order schema
ALTER TABLE `vibe_retail_v1`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);

-- ========= finance --> store (6 constraint(s)) =========
-- Requires: finance schema, store schema
ALTER TABLE `vibe_retail_v1`.`finance`.`cost_center` ADD CONSTRAINT `fk_finance_cost_center_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`revenue_recognition_event` ADD CONSTRAINT `fk_finance_revenue_recognition_event_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`lease_contract` ADD CONSTRAINT `fk_finance_lease_contract_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`tax_posting` ADD CONSTRAINT `fk_finance_tax_posting_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`plan_version` ADD CONSTRAINT `fk_finance_plan_version_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);

-- ========= finance --> supplier (4 constraint(s)) =========
-- Requires: finance schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`lease_contract` ADD CONSTRAINT `fk_finance_lease_contract_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`tax_posting` ADD CONSTRAINT `fk_finance_tax_posting_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= finance --> supplychain (7 constraint(s)) =========
-- Requires: finance schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`finance`.`cost_center` ADD CONSTRAINT `fk_finance_cost_center_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`finance_budget` ADD CONSTRAINT `fk_finance_finance_budget_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`tax_posting` ADD CONSTRAINT `fk_finance_tax_posting_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= finance --> workforce (14 constraint(s)) =========
-- Requires: finance schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`finance`.`cost_center` ADD CONSTRAINT `fk_finance_cost_center_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`finance_budget` ADD CONSTRAINT `fk_finance_finance_budget_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_fixed_created_by_user_associate_id` FOREIGN KEY (`fixed_created_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_fixed_modified_by_user_associate_id` FOREIGN KEY (`fixed_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`payment_run` ADD CONSTRAINT `fk_finance_payment_run_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`payment_run` ADD CONSTRAINT `fk_finance_payment_run_payment_associate_id` FOREIGN KEY (`payment_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`plan_version` ADD CONSTRAINT `fk_finance_plan_version_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`plan_version` ADD CONSTRAINT `fk_finance_plan_version_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`plan_version` ADD CONSTRAINT `fk_finance_plan_version_plan_created_by_user_associate_id` FOREIGN KEY (`plan_created_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`plan_version` ADD CONSTRAINT `fk_finance_plan_version_plan_last_modified_by_user_associate_id` FOREIGN KEY (`plan_last_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`plan_version` ADD CONSTRAINT `fk_finance_plan_version_plan_submitted_by_user_associate_id` FOREIGN KEY (`plan_submitted_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`netting_run` ADD CONSTRAINT `fk_finance_netting_run_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`finance`.`netting_run` ADD CONSTRAINT `fk_finance_netting_run_netting_initiated_by_user_associate_id` FOREIGN KEY (`netting_initiated_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= fulfillment --> compliance (6 constraint(s)) =========
-- Requires: fulfillment schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_haccp_control_point_id` FOREIGN KEY (`haccp_control_point_id`) REFERENCES `vibe_retail_v1`.`compliance`.`haccp_control_point`(`haccp_control_point_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_environmental_event_id` FOREIGN KEY (`environmental_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`environmental_event`(`environmental_event_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ADD CONSTRAINT `fk_fulfillment_delivery_route_safety_inspection_id` FOREIGN KEY (`safety_inspection_id`) REFERENCES `vibe_retail_v1`.`compliance`.`safety_inspection`(`safety_inspection_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ADD CONSTRAINT `fk_fulfillment_carrier_certification_id` FOREIGN KEY (`certification_id`) REFERENCES `vibe_retail_v1`.`compliance`.`certification`(`certification_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ADD CONSTRAINT `fk_fulfillment_exception_corrective_action_id` FOREIGN KEY (`corrective_action_id`) REFERENCES `vibe_retail_v1`.`compliance`.`corrective_action`(`corrective_action_id`);

-- ========= fulfillment --> customer (6 constraint(s)) =========
-- Requires: fulfillment schema, customer schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ADD CONSTRAINT `fk_fulfillment_delivery_stop_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ADD CONSTRAINT `fk_fulfillment_drop_ship_order_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= fulfillment --> finance (7 constraint(s)) =========
-- Requires: fulfillment schema, finance schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ADD CONSTRAINT `fk_fulfillment_delivery_route_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ADD CONSTRAINT `fk_fulfillment_fulfillment_node_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ADD CONSTRAINT `fk_fulfillment_fulfillment_node_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ADD CONSTRAINT `fk_fulfillment_exception_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= fulfillment --> loyalty (1 constraint(s)) =========
-- Requires: fulfillment schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ADD CONSTRAINT `fk_fulfillment_exception_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);

-- ========= fulfillment --> merchandising (2 constraint(s)) =========
-- Requires: fulfillment schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`sla` ADD CONSTRAINT `fk_fulfillment_sla_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ADD CONSTRAINT `fk_fulfillment_drop_ship_order_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);

-- ========= fulfillment --> order (11 constraint(s)) =========
-- Requires: fulfillment schema, order schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ADD CONSTRAINT `fk_fulfillment_shipment_package_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ADD CONSTRAINT `fk_fulfillment_pack_task_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ADD CONSTRAINT `fk_fulfillment_delivery_stop_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ADD CONSTRAINT `fk_fulfillment_drop_ship_order_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ADD CONSTRAINT `fk_fulfillment_drop_ship_order_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ADD CONSTRAINT `fk_fulfillment_proof_of_delivery_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);

-- ========= fulfillment --> pricing (3 constraint(s)) =========
-- Requires: fulfillment schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ADD CONSTRAINT `fk_fulfillment_drop_ship_order_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);

-- ========= fulfillment --> product (1 constraint(s)) =========
-- Requires: fulfillment schema, product schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= fulfillment --> service (1 constraint(s)) =========
-- Requires: fulfillment schema, service schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ADD CONSTRAINT `fk_fulfillment_exception_service_case_id` FOREIGN KEY (`service_case_id`) REFERENCES `vibe_retail_v1`.`service`.`service_case`(`service_case_id`);

-- ========= fulfillment --> store (2 constraint(s)) =========
-- Requires: fulfillment schema, store schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= fulfillment --> supplier (6 constraint(s)) =========
-- Requires: fulfillment schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ADD CONSTRAINT `fk_fulfillment_carrier_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ADD CONSTRAINT `fk_fulfillment_drop_ship_order_vendor_contact_id` FOREIGN KEY (`vendor_contact_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contact`(`vendor_contact_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ADD CONSTRAINT `fk_fulfillment_drop_ship_order_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ADD CONSTRAINT `fk_fulfillment_drop_ship_order_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`drop_ship_order` ADD CONSTRAINT `fk_fulfillment_drop_ship_order_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);

-- ========= fulfillment --> supplychain (13 constraint(s)) =========
-- Requires: fulfillment schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_handling_unit_id` FOREIGN KEY (`handling_unit_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`handling_unit`(`handling_unit_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_outbound_order_line_id` FOREIGN KEY (`outbound_order_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order_line`(`outbound_order_line_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_outbound_shipment_id` FOREIGN KEY (`outbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_shipment`(`outbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ADD CONSTRAINT `fk_fulfillment_shipment_package_outbound_shipment_id` FOREIGN KEY (`outbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_shipment`(`outbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_wave_id` FOREIGN KEY (`wave_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`wave`(`wave_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ADD CONSTRAINT `fk_fulfillment_pack_task_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ADD CONSTRAINT `fk_fulfillment_delivery_route_outbound_shipment_id` FOREIGN KEY (`outbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_shipment`(`outbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ADD CONSTRAINT `fk_fulfillment_delivery_stop_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ADD CONSTRAINT `fk_fulfillment_fulfillment_node_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ADD CONSTRAINT `fk_fulfillment_proof_of_delivery_outbound_shipment_id` FOREIGN KEY (`outbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_shipment`(`outbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier_facility_contract` ADD CONSTRAINT `fk_fulfillment_carrier_facility_contract_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= fulfillment --> workforce (9 constraint(s)) =========
-- Requires: fulfillment schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ADD CONSTRAINT `fk_fulfillment_pack_task_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_route` ADD CONSTRAINT `fk_fulfillment_delivery_route_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`delivery_stop` ADD CONSTRAINT `fk_fulfillment_delivery_stop_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`exception` ADD CONSTRAINT `fk_fulfillment_exception_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`proof_of_delivery` ADD CONSTRAINT `fk_fulfillment_proof_of_delivery_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= inventory --> compliance (7 constraint(s)) =========
-- Requires: inventory schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_food_safety_plan_id` FOREIGN KEY (`food_safety_plan_id`) REFERENCES `vibe_retail_v1`.`compliance`.`food_safety_plan`(`food_safety_plan_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_haccp_control_point_id` FOREIGN KEY (`haccp_control_point_id`) REFERENCES `vibe_retail_v1`.`compliance`.`haccp_control_point`(`haccp_control_point_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`vmi_agreement` ADD CONSTRAINT `fk_inventory_vmi_agreement_license_permit_id` FOREIGN KEY (`license_permit_id`) REFERENCES `vibe_retail_v1`.`compliance`.`license_permit`(`license_permit_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`expiry_tracking` ADD CONSTRAINT `fk_inventory_expiry_tracking_food_safety_plan_id` FOREIGN KEY (`food_safety_plan_id`) REFERENCES `vibe_retail_v1`.`compliance`.`food_safety_plan`(`food_safety_plan_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`asn` ADD CONSTRAINT `fk_inventory_asn_food_safety_log_id` FOREIGN KEY (`food_safety_log_id`) REFERENCES `vibe_retail_v1`.`compliance`.`food_safety_log`(`food_safety_log_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_food_safety_plan_id` FOREIGN KEY (`food_safety_plan_id`) REFERENCES `vibe_retail_v1`.`compliance`.`food_safety_plan`(`food_safety_plan_id`);

-- ========= inventory --> customer (2 constraint(s)) =========
-- Requires: inventory schema, customer schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= inventory --> ecommerce (2 constraint(s)) =========
-- Requires: inventory schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`cart`(`cart_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_checkout_id` FOREIGN KEY (`checkout_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`checkout`(`checkout_id`);

-- ========= inventory --> finance (8 constraint(s)) =========
-- Requires: inventory schema, finance schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= inventory --> fulfillment (4 constraint(s)) =========
-- Requires: inventory schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_fulfillment_line_id` FOREIGN KEY (`fulfillment_line_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_line`(`fulfillment_line_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`asn` ADD CONSTRAINT `fk_inventory_asn_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);

-- ========= inventory --> loyalty (1 constraint(s)) =========
-- Requires: inventory schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);

-- ========= inventory --> merchandising (13 constraint(s)) =========
-- Requires: inventory schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`vmi_agreement` ADD CONSTRAINT `fk_inventory_vmi_agreement_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`vmi_agreement` ADD CONSTRAINT `fk_inventory_vmi_agreement_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`expiry_tracking` ADD CONSTRAINT `fk_inventory_expiry_tracking_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`assortment_deployment` ADD CONSTRAINT `fk_inventory_assortment_deployment_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`assortment_deployment` ADD CONSTRAINT `fk_inventory_assortment_deployment_merchandising_planogram_id` FOREIGN KEY (`merchandising_planogram_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`merchandising_planogram`(`merchandising_planogram_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`assortment_deployment` ADD CONSTRAINT `fk_inventory_assortment_deployment_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);

-- ========= inventory --> order (3 constraint(s)) =========
-- Requires: inventory schema, order schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`rfid_tag` ADD CONSTRAINT `fk_inventory_rfid_tag_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);

-- ========= inventory --> pricing (9 constraint(s)) =========
-- Requires: inventory schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`expiry_tracking` ADD CONSTRAINT `fk_inventory_expiry_tracking_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);

-- ========= inventory --> product (14 constraint(s)) =========
-- Requires: inventory schema, product schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`rfid_tag` ADD CONSTRAINT `fk_inventory_rfid_tag_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`vmi_agreement` ADD CONSTRAINT `fk_inventory_vmi_agreement_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`expiry_tracking` ADD CONSTRAINT `fk_inventory_expiry_tracking_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`node_assortment` ADD CONSTRAINT `fk_inventory_node_assortment_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);

-- ========= inventory --> promotion (2 constraint(s)) =========
-- Requires: inventory schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`promo_stock_allocation` ADD CONSTRAINT `fk_inventory_promo_stock_allocation_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= inventory --> store (9 constraint(s)) =========
-- Requires: inventory schema, store schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`inventory_node` ADD CONSTRAINT `fk_inventory_inventory_node_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`rfid_tag` ADD CONSTRAINT `fk_inventory_rfid_tag_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`rfid_tag` ADD CONSTRAINT `fk_inventory_rfid_tag_tertiary_rfid_location_id` FOREIGN KEY (`tertiary_rfid_location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`vmi_agreement` ADD CONSTRAINT `fk_inventory_vmi_agreement_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`expiry_tracking` ADD CONSTRAINT `fk_inventory_expiry_tracking_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= inventory --> supplier (11 constraint(s)) =========
-- Requires: inventory schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`rfid_tag` ADD CONSTRAINT `fk_inventory_rfid_tag_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`vmi_agreement` ADD CONSTRAINT `fk_inventory_vmi_agreement_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`expiry_tracking` ADD CONSTRAINT `fk_inventory_expiry_tracking_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`asn` ADD CONSTRAINT `fk_inventory_asn_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`asn` ADD CONSTRAINT `fk_inventory_asn_supplier_edi_transaction_id` FOREIGN KEY (`supplier_edi_transaction_id`) REFERENCES `vibe_retail_v1`.`supplier`.`supplier_edi_transaction`(`supplier_edi_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= inventory --> supplychain (19 constraint(s)) =========
-- Requires: inventory schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`inventory_node` ADD CONSTRAINT `fk_inventory_inventory_node_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_inbound_appointment_id` FOREIGN KEY (`inbound_appointment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_appointment`(`inbound_appointment_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_supplychain_edi_transaction_id` FOREIGN KEY (`supplychain_edi_transaction_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`supplychain_edi_transaction`(`supplychain_edi_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_supplychain_edi_transaction_id` FOREIGN KEY (`supplychain_edi_transaction_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`supplychain_edi_transaction`(`supplychain_edi_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_inbound_appointment_id` FOREIGN KEY (`inbound_appointment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_appointment`(`inbound_appointment_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`expiry_tracking` ADD CONSTRAINT `fk_inventory_expiry_tracking_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_supplychain_edi_transaction_id` FOREIGN KEY (`supplychain_edi_transaction_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`supplychain_edi_transaction`(`supplychain_edi_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`asn` ADD CONSTRAINT `fk_inventory_asn_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`asn` ADD CONSTRAINT `fk_inventory_asn_dock_appointment_id` FOREIGN KEY (`dock_appointment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dock_appointment`(`dock_appointment_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`asn` ADD CONSTRAINT `fk_inventory_asn_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);

-- ========= inventory --> workforce (9 constraint(s)) =========
-- Requires: inventory schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_primary_cycle_associate_id` FOREIGN KEY (`primary_cycle_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`location_assignment` ADD CONSTRAINT `fk_inventory_location_assignment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= loyalty --> compliance (2 constraint(s)) =========
-- Requires: loyalty schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ADD CONSTRAINT `fk_loyalty_loyalty_program_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_program` ADD CONSTRAINT `fk_loyalty_partner_program_third_party_assessment_id` FOREIGN KEY (`third_party_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`third_party_assessment`(`third_party_assessment_id`);

-- ========= loyalty --> customer (3 constraint(s)) =========
-- Requires: loyalty schema, customer schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ADD CONSTRAINT `fk_loyalty_loyalty_membership_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ADD CONSTRAINT `fk_loyalty_clienteling_interaction_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ADD CONSTRAINT `fk_loyalty_referral_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= loyalty --> ecommerce (7 constraint(s)) =========
-- Requires: loyalty schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ADD CONSTRAINT `fk_loyalty_loyalty_membership_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`cart`(`cart_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`cart`(`cart_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ADD CONSTRAINT `fk_loyalty_member_offer_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ADD CONSTRAINT `fk_loyalty_clienteling_interaction_web_session_id` FOREIGN KEY (`web_session_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`web_session`(`web_session_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ADD CONSTRAINT `fk_loyalty_referral_web_session_id` FOREIGN KEY (`web_session_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`web_session`(`web_session_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`campaign_storefront_deployment` ADD CONSTRAINT `fk_loyalty_campaign_storefront_deployment_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);

-- ========= loyalty --> finance (6 constraint(s)) =========
-- Requires: loyalty schema, finance schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_revenue_recognition_event_id` FOREIGN KEY (`revenue_recognition_event_id`) REFERENCES `vibe_retail_v1`.`finance`.`revenue_recognition_event`(`revenue_recognition_event_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ADD CONSTRAINT `fk_loyalty_engagement_campaign_finance_budget_id` FOREIGN KEY (`finance_budget_id`) REFERENCES `vibe_retail_v1`.`finance`.`finance_budget`(`finance_budget_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ADD CONSTRAINT `fk_loyalty_partner_transaction_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);

-- ========= loyalty --> fulfillment (1 constraint(s)) =========
-- Requires: loyalty schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ADD CONSTRAINT `fk_loyalty_clienteling_interaction_bopis_appointment_id` FOREIGN KEY (`bopis_appointment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`bopis_appointment`(`bopis_appointment_id`);

-- ========= loyalty --> marketing (9 constraint(s)) =========
-- Requires: loyalty schema, marketing schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ADD CONSTRAINT `fk_loyalty_member_offer_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ADD CONSTRAINT `fk_loyalty_engagement_campaign_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`segment`(`segment_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ADD CONSTRAINT `fk_loyalty_engagement_campaign_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ADD CONSTRAINT `fk_loyalty_clienteling_interaction_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ADD CONSTRAINT `fk_loyalty_member_segment_audience_segment_id` FOREIGN KEY (`audience_segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`audience_segment`(`audience_segment_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`partner_transaction` ADD CONSTRAINT `fk_loyalty_partner_transaction_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ADD CONSTRAINT `fk_loyalty_referral_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);

-- ========= loyalty --> order (7 constraint(s)) =========
-- Requires: loyalty schema, order schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ADD CONSTRAINT `fk_loyalty_clienteling_interaction_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ADD CONSTRAINT `fk_loyalty_clienteling_interaction_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ADD CONSTRAINT `fk_loyalty_referral_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);

-- ========= loyalty --> pricing (1 constraint(s)) =========
-- Requires: loyalty schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);

-- ========= loyalty --> product (12 constraint(s)) =========
-- Requires: loyalty schema, product schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_product_brand_id` FOREIGN KEY (`product_brand_id`) REFERENCES `vibe_retail_v1`.`product`.`product_brand`(`product_brand_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_product_brand_id` FOREIGN KEY (`product_brand_id`) REFERENCES `vibe_retail_v1`.`product`.`product_brand`(`product_brand_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_product_brand_id` FOREIGN KEY (`product_brand_id`) REFERENCES `vibe_retail_v1`.`product`.`product_brand`(`product_brand_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ADD CONSTRAINT `fk_loyalty_member_offer_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ADD CONSTRAINT `fk_loyalty_member_offer_product_brand_id` FOREIGN KEY (`product_brand_id`) REFERENCES `vibe_retail_v1`.`product`.`product_brand`(`product_brand_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ADD CONSTRAINT `fk_loyalty_member_offer_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= loyalty --> promotion (5 constraint(s)) =========
-- Requires: loyalty schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ADD CONSTRAINT `fk_loyalty_member_offer_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ADD CONSTRAINT `fk_loyalty_engagement_campaign_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);

-- ========= loyalty --> store (12 constraint(s)) =========
-- Requires: loyalty schema, store schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_membership` ADD CONSTRAINT `fk_loyalty_loyalty_membership_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_offer` ADD CONSTRAINT `fk_loyalty_member_offer_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ADD CONSTRAINT `fk_loyalty_engagement_campaign_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ADD CONSTRAINT `fk_loyalty_engagement_campaign_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ADD CONSTRAINT `fk_loyalty_clienteling_interaction_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ADD CONSTRAINT `fk_loyalty_clienteling_interaction_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ADD CONSTRAINT `fk_loyalty_referral_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= loyalty --> supplier (1 constraint(s)) =========
-- Requires: loyalty schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= loyalty --> workforce (9 constraint(s)) =========
-- Requires: loyalty schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`loyalty_program` ADD CONSTRAINT `fk_loyalty_loyalty_program_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_tertiary_accrual_approved_by_user_associate_id` FOREIGN KEY (`tertiary_accrual_approved_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`engagement_campaign` ADD CONSTRAINT `fk_loyalty_engagement_campaign_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`clienteling_interaction` ADD CONSTRAINT `fk_loyalty_clienteling_interaction_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`member_segment` ADD CONSTRAINT `fk_loyalty_member_segment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`referral` ADD CONSTRAINT `fk_loyalty_referral_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= marketing --> analytics (2 constraint(s)) =========
-- Requires: marketing schema, analytics schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ADD CONSTRAINT `fk_marketing_campaign_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ADD CONSTRAINT `fk_marketing_campaign_performance_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);

-- ========= marketing --> compliance (8 constraint(s)) =========
-- Requires: marketing schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ADD CONSTRAINT `fk_marketing_campaign_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ADD CONSTRAINT `fk_marketing_campaign_training_program_id` FOREIGN KEY (`training_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`training_program`(`training_program_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ADD CONSTRAINT `fk_marketing_campaign_brief_privacy_assessment_id` FOREIGN KEY (`privacy_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`privacy_assessment`(`privacy_assessment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`audience_segment` ADD CONSTRAINT `fk_marketing_audience_segment_privacy_assessment_id` FOREIGN KEY (`privacy_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`privacy_assessment`(`privacy_assessment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ADD CONSTRAINT `fk_marketing_social_post_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `vibe_retail_v1`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ADD CONSTRAINT `fk_marketing_influencer_engagement_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `vibe_retail_v1`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_privacy_assessment_id` FOREIGN KEY (`privacy_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`privacy_assessment`(`privacy_assessment_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ADD CONSTRAINT `fk_marketing_campaign_policy_compliance_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `vibe_retail_v1`.`compliance`.`policy`(`policy_id`);

-- ========= marketing --> customer (8 constraint(s)) =========
-- Requires: marketing schema, customer schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ADD CONSTRAINT `fk_marketing_sms_send_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ADD CONSTRAINT `fk_marketing_push_notification_send_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ADD CONSTRAINT `fk_marketing_social_post_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ADD CONSTRAINT `fk_marketing_conversion_event_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ADD CONSTRAINT `fk_marketing_automation_enrollment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ADD CONSTRAINT `fk_marketing_opt_in_record_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ADD CONSTRAINT `fk_marketing_customer_membership_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= marketing --> ecommerce (10 constraint(s)) =========
-- Requires: marketing schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_send` ADD CONSTRAINT `fk_marketing_email_send_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ADD CONSTRAINT `fk_marketing_sms_send_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ADD CONSTRAINT `fk_marketing_push_notification_send_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ADD CONSTRAINT `fk_marketing_social_post_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_web_session_id` FOREIGN KEY (`web_session_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`web_session`(`web_session_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ADD CONSTRAINT `fk_marketing_conversion_event_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ADD CONSTRAINT `fk_marketing_conversion_event_web_session_id` FOREIGN KEY (`web_session_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`web_session`(`web_session_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ADD CONSTRAINT `fk_marketing_campaign_performance_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_deployment` ADD CONSTRAINT `fk_marketing_campaign_deployment_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);

-- ========= marketing --> finance (5 constraint(s)) =========
-- Requires: marketing schema, finance schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ADD CONSTRAINT `fk_marketing_media_buy_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ADD CONSTRAINT `fk_marketing_influencer_engagement_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ADD CONSTRAINT `fk_marketing_marketing_budget_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ADD CONSTRAINT `fk_marketing_campaign_performance_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ADD CONSTRAINT `fk_marketing_agency_brief_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= marketing --> loyalty (1 constraint(s)) =========
-- Requires: marketing schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`customer_membership` ADD CONSTRAINT `fk_marketing_customer_membership_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);

-- ========= marketing --> merchandising (2 constraint(s)) =========
-- Requires: marketing schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ADD CONSTRAINT `fk_marketing_segment_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);

-- ========= marketing --> order (2 constraint(s)) =========
-- Requires: marketing schema, order schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ADD CONSTRAINT `fk_marketing_conversion_event_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);

-- ========= marketing --> pricing (8 constraint(s)) =========
-- Requires: marketing schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ADD CONSTRAINT `fk_marketing_campaign_price_strategy_id` FOREIGN KEY (`price_strategy_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_strategy`(`price_strategy_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ADD CONSTRAINT `fk_marketing_media_buy_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ADD CONSTRAINT `fk_marketing_creative_asset_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ADD CONSTRAINT `fk_marketing_ab_test_campaign_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ADD CONSTRAINT `fk_marketing_campaign_performance_price_strategy_id` FOREIGN KEY (`price_strategy_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_strategy`(`price_strategy_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ADD CONSTRAINT `fk_marketing_segment_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ADD CONSTRAINT `fk_marketing_segment_price_strategy_id` FOREIGN KEY (`price_strategy_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_strategy`(`price_strategy_id`);

-- ========= marketing --> product (8 constraint(s)) =========
-- Requires: marketing schema, product schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_brief` ADD CONSTRAINT `fk_marketing_campaign_brief_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ADD CONSTRAINT `fk_marketing_media_buy_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ADD CONSTRAINT `fk_marketing_creative_asset_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_touchpoint` ADD CONSTRAINT `fk_marketing_attribution_touchpoint_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ADD CONSTRAINT `fk_marketing_conversion_event_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_performance` ADD CONSTRAINT `fk_marketing_campaign_performance_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ADD CONSTRAINT `fk_marketing_agency_brief_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ADD CONSTRAINT `fk_marketing_segment_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);

-- ========= marketing --> promotion (1 constraint(s)) =========
-- Requires: marketing schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ADD CONSTRAINT `fk_marketing_segment_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);

-- ========= marketing --> store (1 constraint(s)) =========
-- Requires: marketing schema, store schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ADD CONSTRAINT `fk_marketing_conversion_event_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= marketing --> supplychain (3 constraint(s)) =========
-- Requires: marketing schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ADD CONSTRAINT `fk_marketing_campaign_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ADD CONSTRAINT `fk_marketing_campaign_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_fulfillment` ADD CONSTRAINT `fk_marketing_campaign_fulfillment_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= marketing --> workforce (54 constraint(s)) =========
-- Requires: marketing schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ADD CONSTRAINT `fk_marketing_campaign_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ADD CONSTRAINT `fk_marketing_campaign_campaign_associate_id` FOREIGN KEY (`campaign_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign` ADD CONSTRAINT `fk_marketing_campaign_campaign_modified_by_associate_id` FOREIGN KEY (`campaign_modified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ADD CONSTRAINT `fk_marketing_media_plan_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ADD CONSTRAINT `fk_marketing_media_plan_media_modified_by_associate_id` FOREIGN KEY (`media_modified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ADD CONSTRAINT `fk_marketing_media_plan_owner_associate_id` FOREIGN KEY (`owner_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_plan` ADD CONSTRAINT `fk_marketing_media_plan_primary_media_associate_id` FOREIGN KEY (`primary_media_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ADD CONSTRAINT `fk_marketing_media_buy_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ADD CONSTRAINT `fk_marketing_media_buy_media_created_by_associate_id` FOREIGN KEY (`media_created_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`media_buy` ADD CONSTRAINT `fk_marketing_media_buy_media_modified_by_associate_id` FOREIGN KEY (`media_modified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ADD CONSTRAINT `fk_marketing_creative_asset_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ADD CONSTRAINT `fk_marketing_creative_asset_creative_modified_by_associate_id` FOREIGN KEY (`creative_modified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ADD CONSTRAINT `fk_marketing_creative_asset_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`creative_asset` ADD CONSTRAINT `fk_marketing_creative_asset_primary_creative_owner_associate_id` FOREIGN KEY (`primary_creative_owner_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`sms_send` ADD CONSTRAINT `fk_marketing_sms_send_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`push_notification_send` ADD CONSTRAINT `fk_marketing_push_notification_send_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ADD CONSTRAINT `fk_marketing_social_post_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`social_post` ADD CONSTRAINT `fk_marketing_social_post_tertiary_social_modified_by_associate_id` FOREIGN KEY (`tertiary_social_modified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer` ADD CONSTRAINT `fk_marketing_influencer_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ADD CONSTRAINT `fk_marketing_influencer_engagement_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ADD CONSTRAINT `fk_marketing_influencer_engagement_influencer_created_by_associate_id` FOREIGN KEY (`influencer_created_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`influencer_engagement` ADD CONSTRAINT `fk_marketing_influencer_engagement_influencer_modified_by_associate_id` FOREIGN KEY (`influencer_modified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ADD CONSTRAINT `fk_marketing_attribution_model_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ADD CONSTRAINT `fk_marketing_attribution_model_attribution_created_by_associate_id` FOREIGN KEY (`attribution_created_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ADD CONSTRAINT `fk_marketing_attribution_model_attribution_modified_by_associate_id` FOREIGN KEY (`attribution_modified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`attribution_model` ADD CONSTRAINT `fk_marketing_attribution_model_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_retail_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ADD CONSTRAINT `fk_marketing_conversion_event_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`conversion_event` ADD CONSTRAINT `fk_marketing_conversion_event_conversion_modified_by_associate_id` FOREIGN KEY (`conversion_modified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ADD CONSTRAINT `fk_marketing_marketing_budget_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ADD CONSTRAINT `fk_marketing_marketing_budget_marketing_modified_by_associate_id` FOREIGN KEY (`marketing_modified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_budget` ADD CONSTRAINT `fk_marketing_marketing_budget_primary_marketing_associate_id` FOREIGN KEY (`primary_marketing_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ADD CONSTRAINT `fk_marketing_marketing_brand_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ADD CONSTRAINT `fk_marketing_marketing_brand_marketing_modified_by_associate_id` FOREIGN KEY (`marketing_modified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`marketing_brand` ADD CONSTRAINT `fk_marketing_marketing_brand_primary_marketing_associate_id` FOREIGN KEY (`primary_marketing_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ADD CONSTRAINT `fk_marketing_channel_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`channel` ADD CONSTRAINT `fk_marketing_channel_channel_modified_by_user_associate_id` FOREIGN KEY (`channel_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ADD CONSTRAINT `fk_marketing_utm_parameter_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`utm_parameter` ADD CONSTRAINT `fk_marketing_utm_parameter_tertiary_utm_approved_by_user_associate_id` FOREIGN KEY (`tertiary_utm_approved_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ADD CONSTRAINT `fk_marketing_ab_test_campaign_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ADD CONSTRAINT `fk_marketing_ab_test_campaign_ab_modified_by_associate_id` FOREIGN KEY (`ab_modified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`ab_test_campaign` ADD CONSTRAINT `fk_marketing_ab_test_campaign_primary_ab_associate_id` FOREIGN KEY (`primary_ab_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ADD CONSTRAINT `fk_marketing_automation_flow_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ADD CONSTRAINT `fk_marketing_automation_flow_automation_created_by_associate_id` FOREIGN KEY (`automation_created_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_flow` ADD CONSTRAINT `fk_marketing_automation_flow_automation_modified_by_associate_id` FOREIGN KEY (`automation_modified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`automation_enrollment` ADD CONSTRAINT `fk_marketing_automation_enrollment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ADD CONSTRAINT `fk_marketing_opt_in_record_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`opt_in_record` ADD CONSTRAINT `fk_marketing_opt_in_record_opt_modified_by_user_associate_id` FOREIGN KEY (`opt_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ADD CONSTRAINT `fk_marketing_agency_brief_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`agency_brief` ADD CONSTRAINT `fk_marketing_agency_brief_primary_agency_associate_id` FOREIGN KEY (`primary_agency_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`campaign_policy_compliance` ADD CONSTRAINT `fk_marketing_campaign_policy_compliance_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` ADD CONSTRAINT `fk_marketing_email_template_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` ADD CONSTRAINT `fk_marketing_email_template_email_associate_id` FOREIGN KEY (`email_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`email_template` ADD CONSTRAINT `fk_marketing_email_template_email_last_modified_by_user_associate_id` FOREIGN KEY (`email_last_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`marketing`.`segment` ADD CONSTRAINT `fk_marketing_segment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= merchandising --> analytics (6 constraint(s)) =========
-- Requires: merchandising schema, analytics schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_report_subscription_id` FOREIGN KEY (`report_subscription_id`) REFERENCES `vibe_retail_v1`.`analytics`.`report_subscription`(`report_subscription_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`season` ADD CONSTRAINT `fk_merchandising_season_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_alert_id` FOREIGN KEY (`alert_id`) REFERENCES `vibe_retail_v1`.`analytics`.`alert`(`alert_id`);

-- ========= merchandising --> compliance (6 constraint(s)) =========
-- Requires: merchandising schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ADD CONSTRAINT `fk_merchandising_category_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_license_permit_id` FOREIGN KEY (`license_permit_id`) REFERENCES `vibe_retail_v1`.`compliance`.`license_permit`(`license_permit_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_certification_id` FOREIGN KEY (`certification_id`) REFERENCES `vibe_retail_v1`.`compliance`.`certification`(`certification_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ADD CONSTRAINT `fk_merchandising_vendor_negotiation_corrective_action_id` FOREIGN KEY (`corrective_action_id`) REFERENCES `vibe_retail_v1`.`compliance`.`corrective_action`(`corrective_action_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_finding`(`audit_finding_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ADD CONSTRAINT `fk_merchandising_private_label_program_certification_id` FOREIGN KEY (`certification_id`) REFERENCES `vibe_retail_v1`.`compliance`.`certification`(`certification_id`);

-- ========= merchandising --> finance (17 constraint(s)) =========
-- Requires: merchandising schema, finance schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ADD CONSTRAINT `fk_merchandising_category_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ADD CONSTRAINT `fk_merchandising_category_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ADD CONSTRAINT `fk_merchandising_buyer_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ADD CONSTRAINT `fk_merchandising_private_label_program_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ADD CONSTRAINT `fk_merchandising_private_label_program_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer_profit_center_assignment` ADD CONSTRAINT `fk_merchandising_buyer_profit_center_assignment_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);

-- ========= merchandising --> fulfillment (1 constraint(s)) =========
-- Requires: merchandising schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= merchandising --> loyalty (1 constraint(s)) =========
-- Requires: merchandising schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ADD CONSTRAINT `fk_merchandising_category_accrual_rule_accrual_rule_id` FOREIGN KEY (`accrual_rule_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`accrual_rule`(`accrual_rule_id`);

-- ========= merchandising --> marketing (4 constraint(s)) =========
-- Requires: merchandising schema, marketing schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ADD CONSTRAINT `fk_merchandising_private_label_program_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_campaign_placement` ADD CONSTRAINT `fk_merchandising_category_campaign_placement_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);

-- ========= merchandising --> pricing (4 constraint(s)) =========
-- Requires: merchandising schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_price_strategy_id` FOREIGN KEY (`price_strategy_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_strategy`(`price_strategy_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_price_strategy_id` FOREIGN KEY (`price_strategy_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_strategy`(`price_strategy_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ADD CONSTRAINT `fk_merchandising_private_label_program_price_strategy_id` FOREIGN KEY (`price_strategy_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_strategy`(`price_strategy_id`);

-- ========= merchandising --> product (8 constraint(s)) =========
-- Requires: merchandising schema, product schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`planogram_position` ADD CONSTRAINT `fk_merchandising_planogram_position_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ADD CONSTRAINT `fk_merchandising_private_label_program_product_brand_id` FOREIGN KEY (`product_brand_id`) REFERENCES `vibe_retail_v1`.`product`.`product_brand`(`product_brand_id`);

-- ========= merchandising --> promotion (1 constraint(s)) =========
-- Requires: merchandising schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);

-- ========= merchandising --> store (18 constraint(s)) =========
-- Requires: merchandising schema, store schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ADD CONSTRAINT `fk_merchandising_merchandising_planogram_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ADD CONSTRAINT `fk_merchandising_merchandising_planogram_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ADD CONSTRAINT `fk_merchandising_vendor_negotiation_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ADD CONSTRAINT `fk_merchandising_private_label_program_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ADD CONSTRAINT `fk_merchandising_private_label_program_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);

-- ========= merchandising --> supplier (7 constraint(s)) =========
-- Requires: merchandising schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ADD CONSTRAINT `fk_merchandising_vendor_negotiation_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ADD CONSTRAINT `fk_merchandising_vendor_negotiation_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_vendor_allowance_id` FOREIGN KEY (`vendor_allowance_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_allowance`(`vendor_allowance_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ADD CONSTRAINT `fk_merchandising_private_label_program_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= merchandising --> supplychain (2 constraint(s)) =========
-- Requires: merchandising schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`po_line`(`po_line_id`);

-- ========= merchandising --> workforce (12 constraint(s)) =========
-- Requires: merchandising schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ADD CONSTRAINT `fk_merchandising_category_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ADD CONSTRAINT `fk_merchandising_buyer_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merchandising_planogram` ADD CONSTRAINT `fk_merchandising_merchandising_planogram_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`vendor_negotiation` ADD CONSTRAINT `fk_merchandising_vendor_negotiation_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`markdown_event` ADD CONSTRAINT `fk_merchandising_markdown_event_tertiary_markdown_modified_by_user_associate_id` FOREIGN KEY (`tertiary_markdown_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`private_label_program` ADD CONSTRAINT `fk_merchandising_private_label_program_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category_accrual_rule` ADD CONSTRAINT `fk_merchandising_category_accrual_rule_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= order --> compliance (4 constraint(s)) =========
-- Requires: order schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_pci_assessment_id` FOREIGN KEY (`pci_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`pci_assessment`(`pci_assessment_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`hold` ADD CONSTRAINT `fk_order_hold_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_finding`(`audit_finding_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_pci_assessment_id` FOREIGN KEY (`pci_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`pci_assessment`(`pci_assessment_id`);

-- ========= order --> customer (9 constraint(s)) =========
-- Requires: order schema, customer schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_corporate_account_id` FOREIGN KEY (`corporate_account_id`) REFERENCES `vibe_retail_v1`.`customer`.`corporate_account`(`corporate_account_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);

-- ========= order --> ecommerce (2 constraint(s)) =========
-- Requires: order schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);

-- ========= order --> finance (14 constraint(s)) =========
-- Requires: order schema, finance schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_bank_account_id` FOREIGN KEY (`bank_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`bank_account`(`bank_account_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_payment_method_id` FOREIGN KEY (`payment_method_id`) REFERENCES `vibe_retail_v1`.`finance`.`payment_method`(`payment_method_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);

-- ========= order --> fulfillment (14 constraint(s)) =========
-- Requires: order schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`status_history` ADD CONSTRAINT `fk_order_status_history_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`status_history` ADD CONSTRAINT `fk_order_status_history_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`line_status_history` ADD CONSTRAINT `fk_order_line_status_history_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`line_status_history` ADD CONSTRAINT `fk_order_line_status_history_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`line_status_history` ADD CONSTRAINT `fk_order_line_status_history_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`line_status_history` ADD CONSTRAINT `fk_order_line_status_history_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`promise` ADD CONSTRAINT `fk_order_promise_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`promise` ADD CONSTRAINT `fk_order_promise_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`promise` ADD CONSTRAINT `fk_order_promise_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= order --> inventory (4 constraint(s)) =========
-- Requires: order schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_lot_id` FOREIGN KEY (`lot_id`) REFERENCES `vibe_retail_v1`.`inventory`.`lot`(`lot_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_stock_ledger_id` FOREIGN KEY (`stock_ledger_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_ledger`(`stock_ledger_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_stock_ledger_id` FOREIGN KEY (`stock_ledger_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_ledger`(`stock_ledger_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`hold` ADD CONSTRAINT `fk_order_hold_reservation_id` FOREIGN KEY (`reservation_id`) REFERENCES `vibe_retail_v1`.`inventory`.`reservation`(`reservation_id`);

-- ========= order --> loyalty (4 constraint(s)) =========
-- Requires: order schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);

-- ========= order --> merchandising (2 constraint(s)) =========
-- Requires: order schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);

-- ========= order --> pricing (5 constraint(s)) =========
-- Requires: order schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);

-- ========= order --> product (4 constraint(s)) =========
-- Requires: order schema, product schema
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= order --> promotion (3 constraint(s)) =========
-- Requires: order schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);

-- ========= order --> store (11 constraint(s)) =========
-- Requires: order schema, store schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_pos_store_location_id` FOREIGN KEY (`pos_store_location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`hold` ADD CONSTRAINT `fk_order_hold_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);

-- ========= order --> supplier (2 constraint(s)) =========
-- Requires: order schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= order --> supplychain (3 constraint(s)) =========
-- Requires: order schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`line_status_history` ADD CONSTRAINT `fk_order_line_status_history_wave_id` FOREIGN KEY (`wave_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`wave`(`wave_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_plan_id` FOREIGN KEY (`plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`plan`(`plan_id`);

-- ========= order --> workforce (12 constraint(s)) =========
-- Requires: order schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`order`.`status_history` ADD CONSTRAINT `fk_order_status_history_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`line_status_history` ADD CONSTRAINT `fk_order_line_status_history_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`line_status_history` ADD CONSTRAINT `fk_order_line_status_history_tertiary_line_user_associate_id` FOREIGN KEY (`tertiary_line_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_primary_cancellation_associate_id` FOREIGN KEY (`primary_cancellation_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`hold` ADD CONSTRAINT `fk_order_hold_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= pricing --> compliance (14 constraint(s)) =========
-- Requires: pricing schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`sku_price` ADD CONSTRAINT `fk_pricing_sku_price_food_safety_plan_id` FOREIGN KEY (`food_safety_plan_id`) REFERENCES `vibe_retail_v1`.`compliance`.`food_safety_plan`(`food_safety_plan_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`sku_price` ADD CONSTRAINT `fk_pricing_sku_price_license_permit_id` FOREIGN KEY (`license_permit_id`) REFERENCES `vibe_retail_v1`.`compliance`.`license_permit`(`license_permit_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_finding`(`audit_finding_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `vibe_retail_v1`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_violation_notice_id` FOREIGN KEY (`violation_notice_id`) REFERENCES `vibe_retail_v1`.`compliance`.`violation_notice`(`violation_notice_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_finding`(`audit_finding_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_license_permit_id` FOREIGN KEY (`license_permit_id`) REFERENCES `vibe_retail_v1`.`compliance`.`license_permit`(`license_permit_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_risk_register_id` FOREIGN KEY (`risk_register_id`) REFERENCES `vibe_retail_v1`.`compliance`.`risk_register`(`risk_register_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `vibe_retail_v1`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`margin_target` ADD CONSTRAINT `fk_pricing_margin_target_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `vibe_retail_v1`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_override` ADD CONSTRAINT `fk_pricing_price_override_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_finding`(`audit_finding_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_audit_log` ADD CONSTRAINT `fk_pricing_price_audit_log_audit_event_id` FOREIGN KEY (`audit_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_event`(`audit_event_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_audit_log` ADD CONSTRAINT `fk_pricing_price_audit_log_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `vibe_retail_v1`.`compliance`.`policy`(`policy_id`);

-- ========= pricing --> customer (1 constraint(s)) =========
-- Requires: pricing schema, customer schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_override` ADD CONSTRAINT `fk_pricing_price_override_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= pricing --> finance (12 constraint(s)) =========
-- Requires: pricing schema, finance schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_list` ADD CONSTRAINT `fk_pricing_price_list_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_zone` ADD CONSTRAINT `fk_pricing_price_zone_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`sku_price` ADD CONSTRAINT `fk_pricing_sku_price_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`margin_target` ADD CONSTRAINT `fk_pricing_margin_target_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_override` ADD CONSTRAINT `fk_pricing_price_override_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_strategy` ADD CONSTRAINT `fk_pricing_price_strategy_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_audit_log` ADD CONSTRAINT `fk_pricing_price_audit_log_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= pricing --> loyalty (5 constraint(s)) =========
-- Requires: pricing schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_list` ADD CONSTRAINT `fk_pricing_price_list_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_tier_id` FOREIGN KEY (`tier_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`tier`(`tier_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_override` ADD CONSTRAINT `fk_pricing_price_override_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_override` ADD CONSTRAINT `fk_pricing_price_override_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_program`(`loyalty_program_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_sensitivity` ADD CONSTRAINT `fk_pricing_price_sensitivity_tier_id` FOREIGN KEY (`tier_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`tier`(`tier_id`);

-- ========= pricing --> marketing (1 constraint(s)) =========
-- Requires: pricing schema, marketing schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_sensitivity` ADD CONSTRAINT `fk_pricing_price_sensitivity_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`segment`(`segment_id`);

-- ========= pricing --> merchandising (15 constraint(s)) =========
-- Requires: pricing schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_list` ADD CONSTRAINT `fk_pricing_price_list_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`margin_target` ADD CONSTRAINT `fk_pricing_margin_target_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`margin_target` ADD CONSTRAINT `fk_pricing_margin_target_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`margin_target` ADD CONSTRAINT `fk_pricing_margin_target_margin_category_id` FOREIGN KEY (`margin_category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`margin_target` ADD CONSTRAINT `fk_pricing_margin_target_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_strategy` ADD CONSTRAINT `fk_pricing_price_strategy_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_strategy` ADD CONSTRAINT `fk_pricing_price_strategy_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_strategy` ADD CONSTRAINT `fk_pricing_price_strategy_price_category_id` FOREIGN KEY (`price_category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_sensitivity` ADD CONSTRAINT `fk_pricing_price_sensitivity_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);

-- ========= pricing --> order (1 constraint(s)) =========
-- Requires: pricing schema, order schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_override` ADD CONSTRAINT `fk_pricing_price_override_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);

-- ========= pricing --> product (8 constraint(s)) =========
-- Requires: pricing schema, product schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`sku_price` ADD CONSTRAINT `fk_pricing_sku_price_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`competitive_price` ADD CONSTRAINT `fk_pricing_competitive_price_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_override` ADD CONSTRAINT `fk_pricing_price_override_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_sensitivity` ADD CONSTRAINT `fk_pricing_price_sensitivity_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_audit_log` ADD CONSTRAINT `fk_pricing_price_audit_log_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= pricing --> promotion (9 constraint(s)) =========
-- Requires: pricing schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`sku_price` ADD CONSTRAINT `fk_pricing_sku_price_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`competitive_price` ADD CONSTRAINT `fk_pricing_competitive_price_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_override` ADD CONSTRAINT `fk_pricing_price_override_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_audit_log` ADD CONSTRAINT `fk_pricing_price_audit_log_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule_application` ADD CONSTRAINT `fk_pricing_rule_application_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= pricing --> store (8 constraint(s)) =========
-- Requires: pricing schema, store schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_override` ADD CONSTRAINT `fk_pricing_price_override_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_override` ADD CONSTRAINT `fk_pricing_price_override_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_strategy` ADD CONSTRAINT `fk_pricing_price_strategy_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_audit_log` ADD CONSTRAINT `fk_pricing_price_audit_log_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= pricing --> supplier (4 constraint(s)) =========
-- Requires: pricing schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`competitive_price` ADD CONSTRAINT `fk_pricing_competitive_price_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= pricing --> supplychain (1 constraint(s)) =========
-- Requires: pricing schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);

-- ========= pricing --> workforce (11 constraint(s)) =========
-- Requires: pricing schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_primary_price_associate_id` FOREIGN KEY (`primary_price_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_override` ADD CONSTRAINT `fk_pricing_price_override_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_strategy` ADD CONSTRAINT `fk_pricing_price_strategy_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_sensitivity` ADD CONSTRAINT `fk_pricing_price_sensitivity_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_audit_log` ADD CONSTRAINT `fk_pricing_price_audit_log_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_audit_log` ADD CONSTRAINT `fk_pricing_price_audit_log_price_associate_id` FOREIGN KEY (`price_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_zone` ADD CONSTRAINT `fk_pricing_cost_zone_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_zone` ADD CONSTRAINT `fk_pricing_cost_zone_cost_created_by_user_associate_id` FOREIGN KEY (`cost_created_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_zone` ADD CONSTRAINT `fk_pricing_cost_zone_cost_last_modified_by_user_associate_id` FOREIGN KEY (`cost_last_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= product --> analytics (1 constraint(s)) =========
-- Requires: product schema, analytics schema
ALTER TABLE `vibe_retail_v1`.`product`.`category_kpi_target` ADD CONSTRAINT `fk_product_category_kpi_target_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);

-- ========= product --> compliance (1 constraint(s)) =========
-- Requires: product schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ADD CONSTRAINT `fk_product_recall_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);

-- ========= product --> finance (5 constraint(s)) =========
-- Requires: product schema, finance schema
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ADD CONSTRAINT `fk_product_item_hierarchy_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ADD CONSTRAINT `fk_product_item_hierarchy_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_hierarchy` ADD CONSTRAINT `fk_product_item_hierarchy_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ADD CONSTRAINT `fk_product_recall_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ADD CONSTRAINT `fk_product_recall_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);

-- ========= product --> fulfillment (3 constraint(s)) =========
-- Requires: product schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ADD CONSTRAINT `fk_product_product_compliance_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ADD CONSTRAINT `fk_product_product_compliance_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ADD CONSTRAINT `fk_product_assortment_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= product --> marketing (2 constraint(s)) =========
-- Requires: product schema, marketing schema
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_marketing_brand_id` FOREIGN KEY (`marketing_brand_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_brand`(`marketing_brand_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`category_campaign_plan` ADD CONSTRAINT `fk_product_category_campaign_plan_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);

-- ========= product --> merchandising (1 constraint(s)) =========
-- Requires: product schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ADD CONSTRAINT `fk_product_item_lifecycle_event_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);

-- ========= product --> store (4 constraint(s)) =========
-- Requires: product schema, store schema
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ADD CONSTRAINT `fk_product_item_lifecycle_event_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ADD CONSTRAINT `fk_product_recall_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ADD CONSTRAINT `fk_product_item_bundle_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= product --> supplier (6 constraint(s)) =========
-- Requires: product schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`product_brand` ADD CONSTRAINT `fk_product_product_brand_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ADD CONSTRAINT `fk_product_item_lifecycle_event_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ADD CONSTRAINT `fk_product_recall_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ADD CONSTRAINT `fk_product_item_bundle_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ADD CONSTRAINT `fk_product_item_cross_reference_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= product --> workforce (11 constraint(s)) =========
-- Requires: product schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`product`.`item_variant` ADD CONSTRAINT `fk_product_item_variant_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`image` ADD CONSTRAINT `fk_product_image_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ADD CONSTRAINT `fk_product_item_lifecycle_event_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_lifecycle_event` ADD CONSTRAINT `fk_product_item_lifecycle_event_primary_item_associate_id` FOREIGN KEY (`primary_item_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`product_compliance` ADD CONSTRAINT `fk_product_product_compliance_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ADD CONSTRAINT `fk_product_recall_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ADD CONSTRAINT `fk_product_item_bundle_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`gtin_registry` ADD CONSTRAINT `fk_product_gtin_registry_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_nutritional` ADD CONSTRAINT `fk_product_item_nutritional_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_cross_reference` ADD CONSTRAINT `fk_product_item_cross_reference_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`category_campaign_plan` ADD CONSTRAINT `fk_product_category_campaign_plan_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= promotion --> analytics (8 constraint(s)) =========
-- Requires: promotion schema, analytics schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ADD CONSTRAINT `fk_promotion_vendor_promo_claim_dq_rule_id` FOREIGN KEY (`dq_rule_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dq_rule`(`dq_rule_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ADD CONSTRAINT `fk_promotion_promo_budget_report_definition_id` FOREIGN KEY (`report_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`report_definition`(`report_definition_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ADD CONSTRAINT `fk_promotion_promo_forecast_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);

-- ========= promotion --> compliance (5 constraint(s)) =========
-- Requires: promotion schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);

-- ========= promotion --> customer (2 constraint(s)) =========
-- Requires: promotion schema, customer schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ADD CONSTRAINT `fk_promotion_rebate_claim_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= promotion --> finance (12 constraint(s)) =========
-- Requires: promotion schema, finance schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ADD CONSTRAINT `fk_promotion_rebate_claim_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `vibe_retail_v1`.`finance`.`ap_invoice`(`ap_invoice_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ADD CONSTRAINT `fk_promotion_vendor_promo_agreement_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ADD CONSTRAINT `fk_promotion_vendor_promo_claim_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `vibe_retail_v1`.`finance`.`ap_invoice`(`ap_invoice_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `vibe_retail_v1`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ADD CONSTRAINT `fk_promotion_promo_budget_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= promotion --> fulfillment (1 constraint(s)) =========
-- Requires: promotion schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);

-- ========= promotion --> inventory (2 constraint(s)) =========
-- Requires: promotion schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_stock_ledger_id` FOREIGN KEY (`stock_ledger_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_ledger`(`stock_ledger_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ADD CONSTRAINT `fk_promotion_promo_forecast_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);

-- ========= promotion --> loyalty (2 constraint(s)) =========
-- Requires: promotion schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_tier_id` FOREIGN KEY (`tier_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`tier`(`tier_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_loyalty_membership_id` FOREIGN KEY (`loyalty_membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_membership`(`loyalty_membership_id`);

-- ========= promotion --> marketing (14 constraint(s)) =========
-- Requires: promotion schema, marketing schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_creative_asset_id` FOREIGN KEY (`creative_asset_id`) REFERENCES `vibe_retail_v1`.`marketing`.`creative_asset`(`creative_asset_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ADD CONSTRAINT `fk_promotion_rebate_claim_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_attribution_touchpoint_id` FOREIGN KEY (`attribution_touchpoint_id`) REFERENCES `vibe_retail_v1`.`marketing`.`attribution_touchpoint`(`attribution_touchpoint_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ADD CONSTRAINT `fk_promotion_promo_budget_marketing_budget_id` FOREIGN KEY (`marketing_budget_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_budget`(`marketing_budget_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ADD CONSTRAINT `fk_promotion_promo_calendar_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ADD CONSTRAINT `fk_promotion_promo_forecast_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon_distribution` ADD CONSTRAINT `fk_promotion_coupon_distribution_audience_segment_id` FOREIGN KEY (`audience_segment_id`) REFERENCES `vibe_retail_v1`.`marketing`.`audience_segment`(`audience_segment_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promotion_stack` ADD CONSTRAINT `fk_promotion_promotion_stack_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);

-- ========= promotion --> merchandising (16 constraint(s)) =========
-- Requires: promotion schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ADD CONSTRAINT `fk_promotion_promo_budget_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ADD CONSTRAINT `fk_promotion_promo_budget_merch_plan_id` FOREIGN KEY (`merch_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`merch_plan`(`merch_plan_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ADD CONSTRAINT `fk_promotion_promo_calendar_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ADD CONSTRAINT `fk_promotion_promo_forecast_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ADD CONSTRAINT `fk_promotion_promo_forecast_merch_plan_id` FOREIGN KEY (`merch_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`merch_plan`(`merch_plan_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ADD CONSTRAINT `fk_promotion_circular_ad_category_feature_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);

-- ========= promotion --> order (3 constraint(s)) =========
-- Requires: promotion schema, order schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ADD CONSTRAINT `fk_promotion_rebate_claim_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);

-- ========= promotion --> product (8 constraint(s)) =========
-- Requires: promotion schema, product schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ADD CONSTRAINT `fk_promotion_promo_forecast_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= promotion --> returns (1 constraint(s)) =========
-- Requires: promotion schema, returns schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_rma_id` FOREIGN KEY (`rma_id`) REFERENCES `vibe_retail_v1`.`returns`.`rma`(`rma_id`);

-- ========= promotion --> store (5 constraint(s)) =========
-- Requires: promotion schema, store schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ADD CONSTRAINT `fk_promotion_rebate_claim_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ADD CONSTRAINT `fk_promotion_promo_forecast_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= promotion --> supplier (11 constraint(s)) =========
-- Requires: promotion schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ADD CONSTRAINT `fk_promotion_rebate_claim_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ADD CONSTRAINT `fk_promotion_vendor_promo_agreement_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ADD CONSTRAINT `fk_promotion_vendor_promo_claim_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ADD CONSTRAINT `fk_promotion_promo_conflict_rule_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promotion_stack` ADD CONSTRAINT `fk_promotion_promotion_stack_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= promotion --> supplychain (2 constraint(s)) =========
-- Requires: promotion schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ADD CONSTRAINT `fk_promotion_promo_forecast_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_inventory_allocation` ADD CONSTRAINT `fk_promotion_promo_inventory_allocation_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= promotion --> workforce (15 constraint(s)) =========
-- Requires: promotion schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_tertiary_circular_modified_by_user_associate_id` FOREIGN KEY (`tertiary_circular_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_rebate_created_by_user_associate_id` FOREIGN KEY (`rebate_created_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_rebate_last_modified_by_user_associate_id` FOREIGN KEY (`rebate_last_modified_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate_claim` ADD CONSTRAINT `fk_promotion_rebate_claim_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ADD CONSTRAINT `fk_promotion_vendor_promo_agreement_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_claim` ADD CONSTRAINT `fk_promotion_vendor_promo_claim_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_budget` ADD CONSTRAINT `fk_promotion_promo_budget_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ADD CONSTRAINT `fk_promotion_promo_conflict_rule_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_conflict_rule` ADD CONSTRAINT `fk_promotion_promo_conflict_rule_tertiary_promo_approved_by_user_associate_id` FOREIGN KEY (`tertiary_promo_approved_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_forecast` ADD CONSTRAINT `fk_promotion_promo_forecast_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ADD CONSTRAINT `fk_promotion_circular_ad_category_feature_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad_category_feature` ADD CONSTRAINT `fk_promotion_circular_ad_category_feature_circular_last_modified_by_associate_id` FOREIGN KEY (`circular_last_modified_by_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= returns --> compliance (7 constraint(s)) =========
-- Requires: returns schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_corrective_action_id` FOREIGN KEY (`corrective_action_id`) REFERENCES `vibe_retail_v1`.`compliance`.`corrective_action`(`corrective_action_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_environmental_event_id` FOREIGN KEY (`environmental_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`environmental_event`(`environmental_event_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_policy_id` FOREIGN KEY (`policy_id`) REFERENCES `vibe_retail_v1`.`compliance`.`policy`(`policy_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_training_program_id` FOREIGN KEY (`training_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`training_program`(`training_program_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`liquidation_batch` ADD CONSTRAINT `fk_returns_liquidation_batch_environmental_event_id` FOREIGN KEY (`environmental_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`environmental_event`(`environmental_event_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_fraud_case` ADD CONSTRAINT `fk_returns_return_fraud_case_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_finding`(`audit_finding_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_fraud_case` ADD CONSTRAINT `fk_returns_return_fraud_case_violation_notice_id` FOREIGN KEY (`violation_notice_id`) REFERENCES `vibe_retail_v1`.`compliance`.`violation_notice`(`violation_notice_id`);

-- ========= returns --> customer (10 constraint(s)) =========
-- Requires: returns schema, customer schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_shipment` ADD CONSTRAINT `fk_returns_return_shipment_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_fraud_case` ADD CONSTRAINT `fk_returns_return_fraud_case_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= returns --> finance (9 constraint(s)) =========
-- Requires: returns schema, finance schema
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`liquidation_batch` ADD CONSTRAINT `fk_returns_liquidation_batch_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`liquidation_batch` ADD CONSTRAINT `fk_returns_liquidation_batch_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`vendor_credit` ADD CONSTRAINT `fk_returns_vendor_credit_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`vendor_credit` ADD CONSTRAINT `fk_returns_vendor_credit_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_fraud_case` ADD CONSTRAINT `fk_returns_return_fraud_case_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= returns --> fulfillment (9 constraint(s)) =========
-- Requires: returns schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_fulfillment_line_id` FOREIGN KEY (`fulfillment_line_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_line`(`fulfillment_line_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_shipment` ADD CONSTRAINT `fk_returns_return_shipment_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_shipment` ADD CONSTRAINT `fk_returns_return_shipment_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_shipment` ADD CONSTRAINT `fk_returns_return_shipment_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);

-- ========= returns --> inventory (11 constraint(s)) =========
-- Requires: returns schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_expiry_tracking_id` FOREIGN KEY (`expiry_tracking_id`) REFERENCES `vibe_retail_v1`.`inventory`.`expiry_tracking`(`expiry_tracking_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_retail_v1`.`inventory`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_lot_id` FOREIGN KEY (`lot_id`) REFERENCES `vibe_retail_v1`.`inventory`.`lot`(`lot_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_retail_v1`.`inventory`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_stock_ledger_id` FOREIGN KEY (`stock_ledger_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_ledger`(`stock_ledger_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_lot_id` FOREIGN KEY (`lot_id`) REFERENCES `vibe_retail_v1`.`inventory`.`lot`(`lot_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`restock_event` ADD CONSTRAINT `fk_returns_restock_event_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`restock_event` ADD CONSTRAINT `fk_returns_restock_event_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`liquidation_item` ADD CONSTRAINT `fk_returns_liquidation_item_lot_id` FOREIGN KEY (`lot_id`) REFERENCES `vibe_retail_v1`.`inventory`.`lot`(`lot_id`);

-- ========= returns --> merchandising (1 constraint(s)) =========
-- Requires: returns schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);

-- ========= returns --> order (9 constraint(s)) =========
-- Requires: returns schema, order schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_fraud_case` ADD CONSTRAINT `fk_returns_return_fraud_case_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);

-- ========= returns --> pricing (3 constraint(s)) =========
-- Requires: returns schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`liquidation_item` ADD CONSTRAINT `fk_returns_liquidation_item_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);

-- ========= returns --> product (7 constraint(s)) =========
-- Requires: returns schema, product schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rtv_line` ADD CONSTRAINT `fk_returns_rtv_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rtv_line` ADD CONSTRAINT `fk_returns_rtv_line_rtv_sku_id` FOREIGN KEY (`rtv_sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`restock_event` ADD CONSTRAINT `fk_returns_restock_event_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`liquidation_item` ADD CONSTRAINT `fk_returns_liquidation_item_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= returns --> promotion (2 constraint(s)) =========
-- Requires: returns schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_promo_redemption_id` FOREIGN KEY (`promo_redemption_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_redemption`(`promo_redemption_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_fraud_case` ADD CONSTRAINT `fk_returns_return_fraud_case_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);

-- ========= returns --> service (1 constraint(s)) =========
-- Requires: returns schema, service schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_service_case_id` FOREIGN KEY (`service_case_id`) REFERENCES `vibe_retail_v1`.`service`.`service_case`(`service_case_id`);

-- ========= returns --> store (11 constraint(s)) =========
-- Requires: returns schema, store schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rtv_line` ADD CONSTRAINT `fk_returns_rtv_line_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`restock_event` ADD CONSTRAINT `fk_returns_restock_event_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_shipment` ADD CONSTRAINT `fk_returns_return_shipment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_shipment` ADD CONSTRAINT `fk_returns_return_shipment_origin_location_id` FOREIGN KEY (`origin_location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_fraud_case` ADD CONSTRAINT `fk_returns_return_fraud_case_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= returns --> supplier (11 constraint(s)) =========
-- Requires: returns schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_disposition_vendor_id` FOREIGN KEY (`disposition_vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_rtv_request_id` FOREIGN KEY (`rtv_request_id`) REFERENCES `vibe_retail_v1`.`supplier`.`rtv_request`(`rtv_request_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rtv_line` ADD CONSTRAINT `fk_returns_rtv_line_rtv_request_id` FOREIGN KEY (`rtv_request_id`) REFERENCES `vibe_retail_v1`.`supplier`.`rtv_request`(`rtv_request_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rtv_line` ADD CONSTRAINT `fk_returns_rtv_line_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`liquidation_batch` ADD CONSTRAINT `fk_returns_liquidation_batch_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`liquidation_item` ADD CONSTRAINT `fk_returns_liquidation_item_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`liquidation_item` ADD CONSTRAINT `fk_returns_liquidation_item_primary_liquidation_partner_vendor_id` FOREIGN KEY (`primary_liquidation_partner_vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`vendor_credit` ADD CONSTRAINT `fk_returns_vendor_credit_rtv_request_id` FOREIGN KEY (`rtv_request_id`) REFERENCES `vibe_retail_v1`.`supplier`.`rtv_request`(`rtv_request_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`vendor_credit` ADD CONSTRAINT `fk_returns_vendor_credit_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= returns --> supplychain (6 constraint(s)) =========
-- Requires: returns schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rtv_line` ADD CONSTRAINT `fk_returns_rtv_line_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`restock_event` ADD CONSTRAINT `fk_returns_restock_event_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`liquidation_batch` ADD CONSTRAINT `fk_returns_liquidation_batch_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= returns --> workforce (14 constraint(s)) =========
-- Requires: returns schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_receiving_associate_id` FOREIGN KEY (`receiving_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`restock_event` ADD CONSTRAINT `fk_returns_restock_event_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`liquidation_batch` ADD CONSTRAINT `fk_returns_liquidation_batch_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`vendor_credit` ADD CONSTRAINT `fk_returns_vendor_credit_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`vendor_credit` ADD CONSTRAINT `fk_returns_vendor_credit_tertiary_vendor_created_by_user_associate_id` FOREIGN KEY (`tertiary_vendor_created_by_user_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_fraud_case` ADD CONSTRAINT `fk_returns_return_fraud_case_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= service --> compliance (1 constraint(s)) =========
-- Requires: service schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ADD CONSTRAINT `fk_service_service_case_violation_notice_id` FOREIGN KEY (`violation_notice_id`) REFERENCES `vibe_retail_v1`.`compliance`.`violation_notice`(`violation_notice_id`);

-- ========= service --> customer (1 constraint(s)) =========
-- Requires: service schema, customer schema
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ADD CONSTRAINT `fk_service_service_case_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= service --> finance (1 constraint(s)) =========
-- Requires: service schema, finance schema
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ADD CONSTRAINT `fk_service_service_case_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);

-- ========= service --> fulfillment (1 constraint(s)) =========
-- Requires: service schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ADD CONSTRAINT `fk_service_service_case_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);

-- ========= service --> loyalty (1 constraint(s)) =========
-- Requires: service schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ADD CONSTRAINT `fk_service_service_case_redemption_id` FOREIGN KEY (`redemption_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`redemption`(`redemption_id`);

-- ========= service --> merchandising (1 constraint(s)) =========
-- Requires: service schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ADD CONSTRAINT `fk_service_service_case_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);

-- ========= service --> order (1 constraint(s)) =========
-- Requires: service schema, order schema
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ADD CONSTRAINT `fk_service_service_case_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);

-- ========= service --> product (1 constraint(s)) =========
-- Requires: service schema, product schema
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ADD CONSTRAINT `fk_service_service_case_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= service --> store (1 constraint(s)) =========
-- Requires: service schema, store schema
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ADD CONSTRAINT `fk_service_service_case_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= service --> supplier (1 constraint(s)) =========
-- Requires: service schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ADD CONSTRAINT `fk_service_service_case_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= service --> workforce (1 constraint(s)) =========
-- Requires: service schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`service`.`service_case` ADD CONSTRAINT `fk_service_service_case_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= store --> analytics (3 constraint(s)) =========
-- Requires: store schema, analytics schema
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ADD CONSTRAINT `fk_store_comparable_sales_kpi_value_id` FOREIGN KEY (`kpi_value_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_value`(`kpi_value_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_dq_issue_id` FOREIGN KEY (`dq_issue_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dq_issue`(`dq_issue_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ADD CONSTRAINT `fk_store_cluster_reporting_hierarchy_id` FOREIGN KEY (`reporting_hierarchy_id`) REFERENCES `vibe_retail_v1`.`analytics`.`reporting_hierarchy`(`reporting_hierarchy_id`);

-- ========= store --> compliance (1 constraint(s)) =========
-- Requires: store schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`store`.`license` ADD CONSTRAINT `fk_store_license_license_permit_id` FOREIGN KEY (`license_permit_id`) REFERENCES `vibe_retail_v1`.`compliance`.`license_permit`(`license_permit_id`);

-- ========= store --> finance (10 constraint(s)) =========
-- Requires: store schema, finance schema
ALTER TABLE `vibe_retail_v1`.`store`.`location` ADD CONSTRAINT `fk_store_location_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `vibe_retail_v1`.`finance`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ADD CONSTRAINT `fk_store_fixture_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_retail_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ADD CONSTRAINT `fk_store_comparable_sales_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ADD CONSTRAINT `fk_store_remodel_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ADD CONSTRAINT `fk_store_remodel_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_retail_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ADD CONSTRAINT `fk_store_audit_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`license` ADD CONSTRAINT `fk_store_license_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ADD CONSTRAINT `fk_store_store_profit_loss_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ADD CONSTRAINT `fk_store_direct_store_delivery_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `vibe_retail_v1`.`finance`.`ap_invoice`(`ap_invoice_id`);

-- ========= store --> fulfillment (2 constraint(s)) =========
-- Requires: store schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`store`.`location` ADD CONSTRAINT `fk_store_location_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`carrier_agreement` ADD CONSTRAINT `fk_store_carrier_agreement_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);

-- ========= store --> inventory (3 constraint(s)) =========
-- Requires: store schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_adjustment_id` FOREIGN KEY (`adjustment_id`) REFERENCES `vibe_retail_v1`.`inventory`.`adjustment`(`adjustment_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ADD CONSTRAINT `fk_store_direct_store_delivery_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);

-- ========= store --> loyalty (1 constraint(s)) =========
-- Requires: store schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ADD CONSTRAINT `fk_store_cluster_loyalty_program_id` FOREIGN KEY (`loyalty_program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`loyalty_program`(`loyalty_program_id`);

-- ========= store --> marketing (7 constraint(s)) =========
-- Requires: store schema, marketing schema
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ADD CONSTRAINT `fk_store_fixture_creative_asset_id` FOREIGN KEY (`creative_asset_id`) REFERENCES `vibe_retail_v1`.`marketing`.`creative_asset`(`creative_asset_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ADD CONSTRAINT `fk_store_traffic_count_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ADD CONSTRAINT `fk_store_comparable_sales_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_marketing_brand_id` FOREIGN KEY (`marketing_brand_id`) REFERENCES `vibe_retail_v1`.`marketing`.`marketing_brand`(`marketing_brand_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ADD CONSTRAINT `fk_store_remodel_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ADD CONSTRAINT `fk_store_audit_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);

-- ========= store --> merchandising (4 constraint(s)) =========
-- Requires: store schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ADD CONSTRAINT `fk_store_fixture_merchandising_planogram_id` FOREIGN KEY (`merchandising_planogram_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`merchandising_planogram`(`merchandising_planogram_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ADD CONSTRAINT `fk_store_remodel_merchandising_planogram_id` FOREIGN KEY (`merchandising_planogram_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`merchandising_planogram`(`merchandising_planogram_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ADD CONSTRAINT `fk_store_audit_merchandising_planogram_id` FOREIGN KEY (`merchandising_planogram_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`merchandising_planogram`(`merchandising_planogram_id`);

-- ========= store --> pricing (1 constraint(s)) =========
-- Requires: store schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`store`.`location` ADD CONSTRAINT `fk_store_location_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);

-- ========= store --> product (4 constraint(s)) =========
-- Requires: store schema, product schema
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ADD CONSTRAINT `fk_store_store_planogram_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ADD CONSTRAINT `fk_store_store_planogram_product_brand_id` FOREIGN KEY (`product_brand_id`) REFERENCES `vibe_retail_v1`.`product`.`product_brand`(`product_brand_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ADD CONSTRAINT `fk_store_direct_store_delivery_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= store --> promotion (13 constraint(s)) =========
-- Requires: store schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`store`.`store_planogram` ADD CONSTRAINT `fk_store_store_planogram_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ADD CONSTRAINT `fk_store_fixture_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ADD CONSTRAINT `fk_store_traffic_count_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`comparable_sales` ADD CONSTRAINT `fk_store_comparable_sales_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ADD CONSTRAINT `fk_store_remodel_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ADD CONSTRAINT `fk_store_cluster_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ADD CONSTRAINT `fk_store_audit_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`license` ADD CONSTRAINT `fk_store_license_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ADD CONSTRAINT `fk_store_format_offer_eligibility_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`store_profit_loss` ADD CONSTRAINT `fk_store_store_profit_loss_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ADD CONSTRAINT `fk_store_direct_store_delivery_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);

-- ========= store --> returns (3 constraint(s)) =========
-- Requires: store schema, returns schema
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_rma_id` FOREIGN KEY (`rma_id`) REFERENCES `vibe_retail_v1`.`returns`.`rma`(`rma_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ADD CONSTRAINT `fk_store_audit_return_fraud_case_id` FOREIGN KEY (`return_fraud_case_id`) REFERENCES `vibe_retail_v1`.`returns`.`return_fraud_case`(`return_fraud_case_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ADD CONSTRAINT `fk_store_audit_rma_id` FOREIGN KEY (`rma_id`) REFERENCES `vibe_retail_v1`.`returns`.`rma`(`rma_id`);

-- ========= store --> supplier (5 constraint(s)) =========
-- Requires: store schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ADD CONSTRAINT `fk_store_pos_terminal_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`fixture` ADD CONSTRAINT `fk_store_fixture_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`remodel` ADD CONSTRAINT `fk_store_remodel_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ADD CONSTRAINT `fk_store_direct_store_delivery_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= store --> supplychain (3 constraint(s)) =========
-- Requires: store schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ADD CONSTRAINT `fk_store_direct_store_delivery_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ADD CONSTRAINT `fk_store_direct_store_delivery_inbound_appointment_id` FOREIGN KEY (`inbound_appointment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_appointment`(`inbound_appointment_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ADD CONSTRAINT `fk_store_direct_store_delivery_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);

-- ========= store --> workforce (9 constraint(s)) =========
-- Requires: store schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`audit` ADD CONSTRAINT `fk_store_audit_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`license` ADD CONSTRAINT `fk_store_license_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`format_offer_eligibility` ADD CONSTRAINT `fk_store_format_offer_eligibility_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ADD CONSTRAINT `fk_store_sales_territory_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`direct_store_delivery` ADD CONSTRAINT `fk_store_direct_store_delivery_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`region` ADD CONSTRAINT `fk_store_region_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`region` ADD CONSTRAINT `fk_store_region_ops_vp_employee_associate_id` FOREIGN KEY (`ops_vp_employee_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= supplier --> analytics (8 constraint(s)) =========
-- Requires: supplier schema, analytics schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_kpi_value_id` FOREIGN KEY (`kpi_value_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_value`(`kpi_value_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`supplier_edi_transaction` ADD CONSTRAINT `fk_supplier_supplier_edi_transaction_dq_result_id` FOREIGN KEY (`dq_result_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dq_result`(`dq_result_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ADD CONSTRAINT `fk_supplier_lead_time_agreement_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ADD CONSTRAINT `fk_supplier_vmi_config_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_kpi_value_id` FOREIGN KEY (`kpi_value_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_value`(`kpi_value_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ADD CONSTRAINT `fk_supplier_risk_assessment_kpi_value_id` FOREIGN KEY (`kpi_value_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_value`(`kpi_value_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ADD CONSTRAINT `fk_supplier_vendor_dispute_kpi_value_id` FOREIGN KEY (`kpi_value_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_value`(`kpi_value_id`);

-- ========= supplier --> compliance (9 constraint(s)) =========
-- Requires: supplier schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_environmental_event_id` FOREIGN KEY (`environmental_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`environmental_event`(`environmental_event_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_audit_event_id` FOREIGN KEY (`audit_event_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_event`(`audit_event_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ADD CONSTRAINT `fk_supplier_vendor_certification_certification_id` FOREIGN KEY (`certification_id`) REFERENCES `vibe_retail_v1`.`compliance`.`certification`(`certification_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ADD CONSTRAINT `fk_supplier_vendor_certification_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ADD CONSTRAINT `fk_supplier_onboarding_request_third_party_assessment_id` FOREIGN KEY (`third_party_assessment_id`) REFERENCES `vibe_retail_v1`.`compliance`.`third_party_assessment`(`third_party_assessment_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ADD CONSTRAINT `fk_supplier_risk_assessment_risk_register_id` FOREIGN KEY (`risk_register_id`) REFERENCES `vibe_retail_v1`.`compliance`.`risk_register`(`risk_register_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_program_enrollment` ADD CONSTRAINT `fk_supplier_vendor_program_enrollment_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_program_enrollment` ADD CONSTRAINT `fk_supplier_vendor_program_enrollment_vendor_program_compliance_program_id` FOREIGN KEY (`vendor_program_compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_training_requirement` ADD CONSTRAINT `fk_supplier_vendor_training_requirement_training_program_id` FOREIGN KEY (`training_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`training_program`(`training_program_id`);

-- ========= supplier --> finance (6 constraint(s)) =========
-- Requires: supplier schema, finance schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `vibe_retail_v1`.`finance`.`ap_invoice`(`ap_invoice_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ADD CONSTRAINT `fk_supplier_vendor_dispute_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ADD CONSTRAINT `fk_supplier_vendor_dispute_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);

-- ========= supplier --> inventory (8 constraint(s)) =========
-- Requires: supplier schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_asn_id` FOREIGN KEY (`asn_id`) REFERENCES `vibe_retail_v1`.`inventory`.`asn`(`asn_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_retail_v1`.`inventory`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_retail_v1`.`inventory`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ADD CONSTRAINT `fk_supplier_lead_time_agreement_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ADD CONSTRAINT `fk_supplier_vmi_config_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ADD CONSTRAINT `fk_supplier_vmi_config_reorder_policy_id` FOREIGN KEY (`reorder_policy_id`) REFERENCES `vibe_retail_v1`.`inventory`.`reorder_policy`(`reorder_policy_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ADD CONSTRAINT `fk_supplier_vmi_config_vmi_agreement_id` FOREIGN KEY (`vmi_agreement_id`) REFERENCES `vibe_retail_v1`.`inventory`.`vmi_agreement`(`vmi_agreement_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ADD CONSTRAINT `fk_supplier_vendor_dispute_adjustment_id` FOREIGN KEY (`adjustment_id`) REFERENCES `vibe_retail_v1`.`inventory`.`adjustment`(`adjustment_id`);

-- ========= supplier --> marketing (1 constraint(s)) =========
-- Requires: supplier schema, marketing schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_retail_v1`.`marketing`.`campaign`(`campaign_id`);

-- ========= supplier --> merchandising (12 constraint(s)) =========
-- Requires: supplier schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ADD CONSTRAINT `fk_supplier_vendor_contract_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_buying_order_id` FOREIGN KEY (`buying_order_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order`(`buying_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_buying_order_id` FOREIGN KEY (`buying_order_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order`(`buying_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ADD CONSTRAINT `fk_supplier_vendor_certification_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ADD CONSTRAINT `fk_supplier_lead_time_agreement_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ADD CONSTRAINT `fk_supplier_vmi_config_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ADD CONSTRAINT `fk_supplier_onboarding_request_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ADD CONSTRAINT `fk_supplier_risk_assessment_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ADD CONSTRAINT `fk_supplier_vendor_dispute_buying_order_id` FOREIGN KEY (`buying_order_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order`(`buying_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_category_sourcing` ADD CONSTRAINT `fk_supplier_vendor_category_sourcing_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);

-- ========= supplier --> product (5 constraint(s)) =========
-- Requires: supplier schema, product schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vmi_config` ADD CONSTRAINT `fk_supplier_vmi_config_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ADD CONSTRAINT `fk_supplier_vendor_item_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= supplier --> promotion (2 constraint(s)) =========
-- Requires: supplier schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= supplier --> returns (2 constraint(s)) =========
-- Requires: supplier schema, returns schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_rma_id` FOREIGN KEY (`rma_id`) REFERENCES `vibe_retail_v1`.`returns`.`rma`(`rma_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_rma_id` FOREIGN KEY (`rma_id`) REFERENCES `vibe_retail_v1`.`returns`.`rma`(`rma_id`);

-- ========= supplier --> store (3 constraint(s)) =========
-- Requires: supplier schema, store schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_origin_location_id` FOREIGN KEY (`origin_location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= supplier --> supplychain (12 constraint(s)) =========
-- Requires: supplier schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ADD CONSTRAINT `fk_supplier_vendor_contract_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_certification` ADD CONSTRAINT `fk_supplier_vendor_certification_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ADD CONSTRAINT `fk_supplier_lead_time_agreement_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ADD CONSTRAINT `fk_supplier_vendor_item_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ADD CONSTRAINT `fk_supplier_vendor_dispute_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ADD CONSTRAINT `fk_supplier_routing_guide_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`supply_lane` ADD CONSTRAINT `fk_supplier_supply_lane_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= supplier --> workforce (7 constraint(s)) =========
-- Requires: supplier schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ADD CONSTRAINT `fk_supplier_vendor_contract_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`onboarding_request` ADD CONSTRAINT `fk_supplier_onboarding_request_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`risk_assessment` ADD CONSTRAINT `fk_supplier_risk_assessment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_dispute` ADD CONSTRAINT `fk_supplier_vendor_dispute_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`routing_guide` ADD CONSTRAINT `fk_supplier_routing_guide_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= supplychain --> compliance (4 constraint(s)) =========
-- Requires: supplychain schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`sla_performance` ADD CONSTRAINT `fk_supplychain_sla_performance_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_food_safety_log_id` FOREIGN KEY (`food_safety_log_id`) REFERENCES `vibe_retail_v1`.`compliance`.`food_safety_log`(`food_safety_log_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`quality_hold` ADD CONSTRAINT `fk_supplychain_quality_hold_audit_finding_id` FOREIGN KEY (`audit_finding_id`) REFERENCES `vibe_retail_v1`.`compliance`.`audit_finding`(`audit_finding_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`quality_hold` ADD CONSTRAINT `fk_supplychain_quality_hold_corrective_action_id` FOREIGN KEY (`corrective_action_id`) REFERENCES `vibe_retail_v1`.`compliance`.`corrective_action`(`corrective_action_id`);

-- ========= supplychain --> finance (1 constraint(s)) =========
-- Requires: supplychain schema, finance schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);

-- ========= supplychain --> fulfillment (16 constraint(s)) =========
-- Requires: supplychain schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_appointment` ADD CONSTRAINT `fk_supplychain_inbound_appointment_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`cross_dock_plan` ADD CONSTRAINT `fk_supplychain_cross_dock_plan_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`supplychain_edi_transaction` ADD CONSTRAINT `fk_supplychain_supplychain_edi_transaction_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ADD CONSTRAINT `fk_supplychain_inbound_shipment_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_task` ADD CONSTRAINT `fk_supplychain_warehouse_task_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ADD CONSTRAINT `fk_supplychain_wave_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_shipment` ADD CONSTRAINT `fk_supplychain_outbound_shipment_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`crossdock_transaction` ADD CONSTRAINT `fk_supplychain_crossdock_transaction_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inventory_transfer` ADD CONSTRAINT `fk_supplychain_inventory_transfer_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inventory_transfer` ADD CONSTRAINT `fk_supplychain_inventory_transfer_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dock_appointment` ADD CONSTRAINT `fk_supplychain_dock_appointment_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`handling_unit` ADD CONSTRAINT `fk_supplychain_handling_unit_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`handling_unit` ADD CONSTRAINT `fk_supplychain_handling_unit_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);

-- ========= supplychain --> inventory (5 constraint(s)) =========
-- Requires: supplychain schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`cross_dock_plan` ADD CONSTRAINT `fk_supplychain_cross_dock_plan_asn_id` FOREIGN KEY (`asn_id`) REFERENCES `vibe_retail_v1`.`inventory`.`asn`(`asn_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ADD CONSTRAINT `fk_supplychain_warehouse_zone_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_task` ADD CONSTRAINT `fk_supplychain_warehouse_task_asn_id` FOREIGN KEY (`asn_id`) REFERENCES `vibe_retail_v1`.`inventory`.`asn`(`asn_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inventory_transfer` ADD CONSTRAINT `fk_supplychain_inventory_transfer_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);

-- ========= supplychain --> merchandising (6 constraint(s)) =========
-- Requires: supplychain schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ADD CONSTRAINT `fk_supplychain_purchase_order_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`cross_dock_plan` ADD CONSTRAINT `fk_supplychain_cross_dock_plan_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ADD CONSTRAINT `fk_supplychain_wave_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);

-- ========= supplychain --> order (1 constraint(s)) =========
-- Requires: supplychain schema, order schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_task` ADD CONSTRAINT `fk_supplychain_warehouse_task_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);

-- ========= supplychain --> product (11 constraint(s)) =========
-- Requires: supplychain schema, product schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`plan` ADD CONSTRAINT `fk_supplychain_plan_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`cross_dock_plan` ADD CONSTRAINT `fk_supplychain_cross_dock_plan_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`supplychain_edi_transaction` ADD CONSTRAINT `fk_supplychain_supplychain_edi_transaction_item_cross_reference_id` FOREIGN KEY (`item_cross_reference_id`) REFERENCES `vibe_retail_v1`.`product`.`item_cross_reference`(`item_cross_reference_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_task` ADD CONSTRAINT `fk_supplychain_warehouse_task_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`crossdock_transaction` ADD CONSTRAINT `fk_supplychain_crossdock_transaction_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inventory_transfer` ADD CONSTRAINT `fk_supplychain_inventory_transfer_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`quality_hold` ADD CONSTRAINT `fk_supplychain_quality_hold_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= supplychain --> promotion (4 constraint(s)) =========
-- Requires: supplychain schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`plan` ADD CONSTRAINT `fk_supplychain_plan_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`cross_dock_plan` ADD CONSTRAINT `fk_supplychain_cross_dock_plan_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`crossdock_transaction` ADD CONSTRAINT `fk_supplychain_crossdock_transaction_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);

-- ========= supplychain --> store (8 constraint(s)) =========
-- Requires: supplychain schema, store schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`cross_dock_plan` ADD CONSTRAINT `fk_supplychain_cross_dock_plan_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ADD CONSTRAINT `fk_supplychain_dc_facility_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_task` ADD CONSTRAINT `fk_supplychain_warehouse_task_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_source_location_id` FOREIGN KEY (`source_location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`crossdock_transaction` ADD CONSTRAINT `fk_supplychain_crossdock_transaction_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= supplychain --> supplier (16 constraint(s)) =========
-- Requires: supplychain schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ADD CONSTRAINT `fk_supplychain_purchase_order_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`plan` ADD CONSTRAINT `fk_supplychain_plan_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`sla_definition` ADD CONSTRAINT `fk_supplychain_sla_definition_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`sla_performance` ADD CONSTRAINT `fk_supplychain_sla_performance_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_appointment` ADD CONSTRAINT `fk_supplychain_inbound_appointment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`cross_dock_plan` ADD CONSTRAINT `fk_supplychain_cross_dock_plan_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`supplychain_edi_transaction` ADD CONSTRAINT `fk_supplychain_supplychain_edi_transaction_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`supplychain_edi_transaction` ADD CONSTRAINT `fk_supplychain_supplychain_edi_transaction_supplychain_vendor_id` FOREIGN KEY (`supplychain_vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ADD CONSTRAINT `fk_supplychain_inbound_shipment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`crossdock_transaction` ADD CONSTRAINT `fk_supplychain_crossdock_transaction_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dock_appointment` ADD CONSTRAINT `fk_supplychain_dock_appointment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`handling_unit` ADD CONSTRAINT `fk_supplychain_handling_unit_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`quality_hold` ADD CONSTRAINT `fk_supplychain_quality_hold_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= supplychain --> workforce (14 constraint(s)) =========
-- Requires: supplychain schema, workforce schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ADD CONSTRAINT `fk_supplychain_purchase_order_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_appointment` ADD CONSTRAINT `fk_supplychain_inbound_appointment_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`cross_dock_plan` ADD CONSTRAINT `fk_supplychain_cross_dock_plan_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ADD CONSTRAINT `fk_supplychain_warehouse_zone_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_receiving_supervisor_employee_associate_id` FOREIGN KEY (`receiving_supervisor_employee_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_task` ADD CONSTRAINT `fk_supplychain_warehouse_task_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ADD CONSTRAINT `fk_supplychain_wave_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`quality_hold` ADD CONSTRAINT `fk_supplychain_quality_hold_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`quality_hold` ADD CONSTRAINT `fk_supplychain_quality_hold_primary_quality_associate_id` FOREIGN KEY (`primary_quality_associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_shipment_receipt` ADD CONSTRAINT `fk_supplychain_po_shipment_receipt_associate_id` FOREIGN KEY (`associate_id`) REFERENCES `vibe_retail_v1`.`workforce`.`associate`(`associate_id`);

-- ========= workforce --> analytics (7 constraint(s)) =========
-- Requires: workforce schema, analytics schema
ALTER TABLE `vibe_retail_v1`.`workforce`.`performance_review` ADD CONSTRAINT `fk_workforce_performance_review_kpi_value_id` FOREIGN KEY (`kpi_value_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_value`(`kpi_value_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ADD CONSTRAINT `fk_workforce_training_enrollment_kpi_value_id` FOREIGN KEY (`kpi_value_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_value`(`kpi_value_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ADD CONSTRAINT `fk_workforce_requisition_kpi_value_id` FOREIGN KEY (`kpi_value_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_value`(`kpi_value_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ADD CONSTRAINT `fk_workforce_org_unit_semantic_layer_entity_id` FOREIGN KEY (`semantic_layer_entity_id`) REFERENCES `vibe_retail_v1`.`analytics`.`semantic_layer_entity`(`semantic_layer_entity_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`dashboard_access` ADD CONSTRAINT `fk_workforce_dashboard_access_dashboard_config_id` FOREIGN KEY (`dashboard_config_id`) REFERENCES `vibe_retail_v1`.`analytics`.`dashboard_config`(`dashboard_config_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ADD CONSTRAINT `fk_workforce_workforce_kpi_target_analytics_kpi_target_id` FOREIGN KEY (`analytics_kpi_target_id`) REFERENCES `vibe_retail_v1`.`analytics`.`analytics_kpi_target`(`analytics_kpi_target_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`workforce_kpi_target` ADD CONSTRAINT `fk_workforce_workforce_kpi_target_kpi_definition_id` FOREIGN KEY (`kpi_definition_id`) REFERENCES `vibe_retail_v1`.`analytics`.`kpi_definition`(`kpi_definition_id`);

-- ========= workforce --> compliance (5 constraint(s)) =========
-- Requires: workforce schema, compliance schema
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ADD CONSTRAINT `fk_workforce_training_enrollment_certification_id` FOREIGN KEY (`certification_id`) REFERENCES `vibe_retail_v1`.`compliance`.`certification`(`certification_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`training_enrollment` ADD CONSTRAINT `fk_workforce_training_enrollment_training_program_id` FOREIGN KEY (`training_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`training_program`(`training_program_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ADD CONSTRAINT `fk_workforce_wf_certification_training_program_id` FOREIGN KEY (`training_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`training_program`(`training_program_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` ADD CONSTRAINT `fk_workforce_org_unit_compliance_scope_compliance_program_id` FOREIGN KEY (`compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit_compliance_scope` ADD CONSTRAINT `fk_workforce_org_unit_compliance_scope_org_program_compliance_program_id` FOREIGN KEY (`org_program_compliance_program_id`) REFERENCES `vibe_retail_v1`.`compliance`.`compliance_program`(`compliance_program_id`);

-- ========= workforce --> finance (16 constraint(s)) =========
-- Requires: workforce schema, finance schema
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ADD CONSTRAINT `fk_workforce_payroll_record_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_record` ADD CONSTRAINT `fk_workforce_payroll_record_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`benefit_enrollment` ADD CONSTRAINT `fk_workforce_benefit_enrollment_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ADD CONSTRAINT `fk_workforce_requisition_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ADD CONSTRAINT `fk_workforce_requisition_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ADD CONSTRAINT `fk_workforce_labor_budget_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ADD CONSTRAINT `fk_workforce_labor_budget_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ADD CONSTRAINT `fk_workforce_labor_budget_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ADD CONSTRAINT `fk_workforce_labor_budget_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ADD CONSTRAINT `fk_workforce_compensation_change_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_retail_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ADD CONSTRAINT `fk_workforce_compensation_change_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_retail_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ADD CONSTRAINT `fk_workforce_staffing_plan_financial_period_id` FOREIGN KEY (`financial_period_id`) REFERENCES `vibe_retail_v1`.`finance`.`financial_period`(`financial_period_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`payroll_calendar` ADD CONSTRAINT `fk_workforce_payroll_calendar_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `vibe_retail_v1`.`finance`.`legal_entity`(`legal_entity_id`);

-- ========= workforce --> store (16 constraint(s)) =========
-- Requires: workforce schema, store schema
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ADD CONSTRAINT `fk_workforce_associate_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ADD CONSTRAINT `fk_workforce_requisition_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`job_application` ADD CONSTRAINT `fk_workforce_job_application_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ADD CONSTRAINT `fk_workforce_labor_budget_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ADD CONSTRAINT `fk_workforce_compensation_change_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`org_unit` ADD CONSTRAINT `fk_workforce_org_unit_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ADD CONSTRAINT `fk_workforce_wf_certification_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ADD CONSTRAINT `fk_workforce_staffing_plan_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_swap_request` ADD CONSTRAINT `fk_workforce_shift_swap_request_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_swap_request` ADD CONSTRAINT `fk_workforce_shift_swap_request_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`coverage_request` ADD CONSTRAINT `fk_workforce_coverage_request_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`coverage_request` ADD CONSTRAINT `fk_workforce_coverage_request_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= workforce --> supplychain (9 constraint(s)) =========
-- Requires: workforce schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`workforce`.`associate` ADD CONSTRAINT `fk_workforce_associate_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`leave_request` ADD CONSTRAINT `fk_workforce_leave_request_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`requisition` ADD CONSTRAINT `fk_workforce_requisition_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`labor_budget` ADD CONSTRAINT `fk_workforce_labor_budget_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`compensation_change` ADD CONSTRAINT `fk_workforce_compensation_change_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`wf_certification` ADD CONSTRAINT `fk_workforce_wf_certification_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`workforce`.`staffing_plan` ADD CONSTRAINT `fk_workforce_staffing_plan_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

