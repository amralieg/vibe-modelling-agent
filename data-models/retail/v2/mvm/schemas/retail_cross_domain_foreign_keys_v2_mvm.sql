-- Cross-Domain Foreign Keys for Business: Retail | Version: v2_mvm
-- Generated on: 2026-07-12 10:43:59
-- Total cross-domain FK constraints: 554
--
-- EXECUTION ORDER:
--   1. Run ALL domain schema files first (any order).
--   2. Run this file LAST.
--
-- PREREQUISITE DOMAINS: customer, ecommerce, fulfillment, inventory, loyalty, order, pricing, product, promotion, returns, store, supplychain

-- ========= customer --> pricing (3 constraint(s)) =========
-- Requires: customer schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`address` ADD CONSTRAINT `fk_customer_address_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);

-- ========= customer --> store (4 constraint(s)) =========
-- Requires: customer schema, store schema
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ADD CONSTRAINT `fk_customer_profile_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ADD CONSTRAINT `fk_customer_profile_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `vibe_retail_v1`.`store`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `vibe_retail_v1`.`store`.`sales_territory`(`sales_territory_id`);

-- ========= customer --> supplychain (1 constraint(s)) =========
-- Requires: customer schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= ecommerce --> customer (11 constraint(s)) =========
-- Requires: ecommerce schema, customer schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`search_query` ADD CONSTRAINT `fk_ecommerce_search_query_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= ecommerce --> fulfillment (1 constraint(s)) =========
-- Requires: ecommerce schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);

-- ========= ecommerce --> inventory (3 constraint(s)) =========
-- Requires: ecommerce schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);

-- ========= ecommerce --> loyalty (5 constraint(s)) =========
-- Requires: ecommerce schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);

-- ========= ecommerce --> order (4 constraint(s)) =========
-- Requires: ecommerce schema, order schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);

-- ========= ecommerce --> pricing (8 constraint(s)) =========
-- Requires: ecommerce schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);

-- ========= ecommerce --> product (3 constraint(s)) =========
-- Requires: ecommerce schema, product schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= ecommerce --> promotion (13 constraint(s)) =========
-- Requires: ecommerce schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `vibe_retail_v1`.`promotion`.`coupon`(`coupon_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `vibe_retail_v1`.`promotion`.`coupon`(`coupon_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `vibe_retail_v1`.`promotion`.`coupon`(`coupon_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_rebate_id` FOREIGN KEY (`rebate_id`) REFERENCES `vibe_retail_v1`.`promotion`.`rebate`(`rebate_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`search_query` ADD CONSTRAINT `fk_ecommerce_search_query_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);

-- ========= ecommerce --> returns (4 constraint(s)) =========
-- Requires: ecommerce schema, returns schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_return_policy_id` FOREIGN KEY (`return_policy_id`) REFERENCES `vibe_retail_v1`.`returns`.`return_policy`(`return_policy_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_return_policy_id` FOREIGN KEY (`return_policy_id`) REFERENCES `vibe_retail_v1`.`returns`.`return_policy`(`return_policy_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_return_request_id` FOREIGN KEY (`return_request_id`) REFERENCES `vibe_retail_v1`.`returns`.`return_request`(`return_request_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_return_policy_id` FOREIGN KEY (`return_policy_id`) REFERENCES `vibe_retail_v1`.`returns`.`return_policy`(`return_policy_id`);

-- ========= ecommerce --> store (7 constraint(s)) =========
-- Requires: ecommerce schema, store schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= ecommerce --> supplychain (1 constraint(s)) =========
-- Requires: ecommerce schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= fulfillment --> customer (4 constraint(s)) =========
-- Requires: fulfillment schema, customer schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= fulfillment --> inventory (1 constraint(s)) =========
-- Requires: fulfillment schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);

-- ========= fulfillment --> loyalty (2 constraint(s)) =========
-- Requires: fulfillment schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);

-- ========= fulfillment --> order (7 constraint(s)) =========
-- Requires: fulfillment schema, order schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ADD CONSTRAINT `fk_fulfillment_shipment_package_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ADD CONSTRAINT `fk_fulfillment_pack_task_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);

-- ========= fulfillment --> pricing (2 constraint(s)) =========
-- Requires: fulfillment schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ADD CONSTRAINT `fk_fulfillment_fulfillment_node_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);

-- ========= fulfillment --> product (2 constraint(s)) =========
-- Requires: fulfillment schema, product schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= fulfillment --> store (8 constraint(s)) =========
-- Requires: fulfillment schema, store schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ADD CONSTRAINT `fk_fulfillment_pack_task_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ADD CONSTRAINT `fk_fulfillment_fulfillment_node_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= fulfillment --> supplychain (12 constraint(s)) =========
-- Requires: fulfillment schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_outbound_order_line_id` FOREIGN KEY (`outbound_order_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order_line`(`outbound_order_line_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ADD CONSTRAINT `fk_fulfillment_shipment_package_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_warehouse_zone_id` FOREIGN KEY (`warehouse_zone_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`warehouse_zone`(`warehouse_zone_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ADD CONSTRAINT `fk_fulfillment_pack_task_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ADD CONSTRAINT `fk_fulfillment_fulfillment_node_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= inventory --> customer (2 constraint(s)) =========
-- Requires: inventory schema, customer schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= inventory --> ecommerce (3 constraint(s)) =========
-- Requires: inventory schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`cart`(`cart_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_checkout_id` FOREIGN KEY (`checkout_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`checkout`(`checkout_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_digital_catalog_id` FOREIGN KEY (`digital_catalog_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`digital_catalog`(`digital_catalog_id`);

-- ========= inventory --> fulfillment (8 constraint(s)) =========
-- Requires: inventory schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_fulfillment_line_id` FOREIGN KEY (`fulfillment_line_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_line`(`fulfillment_line_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);

-- ========= inventory --> loyalty (2 constraint(s)) =========
-- Requires: inventory schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_redemption_id` FOREIGN KEY (`redemption_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`redemption`(`redemption_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_reward_id` FOREIGN KEY (`reward_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`reward`(`reward_id`);

-- ========= inventory --> order (4 constraint(s)) =========
-- Requires: inventory schema, order schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);

-- ========= inventory --> pricing (7 constraint(s)) =========
-- Requires: inventory schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`inventory_node` ADD CONSTRAINT `fk_inventory_inventory_node_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);

-- ========= inventory --> product (13 constraint(s)) =========
-- Requires: inventory schema, product schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_recall_id` FOREIGN KEY (`recall_id`) REFERENCES `vibe_retail_v1`.`product`.`recall`(`recall_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_recall_id` FOREIGN KEY (`recall_id`) REFERENCES `vibe_retail_v1`.`product`.`recall`(`recall_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);

-- ========= inventory --> promotion (3 constraint(s)) =========
-- Requires: inventory schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= inventory --> store (18 constraint(s)) =========
-- Requires: inventory schema, store schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`inventory_node` ADD CONSTRAINT `fk_inventory_inventory_node_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`inventory_node` ADD CONSTRAINT `fk_inventory_inventory_node_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`inventory_node` ADD CONSTRAINT `fk_inventory_inventory_node_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= inventory --> supplychain (21 constraint(s)) =========
-- Requires: inventory schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_warehouse_zone_id` FOREIGN KEY (`warehouse_zone_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`warehouse_zone`(`warehouse_zone_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`inventory_node` ADD CONSTRAINT `fk_inventory_inventory_node_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_warehouse_zone_id` FOREIGN KEY (`warehouse_zone_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`warehouse_zone`(`warehouse_zone_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_receiving_event_id` FOREIGN KEY (`receiving_event_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`receiving_event`(`receiving_event_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);

-- ========= loyalty --> customer (4 constraint(s)) =========
-- Requires: loyalty schema, customer schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ADD CONSTRAINT `fk_loyalty_membership_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ADD CONSTRAINT `fk_loyalty_membership_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= loyalty --> ecommerce (9 constraint(s)) =========
-- Requires: loyalty schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ADD CONSTRAINT `fk_loyalty_membership_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`cart`(`cart_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_checkout_id` FOREIGN KEY (`checkout_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`checkout`(`checkout_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_digital_catalog_id` FOREIGN KEY (`digital_catalog_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`digital_catalog`(`digital_catalog_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`cart`(`cart_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_checkout_id` FOREIGN KEY (`checkout_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`checkout`(`checkout_id`);

-- ========= loyalty --> fulfillment (1 constraint(s)) =========
-- Requires: loyalty schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= loyalty --> order (4 constraint(s)) =========
-- Requires: loyalty schema, order schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);

-- ========= loyalty --> pricing (4 constraint(s)) =========
-- Requires: loyalty schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_rule_id` FOREIGN KEY (`rule_id`) REFERENCES `vibe_retail_v1`.`pricing`.`rule`(`rule_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);

-- ========= loyalty --> product (9 constraint(s)) =========
-- Requires: loyalty schema, product schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= loyalty --> promotion (7 constraint(s)) =========
-- Requires: loyalty schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= loyalty --> returns (1 constraint(s)) =========
-- Requires: loyalty schema, returns schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_rma_id` FOREIGN KEY (`rma_id`) REFERENCES `vibe_retail_v1`.`returns`.`rma`(`rma_id`);

-- ========= loyalty --> store (12 constraint(s)) =========
-- Requires: loyalty schema, store schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`program` ADD CONSTRAINT `fk_loyalty_program_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`membership` ADD CONSTRAINT `fk_loyalty_membership_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`points_ledger` ADD CONSTRAINT `fk_loyalty_points_ledger_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption_rule` ADD CONSTRAINT `fk_loyalty_redemption_rule_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= loyalty --> supplychain (4 constraint(s)) =========
-- Requires: loyalty schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`loyalty`.`accrual_rule` ADD CONSTRAINT `fk_loyalty_accrual_rule_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`reward` ADD CONSTRAINT `fk_loyalty_reward_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`loyalty`.`redemption` ADD CONSTRAINT `fk_loyalty_redemption_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);

-- ========= order --> customer (13 constraint(s)) =========
-- Requires: order schema, customer schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `vibe_retail_v1`.`customer`.`contact`(`contact_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);

-- ========= order --> ecommerce (7 constraint(s)) =========
-- Requires: order schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_digital_catalog_id` FOREIGN KEY (`digital_catalog_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`digital_catalog`(`digital_catalog_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_checkout_id` FOREIGN KEY (`checkout_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`checkout`(`checkout_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_digital_catalog_id` FOREIGN KEY (`digital_catalog_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`digital_catalog`(`digital_catalog_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);

-- ========= order --> fulfillment (8 constraint(s)) =========
-- Requires: order schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_bopis_appointment_id` FOREIGN KEY (`bopis_appointment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`bopis_appointment`(`bopis_appointment_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= order --> inventory (2 constraint(s)) =========
-- Requires: order schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_reservation_id` FOREIGN KEY (`reservation_id`) REFERENCES `vibe_retail_v1`.`inventory`.`reservation`(`reservation_id`);

-- ========= order --> loyalty (16 constraint(s)) =========
-- Requires: order schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_accrual_rule_id` FOREIGN KEY (`accrual_rule_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`accrual_rule`(`accrual_rule_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_reward_id` FOREIGN KEY (`reward_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`reward`(`reward_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_accrual_rule_id` FOREIGN KEY (`accrual_rule_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`accrual_rule`(`accrual_rule_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_reward_id` FOREIGN KEY (`reward_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`reward`(`reward_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_redemption_id` FOREIGN KEY (`redemption_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`redemption`(`redemption_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_redemption_id` FOREIGN KEY (`redemption_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`redemption`(`redemption_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_redemption_id` FOREIGN KEY (`redemption_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`redemption`(`redemption_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_reward_id` FOREIGN KEY (`reward_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`reward`(`reward_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_redemption_id` FOREIGN KEY (`redemption_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`redemption`(`redemption_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_tier_id` FOREIGN KEY (`tier_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`tier`(`tier_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_reward_id` FOREIGN KEY (`reward_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`reward`(`reward_id`);

-- ========= order --> pricing (11 constraint(s)) =========
-- Requires: order schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_rule_id` FOREIGN KEY (`rule_id`) REFERENCES `vibe_retail_v1`.`pricing`.`rule`(`rule_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);

-- ========= order --> product (5 constraint(s)) =========
-- Requires: order schema, product schema
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);

-- ========= order --> promotion (10 constraint(s)) =========
-- Requires: order schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `vibe_retail_v1`.`promotion`.`coupon`(`coupon_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `vibe_retail_v1`.`promotion`.`coupon`(`coupon_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= order --> store (12 constraint(s)) =========
-- Requires: order schema, store schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= order --> supplychain (7 constraint(s)) =========
-- Requires: order schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= pricing --> inventory (1 constraint(s)) =========
-- Requires: pricing schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);

-- ========= pricing --> loyalty (2 constraint(s)) =========
-- Requires: pricing schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_list` ADD CONSTRAINT `fk_pricing_price_list_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_tier_id` FOREIGN KEY (`tier_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`tier`(`tier_id`);

-- ========= pricing --> product (6 constraint(s)) =========
-- Requires: pricing schema, product schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`sku_price` ADD CONSTRAINT `fk_pricing_sku_price_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`sku_price` ADD CONSTRAINT `fk_pricing_sku_price_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= pricing --> promotion (10 constraint(s)) =========
-- Requires: pricing schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`sku_price` ADD CONSTRAINT `fk_pricing_sku_price_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_promo_calendar_id` FOREIGN KEY (`promo_calendar_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_calendar`(`promo_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_promo_calendar_id` FOREIGN KEY (`promo_calendar_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_calendar`(`promo_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= pricing --> store (8 constraint(s)) =========
-- Requires: pricing schema, store schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_list` ADD CONSTRAINT `fk_pricing_price_list_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= pricing --> supplychain (7 constraint(s)) =========
-- Requires: pricing schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= product --> fulfillment (2 constraint(s)) =========
-- Requires: product schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ADD CONSTRAINT `fk_product_compliance_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ADD CONSTRAINT `fk_product_compliance_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);

-- ========= product --> store (1 constraint(s)) =========
-- Requires: product schema, store schema
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ADD CONSTRAINT `fk_product_recall_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= product --> supplychain (1 constraint(s)) =========
-- Requires: product schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`product`.`recall` ADD CONSTRAINT `fk_product_recall_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= promotion --> customer (4 constraint(s)) =========
-- Requires: promotion schema, customer schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= promotion --> ecommerce (3 constraint(s)) =========
-- Requires: promotion schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);

-- ========= promotion --> fulfillment (3 constraint(s)) =========
-- Requires: promotion schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_fulfillment_line_id` FOREIGN KEY (`fulfillment_line_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_line`(`fulfillment_line_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= promotion --> loyalty (10 constraint(s)) =========
-- Requires: promotion schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_tier_id` FOREIGN KEY (`tier_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`tier`(`tier_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_tier_id` FOREIGN KEY (`tier_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`tier`(`tier_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_tier_id` FOREIGN KEY (`tier_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`tier`(`tier_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_reward_id` FOREIGN KEY (`reward_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`reward`(`reward_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);

-- ========= promotion --> order (2 constraint(s)) =========
-- Requires: promotion schema, order schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);

-- ========= promotion --> pricing (5 constraint(s)) =========
-- Requires: promotion schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);

-- ========= promotion --> product (10 constraint(s)) =========
-- Requires: promotion schema, product schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ADD CONSTRAINT `fk_promotion_promo_calendar_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);

-- ========= promotion --> returns (1 constraint(s)) =========
-- Requires: promotion schema, returns schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_return_policy_id` FOREIGN KEY (`return_policy_id`) REFERENCES `vibe_retail_v1`.`returns`.`return_policy`(`return_policy_id`);

-- ========= promotion --> store (18 constraint(s)) =========
-- Requires: promotion schema, store schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`rebate` ADD CONSTRAINT `fk_promotion_rebate_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ADD CONSTRAINT `fk_promotion_promo_calendar_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);

-- ========= promotion --> supplychain (3 constraint(s)) =========
-- Requires: promotion schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);

-- ========= returns --> customer (8 constraint(s)) =========
-- Requires: returns schema, customer schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= returns --> ecommerce (1 constraint(s)) =========
-- Requires: returns schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);

-- ========= returns --> fulfillment (9 constraint(s)) =========
-- Requires: returns schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_fulfillment_line_id` FOREIGN KEY (`fulfillment_line_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_line`(`fulfillment_line_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= returns --> inventory (7 constraint(s)) =========
-- Requires: returns schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_retail_v1`.`inventory`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_retail_v1`.`inventory`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);

-- ========= returns --> loyalty (8 constraint(s)) =========
-- Requires: returns schema, loyalty schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_redemption_id` FOREIGN KEY (`redemption_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`redemption`(`redemption_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_program_id` FOREIGN KEY (`program_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`program`(`program_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_tier_id` FOREIGN KEY (`tier_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`tier`(`tier_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_membership_id` FOREIGN KEY (`membership_id`) REFERENCES `vibe_retail_v1`.`loyalty`.`membership`(`membership_id`);

-- ========= returns --> order (14 constraint(s)) =========
-- Requires: returns schema, order schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_pos_transaction_line_id` FOREIGN KEY (`pos_transaction_line_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction_line`(`pos_transaction_line_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `vibe_retail_v1`.`order`.`payment`(`payment_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);

-- ========= returns --> pricing (8 constraint(s)) =========
-- Requires: returns schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_price_change_id` FOREIGN KEY (`price_change_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_change`(`price_change_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);

-- ========= returns --> product (5 constraint(s)) =========
-- Requires: returns schema, product schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_item_variant_id` FOREIGN KEY (`item_variant_id`) REFERENCES `vibe_retail_v1`.`product`.`item_variant`(`item_variant_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);

-- ========= returns --> promotion (6 constraint(s)) =========
-- Requires: returns schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_promo_redemption_id` FOREIGN KEY (`promo_redemption_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_redemption`(`promo_redemption_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= returns --> store (12 constraint(s)) =========
-- Requires: returns schema, store schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= returns --> supplychain (7 constraint(s)) =========
-- Requires: returns schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_warehouse_zone_id` FOREIGN KEY (`warehouse_zone_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`warehouse_zone`(`warehouse_zone_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);

-- ========= store --> fulfillment (3 constraint(s)) =========
-- Requires: store schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= store --> pricing (4 constraint(s)) =========
-- Requires: store schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`store`.`location` ADD CONSTRAINT `fk_store_location_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`format` ADD CONSTRAINT `fk_store_format_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ADD CONSTRAINT `fk_store_cluster_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);

-- ========= store --> product (1 constraint(s)) =========
-- Requires: store schema, product schema
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);

-- ========= store --> promotion (1 constraint(s)) =========
-- Requires: store schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= store --> supplychain (5 constraint(s)) =========
-- Requires: store schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ADD CONSTRAINT `fk_store_cluster_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`sales_territory` ADD CONSTRAINT `fk_store_sales_territory_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`region` ADD CONSTRAINT `fk_store_region_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= supplychain --> fulfillment (6 constraint(s)) =========
-- Requires: supplychain schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ADD CONSTRAINT `fk_supplychain_inbound_shipment_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);

-- ========= supplychain --> inventory (2 constraint(s)) =========
-- Requires: supplychain schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ADD CONSTRAINT `fk_supplychain_warehouse_zone_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);

-- ========= supplychain --> pricing (2 constraint(s)) =========
-- Requires: supplychain schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);

-- ========= supplychain --> product (4 constraint(s)) =========
-- Requires: supplychain schema, product schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= supplychain --> promotion (2 constraint(s)) =========
-- Requires: supplychain schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= supplychain --> store (9 constraint(s)) =========
-- Requires: supplychain schema, store schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ADD CONSTRAINT `fk_supplychain_inbound_shipment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ADD CONSTRAINT `fk_supplychain_inbound_shipment_ship_from_store_node_id` FOREIGN KEY (`ship_from_store_node_id`) REFERENCES `vibe_retail_v1`.`store`.`ship_from_store_node`(`ship_from_store_node_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_ship_from_store_node_id` FOREIGN KEY (`ship_from_store_node_id`) REFERENCES `vibe_retail_v1`.`store`.`ship_from_store_node`(`ship_from_store_node_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_source_location_id` FOREIGN KEY (`source_location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

