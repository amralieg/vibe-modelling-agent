-- Cross-Domain Foreign Keys for Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:38
-- Total cross-domain FK constraints: 1836
--
-- EXECUTION ORDER:
--   1. Run ALL domain schema files first (any order).
--   2. Run this file LAST.
--
-- PREREQUISITE DOMAINS: asset, billing, compliance, customer, engineering, finance, hse, inventory, logistics, order, procurement, product, production, quality, research, sales, service, technology, workforce

-- ========= asset --> billing (1 constraint(s)) =========
-- Requires: asset schema, billing schema
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_plan_id` FOREIGN KEY (`plan_id`) REFERENCES `manufacturing_ecm`.`billing`.`plan`(`plan_id`);

-- ========= asset --> compliance (4 constraint(s)) =========
-- Requires: asset schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ADD CONSTRAINT `fk_asset_permit_to_work_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `manufacturing_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ADD CONSTRAINT `fk_asset_asset_document_evidence_id` FOREIGN KEY (`evidence_id`) REFERENCES `manufacturing_ecm`.`compliance`.`evidence`(`evidence_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ADD CONSTRAINT `fk_asset_control_implementation_cybersecurity_control_id` FOREIGN KEY (`cybersecurity_control_id`) REFERENCES `manufacturing_ecm`.`compliance`.`cybersecurity_control`(`cybersecurity_control_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`contract_risk_assessment` ADD CONSTRAINT `fk_asset_contract_risk_assessment_third_party_risk_id` FOREIGN KEY (`third_party_risk_id`) REFERENCES `manufacturing_ecm`.`compliance`.`third_party_risk`(`third_party_risk_id`);

-- ========= asset --> engineering (6 constraint(s)) =========
-- Requires: asset schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ADD CONSTRAINT `fk_asset_failure_record_pfmea_id` FOREIGN KEY (`pfmea_id`) REFERENCES `manufacturing_ecm`.`engineering`.`pfmea`(`pfmea_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_product_specification_id` FOREIGN KEY (`product_specification_id`) REFERENCES `manufacturing_ecm`.`engineering`.`product_specification`(`product_specification_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ADD CONSTRAINT `fk_asset_capex_request_project_id` FOREIGN KEY (`project_id`) REFERENCES `manufacturing_ecm`.`engineering`.`project`(`project_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_approved_manufacturer_id` FOREIGN KEY (`approved_manufacturer_id`) REFERENCES `manufacturing_ecm`.`engineering`.`approved_manufacturer`(`approved_manufacturer_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ADD CONSTRAINT `fk_asset_asset_document_cad_model_id` FOREIGN KEY (`cad_model_id`) REFERENCES `manufacturing_ecm`.`engineering`.`cad_model`(`cad_model_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ADD CONSTRAINT `fk_asset_equipment_certification_engineering_regulatory_certification_id` FOREIGN KEY (`engineering_regulatory_certification_id`) REFERENCES `manufacturing_ecm`.`engineering`.`engineering_regulatory_certification`(`engineering_regulatory_certification_id`);

-- ========= asset --> finance (1 constraint(s)) =========
-- Requires: asset schema, finance schema
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ADD CONSTRAINT `fk_asset_capex_request_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `manufacturing_ecm`.`finance`.`budget`(`budget_id`);

-- ========= asset --> hse (1 constraint(s)) =========
-- Requires: asset schema, hse schema
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ADD CONSTRAINT `fk_asset_permit_to_work_incident_id` FOREIGN KEY (`incident_id`) REFERENCES `manufacturing_ecm`.`hse`.`incident`(`incident_id`);

-- ========= asset --> order (1 constraint(s)) =========
-- Requires: asset schema, order schema
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ADD CONSTRAINT `fk_asset_capex_request_order_quotation_id` FOREIGN KEY (`order_quotation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_quotation`(`order_quotation_id`);

-- ========= asset --> procurement (3 constraint(s)) =========
-- Requires: asset schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ADD CONSTRAINT `fk_asset_capex_request_procurement_purchase_requisition_id` FOREIGN KEY (`procurement_purchase_requisition_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition`(`procurement_purchase_requisition_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_procurement_contract_id` FOREIGN KEY (`procurement_contract_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_contract`(`procurement_contract_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ADD CONSTRAINT `fk_asset_asset_supply_agreement_procurement_supply_agreement_id` FOREIGN KEY (`procurement_supply_agreement_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_supply_agreement`(`procurement_supply_agreement_id`);

-- ========= asset --> product (1 constraint(s)) =========
-- Requires: asset schema, product schema
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_warranty_policy_id` FOREIGN KEY (`warranty_policy_id`) REFERENCES `manufacturing_ecm`.`product`.`warranty_policy`(`warranty_policy_id`);

-- ========= asset --> service (2 constraint(s)) =========
-- Requires: asset schema, service schema
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ADD CONSTRAINT `fk_asset_asset_notification_request_id` FOREIGN KEY (`request_id`) REFERENCES `manufacturing_ecm`.`service`.`request`(`request_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ADD CONSTRAINT `fk_asset_predictive_alert_request_id` FOREIGN KEY (`request_id`) REFERENCES `manufacturing_ecm`.`service`.`request`(`request_id`);

-- ========= asset --> technology (2 constraint(s)) =========
-- Requires: asset schema, technology schema
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ADD CONSTRAINT `fk_asset_iiot_asset_telemetry_iiot_platform_id` FOREIGN KEY (`iiot_platform_id`) REFERENCES `manufacturing_ecm`.`technology`.`iiot_platform`(`iiot_platform_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_it_vendor_id` FOREIGN KEY (`it_vendor_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_vendor`(`it_vendor_id`);

-- ========= asset --> workforce (88 constraint(s)) =========
-- Requires: asset schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ADD CONSTRAINT `fk_asset_maintenance_item_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ADD CONSTRAINT `fk_asset_maintenance_item_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ADD CONSTRAINT `fk_asset_maintenance_item_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`maintenance_item` ADD CONSTRAINT `fk_asset_maintenance_item_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ADD CONSTRAINT `fk_asset_asset_notification_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ADD CONSTRAINT `fk_asset_asset_notification_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ADD CONSTRAINT `fk_asset_asset_notification_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_notification` ADD CONSTRAINT `fk_asset_asset_notification_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ADD CONSTRAINT `fk_asset_measurement_point_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ADD CONSTRAINT `fk_asset_measurement_point_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_point` ADD CONSTRAINT `fk_asset_measurement_point_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ADD CONSTRAINT `fk_asset_measurement_reading_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ADD CONSTRAINT `fk_asset_measurement_reading_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`measurement_reading` ADD CONSTRAINT `fk_asset_measurement_reading_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ADD CONSTRAINT `fk_asset_failure_record_capa_record_id` FOREIGN KEY (`capa_record_id`) REFERENCES `manufacturing_ecm`.`workforce`.`capa_record`(`capa_record_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ADD CONSTRAINT `fk_asset_failure_record_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ADD CONSTRAINT `fk_asset_failure_record_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ADD CONSTRAINT `fk_asset_failure_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`failure_record` ADD CONSTRAINT `fk_asset_failure_record_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`reliability_record` ADD CONSTRAINT `fk_asset_reliability_record_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ADD CONSTRAINT `fk_asset_asset_bom_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_bom` ADD CONSTRAINT `fk_asset_asset_bom_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ADD CONSTRAINT `fk_asset_work_order_operation_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ADD CONSTRAINT `fk_asset_work_order_operation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ADD CONSTRAINT `fk_asset_work_order_operation_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`work_order_operation` ADD CONSTRAINT `fk_asset_work_order_operation_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ADD CONSTRAINT `fk_asset_permit_to_work_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ADD CONSTRAINT `fk_asset_permit_to_work_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ADD CONSTRAINT `fk_asset_permit_to_work_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`permit_to_work` ADD CONSTRAINT `fk_asset_permit_to_work_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`calibration_record` ADD CONSTRAINT `fk_asset_calibration_record_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ADD CONSTRAINT `fk_asset_asset_valuation_asset_register_id` FOREIGN KEY (`asset_register_id`) REFERENCES `manufacturing_ecm`.`workforce`.`asset_register`(`asset_register_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_valuation` ADD CONSTRAINT `fk_asset_asset_valuation_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ADD CONSTRAINT `fk_asset_capex_request_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ADD CONSTRAINT `fk_asset_capex_request_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ADD CONSTRAINT `fk_asset_capex_request_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ADD CONSTRAINT `fk_asset_capex_request_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ADD CONSTRAINT `fk_asset_capex_request_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ADD CONSTRAINT `fk_asset_capex_request_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`capex_request` ADD CONSTRAINT `fk_asset_capex_request_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ADD CONSTRAINT `fk_asset_lifecycle_event_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ADD CONSTRAINT `fk_asset_lifecycle_event_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`lifecycle_event` ADD CONSTRAINT `fk_asset_lifecycle_event_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ADD CONSTRAINT `fk_asset_condition_assessment_assessed_by_employee_id` FOREIGN KEY (`assessed_by_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ADD CONSTRAINT `fk_asset_condition_assessment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ADD CONSTRAINT `fk_asset_condition_assessment_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ADD CONSTRAINT `fk_asset_condition_assessment_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`condition_assessment` ADD CONSTRAINT `fk_asset_condition_assessment_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ADD CONSTRAINT `fk_asset_iiot_asset_telemetry_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`iiot_asset_telemetry` ADD CONSTRAINT `fk_asset_iiot_asset_telemetry_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ADD CONSTRAINT `fk_asset_predictive_alert_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ADD CONSTRAINT `fk_asset_predictive_alert_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ADD CONSTRAINT `fk_asset_predictive_alert_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`predictive_alert` ADD CONSTRAINT `fk_asset_predictive_alert_line_id` FOREIGN KEY (`line_id`) REFERENCES `manufacturing_ecm`.`workforce`.`line`(`line_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`warranty` ADD CONSTRAINT `fk_asset_warranty_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`service_contract` ADD CONSTRAINT `fk_asset_service_contract_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ADD CONSTRAINT `fk_asset_shutdown_plan_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ADD CONSTRAINT `fk_asset_shutdown_plan_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`internal_order`(`internal_order_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ADD CONSTRAINT `fk_asset_shutdown_plan_line_id` FOREIGN KEY (`line_id`) REFERENCES `manufacturing_ecm`.`workforce`.`line`(`line_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`shutdown_plan` ADD CONSTRAINT `fk_asset_shutdown_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`task_list` ADD CONSTRAINT `fk_asset_task_list_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ADD CONSTRAINT `fk_asset_asset_document_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_document` ADD CONSTRAINT `fk_asset_asset_document_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_contract_coverage` ADD CONSTRAINT `fk_asset_equipment_contract_coverage_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ADD CONSTRAINT `fk_asset_equipment_service_contract_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_service_contract` ADD CONSTRAINT `fk_asset_equipment_service_contract_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ADD CONSTRAINT `fk_asset_asset_supply_agreement_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`asset_supply_agreement` ADD CONSTRAINT `fk_asset_asset_supply_agreement_spare_part_id` FOREIGN KEY (`spare_part_id`) REFERENCES `manufacturing_ecm`.`workforce`.`spare_part`(`spare_part_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` ADD CONSTRAINT `fk_asset_equipment_allocation_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_allocation` ADD CONSTRAINT `fk_asset_equipment_allocation_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ADD CONSTRAINT `fk_asset_equipment_compliance_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_compliance` ADD CONSTRAINT `fk_asset_equipment_compliance_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`control_implementation` ADD CONSTRAINT `fk_asset_control_implementation_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`asset`.`equipment_certification` ADD CONSTRAINT `fk_asset_equipment_certification_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);

-- ========= billing --> compliance (1 constraint(s)) =========
-- Requires: billing schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ADD CONSTRAINT `fk_billing_invoice_dispute_exception_id` FOREIGN KEY (`exception_id`) REFERENCES `manufacturing_ecm`.`compliance`.`exception`(`exception_id`);

-- ========= billing --> customer (2 constraint(s)) =========
-- Requires: billing schema, customer schema
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`customer`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ADD CONSTRAINT `fk_billing_plan_sla_agreement_id` FOREIGN KEY (`sla_agreement_id`) REFERENCES `manufacturing_ecm`.`customer`.`sla_agreement`(`sla_agreement_id`);

-- ========= billing --> engineering (5 constraint(s)) =========
-- Requires: billing schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_engineering_prototype_id` FOREIGN KEY (`engineering_prototype_id`) REFERENCES `manufacturing_ecm`.`engineering`.`engineering_prototype`(`engineering_prototype_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_project_id` FOREIGN KEY (`project_id`) REFERENCES `manufacturing_ecm`.`engineering`.`project`(`project_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_tooling_equipment_id` FOREIGN KEY (`tooling_equipment_id`) REFERENCES `manufacturing_ecm`.`engineering`.`tooling_equipment`(`tooling_equipment_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ADD CONSTRAINT `fk_billing_plan_milestone_project_id` FOREIGN KEY (`project_id`) REFERENCES `manufacturing_ecm`.`engineering`.`project`(`project_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ADD CONSTRAINT `fk_billing_performance_obligation_project_id` FOREIGN KEY (`project_id`) REFERENCES `manufacturing_ecm`.`engineering`.`project`(`project_id`);

-- ========= billing --> finance (7 constraint(s)) =========
-- Requires: billing schema, finance schema
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `manufacturing_ecm`.`finance`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ADD CONSTRAINT `fk_billing_payment_receipt_bank_account_id` FOREIGN KEY (`bank_account_id`) REFERENCES `manufacturing_ecm`.`finance`.`bank_account`(`bank_account_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ADD CONSTRAINT `fk_billing_payment_receipt_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `manufacturing_ecm`.`finance`.`payment`(`payment_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ADD CONSTRAINT `fk_billing_revenue_recognition_event_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `manufacturing_ecm`.`finance`.`journal_entry`(`journal_entry_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ADD CONSTRAINT `fk_billing_tax_determination_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`finance`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ADD CONSTRAINT `fk_billing_intercompany_invoice_intercompany_transaction_id` FOREIGN KEY (`intercompany_transaction_id`) REFERENCES `manufacturing_ecm`.`finance`.`intercompany_transaction`(`intercompany_transaction_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `manufacturing_ecm`.`finance`.`journal_entry`(`journal_entry_id`);

-- ========= billing --> hse (4 constraint(s)) =========
-- Requires: billing schema, hse schema
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_contractor_qualification_id` FOREIGN KEY (`contractor_qualification_id`) REFERENCES `manufacturing_ecm`.`hse`.`contractor_qualification`(`contractor_qualification_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `manufacturing_ecm`.`hse`.`environmental_permit`(`environmental_permit_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_safety_training_id` FOREIGN KEY (`safety_training_id`) REFERENCES `manufacturing_ecm`.`hse`.`safety_training`(`safety_training_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_waste_record_id` FOREIGN KEY (`waste_record_id`) REFERENCES `manufacturing_ecm`.`hse`.`waste_record`(`waste_record_id`);

-- ========= billing --> inventory (4 constraint(s)) =========
-- Requires: billing schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`inventory`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`inventory`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_stock_adjustment_id` FOREIGN KEY (`stock_adjustment_id`) REFERENCES `manufacturing_ecm`.`inventory`.`stock_adjustment`(`stock_adjustment_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_transaction_id` FOREIGN KEY (`transaction_id`) REFERENCES `manufacturing_ecm`.`inventory`.`transaction`(`transaction_id`);

-- ========= billing --> logistics (2 constraint(s)) =========
-- Requires: billing schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_shipment_item_id` FOREIGN KEY (`shipment_item_id`) REFERENCES `manufacturing_ecm`.`logistics`.`shipment_item`(`shipment_item_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ADD CONSTRAINT `fk_billing_intercompany_invoice_delivery_id` FOREIGN KEY (`delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`delivery`(`delivery_id`);

-- ========= billing --> order (1 constraint(s)) =========
-- Requires: billing schema, order schema
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_returns_order_id` FOREIGN KEY (`returns_order_id`) REFERENCES `manufacturing_ecm`.`order`.`returns_order`(`returns_order_id`);

-- ========= billing --> procurement (2 constraint(s)) =========
-- Requires: billing schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_procurement_po_line_item_id` FOREIGN KEY (`procurement_po_line_item_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_po_line_item`(`procurement_po_line_item_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_receipt` ADD CONSTRAINT `fk_billing_payment_receipt_procurement_supplier_invoice_id` FOREIGN KEY (`procurement_supplier_invoice_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice`(`procurement_supplier_invoice_id`);

-- ========= billing --> production (1 constraint(s)) =========
-- Requires: billing schema, production schema
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);

-- ========= billing --> quality (3 constraint(s)) =========
-- Requires: billing schema, quality schema
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_certificate_id` FOREIGN KEY (`certificate_id`) REFERENCES `manufacturing_ecm`.`quality`.`certificate`(`certificate_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_supplier_quality_event_id` FOREIGN KEY (`supplier_quality_event_id`) REFERENCES `manufacturing_ecm`.`quality`.`supplier_quality_event`(`supplier_quality_event_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ADD CONSTRAINT `fk_billing_invoice_dispute_quality_notification_id` FOREIGN KEY (`quality_notification_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_notification`(`quality_notification_id`);

-- ========= billing --> research (2 constraint(s)) =========
-- Requires: billing schema, research schema
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ADD CONSTRAINT `fk_billing_plan_milestone_rd_milestone_id` FOREIGN KEY (`rd_milestone_id`) REFERENCES `manufacturing_ecm`.`research`.`rd_milestone`(`rd_milestone_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ADD CONSTRAINT `fk_billing_document_output_partner_id` FOREIGN KEY (`partner_id`) REFERENCES `manufacturing_ecm`.`research`.`partner`(`partner_id`);

-- ========= billing --> service (6 constraint(s)) =========
-- Requires: billing schema, service schema
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_contract_line_id` FOREIGN KEY (`contract_line_id`) REFERENCES `manufacturing_ecm`.`service`.`contract_line`(`contract_line_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_installation_record_id` FOREIGN KEY (`installation_record_id`) REFERENCES `manufacturing_ecm`.`service`.`installation_record`(`installation_record_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_spare_parts_request_id` FOREIGN KEY (`spare_parts_request_id`) REFERENCES `manufacturing_ecm`.`service`.`spare_parts_request`(`spare_parts_request_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_product_return_id` FOREIGN KEY (`product_return_id`) REFERENCES `manufacturing_ecm`.`service`.`product_return`(`product_return_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_warranty_claim_id` FOREIGN KEY (`warranty_claim_id`) REFERENCES `manufacturing_ecm`.`service`.`warranty_claim`(`warranty_claim_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ADD CONSTRAINT `fk_billing_invoice_dispute_service_invoice_id` FOREIGN KEY (`service_invoice_id`) REFERENCES `manufacturing_ecm`.`service`.`service_invoice`(`service_invoice_id`);

-- ========= billing --> technology (5 constraint(s)) =========
-- Requires: billing schema, technology schema
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_software_license_id` FOREIGN KEY (`software_license_id`) REFERENCES `manufacturing_ecm`.`technology`.`software_license`(`software_license_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ADD CONSTRAINT `fk_billing_plan_milestone_it_project_milestone_id` FOREIGN KEY (`it_project_milestone_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_project_milestone`(`it_project_milestone_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ADD CONSTRAINT `fk_billing_revenue_recognition_event_it_project_id` FOREIGN KEY (`it_project_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_project`(`it_project_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`intercompany_invoice` ADD CONSTRAINT `fk_billing_intercompany_invoice_it_service_id` FOREIGN KEY (`it_service_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_service`(`it_service_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ADD CONSTRAINT `fk_billing_invoice_service_line_it_service_id` FOREIGN KEY (`it_service_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_service`(`it_service_id`);

-- ========= billing --> workforce (52 constraint(s)) =========
-- Requires: billing schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_line_item` ADD CONSTRAINT `fk_billing_invoice_line_item_spare_part_id` FOREIGN KEY (`spare_part_id`) REFERENCES `manufacturing_ecm`.`workforce`.`spare_part`(`spare_part_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_approved_by_employee_id` FOREIGN KEY (`approved_by_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`credit_note` ADD CONSTRAINT `fk_billing_credit_note_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ADD CONSTRAINT `fk_billing_plan_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`plan` ADD CONSTRAINT `fk_billing_plan_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`plan_milestone` ADD CONSTRAINT `fk_billing_plan_milestone_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ADD CONSTRAINT `fk_billing_revenue_recognition_event_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ADD CONSTRAINT `fk_billing_revenue_recognition_event_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ADD CONSTRAINT `fk_billing_revenue_recognition_event_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`revenue_recognition_event` ADD CONSTRAINT `fk_billing_revenue_recognition_event_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ADD CONSTRAINT `fk_billing_performance_obligation_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`performance_obligation` ADD CONSTRAINT `fk_billing_performance_obligation_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ADD CONSTRAINT `fk_billing_dunning_record_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`dunning_record` ADD CONSTRAINT `fk_billing_dunning_record_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`tax_determination` ADD CONSTRAINT `fk_billing_tax_determination_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`billing_block` ADD CONSTRAINT `fk_billing_billing_block_released_by_user_employee_id` FOREIGN KEY (`released_by_user_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ADD CONSTRAINT `fk_billing_invoice_dispute_assigned_to_employee_id` FOREIGN KEY (`assigned_to_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ADD CONSTRAINT `fk_billing_invoice_dispute_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ADD CONSTRAINT `fk_billing_invoice_dispute_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ADD CONSTRAINT `fk_billing_invoice_dispute_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ADD CONSTRAINT `fk_billing_invoice_dispute_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_dispute` ADD CONSTRAINT `fk_billing_invoice_dispute_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ADD CONSTRAINT `fk_billing_accounts_receivable_position_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`accounts_receivable_position` ADD CONSTRAINT `fk_billing_accounts_receivable_position_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`document_output` ADD CONSTRAINT `fk_billing_document_output_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ADD CONSTRAINT `fk_billing_invoice_status_history_approved_by_user_employee_id` FOREIGN KEY (`approved_by_user_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ADD CONSTRAINT `fk_billing_invoice_status_history_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_status_history` ADD CONSTRAINT `fk_billing_invoice_status_history_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_authorized_by_employee_id` FOREIGN KEY (`authorized_by_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`write_off` ADD CONSTRAINT `fk_billing_write_off_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`condition` ADD CONSTRAINT `fk_billing_condition_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`billing`.`invoice_service_line` ADD CONSTRAINT `fk_billing_invoice_service_line_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);

-- ========= compliance --> asset (1 constraint(s)) =========
-- Requires: compliance schema, asset schema
ALTER TABLE `manufacturing_ecm`.`compliance`.`internal_audit` ADD CONSTRAINT `fk_compliance_internal_audit_shutdown_plan_id` FOREIGN KEY (`shutdown_plan_id`) REFERENCES `manufacturing_ecm`.`asset`.`shutdown_plan`(`shutdown_plan_id`);

-- ========= compliance --> engineering (4 constraint(s)) =========
-- Requires: compliance schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`compliance`.`compliance_audit_finding` ADD CONSTRAINT `fk_compliance_compliance_audit_finding_dfmea_id` FOREIGN KEY (`dfmea_id`) REFERENCES `manufacturing_ecm`.`engineering`.`dfmea`(`dfmea_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`compliance_audit_finding` ADD CONSTRAINT `fk_compliance_compliance_audit_finding_pfmea_id` FOREIGN KEY (`pfmea_id`) REFERENCES `manufacturing_ecm`.`engineering`.`pfmea`(`pfmea_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_engineering_regulatory_certification_id` FOREIGN KEY (`engineering_regulatory_certification_id`) REFERENCES `manufacturing_ecm`.`engineering`.`engineering_regulatory_certification`(`engineering_regulatory_certification_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`regulatory_change` ADD CONSTRAINT `fk_compliance_regulatory_change_engineering_change_request_id` FOREIGN KEY (`engineering_change_request_id`) REFERENCES `manufacturing_ecm`.`engineering`.`engineering_change_request`(`engineering_change_request_id`);

-- ========= compliance --> hse (4 constraint(s)) =========
-- Requires: compliance schema, hse schema
ALTER TABLE `manufacturing_ecm`.`compliance`.`certification_audit` ADD CONSTRAINT `fk_compliance_certification_audit_safety_audit_id` FOREIGN KEY (`safety_audit_id`) REFERENCES `manufacturing_ecm`.`hse`.`safety_audit`(`safety_audit_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`rohs_compliance_record` ADD CONSTRAINT `fk_compliance_rohs_compliance_record_chemical_substance_id` FOREIGN KEY (`chemical_substance_id`) REFERENCES `manufacturing_ecm`.`hse`.`chemical_substance`(`chemical_substance_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`env_compliance_record` ADD CONSTRAINT `fk_compliance_env_compliance_record_emission_monitoring_id` FOREIGN KEY (`emission_monitoring_id`) REFERENCES `manufacturing_ecm`.`hse`.`emission_monitoring`(`emission_monitoring_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`env_compliance_record` ADD CONSTRAINT `fk_compliance_env_compliance_record_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `manufacturing_ecm`.`hse`.`environmental_permit`(`environmental_permit_id`);

-- ========= compliance --> logistics (3 constraint(s)) =========
-- Requires: compliance schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`third_party_risk` ADD CONSTRAINT `fk_compliance_third_party_risk_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`env_compliance_record` ADD CONSTRAINT `fk_compliance_env_compliance_record_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);

-- ========= compliance --> production (3 constraint(s)) =========
-- Requires: compliance schema, production schema
ALTER TABLE `manufacturing_ecm`.`compliance`.`compliance_audit_finding` ADD CONSTRAINT `fk_compliance_compliance_audit_finding_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`rohs_compliance_record` ADD CONSTRAINT `fk_compliance_rohs_compliance_record_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`evidence` ADD CONSTRAINT `fk_compliance_evidence_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);

-- ========= compliance --> quality (1 constraint(s)) =========
-- Requires: compliance schema, quality schema
ALTER TABLE `manufacturing_ecm`.`compliance`.`rohs_compliance_record` ADD CONSTRAINT `fk_compliance_rohs_compliance_record_certificate_id` FOREIGN KEY (`certificate_id`) REFERENCES `manufacturing_ecm`.`quality`.`certificate`(`certificate_id`);

-- ========= compliance --> service (4 constraint(s)) =========
-- Requires: compliance schema, service schema
ALTER TABLE `manufacturing_ecm`.`compliance`.`certification_audit` ADD CONSTRAINT `fk_compliance_certification_audit_report_id` FOREIGN KEY (`report_id`) REFERENCES `manufacturing_ecm`.`service`.`report`(`report_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`internal_audit` ADD CONSTRAINT `fk_compliance_internal_audit_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `manufacturing_ecm`.`service`.`service_territory`(`service_territory_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`policy_acknowledgment` ADD CONSTRAINT `fk_compliance_policy_acknowledgment_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `manufacturing_ecm`.`service`.`technician`(`technician_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`cybersecurity_incident` ADD CONSTRAINT `fk_compliance_cybersecurity_incident_remote_support_session_id` FOREIGN KEY (`remote_support_session_id`) REFERENCES `manufacturing_ecm`.`service`.`remote_support_session`(`remote_support_session_id`);

-- ========= compliance --> technology (4 constraint(s)) =========
-- Requires: compliance schema, technology schema
ALTER TABLE `manufacturing_ecm`.`compliance`.`cybersecurity_incident` ADD CONSTRAINT `fk_compliance_cybersecurity_incident_vulnerability_id` FOREIGN KEY (`vulnerability_id`) REFERENCES `manufacturing_ecm`.`technology`.`vulnerability`(`vulnerability_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`evidence` ADD CONSTRAINT `fk_compliance_evidence_service_ticket_id` FOREIGN KEY (`service_ticket_id`) REFERENCES `manufacturing_ecm`.`technology`.`service_ticket`(`service_ticket_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`third_party_risk` ADD CONSTRAINT `fk_compliance_third_party_risk_it_vendor_id` FOREIGN KEY (`it_vendor_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_vendor`(`it_vendor_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`audit_service_scope` ADD CONSTRAINT `fk_compliance_audit_service_scope_it_service_id` FOREIGN KEY (`it_service_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_service`(`it_service_id`);

-- ========= compliance --> workforce (60 constraint(s)) =========
-- Requires: compliance schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`obligation` ADD CONSTRAINT `fk_compliance_obligation_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`certification_audit` ADD CONSTRAINT `fk_compliance_certification_audit_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`certification_audit` ADD CONSTRAINT `fk_compliance_certification_audit_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`certification_audit` ADD CONSTRAINT `fk_compliance_certification_audit_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`certification_audit` ADD CONSTRAINT `fk_compliance_certification_audit_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`certification_audit` ADD CONSTRAINT `fk_compliance_certification_audit_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`internal_audit` ADD CONSTRAINT `fk_compliance_internal_audit_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`internal_audit` ADD CONSTRAINT `fk_compliance_internal_audit_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`internal_audit` ADD CONSTRAINT `fk_compliance_internal_audit_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`internal_audit` ADD CONSTRAINT `fk_compliance_internal_audit_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`compliance_audit_finding` ADD CONSTRAINT `fk_compliance_compliance_audit_finding_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`compliance_audit_finding` ADD CONSTRAINT `fk_compliance_compliance_audit_finding_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`compliance_audit_finding` ADD CONSTRAINT `fk_compliance_compliance_audit_finding_it_asset_id` FOREIGN KEY (`it_asset_id`) REFERENCES `manufacturing_ecm`.`workforce`.`it_asset`(`it_asset_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`compliance_audit_finding` ADD CONSTRAINT `fk_compliance_compliance_audit_finding_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`compliance_audit_finding` ADD CONSTRAINT `fk_compliance_compliance_audit_finding_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`compliance_audit_finding` ADD CONSTRAINT `fk_compliance_compliance_audit_finding_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`compliance_audit_finding` ADD CONSTRAINT `fk_compliance_compliance_audit_finding_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`regulatory_filing` ADD CONSTRAINT `fk_compliance_regulatory_filing_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`assessment` ADD CONSTRAINT `fk_compliance_assessment_capa_record_id` FOREIGN KEY (`capa_record_id`) REFERENCES `manufacturing_ecm`.`workforce`.`capa_record`(`capa_record_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`assessment` ADD CONSTRAINT `fk_compliance_assessment_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`assessment` ADD CONSTRAINT `fk_compliance_assessment_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`policy_acknowledgment` ADD CONSTRAINT `fk_compliance_policy_acknowledgment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`data_privacy_record` ADD CONSTRAINT `fk_compliance_data_privacy_record_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`data_privacy_record` ADD CONSTRAINT `fk_compliance_data_privacy_record_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`data_privacy_record` ADD CONSTRAINT `fk_compliance_data_privacy_record_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`data_subject_request` ADD CONSTRAINT `fk_compliance_data_subject_request_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`privacy_breach` ADD CONSTRAINT `fk_compliance_privacy_breach_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`cybersecurity_control` ADD CONSTRAINT `fk_compliance_cybersecurity_control_it_asset_id` FOREIGN KEY (`it_asset_id`) REFERENCES `manufacturing_ecm`.`workforce`.`it_asset`(`it_asset_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`cybersecurity_control` ADD CONSTRAINT `fk_compliance_cybersecurity_control_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`cybersecurity_incident` ADD CONSTRAINT `fk_compliance_cybersecurity_incident_it_asset_id` FOREIGN KEY (`it_asset_id`) REFERENCES `manufacturing_ecm`.`workforce`.`it_asset`(`it_asset_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`cybersecurity_incident` ADD CONSTRAINT `fk_compliance_cybersecurity_incident_capa_record_id` FOREIGN KEY (`capa_record_id`) REFERENCES `manufacturing_ecm`.`workforce`.`capa_record`(`capa_record_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`rohs_compliance_record` ADD CONSTRAINT `fk_compliance_rohs_compliance_record_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`rohs_compliance_record` ADD CONSTRAINT `fk_compliance_rohs_compliance_record_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`rohs_compliance_record` ADD CONSTRAINT `fk_compliance_rohs_compliance_record_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`training` ADD CONSTRAINT `fk_compliance_training_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`training` ADD CONSTRAINT `fk_compliance_training_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`exception` ADD CONSTRAINT `fk_compliance_exception_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`regulatory_change` ADD CONSTRAINT `fk_compliance_regulatory_change_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`evidence` ADD CONSTRAINT `fk_compliance_evidence_capa_record_id` FOREIGN KEY (`capa_record_id`) REFERENCES `manufacturing_ecm`.`workforce`.`capa_record`(`capa_record_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`evidence` ADD CONSTRAINT `fk_compliance_evidence_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`evidence` ADD CONSTRAINT `fk_compliance_evidence_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`third_party_risk` ADD CONSTRAINT `fk_compliance_third_party_risk_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`third_party_risk` ADD CONSTRAINT `fk_compliance_third_party_risk_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`third_party_risk` ADD CONSTRAINT `fk_compliance_third_party_risk_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`third_party_risk` ADD CONSTRAINT `fk_compliance_third_party_risk_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`env_compliance_record` ADD CONSTRAINT `fk_compliance_env_compliance_record_capa_record_id` FOREIGN KEY (`capa_record_id`) REFERENCES `manufacturing_ecm`.`workforce`.`capa_record`(`capa_record_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`env_compliance_record` ADD CONSTRAINT `fk_compliance_env_compliance_record_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`env_compliance_record` ADD CONSTRAINT `fk_compliance_env_compliance_record_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`env_compliance_record` ADD CONSTRAINT `fk_compliance_env_compliance_record_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`env_compliance_record` ADD CONSTRAINT `fk_compliance_env_compliance_record_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`env_compliance_record` ADD CONSTRAINT `fk_compliance_env_compliance_record_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`risk_register` ADD CONSTRAINT `fk_compliance_risk_register_capa_record_id` FOREIGN KEY (`capa_record_id`) REFERENCES `manufacturing_ecm`.`workforce`.`capa_record`(`capa_record_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`risk_register` ADD CONSTRAINT `fk_compliance_risk_register_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`policy_regulatory_mapping` ADD CONSTRAINT `fk_compliance_policy_regulatory_mapping_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`asset_compliance_requirement` ADD CONSTRAINT `fk_compliance_asset_compliance_requirement_it_asset_id` FOREIGN KEY (`it_asset_id`) REFERENCES `manufacturing_ecm`.`workforce`.`it_asset`(`it_asset_id`);
ALTER TABLE `manufacturing_ecm`.`compliance`.`asset_compliance_requirement` ADD CONSTRAINT `fk_compliance_asset_compliance_requirement_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);

-- ========= customer --> compliance (2 constraint(s)) =========
-- Requires: customer schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ADD CONSTRAINT `fk_customer_account_document_evidence_id` FOREIGN KEY (`evidence_id`) REFERENCES `manufacturing_ecm`.`compliance`.`evidence`(`evidence_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`consent_record` ADD CONSTRAINT `fk_customer_consent_record_data_subject_request_id` FOREIGN KEY (`data_subject_request_id`) REFERENCES `manufacturing_ecm`.`compliance`.`data_subject_request`(`data_subject_request_id`);

-- ========= customer --> engineering (2 constraint(s)) =========
-- Requires: customer schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ADD CONSTRAINT `fk_customer_customer_opportunity_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`engineering`.`product_variant`(`product_variant_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ADD CONSTRAINT `fk_customer_account_certification_requirement_engineering_regulatory_certification_id` FOREIGN KEY (`engineering_regulatory_certification_id`) REFERENCES `manufacturing_ecm`.`engineering`.`engineering_regulatory_certification`(`engineering_regulatory_certification_id`);

-- ========= customer --> finance (3 constraint(s)) =========
-- Requires: customer schema, finance schema
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ADD CONSTRAINT `fk_customer_credit_profile_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ADD CONSTRAINT `fk_customer_pricing_agreement_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`finance`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ADD CONSTRAINT `fk_customer_account_bank_detail_bank_account_id` FOREIGN KEY (`bank_account_id`) REFERENCES `manufacturing_ecm`.`finance`.`bank_account`(`bank_account_id`);

-- ========= customer --> hse (2 constraint(s)) =========
-- Requires: customer schema, hse schema
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_sds_id` FOREIGN KEY (`sds_id`) REFERENCES `manufacturing_ecm`.`hse`.`sds`(`sds_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ADD CONSTRAINT `fk_customer_account_chemical_approval_chemical_substance_id` FOREIGN KEY (`chemical_substance_id`) REFERENCES `manufacturing_ecm`.`hse`.`chemical_substance`(`chemical_substance_id`);

-- ========= customer --> inventory (2 constraint(s)) =========
-- Requires: customer schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`inventory`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`inventory`.`serialized_unit`(`serialized_unit_id`);

-- ========= customer --> logistics (2 constraint(s)) =========
-- Requires: customer schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ADD CONSTRAINT `fk_customer_preferred_carrier_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ADD CONSTRAINT `fk_customer_account_delivery_zone_transport_zone_id` FOREIGN KEY (`transport_zone_id`) REFERENCES `manufacturing_ecm`.`logistics`.`transport_zone`(`transport_zone_id`);

-- ========= customer --> product (2 constraint(s)) =========
-- Requires: customer schema, product schema
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ADD CONSTRAINT `fk_customer_sla_agreement_warranty_policy_id` FOREIGN KEY (`warranty_policy_id`) REFERENCES `manufacturing_ecm`.`product`.`warranty_policy`(`warranty_policy_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ADD CONSTRAINT `fk_customer_pricing_agreement_product_price_list_id` FOREIGN KEY (`product_price_list_id`) REFERENCES `manufacturing_ecm`.`product`.`product_price_list`(`product_price_list_id`);

-- ========= customer --> research (2 constraint(s)) =========
-- Requires: customer schema, research schema
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ADD CONSTRAINT `fk_customer_communication_preference_partner_id` FOREIGN KEY (`partner_id`) REFERENCES `manufacturing_ecm`.`research`.`partner`(`partner_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ADD CONSTRAINT `fk_customer_collaboration_collaboration_agreement_id` FOREIGN KEY (`collaboration_agreement_id`) REFERENCES `manufacturing_ecm`.`research`.`collaboration_agreement`(`collaboration_agreement_id`);

-- ========= customer --> sales (2 constraint(s)) =========
-- Requires: customer schema, sales schema
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ADD CONSTRAINT `fk_customer_campaign_enrollment_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `manufacturing_ecm`.`sales`.`campaign`(`campaign_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`campaign_enrollment` ADD CONSTRAINT `fk_customer_campaign_enrollment_sales_campaign_id` FOREIGN KEY (`sales_campaign_id`) REFERENCES `manufacturing_ecm`.`sales`.`campaign`(`campaign_id`);

-- ========= customer --> service (1 constraint(s)) =========
-- Requires: customer schema, service schema
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ADD CONSTRAINT `fk_customer_nps_response_nps_survey_id` FOREIGN KEY (`nps_survey_id`) REFERENCES `manufacturing_ecm`.`service`.`nps_survey`(`nps_survey_id`);

-- ========= customer --> technology (6 constraint(s)) =========
-- Requires: customer schema, technology schema
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ADD CONSTRAINT `fk_customer_sla_agreement_sla_definition_id` FOREIGN KEY (`sla_definition_id`) REFERENCES `manufacturing_ecm`.`technology`.`sla_definition`(`sla_definition_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_service_ticket_id` FOREIGN KEY (`service_ticket_id`) REFERENCES `manufacturing_ecm`.`technology`.`service_ticket`(`service_ticket_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ADD CONSTRAINT `fk_customer_account_contract_it_contract_id` FOREIGN KEY (`it_contract_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_contract`(`it_contract_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ADD CONSTRAINT `fk_customer_license_entitlement_software_license_id` FOREIGN KEY (`software_license_id`) REFERENCES `manufacturing_ecm`.`technology`.`software_license`(`software_license_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`contact_system_access` ADD CONSTRAINT `fk_customer_contact_system_access_user_access_request_id` FOREIGN KEY (`user_access_request_id`) REFERENCES `manufacturing_ecm`.`technology`.`user_access_request`(`user_access_request_id`);

-- ========= customer --> workforce (62 constraint(s)) =========
-- Requires: customer schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`customer`.`contact` ADD CONSTRAINT `fk_customer_contact_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ADD CONSTRAINT `fk_customer_account_hierarchy_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ADD CONSTRAINT `fk_customer_account_hierarchy_parent_account_id` FOREIGN KEY (`parent_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_hierarchy` ADD CONSTRAINT `fk_customer_account_hierarchy_root_account_id` FOREIGN KEY (`root_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ADD CONSTRAINT `fk_customer_credit_profile_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ADD CONSTRAINT `fk_customer_credit_profile_credit_analyst_employee_id` FOREIGN KEY (`credit_analyst_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`credit_profile` ADD CONSTRAINT `fk_customer_credit_profile_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`sla_agreement` ADD CONSTRAINT `fk_customer_sla_agreement_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`partner_function` ADD CONSTRAINT `fk_customer_partner_function_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_classification` ADD CONSTRAINT `fk_customer_account_classification_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`sales_area_assignment` ADD CONSTRAINT `fk_customer_sales_area_assignment_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`pricing_agreement` ADD CONSTRAINT `fk_customer_pricing_agreement_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`interaction` ADD CONSTRAINT `fk_customer_interaction_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ADD CONSTRAINT `fk_customer_customer_opportunity_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ADD CONSTRAINT `fk_customer_customer_opportunity_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_opportunity` ADD CONSTRAINT `fk_customer_customer_opportunity_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`case` ADD CONSTRAINT `fk_customer_case_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`nps_response` ADD CONSTRAINT `fk_customer_nps_response_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_document` ADD CONSTRAINT `fk_customer_account_document_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_bank_detail` ADD CONSTRAINT `fk_customer_account_bank_detail_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contact_role` ADD CONSTRAINT `fk_customer_account_contact_role_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_status_history` ADD CONSTRAINT `fk_customer_account_status_history_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`communication_preference` ADD CONSTRAINT `fk_customer_communication_preference_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ADD CONSTRAINT `fk_customer_account_team_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_team` ADD CONSTRAINT `fk_customer_account_team_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_asset_register_id` FOREIGN KEY (`asset_register_id`) REFERENCES `manufacturing_ecm`.`workforce`.`asset_register`(`asset_register_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_plm_product_catalog_item_id` FOREIGN KEY (`plm_product_catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`installed_base` ADD CONSTRAINT `fk_customer_installed_base_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ADD CONSTRAINT `fk_customer_account_payment_term_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_payment_term` ADD CONSTRAINT `fk_customer_account_payment_term_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ADD CONSTRAINT `fk_customer_customer_contract_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ADD CONSTRAINT `fk_customer_customer_contract_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`customer_contract` ADD CONSTRAINT `fk_customer_customer_contract_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`collaboration` ADD CONSTRAINT `fk_customer_collaboration_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ADD CONSTRAINT `fk_customer_account_regulatory_applicability_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_regulatory_applicability` ADD CONSTRAINT `fk_customer_account_regulatory_applicability_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`preferred_carrier` ADD CONSTRAINT `fk_customer_preferred_carrier_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_delivery_zone` ADD CONSTRAINT `fk_customer_account_delivery_zone_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_contract` ADD CONSTRAINT `fk_customer_account_contract_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`license_entitlement` ADD CONSTRAINT `fk_customer_license_entitlement_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ADD CONSTRAINT `fk_customer_approval_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`approval` ADD CONSTRAINT `fk_customer_approval_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ADD CONSTRAINT `fk_customer_approved_component_list_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`approved_component_list` ADD CONSTRAINT `fk_customer_approved_component_list_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_certification_requirement` ADD CONSTRAINT `fk_customer_account_certification_requirement_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`customer`.`account_chemical_approval` ADD CONSTRAINT `fk_customer_account_chemical_approval_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);

-- ========= engineering --> compliance (1 constraint(s)) =========
-- Requires: engineering schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`engineering`.`approved_manufacturer` ADD CONSTRAINT `fk_engineering_approved_manufacturer_third_party_risk_id` FOREIGN KEY (`third_party_risk_id`) REFERENCES `manufacturing_ecm`.`compliance`.`third_party_risk`(`third_party_risk_id`);

-- ========= engineering --> hse (3 constraint(s)) =========
-- Requires: engineering schema, hse schema
ALTER TABLE `manufacturing_ecm`.`engineering`.`dfmea` ADD CONSTRAINT `fk_engineering_dfmea_hazard_assessment_id` FOREIGN KEY (`hazard_assessment_id`) REFERENCES `manufacturing_ecm`.`hse`.`hazard_assessment`(`hazard_assessment_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`pfmea` ADD CONSTRAINT `fk_engineering_pfmea_hazard_assessment_id` FOREIGN KEY (`hazard_assessment_id`) REFERENCES `manufacturing_ecm`.`hse`.`hazard_assessment`(`hazard_assessment_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`design_validation_test` ADD CONSTRAINT `fk_engineering_design_validation_test_safety_audit_id` FOREIGN KEY (`safety_audit_id`) REFERENCES `manufacturing_ecm`.`hse`.`safety_audit`(`safety_audit_id`);

-- ========= engineering --> logistics (2 constraint(s)) =========
-- Requires: engineering schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`engineering`.`tooling_equipment` ADD CONSTRAINT `fk_engineering_tooling_equipment_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`logistics`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`component_carrier_qualification` ADD CONSTRAINT `fk_engineering_component_carrier_qualification_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);

-- ========= engineering --> procurement (1 constraint(s)) =========
-- Requires: engineering schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`engineering`.`component_carrier_qualification` ADD CONSTRAINT `fk_engineering_component_carrier_qualification_supplier_qualification_id` FOREIGN KEY (`supplier_qualification_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier_qualification`(`supplier_qualification_id`);

-- ========= engineering --> quality (6 constraint(s)) =========
-- Requires: engineering schema, quality schema
ALTER TABLE `manufacturing_ecm`.`engineering`.`change_affected_item` ADD CONSTRAINT `fk_engineering_change_affected_item_inspection_plan_id` FOREIGN KEY (`inspection_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_plan`(`inspection_plan_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`dfmea` ADD CONSTRAINT `fk_engineering_dfmea_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `manufacturing_ecm`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`pfmea` ADD CONSTRAINT `fk_engineering_pfmea_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `manufacturing_ecm`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`engineering_prototype` ADD CONSTRAINT `fk_engineering_engineering_prototype_apqp_project_id` FOREIGN KEY (`apqp_project_id`) REFERENCES `manufacturing_ecm`.`quality`.`apqp_project`(`apqp_project_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`design_validation_test` ADD CONSTRAINT `fk_engineering_design_validation_test_apqp_project_id` FOREIGN KEY (`apqp_project_id`) REFERENCES `manufacturing_ecm`.`quality`.`apqp_project`(`apqp_project_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`component_measurement_plan` ADD CONSTRAINT `fk_engineering_component_measurement_plan_gauge_id` FOREIGN KEY (`gauge_id`) REFERENCES `manufacturing_ecm`.`quality`.`gauge`(`gauge_id`);

-- ========= engineering --> research (1 constraint(s)) =========
-- Requires: engineering schema, research schema
ALTER TABLE `manufacturing_ecm`.`engineering`.`dfmea` ADD CONSTRAINT `fk_engineering_dfmea_rd_risk_id` FOREIGN KEY (`rd_risk_id`) REFERENCES `manufacturing_ecm`.`research`.`rd_risk`(`rd_risk_id`);

-- ========= engineering --> service (1 constraint(s)) =========
-- Requires: engineering schema, service schema
ALTER TABLE `manufacturing_ecm`.`engineering`.`dfmea` ADD CONSTRAINT `fk_engineering_dfmea_feedback_id` FOREIGN KEY (`feedback_id`) REFERENCES `manufacturing_ecm`.`service`.`feedback`(`feedback_id`);

-- ========= engineering --> technology (1 constraint(s)) =========
-- Requires: engineering schema, technology schema
ALTER TABLE `manufacturing_ecm`.`engineering`.`project` ADD CONSTRAINT `fk_engineering_project_it_project_id` FOREIGN KEY (`it_project_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_project`(`it_project_id`);

-- ========= engineering --> workforce (64 constraint(s)) =========
-- Requires: engineering schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`engineering`.`engineering_bom` ADD CONSTRAINT `fk_engineering_engineering_bom_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`bom_line` ADD CONSTRAINT `fk_engineering_bom_line_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`bom_line` ADD CONSTRAINT `fk_engineering_bom_line_parent_material_component_id` FOREIGN KEY (`parent_material_component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`bop` ADD CONSTRAINT `fk_engineering_bop_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`bop_operation` ADD CONSTRAINT `fk_engineering_bop_operation_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`bop_operation` ADD CONSTRAINT `fk_engineering_bop_operation_skill_id` FOREIGN KEY (`skill_id`) REFERENCES `manufacturing_ecm`.`workforce`.`skill`(`skill_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`cad_model` ADD CONSTRAINT `fk_engineering_cad_model_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`cad_model` ADD CONSTRAINT `fk_engineering_cad_model_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`drawing` ADD CONSTRAINT `fk_engineering_drawing_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`ecn` ADD CONSTRAINT `fk_engineering_ecn_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`ecn` ADD CONSTRAINT `fk_engineering_ecn_initiator_employee_id` FOREIGN KEY (`initiator_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`eco` ADD CONSTRAINT `fk_engineering_eco_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`change_affected_item` ADD CONSTRAINT `fk_engineering_change_affected_item_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`change_affected_item` ADD CONSTRAINT `fk_engineering_change_affected_item_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`dfmea` ADD CONSTRAINT `fk_engineering_dfmea_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`pfmea` ADD CONSTRAINT `fk_engineering_pfmea_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`engineering_prototype` ADD CONSTRAINT `fk_engineering_engineering_prototype_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`engineering_prototype` ADD CONSTRAINT `fk_engineering_engineering_prototype_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`engineering_prototype` ADD CONSTRAINT `fk_engineering_engineering_prototype_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`engineering_prototype` ADD CONSTRAINT `fk_engineering_engineering_prototype_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`internal_order`(`internal_order_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`engineering_prototype` ADD CONSTRAINT `fk_engineering_engineering_prototype_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`design_validation_test` ADD CONSTRAINT `fk_engineering_design_validation_test_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`design_validation_test` ADD CONSTRAINT `fk_engineering_design_validation_test_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`internal_order`(`internal_order_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`design_validation_test` ADD CONSTRAINT `fk_engineering_design_validation_test_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`design_validation_test` ADD CONSTRAINT `fk_engineering_design_validation_test_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`product_specification` ADD CONSTRAINT `fk_engineering_product_specification_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`approved_manufacturer` ADD CONSTRAINT `fk_engineering_approved_manufacturer_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`approved_manufacturer` ADD CONSTRAINT `fk_engineering_approved_manufacturer_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`approved_manufacturer` ADD CONSTRAINT `fk_engineering_approved_manufacturer_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`design_review` ADD CONSTRAINT `fk_engineering_design_review_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`design_review` ADD CONSTRAINT `fk_engineering_design_review_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`design_review` ADD CONSTRAINT `fk_engineering_design_review_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`design_review_action` ADD CONSTRAINT `fk_engineering_design_review_action_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`design_review_action` ADD CONSTRAINT `fk_engineering_design_review_action_owner_employee_id` FOREIGN KEY (`owner_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`design_review_action` ADD CONSTRAINT `fk_engineering_design_review_action_raised_by_employee_id` FOREIGN KEY (`raised_by_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`project` ADD CONSTRAINT `fk_engineering_project_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`project` ADD CONSTRAINT `fk_engineering_project_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`project` ADD CONSTRAINT `fk_engineering_project_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`internal_order`(`internal_order_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`project` ADD CONSTRAINT `fk_engineering_project_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`project` ADD CONSTRAINT `fk_engineering_project_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`engineering_change_request` ADD CONSTRAINT `fk_engineering_engineering_change_request_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`product_variant` ADD CONSTRAINT `fk_engineering_product_variant_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`product_variant` ADD CONSTRAINT `fk_engineering_product_variant_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`substitute_component` ADD CONSTRAINT `fk_engineering_substitute_component_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`tooling_equipment` ADD CONSTRAINT `fk_engineering_tooling_equipment_asset_register_id` FOREIGN KEY (`asset_register_id`) REFERENCES `manufacturing_ecm`.`workforce`.`asset_register`(`asset_register_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`tooling_equipment` ADD CONSTRAINT `fk_engineering_tooling_equipment_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`tooling_equipment` ADD CONSTRAINT `fk_engineering_tooling_equipment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`tooling_equipment` ADD CONSTRAINT `fk_engineering_tooling_equipment_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`tooling_equipment` ADD CONSTRAINT `fk_engineering_tooling_equipment_it_asset_id` FOREIGN KEY (`it_asset_id`) REFERENCES `manufacturing_ecm`.`workforce`.`it_asset`(`it_asset_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`tooling_equipment` ADD CONSTRAINT `fk_engineering_tooling_equipment_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`tooling_equipment` ADD CONSTRAINT `fk_engineering_tooling_equipment_certification_id` FOREIGN KEY (`certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`certification`(`certification_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`engineering_regulatory_certification` ADD CONSTRAINT `fk_engineering_engineering_regulatory_certification_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`engineering_regulatory_certification` ADD CONSTRAINT `fk_engineering_engineering_regulatory_certification_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`component_revision` ADD CONSTRAINT `fk_engineering_component_revision_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`component_carrier_qualification` ADD CONSTRAINT `fk_engineering_component_carrier_qualification_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`component_certification` ADD CONSTRAINT `fk_engineering_component_certification_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`component_evaluation` ADD CONSTRAINT `fk_engineering_component_evaluation_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`component_evaluation` ADD CONSTRAINT `fk_engineering_component_evaluation_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`component_measurement_plan` ADD CONSTRAINT `fk_engineering_component_measurement_plan_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`component_compliance` ADD CONSTRAINT `fk_engineering_component_compliance_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`component_compliance` ADD CONSTRAINT `fk_engineering_component_compliance_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`component_compliance` ADD CONSTRAINT `fk_engineering_component_compliance_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`test_requirement_verification` ADD CONSTRAINT `fk_engineering_test_requirement_verification_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`engineering`.`specification_compliance_mapping` ADD CONSTRAINT `fk_engineering_specification_compliance_mapping_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);

-- ========= finance --> billing (2 constraint(s)) =========
-- Requires: finance schema, billing schema
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_run_id` FOREIGN KEY (`run_id`) REFERENCES `manufacturing_ecm`.`billing`.`run`(`run_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_run_id` FOREIGN KEY (`run_id`) REFERENCES `manufacturing_ecm`.`billing`.`run`(`run_id`);

-- ========= finance --> compliance (2 constraint(s)) =========
-- Requires: finance schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `manufacturing_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_internal_audit_id` FOREIGN KEY (`internal_audit_id`) REFERENCES `manufacturing_ecm`.`compliance`.`internal_audit`(`internal_audit_id`);

-- ========= finance --> engineering (3 constraint(s)) =========
-- Requires: finance schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_project_id` FOREIGN KEY (`project_id`) REFERENCES `manufacturing_ecm`.`engineering`.`project`(`project_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ADD CONSTRAINT `fk_finance_production_order_cost_bop_id` FOREIGN KEY (`bop_id`) REFERENCES `manufacturing_ecm`.`engineering`.`bop`(`bop_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ADD CONSTRAINT `fk_finance_production_order_cost_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`engineering`.`engineering_bom`(`engineering_bom_id`);

-- ========= finance --> hse (1 constraint(s)) =========
-- Requires: finance schema, hse schema
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_objective_id` FOREIGN KEY (`objective_id`) REFERENCES `manufacturing_ecm`.`hse`.`objective`(`objective_id`);

-- ========= finance --> procurement (1 constraint(s)) =========
-- Requires: finance schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_procurement_spend_category_id` FOREIGN KEY (`procurement_spend_category_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_spend_category`(`procurement_spend_category_id`);

-- ========= finance --> product (1 constraint(s)) =========
-- Requires: finance schema, product schema
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ADD CONSTRAINT `fk_finance_profitability_segment_category_id` FOREIGN KEY (`category_id`) REFERENCES `manufacturing_ecm`.`product`.`category`(`category_id`);

-- ========= finance --> production (1 constraint(s)) =========
-- Requires: finance schema, production schema
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ADD CONSTRAINT `fk_finance_product_cost_estimate_version_id` FOREIGN KEY (`version_id`) REFERENCES `manufacturing_ecm`.`production`.`version`(`version_id`);

-- ========= finance --> quality (1 constraint(s)) =========
-- Requires: finance schema, quality schema
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ADD CONSTRAINT `fk_finance_production_order_cost_scrap_rework_transaction_id` FOREIGN KEY (`scrap_rework_transaction_id`) REFERENCES `manufacturing_ecm`.`quality`.`scrap_rework_transaction`(`scrap_rework_transaction_id`);

-- ========= finance --> sales (2 constraint(s)) =========
-- Requires: finance schema, sales schema
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`sales`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ADD CONSTRAINT `fk_finance_copa_posting_team_id` FOREIGN KEY (`team_id`) REFERENCES `manufacturing_ecm`.`sales`.`team`(`team_id`);

-- ========= finance --> technology (3 constraint(s)) =========
-- Requires: finance schema, technology schema
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_it_vendor_id` FOREIGN KEY (`it_vendor_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_vendor`(`it_vendor_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_it_budget_id` FOREIGN KEY (`it_budget_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_budget`(`it_budget_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_it_service_id` FOREIGN KEY (`it_service_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_service`(`it_service_id`);

-- ========= finance --> workforce (82 constraint(s)) =========
-- Requires: finance schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ar_invoice` ADD CONSTRAINT `fk_finance_ar_invoice_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`payment` ADD CONSTRAINT `fk_finance_payment_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ADD CONSTRAINT `fk_finance_bank_account_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`bank_account` ADD CONSTRAINT `fk_finance_bank_account_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_asset_register_id` FOREIGN KEY (`asset_register_id`) REFERENCES `manufacturing_ecm`.`workforce`.`asset_register`(`asset_register_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_it_asset_id` FOREIGN KEY (`it_asset_id`) REFERENCES `manufacturing_ecm`.`workforce`.`it_asset`(`it_asset_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ADD CONSTRAINT `fk_finance_budget_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ADD CONSTRAINT `fk_finance_budget_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ADD CONSTRAINT `fk_finance_budget_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ADD CONSTRAINT `fk_finance_budget_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget` ADD CONSTRAINT `fk_finance_budget_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`internal_order`(`internal_order_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`internal_order`(`internal_order_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ADD CONSTRAINT `fk_finance_product_cost_estimate_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ADD CONSTRAINT `fk_finance_product_cost_estimate_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ADD CONSTRAINT `fk_finance_product_cost_estimate_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`product_cost_estimate` ADD CONSTRAINT `fk_finance_product_cost_estimate_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ADD CONSTRAINT `fk_finance_production_order_cost_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ADD CONSTRAINT `fk_finance_production_order_cost_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ADD CONSTRAINT `fk_finance_production_order_cost_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ADD CONSTRAINT `fk_finance_production_order_cost_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ADD CONSTRAINT `fk_finance_production_order_cost_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`production_order_cost` ADD CONSTRAINT `fk_finance_production_order_cost_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ADD CONSTRAINT `fk_finance_profitability_segment_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`profitability_segment` ADD CONSTRAINT `fk_finance_profitability_segment_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ADD CONSTRAINT `fk_finance_copa_posting_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ADD CONSTRAINT `fk_finance_copa_posting_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ADD CONSTRAINT `fk_finance_copa_posting_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ADD CONSTRAINT `fk_finance_copa_posting_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ADD CONSTRAINT `fk_finance_copa_posting_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`copa_posting` ADD CONSTRAINT `fk_finance_copa_posting_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`currency_exchange_rate` ADD CONSTRAINT `fk_finance_currency_exchange_rate_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ADD CONSTRAINT `fk_finance_tax_code_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`tax_code` ADD CONSTRAINT `fk_finance_tax_code_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`statement_version` ADD CONSTRAINT `fk_finance_statement_version_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ADD CONSTRAINT `fk_finance_period_close_activity_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ADD CONSTRAINT `fk_finance_period_close_activity_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`period_close_activity` ADD CONSTRAINT `fk_finance_period_close_activity_signoff_user_employee_id` FOREIGN KEY (`signoff_user_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_pool` ADD CONSTRAINT `fk_finance_cash_pool_business_unit_id` FOREIGN KEY (`business_unit_id`) REFERENCES `manufacturing_ecm`.`workforce`.`business_unit`(`business_unit_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`cash_pool` ADD CONSTRAINT `fk_finance_cash_pool_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ledger` ADD CONSTRAINT `fk_finance_ledger_business_unit_id` FOREIGN KEY (`business_unit_id`) REFERENCES `manufacturing_ecm`.`workforce`.`business_unit`(`business_unit_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ledger` ADD CONSTRAINT `fk_finance_ledger_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`finance`.`ledger` ADD CONSTRAINT `fk_finance_ledger_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);

-- ========= hse --> asset (2 constraint(s)) =========
-- Requires: hse schema, asset schema
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ADD CONSTRAINT `fk_hse_emission_monitoring_measurement_point_id` FOREIGN KEY (`measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ADD CONSTRAINT `fk_hse_energy_consumption_measurement_point_id` FOREIGN KEY (`measurement_point_id`) REFERENCES `manufacturing_ecm`.`asset`.`measurement_point`(`measurement_point_id`);

-- ========= hse --> compliance (3 constraint(s)) =========
-- Requires: hse schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ADD CONSTRAINT `fk_hse_environmental_permit_regulatory_filing_id` FOREIGN KEY (`regulatory_filing_id`) REFERENCES `manufacturing_ecm`.`compliance`.`regulatory_filing`(`regulatory_filing_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ADD CONSTRAINT `fk_hse_compliance_evaluation_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `manufacturing_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ADD CONSTRAINT `fk_hse_contractor_qualification_third_party_risk_id` FOREIGN KEY (`third_party_risk_id`) REFERENCES `manufacturing_ecm`.`compliance`.`third_party_risk`(`third_party_risk_id`);

-- ========= hse --> engineering (7 constraint(s)) =========
-- Requires: hse schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_tooling_equipment_id` FOREIGN KEY (`tooling_equipment_id`) REFERENCES `manufacturing_ecm`.`engineering`.`tooling_equipment`(`tooling_equipment_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ADD CONSTRAINT `fk_hse_hse_capa_eco_id` FOREIGN KEY (`eco_id`) REFERENCES `manufacturing_ecm`.`engineering`.`eco`(`eco_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ADD CONSTRAINT `fk_hse_chemical_substance_material_specification_id` FOREIGN KEY (`material_specification_id`) REFERENCES `manufacturing_ecm`.`engineering`.`material_specification`(`material_specification_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ADD CONSTRAINT `fk_hse_ppe_requirement_bop_operation_id` FOREIGN KEY (`bop_operation_id`) REFERENCES `manufacturing_ecm`.`engineering`.`bop_operation`(`bop_operation_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ADD CONSTRAINT `fk_hse_environmental_aspect_bop_operation_id` FOREIGN KEY (`bop_operation_id`) REFERENCES `manufacturing_ecm`.`engineering`.`bop_operation`(`bop_operation_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ADD CONSTRAINT `fk_hse_management_of_change_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`engineering`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ADD CONSTRAINT `fk_hse_management_of_change_eco_id` FOREIGN KEY (`eco_id`) REFERENCES `manufacturing_ecm`.`engineering`.`eco`(`eco_id`);

-- ========= hse --> inventory (4 constraint(s)) =========
-- Requires: hse schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ADD CONSTRAINT `fk_hse_hazard_assessment_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ADD CONSTRAINT `fk_hse_chemical_inventory_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ADD CONSTRAINT `fk_hse_ppe_requirement_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`inventory`.`storage_location`(`storage_location_id`);

-- ========= hse --> order (2 constraint(s)) =========
-- Requires: hse schema, order schema
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ADD CONSTRAINT `fk_hse_hazard_assessment_order_configuration_id` FOREIGN KEY (`order_configuration_id`) REFERENCES `manufacturing_ecm`.`order`.`order_configuration`(`order_configuration_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ADD CONSTRAINT `fk_hse_management_of_change_order_configuration_id` FOREIGN KEY (`order_configuration_id`) REFERENCES `manufacturing_ecm`.`order`.`order_configuration`(`order_configuration_id`);

-- ========= hse --> procurement (1 constraint(s)) =========
-- Requires: hse schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_procurement_inbound_delivery_id` FOREIGN KEY (`procurement_inbound_delivery_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery`(`procurement_inbound_delivery_id`);

-- ========= hse --> product (1 constraint(s)) =========
-- Requires: hse schema, product schema
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ADD CONSTRAINT `fk_hse_management_of_change_change_notice_id` FOREIGN KEY (`change_notice_id`) REFERENCES `manufacturing_ecm`.`product`.`change_notice`(`change_notice_id`);

-- ========= hse --> production (3 constraint(s)) =========
-- Requires: hse schema, production schema
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ADD CONSTRAINT `fk_hse_hazard_assessment_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ADD CONSTRAINT `fk_hse_ppe_requirement_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);

-- ========= hse --> quality (1 constraint(s)) =========
-- Requires: hse schema, quality schema
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);

-- ========= hse --> research (1 constraint(s)) =========
-- Requires: hse schema, research schema
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_lab_resource_id` FOREIGN KEY (`lab_resource_id`) REFERENCES `manufacturing_ecm`.`research`.`lab_resource`(`lab_resource_id`);

-- ========= hse --> service (3 constraint(s)) =========
-- Requires: hse schema, service schema
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ADD CONSTRAINT `fk_hse_hse_capa_report_id` FOREIGN KEY (`report_id`) REFERENCES `manufacturing_ecm`.`service`.`report`(`report_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ADD CONSTRAINT `fk_hse_safety_training_knowledge_article_id` FOREIGN KEY (`knowledge_article_id`) REFERENCES `manufacturing_ecm`.`service`.`knowledge_article`(`knowledge_article_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ADD CONSTRAINT `fk_hse_emergency_response_plan_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `manufacturing_ecm`.`service`.`service_territory`(`service_territory_id`);

-- ========= hse --> technology (1 constraint(s)) =========
-- Requires: hse schema, technology schema
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ADD CONSTRAINT `fk_hse_management_of_change_technology_change_request_id` FOREIGN KEY (`technology_change_request_id`) REFERENCES `manufacturing_ecm`.`technology`.`technology_change_request`(`technology_change_request_id`);

-- ========= hse --> workforce (81 constraint(s)) =========
-- Requires: hse schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`incident` ADD CONSTRAINT `fk_hse_incident_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ADD CONSTRAINT `fk_hse_incident_investigation_capa_record_id` FOREIGN KEY (`capa_record_id`) REFERENCES `manufacturing_ecm`.`workforce`.`capa_record`(`capa_record_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`incident_investigation` ADD CONSTRAINT `fk_hse_incident_investigation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ADD CONSTRAINT `fk_hse_hse_capa_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ADD CONSTRAINT `fk_hse_hse_capa_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`internal_order`(`internal_order_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ADD CONSTRAINT `fk_hse_hse_capa_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_capa` ADD CONSTRAINT `fk_hse_hse_capa_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ADD CONSTRAINT `fk_hse_hazard_assessment_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ADD CONSTRAINT `fk_hse_hazard_assessment_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ADD CONSTRAINT `fk_hse_hazard_assessment_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hazard_assessment` ADD CONSTRAINT `fk_hse_hazard_assessment_line_id` FOREIGN KEY (`line_id`) REFERENCES `manufacturing_ecm`.`workforce`.`line`(`line_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ADD CONSTRAINT `fk_hse_safety_audit_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ADD CONSTRAINT `fk_hse_safety_audit_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_audit` ADD CONSTRAINT `fk_hse_safety_audit_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ADD CONSTRAINT `fk_hse_hse_audit_finding_capa_record_id` FOREIGN KEY (`capa_record_id`) REFERENCES `manufacturing_ecm`.`workforce`.`capa_record`(`capa_record_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_audit_finding` ADD CONSTRAINT `fk_hse_hse_audit_finding_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_substance` ADD CONSTRAINT `fk_hse_chemical_substance_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ADD CONSTRAINT `fk_hse_chemical_inventory_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ADD CONSTRAINT `fk_hse_chemical_inventory_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_inventory` ADD CONSTRAINT `fk_hse_chemical_inventory_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`sds` ADD CONSTRAINT `fk_hse_sds_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ADD CONSTRAINT `fk_hse_environmental_permit_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ADD CONSTRAINT `fk_hse_environmental_permit_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_permit` ADD CONSTRAINT `fk_hse_environmental_permit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ADD CONSTRAINT `fk_hse_emission_monitoring_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ADD CONSTRAINT `fk_hse_emission_monitoring_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ADD CONSTRAINT `fk_hse_emission_monitoring_instrument_equipment_id` FOREIGN KEY (`instrument_equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ADD CONSTRAINT `fk_hse_emission_monitoring_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ADD CONSTRAINT `fk_hse_emission_monitoring_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emission_monitoring` ADD CONSTRAINT `fk_hse_emission_monitoring_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ADD CONSTRAINT `fk_hse_waste_record_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ADD CONSTRAINT `fk_hse_waste_record_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ADD CONSTRAINT `fk_hse_waste_record_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ADD CONSTRAINT `fk_hse_waste_record_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ADD CONSTRAINT `fk_hse_waste_record_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`waste_record` ADD CONSTRAINT `fk_hse_waste_record_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ADD CONSTRAINT `fk_hse_energy_consumption_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ADD CONSTRAINT `fk_hse_energy_consumption_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ADD CONSTRAINT `fk_hse_energy_consumption_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ADD CONSTRAINT `fk_hse_energy_consumption_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ADD CONSTRAINT `fk_hse_energy_consumption_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_consumption` ADD CONSTRAINT `fk_hse_energy_consumption_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`energy_target` ADD CONSTRAINT `fk_hse_energy_target_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ADD CONSTRAINT `fk_hse_regulatory_obligation_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ADD CONSTRAINT `fk_hse_regulatory_obligation_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`regulatory_obligation` ADD CONSTRAINT `fk_hse_regulatory_obligation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`compliance_evaluation` ADD CONSTRAINT `fk_hse_compliance_evaluation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ADD CONSTRAINT `fk_hse_safety_training_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`safety_training` ADD CONSTRAINT `fk_hse_safety_training_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`training_attendance` ADD CONSTRAINT `fk_hse_training_attendance_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`ppe_requirement` ADD CONSTRAINT `fk_hse_ppe_requirement_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ADD CONSTRAINT `fk_hse_hygiene_monitoring_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ADD CONSTRAINT `fk_hse_hygiene_monitoring_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hygiene_monitoring` ADD CONSTRAINT `fk_hse_hygiene_monitoring_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ADD CONSTRAINT `fk_hse_emergency_response_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ADD CONSTRAINT `fk_hse_emergency_response_plan_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_response_plan` ADD CONSTRAINT `fk_hse_emergency_response_plan_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ADD CONSTRAINT `fk_hse_emergency_drill_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`emergency_drill` ADD CONSTRAINT `fk_hse_emergency_drill_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`environmental_aspect` ADD CONSTRAINT `fk_hse_environmental_aspect_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration` ADD CONSTRAINT `fk_hse_hse_reach_substance_declaration_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`objective` ADD CONSTRAINT `fk_hse_objective_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ADD CONSTRAINT `fk_hse_management_of_change_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ADD CONSTRAINT `fk_hse_management_of_change_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ADD CONSTRAINT `fk_hse_management_of_change_line_id` FOREIGN KEY (`line_id`) REFERENCES `manufacturing_ecm`.`workforce`.`line`(`line_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`management_of_change` ADD CONSTRAINT `fk_hse_management_of_change_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ADD CONSTRAINT `fk_hse_contractor_qualification_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ADD CONSTRAINT `fk_hse_contractor_qualification_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`contractor_qualification` ADD CONSTRAINT `fk_hse_contractor_qualification_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ADD CONSTRAINT `fk_hse_ghg_emission_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ADD CONSTRAINT `fk_hse_ghg_emission_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`ghg_emission` ADD CONSTRAINT `fk_hse_ghg_emission_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`hse`.`chemical_regulatory_compliance` ADD CONSTRAINT `fk_hse_chemical_regulatory_compliance_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);

-- ========= inventory --> billing (2 constraint(s)) =========
-- Requires: inventory schema, billing schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_run_id` FOREIGN KEY (`run_id`) REFERENCES `manufacturing_ecm`.`billing`.`run`(`run_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`consignment_stock` ADD CONSTRAINT `fk_inventory_consignment_stock_plan_id` FOREIGN KEY (`plan_id`) REFERENCES `manufacturing_ecm`.`billing`.`plan`(`plan_id`);

-- ========= inventory --> compliance (1 constraint(s)) =========
-- Requires: inventory schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_compliance_audit_finding_id` FOREIGN KEY (`compliance_audit_finding_id`) REFERENCES `manufacturing_ecm`.`compliance`.`compliance_audit_finding`(`compliance_audit_finding_id`);

-- ========= inventory --> customer (1 constraint(s)) =========
-- Requires: inventory schema, customer schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`sku_pricing` ADD CONSTRAINT `fk_inventory_sku_pricing_pricing_agreement_id` FOREIGN KEY (`pricing_agreement_id`) REFERENCES `manufacturing_ecm`.`customer`.`pricing_agreement`(`pricing_agreement_id`);

-- ========= inventory --> finance (3 constraint(s)) =========
-- Requires: inventory schema, finance schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_production_order_cost_id` FOREIGN KEY (`production_order_cost_id`) REFERENCES `manufacturing_ecm`.`finance`.`production_order_cost`(`production_order_cost_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`snapshot` ADD CONSTRAINT `fk_inventory_snapshot_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);

-- ========= inventory --> hse (1 constraint(s)) =========
-- Requires: inventory schema, hse schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_incident_id` FOREIGN KEY (`incident_id`) REFERENCES `manufacturing_ecm`.`hse`.`incident`(`incident_id`);

-- ========= inventory --> logistics (3 constraint(s)) =========
-- Requires: inventory schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_logistics_inbound_delivery_id` FOREIGN KEY (`logistics_inbound_delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery`(`logistics_inbound_delivery_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_logistics_inbound_delivery_id` FOREIGN KEY (`logistics_inbound_delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery`(`logistics_inbound_delivery_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`warehouse_carrier_agreement` ADD CONSTRAINT `fk_inventory_warehouse_carrier_agreement_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);

-- ========= inventory --> procurement (1 constraint(s)) =========
-- Requires: inventory schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_procurement_purchase_requisition_id` FOREIGN KEY (`procurement_purchase_requisition_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition`(`procurement_purchase_requisition_id`);

-- ========= inventory --> research (1 constraint(s)) =========
-- Requires: inventory schema, research schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_rd_test_plan_id` FOREIGN KEY (`rd_test_plan_id`) REFERENCES `manufacturing_ecm`.`research`.`rd_test_plan`(`rd_test_plan_id`);

-- ========= inventory --> sales (1 constraint(s)) =========
-- Requires: inventory schema, sales schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_sales_price_list_id` FOREIGN KEY (`sales_price_list_id`) REFERENCES `manufacturing_ecm`.`sales`.`sales_price_list`(`sales_price_list_id`);

-- ========= inventory --> technology (1 constraint(s)) =========
-- Requires: inventory schema, technology schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_iiot_platform_id` FOREIGN KEY (`iiot_platform_id`) REFERENCES `manufacturing_ecm`.`technology`.`iiot_platform`(`iiot_platform_id`);

-- ========= inventory --> workforce (96 constraint(s)) =========
-- Requires: inventory schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_position` ADD CONSTRAINT `fk_inventory_stock_position_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`storage_location` ADD CONSTRAINT `fk_inventory_storage_location_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`transaction` ADD CONSTRAINT `fk_inventory_transaction_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`transaction` ADD CONSTRAINT `fk_inventory_transaction_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`transaction` ADD CONSTRAINT `fk_inventory_transaction_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`transaction` ADD CONSTRAINT `fk_inventory_transaction_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`transaction` ADD CONSTRAINT `fk_inventory_transaction_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`transaction` ADD CONSTRAINT `fk_inventory_transaction_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`transaction` ADD CONSTRAINT `fk_inventory_transaction_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_transfer` ADD CONSTRAINT `fk_inventory_stock_transfer_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_supervisor_employee_id` FOREIGN KEY (`supervisor_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`cycle_count` ADD CONSTRAINT `fk_inventory_cycle_count_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`cycle_count_result` ADD CONSTRAINT `fk_inventory_cycle_count_result_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`cycle_count_result` ADD CONSTRAINT `fk_inventory_cycle_count_result_counter_employee_id` FOREIGN KEY (`counter_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`cycle_count_result` ADD CONSTRAINT `fk_inventory_cycle_count_result_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`cycle_count_result` ADD CONSTRAINT `fk_inventory_cycle_count_result_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_adjustment` ADD CONSTRAINT `fk_inventory_stock_adjustment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_adjustment` ADD CONSTRAINT `fk_inventory_stock_adjustment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_adjustment` ADD CONSTRAINT `fk_inventory_stock_adjustment_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_adjustment` ADD CONSTRAINT `fk_inventory_stock_adjustment_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`stock_adjustment` ADD CONSTRAINT `fk_inventory_stock_adjustment_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`lot_batch` ADD CONSTRAINT `fk_inventory_lot_batch_compliance_reach_substance_declaration_id` FOREIGN KEY (`compliance_reach_substance_declaration_id`) REFERENCES `manufacturing_ecm`.`workforce`.`compliance_reach_substance_declaration`(`compliance_reach_substance_declaration_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`lot_batch` ADD CONSTRAINT `fk_inventory_lot_batch_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`lot_batch` ADD CONSTRAINT `fk_inventory_lot_batch_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`lot_batch` ADD CONSTRAINT `fk_inventory_lot_batch_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`reorder_policy` ADD CONSTRAINT `fk_inventory_reorder_policy_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_created_by_employee_id` FOREIGN KEY (`created_by_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`replenishment_order` ADD CONSTRAINT `fk_inventory_replenishment_order_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`putaway_task` ADD CONSTRAINT `fk_inventory_putaway_task_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`putaway_task` ADD CONSTRAINT `fk_inventory_putaway_task_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`putaway_task` ADD CONSTRAINT `fk_inventory_putaway_task_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`putaway_task` ADD CONSTRAINT `fk_inventory_putaway_task_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`pick_task` ADD CONSTRAINT `fk_inventory_pick_task_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`pick_task` ADD CONSTRAINT `fk_inventory_pick_task_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`pick_task` ADD CONSTRAINT `fk_inventory_pick_task_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`pick_task` ADD CONSTRAINT `fk_inventory_pick_task_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`abc_classification` ADD CONSTRAINT `fk_inventory_abc_classification_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`abc_classification` ADD CONSTRAINT `fk_inventory_abc_classification_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`abc_classification` ADD CONSTRAINT `fk_inventory_abc_classification_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`inventory_valuation` ADD CONSTRAINT `fk_inventory_inventory_valuation_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`wip_stock` ADD CONSTRAINT `fk_inventory_wip_stock_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_capa_record_id` FOREIGN KEY (`capa_record_id`) REFERENCES `manufacturing_ecm`.`workforce`.`capa_record`(`capa_record_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_initiated_by_employee_id` FOREIGN KEY (`initiated_by_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`quarantine_hold` ADD CONSTRAINT `fk_inventory_quarantine_hold_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`serialized_unit` ADD CONSTRAINT `fk_inventory_serialized_unit_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`mro_stock` ADD CONSTRAINT `fk_inventory_mro_stock_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`mro_stock` ADD CONSTRAINT `fk_inventory_mro_stock_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`mro_stock` ADD CONSTRAINT `fk_inventory_mro_stock_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`mro_stock` ADD CONSTRAINT `fk_inventory_mro_stock_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`mro_stock` ADD CONSTRAINT `fk_inventory_mro_stock_it_asset_id` FOREIGN KEY (`it_asset_id`) REFERENCES `manufacturing_ecm`.`workforce`.`it_asset`(`it_asset_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`mro_stock` ADD CONSTRAINT `fk_inventory_mro_stock_spare_part_id` FOREIGN KEY (`spare_part_id`) REFERENCES `manufacturing_ecm`.`workforce`.`spare_part`(`spare_part_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`mro_stock` ADD CONSTRAINT `fk_inventory_mro_stock_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`physical_inventory` ADD CONSTRAINT `fk_inventory_physical_inventory_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`physical_inventory` ADD CONSTRAINT `fk_inventory_physical_inventory_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`consignment_stock` ADD CONSTRAINT `fk_inventory_consignment_stock_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`consignment_stock` ADD CONSTRAINT `fk_inventory_consignment_stock_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`consignment_stock` ADD CONSTRAINT `fk_inventory_consignment_stock_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`consignment_stock` ADD CONSTRAINT `fk_inventory_consignment_stock_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`consignment_stock` ADD CONSTRAINT `fk_inventory_consignment_stock_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`consignment_stock` ADD CONSTRAINT `fk_inventory_consignment_stock_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`handling_unit` ADD CONSTRAINT `fk_inventory_handling_unit_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`handling_unit` ADD CONSTRAINT `fk_inventory_handling_unit_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`sku_pricing` ADD CONSTRAINT `fk_inventory_sku_pricing_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`warehouse_carrier_agreement` ADD CONSTRAINT `fk_inventory_warehouse_carrier_agreement_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`consumption` ADD CONSTRAINT `fk_inventory_consumption_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`inventory`.`consumption` ADD CONSTRAINT `fk_inventory_consumption_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);

-- ========= logistics --> asset (1 constraint(s)) =========
-- Requires: logistics schema, asset schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_service_agreement` ADD CONSTRAINT `fk_logistics_carrier_service_agreement_service_contract_id` FOREIGN KEY (`service_contract_id`) REFERENCES `manufacturing_ecm`.`asset`.`service_contract`(`service_contract_id`);

-- ========= logistics --> billing (1 constraint(s)) =========
-- Requires: logistics schema, billing schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ADD CONSTRAINT `fk_logistics_freight_claim_credit_note_id` FOREIGN KEY (`credit_note_id`) REFERENCES `manufacturing_ecm`.`billing`.`credit_note`(`credit_note_id`);

-- ========= logistics --> compliance (1 constraint(s)) =========
-- Requires: logistics schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ADD CONSTRAINT `fk_logistics_freight_claim_compliance_audit_finding_id` FOREIGN KEY (`compliance_audit_finding_id`) REFERENCES `manufacturing_ecm`.`compliance`.`compliance_audit_finding`(`compliance_audit_finding_id`);

-- ========= logistics --> customer (3 constraint(s)) =========
-- Requires: logistics schema, customer schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_stop` ADD CONSTRAINT `fk_logistics_route_stop_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`customer`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`customer`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);

-- ========= logistics --> engineering (3 constraint(s)) =========
-- Requires: logistics schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ADD CONSTRAINT `fk_logistics_trade_document_engineering_regulatory_certification_id` FOREIGN KEY (`engineering_regulatory_certification_id`) REFERENCES `manufacturing_ecm`.`engineering`.`engineering_regulatory_certification`(`engineering_regulatory_certification_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_logistics_dangerous_goods_declaration_material_specification_id` FOREIGN KEY (`material_specification_id`) REFERENCES `manufacturing_ecm`.`engineering`.`material_specification`(`material_specification_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_qualification` ADD CONSTRAINT `fk_logistics_carrier_qualification_tooling_equipment_id` FOREIGN KEY (`tooling_equipment_id`) REFERENCES `manufacturing_ecm`.`engineering`.`tooling_equipment`(`tooling_equipment_id`);

-- ========= logistics --> finance (1 constraint(s)) =========
-- Requires: logistics schema, finance schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `manufacturing_ecm`.`finance`.`ap_invoice`(`ap_invoice_id`);

-- ========= logistics --> hse (2 constraint(s)) =========
-- Requires: logistics schema, hse schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_logistics_dangerous_goods_declaration_chemical_substance_id` FOREIGN KEY (`chemical_substance_id`) REFERENCES `manufacturing_ecm`.`hse`.`chemical_substance`(`chemical_substance_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_logistics_dangerous_goods_declaration_sds_id` FOREIGN KEY (`sds_id`) REFERENCES `manufacturing_ecm`.`hse`.`sds`(`sds_id`);

-- ========= logistics --> inventory (5 constraint(s)) =========
-- Requires: logistics schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_lot_batch_id` FOREIGN KEY (`lot_batch_id`) REFERENCES `manufacturing_ecm`.`inventory`.`lot_batch`(`lot_batch_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`inventory`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_stock_position_id` FOREIGN KEY (`stock_position_id`) REFERENCES `manufacturing_ecm`.`inventory`.`stock_position`(`stock_position_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_pick_task_id` FOREIGN KEY (`pick_task_id`) REFERENCES `manufacturing_ecm`.`inventory`.`pick_task`(`pick_task_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ADD CONSTRAINT `fk_logistics_load_unit_handling_unit_id` FOREIGN KEY (`handling_unit_id`) REFERENCES `manufacturing_ecm`.`inventory`.`handling_unit`(`handling_unit_id`);

-- ========= logistics --> order (1 constraint(s)) =========
-- Requires: logistics schema, order schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ADD CONSTRAINT `fk_logistics_logistics_inbound_delivery_returns_order_id` FOREIGN KEY (`returns_order_id`) REFERENCES `manufacturing_ecm`.`order`.`returns_order`(`returns_order_id`);

-- ========= logistics --> product (3 constraint(s)) =========
-- Requires: logistics schema, product schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_rate` ADD CONSTRAINT `fk_logistics_freight_rate_category_id` FOREIGN KEY (`category_id`) REFERENCES `manufacturing_ecm`.`product`.`category`(`category_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ADD CONSTRAINT `fk_logistics_customs_declaration_product_regulatory_certification_id` FOREIGN KEY (`product_regulatory_certification_id`) REFERENCES `manufacturing_ecm`.`product`.`product_regulatory_certification`(`product_regulatory_certification_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_logistics_dangerous_goods_declaration_hazardous_substance_id` FOREIGN KEY (`hazardous_substance_id`) REFERENCES `manufacturing_ecm`.`product`.`hazardous_substance`(`hazardous_substance_id`);

-- ========= logistics --> production (1 constraint(s)) =========
-- Requires: logistics schema, production schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);

-- ========= logistics --> quality (2 constraint(s)) =========
-- Requires: logistics schema, quality schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_logistics_dangerous_goods_declaration_certificate_id` FOREIGN KEY (`certificate_id`) REFERENCES `manufacturing_ecm`.`quality`.`certificate`(`certificate_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ADD CONSTRAINT `fk_logistics_shipment_exception_quality_notification_id` FOREIGN KEY (`quality_notification_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_notification`(`quality_notification_id`);

-- ========= logistics --> research (1 constraint(s)) =========
-- Requires: logistics schema, research schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ADD CONSTRAINT `fk_logistics_logistics_inbound_delivery_lab_resource_id` FOREIGN KEY (`lab_resource_id`) REFERENCES `manufacturing_ecm`.`research`.`lab_resource`(`lab_resource_id`);

-- ========= logistics --> service (4 constraint(s)) =========
-- Requires: logistics schema, service schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ADD CONSTRAINT `fk_logistics_freight_claim_request_id` FOREIGN KEY (`request_id`) REFERENCES `manufacturing_ecm`.`service`.`request`(`request_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ADD CONSTRAINT `fk_logistics_carrier_territory_coverage_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `manufacturing_ecm`.`service`.`service_territory`(`service_territory_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_territory_coverage` ADD CONSTRAINT `fk_logistics_carrier_territory_coverage_territory_service_territory_id` FOREIGN KEY (`territory_service_territory_id`) REFERENCES `manufacturing_ecm`.`service`.`service_territory`(`service_territory_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`parts_inventory_position` ADD CONSTRAINT `fk_logistics_parts_inventory_position_spare_parts_catalog_id` FOREIGN KEY (`spare_parts_catalog_id`) REFERENCES `manufacturing_ecm`.`service`.`spare_parts_catalog`(`spare_parts_catalog_id`);

-- ========= logistics --> workforce (71 constraint(s)) =========
-- Requires: logistics schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_item` ADD CONSTRAINT `fk_logistics_shipment_item_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier` ADD CONSTRAINT `fk_logistics_carrier_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_order` ADD CONSTRAINT `fk_logistics_freight_order_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ADD CONSTRAINT `fk_logistics_transport_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ADD CONSTRAINT `fk_logistics_transport_plan_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`transport_plan` ADD CONSTRAINT `fk_logistics_transport_plan_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ADD CONSTRAINT `fk_logistics_route_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`route` ADD CONSTRAINT `fk_logistics_route_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery` ADD CONSTRAINT `fk_logistics_delivery_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ADD CONSTRAINT `fk_logistics_logistics_inbound_delivery_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ADD CONSTRAINT `fk_logistics_logistics_inbound_delivery_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ADD CONSTRAINT `fk_logistics_logistics_inbound_delivery_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ADD CONSTRAINT `fk_logistics_logistics_inbound_delivery_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ADD CONSTRAINT `fk_logistics_logistics_inbound_delivery_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery` ADD CONSTRAINT `fk_logistics_logistics_inbound_delivery_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ADD CONSTRAINT `fk_logistics_tracking_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ADD CONSTRAINT `fk_logistics_tracking_event_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`tracking_event` ADD CONSTRAINT `fk_logistics_tracking_event_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_invoice` ADD CONSTRAINT `fk_logistics_freight_invoice_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ADD CONSTRAINT `fk_logistics_freight_audit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ADD CONSTRAINT `fk_logistics_freight_audit_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ADD CONSTRAINT `fk_logistics_freight_audit_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_audit` ADD CONSTRAINT `fk_logistics_freight_audit_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ADD CONSTRAINT `fk_logistics_customs_declaration_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ADD CONSTRAINT `fk_logistics_customs_declaration_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ADD CONSTRAINT `fk_logistics_customs_declaration_export_classification_id` FOREIGN KEY (`export_classification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`export_classification`(`export_classification_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ADD CONSTRAINT `fk_logistics_customs_declaration_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ADD CONSTRAINT `fk_logistics_customs_declaration_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ADD CONSTRAINT `fk_logistics_customs_declaration_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ADD CONSTRAINT `fk_logistics_customs_declaration_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`customs_declaration` ADD CONSTRAINT `fk_logistics_customs_declaration_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ADD CONSTRAINT `fk_logistics_trade_document_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ADD CONSTRAINT `fk_logistics_trade_document_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`trade_document` ADD CONSTRAINT `fk_logistics_trade_document_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ADD CONSTRAINT `fk_logistics_packaging_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ADD CONSTRAINT `fk_logistics_packaging_line_id` FOREIGN KEY (`line_id`) REFERENCES `manufacturing_ecm`.`workforce`.`line`(`line_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`packaging` ADD CONSTRAINT `fk_logistics_packaging_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ADD CONSTRAINT `fk_logistics_load_unit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`load_unit` ADD CONSTRAINT `fk_logistics_load_unit_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`carrier_performance` ADD CONSTRAINT `fk_logistics_carrier_performance_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ADD CONSTRAINT `fk_logistics_delivery_performance_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`delivery_performance` ADD CONSTRAINT `fk_logistics_delivery_performance_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ADD CONSTRAINT `fk_logistics_freight_claim_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ADD CONSTRAINT `fk_logistics_freight_claim_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ADD CONSTRAINT `fk_logistics_freight_claim_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ADD CONSTRAINT `fk_logistics_freight_claim_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ADD CONSTRAINT `fk_logistics_freight_claim_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_claim` ADD CONSTRAINT `fk_logistics_freight_claim_spare_part_id` FOREIGN KEY (`spare_part_id`) REFERENCES `manufacturing_ecm`.`workforce`.`spare_part`(`spare_part_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`location` ADD CONSTRAINT `fk_logistics_location_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_logistics_dangerous_goods_declaration_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_logistics_dangerous_goods_declaration_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_logistics_dangerous_goods_declaration_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_logistics_dangerous_goods_declaration_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_logistics_dangerous_goods_declaration_spare_part_id` FOREIGN KEY (`spare_part_id`) REFERENCES `manufacturing_ecm`.`workforce`.`spare_part`(`spare_part_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ADD CONSTRAINT `fk_logistics_freight_contract_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`freight_contract` ADD CONSTRAINT `fk_logistics_freight_contract_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ADD CONSTRAINT `fk_logistics_shipment_exception_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`shipment_exception` ADD CONSTRAINT `fk_logistics_shipment_exception_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`logistics`.`route_supplier_pickup` ADD CONSTRAINT `fk_logistics_route_supplier_pickup_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);

-- ========= order --> compliance (1 constraint(s)) =========
-- Requires: order schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ADD CONSTRAINT `fk_order_export_control_check_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `manufacturing_ecm`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);

-- ========= order --> customer (5 constraint(s)) =========
-- Requires: order schema, customer schema
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ADD CONSTRAINT `fk_order_order_quotation_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ADD CONSTRAINT `fk_order_order_quotation_customer_opportunity_id` FOREIGN KEY (`customer_opportunity_id`) REFERENCES `manufacturing_ecm`.`customer`.`customer_opportunity`(`customer_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ADD CONSTRAINT `fk_order_order_quotation_pricing_agreement_id` FOREIGN KEY (`pricing_agreement_id`) REFERENCES `manufacturing_ecm`.`customer`.`pricing_agreement`(`pricing_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ADD CONSTRAINT `fk_order_rfq_request_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ADD CONSTRAINT `fk_order_credit_check_credit_profile_id` FOREIGN KEY (`credit_profile_id`) REFERENCES `manufacturing_ecm`.`customer`.`credit_profile`(`credit_profile_id`);

-- ========= order --> engineering (1 constraint(s)) =========
-- Requires: order schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ADD CONSTRAINT `fk_order_order_configuration_product_variant_id` FOREIGN KEY (`product_variant_id`) REFERENCES `manufacturing_ecm`.`engineering`.`product_variant`(`product_variant_id`);

-- ========= order --> finance (3 constraint(s)) =========
-- Requires: order schema, finance schema
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`finance`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ADD CONSTRAINT `fk_order_returns_order_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `manufacturing_ecm`.`finance`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ADD CONSTRAINT `fk_order_credit_check_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `manufacturing_ecm`.`finance`.`ar_invoice`(`ar_invoice_id`);

-- ========= order --> hse (1 constraint(s)) =========
-- Requires: order schema, hse schema
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ADD CONSTRAINT `fk_order_export_control_check_hse_reach_substance_declaration_id` FOREIGN KEY (`hse_reach_substance_declaration_id`) REFERENCES `manufacturing_ecm`.`hse`.`hse_reach_substance_declaration`(`hse_reach_substance_declaration_id`);

-- ========= order --> procurement (1 constraint(s)) =========
-- Requires: order schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ADD CONSTRAINT `fk_order_rfq_request_procurement_sourcing_event_id` FOREIGN KEY (`procurement_sourcing_event_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_sourcing_event`(`procurement_sourcing_event_id`);

-- ========= order --> product (2 constraint(s)) =========
-- Requires: order schema, product schema
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ADD CONSTRAINT `fk_order_export_control_check_hazardous_substance_id` FOREIGN KEY (`hazardous_substance_id`) REFERENCES `manufacturing_ecm`.`product`.`hazardous_substance`(`hazardous_substance_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ADD CONSTRAINT `fk_order_export_control_check_product_regulatory_certification_id` FOREIGN KEY (`product_regulatory_certification_id`) REFERENCES `manufacturing_ecm`.`product`.`product_regulatory_certification`(`product_regulatory_certification_id`);

-- ========= order --> quality (2 constraint(s)) =========
-- Requires: order schema, quality schema
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ADD CONSTRAINT `fk_order_order_block_quality_notification_id` FOREIGN KEY (`quality_notification_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_notification`(`quality_notification_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);

-- ========= order --> research (1 constraint(s)) =========
-- Requires: order schema, research schema
ALTER TABLE `manufacturing_ecm`.`order`.`channel` ADD CONSTRAINT `fk_order_channel_partner_id` FOREIGN KEY (`partner_id`) REFERENCES `manufacturing_ecm`.`research`.`partner`(`partner_id`);

-- ========= order --> sales (3 constraint(s)) =========
-- Requires: order schema, sales schema
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ADD CONSTRAINT `fk_order_order_quotation_sales_price_list_id` FOREIGN KEY (`sales_price_list_id`) REFERENCES `manufacturing_ecm`.`sales`.`sales_price_list`(`sales_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_discount_structure_id` FOREIGN KEY (`discount_structure_id`) REFERENCES `manufacturing_ecm`.`sales`.`discount_structure`(`discount_structure_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_special_pricing_request_id` FOREIGN KEY (`special_pricing_request_id`) REFERENCES `manufacturing_ecm`.`sales`.`special_pricing_request`(`special_pricing_request_id`);

-- ========= order --> workforce (51 constraint(s)) =========
-- Requires: order schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ADD CONSTRAINT `fk_order_line_item_compliance_reach_substance_declaration_id` FOREIGN KEY (`compliance_reach_substance_declaration_id`) REFERENCES `manufacturing_ecm`.`workforce`.`compliance_reach_substance_declaration`(`compliance_reach_substance_declaration_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ADD CONSTRAINT `fk_order_line_item_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ADD CONSTRAINT `fk_order_line_item_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ADD CONSTRAINT `fk_order_line_item_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ADD CONSTRAINT `fk_order_line_item_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`line_item` ADD CONSTRAINT `fk_order_line_item_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ADD CONSTRAINT `fk_order_order_quotation_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ADD CONSTRAINT `fk_order_order_quotation_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_quotation` ADD CONSTRAINT `fk_order_order_quotation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ADD CONSTRAINT `fk_order_quotation_line_item_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`quotation_line_item` ADD CONSTRAINT `fk_order_quotation_line_item_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ADD CONSTRAINT `fk_order_rfq_request_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`rfq_request` ADD CONSTRAINT `fk_order_rfq_request_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ADD CONSTRAINT `fk_order_schedule_line_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`schedule_line` ADD CONSTRAINT `fk_order_schedule_line_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`status_history` ADD CONSTRAINT `fk_order_status_history_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ADD CONSTRAINT `fk_order_order_confirmation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_confirmation` ADD CONSTRAINT `fk_order_order_confirmation_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`atp_commitment` ADD CONSTRAINT `fk_order_atp_commitment_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_configuration` ADD CONSTRAINT `fk_order_order_configuration_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`pricing_condition` ADD CONSTRAINT `fk_order_pricing_condition_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`order_block` ADD CONSTRAINT `fk_order_order_block_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ADD CONSTRAINT `fk_order_returns_order_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ADD CONSTRAINT `fk_order_returns_order_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ADD CONSTRAINT `fk_order_returns_order_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ADD CONSTRAINT `fk_order_returns_order_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ADD CONSTRAINT `fk_order_returns_order_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ADD CONSTRAINT `fk_order_returns_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ADD CONSTRAINT `fk_order_returns_order_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`returns_order` ADD CONSTRAINT `fk_order_returns_order_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ADD CONSTRAINT `fk_order_amendment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`amendment` ADD CONSTRAINT `fk_order_amendment_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`customer_po` ADD CONSTRAINT `fk_order_customer_po_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`internal_order`(`internal_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`fulfillment_plan` ADD CONSTRAINT `fk_order_fulfillment_plan_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`goods_issue` ADD CONSTRAINT `fk_order_goods_issue_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ADD CONSTRAINT `fk_order_credit_check_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`credit_check` ADD CONSTRAINT `fk_order_credit_check_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ADD CONSTRAINT `fk_order_export_control_check_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ADD CONSTRAINT `fk_order_export_control_check_export_classification_id` FOREIGN KEY (`export_classification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`export_classification`(`export_classification_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`export_control_check` ADD CONSTRAINT `fk_order_export_control_check_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`text` ADD CONSTRAINT `fk_order_text_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`text` ADD CONSTRAINT `fk_order_text_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`blanket_order_line` ADD CONSTRAINT `fk_order_blanket_order_line_spare_part_id` FOREIGN KEY (`spare_part_id`) REFERENCES `manufacturing_ecm`.`workforce`.`spare_part`(`spare_part_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ADD CONSTRAINT `fk_order_service_coverage_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`order`.`service_coverage` ADD CONSTRAINT `fk_order_service_coverage_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);

-- ========= procurement --> asset (1 constraint(s)) =========
-- Requires: procurement schema, asset schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ADD CONSTRAINT `fk_procurement_procurement_purchase_requisition_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `manufacturing_ecm`.`asset`.`maintenance_plan`(`maintenance_plan_id`);

-- ========= procurement --> compliance (7 constraint(s)) =========
-- Requires: procurement schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ADD CONSTRAINT `fk_procurement_procurement_supplier_qualification_certification_audit_id` FOREIGN KEY (`certification_audit_id`) REFERENCES `manufacturing_ecm`.`compliance`.`certification_audit`(`certification_audit_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ADD CONSTRAINT `fk_procurement_procurement_material_info_record_rohs_compliance_record_id` FOREIGN KEY (`rohs_compliance_record_id`) REFERENCES `manufacturing_ecm`.`compliance`.`rohs_compliance_record`(`rohs_compliance_record_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ADD CONSTRAINT `fk_procurement_supplier_audit_internal_audit_id` FOREIGN KEY (`internal_audit_id`) REFERENCES `manufacturing_ecm`.`compliance`.`internal_audit`(`internal_audit_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_risk` ADD CONSTRAINT `fk_procurement_supplier_risk_third_party_risk_id` FOREIGN KEY (`third_party_risk_id`) REFERENCES `manufacturing_ecm`.`compliance`.`third_party_risk`(`third_party_risk_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_policy` ADD CONSTRAINT `fk_procurement_procurement_policy_compliance_policy_id` FOREIGN KEY (`compliance_policy_id`) REFERENCES `manufacturing_ecm`.`compliance`.`compliance_policy`(`compliance_policy_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ADD CONSTRAINT `fk_procurement_po_compliance_verification_compliance_obligation_id` FOREIGN KEY (`compliance_obligation_id`) REFERENCES `manufacturing_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ADD CONSTRAINT `fk_procurement_po_compliance_verification_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `manufacturing_ecm`.`compliance`.`obligation`(`obligation_id`);

-- ========= procurement --> customer (1 constraint(s)) =========
-- Requires: procurement schema, customer schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ADD CONSTRAINT `fk_procurement_procurement_supplier_contact_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);

-- ========= procurement --> finance (4 constraint(s)) =========
-- Requires: procurement schema, finance schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ADD CONSTRAINT `fk_procurement_procurement_purchase_requisition_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `manufacturing_ecm`.`finance`.`budget`(`budget_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ADD CONSTRAINT `fk_procurement_procurement_supplier_invoice_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `manufacturing_ecm`.`finance`.`ap_invoice`(`ap_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ADD CONSTRAINT `fk_procurement_procurement_supplier_invoice_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`finance`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_journal_entry_id` FOREIGN KEY (`journal_entry_id`) REFERENCES `manufacturing_ecm`.`finance`.`journal_entry`(`journal_entry_id`);

-- ========= procurement --> hse (3 constraint(s)) =========
-- Requires: procurement schema, hse schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ADD CONSTRAINT `fk_procurement_procurement_supplier_qualification_safety_audit_id` FOREIGN KEY (`safety_audit_id`) REFERENCES `manufacturing_ecm`.`hse`.`safety_audit`(`safety_audit_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ADD CONSTRAINT `fk_procurement_supplier_certificate_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `manufacturing_ecm`.`hse`.`environmental_permit`(`environmental_permit_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ADD CONSTRAINT `fk_procurement_supplier_compliance_regulatory_obligation_id` FOREIGN KEY (`regulatory_obligation_id`) REFERENCES `manufacturing_ecm`.`hse`.`regulatory_obligation`(`regulatory_obligation_id`);

-- ========= procurement --> logistics (1 constraint(s)) =========
-- Requires: procurement schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ADD CONSTRAINT `fk_procurement_goods_receipt_line_logistics_inbound_delivery_id` FOREIGN KEY (`logistics_inbound_delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery`(`logistics_inbound_delivery_id`);

-- ========= procurement --> order (1 constraint(s)) =========
-- Requires: procurement schema, order schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_blanket_order_id` FOREIGN KEY (`blanket_order_id`) REFERENCES `manufacturing_ecm`.`order`.`blanket_order`(`blanket_order_id`);

-- ========= procurement --> product (1 constraint(s)) =========
-- Requires: procurement schema, product schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_spend_category` ADD CONSTRAINT `fk_procurement_procurement_spend_category_category_id` FOREIGN KEY (`category_id`) REFERENCES `manufacturing_ecm`.`product`.`category`(`category_id`);

-- ========= procurement --> quality (7 constraint(s)) =========
-- Requires: procurement schema, quality schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ADD CONSTRAINT `fk_procurement_procurement_supplier_qualification_ppap_submission_id` FOREIGN KEY (`ppap_submission_id`) REFERENCES `manufacturing_ecm`.`quality`.`ppap_submission`(`ppap_submission_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ADD CONSTRAINT `fk_procurement_goods_receipt_line_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ADD CONSTRAINT `fk_procurement_supplier_audit_ariba_audit_id` FOREIGN KEY (`ariba_audit_id`) REFERENCES `manufacturing_ecm`.`quality`.`audit`(`audit_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ADD CONSTRAINT `fk_procurement_supplier_audit_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `manufacturing_ecm`.`quality`.`audit`(`audit_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ADD CONSTRAINT `fk_procurement_supplier_certificate_ariba_certificate_id` FOREIGN KEY (`ariba_certificate_id`) REFERENCES `manufacturing_ecm`.`quality`.`certificate`(`certificate_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ADD CONSTRAINT `fk_procurement_supplier_certificate_certificate_id` FOREIGN KEY (`certificate_id`) REFERENCES `manufacturing_ecm`.`quality`.`certificate`(`certificate_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ADD CONSTRAINT `fk_procurement_supplier_control_plan_approval_control_plan_id` FOREIGN KEY (`control_plan_id`) REFERENCES `manufacturing_ecm`.`quality`.`control_plan`(`control_plan_id`);

-- ========= procurement --> sales (2 constraint(s)) =========
-- Requires: procurement schema, sales schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_forecast_id` FOREIGN KEY (`forecast_id`) REFERENCES `manufacturing_ecm`.`sales`.`forecast`(`forecast_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_forecast_id` FOREIGN KEY (`forecast_id`) REFERENCES `manufacturing_ecm`.`sales`.`forecast`(`forecast_id`);

-- ========= procurement --> service (2 constraint(s)) =========
-- Requires: procurement schema, service schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ADD CONSTRAINT `fk_procurement_contract_line_item_contract_line_id` FOREIGN KEY (`contract_line_id`) REFERENCES `manufacturing_ecm`.`service`.`contract_line`(`contract_line_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ADD CONSTRAINT `fk_procurement_mro_catalog_spare_parts_catalog_id` FOREIGN KEY (`spare_parts_catalog_id`) REFERENCES `manufacturing_ecm`.`service`.`spare_parts_catalog`(`spare_parts_catalog_id`);

-- ========= procurement --> technology (2 constraint(s)) =========
-- Requires: procurement schema, technology schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ADD CONSTRAINT `fk_procurement_procurement_contract_it_contract_id` FOREIGN KEY (`it_contract_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_contract`(`it_contract_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_it_cost_allocation_id` FOREIGN KEY (`it_cost_allocation_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_cost_allocation`(`it_cost_allocation_id`);

-- ========= procurement --> workforce (87 constraint(s)) =========
-- Requires: procurement schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_contact` ADD CONSTRAINT `fk_procurement_procurement_supplier_contact_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_qualification` ADD CONSTRAINT `fk_procurement_procurement_supplier_qualification_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_event` ADD CONSTRAINT `fk_procurement_procurement_sourcing_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ADD CONSTRAINT `fk_procurement_procurement_sourcing_bid_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_sourcing_bid` ADD CONSTRAINT `fk_procurement_procurement_sourcing_bid_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ADD CONSTRAINT `fk_procurement_procurement_po_line_item_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ADD CONSTRAINT `fk_procurement_procurement_po_line_item_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ADD CONSTRAINT `fk_procurement_procurement_po_line_item_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ADD CONSTRAINT `fk_procurement_procurement_po_line_item_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_po_line_item` ADD CONSTRAINT `fk_procurement_procurement_po_line_item_spare_part_id` FOREIGN KEY (`spare_part_id`) REFERENCES `manufacturing_ecm`.`workforce`.`spare_part`(`spare_part_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ADD CONSTRAINT `fk_procurement_procurement_purchase_requisition_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ADD CONSTRAINT `fk_procurement_procurement_purchase_requisition_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ADD CONSTRAINT `fk_procurement_procurement_purchase_requisition_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ADD CONSTRAINT `fk_procurement_procurement_purchase_requisition_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ADD CONSTRAINT `fk_procurement_procurement_purchase_requisition_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ADD CONSTRAINT `fk_procurement_procurement_purchase_requisition_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ADD CONSTRAINT `fk_procurement_procurement_purchase_requisition_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition` ADD CONSTRAINT `fk_procurement_procurement_purchase_requisition_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_goods_receipt` ADD CONSTRAINT `fk_procurement_procurement_goods_receipt_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`goods_receipt_line` ADD CONSTRAINT `fk_procurement_goods_receipt_line_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ADD CONSTRAINT `fk_procurement_procurement_supplier_invoice_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ADD CONSTRAINT `fk_procurement_procurement_supplier_invoice_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ADD CONSTRAINT `fk_procurement_procurement_supplier_invoice_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_invoice` ADD CONSTRAINT `fk_procurement_procurement_supplier_invoice_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mrp_planned_order` ADD CONSTRAINT `fk_procurement_mrp_planned_order_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`demand_forecast` ADD CONSTRAINT `fk_procurement_demand_forecast_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supply_agreement` ADD CONSTRAINT `fk_procurement_procurement_supply_agreement_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ADD CONSTRAINT `fk_procurement_delivery_schedule_line_id` FOREIGN KEY (`line_id`) REFERENCES `manufacturing_ecm`.`workforce`.`line`(`line_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`delivery_schedule` ADD CONSTRAINT `fk_procurement_delivery_schedule_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ADD CONSTRAINT `fk_procurement_procurement_supplier_performance_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_supplier_performance` ADD CONSTRAINT `fk_procurement_procurement_supplier_performance_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supply_risk` ADD CONSTRAINT `fk_procurement_supply_risk_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ADD CONSTRAINT `fk_procurement_procurement_material_info_record_compliance_reach_substance_declaration_id` FOREIGN KEY (`compliance_reach_substance_declaration_id`) REFERENCES `manufacturing_ecm`.`workforce`.`compliance_reach_substance_declaration`(`compliance_reach_substance_declaration_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ADD CONSTRAINT `fk_procurement_procurement_material_info_record_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ADD CONSTRAINT `fk_procurement_procurement_material_info_record_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_material_info_record` ADD CONSTRAINT `fk_procurement_procurement_material_info_record_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ADD CONSTRAINT `fk_procurement_source_list_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ADD CONSTRAINT `fk_procurement_source_list_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`source_list` ADD CONSTRAINT `fk_procurement_source_list_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ADD CONSTRAINT `fk_procurement_quota_arrangement_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ADD CONSTRAINT `fk_procurement_quota_arrangement_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`quota_arrangement` ADD CONSTRAINT `fk_procurement_quota_arrangement_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ADD CONSTRAINT `fk_procurement_procurement_inbound_delivery_export_classification_id` FOREIGN KEY (`export_classification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`export_classification`(`export_classification_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ADD CONSTRAINT `fk_procurement_procurement_inbound_delivery_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ADD CONSTRAINT `fk_procurement_procurement_inbound_delivery_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_inbound_delivery` ADD CONSTRAINT `fk_procurement_procurement_inbound_delivery_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_audit` ADD CONSTRAINT `fk_procurement_supplier_audit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ADD CONSTRAINT `fk_procurement_po_change_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_change_record` ADD CONSTRAINT `fk_procurement_po_change_record_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ADD CONSTRAINT `fk_procurement_procurement_contract_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ADD CONSTRAINT `fk_procurement_procurement_contract_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`procurement_contract` ADD CONSTRAINT `fk_procurement_procurement_contract_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`contract_line_item` ADD CONSTRAINT `fk_procurement_contract_line_item_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order` ADD CONSTRAINT `fk_procurement_purchase_order_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`spend_transaction` ADD CONSTRAINT `fk_procurement_spend_transaction_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ADD CONSTRAINT `fk_procurement_purchase_requisition_approval_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ADD CONSTRAINT `fk_procurement_purchase_requisition_approval_delegated_by_employee_id` FOREIGN KEY (`delegated_by_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_requisition_approval` ADD CONSTRAINT `fk_procurement_purchase_requisition_approval_escalated_to_employee_id` FOREIGN KEY (`escalated_to_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certificate` ADD CONSTRAINT `fk_procurement_supplier_certificate_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ADD CONSTRAINT `fk_procurement_purchase_order_amendment_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`purchase_order_amendment` ADD CONSTRAINT `fk_procurement_purchase_order_amendment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ADD CONSTRAINT `fk_procurement_mro_catalog_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`mro_catalog` ADD CONSTRAINT `fk_procurement_mro_catalog_spare_part_id` FOREIGN KEY (`spare_part_id`) REFERENCES `manufacturing_ecm`.`workforce`.`spare_part`(`spare_part_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ADD CONSTRAINT `fk_procurement_supplier_collaboration_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_collaboration` ADD CONSTRAINT `fk_procurement_supplier_collaboration_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ADD CONSTRAINT `fk_procurement_supplier_service_contract_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ADD CONSTRAINT `fk_procurement_supplier_service_contract_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_service_contract` ADD CONSTRAINT `fk_procurement_supplier_service_contract_service_contract_id` FOREIGN KEY (`service_contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ADD CONSTRAINT `fk_procurement_supplier_compliance_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_compliance` ADD CONSTRAINT `fk_procurement_supplier_compliance_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ADD CONSTRAINT `fk_procurement_supplier_certification_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_certification` ADD CONSTRAINT `fk_procurement_supplier_certification_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`supplier_control_plan_approval` ADD CONSTRAINT `fk_procurement_supplier_control_plan_approval_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`procurement`.`po_compliance_verification` ADD CONSTRAINT `fk_procurement_po_compliance_verification_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);

-- ========= product --> asset (1 constraint(s)) =========
-- Requires: product schema, asset schema
ALTER TABLE `manufacturing_ecm`.`product`.`category` ADD CONSTRAINT `fk_product_category_class_id` FOREIGN KEY (`class_id`) REFERENCES `manufacturing_ecm`.`asset`.`class`(`class_id`);

-- ========= product --> compliance (3 constraint(s)) =========
-- Requires: product schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ADD CONSTRAINT `fk_product_change_notice_regulatory_change_id` FOREIGN KEY (`regulatory_change_id`) REFERENCES `manufacturing_ecm`.`compliance`.`regulatory_change`(`regulatory_change_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ADD CONSTRAINT `fk_product_compliance_evidence_id` FOREIGN KEY (`evidence_id`) REFERENCES `manufacturing_ecm`.`compliance`.`evidence`(`evidence_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ADD CONSTRAINT `fk_product_market_authorization_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `manufacturing_ecm`.`compliance`.`jurisdiction`(`jurisdiction_id`);

-- ========= product --> engineering (4 constraint(s)) =========
-- Requires: product schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ADD CONSTRAINT `fk_product_product_configuration_cad_model_id` FOREIGN KEY (`cad_model_id`) REFERENCES `manufacturing_ecm`.`engineering`.`cad_model`(`cad_model_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ADD CONSTRAINT `fk_product_product_document_drawing_id` FOREIGN KEY (`drawing_id`) REFERENCES `manufacturing_ecm`.`engineering`.`drawing`(`drawing_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ADD CONSTRAINT `fk_product_change_notice_eco_id` FOREIGN KEY (`eco_id`) REFERENCES `manufacturing_ecm`.`engineering`.`eco`(`eco_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ADD CONSTRAINT `fk_product_launch_project_id` FOREIGN KEY (`project_id`) REFERENCES `manufacturing_ecm`.`engineering`.`project`(`project_id`);

-- ========= product --> finance (1 constraint(s)) =========
-- Requires: product schema, finance schema
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ADD CONSTRAINT `fk_product_price_list_item_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`finance`.`tax_code`(`tax_code_id`);

-- ========= product --> hse (1 constraint(s)) =========
-- Requires: product schema, hse schema
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ADD CONSTRAINT `fk_product_product_regulatory_certification_regulatory_obligation_id` FOREIGN KEY (`regulatory_obligation_id`) REFERENCES `manufacturing_ecm`.`hse`.`regulatory_obligation`(`regulatory_obligation_id`);

-- ========= product --> procurement (1 constraint(s)) =========
-- Requires: product schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ADD CONSTRAINT `fk_product_product_material_info_record_procurement_material_info_record_id` FOREIGN KEY (`procurement_material_info_record_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_material_info_record`(`procurement_material_info_record_id`);

-- ========= product --> quality (2 constraint(s)) =========
-- Requires: product schema, quality schema
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ADD CONSTRAINT `fk_product_quality_specification_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ADD CONSTRAINT `fk_product_quality_specification_quality_characteristic_id` FOREIGN KEY (`quality_characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);

-- ========= product --> technology (1 constraint(s)) =========
-- Requires: product schema, technology schema
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ADD CONSTRAINT `fk_product_product_configuration_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);

-- ========= product --> workforce (43 constraint(s)) =========
-- Requires: product schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`product`.`product_configuration` ADD CONSTRAINT `fk_product_product_configuration_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ADD CONSTRAINT `fk_product_lifecycle_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`lifecycle` ADD CONSTRAINT `fk_product_lifecycle_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ADD CONSTRAINT `fk_product_price_list_item_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`price_list_item` ADD CONSTRAINT `fk_product_price_list_item_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ADD CONSTRAINT `fk_product_product_regulatory_certification_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ADD CONSTRAINT `fk_product_product_regulatory_certification_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ADD CONSTRAINT `fk_product_product_regulatory_certification_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_regulatory_certification` ADD CONSTRAINT `fk_product_product_regulatory_certification_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`hazardous_substance` ADD CONSTRAINT `fk_product_hazardous_substance_compliance_reach_substance_declaration_id` FOREIGN KEY (`compliance_reach_substance_declaration_id`) REFERENCES `manufacturing_ecm`.`workforce`.`compliance_reach_substance_declaration`(`compliance_reach_substance_declaration_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_document` ADD CONSTRAINT `fk_product_product_document_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ADD CONSTRAINT `fk_product_substitution_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`substitution` ADD CONSTRAINT `fk_product_substitution_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`bundle` ADD CONSTRAINT `fk_product_bundle_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ADD CONSTRAINT `fk_product_bundle_component_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`bundle_component` ADD CONSTRAINT `fk_product_bundle_component_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ADD CONSTRAINT `fk_product_aftermarket_part_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ADD CONSTRAINT `fk_product_aftermarket_part_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`aftermarket_part` ADD CONSTRAINT `fk_product_aftermarket_part_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ADD CONSTRAINT `fk_product_sales_org_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`sales_org` ADD CONSTRAINT `fk_product_sales_org_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ADD CONSTRAINT `fk_product_product_plant_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ADD CONSTRAINT `fk_product_product_plant_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ADD CONSTRAINT `fk_product_product_plant_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_plant` ADD CONSTRAINT `fk_product_product_plant_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`uom` ADD CONSTRAINT `fk_product_uom_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`attribute` ADD CONSTRAINT `fk_product_attribute_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ADD CONSTRAINT `fk_product_change_notice_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`change_notice` ADD CONSTRAINT `fk_product_change_notice_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ADD CONSTRAINT `fk_product_launch_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ADD CONSTRAINT `fk_product_launch_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`launch` ADD CONSTRAINT `fk_product_launch_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`market` ADD CONSTRAINT `fk_product_market_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`market` ADD CONSTRAINT `fk_product_market_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`substance_declaration` ADD CONSTRAINT `fk_product_substance_declaration_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ADD CONSTRAINT `fk_product_partner_authorization_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`partner_authorization` ADD CONSTRAINT `fk_product_partner_authorization_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`quality_specification` ADD CONSTRAINT `fk_product_quality_specification_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ADD CONSTRAINT `fk_product_product_material_info_record_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`product_material_info_record` ADD CONSTRAINT `fk_product_product_material_info_record_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ADD CONSTRAINT `fk_product_compliance_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`compliance` ADD CONSTRAINT `fk_product_compliance_regulatory_requirement_id` FOREIGN KEY (`regulatory_requirement_id`) REFERENCES `manufacturing_ecm`.`workforce`.`regulatory_requirement`(`regulatory_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`product`.`market_authorization` ADD CONSTRAINT `fk_product_market_authorization_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);

-- ========= production --> asset (1 constraint(s)) =========
-- Requires: production schema, asset schema
ALTER TABLE `manufacturing_ecm`.`production`.`downtime_event` ADD CONSTRAINT `fk_production_downtime_event_failure_record_id` FOREIGN KEY (`failure_record_id`) REFERENCES `manufacturing_ecm`.`asset`.`failure_record`(`failure_record_id`);

-- ========= production --> billing (1 constraint(s)) =========
-- Requires: production schema, billing schema
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_credit_note_id` FOREIGN KEY (`credit_note_id`) REFERENCES `manufacturing_ecm`.`billing`.`credit_note`(`credit_note_id`);

-- ========= production --> engineering (7 constraint(s)) =========
-- Requires: production schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`production`.`routing` ADD CONSTRAINT `fk_production_routing_bop_id` FOREIGN KEY (`bop_id`) REFERENCES `manufacturing_ecm`.`engineering`.`bop`(`bop_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`routing_operation` ADD CONSTRAINT `fk_production_routing_operation_bop_operation_id` FOREIGN KEY (`bop_operation_id`) REFERENCES `manufacturing_ecm`.`engineering`.`bop_operation`(`bop_operation_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`version` ADD CONSTRAINT `fk_production_version_bop_id` FOREIGN KEY (`bop_id`) REFERENCES `manufacturing_ecm`.`engineering`.`bop`(`bop_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`version` ADD CONSTRAINT `fk_production_version_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`engineering`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`bom_explosion` ADD CONSTRAINT `fk_production_bom_explosion_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`engineering`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`hold` ADD CONSTRAINT `fk_production_hold_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`engineering`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`cost_estimate` ADD CONSTRAINT `fk_production_cost_estimate_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`engineering`.`engineering_bom`(`engineering_bom_id`);

-- ========= production --> finance (1 constraint(s)) =========
-- Requires: production schema, finance schema
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);

-- ========= production --> hse (3 constraint(s)) =========
-- Requires: production schema, hse schema
ALTER TABLE `manufacturing_ecm`.`production`.`changeover` ADD CONSTRAINT `fk_production_changeover_management_of_change_id` FOREIGN KEY (`management_of_change_id`) REFERENCES `manufacturing_ecm`.`hse`.`management_of_change`(`management_of_change_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_waste_record_id` FOREIGN KEY (`waste_record_id`) REFERENCES `manufacturing_ecm`.`hse`.`waste_record`(`waste_record_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`line_permit_coverage` ADD CONSTRAINT `fk_production_line_permit_coverage_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `manufacturing_ecm`.`hse`.`environmental_permit`(`environmental_permit_id`);

-- ========= production --> inventory (3 constraint(s)) =========
-- Requires: production schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`inventory`.`storage_location`(`storage_location_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_storage_location_id` FOREIGN KEY (`storage_location_id`) REFERENCES `manufacturing_ecm`.`inventory`.`storage_location`(`storage_location_id`);

-- ========= production --> logistics (1 constraint(s)) =========
-- Requires: production schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`logistics`.`location`(`location_id`);

-- ========= production --> order (2 constraint(s)) =========
-- Requires: production schema, order schema
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`line_item`(`line_item_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`cost_estimate` ADD CONSTRAINT `fk_production_cost_estimate_order_quotation_id` FOREIGN KEY (`order_quotation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_quotation`(`order_quotation_id`);

-- ========= production --> procurement (3 constraint(s)) =========
-- Requires: production schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`production`.`planned_order` ADD CONSTRAINT `fk_production_planned_order_mrp_planned_order_id` FOREIGN KEY (`mrp_planned_order_id`) REFERENCES `manufacturing_ecm`.`procurement`.`mrp_planned_order`(`mrp_planned_order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_procurement_goods_receipt_id` FOREIGN KEY (`procurement_goods_receipt_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_goods_receipt`(`procurement_goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_procurement_goods_receipt_id` FOREIGN KEY (`procurement_goods_receipt_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_goods_receipt`(`procurement_goods_receipt_id`);

-- ========= production --> product (1 constraint(s)) =========
-- Requires: production schema, product schema
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_lifecycle_id` FOREIGN KEY (`lifecycle_id`) REFERENCES `manufacturing_ecm`.`product`.`lifecycle`(`lifecycle_id`);

-- ========= production --> quality (3 constraint(s)) =========
-- Requires: production schema, quality schema
ALTER TABLE `manufacturing_ecm`.`production`.`changeover` ADD CONSTRAINT `fk_production_changeover_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `manufacturing_ecm`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`hold` ADD CONSTRAINT `fk_production_hold_quality_notification_id` FOREIGN KEY (`quality_notification_id`) REFERENCES `manufacturing_ecm`.`quality`.`quality_notification`(`quality_notification_id`);

-- ========= production --> research (1 constraint(s)) =========
-- Requires: production schema, research schema
ALTER TABLE `manufacturing_ecm`.`production`.`version` ADD CONSTRAINT `fk_production_version_research_prototype_id` FOREIGN KEY (`research_prototype_id`) REFERENCES `manufacturing_ecm`.`research`.`research_prototype`(`research_prototype_id`);

-- ========= production --> sales (1 constraint(s)) =========
-- Requires: production schema, sales schema
ALTER TABLE `manufacturing_ecm`.`production`.`schedule` ADD CONSTRAINT `fk_production_schedule_forecast_id` FOREIGN KEY (`forecast_id`) REFERENCES `manufacturing_ecm`.`sales`.`forecast`(`forecast_id`);

-- ========= production --> service (1 constraint(s)) =========
-- Requires: production schema, service schema
ALTER TABLE `manufacturing_ecm`.`production`.`hold` ADD CONSTRAINT `fk_production_hold_warranty_claim_id` FOREIGN KEY (`warranty_claim_id`) REFERENCES `manufacturing_ecm`.`service`.`warranty_claim`(`warranty_claim_id`);

-- ========= production --> technology (2 constraint(s)) =========
-- Requires: production schema, technology schema
ALTER TABLE `manufacturing_ecm`.`production`.`downtime_event` ADD CONSTRAINT `fk_production_downtime_event_service_ticket_id` FOREIGN KEY (`service_ticket_id`) REFERENCES `manufacturing_ecm`.`technology`.`service_ticket`(`service_ticket_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`iiot_machine_signal` ADD CONSTRAINT `fk_production_iiot_machine_signal_iiot_platform_id` FOREIGN KEY (`iiot_platform_id`) REFERENCES `manufacturing_ecm`.`technology`.`iiot_platform`(`iiot_platform_id`);

-- ========= production --> workforce (107 constraint(s)) =========
-- Requires: production schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`production`.`work_center` ADD CONSTRAINT `fk_production_work_center_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`work_center` ADD CONSTRAINT `fk_production_work_center_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`work_center` ADD CONSTRAINT `fk_production_work_center_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`work_center` ADD CONSTRAINT `fk_production_work_center_line_id` FOREIGN KEY (`line_id`) REFERENCES `manufacturing_ecm`.`workforce`.`line`(`line_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`work_center` ADD CONSTRAINT `fk_production_work_center_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`work_center` ADD CONSTRAINT `fk_production_work_center_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`routing` ADD CONSTRAINT `fk_production_routing_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`schedule` ADD CONSTRAINT `fk_production_schedule_line_id` FOREIGN KEY (`line_id`) REFERENCES `manufacturing_ecm`.`workforce`.`line`(`line_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`schedule` ADD CONSTRAINT `fk_production_schedule_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`schedule` ADD CONSTRAINT `fk_production_schedule_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`schedule` ADD CONSTRAINT `fk_production_schedule_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`planned_order` ADD CONSTRAINT `fk_production_planned_order_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`planned_order` ADD CONSTRAINT `fk_production_planned_order_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`planned_order` ADD CONSTRAINT `fk_production_planned_order_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`shop_order_operation` ADD CONSTRAINT `fk_production_shop_order_operation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`shop_order_operation` ADD CONSTRAINT `fk_production_shop_order_operation_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`production_confirmation` ADD CONSTRAINT `fk_production_production_confirmation_supervisor_employee_id` FOREIGN KEY (`supervisor_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`material_staging` ADD CONSTRAINT `fk_production_material_staging_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`order_status` ADD CONSTRAINT `fk_production_order_status_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`capacity_requirement` ADD CONSTRAINT `fk_production_capacity_requirement_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`version` ADD CONSTRAINT `fk_production_version_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`version` ADD CONSTRAINT `fk_production_version_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch` ADD CONSTRAINT `fk_production_batch_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch_genealogy` ADD CONSTRAINT `fk_production_batch_genealogy_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`batch_genealogy` ADD CONSTRAINT `fk_production_batch_genealogy_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`oee_event` ADD CONSTRAINT `fk_production_oee_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`oee_event` ADD CONSTRAINT `fk_production_oee_event_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`oee_event` ADD CONSTRAINT `fk_production_oee_event_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`oee_event` ADD CONSTRAINT `fk_production_oee_event_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`downtime_event` ADD CONSTRAINT `fk_production_downtime_event_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`downtime_event` ADD CONSTRAINT `fk_production_downtime_event_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`downtime_event` ADD CONSTRAINT `fk_production_downtime_event_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`downtime_event` ADD CONSTRAINT `fk_production_downtime_event_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`downtime_event` ADD CONSTRAINT `fk_production_downtime_event_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`downtime_event` ADD CONSTRAINT `fk_production_downtime_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`shift` ADD CONSTRAINT `fk_production_shift_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`changeover` ADD CONSTRAINT `fk_production_changeover_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`changeover` ADD CONSTRAINT `fk_production_changeover_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`changeover` ADD CONSTRAINT `fk_production_changeover_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`changeover` ADD CONSTRAINT `fk_production_changeover_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`changeover` ADD CONSTRAINT `fk_production_changeover_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`changeover` ADD CONSTRAINT `fk_production_changeover_supervisor_employee_id` FOREIGN KEY (`supervisor_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_capa_record_id` FOREIGN KEY (`capa_record_id`) REFERENCES `manufacturing_ecm`.`workforce`.`capa_record`(`capa_record_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`scrap_record` ADD CONSTRAINT `fk_production_scrap_record_supervisor_employee_id` FOREIGN KEY (`supervisor_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`bom_explosion` ADD CONSTRAINT `fk_production_bom_explosion_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`bom_explosion` ADD CONSTRAINT `fk_production_bom_explosion_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`bom_explosion` ADD CONSTRAINT `fk_production_bom_explosion_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`bom_explosion` ADD CONSTRAINT `fk_production_bom_explosion_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`takt_time_standard` ADD CONSTRAINT `fk_production_takt_time_standard_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`takt_time_standard` ADD CONSTRAINT `fk_production_takt_time_standard_line_id` FOREIGN KEY (`line_id`) REFERENCES `manufacturing_ecm`.`workforce`.`line`(`line_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`takt_time_standard` ADD CONSTRAINT `fk_production_takt_time_standard_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`hold` ADD CONSTRAINT `fk_production_hold_capa_record_id` FOREIGN KEY (`capa_record_id`) REFERENCES `manufacturing_ecm`.`workforce`.`capa_record`(`capa_record_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`hold` ADD CONSTRAINT `fk_production_hold_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`hold` ADD CONSTRAINT `fk_production_hold_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`hold` ADD CONSTRAINT `fk_production_hold_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`hold` ADD CONSTRAINT `fk_production_hold_initiator_employee_id` FOREIGN KEY (`initiator_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`hold` ADD CONSTRAINT `fk_production_hold_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`hold` ADD CONSTRAINT `fk_production_hold_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`hold` ADD CONSTRAINT `fk_production_hold_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`hold` ADD CONSTRAINT `fk_production_hold_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`hold` ADD CONSTRAINT `fk_production_hold_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`cost_estimate` ADD CONSTRAINT `fk_production_cost_estimate_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`cost_estimate` ADD CONSTRAINT `fk_production_cost_estimate_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`cost_estimate` ADD CONSTRAINT `fk_production_cost_estimate_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`cost_estimate` ADD CONSTRAINT `fk_production_cost_estimate_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`cost_estimate` ADD CONSTRAINT `fk_production_cost_estimate_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`cost_estimate` ADD CONSTRAINT `fk_production_cost_estimate_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`cost_estimate` ADD CONSTRAINT `fk_production_cost_estimate_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`order_type` ADD CONSTRAINT `fk_production_order_type_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`iiot_machine_signal` ADD CONSTRAINT `fk_production_iiot_machine_signal_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`iiot_machine_signal` ADD CONSTRAINT `fk_production_iiot_machine_signal_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`iiot_machine_signal` ADD CONSTRAINT `fk_production_iiot_machine_signal_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`operation` ADD CONSTRAINT `fk_production_operation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`operation` ADD CONSTRAINT `fk_production_operation_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`operation` ADD CONSTRAINT `fk_production_operation_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`plant_supplier_qualification` ADD CONSTRAINT `fk_production_plant_supplier_qualification_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`plant_supplier_qualification` ADD CONSTRAINT `fk_production_plant_supplier_qualification_plant_production_plant_id` FOREIGN KEY (`plant_production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`plant_supplier_qualification` ADD CONSTRAINT `fk_production_plant_supplier_qualification_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`plant_supplier_qualification` ADD CONSTRAINT `fk_production_plant_supplier_qualification_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`work_center_supplier_service` ADD CONSTRAINT `fk_production_work_center_supplier_service_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`line_qualification` ADD CONSTRAINT `fk_production_line_qualification_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`line_qualification` ADD CONSTRAINT `fk_production_line_qualification_line_id` FOREIGN KEY (`line_id`) REFERENCES `manufacturing_ecm`.`workforce`.`line`(`line_id`);
ALTER TABLE `manufacturing_ecm`.`production`.`line_permit_coverage` ADD CONSTRAINT `fk_production_line_permit_coverage_line_id` FOREIGN KEY (`line_id`) REFERENCES `manufacturing_ecm`.`workforce`.`line`(`line_id`);

-- ========= quality --> asset (1 constraint(s)) =========
-- Requires: quality schema, asset schema
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ADD CONSTRAINT `fk_quality_gauge_calibration_calibration_record_id` FOREIGN KEY (`calibration_record_id`) REFERENCES `manufacturing_ecm`.`asset`.`calibration_record`(`calibration_record_id`);

-- ========= quality --> billing (1 constraint(s)) =========
-- Requires: quality schema, billing schema
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ADD CONSTRAINT `fk_quality_scrap_rework_transaction_credit_note_id` FOREIGN KEY (`credit_note_id`) REFERENCES `manufacturing_ecm`.`billing`.`credit_note`(`credit_note_id`);

-- ========= quality --> compliance (1 constraint(s)) =========
-- Requires: quality schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_third_party_risk_id` FOREIGN KEY (`third_party_risk_id`) REFERENCES `manufacturing_ecm`.`compliance`.`third_party_risk`(`third_party_risk_id`);

-- ========= quality --> engineering (3 constraint(s)) =========
-- Requires: quality schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ADD CONSTRAINT `fk_quality_quality_capa_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`engineering`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ADD CONSTRAINT `fk_quality_quality_capa_eco_id` FOREIGN KEY (`eco_id`) REFERENCES `manufacturing_ecm`.`engineering`.`eco`(`eco_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ADD CONSTRAINT `fk_quality_apqp_project_project_id` FOREIGN KEY (`project_id`) REFERENCES `manufacturing_ecm`.`engineering`.`project`(`project_id`);

-- ========= quality --> hse (2 constraint(s)) =========
-- Requires: quality schema, hse schema
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_hazard_assessment_id` FOREIGN KEY (`hazard_assessment_id`) REFERENCES `manufacturing_ecm`.`hse`.`hazard_assessment`(`hazard_assessment_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_incident_id` FOREIGN KEY (`incident_id`) REFERENCES `manufacturing_ecm`.`hse`.`incident`(`incident_id`);

-- ========= quality --> logistics (2 constraint(s)) =========
-- Requires: quality schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_logistics_inbound_delivery_id` FOREIGN KEY (`logistics_inbound_delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery`(`logistics_inbound_delivery_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_logistics_inbound_delivery_id` FOREIGN KEY (`logistics_inbound_delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery`(`logistics_inbound_delivery_id`);

-- ========= quality --> order (1 constraint(s)) =========
-- Requires: quality schema, order schema
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_order_quotation_id` FOREIGN KEY (`order_quotation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_quotation`(`order_quotation_id`);

-- ========= quality --> production (3 constraint(s)) =========
-- Requires: quality schema, production schema
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_routing_id` FOREIGN KEY (`routing_id`) REFERENCES `manufacturing_ecm`.`production`.`routing`(`routing_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_routing_id` FOREIGN KEY (`routing_id`) REFERENCES `manufacturing_ecm`.`production`.`routing`(`routing_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ADD CONSTRAINT `fk_quality_gauge_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);

-- ========= quality --> service (1 constraint(s)) =========
-- Requires: quality schema, service schema
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_spare_parts_catalog_id` FOREIGN KEY (`spare_parts_catalog_id`) REFERENCES `manufacturing_ecm`.`service`.`spare_parts_catalog`(`spare_parts_catalog_id`);

-- ========= quality --> technology (5 constraint(s)) =========
-- Requires: quality schema, technology schema
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ADD CONSTRAINT `fk_quality_apqp_project_it_project_id` FOREIGN KEY (`it_project_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_project`(`it_project_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ADD CONSTRAINT `fk_quality_gauge_calibration_service_ticket_id` FOREIGN KEY (`service_ticket_id`) REFERENCES `manufacturing_ecm`.`technology`.`service_ticket`(`service_ticket_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_service_ticket_id` FOREIGN KEY (`service_ticket_id`) REFERENCES `manufacturing_ecm`.`technology`.`service_ticket`(`service_ticket_id`);

-- ========= quality --> workforce (81 constraint(s)) =========
-- Requires: quality schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_plan` ADD CONSTRAINT `fk_quality_inspection_plan_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_lot` ADD CONSTRAINT `fk_quality_inspection_lot_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`inspection_result` ADD CONSTRAINT `fk_quality_inspection_result_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ADD CONSTRAINT `fk_quality_usage_decision_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ADD CONSTRAINT `fk_quality_usage_decision_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`usage_decision` ADD CONSTRAINT `fk_quality_usage_decision_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ADD CONSTRAINT `fk_quality_quality_capa_capa_record_id` FOREIGN KEY (`capa_record_id`) REFERENCES `manufacturing_ecm`.`workforce`.`capa_record`(`capa_record_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ADD CONSTRAINT `fk_quality_quality_capa_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ADD CONSTRAINT `fk_quality_quality_capa_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`internal_order`(`internal_order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ADD CONSTRAINT `fk_quality_quality_capa_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_capa` ADD CONSTRAINT `fk_quality_quality_capa_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea` ADD CONSTRAINT `fk_quality_fmea_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fmea_action` ADD CONSTRAINT `fk_quality_fmea_action_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`control_plan` ADD CONSTRAINT `fk_quality_control_plan_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`ppap_submission` ADD CONSTRAINT `fk_quality_ppap_submission_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`fai_record` ADD CONSTRAINT `fk_quality_fai_record_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ADD CONSTRAINT `fk_quality_spc_chart_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_chart` ADD CONSTRAINT `fk_quality_spc_chart_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ADD CONSTRAINT `fk_quality_spc_sample_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`spc_sample` ADD CONSTRAINT `fk_quality_spc_sample_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`audit` ADD CONSTRAINT `fk_quality_audit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ADD CONSTRAINT `fk_quality_quality_audit_finding_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ADD CONSTRAINT `fk_quality_quality_audit_finding_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_audit_finding` ADD CONSTRAINT `fk_quality_quality_audit_finding_owner_employee_id` FOREIGN KEY (`owner_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ADD CONSTRAINT `fk_quality_apqp_project_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ADD CONSTRAINT `fk_quality_apqp_project_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`internal_order`(`internal_order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`apqp_project` ADD CONSTRAINT `fk_quality_apqp_project_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`characteristic` ADD CONSTRAINT `fk_quality_characteristic_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ADD CONSTRAINT `fk_quality_gauge_asset_register_id` FOREIGN KEY (`asset_register_id`) REFERENCES `manufacturing_ecm`.`workforce`.`asset_register`(`asset_register_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ADD CONSTRAINT `fk_quality_gauge_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge` ADD CONSTRAINT `fk_quality_gauge_it_asset_id` FOREIGN KEY (`it_asset_id`) REFERENCES `manufacturing_ecm`.`workforce`.`it_asset`(`it_asset_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ADD CONSTRAINT `fk_quality_gauge_calibration_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_calibration` ADD CONSTRAINT `fk_quality_gauge_calibration_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ADD CONSTRAINT `fk_quality_msa_study_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`msa_study` ADD CONSTRAINT `fk_quality_msa_study_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ADD CONSTRAINT `fk_quality_scrap_rework_transaction_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ADD CONSTRAINT `fk_quality_scrap_rework_transaction_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ADD CONSTRAINT `fk_quality_scrap_rework_transaction_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ADD CONSTRAINT `fk_quality_scrap_rework_transaction_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ADD CONSTRAINT `fk_quality_scrap_rework_transaction_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ADD CONSTRAINT `fk_quality_scrap_rework_transaction_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`scrap_rework_transaction` ADD CONSTRAINT `fk_quality_scrap_rework_transaction_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`work_order`(`work_order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`supplier_quality_event` ADD CONSTRAINT `fk_quality_supplier_quality_event_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`customer_complaint` ADD CONSTRAINT `fk_quality_customer_complaint_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`quality_notification` ADD CONSTRAINT `fk_quality_quality_notification_order_id` FOREIGN KEY (`order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`order`(`order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`certificate` ADD CONSTRAINT `fk_quality_certificate_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`qms_document` ADD CONSTRAINT `fk_quality_qms_document_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`project_team_member` ADD CONSTRAINT `fk_quality_project_team_member_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`gauge_loan` ADD CONSTRAINT `fk_quality_gauge_loan_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`quality`.`measurement_capability` ADD CONSTRAINT `fk_quality_measurement_capability_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);

-- ========= research --> asset (1 constraint(s)) =========
-- Requires: research schema, asset schema
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ADD CONSTRAINT `fk_research_prototype_asset_allocation_equipment_allocation_id` FOREIGN KEY (`equipment_allocation_id`) REFERENCES `manufacturing_ecm`.`asset`.`equipment_allocation`(`equipment_allocation_id`);

-- ========= research --> billing (1 constraint(s)) =========
-- Requires: research schema, billing schema
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ADD CONSTRAINT `fk_research_grant_funding_credit_note_id` FOREIGN KEY (`credit_note_id`) REFERENCES `manufacturing_ecm`.`billing`.`credit_note`(`credit_note_id`);

-- ========= research --> compliance (5 constraint(s)) =========
-- Requires: research schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ADD CONSTRAINT `fk_research_stage_gate_review_assessment_id` FOREIGN KEY (`assessment_id`) REFERENCES `manufacturing_ecm`.`compliance`.`assessment`(`assessment_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ADD CONSTRAINT `fk_research_rd_test_result_rohs_compliance_record_id` FOREIGN KEY (`rohs_compliance_record_id`) REFERENCES `manufacturing_ecm`.`compliance`.`rohs_compliance_record`(`rohs_compliance_record_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ADD CONSTRAINT `fk_research_partner_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `manufacturing_ecm`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ADD CONSTRAINT `fk_research_collaboration_agreement_data_privacy_record_id` FOREIGN KEY (`data_privacy_record_id`) REFERENCES `manufacturing_ecm`.`compliance`.`data_privacy_record`(`data_privacy_record_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ADD CONSTRAINT `fk_research_grant_funding_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `manufacturing_ecm`.`compliance`.`obligation`(`obligation_id`);

-- ========= research --> customer (1 constraint(s)) =========
-- Requires: research schema, customer schema
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ADD CONSTRAINT `fk_research_rd_test_result_case_id` FOREIGN KEY (`case_id`) REFERENCES `manufacturing_ecm`.`customer`.`case`(`case_id`);

-- ========= research --> engineering (3 constraint(s)) =========
-- Requires: research schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ADD CONSTRAINT `fk_research_experimental_bom_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`engineering`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ADD CONSTRAINT `fk_research_rd_test_result_design_validation_test_id` FOREIGN KEY (`design_validation_test_id`) REFERENCES `manufacturing_ecm`.`engineering`.`design_validation_test`(`design_validation_test_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ADD CONSTRAINT `fk_research_project_certification_engineering_regulatory_certification_id` FOREIGN KEY (`engineering_regulatory_certification_id`) REFERENCES `manufacturing_ecm`.`engineering`.`engineering_regulatory_certification`(`engineering_regulatory_certification_id`);

-- ========= research --> finance (1 constraint(s)) =========
-- Requires: research schema, finance schema
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ADD CONSTRAINT `fk_research_grant_funding_bank_account_id` FOREIGN KEY (`bank_account_id`) REFERENCES `manufacturing_ecm`.`finance`.`bank_account`(`bank_account_id`);

-- ========= research --> hse (5 constraint(s)) =========
-- Requires: research schema, hse schema
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_hazard_assessment_id` FOREIGN KEY (`hazard_assessment_id`) REFERENCES `manufacturing_ecm`.`hse`.`hazard_assessment`(`hazard_assessment_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ADD CONSTRAINT `fk_research_experimental_bom_chemical_substance_id` FOREIGN KEY (`chemical_substance_id`) REFERENCES `manufacturing_ecm`.`hse`.`chemical_substance`(`chemical_substance_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ADD CONSTRAINT `fk_research_rd_test_plan_safety_audit_id` FOREIGN KEY (`safety_audit_id`) REFERENCES `manufacturing_ecm`.`hse`.`safety_audit`(`safety_audit_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ADD CONSTRAINT `fk_research_lab_resource_ppe_requirement_id` FOREIGN KEY (`ppe_requirement_id`) REFERENCES `manufacturing_ecm`.`hse`.`ppe_requirement`(`ppe_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ADD CONSTRAINT `fk_research_rd_risk_regulatory_obligation_id` FOREIGN KEY (`regulatory_obligation_id`) REFERENCES `manufacturing_ecm`.`hse`.`regulatory_obligation`(`regulatory_obligation_id`);

-- ========= research --> inventory (1 constraint(s)) =========
-- Requires: research schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`inventory`.`serialized_unit`(`serialized_unit_id`);

-- ========= research --> logistics (2 constraint(s)) =========
-- Requires: research schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_packaging_id` FOREIGN KEY (`packaging_id`) REFERENCES `manufacturing_ecm`.`logistics`.`packaging`(`packaging_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ADD CONSTRAINT `fk_research_rd_expense_freight_invoice_id` FOREIGN KEY (`freight_invoice_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_invoice`(`freight_invoice_id`);

-- ========= research --> procurement (4 constraint(s)) =========
-- Requires: research schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_procurement_goods_receipt_id` FOREIGN KEY (`procurement_goods_receipt_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_goods_receipt`(`procurement_goods_receipt_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ADD CONSTRAINT `fk_research_experimental_bom_line_procurement_material_info_record_id` FOREIGN KEY (`procurement_material_info_record_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_material_info_record`(`procurement_material_info_record_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ADD CONSTRAINT `fk_research_collaboration_agreement_procurement_contract_id` FOREIGN KEY (`procurement_contract_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_contract`(`procurement_contract_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ADD CONSTRAINT `fk_research_rd_expense_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier`(`supplier_id`);

-- ========= research --> product (1 constraint(s)) =========
-- Requires: research schema, product schema
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ADD CONSTRAINT `fk_research_rd_test_result_product_regulatory_certification_id` FOREIGN KEY (`product_regulatory_certification_id`) REFERENCES `manufacturing_ecm`.`product`.`product_regulatory_certification`(`product_regulatory_certification_id`);

-- ========= research --> production (1 constraint(s)) =========
-- Requires: research schema, production schema
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ADD CONSTRAINT `fk_research_rd_test_plan_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);

-- ========= research --> quality (4 constraint(s)) =========
-- Requires: research schema, quality schema
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ADD CONSTRAINT `fk_research_stage_gate_review_apqp_project_id` FOREIGN KEY (`apqp_project_id`) REFERENCES `manufacturing_ecm`.`quality`.`apqp_project`(`apqp_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `manufacturing_ecm`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ADD CONSTRAINT `fk_research_rd_test_plan_fmea_id` FOREIGN KEY (`fmea_id`) REFERENCES `manufacturing_ecm`.`quality`.`fmea`(`fmea_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ADD CONSTRAINT `fk_research_rd_test_result_characteristic_id` FOREIGN KEY (`characteristic_id`) REFERENCES `manufacturing_ecm`.`quality`.`characteristic`(`characteristic_id`);

-- ========= research --> sales (1 constraint(s)) =========
-- Requires: research schema, sales schema
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ADD CONSTRAINT `fk_research_competitive_intelligence_competitor_id` FOREIGN KEY (`competitor_id`) REFERENCES `manufacturing_ecm`.`sales`.`competitor`(`competitor_id`);

-- ========= research --> service (1 constraint(s)) =========
-- Requires: research schema, service schema
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_installation_record_id` FOREIGN KEY (`installation_record_id`) REFERENCES `manufacturing_ecm`.`service`.`installation_record`(`installation_record_id`);

-- ========= research --> technology (1 constraint(s)) =========
-- Requires: research schema, technology schema
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ADD CONSTRAINT `fk_research_rd_document_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);

-- ========= research --> workforce (61 constraint(s)) =========
-- Requires: research schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ADD CONSTRAINT `fk_research_stage_gate_review_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_production_plant_id` FOREIGN KEY (`production_plant_id`) REFERENCES `manufacturing_ecm`.`workforce`.`production_plant`(`production_plant_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ADD CONSTRAINT `fk_research_research_prototype_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ADD CONSTRAINT `fk_research_experimental_bom_compliance_reach_substance_declaration_id` FOREIGN KEY (`compliance_reach_substance_declaration_id`) REFERENCES `manufacturing_ecm`.`workforce`.`compliance_reach_substance_declaration`(`compliance_reach_substance_declaration_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ADD CONSTRAINT `fk_research_experimental_bom_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ADD CONSTRAINT `fk_research_experimental_bom_line_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ADD CONSTRAINT `fk_research_experimental_bom_line_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ADD CONSTRAINT `fk_research_experimental_bom_line_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ADD CONSTRAINT `fk_research_rd_test_plan_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ADD CONSTRAINT `fk_research_rd_test_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ADD CONSTRAINT `fk_research_rd_test_plan_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ADD CONSTRAINT `fk_research_rd_test_plan_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ADD CONSTRAINT `fk_research_rd_test_plan_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ADD CONSTRAINT `fk_research_rd_test_result_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ADD CONSTRAINT `fk_research_rd_test_result_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ADD CONSTRAINT `fk_research_rd_test_result_test_engineer_employee_id` FOREIGN KEY (`test_engineer_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ADD CONSTRAINT `fk_research_rd_test_result_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ADD CONSTRAINT `fk_research_ip_asset_asset_register_id` FOREIGN KEY (`asset_register_id`) REFERENCES `manufacturing_ecm`.`workforce`.`asset_register`(`asset_register_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ADD CONSTRAINT `fk_research_ip_asset_export_classification_id` FOREIGN KEY (`export_classification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`export_classification`(`export_classification_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ADD CONSTRAINT `fk_research_ip_asset_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ADD CONSTRAINT `fk_research_ip_asset_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ADD CONSTRAINT `fk_research_patent_filing_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ADD CONSTRAINT `fk_research_collaboration_agreement_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ADD CONSTRAINT `fk_research_rd_budget_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ADD CONSTRAINT `fk_research_rd_budget_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ADD CONSTRAINT `fk_research_rd_expense_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ADD CONSTRAINT `fk_research_rd_expense_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ADD CONSTRAINT `fk_research_rd_expense_cost_object_internal_order_id` FOREIGN KEY (`cost_object_internal_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`internal_order`(`internal_order_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ADD CONSTRAINT `fk_research_rd_expense_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ADD CONSTRAINT `fk_research_rd_expense_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`internal_order`(`internal_order_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ADD CONSTRAINT `fk_research_rd_expense_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ADD CONSTRAINT `fk_research_rd_expense_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ADD CONSTRAINT `fk_research_grant_funding_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ADD CONSTRAINT `fk_research_lab_resource_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ADD CONSTRAINT `fk_research_lab_resource_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ADD CONSTRAINT `fk_research_lab_resource_responsible_lab_manager_employee_id` FOREIGN KEY (`responsible_lab_manager_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ADD CONSTRAINT `fk_research_lab_booking_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ADD CONSTRAINT `fk_research_lab_booking_it_asset_id` FOREIGN KEY (`it_asset_id`) REFERENCES `manufacturing_ecm`.`workforce`.`it_asset`(`it_asset_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ADD CONSTRAINT `fk_research_lab_booking_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ADD CONSTRAINT `fk_research_lab_booking_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ADD CONSTRAINT `fk_research_rd_milestone_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ADD CONSTRAINT `fk_research_technology_readiness_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ADD CONSTRAINT `fk_research_technology_readiness_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ADD CONSTRAINT `fk_research_technology_readiness_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ADD CONSTRAINT `fk_research_rd_document_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ADD CONSTRAINT `fk_research_rd_document_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ADD CONSTRAINT `fk_research_competitive_intelligence_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ADD CONSTRAINT `fk_research_rd_risk_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ADD CONSTRAINT `fk_research_rd_risk_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ADD CONSTRAINT `fk_research_project_partner_assignment_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ADD CONSTRAINT `fk_research_prototype_sourcing_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ADD CONSTRAINT `fk_research_prototype_asset_allocation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ADD CONSTRAINT `fk_research_prototype_asset_allocation_it_asset_id` FOREIGN KEY (`it_asset_id`) REFERENCES `manufacturing_ecm`.`workforce`.`it_asset`(`it_asset_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ADD CONSTRAINT `fk_research_project_certification_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);

-- ========= sales --> compliance (1 constraint(s)) =========
-- Requires: sales schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`sales`.`special_pricing_request` ADD CONSTRAINT `fk_sales_special_pricing_request_exception_id` FOREIGN KEY (`exception_id`) REFERENCES `manufacturing_ecm`.`compliance`.`exception`(`exception_id`);

-- ========= sales --> customer (3 constraint(s)) =========
-- Requires: sales schema, customer schema
ALTER TABLE `manufacturing_ecm`.`sales`.`lead` ADD CONSTRAINT `fk_sales_lead_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`special_pricing_request` ADD CONSTRAINT `fk_sales_special_pricing_request_pricing_agreement_id` FOREIGN KEY (`pricing_agreement_id`) REFERENCES `manufacturing_ecm`.`customer`.`pricing_agreement`(`pricing_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);

-- ========= sales --> finance (1 constraint(s)) =========
-- Requires: sales schema, finance schema
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_fiscal_period_id` FOREIGN KEY (`fiscal_period_id`) REFERENCES `manufacturing_ecm`.`finance`.`fiscal_period`(`fiscal_period_id`);

-- ========= sales --> logistics (2 constraint(s)) =========
-- Requires: sales schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`sales`.`special_pricing_request` ADD CONSTRAINT `fk_sales_special_pricing_request_transport_zone_id` FOREIGN KEY (`transport_zone_id`) REFERENCES `manufacturing_ecm`.`logistics`.`transport_zone`(`transport_zone_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_transport_zone_id` FOREIGN KEY (`transport_zone_id`) REFERENCES `manufacturing_ecm`.`logistics`.`transport_zone`(`transport_zone_id`);

-- ========= sales --> production (1 constraint(s)) =========
-- Requires: sales schema, production schema
ALTER TABLE `manufacturing_ecm`.`sales`.`special_pricing_request` ADD CONSTRAINT `fk_sales_special_pricing_request_cost_estimate_id` FOREIGN KEY (`cost_estimate_id`) REFERENCES `manufacturing_ecm`.`production`.`cost_estimate`(`cost_estimate_id`);

-- ========= sales --> quality (1 constraint(s)) =========
-- Requires: sales schema, quality schema
ALTER TABLE `manufacturing_ecm`.`sales`.`win_loss_record` ADD CONSTRAINT `fk_sales_win_loss_record_audit_id` FOREIGN KEY (`audit_id`) REFERENCES `manufacturing_ecm`.`quality`.`audit`(`audit_id`);

-- ========= sales --> research (1 constraint(s)) =========
-- Requires: sales schema, research schema
ALTER TABLE `manufacturing_ecm`.`sales`.`special_pricing_request` ADD CONSTRAINT `fk_sales_special_pricing_request_research_prototype_id` FOREIGN KEY (`research_prototype_id`) REFERENCES `manufacturing_ecm`.`research`.`research_prototype`(`research_prototype_id`);

-- ========= sales --> service (3 constraint(s)) =========
-- Requires: sales schema, service schema
ALTER TABLE `manufacturing_ecm`.`sales`.`lead` ADD CONSTRAINT `fk_sales_lead_request_id` FOREIGN KEY (`request_id`) REFERENCES `manufacturing_ecm`.`service`.`request`(`request_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`partner_territory_authorization` ADD CONSTRAINT `fk_sales_partner_territory_authorization_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `manufacturing_ecm`.`service`.`service_territory`(`service_territory_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`partner_territory_authorization` ADD CONSTRAINT `fk_sales_partner_territory_authorization_territory_service_territory_id` FOREIGN KEY (`territory_service_territory_id`) REFERENCES `manufacturing_ecm`.`service`.`service_territory`(`service_territory_id`);

-- ========= sales --> technology (5 constraint(s)) =========
-- Requires: sales schema, technology schema
ALTER TABLE `manufacturing_ecm`.`sales`.`special_pricing_request` ADD CONSTRAINT `fk_sales_special_pricing_request_it_project_id` FOREIGN KEY (`it_project_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_project`(`it_project_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`deal_registration` ADD CONSTRAINT `fk_sales_deal_registration_digital_initiative_id` FOREIGN KEY (`digital_initiative_id`) REFERENCES `manufacturing_ecm`.`technology`.`digital_initiative`(`digital_initiative_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`partner_certification` ADD CONSTRAINT `fk_sales_partner_certification_standard_id` FOREIGN KEY (`standard_id`) REFERENCES `manufacturing_ecm`.`technology`.`standard`(`standard_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`partner_certification` ADD CONSTRAINT `fk_sales_partner_certification_technology_standard_id` FOREIGN KEY (`technology_standard_id`) REFERENCES `manufacturing_ecm`.`technology`.`standard`(`standard_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`service_inclusion` ADD CONSTRAINT `fk_sales_service_inclusion_it_service_id` FOREIGN KEY (`it_service_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_service`(`it_service_id`);

-- ========= sales --> workforce (76 constraint(s)) =========
-- Requires: sales schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`sales`.`lead` ADD CONSTRAINT `fk_sales_lead_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`lead` ADD CONSTRAINT `fk_sales_lead_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`account_plan` ADD CONSTRAINT `fk_sales_account_plan_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`account_plan` ADD CONSTRAINT `fk_sales_account_plan_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`account_plan` ADD CONSTRAINT `fk_sales_account_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`account_plan` ADD CONSTRAINT `fk_sales_account_plan_owner_employee_id` FOREIGN KEY (`owner_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`sales_territory` ADD CONSTRAINT `fk_sales_sales_territory_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`sales_territory` ADD CONSTRAINT `fk_sales_sales_territory_assigned_rep_employee_id` FOREIGN KEY (`assigned_rep_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`sales_territory` ADD CONSTRAINT `fk_sales_sales_territory_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`territory_assignment` ADD CONSTRAINT `fk_sales_territory_assignment_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`territory_assignment` ADD CONSTRAINT `fk_sales_territory_assignment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`territory_assignment` ADD CONSTRAINT `fk_sales_territory_assignment_sales_rep_employee_id` FOREIGN KEY (`sales_rep_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`quota` ADD CONSTRAINT `fk_sales_quota_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`commission_record` ADD CONSTRAINT `fk_sales_commission_record_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`commission_record` ADD CONSTRAINT `fk_sales_commission_record_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`commission_record` ADD CONSTRAINT `fk_sales_commission_record_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`commission_record` ADD CONSTRAINT `fk_sales_commission_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`commission_record` ADD CONSTRAINT `fk_sales_commission_record_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`commission_record` ADD CONSTRAINT `fk_sales_commission_record_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`sales_price_list` ADD CONSTRAINT `fk_sales_sales_price_list_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`special_pricing_request` ADD CONSTRAINT `fk_sales_special_pricing_request_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`special_pricing_request` ADD CONSTRAINT `fk_sales_special_pricing_request_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`special_pricing_request` ADD CONSTRAINT `fk_sales_special_pricing_request_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`special_pricing_request` ADD CONSTRAINT `fk_sales_special_pricing_request_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`special_pricing_request` ADD CONSTRAINT `fk_sales_special_pricing_request_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`special_pricing_request` ADD CONSTRAINT `fk_sales_special_pricing_request_profit_center_id` FOREIGN KEY (`profit_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`profit_center`(`profit_center_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`special_pricing_request` ADD CONSTRAINT `fk_sales_special_pricing_request_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_inventory_sku_id` FOREIGN KEY (`inventory_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`inventory_sku`(`inventory_sku_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`forecast` ADD CONSTRAINT `fk_sales_forecast_submitter_employee_id` FOREIGN KEY (`submitter_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`deal_registration` ADD CONSTRAINT `fk_sales_deal_registration_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`deal_registration` ADD CONSTRAINT `fk_sales_deal_registration_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`deal_registration` ADD CONSTRAINT `fk_sales_deal_registration_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`activity` ADD CONSTRAINT `fk_sales_activity_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`opportunity_competitor` ADD CONSTRAINT `fk_sales_opportunity_competitor_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`team` ADD CONSTRAINT `fk_sales_team_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`team` ADD CONSTRAINT `fk_sales_team_application_engineer_employee_id` FOREIGN KEY (`application_engineer_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`team` ADD CONSTRAINT `fk_sales_team_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`team` ADD CONSTRAINT `fk_sales_team_commercial_manager_employee_id` FOREIGN KEY (`commercial_manager_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`team` ADD CONSTRAINT `fk_sales_team_lead_employee_id` FOREIGN KEY (`lead_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`team` ADD CONSTRAINT `fk_sales_team_manager_employee_id` FOREIGN KEY (`manager_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`team` ADD CONSTRAINT `fk_sales_team_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`team` ADD CONSTRAINT `fk_sales_team_solution_architect_employee_id` FOREIGN KEY (`solution_architect_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`opportunity_stage_history` ADD CONSTRAINT `fk_sales_opportunity_stage_history_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`opportunity_stage_history` ADD CONSTRAINT `fk_sales_opportunity_stage_history_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`rebate_agreement` ADD CONSTRAINT `fk_sales_rebate_agreement_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`rebate_agreement` ADD CONSTRAINT `fk_sales_rebate_agreement_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`rebate_agreement` ADD CONSTRAINT `fk_sales_rebate_agreement_legal_entity_id` FOREIGN KEY (`legal_entity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`legal_entity`(`legal_entity_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`rebate_agreement` ADD CONSTRAINT `fk_sales_rebate_agreement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`rebate_accrual` ADD CONSTRAINT `fk_sales_rebate_accrual_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`campaign` ADD CONSTRAINT `fk_sales_campaign_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`campaign` ADD CONSTRAINT `fk_sales_campaign_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`win_loss_record` ADD CONSTRAINT `fk_sales_win_loss_record_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`win_loss_record` ADD CONSTRAINT `fk_sales_win_loss_record_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`win_loss_record` ADD CONSTRAINT `fk_sales_win_loss_record_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`win_loss_record` ADD CONSTRAINT `fk_sales_win_loss_record_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`win_loss_record` ADD CONSTRAINT `fk_sales_win_loss_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`win_loss_record` ADD CONSTRAINT `fk_sales_win_loss_record_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`win_loss_record` ADD CONSTRAINT `fk_sales_win_loss_record_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`opportunity_line` ADD CONSTRAINT `fk_sales_opportunity_line_catalog_item_id` FOREIGN KEY (`catalog_item_id`) REFERENCES `manufacturing_ecm`.`workforce`.`catalog_item`(`catalog_item_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`opportunity_line` ADD CONSTRAINT `fk_sales_opportunity_line_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`partner_supplier_relationship` ADD CONSTRAINT `fk_sales_partner_supplier_relationship_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`partner_supplier_relationship` ADD CONSTRAINT `fk_sales_partner_supplier_relationship_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`partner_territory_authorization` ADD CONSTRAINT `fk_sales_partner_territory_authorization_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`partner_territory_authorization` ADD CONSTRAINT `fk_sales_partner_territory_authorization_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`partner_certification` ADD CONSTRAINT `fk_sales_partner_certification_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`partner_rd_collaboration` ADD CONSTRAINT `fk_sales_partner_rd_collaboration_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`partner_rd_collaboration` ADD CONSTRAINT `fk_sales_partner_rd_collaboration_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`opportunity_supplier_sourcing` ADD CONSTRAINT `fk_sales_opportunity_supplier_sourcing_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`opportunity_supplier_sourcing` ADD CONSTRAINT `fk_sales_opportunity_supplier_sourcing_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`sales`.`service_inclusion` ADD CONSTRAINT `fk_sales_service_inclusion_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);

-- ========= service --> asset (1 constraint(s)) =========
-- Requires: service schema, asset schema
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_warranty_id` FOREIGN KEY (`warranty_id`) REFERENCES `manufacturing_ecm`.`asset`.`warranty`(`warranty_id`);

-- ========= service --> billing (1 constraint(s)) =========
-- Requires: service schema, billing schema
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ADD CONSTRAINT `fk_service_service_quotation_proforma_invoice_id` FOREIGN KEY (`proforma_invoice_id`) REFERENCES `manufacturing_ecm`.`billing`.`proforma_invoice`(`proforma_invoice_id`);

-- ========= service --> compliance (2 constraint(s)) =========
-- Requires: service schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ADD CONSTRAINT `fk_service_technician_training_id` FOREIGN KEY (`training_id`) REFERENCES `manufacturing_ecm`.`compliance`.`training`(`training_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ADD CONSTRAINT `fk_service_spare_parts_catalog_rohs_compliance_record_id` FOREIGN KEY (`rohs_compliance_record_id`) REFERENCES `manufacturing_ecm`.`compliance`.`rohs_compliance_record`(`rohs_compliance_record_id`);

-- ========= service --> finance (2 constraint(s)) =========
-- Requires: service schema, finance schema
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ADD CONSTRAINT `fk_service_service_invoice_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `manufacturing_ecm`.`finance`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_ap_invoice_id` FOREIGN KEY (`ap_invoice_id`) REFERENCES `manufacturing_ecm`.`finance`.`ap_invoice`(`ap_invoice_id`);

-- ========= service --> hse (2 constraint(s)) =========
-- Requires: service schema, hse schema
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_environmental_permit_id` FOREIGN KEY (`environmental_permit_id`) REFERENCES `manufacturing_ecm`.`hse`.`environmental_permit`(`environmental_permit_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_incident_id` FOREIGN KEY (`incident_id`) REFERENCES `manufacturing_ecm`.`hse`.`incident`(`incident_id`);

-- ========= service --> inventory (2 constraint(s)) =========
-- Requires: service schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`inventory`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`inventory`.`serialized_unit`(`serialized_unit_id`);

-- ========= service --> logistics (2 constraint(s)) =========
-- Requires: service schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_delivery_id` FOREIGN KEY (`delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`delivery`(`delivery_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_logistics_inbound_delivery_id` FOREIGN KEY (`logistics_inbound_delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery`(`logistics_inbound_delivery_id`);

-- ========= service --> procurement (1 constraint(s)) =========
-- Requires: service schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_procurement_purchase_requisition_id` FOREIGN KEY (`procurement_purchase_requisition_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition`(`procurement_purchase_requisition_id`);

-- ========= service --> production (3 constraint(s)) =========
-- Requires: service schema, production schema
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);

-- ========= service --> quality (5 constraint(s)) =========
-- Requires: service schema, quality schema
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_fai_record_id` FOREIGN KEY (`fai_record_id`) REFERENCES `manufacturing_ecm`.`quality`.`fai_record`(`fai_record_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_inspection_lot_id` FOREIGN KEY (`inspection_lot_id`) REFERENCES `manufacturing_ecm`.`quality`.`inspection_lot`(`inspection_lot_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_usage_decision_id` FOREIGN KEY (`usage_decision_id`) REFERENCES `manufacturing_ecm`.`quality`.`usage_decision`(`usage_decision_id`);

-- ========= service --> research (1 constraint(s)) =========
-- Requires: service schema, research schema
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ADD CONSTRAINT `fk_service_feedback_innovation_pipeline_id` FOREIGN KEY (`innovation_pipeline_id`) REFERENCES `manufacturing_ecm`.`research`.`innovation_pipeline`(`innovation_pipeline_id`);

-- ========= service --> technology (7 constraint(s)) =========
-- Requires: service schema, technology schema
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ADD CONSTRAINT `fk_service_remote_support_session_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ADD CONSTRAINT `fk_service_escalation_service_ticket_id` FOREIGN KEY (`service_ticket_id`) REFERENCES `manufacturing_ecm`.`technology`.`service_ticket`(`service_ticket_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);

-- ========= service --> workforce (88 constraint(s)) =========
-- Requires: service schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`service`.`request` ADD CONSTRAINT `fk_service_request_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`request` ADD CONSTRAINT `fk_service_request_line_id` FOREIGN KEY (`line_id`) REFERENCES `manufacturing_ecm`.`workforce`.`line`(`line_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`request` ADD CONSTRAINT `fk_service_request_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_capa_record_id` FOREIGN KEY (`capa_record_id`) REFERENCES `manufacturing_ecm`.`workforce`.`capa_record`(`capa_record_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_ncr_id` FOREIGN KEY (`ncr_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ncr`(`ncr_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`warranty_claim` ADD CONSTRAINT `fk_service_warranty_claim_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ADD CONSTRAINT `fk_service_contract_line_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ADD CONSTRAINT `fk_service_contract_line_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`contract_line` ADD CONSTRAINT `fk_service_contract_line_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ADD CONSTRAINT `fk_service_sla_tracking_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ADD CONSTRAINT `fk_service_sla_tracking_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`sla_tracking` ADD CONSTRAINT `fk_service_sla_tracking_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`technician` ADD CONSTRAINT `fk_service_technician_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_territory` ADD CONSTRAINT `fk_service_service_territory_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ADD CONSTRAINT `fk_service_dispatch_schedule_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ADD CONSTRAINT `fk_service_dispatch_schedule_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`dispatch_schedule` ADD CONSTRAINT `fk_service_dispatch_schedule_technician_employee_id` FOREIGN KEY (`technician_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`shipment`(`shipment_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_spare_part_id` FOREIGN KEY (`spare_part_id`) REFERENCES `manufacturing_ecm`.`workforce`.`spare_part`(`spare_part_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_request` ADD CONSTRAINT `fk_service_spare_parts_request_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ADD CONSTRAINT `fk_service_spare_parts_catalog_compliance_reach_substance_declaration_id` FOREIGN KEY (`compliance_reach_substance_declaration_id`) REFERENCES `manufacturing_ecm`.`workforce`.`compliance_reach_substance_declaration`(`compliance_reach_substance_declaration_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ADD CONSTRAINT `fk_service_spare_parts_catalog_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`spare_parts_catalog` ADD CONSTRAINT `fk_service_spare_parts_catalog_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_functional_location_id` FOREIGN KEY (`functional_location_id`) REFERENCES `manufacturing_ecm`.`workforce`.`functional_location`(`functional_location_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_product_certification_id` FOREIGN KEY (`product_certification_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_certification`(`product_certification_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`installation_record` ADD CONSTRAINT `fk_service_installation_record_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ADD CONSTRAINT `fk_service_remote_support_session_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ADD CONSTRAINT `fk_service_remote_support_session_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ADD CONSTRAINT `fk_service_remote_support_session_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ADD CONSTRAINT `fk_service_remote_support_session_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ADD CONSTRAINT `fk_service_remote_support_session_ot_system_id` FOREIGN KEY (`ot_system_id`) REFERENCES `manufacturing_ecm`.`workforce`.`ot_system`(`ot_system_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`remote_support_session` ADD CONSTRAINT `fk_service_remote_support_session_support_engineer_employee_id` FOREIGN KEY (`support_engineer_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`report` ADD CONSTRAINT `fk_service_report_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ADD CONSTRAINT `fk_service_escalation_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ADD CONSTRAINT `fk_service_escalation_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`escalation` ADD CONSTRAINT `fk_service_escalation_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ADD CONSTRAINT `fk_service_nps_survey_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`nps_survey` ADD CONSTRAINT `fk_service_nps_survey_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ADD CONSTRAINT `fk_service_entitlement_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ADD CONSTRAINT `fk_service_entitlement_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ADD CONSTRAINT `fk_service_entitlement_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`entitlement` ADD CONSTRAINT `fk_service_entitlement_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ADD CONSTRAINT `fk_service_service_quotation_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ADD CONSTRAINT `fk_service_service_quotation_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ADD CONSTRAINT `fk_service_service_quotation_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ADD CONSTRAINT `fk_service_service_quotation_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ADD CONSTRAINT `fk_service_service_quotation_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_quotation` ADD CONSTRAINT `fk_service_service_quotation_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ADD CONSTRAINT `fk_service_service_invoice_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ADD CONSTRAINT `fk_service_service_invoice_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ADD CONSTRAINT `fk_service_service_invoice_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`service_invoice` ADD CONSTRAINT `fk_service_service_invoice_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ADD CONSTRAINT `fk_service_knowledge_article_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ADD CONSTRAINT `fk_service_knowledge_article_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`knowledge_article` ADD CONSTRAINT `fk_service_knowledge_article_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ADD CONSTRAINT `fk_service_feedback_contract_id` FOREIGN KEY (`contract_id`) REFERENCES `manufacturing_ecm`.`workforce`.`contract`(`contract_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ADD CONSTRAINT `fk_service_feedback_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`feedback` ADD CONSTRAINT `fk_service_feedback_field_service_order_id` FOREIGN KEY (`field_service_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`field_service_order`(`field_service_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_component_id` FOREIGN KEY (`component_id`) REFERENCES `manufacturing_ecm`.`workforce`.`component`(`component_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_procurement_supplier_id` FOREIGN KEY (`procurement_supplier_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_supplier`(`procurement_supplier_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_product_sku_id` FOREIGN KEY (`product_sku_id`) REFERENCES `manufacturing_ecm`.`workforce`.`product_sku`(`product_sku_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_sales_order_id` FOREIGN KEY (`sales_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_order`(`sales_order_id`);
ALTER TABLE `manufacturing_ecm`.`service`.`product_return` ADD CONSTRAINT `fk_service_product_return_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);

-- ========= technology --> hse (1 constraint(s)) =========
-- Requires: technology schema, hse schema
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ADD CONSTRAINT `fk_technology_it_service_outage_incident_id` FOREIGN KEY (`incident_id`) REFERENCES `manufacturing_ecm`.`hse`.`incident`(`incident_id`);

-- ========= technology --> procurement (2 constraint(s)) =========
-- Requires: technology schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ADD CONSTRAINT `fk_technology_technology_change_request_procurement_purchase_requisition_id` FOREIGN KEY (`procurement_purchase_requisition_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_purchase_requisition`(`procurement_purchase_requisition_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ADD CONSTRAINT `fk_technology_software_license_procurement_contract_id` FOREIGN KEY (`procurement_contract_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_contract`(`procurement_contract_id`);

-- ========= technology --> sales (1 constraint(s)) =========
-- Requires: technology schema, sales schema
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ADD CONSTRAINT `fk_technology_digital_initiative_account_plan_id` FOREIGN KEY (`account_plan_id`) REFERENCES `manufacturing_ecm`.`sales`.`account_plan`(`account_plan_id`);

-- ========= technology --> workforce (22 constraint(s)) =========
-- Requires: technology schema, workforce schema
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ADD CONSTRAINT `fk_technology_service_ticket_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `manufacturing_ecm`.`workforce`.`equipment`(`equipment_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ADD CONSTRAINT `fk_technology_service_ticket_procurement_purchase_order_id` FOREIGN KEY (`procurement_purchase_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`procurement_purchase_order`(`procurement_purchase_order_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ADD CONSTRAINT `fk_technology_network_device_it_asset_id` FOREIGN KEY (`it_asset_id`) REFERENCES `manufacturing_ecm`.`workforce`.`it_asset`(`it_asset_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ADD CONSTRAINT `fk_technology_software_license_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ADD CONSTRAINT `fk_technology_software_license_asset_register_id` FOREIGN KEY (`asset_register_id`) REFERENCES `manufacturing_ecm`.`workforce`.`asset_register`(`asset_register_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ADD CONSTRAINT `fk_technology_it_project_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `manufacturing_ecm`.`workforce`.`internal_order`(`internal_order_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ADD CONSTRAINT `fk_technology_it_project_rd_project_id` FOREIGN KEY (`rd_project_id`) REFERENCES `manufacturing_ecm`.`workforce`.`rd_project`(`rd_project_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ADD CONSTRAINT `fk_technology_it_project_sales_opportunity_id` FOREIGN KEY (`sales_opportunity_id`) REFERENCES `manufacturing_ecm`.`workforce`.`sales_opportunity`(`sales_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ADD CONSTRAINT `fk_technology_digital_initiative_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ADD CONSTRAINT `fk_technology_it_contract_channel_partner_id` FOREIGN KEY (`channel_partner_id`) REFERENCES `manufacturing_ecm`.`workforce`.`channel_partner`(`channel_partner_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ADD CONSTRAINT `fk_technology_it_contract_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`gl_account`(`gl_account_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ADD CONSTRAINT `fk_technology_vulnerability_it_asset_id` FOREIGN KEY (`it_asset_id`) REFERENCES `manufacturing_ecm`.`workforce`.`it_asset`(`it_asset_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ADD CONSTRAINT `fk_technology_patch_record_it_asset_id` FOREIGN KEY (`it_asset_id`) REFERENCES `manufacturing_ecm`.`workforce`.`it_asset`(`it_asset_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ADD CONSTRAINT `fk_technology_it_service_outage_account_id` FOREIGN KEY (`account_id`) REFERENCES `manufacturing_ecm`.`workforce`.`account`(`account_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ADD CONSTRAINT `fk_technology_it_service_outage_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ADD CONSTRAINT `fk_technology_user_access_request_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ADD CONSTRAINT `fk_technology_user_access_request_beneficiary_employee_id` FOREIGN KEY (`beneficiary_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ADD CONSTRAINT `fk_technology_user_access_request_requester_employee_id` FOREIGN KEY (`requester_employee_id`) REFERENCES `manufacturing_ecm`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ADD CONSTRAINT `fk_technology_data_integration_application_id` FOREIGN KEY (`application_id`) REFERENCES `manufacturing_ecm`.`workforce`.`application`(`application_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ADD CONSTRAINT `fk_technology_data_integration_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `manufacturing_ecm`.`workforce`.`warehouse`(`warehouse_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ADD CONSTRAINT `fk_technology_it_cost_allocation_billing_invoice_id` FOREIGN KEY (`billing_invoice_id`) REFERENCES `manufacturing_ecm`.`workforce`.`billing_invoice`(`billing_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ADD CONSTRAINT `fk_technology_it_cost_allocation_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `manufacturing_ecm`.`workforce`.`cost_center`(`cost_center_id`);

-- ========= workforce --> asset (8 constraint(s)) =========
-- Requires: workforce schema, asset schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`equipment` ADD CONSTRAINT `fk_workforce_equipment_class_id` FOREIGN KEY (`class_id`) REFERENCES `manufacturing_ecm`.`asset`.`class`(`class_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`work_order` ADD CONSTRAINT `fk_workforce_work_order_asset_notification_id` FOREIGN KEY (`asset_notification_id`) REFERENCES `manufacturing_ecm`.`asset`.`asset_notification`(`asset_notification_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`work_order` ADD CONSTRAINT `fk_workforce_work_order_class_id` FOREIGN KEY (`class_id`) REFERENCES `manufacturing_ecm`.`asset`.`class`(`class_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`work_order` ADD CONSTRAINT `fk_workforce_work_order_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `manufacturing_ecm`.`asset`.`maintenance_plan`(`maintenance_plan_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`work_order` ADD CONSTRAINT `fk_workforce_work_order_shutdown_plan_id` FOREIGN KEY (`shutdown_plan_id`) REFERENCES `manufacturing_ecm`.`asset`.`shutdown_plan`(`shutdown_plan_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_capex_request_id` FOREIGN KEY (`capex_request_id`) REFERENCES `manufacturing_ecm`.`asset`.`capex_request`(`capex_request_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_service_contract_id` FOREIGN KEY (`service_contract_id`) REFERENCES `manufacturing_ecm`.`asset`.`service_contract`(`service_contract_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`work_permit` ADD CONSTRAINT `fk_workforce_work_permit_permit_to_work_id` FOREIGN KEY (`permit_to_work_id`) REFERENCES `manufacturing_ecm`.`asset`.`permit_to_work`(`permit_to_work_id`);

-- ========= workforce --> billing (2 constraint(s)) =========
-- Requires: workforce schema, billing schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_type_id` FOREIGN KEY (`type_id`) REFERENCES `manufacturing_ecm`.`billing`.`type`(`type_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`absence_record` ADD CONSTRAINT `fk_workforce_absence_record_plan_id` FOREIGN KEY (`plan_id`) REFERENCES `manufacturing_ecm`.`billing`.`plan`(`plan_id`);

-- ========= workforce --> compliance (15 constraint(s)) =========
-- Requires: workforce schema, compliance schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`procurement_supplier` ADD CONSTRAINT `fk_workforce_procurement_supplier_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `manufacturing_ecm`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`channel_partner` ADD CONSTRAINT `fk_workforce_channel_partner_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `manufacturing_ecm`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`internal_order` ADD CONSTRAINT `fk_workforce_internal_order_obligation_id` FOREIGN KEY (`obligation_id`) REFERENCES `manufacturing_ecm`.`compliance`.`obligation`(`obligation_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_rohs_compliance_record_id` FOREIGN KEY (`rohs_compliance_record_id`) REFERENCES `manufacturing_ecm`.`compliance`.`rohs_compliance_record`(`rohs_compliance_record_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`grievance` ADD CONSTRAINT `fk_workforce_grievance_compliance_policy_id` FOREIGN KEY (`compliance_policy_id`) REFERENCES `manufacturing_ecm`.`compliance`.`compliance_policy`(`compliance_policy_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`disciplinary_action` ADD CONSTRAINT `fk_workforce_disciplinary_action_compliance_policy_id` FOREIGN KEY (`compliance_policy_id`) REFERENCES `manufacturing_ecm`.`compliance`.`compliance_policy`(`compliance_policy_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`compliance_record` ADD CONSTRAINT `fk_workforce_compliance_record_internal_audit_id` FOREIGN KEY (`internal_audit_id`) REFERENCES `manufacturing_ecm`.`compliance`.`internal_audit`(`internal_audit_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`regulatory_requirement` ADD CONSTRAINT `fk_workforce_regulatory_requirement_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `manufacturing_ecm`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`product_certification` ADD CONSTRAINT `fk_workforce_product_certification_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `manufacturing_ecm`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`capa_record` ADD CONSTRAINT `fk_workforce_capa_record_compliance_audit_finding_id` FOREIGN KEY (`compliance_audit_finding_id`) REFERENCES `manufacturing_ecm`.`compliance`.`compliance_audit_finding`(`compliance_audit_finding_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`capa_record` ADD CONSTRAINT `fk_workforce_capa_record_internal_audit_id` FOREIGN KEY (`internal_audit_id`) REFERENCES `manufacturing_ecm`.`compliance`.`internal_audit`(`internal_audit_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`export_classification` ADD CONSTRAINT `fk_workforce_export_classification_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `manufacturing_ecm`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`compliance_reach_substance_declaration` ADD CONSTRAINT `fk_workforce_compliance_reach_substance_declaration_jurisdiction_id` FOREIGN KEY (`jurisdiction_id`) REFERENCES `manufacturing_ecm`.`compliance`.`jurisdiction`(`jurisdiction_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`training_completion` ADD CONSTRAINT `fk_workforce_training_completion_compliance_training_id` FOREIGN KEY (`compliance_training_id`) REFERENCES `manufacturing_ecm`.`compliance`.`training`(`training_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`training_completion` ADD CONSTRAINT `fk_workforce_training_completion_training_id` FOREIGN KEY (`training_id`) REFERENCES `manufacturing_ecm`.`compliance`.`training`(`training_id`);

-- ========= workforce --> customer (17 constraint(s)) =========
-- Requires: workforce schema, customer schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`account` ADD CONSTRAINT `fk_workforce_account_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`customer`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_account_payment_term_id` FOREIGN KEY (`account_payment_term_id`) REFERENCES `manufacturing_ecm`.`customer`.`account_payment_term`(`account_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_customer_opportunity_id` FOREIGN KEY (`customer_opportunity_id`) REFERENCES `manufacturing_ecm`.`customer`.`customer_opportunity`(`customer_opportunity_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_pricing_agreement_id` FOREIGN KEY (`pricing_agreement_id`) REFERENCES `manufacturing_ecm`.`customer`.`pricing_agreement`(`pricing_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_sales_area_assignment_id` FOREIGN KEY (`sales_area_assignment_id`) REFERENCES `manufacturing_ecm`.`customer`.`sales_area_assignment`(`sales_area_assignment_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`customer`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_sla_agreement_id` FOREIGN KEY (`sla_agreement_id`) REFERENCES `manufacturing_ecm`.`customer`.`sla_agreement`(`sla_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`delivery_order` ADD CONSTRAINT `fk_workforce_delivery_order_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`customer`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`delivery_order` ADD CONSTRAINT `fk_workforce_delivery_order_sla_agreement_id` FOREIGN KEY (`sla_agreement_id`) REFERENCES `manufacturing_ecm`.`customer`.`sla_agreement`(`sla_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_opportunity` ADD CONSTRAINT `fk_workforce_sales_opportunity_pricing_agreement_id` FOREIGN KEY (`pricing_agreement_id`) REFERENCES `manufacturing_ecm`.`customer`.`pricing_agreement`(`pricing_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`shipment` ADD CONSTRAINT `fk_workforce_shipment_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`field_service_order` ADD CONSTRAINT `fk_workforce_field_service_order_installed_base_id` FOREIGN KEY (`installed_base_id`) REFERENCES `manufacturing_ecm`.`customer`.`installed_base`(`installed_base_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_account_payment_term_id` FOREIGN KEY (`account_payment_term_id`) REFERENCES `manufacturing_ecm`.`customer`.`account_payment_term`(`account_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_address_id` FOREIGN KEY (`address_id`) REFERENCES `manufacturing_ecm`.`customer`.`address`(`address_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `manufacturing_ecm`.`customer`.`contact`(`contact_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_pricing_agreement_id` FOREIGN KEY (`pricing_agreement_id`) REFERENCES `manufacturing_ecm`.`customer`.`pricing_agreement`(`pricing_agreement_id`);

-- ========= workforce --> engineering (6 constraint(s)) =========
-- Requires: workforce schema, engineering schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`work_order` ADD CONSTRAINT `fk_workforce_work_order_drawing_id` FOREIGN KEY (`drawing_id`) REFERENCES `manufacturing_ecm`.`engineering`.`drawing`(`drawing_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`component` ADD CONSTRAINT `fk_workforce_component_material_specification_id` FOREIGN KEY (`material_specification_id`) REFERENCES `manufacturing_ecm`.`engineering`.`material_specification`(`material_specification_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`component` ADD CONSTRAINT `fk_workforce_component_plm_lifecycle_state_id` FOREIGN KEY (`plm_lifecycle_state_id`) REFERENCES `manufacturing_ecm`.`engineering`.`plm_lifecycle_state`(`plm_lifecycle_state_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`order` ADD CONSTRAINT `fk_workforce_order_engineering_bom_id` FOREIGN KEY (`engineering_bom_id`) REFERENCES `manufacturing_ecm`.`engineering`.`engineering_bom`(`engineering_bom_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`capa_record` ADD CONSTRAINT `fk_workforce_capa_record_ecn_id` FOREIGN KEY (`ecn_id`) REFERENCES `manufacturing_ecm`.`engineering`.`ecn`(`ecn_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`capa_record` ADD CONSTRAINT `fk_workforce_capa_record_eco_id` FOREIGN KEY (`eco_id`) REFERENCES `manufacturing_ecm`.`engineering`.`eco`(`eco_id`);

-- ========= workforce --> finance (10 constraint(s)) =========
-- Requires: workforce schema, finance schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`production_plant` ADD CONSTRAINT `fk_workforce_production_plant_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`legal_entity` ADD CONSTRAINT `fk_workforce_legal_entity_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`legal_entity` ADD CONSTRAINT `fk_workforce_legal_entity_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`gl_account` ADD CONSTRAINT `fk_workforce_gl_account_chart_of_accounts_id` FOREIGN KEY (`chart_of_accounts_id`) REFERENCES `manufacturing_ecm`.`finance`.`chart_of_accounts`(`chart_of_accounts_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`cost_center` ADD CONSTRAINT `fk_workforce_cost_center_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`profit_center` ADD CONSTRAINT `fk_workforce_profit_center_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`internal_order` ADD CONSTRAINT `fk_workforce_internal_order_controlling_area_id` FOREIGN KEY (`controlling_area_id`) REFERENCES `manufacturing_ecm`.`finance`.`controlling_area`(`controlling_area_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_ar_invoice_id` FOREIGN KEY (`ar_invoice_id`) REFERENCES `manufacturing_ecm`.`finance`.`ar_invoice`(`ar_invoice_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_tax_code_id` FOREIGN KEY (`tax_code_id`) REFERENCES `manufacturing_ecm`.`finance`.`tax_code`(`tax_code_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`headcount_plan` ADD CONSTRAINT `fk_workforce_headcount_plan_budget_id` FOREIGN KEY (`budget_id`) REFERENCES `manufacturing_ecm`.`finance`.`budget`(`budget_id`);

-- ========= workforce --> hse (4 constraint(s)) =========
-- Requires: workforce schema, hse schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`work_order` ADD CONSTRAINT `fk_workforce_work_order_incident_id` FOREIGN KEY (`incident_id`) REFERENCES `manufacturing_ecm`.`hse`.`incident`(`incident_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`ncr` ADD CONSTRAINT `fk_workforce_ncr_incident_id` FOREIGN KEY (`incident_id`) REFERENCES `manufacturing_ecm`.`hse`.`incident`(`incident_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`field_service_order` ADD CONSTRAINT `fk_workforce_field_service_order_ppe_requirement_id` FOREIGN KEY (`ppe_requirement_id`) REFERENCES `manufacturing_ecm`.`hse`.`ppe_requirement`(`ppe_requirement_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`ot_system` ADD CONSTRAINT `fk_workforce_ot_system_emergency_response_plan_id` FOREIGN KEY (`emergency_response_plan_id`) REFERENCES `manufacturing_ecm`.`hse`.`emergency_response_plan`(`emergency_response_plan_id`);

-- ========= workforce --> inventory (3 constraint(s)) =========
-- Requires: workforce schema, inventory schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`shipment` ADD CONSTRAINT `fk_workforce_shipment_handling_unit_id` FOREIGN KEY (`handling_unit_id`) REFERENCES `manufacturing_ecm`.`inventory`.`handling_unit`(`handling_unit_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`field_service_order` ADD CONSTRAINT `fk_workforce_field_service_order_serialized_unit_id` FOREIGN KEY (`serialized_unit_id`) REFERENCES `manufacturing_ecm`.`inventory`.`serialized_unit`(`serialized_unit_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_stock_transfer_id` FOREIGN KEY (`stock_transfer_id`) REFERENCES `manufacturing_ecm`.`inventory`.`stock_transfer`(`stock_transfer_id`);

-- ========= workforce --> logistics (11 constraint(s)) =========
-- Requires: workforce schema, logistics schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`procurement_supplier` ADD CONSTRAINT `fk_workforce_procurement_supplier_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`spare_part` ADD CONSTRAINT `fk_workforce_spare_part_logistics_inbound_delivery_id` FOREIGN KEY (`logistics_inbound_delivery_id`) REFERENCES `manufacturing_ecm`.`logistics`.`logistics_inbound_delivery`(`logistics_inbound_delivery_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`order` ADD CONSTRAINT `fk_workforce_order_packaging_id` FOREIGN KEY (`packaging_id`) REFERENCES `manufacturing_ecm`.`logistics`.`packaging`(`packaging_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`shipment` ADD CONSTRAINT `fk_workforce_shipment_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `manufacturing_ecm`.`logistics`.`carrier`(`carrier_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`shipment` ADD CONSTRAINT `fk_workforce_shipment_freight_order_id` FOREIGN KEY (`freight_order_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_order`(`freight_order_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`shipment` ADD CONSTRAINT `fk_workforce_shipment_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`logistics`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`shipment` ADD CONSTRAINT `fk_workforce_shipment_route_id` FOREIGN KEY (`route_id`) REFERENCES `manufacturing_ecm`.`logistics`.`route`(`route_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`shipment` ADD CONSTRAINT `fk_workforce_shipment_transport_plan_id` FOREIGN KEY (`transport_plan_id`) REFERENCES `manufacturing_ecm`.`logistics`.`transport_plan`(`transport_plan_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_freight_order_id` FOREIGN KEY (`freight_order_id`) REFERENCES `manufacturing_ecm`.`logistics`.`freight_order`(`freight_order_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`logistics`.`location`(`location_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`employee_skill` ADD CONSTRAINT `fk_workforce_employee_skill_location_id` FOREIGN KEY (`location_id`) REFERENCES `manufacturing_ecm`.`logistics`.`location`(`location_id`);

-- ========= workforce --> order (7 constraint(s)) =========
-- Requires: workforce schema, order schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_blanket_order_id` FOREIGN KEY (`blanket_order_id`) REFERENCES `manufacturing_ecm`.`order`.`blanket_order`(`blanket_order_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `manufacturing_ecm`.`order`.`channel`(`channel_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_fulfillment_mode_id` FOREIGN KEY (`fulfillment_mode_id`) REFERENCES `manufacturing_ecm`.`order`.`fulfillment_mode`(`fulfillment_mode_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_order_quotation_id` FOREIGN KEY (`order_quotation_id`) REFERENCES `manufacturing_ecm`.`order`.`order_quotation`(`order_quotation_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_priority_id` FOREIGN KEY (`priority_id`) REFERENCES `manufacturing_ecm`.`order`.`priority`(`priority_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_rfq_request_id` FOREIGN KEY (`rfq_request_id`) REFERENCES `manufacturing_ecm`.`order`.`rfq_request`(`rfq_request_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`order` ADD CONSTRAINT `fk_workforce_order_line_item_id` FOREIGN KEY (`line_item_id`) REFERENCES `manufacturing_ecm`.`order`.`line_item`(`line_item_id`);

-- ========= workforce --> procurement (10 constraint(s)) =========
-- Requires: workforce schema, procurement schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`procurement_supplier` ADD CONSTRAINT `fk_workforce_procurement_supplier_supplier_id` FOREIGN KEY (`supplier_id`) REFERENCES `manufacturing_ecm`.`procurement`.`supplier`(`supplier_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`procurement_supplier` ADD CONSTRAINT `fk_workforce_procurement_supplier_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`procurement_supplier` ADD CONSTRAINT `fk_workforce_procurement_supplier_procurement_payment_term_id` FOREIGN KEY (`procurement_payment_term_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_payment_term`(`procurement_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`procurement_purchase_order` ADD CONSTRAINT `fk_workforce_procurement_purchase_order_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`procurement_purchase_order` ADD CONSTRAINT `fk_workforce_procurement_purchase_order_procurement_payment_term_id` FOREIGN KEY (`procurement_payment_term_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_payment_term`(`procurement_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`procurement_purchase_order` ADD CONSTRAINT `fk_workforce_procurement_purchase_order_procurement_sourcing_event_id` FOREIGN KEY (`procurement_sourcing_event_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_sourcing_event`(`procurement_sourcing_event_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`procurement_purchase_order` ADD CONSTRAINT `fk_workforce_procurement_purchase_order_procurement_supply_agreement_id` FOREIGN KEY (`procurement_supply_agreement_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_supply_agreement`(`procurement_supply_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_procurement_payment_term_id` FOREIGN KEY (`procurement_payment_term_id`) REFERENCES `manufacturing_ecm`.`procurement`.`procurement_payment_term`(`procurement_payment_term_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`delivery_order` ADD CONSTRAINT `fk_workforce_delivery_order_incoterm_id` FOREIGN KEY (`incoterm_id`) REFERENCES `manufacturing_ecm`.`procurement`.`incoterm`(`incoterm_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_opportunity` ADD CONSTRAINT `fk_workforce_sales_opportunity_preferred_supplier_list_id` FOREIGN KEY (`preferred_supplier_list_id`) REFERENCES `manufacturing_ecm`.`procurement`.`preferred_supplier_list`(`preferred_supplier_list_id`);

-- ========= workforce --> product (6 constraint(s)) =========
-- Requires: workforce schema, product schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`catalog_item` ADD CONSTRAINT `fk_workforce_catalog_item_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`product_sku` ADD CONSTRAINT `fk_workforce_product_sku_hierarchy_id` FOREIGN KEY (`hierarchy_id`) REFERENCES `manufacturing_ecm`.`product`.`hierarchy`(`hierarchy_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`order` ADD CONSTRAINT `fk_workforce_order_product_configuration_id` FOREIGN KEY (`product_configuration_id`) REFERENCES `manufacturing_ecm`.`product`.`product_configuration`(`product_configuration_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_opportunity` ADD CONSTRAINT `fk_workforce_sales_opportunity_product_price_list_id` FOREIGN KEY (`product_price_list_id`) REFERENCES `manufacturing_ecm`.`product`.`product_price_list`(`product_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_warranty_policy_id` FOREIGN KEY (`warranty_policy_id`) REFERENCES `manufacturing_ecm`.`product`.`warranty_policy`(`warranty_policy_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`capa_record` ADD CONSTRAINT `fk_workforce_capa_record_change_notice_id` FOREIGN KEY (`change_notice_id`) REFERENCES `manufacturing_ecm`.`product`.`change_notice`(`change_notice_id`);

-- ========= workforce --> production (13 constraint(s)) =========
-- Requires: workforce schema, production schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`order` ADD CONSTRAINT `fk_workforce_order_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`order` ADD CONSTRAINT `fk_workforce_order_order_type_id` FOREIGN KEY (`order_type_id`) REFERENCES `manufacturing_ecm`.`production`.`order_type`(`order_type_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`order` ADD CONSTRAINT `fk_workforce_order_routing_id` FOREIGN KEY (`routing_id`) REFERENCES `manufacturing_ecm`.`production`.`routing`(`routing_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`field_service_order` ADD CONSTRAINT `fk_workforce_field_service_order_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`shift_definition` ADD CONSTRAINT `fk_workforce_shift_definition_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `manufacturing_ecm`.`production`.`shift`(`shift_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_schedule_id` FOREIGN KEY (`schedule_id`) REFERENCES `manufacturing_ecm`.`production`.`schedule`(`schedule_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_shift_id` FOREIGN KEY (`shift_id`) REFERENCES `manufacturing_ecm`.`production`.`shift`(`shift_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`shift_schedule` ADD CONSTRAINT `fk_workforce_shift_schedule_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`time_entry` ADD CONSTRAINT `fk_workforce_time_entry_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`employee_skill` ADD CONSTRAINT `fk_workforce_employee_skill_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`labor_cost_entry` ADD CONSTRAINT `fk_workforce_labor_cost_entry_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`labor_standard` ADD CONSTRAINT `fk_workforce_labor_standard_work_center_id` FOREIGN KEY (`work_center_id`) REFERENCES `manufacturing_ecm`.`production`.`work_center`(`work_center_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`compliance_reach_substance_declaration` ADD CONSTRAINT `fk_workforce_compliance_reach_substance_declaration_batch_id` FOREIGN KEY (`batch_id`) REFERENCES `manufacturing_ecm`.`production`.`batch`(`batch_id`);

-- ========= workforce --> quality (2 constraint(s)) =========
-- Requires: workforce schema, quality schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`ncr` ADD CONSTRAINT `fk_workforce_ncr_defect_code_id` FOREIGN KEY (`defect_code_id`) REFERENCES `manufacturing_ecm`.`quality`.`defect_code`(`defect_code_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`field_service_order` ADD CONSTRAINT `fk_workforce_field_service_order_certificate_id` FOREIGN KEY (`certificate_id`) REFERENCES `manufacturing_ecm`.`quality`.`certificate`(`certificate_id`);

-- ========= workforce --> research (5 constraint(s)) =========
-- Requires: workforce schema, research schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`component` ADD CONSTRAINT `fk_workforce_component_ip_asset_id` FOREIGN KEY (`ip_asset_id`) REFERENCES `manufacturing_ecm`.`research`.`ip_asset`(`ip_asset_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`rd_project` ADD CONSTRAINT `fk_workforce_rd_project_collaboration_agreement_id` FOREIGN KEY (`collaboration_agreement_id`) REFERENCES `manufacturing_ecm`.`research`.`collaboration_agreement`(`collaboration_agreement_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`rd_project` ADD CONSTRAINT `fk_workforce_rd_project_innovation_pipeline_id` FOREIGN KEY (`innovation_pipeline_id`) REFERENCES `manufacturing_ecm`.`research`.`innovation_pipeline`(`innovation_pipeline_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`rd_project` ADD CONSTRAINT `fk_workforce_rd_project_technology_roadmap_id` FOREIGN KEY (`technology_roadmap_id`) REFERENCES `manufacturing_ecm`.`research`.`technology_roadmap`(`technology_roadmap_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`labor_standard` ADD CONSTRAINT `fk_workforce_labor_standard_rd_test_result_id` FOREIGN KEY (`rd_test_result_id`) REFERENCES `manufacturing_ecm`.`research`.`rd_test_result`(`rd_test_result_id`);

-- ========= workforce --> sales (7 constraint(s)) =========
-- Requires: workforce schema, sales schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_deal_registration_id` FOREIGN KEY (`deal_registration_id`) REFERENCES `manufacturing_ecm`.`sales`.`deal_registration`(`deal_registration_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_order` ADD CONSTRAINT `fk_workforce_sales_order_sales_price_list_id` FOREIGN KEY (`sales_price_list_id`) REFERENCES `manufacturing_ecm`.`sales`.`sales_price_list`(`sales_price_list_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_opportunity` ADD CONSTRAINT `fk_workforce_sales_opportunity_account_plan_id` FOREIGN KEY (`account_plan_id`) REFERENCES `manufacturing_ecm`.`sales`.`account_plan`(`account_plan_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_opportunity` ADD CONSTRAINT `fk_workforce_sales_opportunity_discount_structure_id` FOREIGN KEY (`discount_structure_id`) REFERENCES `manufacturing_ecm`.`sales`.`discount_structure`(`discount_structure_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`sales_opportunity` ADD CONSTRAINT `fk_workforce_sales_opportunity_sales_territory_id` FOREIGN KEY (`sales_territory_id`) REFERENCES `manufacturing_ecm`.`sales`.`sales_territory`(`sales_territory_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`channel_partner` ADD CONSTRAINT `fk_workforce_channel_partner_channel_partner_program_id` FOREIGN KEY (`channel_partner_program_id`) REFERENCES `manufacturing_ecm`.`sales`.`channel_partner_program`(`channel_partner_program_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_sales_price_list_id` FOREIGN KEY (`sales_price_list_id`) REFERENCES `manufacturing_ecm`.`sales`.`sales_price_list`(`sales_price_list_id`);

-- ========= workforce --> service (3 constraint(s)) =========
-- Requires: workforce schema, service schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`field_service_order` ADD CONSTRAINT `fk_workforce_field_service_order_technician_id` FOREIGN KEY (`technician_id`) REFERENCES `manufacturing_ecm`.`service`.`technician`(`technician_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`field_service_order` ADD CONSTRAINT `fk_workforce_field_service_order_request_id` FOREIGN KEY (`request_id`) REFERENCES `manufacturing_ecm`.`service`.`request`(`request_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`field_service_order` ADD CONSTRAINT `fk_workforce_field_service_order_service_territory_id` FOREIGN KEY (`service_territory_id`) REFERENCES `manufacturing_ecm`.`service`.`service_territory`(`service_territory_id`);

-- ========= workforce --> technology (11 constraint(s)) =========
-- Requires: workforce schema, technology schema
ALTER TABLE `manufacturing_ecm`.`workforce`.`procurement_supplier` ADD CONSTRAINT `fk_workforce_procurement_supplier_it_vendor_id` FOREIGN KEY (`it_vendor_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_vendor`(`it_vendor_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`rd_project` ADD CONSTRAINT `fk_workforce_rd_project_digital_initiative_id` FOREIGN KEY (`digital_initiative_id`) REFERENCES `manufacturing_ecm`.`technology`.`digital_initiative`(`digital_initiative_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`field_service_order` ADD CONSTRAINT `fk_workforce_field_service_order_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_it_contract_id` FOREIGN KEY (`it_contract_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_contract`(`it_contract_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`billing_invoice` ADD CONSTRAINT `fk_workforce_billing_invoice_it_project_id` FOREIGN KEY (`it_project_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_project`(`it_project_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`it_asset` ADD CONSTRAINT `fk_workforce_it_asset_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`application` ADD CONSTRAINT `fk_workforce_application_it_contract_id` FOREIGN KEY (`it_contract_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_contract`(`it_contract_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`application` ADD CONSTRAINT `fk_workforce_application_it_vendor_id` FOREIGN KEY (`it_vendor_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_vendor`(`it_vendor_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`ot_system` ADD CONSTRAINT `fk_workforce_ot_system_it_contract_id` FOREIGN KEY (`it_contract_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_contract`(`it_contract_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`ot_system` ADD CONSTRAINT `fk_workforce_ot_system_it_vendor_id` FOREIGN KEY (`it_vendor_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_vendor`(`it_vendor_id`);
ALTER TABLE `manufacturing_ecm`.`workforce`.`project_assignment` ADD CONSTRAINT `fk_workforce_project_assignment_it_project_id` FOREIGN KEY (`it_project_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_project`(`it_project_id`);

