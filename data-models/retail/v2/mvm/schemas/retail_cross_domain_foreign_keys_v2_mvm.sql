-- Cross-Domain Foreign Keys for Business: Retail | Version: v2_mvm
-- Generated on: 2026-07-12 15:26:02
-- Total cross-domain FK constraints: 807
--
-- EXECUTION ORDER:
--   1. Run ALL domain schema files first (any order).
--   2. Run this file LAST.
--
-- PREREQUISITE DOMAINS: customer, ecommerce, fulfillment, inventory, merchandising, order, pricing, product, promotion, returns, store, supplier, supplychain

-- ========= customer --> pricing (2 constraint(s)) =========
-- Requires: customer schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);

-- ========= customer --> product (2 constraint(s)) =========
-- Requires: customer schema, product schema
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ADD CONSTRAINT `fk_customer_profile_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ADD CONSTRAINT `fk_customer_profile_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);

-- ========= customer --> store (3 constraint(s)) =========
-- Requires: customer schema, store schema
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ADD CONSTRAINT `fk_customer_profile_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`profile` ADD CONSTRAINT `fk_customer_profile_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`customer`.`account` ADD CONSTRAINT `fk_customer_account_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= ecommerce --> customer (10 constraint(s)) =========
-- Requires: ecommerce schema, customer schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= ecommerce --> fulfillment (1 constraint(s)) =========
-- Requires: ecommerce schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= ecommerce --> inventory (5 constraint(s)) =========
-- Requires: ecommerce schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_reservation_id` FOREIGN KEY (`reservation_id`) REFERENCES `vibe_retail_v1`.`inventory`.`reservation`(`reservation_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront_assortment` ADD CONSTRAINT `fk_ecommerce_storefront_assortment_node_assortment_id` FOREIGN KEY (`node_assortment_id`) REFERENCES `vibe_retail_v1`.`inventory`.`node_assortment`(`node_assortment_id`);

-- ========= ecommerce --> merchandising (12 constraint(s)) =========
-- Requires: ecommerce schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_assortment_item_id` FOREIGN KEY (`assortment_item_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_item`(`assortment_item_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_assortment_item_id` FOREIGN KEY (`assortment_item_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_item`(`assortment_item_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_assortment_item_id` FOREIGN KEY (`assortment_item_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_item`(`assortment_item_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront_assortment` ADD CONSTRAINT `fk_ecommerce_storefront_assortment_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront_assortment` ADD CONSTRAINT `fk_ecommerce_storefront_assortment_otb_budget_id` FOREIGN KEY (`otb_budget_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`otb_budget`(`otb_budget_id`);

-- ========= ecommerce --> order (6 constraint(s)) =========
-- Requires: ecommerce schema, order schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_subscription_id` FOREIGN KEY (`subscription_id`) REFERENCES `vibe_retail_v1`.`order`.`subscription`(`subscription_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);

-- ========= ecommerce --> pricing (10 constraint(s)) =========
-- Requires: ecommerce schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_competitive_price_id` FOREIGN KEY (`competitive_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`competitive_price`(`competitive_price_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront_assortment` ADD CONSTRAINT `fk_ecommerce_storefront_assortment_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);

-- ========= ecommerce --> product (5 constraint(s)) =========
-- Requires: ecommerce schema, product schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= ecommerce --> promotion (17 constraint(s)) =========
-- Requires: ecommerce schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `vibe_retail_v1`.`promotion`.`coupon`(`coupon_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `vibe_retail_v1`.`promotion`.`coupon`(`coupon_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront_assortment` ADD CONSTRAINT `fk_ecommerce_storefront_assortment_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);

-- ========= ecommerce --> returns (1 constraint(s)) =========
-- Requires: ecommerce schema, returns schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_payment` ADD CONSTRAINT `fk_ecommerce_digital_payment_exchange_order_id` FOREIGN KEY (`exchange_order_id`) REFERENCES `vibe_retail_v1`.`returns`.`exchange_order`(`exchange_order_id`);

-- ========= ecommerce --> store (11 constraint(s)) =========
-- Requires: ecommerce schema, store schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront` ADD CONSTRAINT `fk_ecommerce_storefront_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`web_session` ADD CONSTRAINT `fk_ecommerce_web_session_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart` ADD CONSTRAINT `fk_ecommerce_cart_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_ship_from_store_node_id` FOREIGN KEY (`ship_from_store_node_id`) REFERENCES `vibe_retail_v1`.`store`.`ship_from_store_node`(`ship_from_store_node_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`checkout` ADD CONSTRAINT `fk_ecommerce_checkout_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`product_review` ADD CONSTRAINT `fk_ecommerce_product_review_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`storefront_assortment` ADD CONSTRAINT `fk_ecommerce_storefront_assortment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= ecommerce --> supplier (3 constraint(s)) =========
-- Requires: ecommerce schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`digital_catalog` ADD CONSTRAINT `fk_ecommerce_digital_catalog_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`marketplace_listing` ADD CONSTRAINT `fk_ecommerce_marketplace_listing_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);

-- ========= ecommerce --> supplychain (1 constraint(s)) =========
-- Requires: ecommerce schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`ecommerce`.`cart_item` ADD CONSTRAINT `fk_ecommerce_cart_item_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);

-- ========= fulfillment --> customer (4 constraint(s)) =========
-- Requires: fulfillment schema, customer schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= fulfillment --> ecommerce (1 constraint(s)) =========
-- Requires: fulfillment schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);

-- ========= fulfillment --> inventory (2 constraint(s)) =========
-- Requires: fulfillment schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_lot_id` FOREIGN KEY (`lot_id`) REFERENCES `vibe_retail_v1`.`inventory`.`lot`(`lot_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);

-- ========= fulfillment --> order (9 constraint(s)) =========
-- Requires: fulfillment schema, order schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_subscription_id` FOREIGN KEY (`subscription_id`) REFERENCES `vibe_retail_v1`.`order`.`subscription`(`subscription_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ADD CONSTRAINT `fk_fulfillment_shipment_package_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ADD CONSTRAINT `fk_fulfillment_pack_task_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);

-- ========= fulfillment --> pricing (4 constraint(s)) =========
-- Requires: fulfillment schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ADD CONSTRAINT `fk_fulfillment_fulfillment_node_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);

-- ========= fulfillment --> product (2 constraint(s)) =========
-- Requires: fulfillment schema, product schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= fulfillment --> promotion (1 constraint(s)) =========
-- Requires: fulfillment schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= fulfillment --> store (8 constraint(s)) =========
-- Requires: fulfillment schema, store schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_ship_from_store_node_id` FOREIGN KEY (`ship_from_store_node_id`) REFERENCES `vibe_retail_v1`.`store`.`ship_from_store_node`(`ship_from_store_node_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_ship_from_store_node_id` FOREIGN KEY (`ship_from_store_node_id`) REFERENCES `vibe_retail_v1`.`store`.`ship_from_store_node`(`ship_from_store_node_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= fulfillment --> supplier (4 constraint(s)) =========
-- Requires: fulfillment schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`carrier` ADD CONSTRAINT `fk_fulfillment_carrier_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= fulfillment --> supplychain (11 constraint(s)) =========
-- Requires: fulfillment schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_order` ADD CONSTRAINT `fk_fulfillment_fulfillment_order_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_line` ADD CONSTRAINT `fk_fulfillment_fulfillment_line_outbound_order_line_id` FOREIGN KEY (`outbound_order_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order_line`(`outbound_order_line_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment` ADD CONSTRAINT `fk_fulfillment_shipment_wave_id` FOREIGN KEY (`wave_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`wave`(`wave_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`shipment_package` ADD CONSTRAINT `fk_fulfillment_shipment_package_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pick_task` ADD CONSTRAINT `fk_fulfillment_pick_task_wave_id` FOREIGN KEY (`wave_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`wave`(`wave_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`pack_task` ADD CONSTRAINT `fk_fulfillment_pack_task_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`fulfillment_node` ADD CONSTRAINT `fk_fulfillment_fulfillment_node_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`fulfillment`.`bopis_appointment` ADD CONSTRAINT `fk_fulfillment_bopis_appointment_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= inventory --> customer (1 constraint(s)) =========
-- Requires: inventory schema, customer schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= inventory --> ecommerce (3 constraint(s)) =========
-- Requires: inventory schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`cart`(`cart_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_checkout_id` FOREIGN KEY (`checkout_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`checkout`(`checkout_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);

-- ========= inventory --> fulfillment (10 constraint(s)) =========
-- Requires: inventory schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_pick_task_id` FOREIGN KEY (`pick_task_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`pick_task`(`pick_task_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_fulfillment_line_id` FOREIGN KEY (`fulfillment_line_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_line`(`fulfillment_line_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);

-- ========= inventory --> merchandising (15 constraint(s)) =========
-- Requires: inventory schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_buying_order_id` FOREIGN KEY (`buying_order_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order`(`buying_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_buying_order_id` FOREIGN KEY (`buying_order_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order`(`buying_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_merch_plan_id` FOREIGN KEY (`merch_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`merch_plan`(`merch_plan_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`node_assortment` ADD CONSTRAINT `fk_inventory_node_assortment_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`node_assortment` ADD CONSTRAINT `fk_inventory_node_assortment_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`node_assortment` ADD CONSTRAINT `fk_inventory_node_assortment_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);

-- ========= inventory --> order (4 constraint(s)) =========
-- Requires: inventory schema, order schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);

-- ========= inventory --> pricing (12 constraint(s)) =========
-- Requires: inventory schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_price_change_id` FOREIGN KEY (`price_change_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_change`(`price_change_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`inventory_node` ADD CONSTRAINT `fk_inventory_inventory_node_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);

-- ========= inventory --> product (23 constraint(s)) =========
-- Requires: inventory schema, product schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_compliance_id` FOREIGN KEY (`compliance_id`) REFERENCES `vibe_retail_v1`.`product`.`compliance`(`compliance_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_compliance_id` FOREIGN KEY (`compliance_id`) REFERENCES `vibe_retail_v1`.`product`.`compliance`(`compliance_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_gtin_registry_id` FOREIGN KEY (`gtin_registry_id`) REFERENCES `vibe_retail_v1`.`product`.`gtin_registry`(`gtin_registry_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`node_assortment` ADD CONSTRAINT `fk_inventory_node_assortment_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);

-- ========= inventory --> promotion (8 constraint(s)) =========
-- Requires: inventory schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`node_assortment` ADD CONSTRAINT `fk_inventory_node_assortment_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);

-- ========= inventory --> store (17 constraint(s)) =========
-- Requires: inventory schema, store schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`inventory_node` ADD CONSTRAINT `fk_inventory_inventory_node_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`inventory_node` ADD CONSTRAINT `fk_inventory_inventory_node_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`inventory_node` ADD CONSTRAINT `fk_inventory_inventory_node_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`inventory_node` ADD CONSTRAINT `fk_inventory_inventory_node_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reservation` ADD CONSTRAINT `fk_inventory_reservation_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`node_assortment` ADD CONSTRAINT `fk_inventory_node_assortment_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`node_assortment` ADD CONSTRAINT `fk_inventory_node_assortment_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`node_assortment` ADD CONSTRAINT `fk_inventory_node_assortment_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);

-- ========= inventory --> supplier (17 constraint(s)) =========
-- Requires: inventory schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_lead_time_agreement_id` FOREIGN KEY (`lead_time_agreement_id`) REFERENCES `vibe_retail_v1`.`supplier`.`lead_time_agreement`(`lead_time_agreement_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_lead_time_agreement_id` FOREIGN KEY (`lead_time_agreement_id`) REFERENCES `vibe_retail_v1`.`supplier`.`lead_time_agreement`(`lead_time_agreement_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`goods_receipt` ADD CONSTRAINT `fk_inventory_goods_receipt_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_lead_time_agreement_id` FOREIGN KEY (`lead_time_agreement_id`) REFERENCES `vibe_retail_v1`.`supplier`.`lead_time_agreement`(`lead_time_agreement_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);

-- ========= inventory --> supplychain (28 constraint(s)) =========
-- Requires: inventory schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_ledger` ADD CONSTRAINT `fk_inventory_stock_ledger_receiving_event_id` FOREIGN KEY (`receiving_event_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`receiving_event`(`receiving_event_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`inventory_node` ADD CONSTRAINT `fk_inventory_inventory_node_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_warehouse_zone_id` FOREIGN KEY (`warehouse_zone_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`warehouse_zone`(`warehouse_zone_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
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
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_retail_v1`.`inventory`.`lot` ADD CONSTRAINT `fk_inventory_lot_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);

-- ========= merchandising --> fulfillment (1 constraint(s)) =========
-- Requires: merchandising schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= merchandising --> pricing (8 constraint(s)) =========
-- Requires: merchandising schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);

-- ========= merchandising --> product (11 constraint(s)) =========
-- Requires: merchandising schema, product schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`category` ADD CONSTRAINT `fk_merchandising_category_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);

-- ========= merchandising --> store (20 constraint(s)) =========
-- Requires: merchandising schema, store schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`merch_plan` ADD CONSTRAINT `fk_merchandising_merch_plan_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`otb_budget` ADD CONSTRAINT `fk_merchandising_otb_budget_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= merchandising --> supplier (9 constraint(s)) =========
-- Requires: merchandising schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_lead_time_agreement_id` FOREIGN KEY (`lead_time_agreement_id`) REFERENCES `vibe_retail_v1`.`supplier`.`lead_time_agreement`(`lead_time_agreement_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_vendor_address_id` FOREIGN KEY (`vendor_address_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_address`(`vendor_address_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_vendor_contact_id` FOREIGN KEY (`vendor_contact_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contact`(`vendor_contact_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);

-- ========= merchandising --> supplychain (6 constraint(s)) =========
-- Requires: merchandising schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_plan` ADD CONSTRAINT `fk_merchandising_assortment_plan_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buyer` ADD CONSTRAINT `fk_merchandising_buyer_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order` ADD CONSTRAINT `fk_merchandising_buying_order_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`buying_order_line` ADD CONSTRAINT `fk_merchandising_buying_order_line_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_retail_v1`.`merchandising`.`assortment_item` ADD CONSTRAINT `fk_merchandising_assortment_item_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);

-- ========= order --> customer (15 constraint(s)) =========
-- Requires: order schema, customer schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `vibe_retail_v1`.`customer`.`contact`(`contact_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_address_id` FOREIGN KEY (`address_id`) REFERENCES `vibe_retail_v1`.`customer`.`address`(`address_id`);

-- ========= order --> ecommerce (13 constraint(s)) =========
-- Requires: order schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_digital_catalog_id` FOREIGN KEY (`digital_catalog_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`digital_catalog`(`digital_catalog_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_marketplace_listing_id` FOREIGN KEY (`marketplace_listing_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`marketplace_listing`(`marketplace_listing_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_digital_catalog_id` FOREIGN KEY (`digital_catalog_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`digital_catalog`(`digital_catalog_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_checkout_id` FOREIGN KEY (`checkout_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`checkout`(`checkout_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_digital_payment_id` FOREIGN KEY (`digital_payment_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`digital_payment`(`digital_payment_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_digital_catalog_id` FOREIGN KEY (`digital_catalog_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`digital_catalog`(`digital_catalog_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_checkout_id` FOREIGN KEY (`checkout_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`checkout`(`checkout_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_digital_catalog_id` FOREIGN KEY (`digital_catalog_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`digital_catalog`(`digital_catalog_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);

-- ========= order --> fulfillment (14 constraint(s)) =========
-- Requires: order schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`status_history` ADD CONSTRAINT `fk_order_status_history_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`status_history` ADD CONSTRAINT `fk_order_status_history_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`status_history` ADD CONSTRAINT `fk_order_status_history_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`status_history` ADD CONSTRAINT `fk_order_status_history_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_fulfillment_line_id` FOREIGN KEY (`fulfillment_line_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_line`(`fulfillment_line_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= order --> inventory (5 constraint(s)) =========
-- Requires: order schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_lot_id` FOREIGN KEY (`lot_id`) REFERENCES `vibe_retail_v1`.`inventory`.`lot`(`lot_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_lot_id` FOREIGN KEY (`lot_id`) REFERENCES `vibe_retail_v1`.`inventory`.`lot`(`lot_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_reservation_id` FOREIGN KEY (`reservation_id`) REFERENCES `vibe_retail_v1`.`inventory`.`reservation`(`reservation_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);

-- ========= order --> merchandising (4 constraint(s)) =========
-- Requires: order schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_assortment_item_id` FOREIGN KEY (`assortment_item_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_item`(`assortment_item_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_assortment_item_id` FOREIGN KEY (`assortment_item_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_item`(`assortment_item_id`);

-- ========= order --> pricing (11 constraint(s)) =========
-- Requires: order schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_rule_id` FOREIGN KEY (`rule_id`) REFERENCES `vibe_retail_v1`.`pricing`.`rule`(`rule_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_rule_id` FOREIGN KEY (`rule_id`) REFERENCES `vibe_retail_v1`.`pricing`.`rule`(`rule_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_rule_id` FOREIGN KEY (`rule_id`) REFERENCES `vibe_retail_v1`.`pricing`.`rule`(`rule_id`);

-- ========= order --> product (4 constraint(s)) =========
-- Requires: order schema, product schema
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= order --> promotion (9 constraint(s)) =========
-- Requires: order schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_coupon_id` FOREIGN KEY (`coupon_id`) REFERENCES `vibe_retail_v1`.`promotion`.`coupon`(`coupon_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= order --> store (15 constraint(s)) =========
-- Requires: order schema, store schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_ship_from_store_node_id` FOREIGN KEY (`ship_from_store_node_id`) REFERENCES `vibe_retail_v1`.`store`.`ship_from_store_node`(`ship_from_store_node_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_ship_from_store_node_id` FOREIGN KEY (`ship_from_store_node_id`) REFERENCES `vibe_retail_v1`.`store`.`ship_from_store_node`(`ship_from_store_node_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`payment` ADD CONSTRAINT `fk_order_payment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card` ADD CONSTRAINT `fk_order_gift_card_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= order --> supplier (6 constraint(s)) =========
-- Requires: order schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction_line` ADD CONSTRAINT `fk_order_pos_transaction_line_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`discount` ADD CONSTRAINT `fk_order_discount_vendor_allowance_id` FOREIGN KEY (`vendor_allowance_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_allowance`(`vendor_allowance_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`subscription` ADD CONSTRAINT `fk_order_subscription_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);

-- ========= order --> supplychain (7 constraint(s)) =========
-- Requires: order schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`header` ADD CONSTRAINT `fk_order_header_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`order_line` ADD CONSTRAINT `fk_order_order_line_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`pos_transaction` ADD CONSTRAINT `fk_order_pos_transaction_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`cancellation` ADD CONSTRAINT `fk_order_cancellation_outbound_order_id` FOREIGN KEY (`outbound_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`outbound_order`(`outbound_order_id`);
ALTER TABLE `vibe_retail_v1`.`order`.`gift_card_transaction` ADD CONSTRAINT `fk_order_gift_card_transaction_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= pricing --> merchandising (21 constraint(s)) =========
-- Requires: pricing schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_list` ADD CONSTRAINT `fk_pricing_price_list_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_list` ADD CONSTRAINT `fk_pricing_price_list_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_list` ADD CONSTRAINT `fk_pricing_price_list_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`sku_price` ADD CONSTRAINT `fk_pricing_sku_price_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`sku_price` ADD CONSTRAINT `fk_pricing_sku_price_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_assortment_item_id` FOREIGN KEY (`assortment_item_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_item`(`assortment_item_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_assortment_item_id` FOREIGN KEY (`assortment_item_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_item`(`assortment_item_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`competitive_price` ADD CONSTRAINT `fk_pricing_competitive_price_assortment_item_id` FOREIGN KEY (`assortment_item_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_item`(`assortment_item_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`competitive_price` ADD CONSTRAINT `fk_pricing_competitive_price_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);

-- ========= pricing --> product (7 constraint(s)) =========
-- Requires: pricing schema, product schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`sku_price` ADD CONSTRAINT `fk_pricing_sku_price_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`sku_price` ADD CONSTRAINT `fk_pricing_sku_price_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`competitive_price` ADD CONSTRAINT `fk_pricing_competitive_price_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= pricing --> promotion (8 constraint(s)) =========
-- Requires: pricing schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_list` ADD CONSTRAINT `fk_pricing_price_list_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
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
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`rule` ADD CONSTRAINT `fk_pricing_rule_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);

-- ========= pricing --> supplier (6 constraint(s)) =========
-- Requires: pricing schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_vendor_allowance_id` FOREIGN KEY (`vendor_allowance_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_allowance`(`vendor_allowance_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_approval` ADD CONSTRAINT `fk_pricing_price_approval_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);

-- ========= pricing --> supplychain (7 constraint(s)) =========
-- Requires: pricing schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`price_change` ADD CONSTRAINT `fk_pricing_price_change_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`markdown` ADD CONSTRAINT `fk_pricing_markdown_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_retail_v1`.`pricing`.`cost_price` ADD CONSTRAINT `fk_pricing_cost_price_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);

-- ========= product --> fulfillment (3 constraint(s)) =========
-- Requires: product schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ADD CONSTRAINT `fk_product_compliance_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ADD CONSTRAINT `fk_product_compliance_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ADD CONSTRAINT `fk_product_assortment_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= product --> store (6 constraint(s)) =========
-- Requires: product schema, store schema
ALTER TABLE `vibe_retail_v1`.`product`.`image` ADD CONSTRAINT `fk_product_image_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ADD CONSTRAINT `fk_product_item_bundle_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ADD CONSTRAINT `fk_product_assortment_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ADD CONSTRAINT `fk_product_assortment_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ADD CONSTRAINT `fk_product_assortment_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ADD CONSTRAINT `fk_product_assortment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= product --> supplier (6 constraint(s)) =========
-- Requires: product schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`brand` ADD CONSTRAINT `fk_product_brand_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`image` ADD CONSTRAINT `fk_product_image_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`compliance` ADD CONSTRAINT `fk_product_compliance_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ADD CONSTRAINT `fk_product_item_bundle_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`product`.`assortment` ADD CONSTRAINT `fk_product_assortment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= product --> supplychain (1 constraint(s)) =========
-- Requires: product schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`product`.`item_bundle` ADD CONSTRAINT `fk_product_item_bundle_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= promotion --> customer (2 constraint(s)) =========
-- Requires: promotion schema, customer schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `vibe_retail_v1`.`customer`.`profile`(`profile_id`);

-- ========= promotion --> ecommerce (5 constraint(s)) =========
-- Requires: promotion schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ADD CONSTRAINT `fk_promotion_promo_calendar_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);

-- ========= promotion --> fulfillment (4 constraint(s)) =========
-- Requires: promotion schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= promotion --> inventory (1 constraint(s)) =========
-- Requires: promotion schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_stock_ledger_id` FOREIGN KEY (`stock_ledger_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_ledger`(`stock_ledger_id`);

-- ========= promotion --> merchandising (16 constraint(s)) =========
-- Requires: promotion schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_otb_budget_id` FOREIGN KEY (`otb_budget_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`otb_budget`(`otb_budget_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ADD CONSTRAINT `fk_promotion_vendor_promo_agreement_buying_order_id` FOREIGN KEY (`buying_order_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order`(`buying_order_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_merch_plan_id` FOREIGN KEY (`merch_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`merch_plan`(`merch_plan_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ADD CONSTRAINT `fk_promotion_promo_calendar_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);

-- ========= promotion --> order (3 constraint(s)) =========
-- Requires: promotion schema, order schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);

-- ========= promotion --> pricing (5 constraint(s)) =========
-- Requires: promotion schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_markdown_id` FOREIGN KEY (`markdown_id`) REFERENCES `vibe_retail_v1`.`pricing`.`markdown`(`markdown_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ADD CONSTRAINT `fk_promotion_vendor_promo_agreement_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_price_list_id` FOREIGN KEY (`price_list_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_list`(`price_list_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_rule_id` FOREIGN KEY (`rule_id`) REFERENCES `vibe_retail_v1`.`pricing`.`rule`(`rule_id`);

-- ========= promotion --> product (10 constraint(s)) =========
-- Requires: promotion schema, product schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ADD CONSTRAINT `fk_promotion_vendor_promo_agreement_brand_id` FOREIGN KEY (`brand_id`) REFERENCES `vibe_retail_v1`.`product`.`brand`(`brand_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= promotion --> returns (3 constraint(s)) =========
-- Requires: promotion schema, returns schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_return_policy_id` FOREIGN KEY (`return_policy_id`) REFERENCES `vibe_retail_v1`.`returns`.`return_policy`(`return_policy_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_return_policy_id` FOREIGN KEY (`return_policy_id`) REFERENCES `vibe_retail_v1`.`returns`.`return_policy`(`return_policy_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_rma_id` FOREIGN KEY (`rma_id`) REFERENCES `vibe_retail_v1`.`returns`.`rma`(`rma_id`);

-- ========= promotion --> store (14 constraint(s)) =========
-- Requires: promotion schema, store schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_calendar` ADD CONSTRAINT `fk_promotion_promo_calendar_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);

-- ========= promotion --> supplier (14 constraint(s)) =========
-- Requires: promotion schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_campaign` ADD CONSTRAINT `fk_promotion_promo_campaign_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_offer` ADD CONSTRAINT `fk_promotion_promo_offer_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`coupon` ADD CONSTRAINT `fk_promotion_coupon_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`circular_ad` ADD CONSTRAINT `fk_promotion_circular_ad_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ADD CONSTRAINT `fk_promotion_vendor_promo_agreement_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`vendor_promo_agreement` ADD CONSTRAINT `fk_promotion_vendor_promo_agreement_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_redemption` ADD CONSTRAINT `fk_promotion_promo_redemption_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`promotion`.`promo_performance` ADD CONSTRAINT `fk_promotion_promo_performance_vendor_scorecard_id` FOREIGN KEY (`vendor_scorecard_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_scorecard`(`vendor_scorecard_id`);

-- ========= promotion --> supplychain (1 constraint(s)) =========
-- Requires: promotion schema, supplychain schema
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

-- ========= returns --> fulfillment (6 constraint(s)) =========
-- Requires: returns schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_fulfillment_line_id` FOREIGN KEY (`fulfillment_line_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_line`(`fulfillment_line_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_fulfillment_order_id` FOREIGN KEY (`fulfillment_order_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_order`(`fulfillment_order_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);

-- ========= returns --> inventory (11 constraint(s)) =========
-- Requires: returns schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_retail_v1`.`inventory`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_lot_id` FOREIGN KEY (`lot_id`) REFERENCES `vibe_retail_v1`.`inventory`.`lot`(`lot_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_adjustment_id` FOREIGN KEY (`adjustment_id`) REFERENCES `vibe_retail_v1`.`inventory`.`adjustment`(`adjustment_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_retail_v1`.`inventory`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_lot_id` FOREIGN KEY (`lot_id`) REFERENCES `vibe_retail_v1`.`inventory`.`lot`(`lot_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_adjustment_id` FOREIGN KEY (`adjustment_id`) REFERENCES `vibe_retail_v1`.`inventory`.`adjustment`(`adjustment_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_stock_transfer_id` FOREIGN KEY (`stock_transfer_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_transfer`(`stock_transfer_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);

-- ========= returns --> merchandising (8 constraint(s)) =========
-- Requires: returns schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_assortment_item_id` FOREIGN KEY (`assortment_item_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_item`(`assortment_item_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_buying_order_line_id` FOREIGN KEY (`buying_order_line_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order_line`(`buying_order_line_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_buying_order_line_id` FOREIGN KEY (`buying_order_line_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order_line`(`buying_order_line_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);

-- ========= returns --> order (14 constraint(s)) =========
-- Requires: returns schema, order schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_pos_transaction_line_id` FOREIGN KEY (`pos_transaction_line_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction_line`(`pos_transaction_line_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_cancellation_id` FOREIGN KEY (`cancellation_id`) REFERENCES `vibe_retail_v1`.`order`.`cancellation`(`cancellation_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_discount_id` FOREIGN KEY (`discount_id`) REFERENCES `vibe_retail_v1`.`order`.`discount`(`discount_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `vibe_retail_v1`.`order`.`payment`(`payment_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_pos_transaction_id` FOREIGN KEY (`pos_transaction_id`) REFERENCES `vibe_retail_v1`.`order`.`pos_transaction`(`pos_transaction_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);

-- ========= returns --> pricing (5 constraint(s)) =========
-- Requires: returns schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);

-- ========= returns --> product (6 constraint(s)) =========
-- Requires: returns schema, product schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);

-- ========= returns --> promotion (6 constraint(s)) =========
-- Requires: returns schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_promo_redemption_id` FOREIGN KEY (`promo_redemption_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_redemption`(`promo_redemption_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= returns --> store (13 constraint(s)) =========
-- Requires: returns schema, store schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma` ADD CONSTRAINT `fk_returns_rma_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_request` ADD CONSTRAINT `fk_returns_return_request_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_pos_terminal_id` FOREIGN KEY (`pos_terminal_id`) REFERENCES `vibe_retail_v1`.`store`.`pos_terminal`(`pos_terminal_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`exchange_order` ADD CONSTRAINT `fk_returns_exchange_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_policy` ADD CONSTRAINT `fk_returns_return_policy_region_id` FOREIGN KEY (`region_id`) REFERENCES `vibe_retail_v1`.`store`.`region`(`region_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`store_credit` ADD CONSTRAINT `fk_returns_store_credit_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= returns --> supplier (7 constraint(s)) =========
-- Requires: returns schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_rtv_request_id` FOREIGN KEY (`rtv_request_id`) REFERENCES `vibe_retail_v1`.`supplier`.`rtv_request`(`rtv_request_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_vendor_contract_id` FOREIGN KEY (`vendor_contract_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_contract`(`vendor_contract_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_disposition_vendor_id` FOREIGN KEY (`disposition_vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_rtv_request_id` FOREIGN KEY (`rtv_request_id`) REFERENCES `vibe_retail_v1`.`supplier`.`rtv_request`(`rtv_request_id`);

-- ========= returns --> supplychain (8 constraint(s)) =========
-- Requires: returns schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`rma_line` ADD CONSTRAINT `fk_returns_rma_line_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`return_receipt` ADD CONSTRAINT `fk_returns_return_receipt_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`disposition` ADD CONSTRAINT `fk_returns_disposition_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`returns`.`refund` ADD CONSTRAINT `fk_returns_refund_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= store --> fulfillment (3 constraint(s)) =========
-- Requires: store schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_carrier_service_id` FOREIGN KEY (`carrier_service_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier_service`(`carrier_service_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_fulfillment_node_id` FOREIGN KEY (`fulfillment_node_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`fulfillment_node`(`fulfillment_node_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);

-- ========= store --> inventory (2 constraint(s)) =========
-- Requires: store schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_adjustment_id` FOREIGN KEY (`adjustment_id`) REFERENCES `vibe_retail_v1`.`inventory`.`adjustment`(`adjustment_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);

-- ========= store --> merchandising (1 constraint(s)) =========
-- Requires: store schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);

-- ========= store --> pricing (4 constraint(s)) =========
-- Requires: store schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`store`.`location` ADD CONSTRAINT `fk_store_location_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ADD CONSTRAINT `fk_store_cluster_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`region` ADD CONSTRAINT `fk_store_region_price_zone_id` FOREIGN KEY (`price_zone_id`) REFERENCES `vibe_retail_v1`.`pricing`.`price_zone`(`price_zone_id`);

-- ========= store --> product (1 constraint(s)) =========
-- Requires: store schema, product schema
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);

-- ========= store --> promotion (3 constraint(s)) =========
-- Requires: store schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`store`.`traffic_count` ADD CONSTRAINT `fk_store_traffic_count_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`ship_from_store_node` ADD CONSTRAINT `fk_store_ship_from_store_node_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= store --> returns (2 constraint(s)) =========
-- Requires: store schema, returns schema
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_rma_id` FOREIGN KEY (`rma_id`) REFERENCES `vibe_retail_v1`.`returns`.`rma`(`rma_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_return_policy_id` FOREIGN KEY (`return_policy_id`) REFERENCES `vibe_retail_v1`.`returns`.`return_policy`(`return_policy_id`);

-- ========= store --> supplier (3 constraint(s)) =========
-- Requires: store schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`store`.`pos_terminal` ADD CONSTRAINT `fk_store_pos_terminal_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`department` ADD CONSTRAINT `fk_store_department_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);

-- ========= store --> supplychain (4 constraint(s)) =========
-- Requires: store schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`shrinkage_event` ADD CONSTRAINT `fk_store_shrinkage_event_replenishment_plan_id` FOREIGN KEY (`replenishment_plan_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`replenishment_plan`(`replenishment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`cluster` ADD CONSTRAINT `fk_store_cluster_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`store`.`region` ADD CONSTRAINT `fk_store_region_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);

-- ========= supplier --> ecommerce (4 constraint(s)) =========
-- Requires: supplier schema, ecommerce schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ADD CONSTRAINT `fk_supplier_lead_time_agreement_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_storefront_id` FOREIGN KEY (`storefront_id`) REFERENCES `vibe_retail_v1`.`ecommerce`.`storefront`(`storefront_id`);

-- ========= supplier --> fulfillment (2 constraint(s)) =========
-- Requires: supplier schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`shipment`(`shipment_id`);

-- ========= supplier --> inventory (6 constraint(s)) =========
-- Requires: supplier schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_retail_v1`.`inventory`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_stock_transfer_id` FOREIGN KEY (`stock_transfer_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_transfer`(`stock_transfer_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_retail_v1`.`inventory`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ADD CONSTRAINT `fk_supplier_lead_time_agreement_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);

-- ========= supplier --> merchandising (13 constraint(s)) =========
-- Requires: supplier schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_contract` ADD CONSTRAINT `fk_supplier_vendor_contract_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_buying_order_id` FOREIGN KEY (`buying_order_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order`(`buying_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_buying_order_id` FOREIGN KEY (`buying_order_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order`(`buying_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_buying_order_line_id` FOREIGN KEY (`buying_order_line_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order_line`(`buying_order_line_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ADD CONSTRAINT `fk_supplier_lead_time_agreement_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ADD CONSTRAINT `fk_supplier_lead_time_agreement_season_id` FOREIGN KEY (`season_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`season`(`season_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_assortment_plan_id` FOREIGN KEY (`assortment_plan_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_plan`(`assortment_plan_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_buying_order_id` FOREIGN KEY (`buying_order_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order`(`buying_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_buying_order_line_id` FOREIGN KEY (`buying_order_line_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order_line`(`buying_order_line_id`);

-- ========= supplier --> product (5 constraint(s)) =========
-- Requires: supplier schema, product schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ADD CONSTRAINT `fk_supplier_vendor_item_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);

-- ========= supplier --> promotion (2 constraint(s)) =========
-- Requires: supplier schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= supplier --> returns (3 constraint(s)) =========
-- Requires: supplier schema, returns schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_return_receipt_id` FOREIGN KEY (`return_receipt_id`) REFERENCES `vibe_retail_v1`.`returns`.`return_receipt`(`return_receipt_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_rma_id` FOREIGN KEY (`rma_id`) REFERENCES `vibe_retail_v1`.`returns`.`rma`(`rma_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_return_receipt_id` FOREIGN KEY (`return_receipt_id`) REFERENCES `vibe_retail_v1`.`returns`.`return_receipt`(`return_receipt_id`);

-- ========= supplier --> store (5 constraint(s)) =========
-- Requires: supplier schema, store schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_origin_location_id` FOREIGN KEY (`origin_location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ADD CONSTRAINT `fk_supplier_lead_time_agreement_format_id` FOREIGN KEY (`format_id`) REFERENCES `vibe_retail_v1`.`store`.`format`(`format_id`);

-- ========= supplier --> supplychain (12 constraint(s)) =========
-- Requires: supplier schema, supplychain schema
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`chargeback` ADD CONSTRAINT `fk_supplier_chargeback_receiving_event_id` FOREIGN KEY (`receiving_event_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`receiving_event`(`receiving_event_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_receiving_event_id` FOREIGN KEY (`receiving_event_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`receiving_event`(`receiving_event_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`rtv_request` ADD CONSTRAINT `fk_supplier_rtv_request_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_scorecard` ADD CONSTRAINT `fk_supplier_vendor_scorecard_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`lead_time_agreement` ADD CONSTRAINT `fk_supplier_lead_time_agreement_dc_facility_id` FOREIGN KEY (`dc_facility_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`dc_facility`(`dc_facility_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_item` ADD CONSTRAINT `fk_supplier_vendor_item_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_retail_v1`.`supplier`.`vendor_allowance` ADD CONSTRAINT `fk_supplier_vendor_allowance_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_retail_v1`.`supplychain`.`purchase_order`(`purchase_order_id`);

-- ========= supplychain --> customer (1 constraint(s)) =========
-- Requires: supplychain schema, customer schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_retail_v1`.`customer`.`account`(`account_id`);

-- ========= supplychain --> fulfillment (5 constraint(s)) =========
-- Requires: supplychain schema, fulfillment schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ADD CONSTRAINT `fk_supplychain_inbound_shipment_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ADD CONSTRAINT `fk_supplychain_wave_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_retail_v1`.`fulfillment`.`carrier`(`carrier_id`);

-- ========= supplychain --> inventory (5 constraint(s)) =========
-- Requires: supplychain schema, inventory schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`warehouse_zone` ADD CONSTRAINT `fk_supplychain_warehouse_zone_inventory_node_id` FOREIGN KEY (`inventory_node_id`) REFERENCES `vibe_retail_v1`.`inventory`.`inventory_node`(`inventory_node_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_replenishment_order_id` FOREIGN KEY (`replenishment_order_id`) REFERENCES `vibe_retail_v1`.`inventory`.`replenishment_order`(`replenishment_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_lot_id` FOREIGN KEY (`lot_id`) REFERENCES `vibe_retail_v1`.`inventory`.`lot`(`lot_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `vibe_retail_v1`.`inventory`.`stock_position`(`stock_position_id`);

-- ========= supplychain --> merchandising (6 constraint(s)) =========
-- Requires: supplychain schema, merchandising schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ADD CONSTRAINT `fk_supplychain_purchase_order_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_buyer_id` FOREIGN KEY (`buyer_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buyer`(`buyer_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_buying_order_id` FOREIGN KEY (`buying_order_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`buying_order`(`buying_order_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_assortment_item_id` FOREIGN KEY (`assortment_item_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`assortment_item`(`assortment_item_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`wave` ADD CONSTRAINT `fk_supplychain_wave_category_id` FOREIGN KEY (`category_id`) REFERENCES `vibe_retail_v1`.`merchandising`.`category`(`category_id`);

-- ========= supplychain --> order (2 constraint(s)) =========
-- Requires: supplychain schema, order schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_header_id` FOREIGN KEY (`header_id`) REFERENCES `vibe_retail_v1`.`order`.`header`(`header_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_retail_v1`.`order`.`order_line`(`order_line_id`);

-- ========= supplychain --> pricing (3 constraint(s)) =========
-- Requires: supplychain schema, pricing schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_cost_price_id` FOREIGN KEY (`cost_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`cost_price`(`cost_price_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_sku_price_id` FOREIGN KEY (`sku_price_id`) REFERENCES `vibe_retail_v1`.`pricing`.`sku_price`(`sku_price_id`);

-- ========= supplychain --> product (11 constraint(s)) =========
-- Requires: supplychain schema, product schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ADD CONSTRAINT `fk_supplychain_purchase_order_item_hierarchy_id` FOREIGN KEY (`item_hierarchy_id`) REFERENCES `vibe_retail_v1`.`product`.`item_hierarchy`(`item_hierarchy_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_gtin_registry_id` FOREIGN KEY (`gtin_registry_id`) REFERENCES `vibe_retail_v1`.`product`.`gtin_registry`(`gtin_registry_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_gtin_registry_id` FOREIGN KEY (`gtin_registry_id`) REFERENCES `vibe_retail_v1`.`product`.`gtin_registry`(`gtin_registry_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_retail_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `vibe_retail_v1`.`product`.`uom`(`uom_id`);

-- ========= supplychain --> promotion (5 constraint(s)) =========
-- Requires: supplychain schema, promotion schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_promo_calendar_id` FOREIGN KEY (`promo_calendar_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_calendar`(`promo_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ADD CONSTRAINT `fk_supplychain_purchase_order_promo_calendar_id` FOREIGN KEY (`promo_calendar_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_calendar`(`promo_calendar_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ADD CONSTRAINT `fk_supplychain_inbound_shipment_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_promo_campaign_id` FOREIGN KEY (`promo_campaign_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_campaign`(`promo_campaign_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_promo_offer_id` FOREIGN KEY (`promo_offer_id`) REFERENCES `vibe_retail_v1`.`promotion`.`promo_offer`(`promo_offer_id`);

-- ========= supplychain --> store (12 constraint(s)) =========
-- Requires: supplychain schema, store schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_cluster_id` FOREIGN KEY (`cluster_id`) REFERENCES `vibe_retail_v1`.`store`.`cluster`(`cluster_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`demand_forecast` ADD CONSTRAINT `fk_supplychain_demand_forecast_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ADD CONSTRAINT `fk_supplychain_purchase_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_retail_v1`.`store`.`department`(`department_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`dc_facility` ADD CONSTRAINT `fk_supplychain_dc_facility_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ADD CONSTRAINT `fk_supplychain_inbound_shipment_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order` ADD CONSTRAINT `fk_supplychain_outbound_order_ship_from_store_node_id` FOREIGN KEY (`ship_from_store_node_id`) REFERENCES `vibe_retail_v1`.`store`.`ship_from_store_node`(`ship_from_store_node_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_location_id` FOREIGN KEY (`location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`outbound_order_line` ADD CONSTRAINT `fk_supplychain_outbound_order_line_source_location_id` FOREIGN KEY (`source_location_id`) REFERENCES `vibe_retail_v1`.`store`.`location`(`location_id`);

-- ========= supplychain --> supplier (8 constraint(s)) =========
-- Requires: supplychain schema, supplier schema
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`replenishment_plan` ADD CONSTRAINT `fk_supplychain_replenishment_plan_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ADD CONSTRAINT `fk_supplychain_purchase_order_lead_time_agreement_id` FOREIGN KEY (`lead_time_agreement_id`) REFERENCES `vibe_retail_v1`.`supplier`.`lead_time_agreement`(`lead_time_agreement_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`purchase_order` ADD CONSTRAINT `fk_supplychain_purchase_order_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`po_line` ADD CONSTRAINT `fk_supplychain_po_line_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`inbound_shipment` ADD CONSTRAINT `fk_supplychain_inbound_shipment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_retail_v1`.`supplychain`.`receiving_event` ADD CONSTRAINT `fk_supplychain_receiving_event_vendor_item_id` FOREIGN KEY (`vendor_item_id`) REFERENCES `vibe_retail_v1`.`supplier`.`vendor_item`(`vendor_item_id`);

