-- Cross-Domain Foreign Keys for Business:  | Version: v2_ecm
-- Generated on: 2026-07-13 15:03:56
-- Total cross-domain FK constraints: 1492
--
-- EXECUTION ORDER:
--   1. Run ALL domain schema files first (any order).
--   2. Run this file LAST.
--
-- PREREQUISITE DOMAINS: aftersales, asset, billing, compliance, customer, dealer, engineering, field_services, finance, inventory, logistics, manufacturing, mobility, procurement, product, quality, sales, supply, vehicle, workforce

-- ========= aftersales --> asset (1 constraint(s)) =========
-- Requires: aftersales schema, asset schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ADD CONSTRAINT `fk_aftersales_service_center_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);

-- ========= aftersales --> billing (1 constraint(s)) =========
-- Requires: aftersales schema, billing schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`rebate_coverage` ADD CONSTRAINT `fk_aftersales_rebate_coverage_rebate_agreement_id` FOREIGN KEY (`rebate_agreement_id`) REFERENCES `vibe_automotive_v1`.`billing`.`rebate_agreement`(`rebate_agreement_id`);

-- ========= aftersales --> compliance (4 constraint(s)) =========
-- Requires: aftersales schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_recall_campaign_id` FOREIGN KEY (`recall_campaign_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`recall_campaign`(`recall_campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_recall_campaign_id` FOREIGN KEY (`recall_campaign_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`recall_campaign`(`recall_campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ADD CONSTRAINT `fk_aftersales_vehicle_warranty_recall_campaign_id` FOREIGN KEY (`recall_campaign_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`recall_campaign`(`recall_campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ADD CONSTRAINT `fk_aftersales_vehicle_warranty_vehicle_recall_recall_campaign_id` FOREIGN KEY (`vehicle_recall_recall_campaign_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`recall_campaign`(`recall_campaign_id`);

-- ========= aftersales --> customer (21 constraint(s)) =========
-- Requires: aftersales schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`fleet_spec` ADD CONSTRAINT `fk_aftersales_fleet_spec_customer_fleet_account_id` FOREIGN KEY (`customer_fleet_account_id`) REFERENCES `vibe_automotive_v1`.`customer`.`customer_fleet_account`(`customer_fleet_account_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`product_lifecycle_event` ADD CONSTRAINT `fk_aftersales_product_lifecycle_event_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_vehicle_ownership_id` FOREIGN KEY (`vehicle_ownership_id`) REFERENCES `vibe_automotive_v1`.`customer`.`vehicle_ownership`(`vehicle_ownership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_vehicle_ownership_id` FOREIGN KEY (`vehicle_ownership_id`) REFERENCES `vibe_automotive_v1`.`customer`.`vehicle_ownership`(`vehicle_ownership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ADD CONSTRAINT `fk_aftersales_vehicle_warranty_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_vehicle_ownership_id` FOREIGN KEY (`vehicle_ownership_id`) REFERENCES `vibe_automotive_v1`.`customer`.`vehicle_ownership`(`vehicle_ownership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract` ADD CONSTRAINT `fk_aftersales_service_contract_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract` ADD CONSTRAINT `fk_aftersales_service_contract_service_customer_party_id` FOREIGN KEY (`service_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract_claim` ADD CONSTRAINT `fk_aftersales_service_contract_claim_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract_claim` ADD CONSTRAINT `fk_aftersales_service_contract_claim_service_customer_party_id` FOREIGN KEY (`service_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`goodwill_adjustment` ADD CONSTRAINT `fk_aftersales_goodwill_adjustment_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`goodwill_adjustment` ADD CONSTRAINT `fk_aftersales_goodwill_adjustment_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`customer_satisfaction_survey` ADD CONSTRAINT `fk_aftersales_customer_satisfaction_survey_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`loaner_assignment` ADD CONSTRAINT `fk_aftersales_loaner_assignment_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`loaner_assignment` ADD CONSTRAINT `fk_aftersales_loaner_assignment_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= aftersales --> dealer (23 constraint(s)) =========
-- Requires: aftersales schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_primary_dealership_id` FOREIGN KEY (`primary_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_primary_dealership_id` FOREIGN KEY (`primary_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ADD CONSTRAINT `fk_aftersales_vehicle_warranty_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ADD CONSTRAINT `fk_aftersales_vehicle_warranty_vehicle_dealer_dealership_id` FOREIGN KEY (`vehicle_dealer_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_primary_dealership_id` FOREIGN KEY (`primary_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_parts_order` ADD CONSTRAINT `fk_aftersales_aftersales_parts_order_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract` ADD CONSTRAINT `fk_aftersales_service_contract_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract` ADD CONSTRAINT `fk_aftersales_service_contract_primary_service_dealership_id` FOREIGN KEY (`primary_service_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract` ADD CONSTRAINT `fk_aftersales_service_contract_service_transfer_to_dealer_dealership_id` FOREIGN KEY (`service_transfer_to_dealer_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract_claim` ADD CONSTRAINT `fk_aftersales_service_contract_claim_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract_claim` ADD CONSTRAINT `fk_aftersales_service_contract_claim_service_dealer_dealership_id` FOREIGN KEY (`service_dealer_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`goodwill_adjustment` ADD CONSTRAINT `fk_aftersales_goodwill_adjustment_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`goodwill_adjustment` ADD CONSTRAINT `fk_aftersales_goodwill_adjustment_primary_dealership_id` FOREIGN KEY (`primary_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ADD CONSTRAINT `fk_aftersales_service_center_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_return` ADD CONSTRAINT `fk_aftersales_parts_return_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_return` ADD CONSTRAINT `fk_aftersales_parts_return_primary_parts_dealership_id` FOREIGN KEY (`primary_parts_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`customer_satisfaction_survey` ADD CONSTRAINT `fk_aftersales_customer_satisfaction_survey_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`customer_satisfaction_survey` ADD CONSTRAINT `fk_aftersales_customer_satisfaction_survey_primary_dealership_id` FOREIGN KEY (`primary_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_parts_return` ADD CONSTRAINT `fk_aftersales_warranty_parts_return_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_parts_return` ADD CONSTRAINT `fk_aftersales_warranty_parts_return_warranty_dealer_dealership_id` FOREIGN KEY (`warranty_dealer_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= aftersales --> engineering (12 constraint(s)) =========
-- Requires: aftersales schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`feature_content` ADD CONSTRAINT `fk_aftersales_feature_content_design_specification_id` FOREIGN KEY (`design_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`design_specification`(`design_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_change_id` FOREIGN KEY (`change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_change_id` FOREIGN KEY (`change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ADD CONSTRAINT `fk_aftersales_warranty_policy_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ADD CONSTRAINT `fk_aftersales_service_campaign_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`tsb` ADD CONSTRAINT `fk_aftersales_tsb_design_specification_id` FOREIGN KEY (`design_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`design_specification`(`design_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ADD CONSTRAINT `fk_aftersales_service_part_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract` ADD CONSTRAINT `fk_aftersales_service_contract_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract_claim` ADD CONSTRAINT `fk_aftersales_service_contract_claim_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_return` ADD CONSTRAINT `fk_aftersales_parts_return_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_parts_return` ADD CONSTRAINT `fk_aftersales_warranty_parts_return_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);

-- ========= aftersales --> field_services (10 constraint(s)) =========
-- Requires: aftersales schema, field_services schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_field_technician_dispatch_id` FOREIGN KEY (`field_technician_dispatch_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_technician_dispatch`(`field_technician_dispatch_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_mobile_service_order_id` FOREIGN KEY (`mobile_service_order_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`mobile_service_order`(`mobile_service_order_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_field_failure_analysis_id` FOREIGN KEY (`field_failure_analysis_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_failure_analysis`(`field_failure_analysis_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_field_quality_investigation_id` FOREIGN KEY (`field_quality_investigation_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_quality_investigation`(`field_quality_investigation_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ADD CONSTRAINT `fk_aftersales_service_campaign_field_quality_investigation_id` FOREIGN KEY (`field_quality_investigation_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_quality_investigation`(`field_quality_investigation_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ADD CONSTRAINT `fk_aftersales_service_part_field_parts_usage_id` FOREIGN KEY (`field_parts_usage_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_parts_usage`(`field_parts_usage_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ADD CONSTRAINT `fk_aftersales_technician_field_technician_dispatch_id` FOREIGN KEY (`field_technician_dispatch_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_technician_dispatch`(`field_technician_dispatch_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_pdi_inspection` ADD CONSTRAINT `fk_aftersales_aftersales_pdi_inspection_field_visit_id` FOREIGN KEY (`field_visit_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_visit`(`field_visit_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_appointment` ADD CONSTRAINT `fk_aftersales_service_appointment_field_technician_dispatch_id` FOREIGN KEY (`field_technician_dispatch_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_technician_dispatch`(`field_technician_dispatch_id`);

-- ========= aftersales --> finance (20 constraint(s)) =========
-- Requires: aftersales schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`fleet_spec` ADD CONSTRAINT `fk_aftersales_fleet_spec_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`fleet_spec` ADD CONSTRAINT `fk_aftersales_fleet_spec_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`product_lifecycle_event` ADD CONSTRAINT `fk_aftersales_product_lifecycle_event_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`product_lifecycle_event` ADD CONSTRAINT `fk_aftersales_product_lifecycle_event_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_warranty_reserve_id` FOREIGN KEY (`warranty_reserve_id`) REFERENCES `vibe_automotive_v1`.`finance`.`warranty_reserve`(`warranty_reserve_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_parts_order` ADD CONSTRAINT `fk_aftersales_aftersales_parts_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_parts_order` ADD CONSTRAINT `fk_aftersales_aftersales_parts_order_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_parts_order` ADD CONSTRAINT `fk_aftersales_aftersales_parts_order_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract` ADD CONSTRAINT `fk_aftersales_service_contract_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract` ADD CONSTRAINT `fk_aftersales_service_contract_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract` ADD CONSTRAINT `fk_aftersales_service_contract_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract_claim` ADD CONSTRAINT `fk_aftersales_service_contract_claim_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract_claim` ADD CONSTRAINT `fk_aftersales_service_contract_claim_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract_claim` ADD CONSTRAINT `fk_aftersales_service_contract_claim_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_return` ADD CONSTRAINT `fk_aftersales_parts_return_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`loaner_assignment` ADD CONSTRAINT `fk_aftersales_loaner_assignment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= aftersales --> inventory (4 constraint(s)) =========
-- Requires: aftersales schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_batch_record_id` FOREIGN KEY (`batch_record_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`batch_record`(`batch_record_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);

-- ========= aftersales --> logistics (2 constraint(s)) =========
-- Requires: aftersales schema, logistics schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_pdi_inspection` ADD CONSTRAINT `fk_aftersales_aftersales_pdi_inspection_logistics_pdi_inspection_id` FOREIGN KEY (`logistics_pdi_inspection_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`logistics_pdi_inspection`(`logistics_pdi_inspection_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`order_shipment` ADD CONSTRAINT `fk_aftersales_order_shipment_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);

-- ========= aftersales --> manufacturing (2 constraint(s)) =========
-- Requires: aftersales schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`program_milestone` ADD CONSTRAINT `fk_aftersales_program_milestone_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);

-- ========= aftersales --> mobility (7 constraint(s)) =========
-- Requires: aftersales schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_remote_diagnostic_session_id` FOREIGN KEY (`remote_diagnostic_session_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session`(`remote_diagnostic_session_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_dtc_event` ADD CONSTRAINT `fk_aftersales_aftersales_dtc_event_mobility_dtc_event_id` FOREIGN KEY (`mobility_dtc_event_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_dtc_event`(`mobility_dtc_event_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract` ADD CONSTRAINT `fk_aftersales_service_contract_mobility_service_id` FOREIGN KEY (`mobility_service_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_service`(`mobility_service_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ADD CONSTRAINT `fk_aftersales_service_center_geofence_id` FOREIGN KEY (`geofence_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`geofence`(`geofence_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_appointment` ADD CONSTRAINT `fk_aftersales_service_appointment_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);

-- ========= aftersales --> procurement (9 constraint(s)) =========
-- Requires: aftersales schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ADD CONSTRAINT `fk_aftersales_service_part_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_order_line` ADD CONSTRAINT `fk_aftersales_parts_order_line_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract` ADD CONSTRAINT `fk_aftersales_service_contract_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`parts_return` ADD CONSTRAINT `fk_aftersales_parts_return_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_parts_return` ADD CONSTRAINT `fk_aftersales_warranty_parts_return_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);

-- ========= aftersales --> product (16 constraint(s)) =========
-- Requires: aftersales schema, product schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`feature_content` ADD CONSTRAINT `fk_aftersales_feature_content_aftersales_trim_level_id` FOREIGN KEY (`aftersales_trim_level_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_trim_level`(`aftersales_trim_level_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`program_milestone` ADD CONSTRAINT `fk_aftersales_program_milestone_aftersales_model_year_program_id` FOREIGN KEY (`aftersales_model_year_program_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_model_year_program`(`aftersales_model_year_program_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`program_milestone` ADD CONSTRAINT `fk_aftersales_program_milestone_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`product_engineering_change` ADD CONSTRAINT `fk_aftersales_product_engineering_change_aftersales_model_year_program_id` FOREIGN KEY (`aftersales_model_year_program_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_model_year_program`(`aftersales_model_year_program_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`option_constraint` ADD CONSTRAINT `fk_aftersales_option_constraint_aftersales_trim_level_id` FOREIGN KEY (`aftersales_trim_level_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_trim_level`(`aftersales_trim_level_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`option_constraint` ADD CONSTRAINT `fk_aftersales_option_constraint_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`option_constraint` ADD CONSTRAINT `fk_aftersales_option_constraint_aftersales_option_package_id` FOREIGN KEY (`aftersales_option_package_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_option_package`(`aftersales_option_package_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`option_constraint` ADD CONSTRAINT `fk_aftersales_option_constraint_target_option_aftersales_option_package_id` FOREIGN KEY (`target_option_aftersales_option_package_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_option_package`(`aftersales_option_package_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`option_constraint` ADD CONSTRAINT `fk_aftersales_option_constraint_target_option_option_package_aftersales_option_package_id` FOREIGN KEY (`target_option_option_package_aftersales_option_package_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_option_package`(`aftersales_option_package_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`fleet_spec` ADD CONSTRAINT `fk_aftersales_fleet_spec_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`product_lifecycle_event` ADD CONSTRAINT `fk_aftersales_product_lifecycle_event_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`warranty_policy` ADD CONSTRAINT `fk_aftersales_warranty_policy_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_campaign` ADD CONSTRAINT `fk_aftersales_service_campaign_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`labor_time_standard` ADD CONSTRAINT `fk_aftersales_labor_time_standard_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`recall_coverage` ADD CONSTRAINT `fk_aftersales_recall_coverage_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`rebate_coverage` ADD CONSTRAINT `fk_aftersales_rebate_coverage_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);

-- ========= aftersales --> quality (1 constraint(s)) =========
-- Requires: aftersales schema, quality schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_defect_record_id` FOREIGN KEY (`defect_record_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_record`(`defect_record_id`);

-- ========= aftersales --> sales (3 constraint(s)) =========
-- Requires: aftersales schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`contract`(`contract_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract` ADD CONSTRAINT `fk_aftersales_service_contract_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `vibe_automotive_v1`.`sales`.`contract`(`contract_id`);

-- ========= aftersales --> supply (2 constraint(s)) =========
-- Requires: aftersales schema, supply schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`repair_order_line` ADD CONSTRAINT `fk_aftersales_repair_order_line_inbound_part_id` FOREIGN KEY (`inbound_part_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_part`(`inbound_part_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_part` ADD CONSTRAINT `fk_aftersales_service_part_inbound_part_id` FOREIGN KEY (`inbound_part_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_part`(`inbound_part_id`);

-- ========= aftersales --> vehicle (7 constraint(s)) =========
-- Requires: aftersales schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`vehicle_warranty` ADD CONSTRAINT `fk_aftersales_vehicle_warranty_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`campaign_vin` ADD CONSTRAINT `fk_aftersales_campaign_vin_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract` ADD CONSTRAINT `fk_aftersales_service_contract_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`loaner_vehicle` ADD CONSTRAINT `fk_aftersales_loaner_vehicle_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);

-- ========= aftersales --> workforce (14 constraint(s)) =========
-- Requires: aftersales schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`program_milestone` ADD CONSTRAINT `fk_aftersales_program_milestone_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`program_milestone` ADD CONSTRAINT `fk_aftersales_program_milestone_program_responsible_person_employee_id` FOREIGN KEY (`program_responsible_person_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`product_engineering_change` ADD CONSTRAINT `fk_aftersales_product_engineering_change_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`fleet_spec` ADD CONSTRAINT `fk_aftersales_fleet_spec_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`fleet_spec` ADD CONSTRAINT `fk_aftersales_fleet_spec_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`product_lifecycle_event` ADD CONSTRAINT `fk_aftersales_product_lifecycle_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order` ADD CONSTRAINT `fk_aftersales_aftersales_repair_order_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim` ADD CONSTRAINT `fk_aftersales_aftersales_warranty_claim_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment` ADD CONSTRAINT `fk_aftersales_aftersales_service_appointment_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_contract_claim` ADD CONSTRAINT `fk_aftersales_service_contract_claim_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`service_center` ADD CONSTRAINT `fk_aftersales_service_center_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`aftersales`.`technician` ADD CONSTRAINT `fk_aftersales_technician_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= asset --> compliance (5 constraint(s)) =========
-- Requires: asset schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ADD CONSTRAINT `fk_asset_functional_location_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ADD CONSTRAINT `fk_asset_maintenance_order_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`compliance_assessment` ADD CONSTRAINT `fk_asset_compliance_assessment_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ADD CONSTRAINT `fk_asset_asset_class_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);

-- ========= asset --> customer (2 constraint(s)) =========
-- Requires: asset schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ADD CONSTRAINT `fk_asset_maintenance_order_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ADD CONSTRAINT `fk_asset_acquisition_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= asset --> finance (11 constraint(s)) =========
-- Requires: asset schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ADD CONSTRAINT `fk_asset_equipment_registry_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`functional_location` ADD CONSTRAINT `fk_asset_functional_location_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ADD CONSTRAINT `fk_asset_maintenance_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ADD CONSTRAINT `fk_asset_equipment_downtime_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ADD CONSTRAINT `fk_asset_spare_parts_catalog_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ADD CONSTRAINT `fk_asset_acquisition_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_valuation` ADD CONSTRAINT `fk_asset_asset_valuation_finance_inventory_valuation_id` FOREIGN KEY (`finance_inventory_valuation_id`) REFERENCES `vibe_automotive_v1`.`finance`.`finance_inventory_valuation`(`finance_inventory_valuation_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_cost` ADD CONSTRAINT `fk_asset_maintenance_cost_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ADD CONSTRAINT `fk_asset_maintenance_work_center_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ADD CONSTRAINT `fk_asset_lubrication_schedule_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_class` ADD CONSTRAINT `fk_asset_asset_class_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= asset --> manufacturing (8 constraint(s)) =========
-- Requires: asset schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ADD CONSTRAINT `fk_asset_maintenance_order_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ADD CONSTRAINT `fk_asset_equipment_downtime_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ADD CONSTRAINT `fk_asset_equipment_downtime_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ADD CONSTRAINT `fk_asset_condition_monitoring_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`asset_tooling_usage` ADD CONSTRAINT `fk_asset_asset_tooling_usage_manufacturing_tooling_usage_id` FOREIGN KEY (`manufacturing_tooling_usage_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`manufacturing_tooling_usage`(`manufacturing_tooling_usage_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);

-- ========= asset --> mobility (1 constraint(s)) =========
-- Requires: asset schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_service_subscription` ADD CONSTRAINT `fk_asset_equipment_service_subscription_mobility_service_id` FOREIGN KEY (`mobility_service_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_service`(`mobility_service_id`);

-- ========= asset --> procurement (3 constraint(s)) =========
-- Requires: asset schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ADD CONSTRAINT `fk_asset_acquisition_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`acquisition` ADD CONSTRAINT `fk_asset_acquisition_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`warranty_claim_equipment` ADD CONSTRAINT `fk_asset_warranty_claim_equipment_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);

-- ========= asset --> product (6 constraint(s)) =========
-- Requires: asset schema, product schema
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ADD CONSTRAINT `fk_asset_tooling_registry_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ADD CONSTRAINT `fk_asset_maintenance_order_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ADD CONSTRAINT `fk_asset_equipment_downtime_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ADD CONSTRAINT `fk_asset_equipment_transfer_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);

-- ========= asset --> supply (4 constraint(s)) =========
-- Requires: asset schema, supply schema
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_registry` ADD CONSTRAINT `fk_asset_equipment_registry_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`tooling_registry` ADD CONSTRAINT `fk_asset_tooling_registry_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`spare_parts_catalog` ADD CONSTRAINT `fk_asset_spare_parts_catalog_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ADD CONSTRAINT `fk_asset_lubrication_schedule_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);

-- ========= asset --> workforce (22 constraint(s)) =========
-- Requires: asset schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ADD CONSTRAINT `fk_asset_maintenance_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ADD CONSTRAINT `fk_asset_maintenance_order_approver_id` FOREIGN KEY (`approver_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ADD CONSTRAINT `fk_asset_maintenance_order_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_order` ADD CONSTRAINT `fk_asset_maintenance_order_primary_maintenance_employee_id` FOREIGN KEY (`primary_maintenance_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ADD CONSTRAINT `fk_asset_maintenance_notification_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_notification` ADD CONSTRAINT `fk_asset_maintenance_notification_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ADD CONSTRAINT `fk_asset_equipment_downtime_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_downtime` ADD CONSTRAINT `fk_asset_equipment_downtime_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ADD CONSTRAINT `fk_asset_condition_monitoring_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`condition_monitoring` ADD CONSTRAINT `fk_asset_condition_monitoring_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ADD CONSTRAINT `fk_asset_equipment_transfer_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`equipment_transfer` ADD CONSTRAINT `fk_asset_equipment_transfer_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ADD CONSTRAINT `fk_asset_maintenance_work_center_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`maintenance_work_center` ADD CONSTRAINT `fk_asset_maintenance_work_center_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`inspection` ADD CONSTRAINT `fk_asset_inspection_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ADD CONSTRAINT `fk_asset_shutdown_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`shutdown_plan` ADD CONSTRAINT `fk_asset_shutdown_plan_shutdown_project_manager_employee_id` FOREIGN KEY (`shutdown_project_manager_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ADD CONSTRAINT `fk_asset_lubrication_schedule_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`asset`.`lubrication_schedule` ADD CONSTRAINT `fk_asset_lubrication_schedule_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= billing --> aftersales (5 constraint(s)) =========
-- Requires: billing schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_service_contract_id` FOREIGN KEY (`service_contract_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_contract`(`service_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_aftersales_service_appointment_id` FOREIGN KEY (`aftersales_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment`(`aftersales_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_repair_order_line_id` FOREIGN KEY (`repair_order_line_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`repair_order_line`(`repair_order_line_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_service_contract_claim_id` FOREIGN KEY (`service_contract_claim_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_contract_claim`(`service_contract_claim_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_aftersales_warranty_claim_id` FOREIGN KEY (`aftersales_warranty_claim_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim`(`aftersales_warranty_claim_id`);

-- ========= billing --> asset (2 constraint(s)) =========
-- Requires: billing schema, asset schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_maintenance_order_id` FOREIGN KEY (`maintenance_order_id`) REFERENCES `vibe_automotive_v1`.`asset`.`maintenance_order`(`maintenance_order_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);

-- ========= billing --> compliance (7 constraint(s)) =========
-- Requires: billing schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_homologation_record_id` FOREIGN KEY (`homologation_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_record`(`homologation_record_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_recall_campaign_id` FOREIGN KEY (`recall_campaign_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`recall_campaign`(`recall_campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ADD CONSTRAINT `fk_billing_account_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_price_condition` ADD CONSTRAINT `fk_billing_billing_price_condition_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ADD CONSTRAINT `fk_billing_rebate_agreement_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ADD CONSTRAINT `fk_billing_parts_service_charge_recall_campaign_id` FOREIGN KEY (`recall_campaign_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`recall_campaign`(`recall_campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_recall_campaign_id` FOREIGN KEY (`recall_campaign_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`recall_campaign`(`recall_campaign_id`);

-- ========= billing --> customer (15 constraint(s)) =========
-- Requires: billing schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ADD CONSTRAINT `fk_billing_account_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`fleet_statement` ADD CONSTRAINT `fk_billing_fleet_statement_customer_fleet_account_id` FOREIGN KEY (`customer_fleet_account_id`) REFERENCES `vibe_automotive_v1`.`customer`.`customer_fleet_account`(`customer_fleet_account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_rebate_customer_party_id` FOREIGN KEY (`rebate_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_write_customer_party_id` FOREIGN KEY (`write_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= billing --> dealer (14 constraint(s)) =========
-- Requires: billing schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_primary_dealership_id` FOREIGN KEY (`primary_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_dealer_incentive_program_id` FOREIGN KEY (`dealer_incentive_program_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_incentive_program`(`dealer_incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_primary_dealership_id` FOREIGN KEY (`primary_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ADD CONSTRAINT `fk_billing_debit_memo_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ADD CONSTRAINT `fk_billing_debit_memo_primary_debit_dealership_id` FOREIGN KEY (`primary_debit_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ADD CONSTRAINT `fk_billing_dealer_statement_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_rebate_dealer_dealership_id` FOREIGN KEY (`rebate_dealer_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_write_dealer_dealership_id` FOREIGN KEY (`write_dealer_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_primary_dealership_id` FOREIGN KEY (`primary_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= billing --> engineering (3 constraint(s)) =========
-- Requires: billing schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_agreement` ADD CONSTRAINT `fk_billing_rebate_agreement_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= billing --> finance (16 constraint(s)) =========
-- Requires: billing schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ADD CONSTRAINT `fk_billing_debit_memo_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ADD CONSTRAINT `fk_billing_account_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`account` ADD CONSTRAINT `fk_billing_account_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);

-- ========= billing --> logistics (1 constraint(s)) =========
-- Requires: billing schema, logistics schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);

-- ========= billing --> mobility (1 constraint(s)) =========
-- Requires: billing schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_service_subscription_id` FOREIGN KEY (`service_subscription_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`service_subscription`(`service_subscription_id`);

-- ========= billing --> product (2 constraint(s)) =========
-- Requires: billing schema, product schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);

-- ========= billing --> sales (2 constraint(s)) =========
-- Requires: billing schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_rep_id` FOREIGN KEY (`rep_id`) REFERENCES `vibe_automotive_v1`.`sales`.`rep`(`rep_id`);

-- ========= billing --> supply (1 constraint(s)) =========
-- Requires: billing schema, supply schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_supply_po_line_id` FOREIGN KEY (`supply_po_line_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_po_line`(`supply_po_line_id`);

-- ========= billing --> vehicle (9 constraint(s)) =========
-- Requires: billing schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`debit_memo` ADD CONSTRAINT `fk_billing_debit_memo_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`intercompany_invoice` ADD CONSTRAINT `fk_billing_intercompany_invoice_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ADD CONSTRAINT `fk_billing_parts_service_charge_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ADD CONSTRAINT `fk_billing_advance_payment_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);

-- ========= billing --> workforce (33 constraint(s)) =========
-- Requires: billing schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_invoice_line` ADD CONSTRAINT `fk_billing_billing_invoice_line_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_primary_payment_employee_id` FOREIGN KEY (`primary_payment_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`credit_memo` ADD CONSTRAINT `fk_billing_credit_memo_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ADD CONSTRAINT `fk_billing_receivable_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`receivable` ADD CONSTRAINT `fk_billing_receivable_receivable_collector_employee_id` FOREIGN KEY (`receivable_collector_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ADD CONSTRAINT `fk_billing_dealer_statement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`dealer_statement` ADD CONSTRAINT `fk_billing_dealer_statement_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ADD CONSTRAINT `fk_billing_dunning_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`dunning_record` ADD CONSTRAINT `fk_billing_dunning_record_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_primary_rebate_employee_id` FOREIGN KEY (`primary_rebate_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_rebate_created_by_user_employee_id` FOREIGN KEY (`rebate_created_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_rebate_updated_by_user_employee_id` FOREIGN KEY (`rebate_updated_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`rebate_accrual` ADD CONSTRAINT `fk_billing_rebate_accrual_tertiary_rebate_updated_by_user_employee_id` FOREIGN KEY (`tertiary_rebate_updated_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_write_approval_authority_employee_id` FOREIGN KEY (`write_approval_authority_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ADD CONSTRAINT `fk_billing_parts_service_charge_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`parts_service_charge` ADD CONSTRAINT `fk_billing_parts_service_charge_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`advance_payment` ADD CONSTRAINT `fk_billing_advance_payment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ADD CONSTRAINT `fk_billing_billing_run_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ADD CONSTRAINT `fk_billing_billing_run_billing_run_approved_by_user_employee_id` FOREIGN KEY (`billing_run_approved_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ADD CONSTRAINT `fk_billing_billing_run_billing_run_employee_id` FOREIGN KEY (`billing_run_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_run` ADD CONSTRAINT `fk_billing_billing_run_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_billing_block_released_by_user_employee_id` FOREIGN KEY (`billing_block_released_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_billing_released_by_user_employee_id` FOREIGN KEY (`billing_released_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= compliance --> asset (4 constraint(s)) =========
-- Requires: compliance schema, asset schema
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` ADD CONSTRAINT `fk_compliance_compliance_emissions_certification_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ADD CONSTRAINT `fk_compliance_test_event_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ADD CONSTRAINT `fk_compliance_compliance_test_result_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ADD CONSTRAINT `fk_compliance_compliance_test_result_primary_equipment_registry_id` FOREIGN KEY (`primary_equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);

-- ========= compliance --> customer (2 constraint(s)) =========
-- Requires: compliance schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ADD CONSTRAINT `fk_compliance_recall_defect_report_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`zev_credit` ADD CONSTRAINT `fk_compliance_zev_credit_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= compliance --> engineering (3 constraint(s)) =========
-- Requires: compliance schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_campaign` ADD CONSTRAINT `fk_compliance_recall_campaign_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_test_result` ADD CONSTRAINT `fk_compliance_compliance_test_result_engineering_test_result_id` FOREIGN KEY (`engineering_test_result_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`engineering_test_result`(`engineering_test_result_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= compliance --> manufacturing (3 constraint(s)) =========
-- Requires: compliance schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ADD CONSTRAINT `fk_compliance_environmental_permit_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`environmental_permit` ADD CONSTRAINT `fk_compliance_environmental_permit_primary_environmental_plant_id` FOREIGN KEY (`primary_environmental_plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`social_compliance_audit` ADD CONSTRAINT `fk_compliance_social_compliance_audit_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);

-- ========= compliance --> mobility (2 constraint(s)) =========
-- Requires: compliance schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ADD CONSTRAINT `fk_compliance_regulatory_submission_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ADD CONSTRAINT `fk_compliance_test_event_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);

-- ========= compliance --> procurement (1 constraint(s)) =========
-- Requires: compliance schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`compliance`.`trade_compliance_record` ADD CONSTRAINT `fk_compliance_trade_compliance_record_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);

-- ========= compliance --> product (6 constraint(s)) =========
-- Requires: compliance schema, product schema
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ADD CONSTRAINT `fk_compliance_regulatory_submission_aftersales_model_year_program_id` FOREIGN KEY (`aftersales_model_year_program_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_model_year_program`(`aftersales_model_year_program_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_campaign` ADD CONSTRAINT `fk_compliance_recall_campaign_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ADD CONSTRAINT `fk_compliance_recall_defect_report_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ADD CONSTRAINT `fk_compliance_homologation_variant_aftersales_trim_level_id` FOREIGN KEY (`aftersales_trim_level_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_trim_level`(`aftersales_trim_level_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ADD CONSTRAINT `fk_compliance_homologation_variant_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_variant` ADD CONSTRAINT `fk_compliance_homologation_variant_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);

-- ========= compliance --> quality (1 constraint(s)) =========
-- Requires: compliance schema, quality schema
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_corrective_action` ADD CONSTRAINT `fk_compliance_compliance_corrective_action_quality_corrective_action_id` FOREIGN KEY (`quality_corrective_action_id`) REFERENCES `vibe_automotive_v1`.`quality`.`quality_corrective_action`(`quality_corrective_action_id`);

-- ========= compliance --> vehicle (6 constraint(s)) =========
-- Requires: compliance schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`compliance`.`homologation_record` ADD CONSTRAINT `fk_compliance_homologation_record_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification` ADD CONSTRAINT `fk_compliance_compliance_emissions_certification_powertrain_variant_id` FOREIGN KEY (`powertrain_variant_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`powertrain_variant`(`powertrain_variant_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`cafe_compliance_record` ADD CONSTRAINT `fk_compliance_cafe_compliance_record_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ADD CONSTRAINT `fk_compliance_regulatory_submission_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ADD CONSTRAINT `fk_compliance_test_event_homologation_id` FOREIGN KEY (`homologation_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`homologation`(`homologation_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`recall_defect_report` ADD CONSTRAINT `fk_compliance_recall_defect_report_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);

-- ========= compliance --> workforce (8 constraint(s)) =========
-- Requires: compliance schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ADD CONSTRAINT `fk_compliance_regulatory_submission_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_submission` ADD CONSTRAINT `fk_compliance_regulatory_submission_regulatory_compliance_officer_employee_id` FOREIGN KEY (`regulatory_compliance_officer_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`test_event` ADD CONSTRAINT `fk_compliance_test_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ADD CONSTRAINT `fk_compliance_fmvss_certification_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`fmvss_certification` ADD CONSTRAINT `fk_compliance_fmvss_certification_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ADD CONSTRAINT `fk_compliance_regulatory_change_notice_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`compliance`.`regulatory_change_notice` ADD CONSTRAINT `fk_compliance_regulatory_change_notice_regulatory_compliance_owner_employee_id` FOREIGN KEY (`regulatory_compliance_owner_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= customer --> aftersales (1 constraint(s)) =========
-- Requires: customer schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ADD CONSTRAINT `fk_customer_pdi_record_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`technician`(`technician_id`);

-- ========= customer --> billing (1 constraint(s)) =========
-- Requires: customer schema, billing schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ADD CONSTRAINT `fk_customer_connected_service_enrollment_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);

-- ========= customer --> dealer (5 constraint(s)) =========
-- Requires: customer schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ADD CONSTRAINT `fk_customer_individual_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ADD CONSTRAINT `fk_customer_individual_primary_dealership_id` FOREIGN KEY (`primary_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`individual` ADD CONSTRAINT `fk_customer_individual_dealer_contact_id` FOREIGN KEY (`dealer_contact_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_contact`(`dealer_contact_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ADD CONSTRAINT `fk_customer_vehicle_ownership_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ADD CONSTRAINT `fk_customer_dealer_customer_link_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= customer --> engineering (1 constraint(s)) =========
-- Requires: customer schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ADD CONSTRAINT `fk_customer_vehicle_ownership_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= customer --> field_services (1 constraint(s)) =========
-- Requires: customer schema, field_services schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_roadside_assistance_case_id` FOREIGN KEY (`roadside_assistance_case_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`roadside_assistance_case`(`roadside_assistance_case_id`);

-- ========= customer --> mobility (2 constraint(s)) =========
-- Requires: customer schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ADD CONSTRAINT `fk_customer_vehicle_ownership_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ADD CONSTRAINT `fk_customer_vehicle_ownership_telematics_device_id` FOREIGN KEY (`telematics_device_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`telematics_device`(`telematics_device_id`);

-- ========= customer --> product (1 constraint(s)) =========
-- Requires: customer schema, product schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_segment` ADD CONSTRAINT `fk_customer_customer_segment_product_segment_id` FOREIGN KEY (`product_segment_id`) REFERENCES `vibe_automotive_v1`.`product`.`product_segment`(`product_segment_id`);

-- ========= customer --> sales (5 constraint(s)) =========
-- Requires: customer schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ADD CONSTRAINT `fk_customer_vehicle_ownership_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ADD CONSTRAINT `fk_customer_journey_touchpoint_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_automotive_v1`.`sales`.`campaign`(`campaign_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ADD CONSTRAINT `fk_customer_journey_touchpoint_activity_id` FOREIGN KEY (`activity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`activity`(`activity_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_test_drive` ADD CONSTRAINT `fk_customer_customer_test_drive_sales_test_drive_id` FOREIGN KEY (`sales_test_drive_id`) REFERENCES `vibe_automotive_v1`.`sales`.`sales_test_drive`(`sales_test_drive_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ADD CONSTRAINT `fk_customer_promotion_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `vibe_automotive_v1`.`sales`.`campaign`(`campaign_id`);

-- ========= customer --> vehicle (6 constraint(s)) =========
-- Requires: customer schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`vehicle_ownership` ADD CONSTRAINT `fk_customer_vehicle_ownership_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ADD CONSTRAINT `fk_customer_journey_touchpoint_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_vehicle_assignment` ADD CONSTRAINT `fk_customer_customer_fleet_vehicle_assignment_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`pdi_record` ADD CONSTRAINT `fk_customer_pdi_record_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ADD CONSTRAINT `fk_customer_connected_service_enrollment_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);

-- ========= customer --> workforce (15 constraint(s)) =========
-- Requires: customer schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_membership` ADD CONSTRAINT `fk_customer_loyalty_membership_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`loyalty_transaction` ADD CONSTRAINT `fk_customer_loyalty_transaction_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ADD CONSTRAINT `fk_customer_journey_touchpoint_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`journey_touchpoint` ADD CONSTRAINT `fk_customer_journey_touchpoint_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_account` ADD CONSTRAINT `fk_customer_customer_fleet_account_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`customer_fleet_vehicle_assignment` ADD CONSTRAINT `fk_customer_customer_fleet_vehicle_assignment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`communication_subscription` ADD CONSTRAINT `fk_customer_communication_subscription_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`party_relationship` ADD CONSTRAINT `fk_customer_party_relationship_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`connected_service_enrollment` ADD CONSTRAINT `fk_customer_connected_service_enrollment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`privacy_request` ADD CONSTRAINT `fk_customer_privacy_request_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`dealer_customer_link` ADD CONSTRAINT `fk_customer_dealer_customer_link_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ADD CONSTRAINT `fk_customer_promotion_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`customer`.`promotion` ADD CONSTRAINT `fk_customer_promotion_promotion_updated_by_user_employee_id` FOREIGN KEY (`promotion_updated_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= dealer --> aftersales (4 constraint(s)) =========
-- Requires: dealer schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_service_appointment` ADD CONSTRAINT `fk_dealer_dealer_service_appointment_aftersales_service_appointment_id` FOREIGN KEY (`aftersales_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_service_appointment`(`aftersales_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_repair_order` ADD CONSTRAINT `fk_dealer_dealer_repair_order_aftersales_repair_order_id` FOREIGN KEY (`aftersales_repair_order_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order`(`aftersales_repair_order_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_parts_order` ADD CONSTRAINT `fk_dealer_dealer_parts_order_aftersales_parts_order_id` FOREIGN KEY (`aftersales_parts_order_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_parts_order`(`aftersales_parts_order_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_warranty_claim` ADD CONSTRAINT `fk_dealer_dealer_warranty_claim_aftersales_warranty_claim_id` FOREIGN KEY (`aftersales_warranty_claim_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim`(`aftersales_warranty_claim_id`);

-- ========= dealer --> asset (1 constraint(s)) =========
-- Requires: dealer schema, asset schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ADD CONSTRAINT `fk_dealer_parts_inventory_spare_parts_catalog_id` FOREIGN KEY (`spare_parts_catalog_id`) REFERENCES `vibe_automotive_v1`.`asset`.`spare_parts_catalog`(`spare_parts_catalog_id`);

-- ========= dealer --> billing (2 constraint(s)) =========
-- Requires: dealer schema, billing schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ADD CONSTRAINT `fk_dealer_dealership_account_id` FOREIGN KEY (`account_id`) REFERENCES `vibe_automotive_v1`.`billing`.`account`(`account_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ADD CONSTRAINT `fk_dealer_dealership_payment_term_id` FOREIGN KEY (`payment_term_id`) REFERENCES `vibe_automotive_v1`.`billing`.`payment_term`(`payment_term_id`);

-- ========= dealer --> compliance (3 constraint(s)) =========
-- Requires: dealer schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_certification` ADD CONSTRAINT `fk_dealer_dealer_certification_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_homologation_record_id` FOREIGN KEY (`homologation_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_record`(`homologation_record_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_region` ADD CONSTRAINT `fk_dealer_dealer_region_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);

-- ========= dealer --> customer (11 constraint(s)) =========
-- Requires: dealer schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_retail_customer_party_id` FOREIGN KEY (`retail_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ADD CONSTRAINT `fk_dealer_csi_survey_individual_id` FOREIGN KEY (`individual_id`) REFERENCES `vibe_automotive_v1`.`customer`.`individual`(`individual_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ADD CONSTRAINT `fk_dealer_csi_survey_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` ADD CONSTRAINT `fk_dealer_dealer_test_drive_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ADD CONSTRAINT `fk_dealer_recall_completion_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ADD CONSTRAINT `fk_dealer_recall_completion_recall_customer_party_id` FOREIGN KEY (`recall_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ADD CONSTRAINT `fk_dealer_used_vehicle_appraisal_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ADD CONSTRAINT `fk_dealer_used_vehicle_appraisal_used_customer_party_id` FOREIGN KEY (`used_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ADD CONSTRAINT `fk_dealer_dealer_order_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ADD CONSTRAINT `fk_dealer_dealer_order_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= dealer --> engineering (1 constraint(s)) =========
-- Requires: dealer schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ADD CONSTRAINT `fk_dealer_dealer_incentive_program_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= dealer --> finance (2 constraint(s)) =========
-- Requires: dealer schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ADD CONSTRAINT `fk_dealer_dealership_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership` ADD CONSTRAINT `fk_dealer_dealership_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= dealer --> inventory (2 constraint(s)) =========
-- Requires: dealer schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_finished_vehicle_stock_id` FOREIGN KEY (`finished_vehicle_stock_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock`(`finished_vehicle_stock_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ADD CONSTRAINT `fk_dealer_parts_inventory_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);

-- ========= dealer --> manufacturing (3 constraint(s)) =========
-- Requires: dealer schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ADD CONSTRAINT `fk_dealer_vehicle_allocation_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_vehicle_build_id` FOREIGN KEY (`vehicle_build_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`vehicle_build`(`vehicle_build_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ADD CONSTRAINT `fk_dealer_dealer_order_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);

-- ========= dealer --> mobility (3 constraint(s)) =========
-- Requires: dealer schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` ADD CONSTRAINT `fk_dealer_dealer_test_drive_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ADD CONSTRAINT `fk_dealer_dealer_order_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);

-- ========= dealer --> procurement (2 constraint(s)) =========
-- Requires: dealer schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ADD CONSTRAINT `fk_dealer_parts_inventory_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ADD CONSTRAINT `fk_dealer_dealer_order_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);

-- ========= dealer --> product (7 constraint(s)) =========
-- Requires: dealer schema, product schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`vehicle_allocation` ADD CONSTRAINT `fk_dealer_vehicle_allocation_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ADD CONSTRAINT `fk_dealer_dealer_incentive_program_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ADD CONSTRAINT `fk_dealer_floor_plan_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ADD CONSTRAINT `fk_dealer_demo_vehicle_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ADD CONSTRAINT `fk_dealer_dealer_order_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);

-- ========= dealer --> quality (1 constraint(s)) =========
-- Requires: dealer schema, quality schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealership_quality_assessment` ADD CONSTRAINT `fk_dealer_dealership_quality_assessment_standard_id` FOREIGN KEY (`standard_id`) REFERENCES `vibe_automotive_v1`.`quality`.`standard`(`standard_id`);

-- ========= dealer --> sales (7 constraint(s)) =========
-- Requires: dealer schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_territory` ADD CONSTRAINT `fk_dealer_dealer_territory_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `vibe_automotive_v1`.`sales`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_program` ADD CONSTRAINT `fk_dealer_dealer_incentive_program_sales_incentive_program_id` FOREIGN KEY (`sales_incentive_program_id`) REFERENCES `vibe_automotive_v1`.`sales`.`sales_incentive_program`(`sales_incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_incentive_claim` ADD CONSTRAINT `fk_dealer_dealer_incentive_claim_sales_incentive_claim_id` FOREIGN KEY (`sales_incentive_claim_id`) REFERENCES `vibe_automotive_v1`.`sales`.`sales_incentive_claim`(`sales_incentive_claim_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` ADD CONSTRAINT `fk_dealer_dealer_test_drive_sales_test_drive_id` FOREIGN KEY (`sales_test_drive_id`) REFERENCES `vibe_automotive_v1`.`sales`.`sales_test_drive`(`sales_test_drive_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ADD CONSTRAINT `fk_dealer_dealer_order_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);

-- ========= dealer --> supply (1 constraint(s)) =========
-- Requires: dealer schema, supply schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`parts_inventory` ADD CONSTRAINT `fk_dealer_parts_inventory_inbound_part_id` FOREIGN KEY (`inbound_part_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_part`(`inbound_part_id`);

-- ========= dealer --> vehicle (7 constraint(s)) =========
-- Requires: dealer schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`csi_survey` ADD CONSTRAINT `fk_dealer_csi_survey_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`floor_plan` ADD CONSTRAINT `fk_dealer_floor_plan_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ADD CONSTRAINT `fk_dealer_demo_vehicle_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ADD CONSTRAINT `fk_dealer_recall_completion_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_order` ADD CONSTRAINT `fk_dealer_dealer_order_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);

-- ========= dealer --> workforce (9 constraint(s)) =========
-- Requires: dealer schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_inventory` ADD CONSTRAINT `fk_dealer_dealer_inventory_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`retail_sale` ADD CONSTRAINT `fk_dealer_retail_sale_retail_salesperson_employee_id` FOREIGN KEY (`retail_salesperson_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ADD CONSTRAINT `fk_dealer_demo_vehicle_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`demo_vehicle` ADD CONSTRAINT `fk_dealer_demo_vehicle_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`dealer_test_drive` ADD CONSTRAINT `fk_dealer_dealer_test_drive_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`recall_completion` ADD CONSTRAINT `fk_dealer_recall_completion_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`facility_standard` ADD CONSTRAINT `fk_dealer_facility_standard_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`dealer`.`used_vehicle_appraisal` ADD CONSTRAINT `fk_dealer_used_vehicle_appraisal_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= engineering --> asset (8 constraint(s)) =========
-- Requires: engineering schema, asset schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_line` ADD CONSTRAINT `fk_engineering_engineering_bom_line_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ADD CONSTRAINT `fk_engineering_change_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ADD CONSTRAINT `fk_engineering_change_tooling_registry_id` FOREIGN KEY (`tooling_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`tooling_registry`(`tooling_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ADD CONSTRAINT `fk_engineering_prototype_build_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ADD CONSTRAINT `fk_engineering_digital_twin_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ADD CONSTRAINT `fk_engineering_milestone_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ADD CONSTRAINT `fk_engineering_fmea_record_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ADD CONSTRAINT `fk_engineering_weight_report_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);

-- ========= engineering --> compliance (5 constraint(s)) =========
-- Requires: engineering schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ADD CONSTRAINT `fk_engineering_part_master_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ADD CONSTRAINT `fk_engineering_design_specification_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`homologation_requirement` ADD CONSTRAINT `fk_engineering_homologation_requirement_homologation_record_id` FOREIGN KEY (`homologation_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_record`(`homologation_record_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ADD CONSTRAINT `fk_engineering_ota_release_ota_compliance_approval_id` FOREIGN KEY (`ota_compliance_approval_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`ota_compliance_approval`(`ota_compliance_approval_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_document` ADD CONSTRAINT `fk_engineering_engineering_document_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);

-- ========= engineering --> dealer (1 constraint(s)) =========
-- Requires: engineering schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dealer_part_inventory` ADD CONSTRAINT `fk_engineering_dealer_part_inventory_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= engineering --> finance (4 constraint(s)) =========
-- Requires: engineering schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ADD CONSTRAINT `fk_engineering_vehicle_program_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ADD CONSTRAINT `fk_engineering_vehicle_program_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ADD CONSTRAINT `fk_engineering_bom_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ADD CONSTRAINT `fk_engineering_part_master_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= engineering --> inventory (1 constraint(s)) =========
-- Requires: engineering schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ADD CONSTRAINT `fk_engineering_bom_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);

-- ========= engineering --> manufacturing (1 constraint(s)) =========
-- Requires: engineering schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_component` ADD CONSTRAINT `fk_engineering_engineering_bom_component_production_bom_id` FOREIGN KEY (`production_bom_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_bom`(`production_bom_id`);

-- ========= engineering --> mobility (1 constraint(s)) =========
-- Requires: engineering schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`digital_twin` ADD CONSTRAINT `fk_engineering_digital_twin_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);

-- ========= engineering --> procurement (1 constraint(s)) =========
-- Requires: engineering schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_bom_line` ADD CONSTRAINT `fk_engineering_engineering_bom_line_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);

-- ========= engineering --> product (1 constraint(s)) =========
-- Requires: engineering schema, product schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ADD CONSTRAINT `fk_engineering_vehicle_program_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);

-- ========= engineering --> supply (3 constraint(s)) =========
-- Requires: engineering schema, supply schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ADD CONSTRAINT `fk_engineering_part_master_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ecu_specification` ADD CONSTRAINT `fk_engineering_ecu_specification_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`material` ADD CONSTRAINT `fk_engineering_material_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);

-- ========= engineering --> workforce (40 constraint(s)) =========
-- Requires: engineering schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`engineering`.`vehicle_program` ADD CONSTRAINT `fk_engineering_vehicle_program_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`bom` ADD CONSTRAINT `fk_engineering_bom_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ADD CONSTRAINT `fk_engineering_part_master_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`part_master` ADD CONSTRAINT `fk_engineering_part_master_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_specification` ADD CONSTRAINT `fk_engineering_design_specification_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ADD CONSTRAINT `fk_engineering_cad_model_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cad_model` ADD CONSTRAINT `fk_engineering_cad_model_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ADD CONSTRAINT `fk_engineering_change_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ADD CONSTRAINT `fk_engineering_change_approver_id` FOREIGN KEY (`approver_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`change` ADD CONSTRAINT `fk_engineering_change_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ADD CONSTRAINT `fk_engineering_cae_simulation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cae_simulation` ADD CONSTRAINT `fk_engineering_cae_simulation_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ADD CONSTRAINT `fk_engineering_prototype_build_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`prototype_build` ADD CONSTRAINT `fk_engineering_prototype_build_prototype_responsible_engineer_employee_id` FOREIGN KEY (`prototype_responsible_engineer_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`validation_test` ADD CONSTRAINT `fk_engineering_validation_test_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ADD CONSTRAINT `fk_engineering_milestone_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ADD CONSTRAINT `fk_engineering_milestone_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ADD CONSTRAINT `fk_engineering_milestone_primary_milestone_employee_id` FOREIGN KEY (`primary_milestone_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`milestone` ADD CONSTRAINT `fk_engineering_milestone_tertiary_milestone_sign_off_authority_employee_id` FOREIGN KEY (`tertiary_milestone_sign_off_authority_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ADD CONSTRAINT `fk_engineering_fmea_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ADD CONSTRAINT `fk_engineering_fmea_record_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`fmea_record` ADD CONSTRAINT `fk_engineering_fmea_record_primary_fmea_employee_id` FOREIGN KEY (`primary_fmea_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ADD CONSTRAINT `fk_engineering_dvp_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ADD CONSTRAINT `fk_engineering_dvp_plan_dvp_updated_by_employee_id` FOREIGN KEY (`dvp_updated_by_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ADD CONSTRAINT `fk_engineering_dvp_plan_primary_dvp_employee_id` FOREIGN KEY (`primary_dvp_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ADD CONSTRAINT `fk_engineering_dvp_plan_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`dvp_plan` ADD CONSTRAINT `fk_engineering_dvp_plan_tertiary_dvp_updated_by_employee_id` FOREIGN KEY (`tertiary_dvp_updated_by_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ADD CONSTRAINT `fk_engineering_weight_report_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`weight_report` ADD CONSTRAINT `fk_engineering_weight_report_primary_weight_employee_id` FOREIGN KEY (`primary_weight_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`design_review` ADD CONSTRAINT `fk_engineering_design_review_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`configuration_rule` ADD CONSTRAINT `fk_engineering_configuration_rule_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`ota_release` ADD CONSTRAINT `fk_engineering_ota_release_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ADD CONSTRAINT `fk_engineering_cost_target_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`cost_target` ADD CONSTRAINT `fk_engineering_cost_target_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ADD CONSTRAINT `fk_engineering_engineering_team_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_team` ADD CONSTRAINT `fk_engineering_engineering_team_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ADD CONSTRAINT `fk_engineering_engineering_change_action_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_change_action` ADD CONSTRAINT `fk_engineering_engineering_change_action_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ADD CONSTRAINT `fk_engineering_engineering_project_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`engineering`.`engineering_project` ADD CONSTRAINT `fk_engineering_engineering_project_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= field_services --> customer (2 constraint(s)) =========
-- Requires: field_services schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`field_services`.`mobile_service_order` ADD CONSTRAINT `fk_field_services_mobile_service_order_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_service_appointment` ADD CONSTRAINT `fk_field_services_field_service_appointment_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= field_services --> dealer (2 constraint(s)) =========
-- Requires: field_services schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`field_services`.`towing_event` ADD CONSTRAINT `fk_field_services_towing_event_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_visit` ADD CONSTRAINT `fk_field_services_field_visit_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= field_services --> engineering (3 constraint(s)) =========
-- Requires: field_services schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_failure_analysis` ADD CONSTRAINT `fk_field_services_field_failure_analysis_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_engineering_report` ADD CONSTRAINT `fk_field_services_field_engineering_report_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_parts_usage` ADD CONSTRAINT `fk_field_services_field_parts_usage_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);

-- ========= field_services --> inventory (1 constraint(s)) =========
-- Requires: field_services schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_parts_usage` ADD CONSTRAINT `fk_field_services_field_parts_usage_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);

-- ========= field_services --> mobility (1 constraint(s)) =========
-- Requires: field_services schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_service_appointment` ADD CONSTRAINT `fk_field_services_field_service_appointment_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);

-- ========= field_services --> quality (1 constraint(s)) =========
-- Requires: field_services schema, quality schema
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_quality_investigation` ADD CONSTRAINT `fk_field_services_field_quality_investigation_defect_record_id` FOREIGN KEY (`defect_record_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_record`(`defect_record_id`);

-- ========= field_services --> vehicle (3 constraint(s)) =========
-- Requires: field_services schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_technician_dispatch` ADD CONSTRAINT `fk_field_services_field_technician_dispatch_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`mobile_service_order` ADD CONSTRAINT `fk_field_services_mobile_service_order_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`roadside_assistance_case` ADD CONSTRAINT `fk_field_services_roadside_assistance_case_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);

-- ========= field_services --> workforce (2 constraint(s)) =========
-- Requires: field_services schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_technician_dispatch` ADD CONSTRAINT `fk_field_services_field_technician_dispatch_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`field_services`.`field_visit` ADD CONSTRAINT `fk_field_services_field_visit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= finance --> billing (1 constraint(s)) =========
-- Requires: finance schema, billing schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ADD CONSTRAINT `fk_finance_payment_settlement_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_automotive_v1`.`billing`.`invoice`(`invoice_id`);

-- ========= finance --> compliance (5 constraint(s)) =========
-- Requires: finance schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_trade_compliance_record_id` FOREIGN KEY (`trade_compliance_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`trade_compliance_record`(`trade_compliance_record_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ADD CONSTRAINT `fk_finance_capex_request_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_homologation_record_id` FOREIGN KEY (`homologation_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_record`(`homologation_record_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`legal_entity` ADD CONSTRAINT `fk_finance_legal_entity_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);

-- ========= finance --> customer (6 constraint(s)) =========
-- Requires: finance schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ADD CONSTRAINT `fk_finance_ar_payment_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_vehicle_customer_party_id` FOREIGN KEY (`vehicle_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`payment_settlement` ADD CONSTRAINT `fk_finance_payment_settlement_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= finance --> dealer (5 constraint(s)) =========
-- Requires: finance schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_accrual_related_dealership_id` FOREIGN KEY (`accrual_related_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ADD CONSTRAINT `fk_finance_dealer_incentive_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_primary_vehicle_dealership_id` FOREIGN KEY (`primary_vehicle_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= finance --> engineering (1 constraint(s)) =========
-- Requires: finance schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`finance_project` ADD CONSTRAINT `fk_finance_finance_project_engineering_project_id` FOREIGN KEY (`engineering_project_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`engineering_project`(`engineering_project_id`);

-- ========= finance --> manufacturing (7 constraint(s)) =========
-- Requires: finance schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_center` ADD CONSTRAINT `fk_finance_cost_center_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ADD CONSTRAINT `fk_finance_profit_center_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ADD CONSTRAINT `fk_finance_capex_request_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ADD CONSTRAINT `fk_finance_manufacturing_cost_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`manufacturing_cost` ADD CONSTRAINT `fk_finance_manufacturing_cost_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);

-- ========= finance --> procurement (4 constraint(s)) =========
-- Requires: finance schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_payment_run_id` FOREIGN KEY (`payment_run_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`payment_run`(`payment_run_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ADD CONSTRAINT `fk_finance_capex_request_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= finance --> vehicle (5 constraint(s)) =========
-- Requires: finance schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`warranty_reserve` ADD CONSTRAINT `fk_finance_warranty_reserve_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`vehicle_profitability` ADD CONSTRAINT `fk_finance_vehicle_profitability_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);

-- ========= finance --> workforce (26 constraint(s)) =========
-- Requires: finance schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ADD CONSTRAINT `fk_finance_profit_center_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ADD CONSTRAINT `fk_finance_profit_center_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ADD CONSTRAINT `fk_finance_profit_center_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`profit_center` ADD CONSTRAINT `fk_finance_profit_center_primary_profit_manager_employee_id` FOREIGN KEY (`primary_profit_manager_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ADD CONSTRAINT `fk_finance_ar_payment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`ar_payment` ADD CONSTRAINT `fk_finance_ar_payment_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ADD CONSTRAINT `fk_finance_capex_request_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ADD CONSTRAINT `fk_finance_capex_request_capex_requested_by_employee_id` FOREIGN KEY (`capex_requested_by_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ADD CONSTRAINT `fk_finance_capex_request_capex_updated_by_user_employee_id` FOREIGN KEY (`capex_updated_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ADD CONSTRAINT `fk_finance_capex_request_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ADD CONSTRAINT `fk_finance_capex_request_primary_capex_employee_id` FOREIGN KEY (`primary_capex_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`capex_request` ADD CONSTRAINT `fk_finance_capex_request_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`budget_plan` ADD CONSTRAINT `fk_finance_budget_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`depreciation_run` ADD CONSTRAINT `fk_finance_depreciation_run_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`intercompany_settlement` ADD CONSTRAINT `fk_finance_intercompany_settlement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_wbs_responsible_person_employee_id` FOREIGN KEY (`wbs_responsible_person_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ADD CONSTRAINT `fk_finance_financial_period_close_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`financial_period_close` ADD CONSTRAINT `fk_finance_financial_period_close_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`finance`.`dealer_incentive` ADD CONSTRAINT `fk_finance_dealer_incentive_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= inventory --> asset (4 constraint(s)) =========
-- Requires: inventory schema, asset schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ADD CONSTRAINT `fk_inventory_storage_location_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ADD CONSTRAINT `fk_inventory_service_parts_stock_spare_parts_catalog_id` FOREIGN KEY (`spare_parts_catalog_id`) REFERENCES `vibe_automotive_v1`.`asset`.`spare_parts_catalog`(`spare_parts_catalog_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_asset_valuation_id` FOREIGN KEY (`asset_valuation_id`) REFERENCES `vibe_automotive_v1`.`asset`.`asset_valuation`(`asset_valuation_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ADD CONSTRAINT `fk_inventory_inventory_hold_spare_parts_catalog_id` FOREIGN KEY (`spare_parts_catalog_id`) REFERENCES `vibe_automotive_v1`.`asset`.`spare_parts_catalog`(`spare_parts_catalog_id`);

-- ========= inventory --> billing (1 constraint(s)) =========
-- Requires: inventory schema, billing schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_automotive_v1`.`billing`.`invoice`(`invoice_id`);

-- ========= inventory --> compliance (8 constraint(s)) =========
-- Requires: inventory schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ADD CONSTRAINT `fk_inventory_sku_master_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ADD CONSTRAINT `fk_inventory_sku_master_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ADD CONSTRAINT `fk_inventory_storage_location_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`environmental_permit`(`environmental_permit_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ADD CONSTRAINT `fk_inventory_batch_record_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_homologation_record_id` FOREIGN KEY (`homologation_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_record`(`homologation_record_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_trade_compliance_record_id` FOREIGN KEY (`trade_compliance_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`trade_compliance_record`(`trade_compliance_record_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ADD CONSTRAINT `fk_inventory_inventory_hold_recall_campaign_id` FOREIGN KEY (`recall_campaign_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`recall_campaign`(`recall_campaign_id`);

-- ========= inventory --> customer (3 constraint(s)) =========
-- Requires: inventory schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_vehicle_ownership_id` FOREIGN KEY (`vehicle_ownership_id`) REFERENCES `vibe_automotive_v1`.`customer`.`vehicle_ownership`(`vehicle_ownership_id`);

-- ========= inventory --> dealer (3 constraint(s)) =========
-- Requires: inventory schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_primary_dealership_id` FOREIGN KEY (`primary_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`dealer_sku_stock` ADD CONSTRAINT `fk_inventory_dealer_sku_stock_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= inventory --> engineering (3 constraint(s)) =========
-- Requires: inventory schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ADD CONSTRAINT `fk_inventory_sku_master_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= inventory --> finance (10 constraint(s)) =========
-- Requires: inventory schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_balance` ADD CONSTRAINT `fk_inventory_stock_balance_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ADD CONSTRAINT `fk_inventory_wip_order_stock_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ADD CONSTRAINT `fk_inventory_service_parts_stock_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`movement_type` ADD CONSTRAINT `fk_inventory_movement_type_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);

-- ========= inventory --> manufacturing (7 constraint(s)) =========
-- Requires: inventory schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ADD CONSTRAINT `fk_inventory_storage_location_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_agv_movement_id` FOREIGN KEY (`agv_movement_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`agv_movement`(`agv_movement_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_source_plant_id` FOREIGN KEY (`source_plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`wip_order_stock` ADD CONSTRAINT `fk_inventory_wip_order_stock_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);

-- ========= inventory --> mobility (2 constraint(s)) =========
-- Requires: inventory schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);

-- ========= inventory --> procurement (8 constraint(s)) =========
-- Requires: inventory schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`consignment_stock` ADD CONSTRAINT `fk_inventory_consignment_stock_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`kanban_card` ADD CONSTRAINT `fk_inventory_kanban_card_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ADD CONSTRAINT `fk_inventory_ckd_skd_kit_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ADD CONSTRAINT `fk_inventory_inventory_hold_supplier_nonconformance_id` FOREIGN KEY (`supplier_nonconformance_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_nonconformance`(`supplier_nonconformance_id`);

-- ========= inventory --> product (1 constraint(s)) =========
-- Requires: inventory schema, product schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);

-- ========= inventory --> quality (1 constraint(s)) =========
-- Requires: inventory schema, quality schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_code`(`defect_code_id`);

-- ========= inventory --> sales (5 constraint(s)) =========
-- Requires: inventory schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`batch_record` ADD CONSTRAINT `fk_inventory_batch_record_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ADD CONSTRAINT `fk_inventory_ckd_skd_kit_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ADD CONSTRAINT `fk_inventory_warehouse_task_order_line_id` FOREIGN KEY (`order_line_id`) REFERENCES `vibe_automotive_v1`.`sales`.`order_line`(`order_line_id`);

-- ========= inventory --> vehicle (2 constraint(s)) =========
-- Requires: inventory schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ADD CONSTRAINT `fk_inventory_ckd_skd_kit_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);

-- ========= inventory --> workforce (31 constraint(s)) =========
-- Requires: inventory schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`inventory`.`sku_master` ADD CONSTRAINT `fk_inventory_sku_master_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`storage_location` ADD CONSTRAINT `fk_inventory_storage_location_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`goods_movement` ADD CONSTRAINT `fk_inventory_goods_movement_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_primary_stock_employee_id` FOREIGN KEY (`primary_stock_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_stock_created_by_user_employee_id` FOREIGN KEY (`stock_created_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_stock_updated_by_user_employee_id` FOREIGN KEY (`stock_updated_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`stock_transfer_order` ADD CONSTRAINT `fk_inventory_stock_transfer_order_tertiary_stock_updated_by_user_employee_id` FOREIGN KEY (`tertiary_stock_updated_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`mrp_requirement` ADD CONSTRAINT `fk_inventory_mrp_requirement_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock` ADD CONSTRAINT `fk_inventory_finished_vehicle_stock_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`service_parts_stock` ADD CONSTRAINT `fk_inventory_service_parts_stock_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ADD CONSTRAINT `fk_inventory_obsolescence_review_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`obsolescence_review` ADD CONSTRAINT `fk_inventory_obsolescence_review_reviewer_employee_id` FOREIGN KEY (`reviewer_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ADD CONSTRAINT `fk_inventory_ckd_skd_kit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ADD CONSTRAINT `fk_inventory_ckd_skd_kit_primary_ckd_employee_id` FOREIGN KEY (`primary_ckd_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`ckd_skd_kit` ADD CONSTRAINT `fk_inventory_ckd_skd_kit_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_adjustment_updated_by_user_employee_id` FOREIGN KEY (`adjustment_updated_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_quaternary_adjustment_updated_by_user_employee_id` FOREIGN KEY (`quaternary_adjustment_updated_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`adjustment` ADD CONSTRAINT `fk_inventory_adjustment_tertiary_adjustment_employee_id` FOREIGN KEY (`tertiary_adjustment_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ADD CONSTRAINT `fk_inventory_warehouse_task_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ADD CONSTRAINT `fk_inventory_warehouse_task_primary_warehouse_employee_id` FOREIGN KEY (`primary_warehouse_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`warehouse_task` ADD CONSTRAINT `fk_inventory_warehouse_task_warehouse_updated_by_user_employee_id` FOREIGN KEY (`warehouse_updated_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`inventory`.`inventory_hold` ADD CONSTRAINT `fk_inventory_inventory_hold_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= logistics --> aftersales (3 constraint(s)) =========
-- Requires: logistics schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ADD CONSTRAINT `fk_logistics_transport_damage_claim_aftersales_warranty_claim_id` FOREIGN KEY (`aftersales_warranty_claim_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim`(`aftersales_warranty_claim_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_aftersales_warranty_claim_id` FOREIGN KEY (`aftersales_warranty_claim_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim`(`aftersales_warranty_claim_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_aftersales_repair_order_id` FOREIGN KEY (`aftersales_repair_order_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order`(`aftersales_repair_order_id`);

-- ========= logistics --> asset (5 constraint(s)) =========
-- Requires: logistics schema, asset schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ADD CONSTRAINT `fk_logistics_shipment_leg_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ADD CONSTRAINT `fk_logistics_shipment_leg_shipment_functional_location_id` FOREIGN KEY (`shipment_functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ADD CONSTRAINT `fk_logistics_port_processing_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);

-- ========= logistics --> compliance (7 constraint(s)) =========
-- Requires: logistics schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier` ADD CONSTRAINT `fk_logistics_carrier_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ADD CONSTRAINT `fk_logistics_port_processing_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ADD CONSTRAINT `fk_logistics_transport_damage_claim_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ADD CONSTRAINT `fk_logistics_export_declaration_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ADD CONSTRAINT `fk_logistics_import_declaration_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);

-- ========= logistics --> customer (5 constraint(s)) =========
-- Requires: logistics schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ADD CONSTRAINT `fk_logistics_transport_damage_claim_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ADD CONSTRAINT `fk_logistics_import_declaration_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= logistics --> dealer (7 constraint(s)) =========
-- Requires: logistics schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ADD CONSTRAINT `fk_logistics_vehicle_transport_order_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ADD CONSTRAINT `fk_logistics_logistics_delivery_schedule_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ADD CONSTRAINT `fk_logistics_logistics_delivery_schedule_primary_dealership_id` FOREIGN KEY (`primary_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ADD CONSTRAINT `fk_logistics_vehicle_compound_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_primary_dealership_id` FOREIGN KEY (`primary_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= logistics --> engineering (4 constraint(s)) =========
-- Requires: logistics schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ADD CONSTRAINT `fk_logistics_vehicle_transport_order_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ADD CONSTRAINT `fk_logistics_logistics_delivery_schedule_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= logistics --> finance (13 constraint(s)) =========
-- Requires: logistics schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ADD CONSTRAINT `fk_logistics_vehicle_transport_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ADD CONSTRAINT `fk_logistics_logistics_delivery_schedule_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ADD CONSTRAINT `fk_logistics_transport_damage_claim_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ADD CONSTRAINT `fk_logistics_transport_damage_claim_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`lane` ADD CONSTRAINT `fk_logistics_lane_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ADD CONSTRAINT `fk_logistics_export_declaration_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ADD CONSTRAINT `fk_logistics_import_declaration_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`import_declaration` ADD CONSTRAINT `fk_logistics_import_declaration_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`load_plan` ADD CONSTRAINT `fk_logistics_load_plan_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= logistics --> inventory (4 constraint(s)) =========
-- Requires: logistics schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment_leg` ADD CONSTRAINT `fk_logistics_shipment_leg_goods_movement_id` FOREIGN KEY (`goods_movement_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`goods_movement`(`goods_movement_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ADD CONSTRAINT `fk_logistics_vehicle_transport_order_finished_vehicle_stock_id` FOREIGN KEY (`finished_vehicle_stock_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock`(`finished_vehicle_stock_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ADD CONSTRAINT `fk_logistics_logistics_delivery_schedule_finished_vehicle_stock_id` FOREIGN KEY (`finished_vehicle_stock_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock`(`finished_vehicle_stock_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_finished_vehicle_stock_id` FOREIGN KEY (`finished_vehicle_stock_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`finished_vehicle_stock`(`finished_vehicle_stock_id`);

-- ========= logistics --> manufacturing (9 constraint(s)) =========
-- Requires: logistics schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ADD CONSTRAINT `fk_logistics_vehicle_transport_order_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ADD CONSTRAINT `fk_logistics_logistics_delivery_schedule_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_compound` ADD CONSTRAINT `fk_logistics_vehicle_compound_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ADD CONSTRAINT `fk_logistics_ckd_kit_shipment_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment` ADD CONSTRAINT `fk_logistics_ckd_kit_shipment_origin_plant_id` FOREIGN KEY (`origin_plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`export_declaration` ADD CONSTRAINT `fk_logistics_export_declaration_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);

-- ========= logistics --> mobility (5 constraint(s)) =========
-- Requires: logistics schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ADD CONSTRAINT `fk_logistics_port_processing_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ADD CONSTRAINT `fk_logistics_transport_damage_claim_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_shipment_assignment` ADD CONSTRAINT `fk_logistics_vehicle_shipment_assignment_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);

-- ========= logistics --> procurement (2 constraint(s)) =========
-- Requires: logistics schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);

-- ========= logistics --> product (3 constraint(s)) =========
-- Requires: logistics schema, product schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ADD CONSTRAINT `fk_logistics_transport_damage_claim_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);

-- ========= logistics --> sales (7 constraint(s)) =========
-- Requires: logistics schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ADD CONSTRAINT `fk_logistics_vehicle_transport_order_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ADD CONSTRAINT `fk_logistics_logistics_delivery_schedule_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ADD CONSTRAINT `fk_logistics_transport_damage_claim_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);

-- ========= logistics --> vehicle (4 constraint(s)) =========
-- Requires: logistics schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`in_transit_inventory` ADD CONSTRAINT `fk_logistics_in_transit_inventory_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ADD CONSTRAINT `fk_logistics_port_processing_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);

-- ========= logistics --> workforce (14 constraint(s)) =========
-- Requires: logistics schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`logistics`.`shipment` ADD CONSTRAINT `fk_logistics_shipment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_transport_order` ADD CONSTRAINT `fk_logistics_vehicle_transport_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule` ADD CONSTRAINT `fk_logistics_logistics_delivery_schedule_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`carrier_performance` ADD CONSTRAINT `fk_logistics_carrier_performance_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ADD CONSTRAINT `fk_logistics_compound_movement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`compound_movement` ADD CONSTRAINT `fk_logistics_compound_movement_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`port_processing` ADD CONSTRAINT `fk_logistics_port_processing_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vessel_voyage` ADD CONSTRAINT `fk_logistics_vessel_voyage_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`rail_car_assignment` ADD CONSTRAINT `fk_logistics_rail_car_assignment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_damage_claim` ADD CONSTRAINT `fk_logistics_transport_damage_claim_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`transport_rate` ADD CONSTRAINT `fk_logistics_transport_rate_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`vehicle_handover` ADD CONSTRAINT `fk_logistics_vehicle_handover_vehicle_created_by_user_employee_id` FOREIGN KEY (`vehicle_created_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`logistics`.`load_plan` ADD CONSTRAINT `fk_logistics_load_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= manufacturing --> asset (14 constraint(s)) =========
-- Requires: manufacturing schema, asset schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ADD CONSTRAINT `fk_manufacturing_work_center_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ADD CONSTRAINT `fk_manufacturing_shop_floor_event_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ADD CONSTRAINT `fk_manufacturing_shop_floor_event_shop_equipment_registry_id` FOREIGN KEY (`shop_equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ADD CONSTRAINT `fk_manufacturing_shop_floor_event_tooling_registry_id` FOREIGN KEY (`tooling_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`tooling_registry`(`tooling_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ADD CONSTRAINT `fk_manufacturing_shop_floor_event_shop_tooling_registry_id` FOREIGN KEY (`shop_tooling_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`tooling_registry`(`tooling_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_inspection_id` FOREIGN KEY (`inspection_id`) REFERENCES `vibe_automotive_v1`.`asset`.`inspection`(`inspection_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ADD CONSTRAINT `fk_manufacturing_downtime_event_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ADD CONSTRAINT `fk_manufacturing_downtime_event_primary_equipment_registry_id` FOREIGN KEY (`primary_equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_tooling_usage` ADD CONSTRAINT `fk_manufacturing_manufacturing_tooling_usage_tooling_registry_id` FOREIGN KEY (`tooling_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`tooling_registry`(`tooling_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ADD CONSTRAINT `fk_manufacturing_process_parameter_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ADD CONSTRAINT `fk_manufacturing_process_parameter_process_equipment_registry_id` FOREIGN KEY (`process_equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ADD CONSTRAINT `fk_manufacturing_process_parameter_tooling_registry_id` FOREIGN KEY (`tooling_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`tooling_registry`(`tooling_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ADD CONSTRAINT `fk_manufacturing_process_parameter_process_tooling_registry_id` FOREIGN KEY (`process_tooling_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`tooling_registry`(`tooling_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ADD CONSTRAINT `fk_manufacturing_operator_team_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);

-- ========= manufacturing --> billing (1 constraint(s)) =========
-- Requires: manufacturing schema, billing schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ADD CONSTRAINT `fk_manufacturing_production_schedule_billing_run_id` FOREIGN KEY (`billing_run_id`) REFERENCES `vibe_automotive_v1`.`billing`.`billing_run`(`billing_run_id`);

-- ========= manufacturing --> compliance (6 constraint(s)) =========
-- Requires: manufacturing schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`plant` ADD CONSTRAINT `fk_manufacturing_plant_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_homologation_record_id` FOREIGN KEY (`homologation_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_record`(`homologation_record_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_homologation_record_id` FOREIGN KEY (`homologation_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_record`(`homologation_record_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ADD CONSTRAINT `fk_manufacturing_production_variant_homologation_record_id` FOREIGN KEY (`homologation_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_record`(`homologation_record_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` ADD CONSTRAINT `fk_manufacturing_compliance_certification_compliance_emissions_certification_id` FOREIGN KEY (`compliance_emissions_certification_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification`(`compliance_emissions_certification_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`compliance_certification` ADD CONSTRAINT `fk_manufacturing_compliance_certification_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);

-- ========= manufacturing --> customer (2 constraint(s)) =========
-- Requires: manufacturing schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_vehicle_ownership_id` FOREIGN KEY (`vehicle_ownership_id`) REFERENCES `vibe_automotive_v1`.`customer`.`vehicle_ownership`(`vehicle_ownership_id`);

-- ========= manufacturing --> dealer (1 constraint(s)) =========
-- Requires: manufacturing schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order_allocation` ADD CONSTRAINT `fk_manufacturing_production_order_allocation_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= manufacturing --> engineering (11 constraint(s)) =========
-- Requires: manufacturing schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ADD CONSTRAINT `fk_manufacturing_production_line_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ADD CONSTRAINT `fk_manufacturing_production_schedule_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ADD CONSTRAINT `fk_manufacturing_production_bom_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`bom`(`bom_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ADD CONSTRAINT `fk_manufacturing_production_bom_production_ebom_reference_bom_id` FOREIGN KEY (`production_ebom_reference_bom_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`bom`(`bom_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_bom_component` ADD CONSTRAINT `fk_manufacturing_manufacturing_bom_component_engineering_bom_component_id` FOREIGN KEY (`engineering_bom_component_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`engineering_bom_component`(`engineering_bom_component_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ADD CONSTRAINT `fk_manufacturing_capacity_plan_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ADD CONSTRAINT `fk_manufacturing_production_variant_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ADD CONSTRAINT `fk_manufacturing_manufacturing_packaging_specification_packaging_specification_id` FOREIGN KEY (`packaging_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`packaging_specification`(`packaging_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ADD CONSTRAINT `fk_manufacturing_manufacturing_packaging_specification_packaging_specification_ssot_id` FOREIGN KEY (`packaging_specification_ssot_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`packaging_specification`(`packaging_specification_id`);

-- ========= manufacturing --> finance (7 constraint(s)) =========
-- Requires: manufacturing schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ADD CONSTRAINT `fk_manufacturing_production_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ADD CONSTRAINT `fk_manufacturing_work_center_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ADD CONSTRAINT `fk_manufacturing_build_stage_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= manufacturing --> inventory (7 constraint(s)) =========
-- Requires: manufacturing schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ADD CONSTRAINT `fk_manufacturing_agv_route_agv_start_location_id` FOREIGN KEY (`agv_start_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_route` ADD CONSTRAINT `fk_manufacturing_agv_route_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);

-- ========= manufacturing --> mobility (3 constraint(s)) =========
-- Requires: manufacturing schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` ADD CONSTRAINT `fk_manufacturing_vehicle_mobility_subscription_mobility_service_id` FOREIGN KEY (`mobility_service_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_service`(`mobility_service_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_mobility_subscription` ADD CONSTRAINT `fk_manufacturing_vehicle_mobility_subscription_service_tier_id` FOREIGN KEY (`service_tier_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`service_tier`(`service_tier_id`);

-- ========= manufacturing --> procurement (5 constraint(s)) =========
-- Requires: manufacturing schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ADD CONSTRAINT `fk_manufacturing_manufacturing_supply_agreement_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_supply_agreement` ADD CONSTRAINT `fk_manufacturing_manufacturing_supply_agreement_procurement_supply_agreement_id` FOREIGN KEY (`procurement_supply_agreement_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supply_agreement`(`procurement_supply_agreement_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ADD CONSTRAINT `fk_manufacturing_manufacturing_packaging_specification_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`manufacturing_packaging_specification` ADD CONSTRAINT `fk_manufacturing_manufacturing_packaging_specification_packaging_vendor_id` FOREIGN KEY (`packaging_vendor_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= manufacturing --> product (1 constraint(s)) =========
-- Requires: manufacturing schema, product schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ADD CONSTRAINT `fk_manufacturing_production_schedule_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);

-- ========= manufacturing --> quality (2 constraint(s)) =========
-- Requires: manufacturing schema, quality schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ADD CONSTRAINT `fk_manufacturing_rework_order_defect_record_id` FOREIGN KEY (`defect_record_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_record`(`defect_record_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ADD CONSTRAINT `fk_manufacturing_scrap_record_defect_record_id` FOREIGN KEY (`defect_record_id`) REFERENCES `vibe_automotive_v1`.`quality`.`defect_record`(`defect_record_id`);

-- ========= manufacturing --> sales (3 constraint(s)) =========
-- Requires: manufacturing schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_opportunity_id` FOREIGN KEY (`opportunity_id`) REFERENCES `vibe_automotive_v1`.`sales`.`opportunity`(`opportunity_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_quote_id` FOREIGN KEY (`quote_id`) REFERENCES `vibe_automotive_v1`.`sales`.`quote`(`quote_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);

-- ========= manufacturing --> supply (3 constraint(s)) =========
-- Requires: manufacturing schema, supply schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_supply_purchase_order_id` FOREIGN KEY (`supply_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_purchase_order`(`supply_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_inbound_shipment_id` FOREIGN KEY (`inbound_shipment_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_shipment`(`inbound_shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_inbound_part_id` FOREIGN KEY (`inbound_part_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_part`(`inbound_part_id`);

-- ========= manufacturing --> vehicle (8 constraint(s)) =========
-- Requires: manufacturing schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ADD CONSTRAINT `fk_manufacturing_build_sequence_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_sequence` ADD CONSTRAINT `fk_manufacturing_build_sequence_build_vehicle_config_configuration_id` FOREIGN KEY (`build_vehicle_config_configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`vehicle_build` ADD CONSTRAINT `fk_manufacturing_vehicle_build_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ADD CONSTRAINT `fk_manufacturing_shop_floor_event_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_schedule` ADD CONSTRAINT `fk_manufacturing_production_schedule_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_bom` ADD CONSTRAINT `fk_manufacturing_production_bom_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_variant` ADD CONSTRAINT `fk_manufacturing_production_variant_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);

-- ========= manufacturing --> workforce (26 constraint(s)) =========
-- Requires: manufacturing schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_line` ADD CONSTRAINT `fk_manufacturing_production_line_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ADD CONSTRAINT `fk_manufacturing_work_center_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`work_center` ADD CONSTRAINT `fk_manufacturing_work_center_work_responsible_supervisor_employee_id` FOREIGN KEY (`work_responsible_supervisor_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_order` ADD CONSTRAINT `fk_manufacturing_production_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`build_stage` ADD CONSTRAINT `fk_manufacturing_build_stage_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ADD CONSTRAINT `fk_manufacturing_shop_floor_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`shop_floor_event` ADD CONSTRAINT `fk_manufacturing_shop_floor_event_shop_operator_employee_id` FOREIGN KEY (`shop_operator_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`wip_inventory` ADD CONSTRAINT `fk_manufacturing_wip_inventory_wip_operator_employee_id` FOREIGN KEY (`wip_operator_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ADD CONSTRAINT `fk_manufacturing_downtime_event_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`downtime_event` ADD CONSTRAINT `fk_manufacturing_downtime_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`material_consumption` ADD CONSTRAINT `fk_manufacturing_material_consumption_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`rework_order` ADD CONSTRAINT `fk_manufacturing_rework_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ADD CONSTRAINT `fk_manufacturing_production_confirmation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`production_confirmation` ADD CONSTRAINT `fk_manufacturing_production_confirmation_production_operator_employee_id` FOREIGN KEY (`production_operator_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ADD CONSTRAINT `fk_manufacturing_process_parameter_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`process_parameter` ADD CONSTRAINT `fk_manufacturing_process_parameter_process_operator_employee_id` FOREIGN KEY (`process_operator_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ADD CONSTRAINT `fk_manufacturing_agv_movement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`agv_movement` ADD CONSTRAINT `fk_manufacturing_agv_movement_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ADD CONSTRAINT `fk_manufacturing_capacity_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`capacity_plan` ADD CONSTRAINT `fk_manufacturing_capacity_plan_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ADD CONSTRAINT `fk_manufacturing_changeover_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ADD CONSTRAINT `fk_manufacturing_changeover_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`changeover` ADD CONSTRAINT `fk_manufacturing_changeover_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`scrap_record` ADD CONSTRAINT `fk_manufacturing_scrap_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`manufacturing`.`operator_team` ADD CONSTRAINT `fk_manufacturing_operator_team_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= mobility --> aftersales (1 constraint(s)) =========
-- Requires: mobility schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ADD CONSTRAINT `fk_mobility_predictive_maintenance_alert_aftersales_repair_order_id` FOREIGN KEY (`aftersales_repair_order_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_repair_order`(`aftersales_repair_order_id`);

-- ========= mobility --> asset (6 constraint(s)) =========
-- Requires: mobility schema, asset schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ADD CONSTRAINT `fk_mobility_telematics_device_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ADD CONSTRAINT `fk_mobility_service_subscription_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ADD CONSTRAINT `fk_mobility_trip_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ADD CONSTRAINT `fk_mobility_ev_charging_session_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charger` ADD CONSTRAINT `fk_mobility_ev_charger_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);

-- ========= mobility --> billing (1 constraint(s)) =========
-- Requires: mobility schema, billing schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ADD CONSTRAINT `fk_mobility_usage_record_billing_period_id` FOREIGN KEY (`billing_period_id`) REFERENCES `vibe_automotive_v1`.`billing`.`billing_period`(`billing_period_id`);

-- ========= mobility --> compliance (4 constraint(s)) =========
-- Requires: mobility schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_homologation_record_id` FOREIGN KEY (`homologation_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_record`(`homologation_record_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_ota_compliance_approval_id` FOREIGN KEY (`ota_compliance_approval_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`ota_compliance_approval`(`ota_compliance_approval_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ota_campaign` ADD CONSTRAINT `fk_mobility_ota_campaign_ota_compliance_approval_id` FOREIGN KEY (`ota_compliance_approval_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`ota_compliance_approval`(`ota_compliance_approval_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`geofence` ADD CONSTRAINT `fk_mobility_geofence_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);

-- ========= mobility --> customer (11 constraint(s)) =========
-- Requires: mobility schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ADD CONSTRAINT `fk_mobility_service_subscription_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ADD CONSTRAINT `fk_mobility_service_subscription_service_customer_party_id` FOREIGN KEY (`service_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ADD CONSTRAINT `fk_mobility_telemetry_event_individual_id` FOREIGN KEY (`individual_id`) REFERENCES `vibe_automotive_v1`.`customer`.`individual`(`individual_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ADD CONSTRAINT `fk_mobility_trip_individual_id` FOREIGN KEY (`individual_id`) REFERENCES `vibe_automotive_v1`.`customer`.`individual`(`individual_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ADD CONSTRAINT `fk_mobility_remote_diagnostic_session_individual_id` FOREIGN KEY (`individual_id`) REFERENCES `vibe_automotive_v1`.`customer`.`individual`(`individual_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ADD CONSTRAINT `fk_mobility_remote_diagnostic_session_remote_individual_id` FOREIGN KEY (`remote_individual_id`) REFERENCES `vibe_automotive_v1`.`customer`.`individual`(`individual_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_account` ADD CONSTRAINT `fk_mobility_mobility_fleet_account_customer_fleet_account_id` FOREIGN KEY (`customer_fleet_account_id`) REFERENCES `vibe_automotive_v1`.`customer`.`customer_fleet_account`(`customer_fleet_account_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ADD CONSTRAINT `fk_mobility_remote_command_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ADD CONSTRAINT `fk_mobility_ev_charging_session_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_consent_record` ADD CONSTRAINT `fk_mobility_mobility_consent_record_customer_consent_record_id` FOREIGN KEY (`customer_consent_record_id`) REFERENCES `vibe_automotive_v1`.`customer`.`customer_consent_record`(`customer_consent_record_id`);

-- ========= mobility --> dealer (3 constraint(s)) =========
-- Requires: mobility schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ADD CONSTRAINT `fk_mobility_service_subscription_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_account` ADD CONSTRAINT `fk_mobility_mobility_fleet_account_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= mobility --> field_services (11 constraint(s)) =========
-- Requires: mobility schema, field_services schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_breakdown_case_id` FOREIGN KEY (`breakdown_case_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`breakdown_case`(`breakdown_case_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ADD CONSTRAINT `fk_mobility_trip_roadside_assistance_case_id` FOREIGN KEY (`roadside_assistance_case_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`roadside_assistance_case`(`roadside_assistance_case_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_dtc_event` ADD CONSTRAINT `fk_mobility_mobility_dtc_event_breakdown_case_id` FOREIGN KEY (`breakdown_case_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`breakdown_case`(`breakdown_case_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ADD CONSTRAINT `fk_mobility_remote_diagnostic_session_mobile_service_order_id` FOREIGN KEY (`mobile_service_order_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`mobile_service_order`(`mobile_service_order_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ADD CONSTRAINT `fk_mobility_predictive_maintenance_alert_breakdown_case_id` FOREIGN KEY (`breakdown_case_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`breakdown_case`(`breakdown_case_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ADD CONSTRAINT `fk_mobility_predictive_maintenance_alert_roadside_assistance_case_id` FOREIGN KEY (`roadside_assistance_case_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`roadside_assistance_case`(`roadside_assistance_case_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`tpms_reading` ADD CONSTRAINT `fk_mobility_tpms_reading_breakdown_case_id` FOREIGN KEY (`breakdown_case_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`breakdown_case`(`breakdown_case_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ADD CONSTRAINT `fk_mobility_usage_record_mobile_service_order_id` FOREIGN KEY (`mobile_service_order_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`mobile_service_order`(`mobile_service_order_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_incident` ADD CONSTRAINT `fk_mobility_service_incident_roadside_assistance_case_id` FOREIGN KEY (`roadside_assistance_case_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`roadside_assistance_case`(`roadside_assistance_case_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_tier` ADD CONSTRAINT `fk_mobility_service_tier_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`vehicle_service_subscription` ADD CONSTRAINT `fk_mobility_vehicle_service_subscription_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);

-- ========= mobility --> finance (9 constraint(s)) =========
-- Requires: mobility schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ADD CONSTRAINT `fk_mobility_service_subscription_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`predictive_maintenance_alert` ADD CONSTRAINT `fk_mobility_predictive_maintenance_alert_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_fleet_account` ADD CONSTRAINT `fk_mobility_mobility_fleet_account_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`adas_feature_entitlement` ADD CONSTRAINT `fk_mobility_adas_feature_entitlement_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`usage_record` ADD CONSTRAINT `fk_mobility_usage_record_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_command` ADD CONSTRAINT `fk_mobility_remote_command_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`ev_charging_session` ADD CONSTRAINT `fk_mobility_ev_charging_session_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_incident` ADD CONSTRAINT `fk_mobility_service_incident_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= mobility --> logistics (2 constraint(s)) =========
-- Requires: mobility schema, logistics schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_route` ADD CONSTRAINT `fk_mobility_mobility_route_route_id` FOREIGN KEY (`route_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`route`(`route_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_route2` ADD CONSTRAINT `fk_mobility_mobility_route2_route_id` FOREIGN KEY (`route_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`route`(`route_id`);

-- ========= mobility --> procurement (1 constraint(s)) =========
-- Requires: mobility schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`software_version` ADD CONSTRAINT `fk_mobility_software_version_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);

-- ========= mobility --> product (3 constraint(s)) =========
-- Requires: mobility schema, product schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ADD CONSTRAINT `fk_mobility_mobility_service_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);

-- ========= mobility --> supply (2 constraint(s)) =========
-- Requires: mobility schema, supply schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ADD CONSTRAINT `fk_mobility_telematics_device_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ADD CONSTRAINT `fk_mobility_mobility_service_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);

-- ========= mobility --> vehicle (5 constraint(s)) =========
-- Requires: mobility schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ADD CONSTRAINT `fk_mobility_service_subscription_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telemetry_event` ADD CONSTRAINT `fk_mobility_telemetry_event_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ADD CONSTRAINT `fk_mobility_trip_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_ota_deployment` ADD CONSTRAINT `fk_mobility_mobility_ota_deployment_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);

-- ========= mobility --> workforce (6 constraint(s)) =========
-- Requires: mobility schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`mobility`.`connected_vehicle` ADD CONSTRAINT `fk_mobility_connected_vehicle_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`telematics_device` ADD CONSTRAINT `fk_mobility_telematics_device_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`service_subscription` ADD CONSTRAINT `fk_mobility_service_subscription_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`trip` ADD CONSTRAINT `fk_mobility_trip_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`remote_diagnostic_session` ADD CONSTRAINT `fk_mobility_remote_diagnostic_session_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`mobility`.`mobility_service` ADD CONSTRAINT `fk_mobility_mobility_service_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= procurement --> aftersales (1 constraint(s)) =========
-- Requires: procurement schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ADD CONSTRAINT `fk_procurement_service_entry_sheet_service_contract_id` FOREIGN KEY (`service_contract_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_contract`(`service_contract_id`);

-- ========= procurement --> asset (5 constraint(s)) =========
-- Requires: procurement schema, asset schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ADD CONSTRAINT `fk_procurement_procurement_purchase_order_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_acquisition_id` FOREIGN KEY (`acquisition_id`) REFERENCES `vibe_automotive_v1`.`asset`.`acquisition`(`acquisition_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ADD CONSTRAINT `fk_procurement_tooling_order_tooling_registry_id` FOREIGN KEY (`tooling_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`tooling_registry`(`tooling_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);

-- ========= procurement --> billing (2 constraint(s)) =========
-- Requires: procurement schema, billing schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_invoice_line` ADD CONSTRAINT `fk_procurement_procurement_invoice_line_billing_invoice_line_id` FOREIGN KEY (`billing_invoice_line_id`) REFERENCES `vibe_automotive_v1`.`billing`.`billing_invoice_line`(`billing_invoice_line_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_price_condition` ADD CONSTRAINT `fk_procurement_procurement_price_condition_billing_price_condition_id` FOREIGN KEY (`billing_price_condition_id`) REFERENCES `vibe_automotive_v1`.`billing`.`billing_price_condition`(`billing_price_condition_id`);

-- ========= procurement --> compliance (5 constraint(s)) =========
-- Requires: procurement schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ADD CONSTRAINT `fk_procurement_supplier_quote_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ADD CONSTRAINT `fk_procurement_procurement_purchase_order_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ADD CONSTRAINT `fk_procurement_supplier_development_plan_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_regulatory_compliance` ADD CONSTRAINT `fk_procurement_supplier_regulatory_compliance_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ADD CONSTRAINT `fk_procurement_procurement_document_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);

-- ========= procurement --> customer (2 constraint(s)) =========
-- Requires: procurement schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ADD CONSTRAINT `fk_procurement_procurement_purchase_order_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= procurement --> engineering (9 constraint(s)) =========
-- Requires: procurement schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ADD CONSTRAINT `fk_procurement_sourcing_event_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ADD CONSTRAINT `fk_procurement_supplier_quote_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ADD CONSTRAINT `fk_procurement_procurement_purchase_order_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`approved_vendor_list` ADD CONSTRAINT `fk_procurement_approved_vendor_list_material_id` FOREIGN KEY (`material_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`material`(`material_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`info_record` ADD CONSTRAINT `fk_procurement_info_record_material_id` FOREIGN KEY (`material_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`material`(`material_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ADD CONSTRAINT `fk_procurement_tooling_order_engineering_project_id` FOREIGN KEY (`engineering_project_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`engineering_project`(`engineering_project_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`program_supplier_contract` ADD CONSTRAINT `fk_procurement_program_supplier_contract_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= procurement --> finance (18 constraint(s)) =========
-- Requires: procurement schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ADD CONSTRAINT `fk_procurement_procurement_purchase_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ADD CONSTRAINT `fk_procurement_procurement_purchase_order_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ADD CONSTRAINT `fk_procurement_procurement_po_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ADD CONSTRAINT `fk_procurement_procurement_po_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ADD CONSTRAINT `fk_procurement_spend_category_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ADD CONSTRAINT `fk_procurement_capex_requisition_budget_line_id` FOREIGN KEY (`budget_line_id`) REFERENCES `vibe_automotive_v1`.`finance`.`budget_line`(`budget_line_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ADD CONSTRAINT `fk_procurement_capex_requisition_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ADD CONSTRAINT `fk_procurement_capex_requisition_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ADD CONSTRAINT `fk_procurement_tooling_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ADD CONSTRAINT `fk_procurement_service_entry_sheet_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`payment_run` ADD CONSTRAINT `fk_procurement_payment_run_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);

-- ========= procurement --> inventory (7 constraint(s)) =========
-- Requires: procurement schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ADD CONSTRAINT `fk_procurement_supplier_quote_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ADD CONSTRAINT `fk_procurement_procurement_po_line_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ADD CONSTRAINT `fk_procurement_scheduling_agreement_line_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ADD CONSTRAINT `fk_procurement_supplier_nonconformance_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);

-- ========= procurement --> logistics (1 constraint(s)) =========
-- Requires: procurement schema, logistics schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_delivery_schedule` ADD CONSTRAINT `fk_procurement_procurement_delivery_schedule_logistics_delivery_schedule_id` FOREIGN KEY (`logistics_delivery_schedule_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule`(`logistics_delivery_schedule_id`);

-- ========= procurement --> manufacturing (10 constraint(s)) =========
-- Requires: procurement schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ADD CONSTRAINT `fk_procurement_procurement_purchase_order_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ADD CONSTRAINT `fk_procurement_procurement_po_line_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ADD CONSTRAINT `fk_procurement_procurement_po_line_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ADD CONSTRAINT `fk_procurement_capex_requisition_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`tooling_order` ADD CONSTRAINT `fk_procurement_tooling_order_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ADD CONSTRAINT `fk_procurement_service_entry_sheet_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`service_entry_sheet` ADD CONSTRAINT `fk_procurement_service_entry_sheet_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_nonconformance` ADD CONSTRAINT `fk_procurement_supplier_nonconformance_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);

-- ========= procurement --> quality (5 constraint(s)) =========
-- Requires: procurement schema, quality schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ADD CONSTRAINT `fk_procurement_supplier_quote_quality_ppap_submission_id` FOREIGN KEY (`quality_ppap_submission_id`) REFERENCES `vibe_automotive_v1`.`quality`.`quality_ppap_submission`(`quality_ppap_submission_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ADD CONSTRAINT `fk_procurement_procurement_purchase_order_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ADD CONSTRAINT `fk_procurement_procurement_po_line_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ADD CONSTRAINT `fk_procurement_supplier_development_plan_apqp_plan_id` FOREIGN KEY (`apqp_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`apqp_plan`(`apqp_plan_id`);

-- ========= procurement --> sales (1 constraint(s)) =========
-- Requires: procurement schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);

-- ========= procurement --> supply (2 constraint(s)) =========
-- Requires: procurement schema, supply schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`scheduling_agreement_line` ADD CONSTRAINT `fk_procurement_scheduling_agreement_line_supply_scheduling_agreement_id` FOREIGN KEY (`supply_scheduling_agreement_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_scheduling_agreement`(`supply_scheduling_agreement_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_supply_agreement` ADD CONSTRAINT `fk_procurement_procurement_supply_agreement_supply_agreement_id` FOREIGN KEY (`supply_agreement_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_agreement`(`supply_agreement_id`);

-- ========= procurement --> workforce (32 constraint(s)) =========
-- Requires: procurement schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ADD CONSTRAINT `fk_procurement_sourcing_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`sourcing_event` ADD CONSTRAINT `fk_procurement_sourcing_event_sourcing_buyer_employee_id` FOREIGN KEY (`sourcing_buyer_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_quote` ADD CONSTRAINT `fk_procurement_supplier_quote_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_primary_purchase_employee_id` FOREIGN KEY (`primary_purchase_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_purchase_approved_by_employee_id` FOREIGN KEY (`purchase_approved_by_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_purchase_order` ADD CONSTRAINT `fk_procurement_procurement_purchase_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_po_line` ADD CONSTRAINT `fk_procurement_procurement_po_line_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_contract` ADD CONSTRAINT `fk_procurement_supplier_contract_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_procurement_receipt_user_employee_id` FOREIGN KEY (`procurement_receipt_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ADD CONSTRAINT `fk_procurement_spend_category_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_category` ADD CONSTRAINT `fk_procurement_spend_category_primary_spend_employee_id` FOREIGN KEY (`primary_spend_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ADD CONSTRAINT `fk_procurement_supplier_evaluation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_evaluation` ADD CONSTRAINT `fk_procurement_supplier_evaluation_supplier_evaluator_employee_id` FOREIGN KEY (`supplier_evaluator_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ADD CONSTRAINT `fk_procurement_supplier_development_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ADD CONSTRAINT `fk_procurement_supplier_development_plan_primary_supplier_employee_id` FOREIGN KEY (`primary_supplier_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`supplier_development_plan` ADD CONSTRAINT `fk_procurement_supplier_development_plan_supplier_approved_by_employee_id` FOREIGN KEY (`supplier_approved_by_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ADD CONSTRAINT `fk_procurement_capex_requisition_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ADD CONSTRAINT `fk_procurement_capex_requisition_department_id` FOREIGN KEY (`department_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`department`(`department_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ADD CONSTRAINT `fk_procurement_capex_requisition_primary_capex_employee_id` FOREIGN KEY (`primary_capex_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`capex_requisition` ADD CONSTRAINT `fk_procurement_capex_requisition_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_spend_approved_by_employee_id` FOREIGN KEY (`spend_approved_by_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ADD CONSTRAINT `fk_procurement_savings_initiative_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`savings_initiative` ADD CONSTRAINT `fk_procurement_savings_initiative_savings_buyer_employee_id` FOREIGN KEY (`savings_buyer_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_document` ADD CONSTRAINT `fk_procurement_procurement_document_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`auto_approval_rule` ADD CONSTRAINT `fk_procurement_auto_approval_rule_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ADD CONSTRAINT `fk_procurement_procurement_approval_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ADD CONSTRAINT `fk_procurement_procurement_approval_procurement_approval_delegated_to_employee_id` FOREIGN KEY (`procurement_approval_delegated_to_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ADD CONSTRAINT `fk_procurement_procurement_approval_procurement_approval_employee_id` FOREIGN KEY (`procurement_approval_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`procurement`.`procurement_approval` ADD CONSTRAINT `fk_procurement_procurement_approval_procurement_delegated_to_employee_id` FOREIGN KEY (`procurement_delegated_to_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= product --> billing (1 constraint(s)) =========
-- Requires: product schema, billing schema
ALTER TABLE `vibe_automotive_v1`.`product`.`pricing_condition_assignment` ADD CONSTRAINT `fk_product_pricing_condition_assignment_billing_price_condition_id` FOREIGN KEY (`billing_price_condition_id`) REFERENCES `vibe_automotive_v1`.`billing`.`billing_price_condition`(`billing_price_condition_id`);

-- ========= product --> compliance (3 constraint(s)) =========
-- Requires: product schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_homologation_record_id` FOREIGN KEY (`homologation_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_record`(`homologation_record_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ADD CONSTRAINT `fk_product_aftersales_model_year_program_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ADD CONSTRAINT `fk_product_aftersales_nameplate_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);

-- ========= product --> dealer (1 constraint(s)) =========
-- Requires: product schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`product`.`package_availability` ADD CONSTRAINT `fk_product_package_availability_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= product --> engineering (4 constraint(s)) =========
-- Requires: product schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`product`.`bom_header` ADD CONSTRAINT `fk_product_bom_header_bom_id` FOREIGN KEY (`bom_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`bom`(`bom_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`product_bom_line` ADD CONSTRAINT `fk_product_product_bom_line_engineering_bom_line_id` FOREIGN KEY (`engineering_bom_line_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`engineering_bom_line`(`engineering_bom_line_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`product_bom_line` ADD CONSTRAINT `fk_product_product_bom_line_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ADD CONSTRAINT `fk_product_aftersales_model_year_program_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= product --> finance (5 constraint(s)) =========
-- Requires: product schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ADD CONSTRAINT `fk_product_aftersales_model_year_program_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ADD CONSTRAINT `fk_product_aftersales_model_year_program_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ADD CONSTRAINT `fk_product_aftersales_nameplate_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ADD CONSTRAINT `fk_product_aftersales_nameplate_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);

-- ========= product --> inventory (1 constraint(s)) =========
-- Requires: product schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);

-- ========= product --> manufacturing (3 constraint(s)) =========
-- Requires: product schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_production_bom_id` FOREIGN KEY (`production_bom_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_bom`(`production_bom_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ADD CONSTRAINT `fk_product_aftersales_model_year_program_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ADD CONSTRAINT `fk_product_aftersales_nameplate_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);

-- ========= product --> quality (2 constraint(s)) =========
-- Requires: product schema, quality schema
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ADD CONSTRAINT `fk_product_aftersales_model_year_program_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ADD CONSTRAINT `fk_product_aftersales_model_year_program_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `vibe_automotive_v1`.`quality`.`inspection_plan`(`inspection_plan_id`);

-- ========= product --> sales (2 constraint(s)) =========
-- Requires: product schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ADD CONSTRAINT `fk_product_catalog_publication_configurator_session_id` FOREIGN KEY (`configurator_session_id`) REFERENCES `vibe_automotive_v1`.`sales`.`configurator_session`(`configurator_session_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ADD CONSTRAINT `fk_product_order_guide_online_order_id` FOREIGN KEY (`online_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`online_order`(`online_order_id`);

-- ========= product --> vehicle (2 constraint(s)) =========
-- Requires: product schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_aftersales_body_style_id` FOREIGN KEY (`aftersales_body_style_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`aftersales_body_style`(`aftersales_body_style_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`sku` ADD CONSTRAINT `fk_product_sku_aftersales_color_option_id` FOREIGN KEY (`aftersales_color_option_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`aftersales_color_option`(`aftersales_color_option_id`);

-- ========= product --> workforce (12 constraint(s)) =========
-- Requires: product schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ADD CONSTRAINT `fk_product_catalog_publication_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ADD CONSTRAINT `fk_product_catalog_publication_primary_catalog_employee_id` FOREIGN KEY (`primary_catalog_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`catalog_publication` ADD CONSTRAINT `fk_product_catalog_publication_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ADD CONSTRAINT `fk_product_aftersales_model_year_program_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_model_year_program` ADD CONSTRAINT `fk_product_aftersales_model_year_program_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`msrp_price_book` ADD CONSTRAINT `fk_product_msrp_price_book_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ADD CONSTRAINT `fk_product_order_guide_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ADD CONSTRAINT `fk_product_order_guide_order_last_modified_by_user_employee_id` FOREIGN KEY (`order_last_modified_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ADD CONSTRAINT `fk_product_order_guide_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ADD CONSTRAINT `fk_product_order_guide_primary_order_employee_id` FOREIGN KEY (`primary_order_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`order_guide` ADD CONSTRAINT `fk_product_order_guide_tertiary_order_last_modified_by_user_employee_id` FOREIGN KEY (`tertiary_order_last_modified_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`product`.`aftersales_nameplate` ADD CONSTRAINT `fk_product_aftersales_nameplate_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= quality --> aftersales (4 constraint(s)) =========
-- Requires: quality schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_aftersales_warranty_claim_id` FOREIGN KEY (`aftersales_warranty_claim_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`aftersales_warranty_claim`(`aftersales_warranty_claim_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_tsb_id` FOREIGN KEY (`tsb_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`tsb`(`tsb_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ADD CONSTRAINT `fk_quality_calibration_event_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`technician`(`technician_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_service_center_id` FOREIGN KEY (`service_center_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_center`(`service_center_id`);

-- ========= quality --> asset (11 constraint(s)) =========
-- Requires: quality schema, asset schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ADD CONSTRAINT `fk_quality_spc_chart_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ADD CONSTRAINT `fk_quality_spc_data_point_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ADD CONSTRAINT `fk_quality_spc_data_point_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ADD CONSTRAINT `fk_quality_gauge_master_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ADD CONSTRAINT `fk_quality_calibration_event_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`calibration_event` ADD CONSTRAINT `fk_quality_calibration_event_primary_equipment_registry_id` FOREIGN KEY (`primary_equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ADD CONSTRAINT `fk_quality_quality_gate_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);

-- ========= quality --> billing (1 constraint(s)) =========
-- Requires: quality schema, billing schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_credit_memo_id` FOREIGN KEY (`credit_memo_id`) REFERENCES `vibe_automotive_v1`.`billing`.`credit_memo`(`credit_memo_id`);

-- ========= quality --> compliance (6 constraint(s)) =========
-- Requires: quality schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ADD CONSTRAINT `fk_quality_apqp_plan_homologation_record_id` FOREIGN KEY (`homologation_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_record`(`homologation_record_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_recall_defect_report_id` FOREIGN KEY (`recall_defect_report_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`recall_defect_report`(`recall_defect_report_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_audit_finding` ADD CONSTRAINT `fk_quality_quality_audit_finding_compliance_audit_finding_id` FOREIGN KEY (`compliance_audit_finding_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_audit_finding`(`compliance_audit_finding_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ADD CONSTRAINT `fk_quality_ncap_test_result_ncap_submission_id` FOREIGN KEY (`ncap_submission_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`ncap_submission`(`ncap_submission_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`standard` ADD CONSTRAINT `fk_quality_standard_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);

-- ========= quality --> customer (5 constraint(s)) =========
-- Requires: quality schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_vehicle_ownership_id` FOREIGN KEY (`vehicle_ownership_id`) REFERENCES `vibe_automotive_v1`.`customer`.`vehicle_ownership`(`vehicle_ownership_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_case_id` FOREIGN KEY (`case_id`) REFERENCES `vibe_automotive_v1`.`customer`.`case`(`case_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_warranty_customer_party_id` FOREIGN KEY (`warranty_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= quality --> dealer (7 constraint(s)) =========
-- Requires: quality schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_warranty_dealer_dealership_id` FOREIGN KEY (`warranty_dealer_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ADD CONSTRAINT `fk_quality_notification_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ADD CONSTRAINT `fk_quality_target_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= quality --> engineering (11 constraint(s)) =========
-- Requires: quality schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ADD CONSTRAINT `fk_quality_apqp_plan_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_design_specification_id` FOREIGN KEY (`design_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`design_specification`(`design_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_engineering_bom_component_id` FOREIGN KEY (`engineering_bom_component_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`engineering_bom_component`(`engineering_bom_component_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_design_specification_id` FOREIGN KEY (`design_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`design_specification`(`design_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ADD CONSTRAINT `fk_quality_ncap_test_result_change_id` FOREIGN KEY (`change_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`change`(`change_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ADD CONSTRAINT `fk_quality_ncap_test_result_engineering_test_result_id` FOREIGN KEY (`engineering_test_result_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`engineering_test_result`(`engineering_test_result_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ADD CONSTRAINT `fk_quality_wltp_test_result_engineering_test_result_id` FOREIGN KEY (`engineering_test_result_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`engineering_test_result`(`engineering_test_result_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code` ADD CONSTRAINT `fk_quality_defect_code_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ADD CONSTRAINT `fk_quality_target_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= quality --> field_services (10 constraint(s)) =========
-- Requires: quality schema, field_services schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_field_visit_id` FOREIGN KEY (`field_visit_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_visit`(`field_visit_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_corrective_action` ADD CONSTRAINT `fk_quality_quality_corrective_action_field_engineering_report_id` FOREIGN KEY (`field_engineering_report_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_engineering_report`(`field_engineering_report_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_field_visit_id` FOREIGN KEY (`field_visit_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_visit`(`field_visit_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_pdi_inspection` ADD CONSTRAINT `fk_quality_quality_pdi_inspection_field_visit_id` FOREIGN KEY (`field_visit_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_visit`(`field_visit_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_field_failure_analysis_id` FOREIGN KEY (`field_failure_analysis_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_failure_analysis`(`field_failure_analysis_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_breakdown_case_id` FOREIGN KEY (`breakdown_case_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`breakdown_case`(`breakdown_case_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ADD CONSTRAINT `fk_quality_notification_field_visit_id` FOREIGN KEY (`field_visit_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_visit`(`field_visit_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` ADD CONSTRAINT `fk_quality_defect_code_assignment_field_quality_investigation_id` FOREIGN KEY (`field_quality_investigation_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_quality_investigation`(`field_quality_investigation_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`root_cause_analysis` ADD CONSTRAINT `fk_quality_root_cause_analysis_field_failure_analysis_id` FOREIGN KEY (`field_failure_analysis_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_failure_analysis`(`field_failure_analysis_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`field_return` ADD CONSTRAINT `fk_quality_field_return_field_failure_analysis_id` FOREIGN KEY (`field_failure_analysis_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_failure_analysis`(`field_failure_analysis_id`);

-- ========= quality --> finance (5 constraint(s)) =========
-- Requires: quality schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_automotive_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_gate` ADD CONSTRAINT `fk_quality_quality_gate_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= quality --> inventory (4 constraint(s)) =========
-- Requires: quality schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ADD CONSTRAINT `fk_quality_ppm_record_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_code_assignment` ADD CONSTRAINT `fk_quality_defect_code_assignment_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);

-- ========= quality --> logistics (5 constraint(s)) =========
-- Requires: quality schema, logistics schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_pdi_inspection` ADD CONSTRAINT `fk_quality_quality_pdi_inspection_logistics_pdi_inspection_id` FOREIGN KEY (`logistics_pdi_inspection_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`logistics_pdi_inspection`(`logistics_pdi_inspection_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ADD CONSTRAINT `fk_quality_notification_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);

-- ========= quality --> manufacturing (12 constraint(s)) =========
-- Requires: quality schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_chart` ADD CONSTRAINT `fk_quality_spc_chart_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ADD CONSTRAINT `fk_quality_spc_data_point_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ADD CONSTRAINT `fk_quality_spc_data_point_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_corrective_action` ADD CONSTRAINT `fk_quality_quality_corrective_action_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ADD CONSTRAINT `fk_quality_target_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ADD CONSTRAINT `fk_quality_target_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);

-- ========= quality --> mobility (4 constraint(s)) =========
-- Requires: quality schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_telemetry_event_id` FOREIGN KEY (`telemetry_event_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`telemetry_event`(`telemetry_event_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_pdi_inspection` ADD CONSTRAINT `fk_quality_quality_pdi_inspection_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ADD CONSTRAINT `fk_quality_gate_result_trip_id` FOREIGN KEY (`trip_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`trip`(`trip_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_connected_vehicle_id` FOREIGN KEY (`connected_vehicle_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`connected_vehicle`(`connected_vehicle_id`);

-- ========= quality --> procurement (3 constraint(s)) =========
-- Requires: quality schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ADD CONSTRAINT `fk_quality_ppm_record_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ADD CONSTRAINT `fk_quality_target_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);

-- ========= quality --> sales (2 constraint(s)) =========
-- Requires: quality schema, sales schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ADD CONSTRAINT `fk_quality_gate_result_vehicle_order_id` FOREIGN KEY (`vehicle_order_id`) REFERENCES `vibe_automotive_v1`.`sales`.`vehicle_order`(`vehicle_order_id`);

-- ========= quality --> supply (3 constraint(s)) =========
-- Requires: quality schema, supply schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_inbound_part_id` FOREIGN KEY (`inbound_part_id`) REFERENCES `vibe_automotive_v1`.`supply`.`inbound_part`(`inbound_part_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_supply_supplier_id` FOREIGN KEY (`supply_supplier_id`) REFERENCES `vibe_automotive_v1`.`supply`.`supply_supplier`(`supply_supplier_id`);

-- ========= quality --> vehicle (7 constraint(s)) =========
-- Requires: quality schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`apqp_plan` ADD CONSTRAINT `fk_quality_apqp_plan_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ADD CONSTRAINT `fk_quality_ncap_test_result_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ADD CONSTRAINT `fk_quality_ncap_test_result_primary_vin_registry_id` FOREIGN KEY (`primary_vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ADD CONSTRAINT `fk_quality_wltp_test_result_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ADD CONSTRAINT `fk_quality_gate_result_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`warranty_quality_signal` ADD CONSTRAINT `fk_quality_warranty_quality_signal_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);

-- ========= quality --> workforce (22 constraint(s)) =========
-- Requires: quality schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`defect_record` ADD CONSTRAINT `fk_quality_defect_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ADD CONSTRAINT `fk_quality_spc_data_point_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`spc_data_point` ADD CONSTRAINT `fk_quality_spc_data_point_spc_operator_employee_id` FOREIGN KEY (`spc_operator_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`quality_corrective_action` ADD CONSTRAINT `fk_quality_quality_corrective_action_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`ncap_test_result` ADD CONSTRAINT `fk_quality_ncap_test_result_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`wltp_test_result` ADD CONSTRAINT `fk_quality_wltp_test_result_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`gauge_master` ADD CONSTRAINT `fk_quality_gauge_master_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`ppm_record` ADD CONSTRAINT `fk_quality_ppm_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ADD CONSTRAINT `fk_quality_gate_result_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`gate_result` ADD CONSTRAINT `fk_quality_gate_result_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_supplier_investigation_owner_employee_id` FOREIGN KEY (`supplier_investigation_owner_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ADD CONSTRAINT `fk_quality_notification_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`notification` ADD CONSTRAINT `fk_quality_notification_tertiary_notification_employee_id` FOREIGN KEY (`tertiary_notification_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ADD CONSTRAINT `fk_quality_target_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`quality`.`target` ADD CONSTRAINT `fk_quality_target_target_responsible_owner_employee_id` FOREIGN KEY (`target_responsible_owner_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= sales --> aftersales (1 constraint(s)) =========
-- Requires: sales schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`technician`(`technician_id`);

-- ========= sales --> compliance (4 constraint(s)) =========
-- Requires: sales schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_homologation_record_id` FOREIGN KEY (`homologation_record_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_record`(`homologation_record_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ADD CONSTRAINT `fk_sales_contract_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);

-- ========= sales --> customer (36 constraint(s)) =========
-- Requires: sales schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_quote_customer_party_id` FOREIGN KEY (`quote_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_contact_point_id` FOREIGN KEY (`contact_point_id`) REFERENCES `vibe_automotive_v1`.`customer`.`contact_point`(`contact_point_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_vehicle_customer_party_id` FOREIGN KEY (`vehicle_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_customer_fleet_account_id` FOREIGN KEY (`customer_fleet_account_id`) REFERENCES `vibe_automotive_v1`.`customer`.`customer_fleet_account`(`customer_fleet_account_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_contact_point_id` FOREIGN KEY (`contact_point_id`) REFERENCES `vibe_automotive_v1`.`customer`.`contact_point`(`contact_point_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ADD CONSTRAINT `fk_sales_trade_in_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ADD CONSTRAINT `fk_sales_trade_in_trade_customer_party_id` FOREIGN KEY (`trade_customer_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ADD CONSTRAINT `fk_sales_price_adjustment_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ADD CONSTRAINT `fk_sales_price_adjustment_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ADD CONSTRAINT `fk_sales_campaign_response_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ADD CONSTRAINT `fk_sales_campaign_response_individual_id` FOREIGN KEY (`individual_id`) REFERENCES `vibe_automotive_v1`.`customer`.`individual`(`individual_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ADD CONSTRAINT `fk_sales_campaign_response_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ADD CONSTRAINT `fk_sales_contract_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ADD CONSTRAINT `fk_sales_contract_primary_party_id` FOREIGN KEY (`primary_party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ADD CONSTRAINT `fk_sales_sales_lead_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`finance_contract` ADD CONSTRAINT `fk_sales_finance_contract_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`lease_contract` ADD CONSTRAINT `fk_sales_lease_contract_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`insurance_policy` ADD CONSTRAINT `fk_sales_insurance_policy_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`credit_application` ADD CONSTRAINT `fk_sales_credit_application_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`configurator_session` ADD CONSTRAINT `fk_sales_configurator_session_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`online_order` ADD CONSTRAINT `fk_sales_online_order_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`ecommerce_cart` ADD CONSTRAINT `fk_sales_ecommerce_cart_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`digital_sales_lead` ADD CONSTRAINT `fk_sales_digital_sales_lead_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_subscription` ADD CONSTRAINT `fk_sales_vehicle_subscription_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= sales --> dealer (33 constraint(s)) =========
-- Requires: sales schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_quote_dealer_dealership_id` FOREIGN KEY (`quote_dealer_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_dealer_incentive_program_id` FOREIGN KEY (`dealer_incentive_program_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_incentive_program`(`dealer_incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_claim` ADD CONSTRAINT `fk_sales_sales_incentive_claim_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_dealer_incentive_program_id` FOREIGN KEY (`dealer_incentive_program_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_incentive_program`(`dealer_incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ADD CONSTRAINT `fk_sales_fleet_contract_line_dealer_incentive_program_id` FOREIGN KEY (`dealer_incentive_program_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_incentive_program`(`dealer_incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ADD CONSTRAINT `fk_sales_fleet_contract_line_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ADD CONSTRAINT `fk_sales_quota_dealer_incentive_program_id` FOREIGN KEY (`dealer_incentive_program_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_incentive_program`(`dealer_incentive_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ADD CONSTRAINT `fk_sales_quota_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_dealer_contact_id` FOREIGN KEY (`dealer_contact_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealer_contact`(`dealer_contact_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_test_drive` ADD CONSTRAINT `fk_sales_sales_test_drive_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ADD CONSTRAINT `fk_sales_trade_in_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ADD CONSTRAINT `fk_sales_price_adjustment_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ADD CONSTRAINT `fk_sales_campaign_response_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ADD CONSTRAINT `fk_sales_contract_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`dealer_rep_assignment` ADD CONSTRAINT `fk_sales_dealer_rep_assignment_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ADD CONSTRAINT `fk_sales_sales_lead_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ADD CONSTRAINT `fk_sales_sales_lead_sales_assigned_dealer_dealership_id` FOREIGN KEY (`sales_assigned_dealer_dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`finance_contract` ADD CONSTRAINT `fk_sales_finance_contract_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`lease_contract` ADD CONSTRAINT `fk_sales_lease_contract_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`insurance_policy` ADD CONSTRAINT `fk_sales_insurance_policy_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fni_menu_product` ADD CONSTRAINT `fk_sales_fni_menu_product_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`credit_application` ADD CONSTRAINT `fk_sales_credit_application_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`configurator_session` ADD CONSTRAINT `fk_sales_configurator_session_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`online_order` ADD CONSTRAINT `fk_sales_online_order_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`digital_sales_lead` ADD CONSTRAINT `fk_sales_digital_sales_lead_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_subscription` ADD CONSTRAINT `fk_sales_vehicle_subscription_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= sales --> engineering (5 constraint(s)) =========
-- Requires: sales schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_program` ADD CONSTRAINT `fk_sales_sales_incentive_program_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);

-- ========= sales --> field_services (14 constraint(s)) =========
-- Requires: sales schema, field_services schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_claim` ADD CONSTRAINT `fk_sales_sales_incentive_claim_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ADD CONSTRAINT `fk_sales_fleet_contract_line_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ADD CONSTRAINT `fk_sales_msrp_schedule_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ADD CONSTRAINT `fk_sales_sales_territory_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ADD CONSTRAINT `fk_sales_trade_in_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ADD CONSTRAINT `fk_sales_price_adjustment_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign_response` ADD CONSTRAINT `fk_sales_campaign_response_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ADD CONSTRAINT `fk_sales_contract_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ADD CONSTRAINT `fk_sales_regional_sales_plan_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`finance_contract` ADD CONSTRAINT `fk_sales_finance_contract_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`lease_contract` ADD CONSTRAINT `fk_sales_lease_contract_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`configurator_session` ADD CONSTRAINT `fk_sales_configurator_session_field_service_appointment_id` FOREIGN KEY (`field_service_appointment_id`) REFERENCES `vibe_automotive_v1`.`field_services`.`field_service_appointment`(`field_service_appointment_id`);

-- ========= sales --> finance (5 constraint(s)) =========
-- Requires: sales schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_automotive_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`profit_center`(`profit_center_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ADD CONSTRAINT `fk_sales_price_adjustment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);

-- ========= sales --> inventory (1 constraint(s)) =========
-- Requires: sales schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ADD CONSTRAINT `fk_sales_fleet_contract_line_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);

-- ========= sales --> logistics (1 constraint(s)) =========
-- Requires: sales schema, logistics schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`shipment`(`shipment_id`);

-- ========= sales --> mobility (2 constraint(s)) =========
-- Requires: sales schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_mobility_service_id` FOREIGN KEY (`mobility_service_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`mobility_service`(`mobility_service_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_service_subscription_id` FOREIGN KEY (`service_subscription_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`service_subscription`(`service_subscription_id`);

-- ========= sales --> product (17 constraint(s)) =========
-- Requires: sales schema, product schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_aftersales_trim_level_id` FOREIGN KEY (`aftersales_trim_level_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_trim_level`(`aftersales_trim_level_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ADD CONSTRAINT `fk_sales_msrp_schedule_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ADD CONSTRAINT `fk_sales_campaign_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`residual_value_schedule` ADD CONSTRAINT `fk_sales_residual_value_schedule_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`residual_value_schedule` ADD CONSTRAINT `fk_sales_residual_value_schedule_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`configurator_session` ADD CONSTRAINT `fk_sales_configurator_session_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`configurator_session` ADD CONSTRAINT `fk_sales_configurator_session_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`online_order` ADD CONSTRAINT `fk_sales_online_order_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`ecommerce_cart` ADD CONSTRAINT `fk_sales_ecommerce_cart_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`digital_sales_lead` ADD CONSTRAINT `fk_sales_digital_sales_lead_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`digital_sales_lead` ADD CONSTRAINT `fk_sales_digital_sales_lead_nameplate_id` FOREIGN KEY (`nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_subscription` ADD CONSTRAINT `fk_sales_vehicle_subscription_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_subscription` ADD CONSTRAINT `fk_sales_vehicle_subscription_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);

-- ========= sales --> vehicle (42 constraint(s)) =========
-- Requires: sales schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_primary_model_id` FOREIGN KEY (`primary_model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_quote_vehicle_vin_registry_id` FOREIGN KEY (`quote_vehicle_vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_quote_vehicle_vin_registry_id` FOREIGN KEY (`quote_vehicle_vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote_line` ADD CONSTRAINT `fk_sales_quote_line_vehicle_option_package_id` FOREIGN KEY (`vehicle_option_package_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vehicle_option_package`(`vehicle_option_package_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_tertiary_vehicle_order_vin_registry_id` FOREIGN KEY (`tertiary_vehicle_order_vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_order_vehicle_vin_registry_id` FOREIGN KEY (`order_vehicle_vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_primary_vin_registry_id` FOREIGN KEY (`primary_vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_vehicle_option_package_id` FOREIGN KEY (`vehicle_option_package_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vehicle_option_package`(`vehicle_option_package_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_incentive_claim` ADD CONSTRAINT `fk_sales_sales_incentive_claim_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ADD CONSTRAINT `fk_sales_fleet_contract_line_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ADD CONSTRAINT `fk_sales_fleet_contract_line_primary_vin_registry_id` FOREIGN KEY (`primary_vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`msrp_schedule` ADD CONSTRAINT `fk_sales_msrp_schedule_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_primary_vin_registry_id` FOREIGN KEY (`primary_vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_test_drive` ADD CONSTRAINT `fk_sales_sales_test_drive_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_primary_vin_registry_id` FOREIGN KEY (`primary_vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ADD CONSTRAINT `fk_sales_price_adjustment_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ADD CONSTRAINT `fk_sales_price_adjustment_primary_vin_registry_id` FOREIGN KEY (`primary_vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_primary_vin_registry_id` FOREIGN KEY (`primary_vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`competitor_vehicle` ADD CONSTRAINT `fk_sales_competitor_vehicle_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ADD CONSTRAINT `fk_sales_contract_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ADD CONSTRAINT `fk_sales_contract_primary_vin_registry_id` FOREIGN KEY (`primary_vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`finance_contract` ADD CONSTRAINT `fk_sales_finance_contract_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`lease_contract` ADD CONSTRAINT `fk_sales_lease_contract_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`insurance_policy` ADD CONSTRAINT `fk_sales_insurance_policy_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`configurator_session` ADD CONSTRAINT `fk_sales_configurator_session_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`configurator_session` ADD CONSTRAINT `fk_sales_configurator_session_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`online_order` ADD CONSTRAINT `fk_sales_online_order_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`ecommerce_cart` ADD CONSTRAINT `fk_sales_ecommerce_cart_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`digital_sales_lead` ADD CONSTRAINT `fk_sales_digital_sales_lead_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_subscription` ADD CONSTRAINT `fk_sales_vehicle_subscription_vin_registry_id` FOREIGN KEY (`vin_registry_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`vin_registry`(`vin_registry_id`);

-- ========= sales --> workforce (26 constraint(s)) =========
-- Requires: sales schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`sales`.`opportunity` ADD CONSTRAINT `fk_sales_opportunity_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quote` ADD CONSTRAINT `fk_sales_quote_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`vehicle_order` ADD CONSTRAINT `fk_sales_vehicle_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_line` ADD CONSTRAINT `fk_sales_order_line_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract` ADD CONSTRAINT `fk_sales_fleet_contract_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`fleet_contract_line` ADD CONSTRAINT `fk_sales_fleet_contract_line_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ADD CONSTRAINT `fk_sales_sales_territory_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ADD CONSTRAINT `fk_sales_sales_territory_primary_sales_manager_employee_id` FOREIGN KEY (`primary_sales_manager_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_territory` ADD CONSTRAINT `fk_sales_sales_territory_tertiary_sales_regional_director_employee_id` FOREIGN KEY (`tertiary_sales_regional_director_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ADD CONSTRAINT `fk_sales_rep_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`rep` ADD CONSTRAINT `fk_sales_rep_tertiary_rep_manager_employee_id` FOREIGN KEY (`tertiary_rep_manager_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`quota` ADD CONSTRAINT `fk_sales_quota_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ADD CONSTRAINT `fk_sales_trade_in_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`trade_in` ADD CONSTRAINT `fk_sales_trade_in_trade_appraiser_employee_id` FOREIGN KEY (`trade_appraiser_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`delivery_appointment` ADD CONSTRAINT `fk_sales_delivery_appointment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ADD CONSTRAINT `fk_sales_price_adjustment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`price_adjustment` ADD CONSTRAINT `fk_sales_price_adjustment_primary_price_employee_id` FOREIGN KEY (`primary_price_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`order_status_event` ADD CONSTRAINT `fk_sales_order_status_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ADD CONSTRAINT `fk_sales_campaign_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`campaign` ADD CONSTRAINT `fk_sales_campaign_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`contract` ADD CONSTRAINT `fk_sales_contract_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ADD CONSTRAINT `fk_sales_regional_sales_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ADD CONSTRAINT `fk_sales_regional_sales_plan_primary_regional_employee_id` FOREIGN KEY (`primary_regional_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`regional_sales_plan` ADD CONSTRAINT `fk_sales_regional_sales_plan_tertiary_regional_created_by_user_employee_id` FOREIGN KEY (`tertiary_regional_created_by_user_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`sales`.`sales_lead` ADD CONSTRAINT `fk_sales_sales_lead_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= supply --> compliance (8 constraint(s)) =========
-- Requires: supply schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier` ADD CONSTRAINT `fk_supply_supply_supplier_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ADD CONSTRAINT `fk_supply_inbound_part_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ADD CONSTRAINT `fk_supply_inbound_part_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ADD CONSTRAINT `fk_supply_inbound_shipment_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ADD CONSTRAINT `fk_supply_inbound_shipment_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ADD CONSTRAINT `fk_supply_ckd_kit_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ADD CONSTRAINT `fk_supply_supplier_deviation_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ADD CONSTRAINT `fk_supply_tooling_asset_compliance_document_id` FOREIGN KEY (`compliance_document_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_document`(`compliance_document_id`);

-- ========= supply --> engineering (2 constraint(s)) =========
-- Requires: supply schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ADD CONSTRAINT `fk_supply_inbound_part_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ADD CONSTRAINT `fk_supply_rfq_part_master_id` FOREIGN KEY (`part_master_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`part_master`(`part_master_id`);

-- ========= supply --> finance (3 constraint(s)) =========
-- Requires: supply schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ADD CONSTRAINT `fk_supply_inbound_part_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`tooling_asset` ADD CONSTRAINT `fk_supply_tooling_asset_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_automotive_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ADD CONSTRAINT `fk_supply_price_agreement_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_automotive_v1`.`finance`.`gl_account`(`gl_account_id`);

-- ========= supply --> inventory (4 constraint(s)) =========
-- Requires: supply schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_part` ADD CONSTRAINT `fk_supply_inbound_part_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ADD CONSTRAINT `fk_supply_supplier_deviation_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ADD CONSTRAINT `fk_supply_inbound_inspection_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ADD CONSTRAINT `fk_supply_price_agreement_sku_master_id` FOREIGN KEY (`sku_master_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`sku_master`(`sku_master_id`);

-- ========= supply --> logistics (3 constraint(s)) =========
-- Requires: supply schema, logistics schema
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_delivery_schedule` ADD CONSTRAINT `fk_supply_supply_delivery_schedule_logistics_delivery_schedule_id` FOREIGN KEY (`logistics_delivery_schedule_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`logistics_delivery_schedule`(`logistics_delivery_schedule_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ADD CONSTRAINT `fk_supply_inbound_shipment_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ADD CONSTRAINT `fk_supply_ckd_shipment_ckd_kit_shipment_id` FOREIGN KEY (`ckd_kit_shipment_id`) REFERENCES `vibe_automotive_v1`.`logistics`.`ckd_kit_shipment`(`ckd_kit_shipment_id`);

-- ========= supply --> manufacturing (6 constraint(s)) =========
-- Requires: supply schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ADD CONSTRAINT `fk_supply_inbound_shipment_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ADD CONSTRAINT `fk_supply_ckd_kit_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_shipment` ADD CONSTRAINT `fk_supply_ckd_shipment_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_scorecard` ADD CONSTRAINT `fk_supply_supplier_scorecard_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`disruption` ADD CONSTRAINT `fk_supply_disruption_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_event` ADD CONSTRAINT `fk_supply_inbound_event_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);

-- ========= supply --> procurement (9 constraint(s)) =========
-- Requires: supply schema, procurement schema
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_supplier_plant` ADD CONSTRAINT `fk_supply_supply_supplier_plant_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_purchase_order` ADD CONSTRAINT `fk_supply_supply_purchase_order_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_po_line` ADD CONSTRAINT `fk_supply_supply_po_line_procurement_po_line_id` FOREIGN KEY (`procurement_po_line_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_po_line`(`procurement_po_line_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`ppap_element` ADD CONSTRAINT `fk_supply_ppap_element_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ADD CONSTRAINT `fk_supply_inbound_shipment_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_goods_receipt` ADD CONSTRAINT `fk_supply_supply_goods_receipt_procurement_goods_receipt_id` FOREIGN KEY (`procurement_goods_receipt_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_goods_receipt`(`procurement_goods_receipt_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ADD CONSTRAINT `fk_supply_ckd_kit_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_deviation` ADD CONSTRAINT `fk_supply_supplier_deviation_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ADD CONSTRAINT `fk_supply_inbound_inspection_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `vibe_automotive_v1`.`procurement`.`procurement_supplier`(`procurement_supplier_id`);

-- ========= supply --> product (2 constraint(s)) =========
-- Requires: supply schema, product schema
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ADD CONSTRAINT `fk_supply_inbound_inspection_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`price_agreement` ADD CONSTRAINT `fk_supply_price_agreement_sku_id` FOREIGN KEY (`sku_id`) REFERENCES `vibe_automotive_v1`.`product`.`sku`(`sku_id`);

-- ========= supply --> quality (2 constraint(s)) =========
-- Requires: supply schema, quality schema
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_ppap_submission` ADD CONSTRAINT `fk_supply_supply_ppap_submission_quality_ppap_submission_id` FOREIGN KEY (`quality_ppap_submission_id`) REFERENCES `vibe_automotive_v1`.`quality`.`quality_ppap_submission`(`quality_ppap_submission_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` ADD CONSTRAINT `fk_supply_supply_corrective_action_quality_corrective_action_id` FOREIGN KEY (`quality_corrective_action_id`) REFERENCES `vibe_automotive_v1`.`quality`.`quality_corrective_action`(`quality_corrective_action_id`);

-- ========= supply --> vehicle (2 constraint(s)) =========
-- Requires: supply schema, vehicle schema
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ADD CONSTRAINT `fk_supply_ckd_kit_configuration_id` FOREIGN KEY (`configuration_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`configuration`(`configuration_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`ckd_kit` ADD CONSTRAINT `fk_supply_ckd_kit_model_id` FOREIGN KEY (`model_id`) REFERENCES `vibe_automotive_v1`.`vehicle`.`model`(`model_id`);

-- ========= supply --> workforce (11 constraint(s)) =========
-- Requires: supply schema, workforce schema
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ADD CONSTRAINT `fk_supply_supplier_part_approval_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_part_approval` ADD CONSTRAINT `fk_supply_supplier_part_approval_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ADD CONSTRAINT `fk_supply_sourcing_nomination_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`sourcing_nomination` ADD CONSTRAINT `fk_supply_sourcing_nomination_sourcing_buyer_employee_id` FOREIGN KEY (`sourcing_buyer_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ADD CONSTRAINT `fk_supply_rfq_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`rfq` ADD CONSTRAINT `fk_supply_rfq_rfq_buyer_employee_id` FOREIGN KEY (`rfq_buyer_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_shipment` ADD CONSTRAINT `fk_supply_inbound_shipment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supply_corrective_action` ADD CONSTRAINT `fk_supply_supply_corrective_action_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`supplier_audit` ADD CONSTRAINT `fk_supply_supplier_audit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ADD CONSTRAINT `fk_supply_inbound_inspection_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_automotive_v1`.`supply`.`inbound_inspection` ADD CONSTRAINT `fk_supply_inbound_inspection_primary_employee_id` FOREIGN KEY (`primary_employee_id`) REFERENCES `vibe_automotive_v1`.`workforce`.`employee`(`employee_id`);

-- ========= vehicle --> aftersales (1 constraint(s)) =========
-- Requires: vehicle schema, aftersales schema
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`campaign_enrollment` ADD CONSTRAINT `fk_vehicle_campaign_enrollment_service_campaign_id` FOREIGN KEY (`service_campaign_id`) REFERENCES `vibe_automotive_v1`.`aftersales`.`service_campaign`(`service_campaign_id`);

-- ========= vehicle --> compliance (3 constraint(s)) =========
-- Requires: vehicle schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`homologation` ADD CONSTRAINT `fk_vehicle_homologation_homologation_variant_id` FOREIGN KEY (`homologation_variant_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`homologation_variant`(`homologation_variant_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_emissions_certification` ADD CONSTRAINT `fk_vehicle_vehicle_emissions_certification_compliance_emissions_certification_id` FOREIGN KEY (`compliance_emissions_certification_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification`(`compliance_emissions_certification_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`regulatory_compliance_assignment` ADD CONSTRAINT `fk_vehicle_regulatory_compliance_assignment_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`regulatory_requirement`(`regulatory_requirement_id`);

-- ========= vehicle --> customer (1 constraint(s)) =========
-- Requires: vehicle schema, customer schema
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ownership` ADD CONSTRAINT `fk_vehicle_ownership_party_id` FOREIGN KEY (`party_id`) REFERENCES `vibe_automotive_v1`.`customer`.`party`(`party_id`);

-- ========= vehicle --> engineering (5 constraint(s)) =========
-- Requires: vehicle schema, engineering schema
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ADD CONSTRAINT `fk_vehicle_model_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`platform` ADD CONSTRAINT `fk_vehicle_platform_vehicle_program_id` FOREIGN KEY (`vehicle_program_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`vehicle_program`(`vehicle_program_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_adas_feature` ADD CONSTRAINT `fk_vehicle_vehicle_adas_feature_engineering_adas_feature_id` FOREIGN KEY (`engineering_adas_feature_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`engineering_adas_feature`(`engineering_adas_feature_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`ecu_catalog` ADD CONSTRAINT `fk_vehicle_ecu_catalog_ecu_specification_id` FOREIGN KEY (`ecu_specification_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`ecu_specification`(`ecu_specification_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ADD CONSTRAINT `fk_vehicle_powertrain_config_powertrain_spec_id` FOREIGN KEY (`powertrain_spec_id`) REFERENCES `vibe_automotive_v1`.`engineering`.`powertrain_spec`(`powertrain_spec_id`);

-- ========= vehicle --> mobility (1 constraint(s)) =========
-- Requires: vehicle schema, mobility schema
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ADD CONSTRAINT `fk_vehicle_vin_registry_telematics_device_id` FOREIGN KEY (`telematics_device_id`) REFERENCES `vibe_automotive_v1`.`mobility`.`telematics_device`(`telematics_device_id`);

-- ========= vehicle --> product (7 constraint(s)) =========
-- Requires: vehicle schema, product schema
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vin_registry` ADD CONSTRAINT `fk_vehicle_vin_registry_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`model` ADD CONSTRAINT `fk_vehicle_model_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_model_year_program` ADD CONSTRAINT `fk_vehicle_vehicle_model_year_program_aftersales_model_year_program_id` FOREIGN KEY (`aftersales_model_year_program_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_model_year_program`(`aftersales_model_year_program_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_trim_level` ADD CONSTRAINT `fk_vehicle_vehicle_trim_level_aftersales_trim_level_id` FOREIGN KEY (`aftersales_trim_level_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_trim_level`(`aftersales_trim_level_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`configuration` ADD CONSTRAINT `fk_vehicle_configuration_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`vehicle_option_package` ADD CONSTRAINT `fk_vehicle_vehicle_option_package_aftersales_option_package_id` FOREIGN KEY (`aftersales_option_package_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_option_package`(`aftersales_option_package_id`);
ALTER TABLE `vibe_automotive_v1`.`vehicle`.`powertrain_config` ADD CONSTRAINT `fk_vehicle_powertrain_config_aftersales_nameplate_id` FOREIGN KEY (`aftersales_nameplate_id`) REFERENCES `vibe_automotive_v1`.`product`.`aftersales_nameplate`(`aftersales_nameplate_id`);

-- ========= workforce --> asset (3 constraint(s)) =========
-- Requires: workforce schema, asset schema
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ADD CONSTRAINT `fk_workforce_employee_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `vibe_automotive_v1`.`asset`.`functional_location`(`functional_location_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ADD CONSTRAINT `fk_workforce_safety_incident_equipment_registry_id` FOREIGN KEY (`equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`safety_incident` ADD CONSTRAINT `fk_workforce_safety_incident_safety_equipment_registry_id` FOREIGN KEY (`safety_equipment_registry_id`) REFERENCES `vibe_automotive_v1`.`asset`.`equipment_registry`(`equipment_registry_id`);

-- ========= workforce --> compliance (2 constraint(s)) =========
-- Requires: workforce schema, compliance schema
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ADD CONSTRAINT `fk_workforce_org_unit_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`workforce_certification` ADD CONSTRAINT `fk_workforce_workforce_certification_compliance_emissions_certification_id` FOREIGN KEY (`compliance_emissions_certification_id`) REFERENCES `vibe_automotive_v1`.`compliance`.`compliance_emissions_certification`(`compliance_emissions_certification_id`);

-- ========= workforce --> dealer (1 constraint(s)) =========
-- Requires: workforce schema, dealer schema
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ADD CONSTRAINT `fk_workforce_employee_dealership_id` FOREIGN KEY (`dealership_id`) REFERENCES `vibe_automotive_v1`.`dealer`.`dealership`(`dealership_id`);

-- ========= workforce --> finance (1 constraint(s)) =========
-- Requires: workforce schema, finance schema
ALTER TABLE `vibe_automotive_v1`.`workforce`.`org_unit` ADD CONSTRAINT `fk_workforce_org_unit_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `vibe_automotive_v1`.`finance`.`cost_center`(`cost_center_id`);

-- ========= workforce --> inventory (1 constraint(s)) =========
-- Requires: workforce schema, inventory schema
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ADD CONSTRAINT `fk_workforce_labor_cost_allocation_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `vibe_automotive_v1`.`inventory`.`storage_location`(`storage_location_id`);

-- ========= workforce --> manufacturing (10 constraint(s)) =========
-- Requires: workforce schema, manufacturing schema
ALTER TABLE `vibe_automotive_v1`.`workforce`.`employee` ADD CONSTRAINT `fk_workforce_employee_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`position` ADD CONSTRAINT `fk_workforce_position_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_production_line_id` FOREIGN KEY (`production_line_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_line`(`production_line_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`work_center`(`work_center_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_agreement` ADD CONSTRAINT `fk_workforce_labor_agreement_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`headcount_plan` ADD CONSTRAINT `fk_workforce_headcount_plan_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ADD CONSTRAINT `fk_workforce_labor_cost_allocation_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`plant`(`plant_id`);
ALTER TABLE `vibe_automotive_v1`.`workforce`.`labor_cost_allocation` ADD CONSTRAINT `fk_workforce_labor_cost_allocation_production_order_id` FOREIGN KEY (`production_order_id`) REFERENCES `vibe_automotive_v1`.`manufacturing`.`production_order`(`production_order_id`);

