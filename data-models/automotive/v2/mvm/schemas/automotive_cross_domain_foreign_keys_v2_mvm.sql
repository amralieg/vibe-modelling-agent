-- Cross-Domain Foreign Keys for Business: Automotive | Version: v2_mvm
-- Generated on: 2026-07-13 17:05:59
-- Total cross-domain FK constraints: 465
--
-- EXECUTION ORDER:
--   1. Run ALL domain schema files first (any order).
--   2. Run this file LAST.
--
-- PREREQUISITE DOMAINS: aftersales, customer, dealer, engineering, finance, inventory, manufacturing, procurement, quality, sales, vehicle

-- ========= aftersales --> customer (7 constraint(s)) =========
-- Requires: aftersales schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_individual_id` FOREIGN KEY (`individual_id`) REFERENCES `vibe_automotive_v1`.`customer`.`individual`(`individual_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_vehicle_ownership_id` FOREIGN KEY (`vehicle_ownership_id`) REFERENCES `vibe_automotive_v1`.`customer`.`vehicle_ownership`(`vehicle_ownership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_warranty_aftersales_customer_party_id` FOREIGN KEY (`warranty_aftersales_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ADD CONSTRAINT `fk_aftersales_vehicle_warranty_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= aftersales --> dealer (9 constraint(s)) =========
-- Requires: aftersales schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_warranty_aftersales_dealer_dealership_id` FOREIGN KEY (`warranty_aftersales_dealer_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ADD CONSTRAINT `fk_aftersales_vehicle_warranty_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ADD CONSTRAINT `fk_aftersales_parts_order_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ADD CONSTRAINT `fk_aftersales_technician_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`campaign_vehicle_completion` ADD CONSTRAINT `fk_aftersales_campaign_vehicle_completion_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= aftersales --> engineering (19 constraint(s)) =========
-- Requires: aftersales schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_ecu_specification_id` FOREIGN KEY (`ecu_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`ecu_specification`(`ecu_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_change_id` FOREIGN KEY (`change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_ecu_specification_id` FOREIGN KEY (`ecu_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`ecu_specification`(`ecu_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_design_specification_id` FOREIGN KEY (`design_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`design_specification`(`design_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ADD CONSTRAINT `fk_aftersales_warranty_policy_homologation_requirement_id` FOREIGN KEY (`homologation_requirement_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`homologation_requirement`(`homologation_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ADD CONSTRAINT `fk_aftersales_warranty_policy_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ADD CONSTRAINT `fk_aftersales_warranty_policy_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ADD CONSTRAINT `fk_aftersales_vehicle_warranty_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ADD CONSTRAINT `fk_aftersales_vehicle_warranty_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ADD CONSTRAINT `fk_aftersales_service_campaign_ecu_specification_id` FOREIGN KEY (`ecu_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`ecu_specification`(`ecu_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ADD CONSTRAINT `fk_aftersales_service_campaign_homologation_requirement_id` FOREIGN KEY (`homologation_requirement_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`homologation_requirement`(`homologation_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ADD CONSTRAINT `fk_aftersales_service_campaign_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ADD CONSTRAINT `fk_aftersales_service_part_ecu_specification_id` FOREIGN KEY (`ecu_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`ecu_specification`(`ecu_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ADD CONSTRAINT `fk_aftersales_service_part_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);

-- ========= aftersales --> finance (15 constraint(s)) =========
-- Requires: aftersales schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ADD CONSTRAINT `fk_aftersales_warranty_policy_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ADD CONSTRAINT `fk_aftersales_warranty_policy_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ADD CONSTRAINT `fk_aftersales_service_campaign_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ADD CONSTRAINT `fk_aftersales_service_campaign_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ADD CONSTRAINT `fk_aftersales_service_part_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ADD CONSTRAINT `fk_aftersales_parts_order_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `vibe_automotive_v1`.`finance`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ADD CONSTRAINT `fk_aftersales_parts_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ADD CONSTRAINT `fk_aftersales_parts_order_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ADD CONSTRAINT `fk_aftersales_technician_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= aftersales --> inventory (5 constraint(s)) =========
-- Requires: aftersales schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_service_parts_stock_id` FOREIGN KEY (`service_parts_stock_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`service_parts_stock`(`service_parts_stock_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ADD CONSTRAINT `fk_aftersales_service_part_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ADD CONSTRAINT `fk_aftersales_parts_order_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`warehouse`(`warehouse_id`);

-- ========= aftersales --> manufacturing (5 constraint(s)) =========
-- Requires: aftersales schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_vehicle_build_id` FOREIGN KEY (`vehicle_build_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`vehicle_build`(`vehicle_build_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_vehicle_build_id` FOREIGN KEY (`vehicle_build_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`vehicle_build`(`vehicle_build_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ADD CONSTRAINT `fk_aftersales_service_campaign_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ADD CONSTRAINT `fk_aftersales_parts_order_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);

-- ========= aftersales --> procurement (7 constraint(s)) =========
-- Requires: aftersales schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ADD CONSTRAINT `fk_aftersales_service_part_info_record_id` FOREIGN KEY (`info_record_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`info_record`(`info_record_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ADD CONSTRAINT `fk_aftersales_service_part_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ADD CONSTRAINT `fk_aftersales_parts_order_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order` ADD CONSTRAINT `fk_aftersales_parts_order_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);

-- ========= aftersales --> quality (5 constraint(s)) =========
-- Requires: aftersales schema, quality schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_defect_record_id` FOREIGN KEY (`defect_record_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_record`(`defect_record_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_claim` ADD CONSTRAINT `fk_aftersales_warranty_claim_field_return_id` FOREIGN KEY (`field_return_id`) REFERENCES `vibe_automotive_v1`.`quality`.`field_return`(`field_return_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ADD CONSTRAINT `fk_aftersales_service_campaign_defect_record_id` FOREIGN KEY (`defect_record_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_record`(`defect_record_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ADD CONSTRAINT `fk_aftersales_service_campaign_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `vibe_automotive_v1`.`quality`.`fmea`(`fmea_id`);

-- ========= aftersales --> sales (2 constraint(s)) =========
-- Requires: aftersales schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_fleet_contract_id` FOREIGN KEY (`fleet_contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`fleet_contract`(`fleet_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);

-- ========= aftersales --> vehicle (5 constraint(s)) =========
-- Requires: aftersales schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ADD CONSTRAINT `fk_aftersales_warranty_policy_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ADD CONSTRAINT `fk_aftersales_warranty_policy_platform_id` FOREIGN KEY (`platform_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`platform`(`platform_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ADD CONSTRAINT `fk_aftersales_service_campaign_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`connected_vehicle`(`connected_vehicle_id`);

-- ========= customer --> aftersales (1 constraint(s)) =========
-- Requires: customer schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_aftersales_repair_order_id` FOREIGN KEY (`aftersales_repair_order_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order`(`aftersales_repair_order_id`);

-- ========= customer --> dealer (5 constraint(s)) =========
-- Requires: customer schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ADD CONSTRAINT `fk_customer_individual_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ADD CONSTRAINT `fk_customer_individual_primary_dealership_id` FOREIGN KEY (`primary_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`organization_account` ADD CONSTRAINT `fk_customer_organization_account_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ADD CONSTRAINT `fk_customer_vehicle_ownership_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= customer --> engineering (4 constraint(s)) =========
-- Requires: customer schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ADD CONSTRAINT `fk_customer_vehicle_ownership_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ADD CONSTRAINT `fk_customer_vehicle_ownership_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`telemetry_event` ADD CONSTRAINT `fk_customer_telemetry_event_ecu_specification_id` FOREIGN KEY (`ecu_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`ecu_specification`(`ecu_specification_id`);

-- ========= customer --> manufacturing (1 constraint(s)) =========
-- Requires: customer schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_vehicle_build_id` FOREIGN KEY (`vehicle_build_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`vehicle_build`(`vehicle_build_id`);

-- ========= customer --> sales (1 constraint(s)) =========
-- Requires: customer schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_delivery_appointment_id` FOREIGN KEY (`delivery_appointment_id`) REFERENCES `vibe_automotive_v1`.`sales`.`delivery_appointment`(`delivery_appointment_id`);

-- ========= customer --> vehicle (2 constraint(s)) =========
-- Requires: customer schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`telemetry_event` ADD CONSTRAINT `fk_customer_telemetry_event_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`connected_vehicle`(`connected_vehicle_id`);

-- ========= dealer --> aftersales (2 constraint(s)) =========
-- Requires: dealer schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ADD CONSTRAINT `fk_dealer_dealer_service_appointment_aftersales_service_appointment_id` FOREIGN KEY (`aftersales_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment`(`aftersales_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`predictive_maintenance_alert` ADD CONSTRAINT `fk_dealer_predictive_maintenance_alert_aftersales_repair_order_id` FOREIGN KEY (`aftersales_repair_order_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order`(`aftersales_repair_order_id`);

-- ========= dealer --> customer (2 constraint(s)) =========
-- Requires: dealer schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ADD CONSTRAINT `fk_dealer_dealership_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= dealer --> engineering (4 constraint(s)) =========
-- Requires: dealer schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`franchise_agreement` ADD CONSTRAINT `fk_dealer_franchise_agreement_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ADD CONSTRAINT `fk_dealer_vehicle_allocation_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`predictive_maintenance_alert` ADD CONSTRAINT `fk_dealer_predictive_maintenance_alert_ecu_specification_id` FOREIGN KEY (`ecu_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`ecu_specification`(`ecu_specification_id`);

-- ========= dealer --> finance (4 constraint(s)) =========
-- Requires: dealer schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ADD CONSTRAINT `fk_dealer_dealership_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ADD CONSTRAINT `fk_dealer_vehicle_allocation_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `vibe_automotive_v1`.`finance`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `vibe_automotive_v1`.`finance`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`predictive_maintenance_alert` ADD CONSTRAINT `fk_dealer_predictive_maintenance_alert_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= dealer --> inventory (3 constraint(s)) =========
-- Requires: dealer schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_finished_vehicle_stock_id` FOREIGN KEY (`finished_vehicle_stock_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock`(`finished_vehicle_stock_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);

-- ========= dealer --> manufacturing (4 constraint(s)) =========
-- Requires: dealer schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_vehicle_build_id` FOREIGN KEY (`vehicle_build_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`vehicle_build`(`vehicle_build_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_vehicle_build_id` FOREIGN KEY (`vehicle_build_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`vehicle_build`(`vehicle_build_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`predictive_maintenance_alert` ADD CONSTRAINT `fk_dealer_predictive_maintenance_alert_vehicle_build_id` FOREIGN KEY (`vehicle_build_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`vehicle_build`(`vehicle_build_id`);

-- ========= dealer --> quality (1 constraint(s)) =========
-- Requires: dealer schema, quality schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`predictive_maintenance_alert` ADD CONSTRAINT `fk_dealer_predictive_maintenance_alert_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_code`(`defect_code_id`);

-- ========= dealer --> sales (5 constraint(s)) =========
-- Requires: dealer schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_fleet_contract_id` FOREIGN KEY (`fleet_contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`fleet_contract`(`fleet_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_trade_in_id` FOREIGN KEY (`trade_in_id`) REFERENCES `vibe_automotive_v1`.`sales`.`trade_in`(`trade_in_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);

-- ========= dealer --> vehicle (5 constraint(s)) =========
-- Requires: dealer schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ADD CONSTRAINT `fk_dealer_vehicle_allocation_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`predictive_maintenance_alert` ADD CONSTRAINT `fk_dealer_predictive_maintenance_alert_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`predictive_maintenance_alert` ADD CONSTRAINT `fk_dealer_predictive_maintenance_alert_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);

-- ========= engineering --> finance (10 constraint(s)) =========
-- Requires: engineering schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ADD CONSTRAINT `fk_engineering_vehicle_program_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ADD CONSTRAINT `fk_engineering_vehicle_program_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ADD CONSTRAINT `fk_engineering_bom_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom_line` ADD CONSTRAINT `fk_engineering_bom_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ADD CONSTRAINT `fk_engineering_part_master_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ADD CONSTRAINT `fk_engineering_part_master_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ADD CONSTRAINT `fk_engineering_design_specification_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ADD CONSTRAINT `fk_engineering_change_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ADD CONSTRAINT `fk_engineering_validation_test_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`powertrain_spec` ADD CONSTRAINT `fk_engineering_powertrain_spec_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= engineering --> inventory (2 constraint(s)) =========
-- Requires: engineering schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ADD CONSTRAINT `fk_engineering_bom_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom_line` ADD CONSTRAINT `fk_engineering_bom_line_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);

-- ========= engineering --> manufacturing (4 constraint(s)) =========
-- Requires: engineering schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ADD CONSTRAINT `fk_engineering_vehicle_program_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ADD CONSTRAINT `fk_engineering_part_master_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ADD CONSTRAINT `fk_engineering_change_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ADD CONSTRAINT `fk_engineering_validation_test_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);

-- ========= engineering --> procurement (1 constraint(s)) =========
-- Requires: engineering schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom_line` ADD CONSTRAINT `fk_engineering_bom_line_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);

-- ========= engineering --> vehicle (1 constraint(s)) =========
-- Requires: engineering schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ADD CONSTRAINT `fk_engineering_homologation_requirement_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);

-- ========= finance --> customer (7 constraint(s)) =========
-- Requires: finance schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_organization_account_id` FOREIGN KEY (`organization_account_id`) REFERENCES `vibe_automotive_v1`.`customer`.`organization_account`(`organization_account_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_vehicle_ownership_id` FOREIGN KEY (`vehicle_ownership_id`) REFERENCES `vibe_automotive_v1`.`customer`.`vehicle_ownership`(`vehicle_ownership_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ADD CONSTRAINT `fk_finance_ar_payment_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_vehicle_ownership_id` FOREIGN KEY (`vehicle_ownership_id`) REFERENCES `vibe_automotive_v1`.`customer`.`vehicle_ownership`(`vehicle_ownership_id`);

-- ========= finance --> dealer (4 constraint(s)) =========
-- Requires: finance schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ADD CONSTRAINT `fk_finance_ar_payment_retail_sale_id` FOREIGN KEY (`retail_sale_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`retail_sale`(`retail_sale_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_primary_vehicle_dealership_id` FOREIGN KEY (`primary_vehicle_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= finance --> engineering (1 constraint(s)) =========
-- Requires: finance schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= finance --> manufacturing (3 constraint(s)) =========
-- Requires: finance schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);

-- ========= finance --> sales (1 constraint(s)) =========
-- Requires: finance schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_incentive_program_id` FOREIGN KEY (`incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`incentive_program`(`incentive_program_id`);

-- ========= finance --> vehicle (2 constraint(s)) =========
-- Requires: finance schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);

-- ========= inventory --> aftersales (1 constraint(s)) =========
-- Requires: inventory schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_service_campaign_id` FOREIGN KEY (`service_campaign_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_campaign`(`service_campaign_id`);

-- ========= inventory --> customer (1 constraint(s)) =========
-- Requires: inventory schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= inventory --> dealer (4 constraint(s)) =========
-- Requires: inventory schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ADD CONSTRAINT `fk_inventory_sku_master_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ADD CONSTRAINT `fk_inventory_service_parts_stock_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= inventory --> engineering (5 constraint(s)) =========
-- Requires: inventory schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ADD CONSTRAINT `fk_inventory_sku_master_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`bom`(`bom_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= inventory --> finance (14 constraint(s)) =========
-- Requires: inventory schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ADD CONSTRAINT `fk_inventory_storage_location_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ADD CONSTRAINT `fk_inventory_stock_balance_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ADD CONSTRAINT `fk_inventory_stock_balance_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ADD CONSTRAINT `fk_inventory_stock_balance_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ADD CONSTRAINT `fk_inventory_service_parts_stock_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ADD CONSTRAINT `fk_inventory_service_parts_stock_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ADD CONSTRAINT `fk_inventory_warehouse_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse` ADD CONSTRAINT `fk_inventory_warehouse_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= inventory --> manufacturing (7 constraint(s)) =========
-- Requires: inventory schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ADD CONSTRAINT `fk_inventory_storage_location_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_production_bom_id` FOREIGN KEY (`production_bom_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_bom`(`production_bom_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_production_schedule_id` FOREIGN KEY (`production_schedule_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_schedule`(`production_schedule_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);

-- ========= inventory --> procurement (5 constraint(s)) =========
-- Requires: inventory schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ADD CONSTRAINT `fk_inventory_service_parts_stock_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);

-- ========= inventory --> sales (3 constraint(s)) =========
-- Requires: inventory schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_delivery_appointment_id` FOREIGN KEY (`delivery_appointment_id`) REFERENCES `vibe_automotive_v1`.`sales`.`delivery_appointment`(`delivery_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_automotive_v1`.`sales`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);

-- ========= inventory --> vehicle (5 constraint(s)) =========
-- Requires: inventory schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ADD CONSTRAINT `fk_inventory_service_parts_stock_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);

-- ========= manufacturing --> aftersales (1 constraint(s)) =========
-- Requires: manufacturing schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ADD CONSTRAINT `fk_manufacturing_rework_order_warranty_claim_id` FOREIGN KEY (`warranty_claim_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`warranty_claim`(`warranty_claim_id`);

-- ========= manufacturing --> customer (2 constraint(s)) =========
-- Requires: manufacturing schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ADD CONSTRAINT `fk_manufacturing_rework_order_case_id` FOREIGN KEY (`case_id`) REFERENCES `vibe_automotive_v1`.`customer`.`case`(`case_id`);

-- ========= manufacturing --> dealer (2 constraint(s)) =========
-- Requires: manufacturing schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ADD CONSTRAINT `fk_manufacturing_production_line_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ADD CONSTRAINT `fk_manufacturing_work_center_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= manufacturing --> engineering (10 constraint(s)) =========
-- Requires: manufacturing schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ADD CONSTRAINT `fk_manufacturing_production_line_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ADD CONSTRAINT `fk_manufacturing_production_line_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_ecu_specification_id` FOREIGN KEY (`ecu_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`ecu_specification`(`ecu_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ADD CONSTRAINT `fk_manufacturing_production_schedule_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ADD CONSTRAINT `fk_manufacturing_production_bom_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ADD CONSTRAINT `fk_manufacturing_production_bom_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`bom`(`bom_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ADD CONSTRAINT `fk_manufacturing_rework_order_change_id` FOREIGN KEY (`change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);

-- ========= manufacturing --> finance (8 constraint(s)) =========
-- Requires: manufacturing schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ADD CONSTRAINT `fk_manufacturing_plant_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ADD CONSTRAINT `fk_manufacturing_production_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ADD CONSTRAINT `fk_manufacturing_work_center_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `vibe_automotive_v1`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ADD CONSTRAINT `fk_manufacturing_production_schedule_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `vibe_automotive_v1`.`finance`.`journal_entry`(`journal_entry_id`);

-- ========= manufacturing --> inventory (6 constraint(s)) =========
-- Requires: manufacturing schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_goods_movement_id` FOREIGN KEY (`goods_movement_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`goods_movement`(`goods_movement_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ADD CONSTRAINT `fk_manufacturing_rework_order_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);

-- ========= manufacturing --> procurement (4 constraint(s)) =========
-- Requires: manufacturing schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ADD CONSTRAINT `fk_manufacturing_production_bom_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ADD CONSTRAINT `fk_manufacturing_production_bom_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ADD CONSTRAINT `fk_manufacturing_rework_order_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);

-- ========= manufacturing --> quality (2 constraint(s)) =========
-- Requires: manufacturing schema, quality schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ADD CONSTRAINT `fk_manufacturing_rework_order_defect_record_id` FOREIGN KEY (`defect_record_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_record`(`defect_record_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ADD CONSTRAINT `fk_manufacturing_rework_order_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_lot`(`inspection_lot_id`);

-- ========= manufacturing --> vehicle (11 constraint(s)) =========
-- Requires: manufacturing schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ADD CONSTRAINT `fk_manufacturing_production_line_platform_id` FOREIGN KEY (`platform_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`platform`(`platform_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ADD CONSTRAINT `fk_manufacturing_production_schedule_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ADD CONSTRAINT `fk_manufacturing_production_bom_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ADD CONSTRAINT `fk_manufacturing_rework_order_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`routing` ADD CONSTRAINT `fk_manufacturing_routing_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);

-- ========= procurement --> dealer (1 constraint(s)) =========
-- Requires: procurement schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= procurement --> engineering (5 constraint(s)) =========
-- Requires: procurement schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ADD CONSTRAINT `fk_procurement_purchase_order_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_design_specification_id` FOREIGN KEY (`design_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`design_specification`(`design_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ADD CONSTRAINT `fk_procurement_info_record_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);

-- ========= procurement --> finance (16 constraint(s)) =========
-- Requires: procurement schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ADD CONSTRAINT `fk_procurement_purchase_order_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ADD CONSTRAINT `fk_procurement_purchase_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ADD CONSTRAINT `fk_procurement_purchase_order_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ADD CONSTRAINT `fk_procurement_po_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ADD CONSTRAINT `fk_procurement_po_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `vibe_automotive_v1`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ADD CONSTRAINT `fk_procurement_info_record_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ADD CONSTRAINT `fk_procurement_supplier_evaluation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= procurement --> inventory (7 constraint(s)) =========
-- Requires: procurement schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ADD CONSTRAINT `fk_procurement_po_line_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ADD CONSTRAINT `fk_procurement_po_line_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ADD CONSTRAINT `fk_procurement_info_record_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);

-- ========= procurement --> manufacturing (5 constraint(s)) =========
-- Requires: procurement schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ADD CONSTRAINT `fk_procurement_purchase_order_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ADD CONSTRAINT `fk_procurement_po_line_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ADD CONSTRAINT `fk_procurement_po_line_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ADD CONSTRAINT `fk_procurement_supplier_evaluation_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);

-- ========= procurement --> quality (3 constraint(s)) =========
-- Requires: procurement schema, quality schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_order` ADD CONSTRAINT `fk_procurement_purchase_order_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`po_line` ADD CONSTRAINT `fk_procurement_po_line_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_lot`(`inspection_lot_id`);

-- ========= procurement --> vehicle (2 constraint(s)) =========
-- Requires: procurement schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_platform_id` FOREIGN KEY (`platform_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`platform`(`platform_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ADD CONSTRAINT `fk_procurement_supplier_evaluation_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);

-- ========= quality --> aftersales (1 constraint(s)) =========
-- Requires: quality schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_aftersales_repair_order_id` FOREIGN KEY (`aftersales_repair_order_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order`(`aftersales_repair_order_id`);

-- ========= quality --> customer (5 constraint(s)) =========
-- Requires: quality schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_telemetry_event_id` FOREIGN KEY (`telemetry_event_id`) REFERENCES `vibe_automotive_v1`.`customer`.`telemetry_event`(`telemetry_event_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_vehicle_ownership_id` FOREIGN KEY (`vehicle_ownership_id`) REFERENCES `vibe_automotive_v1`.`customer`.`vehicle_ownership`(`vehicle_ownership_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_vehicle_ownership_id` FOREIGN KEY (`vehicle_ownership_id`) REFERENCES `vibe_automotive_v1`.`customer`.`vehicle_ownership`(`vehicle_ownership_id`);

-- ========= quality --> dealer (5 constraint(s)) =========
-- Requires: quality schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_vehicle_allocation_id` FOREIGN KEY (`vehicle_allocation_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`vehicle_allocation`(`vehicle_allocation_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_dealer_repair_order_id` FOREIGN KEY (`dealer_repair_order_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_repair_order`(`dealer_repair_order_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_dealer_repair_order_id` FOREIGN KEY (`dealer_repair_order_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_repair_order`(`dealer_repair_order_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= quality --> engineering (20 constraint(s)) =========
-- Requires: quality schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_design_specification_id` FOREIGN KEY (`design_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`design_specification`(`design_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_design_specification_id` FOREIGN KEY (`design_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`design_specification`(`design_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_design_specification_id` FOREIGN KEY (`design_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`design_specification`(`design_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ADD CONSTRAINT `fk_quality_corrective_action_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ADD CONSTRAINT `fk_quality_corrective_action_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ADD CONSTRAINT `fk_quality_defect_code_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ADD CONSTRAINT `fk_quality_characteristic_design_specification_id` FOREIGN KEY (`design_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`design_specification`(`design_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`characteristic` ADD CONSTRAINT `fk_quality_characteristic_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= quality --> finance (5 constraint(s)) =========
-- Requires: quality schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ADD CONSTRAINT `fk_quality_corrective_action_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `vibe_automotive_v1`.`finance`.`ar_invoice`(`ar_invoice_id`);

-- ========= quality --> inventory (6 constraint(s)) =========
-- Requires: quality schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_finished_vehicle_stock_id` FOREIGN KEY (`finished_vehicle_stock_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock`(`finished_vehicle_stock_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_goods_movement_id` FOREIGN KEY (`goods_movement_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`goods_movement`(`goods_movement_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_stock_balance_id` FOREIGN KEY (`stock_balance_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`stock_balance`(`stock_balance_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_goods_movement_id` FOREIGN KEY (`goods_movement_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`goods_movement`(`goods_movement_id`);

-- ========= quality --> manufacturing (16 constraint(s)) =========
-- Requires: quality schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_production_bom_id` FOREIGN KEY (`production_bom_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_bom`(`production_bom_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_routing_id` FOREIGN KEY (`routing_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`routing`(`routing_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_vehicle_build_id` FOREIGN KEY (`vehicle_build_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`vehicle_build`(`vehicle_build_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_vehicle_build_id` FOREIGN KEY (`vehicle_build_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`vehicle_build`(`vehicle_build_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ADD CONSTRAINT `fk_quality_corrective_action_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);

-- ========= quality --> procurement (5 constraint(s)) =========
-- Requires: quality schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_po_line_id` FOREIGN KEY (`po_line_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`po_line`(`po_line_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ADD CONSTRAINT `fk_quality_corrective_action_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier`(`supplier_id`);

-- ========= quality --> sales (7 constraint(s)) =========
-- Requires: quality schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_fleet_contract_id` FOREIGN KEY (`fleet_contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`fleet_contract`(`fleet_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_automotive_v1`.`sales`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_delivery_appointment_id` FOREIGN KEY (`delivery_appointment_id`) REFERENCES `vibe_automotive_v1`.`sales`.`delivery_appointment`(`delivery_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_delivery_appointment_id` FOREIGN KEY (`delivery_appointment_id`) REFERENCES `vibe_automotive_v1`.`sales`.`delivery_appointment`(`delivery_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_automotive_v1`.`sales`.`order_line`(`order_line_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_delivery_appointment_id` FOREIGN KEY (`delivery_appointment_id`) REFERENCES `vibe_automotive_v1`.`sales`.`delivery_appointment`(`delivery_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_automotive_v1`.`sales`.`order_line`(`order_line_id`);

-- ========= quality --> vehicle (6 constraint(s)) =========
-- Requires: quality schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_platform_id` FOREIGN KEY (`platform_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`platform`(`platform_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`corrective_action` ADD CONSTRAINT `fk_quality_corrective_action_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);

-- ========= sales --> aftersales (2 constraint(s)) =========
-- Requires: sales schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_warranty_policy_id` FOREIGN KEY (`warranty_policy_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`warranty_policy`(`warranty_policy_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`technician`(`technician_id`);

-- ========= sales --> customer (15 constraint(s)) =========
-- Requires: sales schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_organization_account_id` FOREIGN KEY (`organization_account_id`) REFERENCES `vibe_automotive_v1`.`customer`.`organization_account`(`organization_account_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_organization_account_id` FOREIGN KEY (`organization_account_id`) REFERENCES `vibe_automotive_v1`.`customer`.`organization_account`(`organization_account_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_quote_customer_party_id` FOREIGN KEY (`quote_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_contact_point_id` FOREIGN KEY (`contact_point_id`) REFERENCES `vibe_automotive_v1`.`customer`.`contact_point`(`contact_point_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_organization_account_id` FOREIGN KEY (`organization_account_id`) REFERENCES `vibe_automotive_v1`.`customer`.`organization_account`(`organization_account_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_vehicle_organization_account_id` FOREIGN KEY (`vehicle_organization_account_id`) REFERENCES `vibe_automotive_v1`.`customer`.`organization_account`(`organization_account_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_organization_account_id` FOREIGN KEY (`organization_account_id`) REFERENCES `vibe_automotive_v1`.`customer`.`organization_account`(`organization_account_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ADD CONSTRAINT `fk_sales_trade_in_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= sales --> dealer (11 constraint(s)) =========
-- Requires: sales schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_dealer_inventory_id` FOREIGN KEY (`dealer_inventory_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_inventory`(`dealer_inventory_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_quote_dealer_dealership_id` FOREIGN KEY (`quote_dealer_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_vehicle_allocation_id` FOREIGN KEY (`vehicle_allocation_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`vehicle_allocation`(`vehicle_allocation_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ADD CONSTRAINT `fk_sales_trade_in_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= sales --> engineering (8 constraint(s)) =========
-- Requires: sales schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` ADD CONSTRAINT `fk_sales_incentive_program_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` ADD CONSTRAINT `fk_sales_incentive_program_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= sales --> finance (12 constraint(s)) =========
-- Requires: sales schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` ADD CONSTRAINT `fk_sales_incentive_program_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` ADD CONSTRAINT `fk_sales_incentive_program_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`incentive_program` ADD CONSTRAINT `fk_sales_incentive_program_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ADD CONSTRAINT `fk_sales_trade_in_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);

-- ========= sales --> inventory (5 constraint(s)) =========
-- Requires: sales schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_finished_vehicle_stock_id` FOREIGN KEY (`finished_vehicle_stock_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock`(`finished_vehicle_stock_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_finished_vehicle_stock_id` FOREIGN KEY (`finished_vehicle_stock_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock`(`finished_vehicle_stock_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_finished_vehicle_stock_id` FOREIGN KEY (`finished_vehicle_stock_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock`(`finished_vehicle_stock_id`);

-- ========= sales --> manufacturing (5 constraint(s)) =========
-- Requires: sales schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_vehicle_build_id` FOREIGN KEY (`vehicle_build_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`vehicle_build`(`vehicle_build_id`);

-- ========= sales --> vehicle (17 constraint(s)) =========
-- Requires: sales schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_primary_model_id` FOREIGN KEY (`primary_model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_quote_trim_level_model_id` FOREIGN KEY (`quote_trim_level_model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_order_option_package_configuration_id` FOREIGN KEY (`order_option_package_configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);

-- ========= vehicle --> customer (3 constraint(s)) =========
-- Requires: vehicle schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ADD CONSTRAINT `fk_vehicle_ownership_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ADD CONSTRAINT `fk_vehicle_connected_vehicle_organization_account_id` FOREIGN KEY (`organization_account_id`) REFERENCES `vibe_automotive_v1`.`customer`.`organization_account`(`organization_account_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ADD CONSTRAINT `fk_vehicle_connected_vehicle_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= vehicle --> dealer (2 constraint(s)) =========
-- Requires: vehicle schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`lifecycle_event` ADD CONSTRAINT `fk_vehicle_lifecycle_event_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ADD CONSTRAINT `fk_vehicle_connected_vehicle_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= vehicle --> engineering (11 constraint(s)) =========
-- Requires: vehicle schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ADD CONSTRAINT `fk_vehicle_vin_registry_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`bom`(`bom_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ADD CONSTRAINT `fk_vehicle_vin_registry_ecu_specification_id` FOREIGN KEY (`ecu_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`ecu_specification`(`ecu_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ADD CONSTRAINT `fk_vehicle_vin_registry_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ADD CONSTRAINT `fk_vehicle_model_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ADD CONSTRAINT `fk_vehicle_platform_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`bom`(`bom_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ADD CONSTRAINT `fk_vehicle_build_spec_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`bom`(`bom_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ADD CONSTRAINT `fk_vehicle_build_spec_change_id` FOREIGN KEY (`change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ADD CONSTRAINT `fk_vehicle_connected_vehicle_ecu_specification_id` FOREIGN KEY (`ecu_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`ecu_specification`(`ecu_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ADD CONSTRAINT `fk_vehicle_connected_vehicle_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);

-- ========= vehicle --> inventory (2 constraint(s)) =========
-- Requires: vehicle schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ADD CONSTRAINT `fk_vehicle_connected_vehicle_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);

-- ========= vehicle --> manufacturing (4 constraint(s)) =========
-- Requires: vehicle schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ADD CONSTRAINT `fk_vehicle_vin_registry_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ADD CONSTRAINT `fk_vehicle_model_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ADD CONSTRAINT `fk_vehicle_connected_vehicle_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);

-- ========= vehicle --> sales (3 constraint(s)) =========
-- Requires: vehicle schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`build_spec` ADD CONSTRAINT `fk_vehicle_build_spec_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ADD CONSTRAINT `fk_vehicle_ownership_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`connected_vehicle` ADD CONSTRAINT `fk_vehicle_connected_vehicle_fleet_contract_id` FOREIGN KEY (`fleet_contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`fleet_contract`(`fleet_contract_id`);

