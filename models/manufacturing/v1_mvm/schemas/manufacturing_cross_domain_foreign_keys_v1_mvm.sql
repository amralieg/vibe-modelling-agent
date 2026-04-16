-- Cross-Domain Foreign Keys for Business:  | Version: v1_mvm
-- Generated on: 2026-04-16 09:51:32
-- Total cross-domain FK constraints: 669
--
-- EXECUTION ORDER:
--   1. Run ALL domain schema files first (any order).
--   2. Run this file LAST.
--
-- PREREQUISITE DOMAINS: asset, customer, engineering, finance, inventory, logistics, order, procurement, product, production, quality, sales, service, shared

-- ========= asset --> finance (2 constraint(s)) =========
-- Requires: asset schema, finance schema
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ADD CONSTRAINT `fk_asset_asset_valuation_asset_transaction_id` FOREIGN KEY (`asset_transaction_id`) REFERENCES `manufacturing_ecm`.`finance`.`asset_transaction`(`asset_transaction_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ADD CONSTRAINT `fk_asset_asset_valuation_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);

-- ========= asset --> logistics (1 constraint(s)) =========
-- Requires: asset schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_freight_contract_id` FOREIGN KEY (`freight_contract_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_contract`(`freight_contract_id`);

-- ========= asset --> product (1 constraint(s)) =========
-- Requires: asset schema, product schema
ALTER TABLE `manufacturing_ecm`.`asset`.`class` ADD CONSTRAINT `fk_asset_class_classification_id` FOREIGN KEY (`classification_id`) REFERENCES `manufacturing_ecm`.`product`.`classification`(`classification_id`);

-- ========= asset --> sales (1 constraint(s)) =========
-- Requires: asset schema, sales schema
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_discount_structure_id` FOREIGN KEY (`discount_structure_id`) REFERENCES `manufacturing_ecm`.`sales`.`discount_structure`(`discount_structure_id`);

-- ========= asset --> service (2 constraint(s)) =========
-- Requires: asset schema, service schema
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_entitlement_id` FOREIGN KEY (`entitlement_id`) REFERENCES `manufacturing_ecm`.`service`.`entitlement`(`entitlement_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ADD CONSTRAINT `fk_asset_task_list_knowledge_article_id` FOREIGN KEY (`knowledge_article_id`) REFERENCES `manufacturing_ecm`.`service`.`knowledge_article`(`knowledge_article_id`);

-- ========= asset --> shared (39 constraint(s)) =========
-- Requires: asset schema, shared schema
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_account_hierarchy_id` FOREIGN KEY (`account_hierarchy_id`) REFERENCES `manufacturing_ecm`.`shared`.`account_hierarchy`(`account_hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_cost_allocation_id` FOREIGN KEY (`cost_allocation_id`) REFERENCES `manufacturing_ecm`.`shared`.`cost_allocation`(`cost_allocation_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_product_configuration_id` FOREIGN KEY (`product_configuration_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_configuration`(`product_configuration_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_tooling_equipment_id` FOREIGN KEY (`tooling_equipment_id`) REFERENCES `manufacturing_ecm`.`shared`.`tooling_equipment`(`tooling_equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ADD CONSTRAINT `fk_asset_maintenance_item_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ADD CONSTRAINT `fk_asset_maintenance_item_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ADD CONSTRAINT `fk_asset_asset_notification_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`shared`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ADD CONSTRAINT `fk_asset_asset_notification_installed_base_id` FOREIGN KEY (`installed_base_id`) REFERENCES `manufacturing_ecm`.`shared`.`installed_base`(`installed_base_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ADD CONSTRAINT `fk_asset_measurement_point_product_specification_id` FOREIGN KEY (`product_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_specification`(`product_specification_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ADD CONSTRAINT `fk_asset_measurement_reading_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_cost_allocation_id` FOREIGN KEY (`cost_allocation_id`) REFERENCES `manufacturing_ecm`.`shared`.`cost_allocation`(`cost_allocation_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_installed_base_id` FOREIGN KEY (`installed_base_id`) REFERENCES `manufacturing_ecm`.`shared`.`installed_base`(`installed_base_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_material_specification_id` FOREIGN KEY (`material_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`material_specification`(`material_specification_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_product_specification_id` FOREIGN KEY (`product_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_specification`(`product_specification_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_work_order_operation_id` FOREIGN KEY (`work_order_operation_id`) REFERENCES `manufacturing_ecm`.`shared`.`work_order_operation`(`work_order_operation_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ADD CONSTRAINT `fk_asset_asset_valuation_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ADD CONSTRAINT `fk_asset_asset_valuation_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ADD CONSTRAINT `fk_asset_asset_valuation_installed_base_id` FOREIGN KEY (`installed_base_id`) REFERENCES `manufacturing_ecm`.`shared`.`installed_base`(`installed_base_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ADD CONSTRAINT `fk_asset_asset_valuation_sales_price_list_id` FOREIGN KEY (`sales_price_list_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_price_list`(`sales_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_account_hierarchy_id` FOREIGN KEY (`account_hierarchy_id`) REFERENCES `manufacturing_ecm`.`shared`.`account_hierarchy`(`account_hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_approved_manufacturer_id` FOREIGN KEY (`approved_manufacturer_id`) REFERENCES `manufacturing_ecm`.`shared`.`approved_manufacturer`(`approved_manufacturer_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_installed_base_id` FOREIGN KEY (`installed_base_id`) REFERENCES `manufacturing_ecm`.`shared`.`installed_base`(`installed_base_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_sales_price_list_id` FOREIGN KEY (`sales_price_list_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_price_list`(`sales_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_warranty_policy_id` FOREIGN KEY (`warranty_policy_id`) REFERENCES `manufacturing_ecm`.`shared`.`warranty_policy`(`warranty_policy_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_account_hierarchy_id` FOREIGN KEY (`account_hierarchy_id`) REFERENCES `manufacturing_ecm`.`shared`.`account_hierarchy`(`account_hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ap_invoice`(`ap_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`shared`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_pricing_agreement_id` FOREIGN KEY (`pricing_agreement_id`) REFERENCES `manufacturing_ecm`.`shared`.`pricing_agreement`(`pricing_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_product_price_list_id` FOREIGN KEY (`product_price_list_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_price_list`(`product_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_sla_agreement_id` FOREIGN KEY (`sla_agreement_id`) REFERENCES `manufacturing_ecm`.`shared`.`sla_agreement`(`sla_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`shared`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ADD CONSTRAINT `fk_asset_task_list_product_configuration_id` FOREIGN KEY (`product_configuration_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_configuration`(`product_configuration_id`);

-- ========= customer --> shared (9 constraint(s)) =========
-- Requires: customer schema, shared schema
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ADD CONSTRAINT `fk_customer_credit_profile_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`shared`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ADD CONSTRAINT `fk_customer_partner_function_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`shared`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ADD CONSTRAINT `fk_customer_partner_function_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`shared`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ADD CONSTRAINT `fk_customer_account_classification_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `manufacturing_ecm`.`shared`.`segment`(`segment_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ADD CONSTRAINT `fk_customer_sales_area_assignment_pricing_agreement_id` FOREIGN KEY (`pricing_agreement_id`) REFERENCES `manufacturing_ecm`.`shared`.`pricing_agreement`(`pricing_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ADD CONSTRAINT `fk_customer_sales_area_assignment_sales_org_id` FOREIGN KEY (`sales_org_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_org`(`sales_org_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ADD CONSTRAINT `fk_customer_account_contact_role_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`shared`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_coverage_assignment` ADD CONSTRAINT `fk_customer_pricing_coverage_assignment_account_hierarchy_id` FOREIGN KEY (`account_hierarchy_id`) REFERENCES `manufacturing_ecm`.`shared`.`account_hierarchy`(`account_hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_coverage_assignment` ADD CONSTRAINT `fk_customer_pricing_coverage_assignment_pricing_agreement_id` FOREIGN KEY (`pricing_agreement_id`) REFERENCES `manufacturing_ecm`.`shared`.`pricing_agreement`(`pricing_agreement_id`);

-- ========= engineering --> product (1 constraint(s)) =========
-- Requires: engineering schema, product schema
ALTER TABLE `manufacturing_ecm`.`engineering`.`substitute_component` ADD CONSTRAINT `fk_engineering_substitute_component_substitution_id` FOREIGN KEY (`substitution_id`) REFERENCES `manufacturing_ecm`.`product`.`substitution`(`substitution_id`);

-- ========= engineering --> quality (4 constraint(s)) =========
-- Requires: engineering schema, quality schema
ALTER TABLE `manufacturing_ecm`.`engineering`.`change_affected_item` ADD CONSTRAINT `fk_engineering_change_affected_item_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`control_plan`(`control_plan_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`change_affected_item` ADD CONSTRAINT `fk_engineering_change_affected_item_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`dfmea` ADD CONSTRAINT `fk_engineering_dfmea_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `manufacturing_ecm`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`pfmea` ADD CONSTRAINT `fk_engineering_pfmea_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `manufacturing_ecm`.`quality`.`fmea`(`fmea_id`);

-- ========= engineering --> shared (22 constraint(s)) =========
-- Requires: engineering schema, shared schema
ALTER TABLE `manufacturing_ecm`.`engineering`.`bom_line` ADD CONSTRAINT `fk_engineering_bom_line_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`shared`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`bom_line` ADD CONSTRAINT `fk_engineering_bom_line_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`bom_line` ADD CONSTRAINT `fk_engineering_bom_line_material_specification_id` FOREIGN KEY (`material_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`material_specification`(`material_specification_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`bom_line` ADD CONSTRAINT `fk_engineering_bom_line_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`bop_operation` ADD CONSTRAINT `fk_engineering_bop_operation_bop_id` FOREIGN KEY (`bop_id`) REFERENCES `manufacturing_ecm`.`shared`.`bop`(`bop_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`bop_operation` ADD CONSTRAINT `fk_engineering_bop_operation_tooling_equipment_id` FOREIGN KEY (`tooling_equipment_id`) REFERENCES `manufacturing_ecm`.`shared`.`tooling_equipment`(`tooling_equipment_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`cad_model` ADD CONSTRAINT `fk_engineering_cad_model_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`shared`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`eco` ADD CONSTRAINT `fk_engineering_eco_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`shared`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`change_affected_item` ADD CONSTRAINT `fk_engineering_change_affected_item_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`shared`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`change_affected_item` ADD CONSTRAINT `fk_engineering_change_affected_item_drawing_id` FOREIGN KEY (`drawing_id`) REFERENCES `manufacturing_ecm`.`shared`.`drawing`(`drawing_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`change_affected_item` ADD CONSTRAINT `fk_engineering_change_affected_item_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`shared`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`dfmea` ADD CONSTRAINT `fk_engineering_dfmea_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`shared`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`dfmea` ADD CONSTRAINT `fk_engineering_dfmea_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`dfmea` ADD CONSTRAINT `fk_engineering_dfmea_product_specification_id` FOREIGN KEY (`product_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_specification`(`product_specification_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`pfmea` ADD CONSTRAINT `fk_engineering_pfmea_bop_id` FOREIGN KEY (`bop_id`) REFERENCES `manufacturing_ecm`.`shared`.`bop`(`bop_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`pfmea` ADD CONSTRAINT `fk_engineering_pfmea_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`shared`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`plm_lifecycle_state` ADD CONSTRAINT `fk_engineering_plm_lifecycle_state_lifecycle_id` FOREIGN KEY (`lifecycle_id`) REFERENCES `manufacturing_ecm`.`shared`.`lifecycle`(`lifecycle_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`substitute_component` ADD CONSTRAINT `fk_engineering_substitute_component_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`shared`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`substitute_component` ADD CONSTRAINT `fk_engineering_substitute_component_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`substitute_component` ADD CONSTRAINT `fk_engineering_substitute_component_material_specification_id` FOREIGN KEY (`material_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`material_specification`(`material_specification_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`substitute_component` ADD CONSTRAINT `fk_engineering_substitute_component_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`component_tooling_assignment` ADD CONSTRAINT `fk_engineering_component_tooling_assignment_tooling_equipment_id` FOREIGN KEY (`tooling_equipment_id`) REFERENCES `manufacturing_ecm`.`shared`.`tooling_equipment`(`tooling_equipment_id`);

-- ========= finance --> customer (1 constraint(s)) =========
-- Requires: finance schema, customer schema
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_credit_profile_id` FOREIGN KEY (`credit_profile_id`) REFERENCES `manufacturing_ecm`.`customer`.`credit_profile`(`credit_profile_id`);

-- ========= finance --> service (2 constraint(s)) =========
-- Requires: finance schema, service schema
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_request_id` FOREIGN KEY (`request_id`) REFERENCES `manufacturing_ecm`.`service`.`request`(`request_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_installation_record_id` FOREIGN KEY (`installation_record_id`) REFERENCES `manufacturing_ecm`.`service`.`installation_record`(`installation_record_id`);

-- ========= finance --> shared (12 constraint(s)) =========
-- Requires: finance schema, shared schema
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`shared`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`shared`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`shared`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ap_invoice`(`ap_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`shared`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`shared`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_tooling_equipment_id` FOREIGN KEY (`tooling_equipment_id`) REFERENCES `manufacturing_ecm`.`shared`.`tooling_equipment`(`tooling_equipment_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_application` ADD CONSTRAINT `fk_finance_cash_application_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ar_invoice`(`ar_invoice_id`);

-- ========= inventory --> asset (2 constraint(s)) =========
-- Requires: inventory schema, asset schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_asset_valuation_id` FOREIGN KEY (`asset_valuation_id`) REFERENCES `manufacturing_ecm`.`asset`.`asset_valuation`(`asset_valuation_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_calibration_record_id` FOREIGN KEY (`calibration_record_id`) REFERENCES `manufacturing_ecm`.`asset`.`calibration_record`(`calibration_record_id`);

-- ========= inventory --> engineering (1 constraint(s)) =========
-- Requires: inventory schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_bop_operation_id` FOREIGN KEY (`bop_operation_id`) REFERENCES `manufacturing_ecm`.`engineering`.`bop_operation`(`bop_operation_id`);

-- ========= inventory --> finance (4 constraint(s)) =========
-- Requires: inventory schema, finance schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`transaction` ADD CONSTRAINT `fk_inventory_transaction_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `manufacturing_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`cycle_count_result` ADD CONSTRAINT `fk_inventory_cycle_count_result_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `manufacturing_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_adjustment` ADD CONSTRAINT `fk_inventory_stock_adjustment_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `manufacturing_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `manufacturing_ecm`.`finance`.`journal_entry`(`journal_entry_id`);

-- ========= inventory --> logistics (2 constraint(s)) =========
-- Requires: inventory schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_freight_order_id` FOREIGN KEY (`freight_order_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_order`(`freight_order_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_inbound_delivery_id` FOREIGN KEY (`inbound_delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`inbound_delivery`(`inbound_delivery_id`);

-- ========= inventory --> procurement (3 constraint(s)) =========
-- Requires: inventory schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_mrp_planned_order_id` FOREIGN KEY (`mrp_planned_order_id`) REFERENCES `manufacturing_ecm`.`procurement`.`mrp_planned_order`(`mrp_planned_order_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `manufacturing_ecm`.`procurement`.`purchase_requisition`(`purchase_requisition_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_supplier_invoice_id` FOREIGN KEY (`supplier_invoice_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier_invoice`(`supplier_invoice_id`);

-- ========= inventory --> product (2 constraint(s)) =========
-- Requires: inventory schema, product schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_price_list_item_id` FOREIGN KEY (`price_list_item_id`) REFERENCES `manufacturing_ecm`.`product`.`price_list_item`(`price_list_item_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_regulatory_certification_id` FOREIGN KEY (`regulatory_certification_id`) REFERENCES `manufacturing_ecm`.`product`.`regulatory_certification`(`regulatory_certification_id`);

-- ========= inventory --> quality (3 constraint(s)) =========
-- Requires: inventory schema, quality schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`cycle_count_result` ADD CONSTRAINT `fk_inventory_cycle_count_result_quality_notification_id` FOREIGN KEY (`quality_notification_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_notification`(`quality_notification_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_adjustment` ADD CONSTRAINT `fk_inventory_stock_adjustment_quality_notification_id` FOREIGN KEY (`quality_notification_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_notification`(`quality_notification_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_adjustment` ADD CONSTRAINT `fk_inventory_stock_adjustment_usage_decision_id` FOREIGN KEY (`usage_decision_id`) REFERENCES `manufacturing_ecm`.`quality`.`usage_decision`(`usage_decision_id`);

-- ========= inventory --> shared (43 constraint(s)) =========
-- Requires: inventory schema, shared schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`transaction` ADD CONSTRAINT `fk_inventory_transaction_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`transaction` ADD CONSTRAINT `fk_inventory_transaction_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `manufacturing_ecm`.`shared`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`transaction` ADD CONSTRAINT `fk_inventory_transaction_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`shared`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`transaction` ADD CONSTRAINT `fk_inventory_transaction_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`shared`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`transaction` ADD CONSTRAINT `fk_inventory_transaction_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`shared`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`shared`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_source_storage_location_id` FOREIGN KEY (`source_storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`cycle_count_result` ADD CONSTRAINT `fk_inventory_cycle_count_result_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`shared`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`cycle_count_result` ADD CONSTRAINT `fk_inventory_cycle_count_result_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_adjustment` ADD CONSTRAINT `fk_inventory_stock_adjustment_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_adjustment` ADD CONSTRAINT `fk_inventory_stock_adjustment_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`shared`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_adjustment` ADD CONSTRAINT `fk_inventory_stock_adjustment_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`shared`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_adjustment` ADD CONSTRAINT `fk_inventory_stock_adjustment_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_asset_bom_id` FOREIGN KEY (`asset_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`asset_bom`(`asset_bom_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ap_invoice`(`ap_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`shared`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_pricing_agreement_id` FOREIGN KEY (`pricing_agreement_id`) REFERENCES `manufacturing_ecm`.`shared`.`pricing_agreement`(`pricing_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_sales_price_list_id` FOREIGN KEY (`sales_price_list_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_price_list`(`sales_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`shared`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`shared`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`shared`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_production_order_cost_id` FOREIGN KEY (`production_order_cost_id`) REFERENCES `manufacturing_ecm`.`shared`.`production_order_cost`(`production_order_cost_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_work_order_operation_id` FOREIGN KEY (`work_order_operation_id`) REFERENCES `manufacturing_ecm`.`shared`.`work_order_operation`(`work_order_operation_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`shared`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_failure_record_id` FOREIGN KEY (`failure_record_id`) REFERENCES `manufacturing_ecm`.`shared`.`failure_record`(`failure_record_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `manufacturing_ecm`.`shared`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`shared`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`shared`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_sla_agreement_id` FOREIGN KEY (`sla_agreement_id`) REFERENCES `manufacturing_ecm`.`shared`.`sla_agreement`(`sla_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`physical_inventory` ADD CONSTRAINT `fk_inventory_physical_inventory_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`physical_inventory` ADD CONSTRAINT `fk_inventory_physical_inventory_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);

-- ========= logistics --> finance (1 constraint(s)) =========
-- Requires: logistics schema, finance schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `manufacturing_ecm`.`finance`.`journal_entry`(`journal_entry_id`);

-- ========= logistics --> inventory (1 constraint(s)) =========
-- Requires: logistics schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ADD CONSTRAINT `fk_logistics_tracking_event_stock_transfer_id` FOREIGN KEY (`stock_transfer_id`) REFERENCES `manufacturing_ecm`.`inventory`.`stock_transfer`(`stock_transfer_id`);

-- ========= logistics --> order (3 constraint(s)) =========
-- Requires: logistics schema, order schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_fulfillment_plan_id` FOREIGN KEY (`fulfillment_plan_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_plan`(`fulfillment_plan_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_fulfillment_plan_id` FOREIGN KEY (`fulfillment_plan_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_plan`(`fulfillment_plan_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_schedule_line_id` FOREIGN KEY (`schedule_line_id`) REFERENCES `manufacturing_ecm`.`order`.`schedule_line`(`schedule_line_id`);

-- ========= logistics --> product (1 constraint(s)) =========
-- Requires: logistics schema, product schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ADD CONSTRAINT `fk_logistics_packaging_hazardous_substance_id` FOREIGN KEY (`hazardous_substance_id`) REFERENCES `manufacturing_ecm`.`product`.`hazardous_substance`(`hazardous_substance_id`);

-- ========= logistics --> production (3 constraint(s)) =========
-- Requires: logistics schema, production schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_production_confirmation_id` FOREIGN KEY (`production_confirmation_id`) REFERENCES `manufacturing_ecm`.`production`.`production_confirmation`(`production_confirmation_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ADD CONSTRAINT `fk_logistics_inbound_delivery_planned_order_id` FOREIGN KEY (`planned_order_id`) REFERENCES `manufacturing_ecm`.`production`.`planned_order`(`planned_order_id`);

-- ========= logistics --> service (2 constraint(s)) =========
-- Requires: logistics schema, service schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_spare_parts_request_id` FOREIGN KEY (`spare_parts_request_id`) REFERENCES `manufacturing_ecm`.`service`.`spare_parts_request`(`spare_parts_request_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_spare_parts_request_id` FOREIGN KEY (`spare_parts_request_id`) REFERENCES `manufacturing_ecm`.`service`.`spare_parts_request`(`spare_parts_request_id`);

-- ========= logistics --> shared (42 constraint(s)) =========
-- Requires: logistics schema, shared schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_cost_allocation_id` FOREIGN KEY (`cost_allocation_id`) REFERENCES `manufacturing_ecm`.`shared`.`cost_allocation`(`cost_allocation_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`shared`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_product_configuration_id` FOREIGN KEY (`product_configuration_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_configuration`(`product_configuration_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`shared`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `manufacturing_ecm`.`shared`.`stock_position`(`stock_position_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`shared`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`shared`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_tooling_equipment_id` FOREIGN KEY (`tooling_equipment_id`) REFERENCES `manufacturing_ecm`.`shared`.`tooling_equipment`(`tooling_equipment_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ADD CONSTRAINT `fk_logistics_transport_plan_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ADD CONSTRAINT `fk_logistics_route_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ADD CONSTRAINT `fk_logistics_route_stop_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`shared`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ADD CONSTRAINT `fk_logistics_route_stop_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`shared`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`shared`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_warranty_policy_id` FOREIGN KEY (`warranty_policy_id`) REFERENCES `manufacturing_ecm`.`shared`.`warranty_policy`(`warranty_policy_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ADD CONSTRAINT `fk_logistics_inbound_delivery_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ap_invoice`(`ap_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ADD CONSTRAINT `fk_logistics_inbound_delivery_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `manufacturing_ecm`.`shared`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ADD CONSTRAINT `fk_logistics_inbound_delivery_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `manufacturing_ecm`.`shared`.`plant`(`plant_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ADD CONSTRAINT `fk_logistics_inbound_delivery_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ADD CONSTRAINT `fk_logistics_inbound_delivery_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ADD CONSTRAINT `fk_logistics_inbound_delivery_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ADD CONSTRAINT `fk_logistics_inbound_delivery_returns_order_id` FOREIGN KEY (`returns_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`returns_order`(`returns_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ADD CONSTRAINT `fk_logistics_inbound_delivery_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`inbound_delivery` ADD CONSTRAINT `fk_logistics_inbound_delivery_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ADD CONSTRAINT `fk_logistics_tracking_event_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ADD CONSTRAINT `fk_logistics_freight_rate_category_id` FOREIGN KEY (`category_id`) REFERENCES `manufacturing_ecm`.`shared`.`category`(`category_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ADD CONSTRAINT `fk_logistics_freight_rate_currency_exchange_rate_id` FOREIGN KEY (`currency_exchange_rate_id`) REFERENCES `manufacturing_ecm`.`shared`.`currency_exchange_rate`(`currency_exchange_rate_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_account_hierarchy_id` FOREIGN KEY (`account_hierarchy_id`) REFERENCES `manufacturing_ecm`.`shared`.`account_hierarchy`(`account_hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ap_invoice`(`ap_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_profitability_segment_id` FOREIGN KEY (`profitability_segment_id`) REFERENCES `manufacturing_ecm`.`shared`.`profitability_segment`(`profitability_segment_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`shared`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ADD CONSTRAINT `fk_logistics_packaging_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ADD CONSTRAINT `fk_logistics_freight_contract_currency_exchange_rate_id` FOREIGN KEY (`currency_exchange_rate_id`) REFERENCES `manufacturing_ecm`.`shared`.`currency_exchange_rate`(`currency_exchange_rate_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ADD CONSTRAINT `fk_logistics_freight_contract_sales_org_id` FOREIGN KEY (`sales_org_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_org`(`sales_org_id`);

-- ========= order --> asset (3 constraint(s)) =========
-- Requires: order schema, asset schema
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ADD CONSTRAINT `fk_order_quotation_service_contract_id` FOREIGN KEY (`service_contract_id`) REFERENCES `manufacturing_ecm`.`asset`.`service_contract`(`service_contract_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_service_contract_id` FOREIGN KEY (`service_contract_id`) REFERENCES `manufacturing_ecm`.`asset`.`service_contract`(`service_contract_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `manufacturing_ecm`.`asset`.`maintenance_plan`(`maintenance_plan_id`);

-- ========= order --> customer (1 constraint(s)) =========
-- Requires: order schema, customer schema
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ADD CONSTRAINT `fk_order_credit_check_credit_profile_id` FOREIGN KEY (`credit_profile_id`) REFERENCES `manufacturing_ecm`.`customer`.`credit_profile`(`credit_profile_id`);

-- ========= order --> inventory (1 constraint(s)) =========
-- Requires: order schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_transaction_id` FOREIGN KEY (`transaction_id`) REFERENCES `manufacturing_ecm`.`inventory`.`transaction`(`transaction_id`);

-- ========= order --> product (1 constraint(s)) =========
-- Requires: order schema, product schema
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_price_list_item_id` FOREIGN KEY (`price_list_item_id`) REFERENCES `manufacturing_ecm`.`product`.`price_list_item`(`price_list_item_id`);

-- ========= order --> quality (3 constraint(s)) =========
-- Requires: order schema, quality schema
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ADD CONSTRAINT `fk_order_atp_commitment_usage_decision_id` FOREIGN KEY (`usage_decision_id`) REFERENCES `manufacturing_ecm`.`quality`.`usage_decision`(`usage_decision_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);

-- ========= order --> sales (6 constraint(s)) =========
-- Requires: order schema, sales schema
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ADD CONSTRAINT `fk_order_quotation_discount_structure_id` FOREIGN KEY (`discount_structure_id`) REFERENCES `manufacturing_ecm`.`sales`.`discount_structure`(`discount_structure_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ADD CONSTRAINT `fk_order_quotation_line_item_discount_structure_id` FOREIGN KEY (`discount_structure_id`) REFERENCES `manufacturing_ecm`.`sales`.`discount_structure`(`discount_structure_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ADD CONSTRAINT `fk_order_rfq_request_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `manufacturing_ecm`.`sales`.`campaign`(`campaign_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_discount_structure_id` FOREIGN KEY (`discount_structure_id`) REFERENCES `manufacturing_ecm`.`sales`.`discount_structure`(`discount_structure_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ADD CONSTRAINT `fk_order_blanket_order_discount_structure_id` FOREIGN KEY (`discount_structure_id`) REFERENCES `manufacturing_ecm`.`sales`.`discount_structure`(`discount_structure_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_forecast_id` FOREIGN KEY (`forecast_id`) REFERENCES `manufacturing_ecm`.`sales`.`forecast`(`forecast_id`);

-- ========= order --> shared (48 constraint(s)) =========
-- Requires: order schema, shared schema
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ADD CONSTRAINT `fk_order_quotation_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`shared`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ADD CONSTRAINT `fk_order_quotation_currency_exchange_rate_id` FOREIGN KEY (`currency_exchange_rate_id`) REFERENCES `manufacturing_ecm`.`shared`.`currency_exchange_rate`(`currency_exchange_rate_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ADD CONSTRAINT `fk_order_quotation_pricing_agreement_id` FOREIGN KEY (`pricing_agreement_id`) REFERENCES `manufacturing_ecm`.`shared`.`pricing_agreement`(`pricing_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ADD CONSTRAINT `fk_order_quotation_sales_org_id` FOREIGN KEY (`sales_org_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_org`(`sales_org_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ADD CONSTRAINT `fk_order_quotation_sales_price_list_id` FOREIGN KEY (`sales_price_list_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_price_list`(`sales_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation` ADD CONSTRAINT `fk_order_quotation_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`shared`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ADD CONSTRAINT `fk_order_quotation_line_item_product_configuration_id` FOREIGN KEY (`product_configuration_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_configuration`(`product_configuration_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ADD CONSTRAINT `fk_order_quotation_line_item_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ADD CONSTRAINT `fk_order_rfq_request_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`shared`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ADD CONSTRAINT `fk_order_rfq_request_product_specification_id` FOREIGN KEY (`product_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_specification`(`product_specification_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ADD CONSTRAINT `fk_order_rfq_request_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ADD CONSTRAINT `fk_order_schedule_line_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ADD CONSTRAINT `fk_order_schedule_line_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `manufacturing_ecm`.`shared`.`plant`(`plant_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ADD CONSTRAINT `fk_order_schedule_line_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `manufacturing_ecm`.`shared`.`stock_position`(`stock_position_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ADD CONSTRAINT `fk_order_status_history_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ADD CONSTRAINT `fk_order_order_confirmation_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ADD CONSTRAINT `fk_order_order_confirmation_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ADD CONSTRAINT `fk_order_atp_commitment_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ADD CONSTRAINT `fk_order_atp_commitment_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ADD CONSTRAINT `fk_order_atp_commitment_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `manufacturing_ecm`.`shared`.`plant`(`plant_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ADD CONSTRAINT `fk_order_atp_commitment_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ADD CONSTRAINT `fk_order_atp_commitment_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `manufacturing_ecm`.`shared`.`stock_position`(`stock_position_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ADD CONSTRAINT `fk_order_order_configuration_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ADD CONSTRAINT `fk_order_order_configuration_product_configuration_id` FOREIGN KEY (`product_configuration_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_configuration`(`product_configuration_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ADD CONSTRAINT `fk_order_order_configuration_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_currency_exchange_rate_id` FOREIGN KEY (`currency_exchange_rate_id`) REFERENCES `manufacturing_ecm`.`shared`.`currency_exchange_rate`(`currency_exchange_rate_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_sales_price_list_id` FOREIGN KEY (`sales_price_list_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_price_list`(`sales_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`shared`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ADD CONSTRAINT `fk_order_blanket_order_profitability_segment_id` FOREIGN KEY (`profitability_segment_id`) REFERENCES `manufacturing_ecm`.`shared`.`profitability_segment`(`profitability_segment_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ADD CONSTRAINT `fk_order_blanket_order_sales_org_id` FOREIGN KEY (`sales_org_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_org`(`sales_org_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order` ADD CONSTRAINT `fk_order_blanket_order_sales_price_list_id` FOREIGN KEY (`sales_price_list_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_price_list`(`sales_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_bop_id` FOREIGN KEY (`bop_id`) REFERENCES `manufacturing_ecm`.`shared`.`bop`(`bop_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `manufacturing_ecm`.`shared`.`plant`(`plant_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `manufacturing_ecm`.`shared`.`plant`(`plant_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `manufacturing_ecm`.`shared`.`stock_position`(`stock_position_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ADD CONSTRAINT `fk_order_channel_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ADD CONSTRAINT `fk_order_credit_check_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ADD CONSTRAINT `fk_order_credit_check_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`shared`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ADD CONSTRAINT `fk_order_credit_check_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ADD CONSTRAINT `fk_order_credit_check_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_territory`(`sales_territory_id`);

-- ========= procurement --> finance (2 constraint(s)) =========
-- Requires: procurement schema, finance schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `manufacturing_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_category` ADD CONSTRAINT `fk_procurement_spend_category_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);

-- ========= procurement --> inventory (2 constraint(s)) =========
-- Requires: procurement schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ADD CONSTRAINT `fk_procurement_mrp_run_physical_inventory_id` FOREIGN KEY (`physical_inventory_id`) REFERENCES `manufacturing_ecm`.`inventory`.`physical_inventory`(`physical_inventory_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_reorder_policy_id` FOREIGN KEY (`reorder_policy_id`) REFERENCES `manufacturing_ecm`.`inventory`.`reorder_policy`(`reorder_policy_id`);

-- ========= procurement --> order (2 constraint(s)) =========
-- Requires: procurement schema, order schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_blanket_order_id` FOREIGN KEY (`blanket_order_id`) REFERENCES `manufacturing_ecm`.`order`.`blanket_order`(`blanket_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ADD CONSTRAINT `fk_procurement_delivery_schedule_schedule_line_id` FOREIGN KEY (`schedule_line_id`) REFERENCES `manufacturing_ecm`.`order`.`schedule_line`(`schedule_line_id`);

-- ========= procurement --> product (2 constraint(s)) =========
-- Requires: procurement schema, product schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);

-- ========= procurement --> sales (2 constraint(s)) =========
-- Requires: procurement schema, sales schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_forecast_id` FOREIGN KEY (`forecast_id`) REFERENCES `manufacturing_ecm`.`sales`.`forecast`(`forecast_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_forecast_id` FOREIGN KEY (`forecast_id`) REFERENCES `manufacturing_ecm`.`sales`.`forecast`(`forecast_id`);

-- ========= procurement --> shared (42 constraint(s)) =========
-- Requires: procurement schema, shared schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ADD CONSTRAINT `fk_procurement_mrp_run_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_run` ADD CONSTRAINT `fk_procurement_mrp_run_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `manufacturing_ecm`.`shared`.`segment`(`segment_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_product_cost_estimate_id` FOREIGN KEY (`product_cost_estimate_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_cost_estimate`(`product_cost_estimate_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `manufacturing_ecm`.`shared`.`stock_position`(`stock_position_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_account_hierarchy_id` FOREIGN KEY (`account_hierarchy_id`) REFERENCES `manufacturing_ecm`.`shared`.`account_hierarchy`(`account_hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `manufacturing_ecm`.`shared`.`segment`(`segment_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `manufacturing_ecm`.`shared`.`stock_position`(`stock_position_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ADD CONSTRAINT `fk_procurement_supply_agreement_profitability_segment_id` FOREIGN KEY (`profitability_segment_id`) REFERENCES `manufacturing_ecm`.`shared`.`profitability_segment`(`profitability_segment_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ADD CONSTRAINT `fk_procurement_supply_agreement_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_agreement` ADD CONSTRAINT `fk_procurement_supply_agreement_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ADD CONSTRAINT `fk_procurement_delivery_schedule_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`shared`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ADD CONSTRAINT `fk_procurement_delivery_schedule_sla_agreement_id` FOREIGN KEY (`sla_agreement_id`) REFERENCES `manufacturing_ecm`.`shared`.`sla_agreement`(`sla_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ADD CONSTRAINT `fk_procurement_delivery_schedule_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ADD CONSTRAINT `fk_procurement_source_list_approved_manufacturer_id` FOREIGN KEY (`approved_manufacturer_id`) REFERENCES `manufacturing_ecm`.`shared`.`approved_manufacturer`(`approved_manufacturer_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ADD CONSTRAINT `fk_procurement_source_list_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `manufacturing_ecm`.`shared`.`plant`(`plant_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ADD CONSTRAINT `fk_procurement_quota_arrangement_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `manufacturing_ecm`.`shared`.`plant`(`plant_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ADD CONSTRAINT `fk_procurement_quota_arrangement_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_cost_allocation_id` FOREIGN KEY (`cost_allocation_id`) REFERENCES `manufacturing_ecm`.`shared`.`cost_allocation`(`cost_allocation_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `manufacturing_ecm`.`shared`.`plant`(`plant_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_product_specification_id` FOREIGN KEY (`product_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_specification`(`product_specification_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ap_invoice`(`ap_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_currency_exchange_rate_id` FOREIGN KEY (`currency_exchange_rate_id`) REFERENCES `manufacturing_ecm`.`shared`.`currency_exchange_rate`(`currency_exchange_rate_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `manufacturing_ecm`.`shared`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_invoice` ADD CONSTRAINT `fk_procurement_supplier_invoice_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_category` ADD CONSTRAINT `fk_procurement_spend_category_category_id` FOREIGN KEY (`category_id`) REFERENCES `manufacturing_ecm`.`shared`.`category`(`category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ADD CONSTRAINT `fk_procurement_preferred_supplier_list_category_id` FOREIGN KEY (`category_id`) REFERENCES `manufacturing_ecm`.`shared`.`category`(`category_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ADD CONSTRAINT `fk_procurement_preferred_supplier_list_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`shared`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ADD CONSTRAINT `fk_procurement_preferred_supplier_list_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier_list` ADD CONSTRAINT `fk_procurement_preferred_supplier_list_supplier_qualification_supplier_id` FOREIGN KEY (`supplier_qualification_supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` ADD CONSTRAINT `fk_procurement_preferred_supplier_sla_agreement_id` FOREIGN KEY (`sla_agreement_id`) REFERENCES `manufacturing_ecm`.`shared`.`sla_agreement`(`sla_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`preferred_supplier` ADD CONSTRAINT `fk_procurement_preferred_supplier_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);

-- ========= product --> shared (7 constraint(s)) =========
-- Requires: product schema, shared schema
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ADD CONSTRAINT `fk_product_price_list_item_product_price_list_id` FOREIGN KEY (`product_price_list_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_price_list`(`product_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ADD CONSTRAINT `fk_product_price_list_item_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`shared`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ADD CONSTRAINT `fk_product_price_list_item_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`regulatory_certification` ADD CONSTRAINT `fk_product_regulatory_certification_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`document` ADD CONSTRAINT `fk_product_document_drawing_id` FOREIGN KEY (`drawing_id`) REFERENCES `manufacturing_ecm`.`shared`.`drawing`(`drawing_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ADD CONSTRAINT `fk_product_aftermarket_part_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ADD CONSTRAINT `fk_product_aftermarket_part_warranty_policy_id` FOREIGN KEY (`warranty_policy_id`) REFERENCES `manufacturing_ecm`.`shared`.`warranty_policy`(`warranty_policy_id`);

-- ========= production --> asset (5 constraint(s)) =========
-- Requires: production schema, asset schema
ALTER TABLE `manufacturing_ecm`.`production`.`work_center` ADD CONSTRAINT `fk_production_work_center_class_id` FOREIGN KEY (`class_id`) REFERENCES `manufacturing_ecm`.`asset`.`class`(`class_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`routing_operation` ADD CONSTRAINT `fk_production_routing_operation_task_list_id` FOREIGN KEY (`task_list_id`) REFERENCES `manufacturing_ecm`.`asset`.`task_list`(`task_list_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_measurement_reading_id` FOREIGN KEY (`measurement_reading_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_reading`(`measurement_reading_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`capacity_requirement` ADD CONSTRAINT `fk_production_capacity_requirement_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `manufacturing_ecm`.`asset`.`maintenance_plan`(`maintenance_plan_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`downtime_event` ADD CONSTRAINT `fk_production_downtime_event_asset_notification_id` FOREIGN KEY (`asset_notification_id`) REFERENCES `manufacturing_ecm`.`asset`.`asset_notification`(`asset_notification_id`);

-- ========= production --> engineering (2 constraint(s)) =========
-- Requires: production schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`production`.`routing_operation` ADD CONSTRAINT `fk_production_routing_operation_bop_operation_id` FOREIGN KEY (`bop_operation_id`) REFERENCES `manufacturing_ecm`.`engineering`.`bop_operation`(`bop_operation_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_pfmea_id` FOREIGN KEY (`pfmea_id`) REFERENCES `manufacturing_ecm`.`engineering`.`pfmea`(`pfmea_id`);

-- ========= production --> inventory (2 constraint(s)) =========
-- Requires: production schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`production`.`shop_order_operation` ADD CONSTRAINT `fk_production_shop_order_operation_wip_stock_id` FOREIGN KEY (`wip_stock_id`) REFERENCES `manufacturing_ecm`.`inventory`.`wip_stock`(`wip_stock_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_wip_stock_id` FOREIGN KEY (`wip_stock_id`) REFERENCES `manufacturing_ecm`.`inventory`.`wip_stock`(`wip_stock_id`);

-- ========= production --> logistics (2 constraint(s)) =========
-- Requires: production schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_delivery_id` FOREIGN KEY (`delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`delivery`(`delivery_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_shipment_item_id` FOREIGN KEY (`shipment_item_id`) REFERENCES `manufacturing_ecm`.`logistics`.`shipment_item`(`shipment_item_id`);

-- ========= production --> order (7 constraint(s)) =========
-- Requires: production schema, order schema
ALTER TABLE `manufacturing_ecm`.`production`.`schedule` ADD CONSTRAINT `fk_production_schedule_fulfillment_plan_id` FOREIGN KEY (`fulfillment_plan_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_plan`(`fulfillment_plan_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`planned_order` ADD CONSTRAINT `fk_production_planned_order_fulfillment_plan_id` FOREIGN KEY (`fulfillment_plan_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_plan`(`fulfillment_plan_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`planned_order` ADD CONSTRAINT `fk_production_planned_order_priority_id` FOREIGN KEY (`priority_id`) REFERENCES `manufacturing_ecm`.`order`.`priority`(`priority_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_goods_issue_id` FOREIGN KEY (`goods_issue_id`) REFERENCES `manufacturing_ecm`.`order`.`goods_issue`(`goods_issue_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_schedule_line_id` FOREIGN KEY (`schedule_line_id`) REFERENCES `manufacturing_ecm`.`order`.`schedule_line`(`schedule_line_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`capacity_requirement` ADD CONSTRAINT `fk_production_capacity_requirement_fulfillment_plan_id` FOREIGN KEY (`fulfillment_plan_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_plan`(`fulfillment_plan_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_order_confirmation_id` FOREIGN KEY (`order_confirmation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_confirmation`(`order_confirmation_id`);

-- ========= production --> procurement (3 constraint(s)) =========
-- Requires: production schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`production`.`planned_order` ADD CONSTRAINT `fk_production_planned_order_demand_forecast_id` FOREIGN KEY (`demand_forecast_id`) REFERENCES `manufacturing_ecm`.`procurement`.`demand_forecast`(`demand_forecast_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`planned_order` ADD CONSTRAINT `fk_production_planned_order_mrp_planned_order_id` FOREIGN KEY (`mrp_planned_order_id`) REFERENCES `manufacturing_ecm`.`procurement`.`mrp_planned_order`(`mrp_planned_order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`capacity_requirement` ADD CONSTRAINT `fk_production_capacity_requirement_mrp_run_id` FOREIGN KEY (`mrp_run_id`) REFERENCES `manufacturing_ecm`.`procurement`.`mrp_run`(`mrp_run_id`);

-- ========= production --> quality (2 constraint(s)) =========
-- Requires: production schema, quality schema
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);

-- ========= production --> sales (3 constraint(s)) =========
-- Requires: production schema, sales schema
ALTER TABLE `manufacturing_ecm`.`production`.`schedule` ADD CONSTRAINT `fk_production_schedule_forecast_id` FOREIGN KEY (`forecast_id`) REFERENCES `manufacturing_ecm`.`sales`.`forecast`(`forecast_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`planned_order` ADD CONSTRAINT `fk_production_planned_order_forecast_id` FOREIGN KEY (`forecast_id`) REFERENCES `manufacturing_ecm`.`sales`.`forecast`(`forecast_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`capacity_requirement` ADD CONSTRAINT `fk_production_capacity_requirement_forecast_id` FOREIGN KEY (`forecast_id`) REFERENCES `manufacturing_ecm`.`sales`.`forecast`(`forecast_id`);

-- ========= production --> shared (36 constraint(s)) =========
-- Requires: production schema, shared schema
ALTER TABLE `manufacturing_ecm`.`production`.`work_center` ADD CONSTRAINT `fk_production_work_center_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`routing` ADD CONSTRAINT `fk_production_routing_bop_id` FOREIGN KEY (`bop_id`) REFERENCES `manufacturing_ecm`.`shared`.`bop`(`bop_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`planned_order` ADD CONSTRAINT `fk_production_planned_order_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`shared`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`planned_order` ADD CONSTRAINT `fk_production_planned_order_product_cost_estimate_id` FOREIGN KEY (`product_cost_estimate_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_cost_estimate`(`product_cost_estimate_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`planned_order` ADD CONSTRAINT `fk_production_planned_order_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`planned_order` ADD CONSTRAINT `fk_production_planned_order_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`shop_order_operation` ADD CONSTRAINT `fk_production_shop_order_operation_production_order_cost_id` FOREIGN KEY (`production_order_cost_id`) REFERENCES `manufacturing_ecm`.`shared`.`production_order_cost`(`production_order_cost_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`shop_order_operation` ADD CONSTRAINT `fk_production_shop_order_operation_tooling_equipment_id` FOREIGN KEY (`tooling_equipment_id`) REFERENCES `manufacturing_ecm`.`shared`.`tooling_equipment`(`tooling_equipment_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`shop_order_operation` ADD CONSTRAINT `fk_production_shop_order_operation_work_order_operation_id` FOREIGN KEY (`work_order_operation_id`) REFERENCES `manufacturing_ecm`.`shared`.`work_order_operation`(`work_order_operation_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_product_specification_id` FOREIGN KEY (`product_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_specification`(`product_specification_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `manufacturing_ecm`.`shared`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`capacity_requirement` ADD CONSTRAINT `fk_production_capacity_requirement_production_order_cost_id` FOREIGN KEY (`production_order_cost_id`) REFERENCES `manufacturing_ecm`.`shared`.`production_order_cost`(`production_order_cost_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`version` ADD CONSTRAINT `fk_production_version_bop_id` FOREIGN KEY (`bop_id`) REFERENCES `manufacturing_ecm`.`shared`.`bop`(`bop_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`version` ADD CONSTRAINT `fk_production_version_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`shared`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`version` ADD CONSTRAINT `fk_production_version_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `manufacturing_ecm`.`shared`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_lifecycle_id` FOREIGN KEY (`lifecycle_id`) REFERENCES `manufacturing_ecm`.`shared`.`lifecycle`(`lifecycle_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`shared`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_material_specification_id` FOREIGN KEY (`material_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`material_specification`(`material_specification_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch_genealogy` ADD CONSTRAINT `fk_production_batch_genealogy_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`downtime_event` ADD CONSTRAINT `fk_production_downtime_event_cost_allocation_id` FOREIGN KEY (`cost_allocation_id`) REFERENCES `manufacturing_ecm`.`shared`.`cost_allocation`(`cost_allocation_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`downtime_event` ADD CONSTRAINT `fk_production_downtime_event_failure_record_id` FOREIGN KEY (`failure_record_id`) REFERENCES `manufacturing_ecm`.`shared`.`failure_record`(`failure_record_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`downtime_event` ADD CONSTRAINT `fk_production_downtime_event_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`downtime_event` ADD CONSTRAINT `fk_production_downtime_event_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_failure_record_id` FOREIGN KEY (`failure_record_id`) REFERENCES `manufacturing_ecm`.`shared`.`failure_record`(`failure_record_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`shared`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_production_order_cost_id` FOREIGN KEY (`production_order_cost_id`) REFERENCES `manufacturing_ecm`.`shared`.`production_order_cost`(`production_order_cost_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_returns_order_id` FOREIGN KEY (`returns_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`returns_order`(`returns_order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);

-- ========= quality --> asset (9 constraint(s)) =========
-- Requires: quality schema, asset schema
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_task_list_id` FOREIGN KEY (`task_list_id`) REFERENCES `manufacturing_ecm`.`asset`.`task_list`(`task_list_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_measurement_point_id` FOREIGN KEY (`measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_measurement_point_id` FOREIGN KEY (`measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ADD CONSTRAINT `fk_quality_spc_chart_measurement_point_id` FOREIGN KEY (`measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ADD CONSTRAINT `fk_quality_spc_sample_measurement_reading_id` FOREIGN KEY (`measurement_reading_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_reading`(`measurement_reading_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ADD CONSTRAINT `fk_quality_gauge_class_id` FOREIGN KEY (`class_id`) REFERENCES `manufacturing_ecm`.`asset`.`class`(`class_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ADD CONSTRAINT `fk_quality_gauge_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `manufacturing_ecm`.`asset`.`maintenance_plan`(`maintenance_plan_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ADD CONSTRAINT `fk_quality_gauge_calibration_calibration_record_id` FOREIGN KEY (`calibration_record_id`) REFERENCES `manufacturing_ecm`.`asset`.`calibration_record`(`calibration_record_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_asset_notification_id` FOREIGN KEY (`asset_notification_id`) REFERENCES `manufacturing_ecm`.`asset`.`asset_notification`(`asset_notification_id`);

-- ========= quality --> engineering (1 constraint(s)) =========
-- Requires: quality schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ADD CONSTRAINT `fk_quality_capa_eco_id` FOREIGN KEY (`eco_id`) REFERENCES `manufacturing_ecm`.`engineering`.`eco`(`eco_id`);

-- ========= quality --> inventory (2 constraint(s)) =========
-- Requires: quality schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ADD CONSTRAINT `fk_quality_usage_decision_quarantine_hold_id` FOREIGN KEY (`quarantine_hold_id`) REFERENCES `manufacturing_ecm`.`inventory`.`quarantine_hold`(`quarantine_hold_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_quarantine_hold_id` FOREIGN KEY (`quarantine_hold_id`) REFERENCES `manufacturing_ecm`.`inventory`.`quarantine_hold`(`quarantine_hold_id`);

-- ========= quality --> logistics (2 constraint(s)) =========
-- Requires: quality schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_inbound_delivery_id` FOREIGN KEY (`inbound_delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`inbound_delivery`(`inbound_delivery_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_shipment_item_id` FOREIGN KEY (`shipment_item_id`) REFERENCES `manufacturing_ecm`.`logistics`.`shipment_item`(`shipment_item_id`);

-- ========= quality --> order (4 constraint(s)) =========
-- Requires: quality schema, order schema
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_order_confirmation_id` FOREIGN KEY (`order_confirmation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_confirmation`(`order_confirmation_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_quotation_id` FOREIGN KEY (`quotation_id`) REFERENCES `manufacturing_ecm`.`order`.`quotation`(`quotation_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_order_confirmation_id` FOREIGN KEY (`order_confirmation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_confirmation`(`order_confirmation_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_goods_issue_id` FOREIGN KEY (`goods_issue_id`) REFERENCES `manufacturing_ecm`.`order`.`goods_issue`(`goods_issue_id`);

-- ========= quality --> product (9 constraint(s)) =========
-- Requires: quality schema, product schema
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);

-- ========= quality --> production (14 constraint(s)) =========
-- Requires: quality schema, production schema
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_routing_id` FOREIGN KEY (`routing_id`) REFERENCES `manufacturing_ecm`.`production`.`routing`(`routing_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_routing_operation_id` FOREIGN KEY (`routing_operation_id`) REFERENCES `manufacturing_ecm`.`production`.`routing_operation`(`routing_operation_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_shop_order_operation_id` FOREIGN KEY (`shop_order_operation_id`) REFERENCES `manufacturing_ecm`.`production`.`shop_order_operation`(`shop_order_operation_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ADD CONSTRAINT `fk_quality_usage_decision_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ADD CONSTRAINT `fk_quality_capa_downtime_event_id` FOREIGN KEY (`downtime_event_id`) REFERENCES `manufacturing_ecm`.`production`.`downtime_event`(`downtime_event_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_routing_id` FOREIGN KEY (`routing_id`) REFERENCES `manufacturing_ecm`.`production`.`routing`(`routing_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_routing_operation_id` FOREIGN KEY (`routing_operation_id`) REFERENCES `manufacturing_ecm`.`production`.`routing_operation`(`routing_operation_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_routing_id` FOREIGN KEY (`routing_id`) REFERENCES `manufacturing_ecm`.`production`.`routing`(`routing_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ADD CONSTRAINT `fk_quality_spc_chart_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ADD CONSTRAINT `fk_quality_spc_sample_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `manufacturing_ecm`.`production`.`shift`(`shift_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ADD CONSTRAINT `fk_quality_gauge_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);

-- ========= quality --> sales (1 constraint(s)) =========
-- Requires: quality schema, sales schema
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `manufacturing_ecm`.`sales`.`campaign`(`campaign_id`);

-- ========= quality --> shared (61 constraint(s)) =========
-- Requires: quality schema, shared schema
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_bop_id` FOREIGN KEY (`bop_id`) REFERENCES `manufacturing_ecm`.`shared`.`bop`(`bop_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_product_configuration_id` FOREIGN KEY (`product_configuration_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_configuration`(`product_configuration_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_account_hierarchy_id` FOREIGN KEY (`account_hierarchy_id`) REFERENCES `manufacturing_ecm`.`shared`.`account_hierarchy`(`account_hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `manufacturing_ecm`.`shared`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_production_order_cost_id` FOREIGN KEY (`production_order_cost_id`) REFERENCES `manufacturing_ecm`.`shared`.`production_order_cost`(`production_order_cost_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ADD CONSTRAINT `fk_quality_usage_decision_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `manufacturing_ecm`.`shared`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ADD CONSTRAINT `fk_quality_capa_account_hierarchy_id` FOREIGN KEY (`account_hierarchy_id`) REFERENCES `manufacturing_ecm`.`shared`.`account_hierarchy`(`account_hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ADD CONSTRAINT `fk_quality_capa_cost_allocation_id` FOREIGN KEY (`cost_allocation_id`) REFERENCES `manufacturing_ecm`.`shared`.`cost_allocation`(`cost_allocation_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ADD CONSTRAINT `fk_quality_capa_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`shared`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ADD CONSTRAINT `fk_quality_capa_failure_record_id` FOREIGN KEY (`failure_record_id`) REFERENCES `manufacturing_ecm`.`shared`.`failure_record`(`failure_record_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ADD CONSTRAINT `fk_quality_capa_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`capa` ADD CONSTRAINT `fk_quality_capa_work_order_operation_id` FOREIGN KEY (`work_order_operation_id`) REFERENCES `manufacturing_ecm`.`shared`.`work_order_operation`(`work_order_operation_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_asset_bom_id` FOREIGN KEY (`asset_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`asset_bom`(`asset_bom_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_bop_id` FOREIGN KEY (`bop_id`) REFERENCES `manufacturing_ecm`.`shared`.`bop`(`bop_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_product_specification_id` FOREIGN KEY (`product_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_specification`(`product_specification_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_account_hierarchy_id` FOREIGN KEY (`account_hierarchy_id`) REFERENCES `manufacturing_ecm`.`shared`.`account_hierarchy`(`account_hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`shared`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`shared`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_pricing_agreement_id` FOREIGN KEY (`pricing_agreement_id`) REFERENCES `manufacturing_ecm`.`shared`.`pricing_agreement`(`pricing_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_product_cost_estimate_id` FOREIGN KEY (`product_cost_estimate_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_cost_estimate`(`product_cost_estimate_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_account_hierarchy_id` FOREIGN KEY (`account_hierarchy_id`) REFERENCES `manufacturing_ecm`.`shared`.`account_hierarchy`(`account_hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_drawing_id` FOREIGN KEY (`drawing_id`) REFERENCES `manufacturing_ecm`.`shared`.`drawing`(`drawing_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ADD CONSTRAINT `fk_quality_spc_chart_account_hierarchy_id` FOREIGN KEY (`account_hierarchy_id`) REFERENCES `manufacturing_ecm`.`shared`.`account_hierarchy`(`account_hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ADD CONSTRAINT `fk_quality_spc_chart_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ADD CONSTRAINT `fk_quality_characteristic_drawing_id` FOREIGN KEY (`drawing_id`) REFERENCES `manufacturing_ecm`.`shared`.`drawing`(`drawing_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ADD CONSTRAINT `fk_quality_characteristic_product_specification_id` FOREIGN KEY (`product_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_specification`(`product_specification_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ADD CONSTRAINT `fk_quality_characteristic_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ADD CONSTRAINT `fk_quality_gauge_calibration_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ap_invoice`(`ap_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_installed_base_id` FOREIGN KEY (`installed_base_id`) REFERENCES `manufacturing_ecm`.`shared`.`installed_base`(`installed_base_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_returns_order_id` FOREIGN KEY (`returns_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`returns_order`(`returns_order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`shared`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_sla_agreement_id` FOREIGN KEY (`sla_agreement_id`) REFERENCES `manufacturing_ecm`.`shared`.`sla_agreement`(`sla_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_account_hierarchy_id` FOREIGN KEY (`account_hierarchy_id`) REFERENCES `manufacturing_ecm`.`shared`.`account_hierarchy`(`account_hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`shared`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_cost_allocation_id` FOREIGN KEY (`cost_allocation_id`) REFERENCES `manufacturing_ecm`.`shared`.`cost_allocation`(`cost_allocation_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_account_hierarchy_id` FOREIGN KEY (`account_hierarchy_id`) REFERENCES `manufacturing_ecm`.`shared`.`account_hierarchy`(`account_hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`shared`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `manufacturing_ecm`.`shared`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `manufacturing_ecm`.`shared`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_material_specification_id` FOREIGN KEY (`material_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`material_specification`(`material_specification_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`shared`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);

-- ========= sales --> customer (4 constraint(s)) =========
-- Requires: sales schema, customer schema
ALTER TABLE `manufacturing_ecm`.`sales`.`account_plan` ADD CONSTRAINT `fk_sales_account_plan_credit_profile_id` FOREIGN KEY (`credit_profile_id`) REFERENCES `manufacturing_ecm`.`customer`.`credit_profile`(`credit_profile_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`territory_assignment` ADD CONSTRAINT `fk_sales_territory_assignment_sales_area_assignment_id` FOREIGN KEY (`sales_area_assignment_id`) REFERENCES `manufacturing_ecm`.`customer`.`sales_area_assignment`(`sales_area_assignment_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`quota` ADD CONSTRAINT `fk_sales_quota_sales_area_assignment_id` FOREIGN KEY (`sales_area_assignment_id`) REFERENCES `manufacturing_ecm`.`customer`.`sales_area_assignment`(`sales_area_assignment_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`discount_structure` ADD CONSTRAINT `fk_sales_discount_structure_account_classification_id` FOREIGN KEY (`account_classification_id`) REFERENCES `manufacturing_ecm`.`customer`.`account_classification`(`account_classification_id`);

-- ========= sales --> procurement (1 constraint(s)) =========
-- Requires: sales schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`sales`.`campaign` ADD CONSTRAINT `fk_sales_campaign_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);

-- ========= sales --> service (4 constraint(s)) =========
-- Requires: sales schema, service schema
ALTER TABLE `manufacturing_ecm`.`sales`.`lead` ADD CONSTRAINT `fk_sales_lead_installation_record_id` FOREIGN KEY (`installation_record_id`) REFERENCES `manufacturing_ecm`.`service`.`installation_record`(`installation_record_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`lead` ADD CONSTRAINT `fk_sales_lead_request_id` FOREIGN KEY (`request_id`) REFERENCES `manufacturing_ecm`.`service`.`request`(`request_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_contract_line_id` FOREIGN KEY (`contract_line_id`) REFERENCES `manufacturing_ecm`.`service`.`contract_line`(`contract_line_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`opportunity_competitor` ADD CONSTRAINT `fk_sales_opportunity_competitor_installation_record_id` FOREIGN KEY (`installation_record_id`) REFERENCES `manufacturing_ecm`.`service`.`installation_record`(`installation_record_id`);

-- ========= sales --> shared (31 constraint(s)) =========
-- Requires: sales schema, shared schema
ALTER TABLE `manufacturing_ecm`.`sales`.`lead` ADD CONSTRAINT `fk_sales_lead_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`shared`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`lead` ADD CONSTRAINT `fk_sales_lead_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`shared`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`lead` ADD CONSTRAINT `fk_sales_lead_product_specification_id` FOREIGN KEY (`product_specification_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_specification`(`product_specification_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`lead` ADD CONSTRAINT `fk_sales_lead_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`lead` ADD CONSTRAINT `fk_sales_lead_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `manufacturing_ecm`.`shared`.`segment`(`segment_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`lead` ADD CONSTRAINT `fk_sales_lead_warranty_policy_id` FOREIGN KEY (`warranty_policy_id`) REFERENCES `manufacturing_ecm`.`shared`.`warranty_policy`(`warranty_policy_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`account_plan` ADD CONSTRAINT `fk_sales_account_plan_pricing_agreement_id` FOREIGN KEY (`pricing_agreement_id`) REFERENCES `manufacturing_ecm`.`shared`.`pricing_agreement`(`pricing_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`account_plan` ADD CONSTRAINT `fk_sales_account_plan_profitability_segment_id` FOREIGN KEY (`profitability_segment_id`) REFERENCES `manufacturing_ecm`.`shared`.`profitability_segment`(`profitability_segment_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`account_plan` ADD CONSTRAINT `fk_sales_account_plan_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`account_plan` ADD CONSTRAINT `fk_sales_account_plan_sla_agreement_id` FOREIGN KEY (`sla_agreement_id`) REFERENCES `manufacturing_ecm`.`shared`.`sla_agreement`(`sla_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`territory_assignment` ADD CONSTRAINT `fk_sales_territory_assignment_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`quota` ADD CONSTRAINT `fk_sales_quota_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`quota` ADD CONSTRAINT `fk_sales_quota_sales_org_id` FOREIGN KEY (`sales_org_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_org`(`sales_org_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`quota` ADD CONSTRAINT `fk_sales_quota_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`discount_structure` ADD CONSTRAINT `fk_sales_discount_structure_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`shared`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`discount_structure` ADD CONSTRAINT `fk_sales_discount_structure_sales_org_id` FOREIGN KEY (`sales_org_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_org`(`sales_org_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`discount_structure` ADD CONSTRAINT `fk_sales_discount_structure_sales_price_list_id` FOREIGN KEY (`sales_price_list_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_price_list`(`sales_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`shared`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_sales_org_id` FOREIGN KEY (`sales_org_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_org`(`sales_org_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `manufacturing_ecm`.`shared`.`segment`(`segment_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`shared`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_installed_base_id` FOREIGN KEY (`installed_base_id`) REFERENCES `manufacturing_ecm`.`shared`.`installed_base`(`installed_base_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`opportunity_competitor` ADD CONSTRAINT `fk_sales_opportunity_competitor_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`team` ADD CONSTRAINT `fk_sales_team_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`campaign` ADD CONSTRAINT `fk_sales_campaign_category_id` FOREIGN KEY (`category_id`) REFERENCES `manufacturing_ecm`.`shared`.`category`(`category_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`campaign` ADD CONSTRAINT `fk_sales_campaign_cost_allocation_id` FOREIGN KEY (`cost_allocation_id`) REFERENCES `manufacturing_ecm`.`shared`.`cost_allocation`(`cost_allocation_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`campaign` ADD CONSTRAINT `fk_sales_campaign_sales_price_list_id` FOREIGN KEY (`sales_price_list_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_price_list`(`sales_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`campaign` ADD CONSTRAINT `fk_sales_campaign_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `manufacturing_ecm`.`shared`.`segment`(`segment_id`);

-- ========= service --> asset (4 constraint(s)) =========
-- Requires: service schema, asset schema
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_warranty_id` FOREIGN KEY (`warranty_id`) REFERENCES `manufacturing_ecm`.`asset`.`warranty`(`warranty_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ADD CONSTRAINT `fk_service_sla_tracking_measurement_reading_id` FOREIGN KEY (`measurement_reading_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_reading`(`measurement_reading_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_maintenance_item_id` FOREIGN KEY (`maintenance_item_id`) REFERENCES `manufacturing_ecm`.`asset`.`maintenance_item`(`maintenance_item_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_calibration_record_id` FOREIGN KEY (`calibration_record_id`) REFERENCES `manufacturing_ecm`.`asset`.`calibration_record`(`calibration_record_id`);

-- ========= service --> engineering (2 constraint(s)) =========
-- Requires: service schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_bom_line_id` FOREIGN KEY (`bom_line_id`) REFERENCES `manufacturing_ecm`.`engineering`.`bom_line`(`bom_line_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_dfmea_id` FOREIGN KEY (`dfmea_id`) REFERENCES `manufacturing_ecm`.`engineering`.`dfmea`(`dfmea_id`);

-- ========= service --> inventory (2 constraint(s)) =========
-- Requires: service schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_quarantine_hold_id` FOREIGN KEY (`quarantine_hold_id`) REFERENCES `manufacturing_ecm`.`inventory`.`quarantine_hold`(`quarantine_hold_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_stock_adjustment_id` FOREIGN KEY (`stock_adjustment_id`) REFERENCES `manufacturing_ecm`.`inventory`.`stock_adjustment`(`stock_adjustment_id`);

-- ========= service --> logistics (2 constraint(s)) =========
-- Requires: service schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_inbound_delivery_id` FOREIGN KEY (`inbound_delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`inbound_delivery`(`inbound_delivery_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_delivery_id` FOREIGN KEY (`delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`delivery`(`delivery_id`);

-- ========= service --> order (5 constraint(s)) =========
-- Requires: service schema, order schema
ALTER TABLE `manufacturing_ecm`.`service`.`request` ADD CONSTRAINT `fk_service_request_order_confirmation_id` FOREIGN KEY (`order_confirmation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_confirmation`(`order_confirmation_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_goods_issue_id` FOREIGN KEY (`goods_issue_id`) REFERENCES `manufacturing_ecm`.`order`.`goods_issue`(`goods_issue_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ADD CONSTRAINT `fk_service_contract_line_blanket_order_id` FOREIGN KEY (`blanket_order_id`) REFERENCES `manufacturing_ecm`.`order`.`blanket_order`(`blanket_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_fulfillment_plan_id` FOREIGN KEY (`fulfillment_plan_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_plan`(`fulfillment_plan_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ADD CONSTRAINT `fk_service_entitlement_blanket_order_id` FOREIGN KEY (`blanket_order_id`) REFERENCES `manufacturing_ecm`.`order`.`blanket_order`(`blanket_order_id`);

-- ========= service --> procurement (3 constraint(s)) =========
-- Requires: service schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `manufacturing_ecm`.`procurement`.`purchase_requisition`(`purchase_requisition_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ADD CONSTRAINT `fk_service_spare_parts_catalog_preferred_supplier_list_id` FOREIGN KEY (`preferred_supplier_list_id`) REFERENCES `manufacturing_ecm`.`procurement`.`preferred_supplier_list`(`preferred_supplier_list_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ADD CONSTRAINT `fk_service_spare_parts_catalog_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);

-- ========= service --> product (3 constraint(s)) =========
-- Requires: service schema, product schema
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_aftermarket_part_id` FOREIGN KEY (`aftermarket_part_id`) REFERENCES `manufacturing_ecm`.`product`.`aftermarket_part`(`aftermarket_part_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_document_id` FOREIGN KEY (`document_id`) REFERENCES `manufacturing_ecm`.`product`.`document`(`document_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ADD CONSTRAINT `fk_service_knowledge_article_regulatory_certification_id` FOREIGN KEY (`regulatory_certification_id`) REFERENCES `manufacturing_ecm`.`product`.`regulatory_certification`(`regulatory_certification_id`);

-- ========= service --> production (8 constraint(s)) =========
-- Requires: service schema, production schema
ALTER TABLE `manufacturing_ecm`.`service`.`request` ADD CONSTRAINT `fk_service_request_downtime_event_id` FOREIGN KEY (`downtime_event_id`) REFERENCES `manufacturing_ecm`.`production`.`downtime_event`(`downtime_event_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`request` ADD CONSTRAINT `fk_service_request_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_downtime_event_id` FOREIGN KEY (`downtime_event_id`) REFERENCES `manufacturing_ecm`.`production`.`downtime_event`(`downtime_event_id`);

-- ========= service --> quality (8 constraint(s)) =========
-- Requires: service schema, quality schema
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_customer_complaint_id` FOREIGN KEY (`customer_complaint_id`) REFERENCES `manufacturing_ecm`.`quality`.`customer_complaint`(`customer_complaint_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_usage_decision_id` FOREIGN KEY (`usage_decision_id`) REFERENCES `manufacturing_ecm`.`quality`.`usage_decision`(`usage_decision_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_certificate_id` FOREIGN KEY (`certificate_id`) REFERENCES `manufacturing_ecm`.`quality`.`certificate`(`certificate_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_fai_record_id` FOREIGN KEY (`fai_record_id`) REFERENCES `manufacturing_ecm`.`quality`.`fai_record`(`fai_record_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_quality_notification_id` FOREIGN KEY (`quality_notification_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_notification`(`quality_notification_id`);

-- ========= service --> sales (2 constraint(s)) =========
-- Requires: service schema, sales schema
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `manufacturing_ecm`.`sales`.`campaign`(`campaign_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ADD CONSTRAINT `fk_service_contract_line_discount_structure_id` FOREIGN KEY (`discount_structure_id`) REFERENCES `manufacturing_ecm`.`sales`.`discount_structure`(`discount_structure_id`);

-- ========= service --> shared (39 constraint(s)) =========
-- Requires: service schema, shared schema
ALTER TABLE `manufacturing_ecm`.`service`.`request` ADD CONSTRAINT `fk_service_request_failure_record_id` FOREIGN KEY (`failure_record_id`) REFERENCES `manufacturing_ecm`.`shared`.`failure_record`(`failure_record_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`request` ADD CONSTRAINT `fk_service_request_lifecycle_id` FOREIGN KEY (`lifecycle_id`) REFERENCES `manufacturing_ecm`.`shared`.`lifecycle`(`lifecycle_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`request` ADD CONSTRAINT `fk_service_request_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`shared`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`shared`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ADD CONSTRAINT `fk_service_contract_line_product_price_list_id` FOREIGN KEY (`product_price_list_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_price_list`(`product_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ADD CONSTRAINT `fk_service_contract_line_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ADD CONSTRAINT `fk_service_service_territory_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ADD CONSTRAINT `fk_service_service_territory_segment_id` FOREIGN KEY (`segment_id`) REFERENCES `manufacturing_ecm`.`shared`.`segment`(`segment_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_approved_manufacturer_id` FOREIGN KEY (`approved_manufacturer_id`) REFERENCES `manufacturing_ecm`.`shared`.`approved_manufacturer`(`approved_manufacturer_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`shared`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_returns_order_id` FOREIGN KEY (`returns_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`returns_order`(`returns_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`shared`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `manufacturing_ecm`.`shared`.`stock_position`(`stock_position_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`shared`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`shared`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ADD CONSTRAINT `fk_service_spare_parts_catalog_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ADD CONSTRAINT `fk_service_spare_parts_catalog_plant_id` FOREIGN KEY (`plant_id`) REFERENCES `manufacturing_ecm`.`shared`.`plant`(`plant_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ADD CONSTRAINT `fk_service_spare_parts_catalog_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ADD CONSTRAINT `fk_service_spare_parts_catalog_uom_id` FOREIGN KEY (`uom_id`) REFERENCES `manufacturing_ecm`.`shared`.`uom`(`uom_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_asset_bom_id` FOREIGN KEY (`asset_bom_id`) REFERENCES `manufacturing_ecm`.`shared`.`asset_bom`(`asset_bom_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_bop_id` FOREIGN KEY (`bop_id`) REFERENCES `manufacturing_ecm`.`shared`.`bop`(`bop_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`shared`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`shared`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`shared`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_product_configuration_id` FOREIGN KEY (`product_configuration_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_configuration`(`product_configuration_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `manufacturing_ecm`.`shared`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`shared`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_work_order_operation_id` FOREIGN KEY (`work_order_operation_id`) REFERENCES `manufacturing_ecm`.`shared`.`work_order_operation`(`work_order_operation_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ADD CONSTRAINT `fk_service_entitlement_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ADD CONSTRAINT `fk_service_entitlement_sales_price_list_id` FOREIGN KEY (`sales_price_list_id`) REFERENCES `manufacturing_ecm`.`shared`.`sales_price_list`(`sales_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ADD CONSTRAINT `fk_service_entitlement_warranty_policy_id` FOREIGN KEY (`warranty_policy_id`) REFERENCES `manufacturing_ecm`.`shared`.`warranty_policy`(`warranty_policy_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ADD CONSTRAINT `fk_service_knowledge_article_drawing_id` FOREIGN KEY (`drawing_id`) REFERENCES `manufacturing_ecm`.`shared`.`drawing`(`drawing_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ADD CONSTRAINT `fk_service_knowledge_article_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`shared`.`product_variant`(`product_variant_id`);

-- ========= shared --> asset (6 constraint(s)) =========
-- Requires: shared schema, asset schema
ALTER TABLE `manufacturing_ecm`.`shared`.`asset_bom` ADD CONSTRAINT `fk_shared_asset_bom_class_id` FOREIGN KEY (`class_id`) REFERENCES `manufacturing_ecm`.`asset`.`class`(`class_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`work_order_operation` ADD CONSTRAINT `fk_shared_work_order_operation_maintenance_item_id` FOREIGN KEY (`maintenance_item_id`) REFERENCES `manufacturing_ecm`.`asset`.`maintenance_item`(`maintenance_item_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`work_order_operation` ADD CONSTRAINT `fk_shared_work_order_operation_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `manufacturing_ecm`.`asset`.`maintenance_plan`(`maintenance_plan_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`work_order_operation` ADD CONSTRAINT `fk_shared_work_order_operation_task_list_id` FOREIGN KEY (`task_list_id`) REFERENCES `manufacturing_ecm`.`asset`.`task_list`(`task_list_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`returns_order` ADD CONSTRAINT `fk_shared_returns_order_warranty_id` FOREIGN KEY (`warranty_id`) REFERENCES `manufacturing_ecm`.`asset`.`warranty`(`warranty_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`category` ADD CONSTRAINT `fk_shared_category_class_id` FOREIGN KEY (`class_id`) REFERENCES `manufacturing_ecm`.`asset`.`class`(`class_id`);

-- ========= shared --> customer (5 constraint(s)) =========
-- Requires: shared schema, customer schema
ALTER TABLE `manufacturing_ecm`.`shared`.`account_hierarchy` ADD CONSTRAINT `fk_shared_account_hierarchy_account_classification_id` FOREIGN KEY (`account_classification_id`) REFERENCES `manufacturing_ecm`.`customer`.`account_classification`(`account_classification_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`account_hierarchy` ADD CONSTRAINT `fk_shared_account_hierarchy_sales_area_assignment_id` FOREIGN KEY (`sales_area_assignment_id`) REFERENCES `manufacturing_ecm`.`customer`.`sales_area_assignment`(`sales_area_assignment_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`ar_invoice` ADD CONSTRAINT `fk_shared_ar_invoice_credit_profile_id` FOREIGN KEY (`credit_profile_id`) REFERENCES `manufacturing_ecm`.`customer`.`credit_profile`(`credit_profile_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`cost_allocation` ADD CONSTRAINT `fk_shared_cost_allocation_account_classification_id` FOREIGN KEY (`account_classification_id`) REFERENCES `manufacturing_ecm`.`customer`.`account_classification`(`account_classification_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`profitability_segment` ADD CONSTRAINT `fk_shared_profitability_segment_sales_area_assignment_id` FOREIGN KEY (`sales_area_assignment_id`) REFERENCES `manufacturing_ecm`.`customer`.`sales_area_assignment`(`sales_area_assignment_id`);

-- ========= shared --> engineering (13 constraint(s)) =========
-- Requires: shared schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`shared`.`failure_record` ADD CONSTRAINT `fk_shared_failure_record_pfmea_id` FOREIGN KEY (`pfmea_id`) REFERENCES `manufacturing_ecm`.`engineering`.`pfmea`(`pfmea_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`serialized_unit` ADD CONSTRAINT `fk_shared_serialized_unit_cad_model_id` FOREIGN KEY (`cad_model_id`) REFERENCES `manufacturing_ecm`.`engineering`.`cad_model`(`cad_model_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`engineering_bom` ADD CONSTRAINT `fk_shared_engineering_bom_plm_lifecycle_state_id` FOREIGN KEY (`plm_lifecycle_state_id`) REFERENCES `manufacturing_ecm`.`engineering`.`plm_lifecycle_state`(`plm_lifecycle_state_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`bop` ADD CONSTRAINT `fk_shared_bop_eco_id` FOREIGN KEY (`eco_id`) REFERENCES `manufacturing_ecm`.`engineering`.`eco`(`eco_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`bop` ADD CONSTRAINT `fk_shared_bop_plm_lifecycle_state_id` FOREIGN KEY (`plm_lifecycle_state_id`) REFERENCES `manufacturing_ecm`.`engineering`.`plm_lifecycle_state`(`plm_lifecycle_state_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`drawing` ADD CONSTRAINT `fk_shared_drawing_cad_model_id` FOREIGN KEY (`cad_model_id`) REFERENCES `manufacturing_ecm`.`engineering`.`cad_model`(`cad_model_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`drawing` ADD CONSTRAINT `fk_shared_drawing_plm_lifecycle_state_id` FOREIGN KEY (`plm_lifecycle_state_id`) REFERENCES `manufacturing_ecm`.`engineering`.`plm_lifecycle_state`(`plm_lifecycle_state_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`product_specification` ADD CONSTRAINT `fk_shared_product_specification_plm_lifecycle_state_id` FOREIGN KEY (`plm_lifecycle_state_id`) REFERENCES `manufacturing_ecm`.`engineering`.`plm_lifecycle_state`(`plm_lifecycle_state_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`approved_manufacturer` ADD CONSTRAINT `fk_shared_approved_manufacturer_bom_line_id` FOREIGN KEY (`bom_line_id`) REFERENCES `manufacturing_ecm`.`engineering`.`bom_line`(`bom_line_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`product_variant` ADD CONSTRAINT `fk_shared_product_variant_cad_model_id` FOREIGN KEY (`cad_model_id`) REFERENCES `manufacturing_ecm`.`engineering`.`cad_model`(`cad_model_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`product_variant` ADD CONSTRAINT `fk_shared_product_variant_plm_lifecycle_state_id` FOREIGN KEY (`plm_lifecycle_state_id`) REFERENCES `manufacturing_ecm`.`engineering`.`plm_lifecycle_state`(`plm_lifecycle_state_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`product_configuration` ADD CONSTRAINT `fk_shared_product_configuration_cad_model_id` FOREIGN KEY (`cad_model_id`) REFERENCES `manufacturing_ecm`.`engineering`.`cad_model`(`cad_model_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`purchase_order` ADD CONSTRAINT `fk_shared_purchase_order_bom_line_id` FOREIGN KEY (`bom_line_id`) REFERENCES `manufacturing_ecm`.`engineering`.`bom_line`(`bom_line_id`);

-- ========= shared --> finance (4 constraint(s)) =========
-- Requires: shared schema, finance schema
ALTER TABLE `manufacturing_ecm`.`shared`.`goods_receipt` ADD CONSTRAINT `fk_shared_goods_receipt_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `manufacturing_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`controlling_area` ADD CONSTRAINT `fk_shared_controlling_area_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`ap_invoice` ADD CONSTRAINT `fk_shared_ap_invoice_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`ar_invoice` ADD CONSTRAINT `fk_shared_ar_invoice_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);

-- ========= shared --> inventory (2 constraint(s)) =========
-- Requires: shared schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`shared`.`stock_position` ADD CONSTRAINT `fk_shared_stock_position_reorder_policy_id` FOREIGN KEY (`reorder_policy_id`) REFERENCES `manufacturing_ecm`.`inventory`.`reorder_policy`(`reorder_policy_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`returns_order` ADD CONSTRAINT `fk_shared_returns_order_quarantine_hold_id` FOREIGN KEY (`quarantine_hold_id`) REFERENCES `manufacturing_ecm`.`inventory`.`quarantine_hold`(`quarantine_hold_id`);

-- ========= shared --> order (3 constraint(s)) =========
-- Requires: shared schema, order schema
ALTER TABLE `manufacturing_ecm`.`shared`.`line_item` ADD CONSTRAINT `fk_shared_line_item_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `manufacturing_ecm`.`order`.`channel`(`channel_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`line_item` ADD CONSTRAINT `fk_shared_line_item_priority_id` FOREIGN KEY (`priority_id`) REFERENCES `manufacturing_ecm`.`order`.`priority`(`priority_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`returns_order` ADD CONSTRAINT `fk_shared_returns_order_goods_issue_id` FOREIGN KEY (`goods_issue_id`) REFERENCES `manufacturing_ecm`.`order`.`goods_issue`(`goods_issue_id`);

-- ========= shared --> procurement (4 constraint(s)) =========
-- Requires: shared schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`shared`.`failure_record` ADD CONSTRAINT `fk_shared_failure_record_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `manufacturing_ecm`.`procurement`.`purchase_requisition`(`purchase_requisition_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`contract` ADD CONSTRAINT `fk_shared_contract_spend_category_id` FOREIGN KEY (`spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`spend_category`(`spend_category_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`contract` ADD CONSTRAINT `fk_shared_contract_supply_agreement_id` FOREIGN KEY (`supply_agreement_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supply_agreement`(`supply_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`purchase_order` ADD CONSTRAINT `fk_shared_purchase_order_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `manufacturing_ecm`.`procurement`.`purchase_requisition`(`purchase_requisition_id`);

-- ========= shared --> product (13 constraint(s)) =========
-- Requires: shared schema, product schema
ALTER TABLE `manufacturing_ecm`.`shared`.`installed_base` ADD CONSTRAINT `fk_shared_installed_base_aftermarket_part_id` FOREIGN KEY (`aftermarket_part_id`) REFERENCES `manufacturing_ecm`.`product`.`aftermarket_part`(`aftermarket_part_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`asset_bom` ADD CONSTRAINT `fk_shared_asset_bom_aftermarket_part_id` FOREIGN KEY (`aftermarket_part_id`) REFERENCES `manufacturing_ecm`.`product`.`aftermarket_part`(`aftermarket_part_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`work_order_operation` ADD CONSTRAINT `fk_shared_work_order_operation_aftermarket_part_id` FOREIGN KEY (`aftermarket_part_id`) REFERENCES `manufacturing_ecm`.`product`.`aftermarket_part`(`aftermarket_part_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`lot_batch` ADD CONSTRAINT `fk_shared_lot_batch_hazardous_substance_id` FOREIGN KEY (`hazardous_substance_id`) REFERENCES `manufacturing_ecm`.`product`.`hazardous_substance`(`hazardous_substance_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`product_specification` ADD CONSTRAINT `fk_shared_product_specification_regulatory_certification_id` FOREIGN KEY (`regulatory_certification_id`) REFERENCES `manufacturing_ecm`.`product`.`regulatory_certification`(`regulatory_certification_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`material_specification` ADD CONSTRAINT `fk_shared_material_specification_hazardous_substance_id` FOREIGN KEY (`hazardous_substance_id`) REFERENCES `manufacturing_ecm`.`product`.`hazardous_substance`(`hazardous_substance_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`approved_manufacturer` ADD CONSTRAINT `fk_shared_approved_manufacturer_classification_id` FOREIGN KEY (`classification_id`) REFERENCES `manufacturing_ecm`.`product`.`classification`(`classification_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`product_variant` ADD CONSTRAINT `fk_shared_product_variant_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`product_configuration` ADD CONSTRAINT `fk_shared_product_configuration_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`lifecycle` ADD CONSTRAINT `fk_shared_lifecycle_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`sales_org` ADD CONSTRAINT `fk_shared_sales_org_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`plant` ADD CONSTRAINT `fk_shared_plant_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`supplier` ADD CONSTRAINT `fk_shared_supplier_regulatory_certification_id` FOREIGN KEY (`regulatory_certification_id`) REFERENCES `manufacturing_ecm`.`product`.`regulatory_certification`(`regulatory_certification_id`);

-- ========= shared --> production (1 constraint(s)) =========
-- Requires: shared schema, production schema
ALTER TABLE `manufacturing_ecm`.`shared`.`product_cost_estimate` ADD CONSTRAINT `fk_shared_product_cost_estimate_version_id` FOREIGN KEY (`version_id`) REFERENCES `manufacturing_ecm`.`production`.`version`(`version_id`);

-- ========= shared --> service (3 constraint(s)) =========
-- Requires: shared schema, service schema
ALTER TABLE `manufacturing_ecm`.`shared`.`ar_invoice` ADD CONSTRAINT `fk_shared_ar_invoice_contract_line_id` FOREIGN KEY (`contract_line_id`) REFERENCES `manufacturing_ecm`.`service`.`contract_line`(`contract_line_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`profitability_segment` ADD CONSTRAINT `fk_shared_profitability_segment_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `manufacturing_ecm`.`service`.`service_territory`(`service_territory_id`);
ALTER TABLE `manufacturing_ecm`.`shared`.`tax_code` ADD CONSTRAINT `fk_shared_tax_code_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `manufacturing_ecm`.`service`.`service_territory`(`service_territory_id`);

