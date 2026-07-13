-- Cross-Domain Foreign Keys for Business: Shipping_Ports | Version: v2_ecm
-- Generated on: 2026-07-13 08:38:33
-- Total cross-domain FK constraints: 1828
--
-- EXECUTION ORDER:
--   1. Run ALL domain schema files first (any order).
--   2. Run this file LAST.
--
-- PREREQUISITE DOMAINS: asset, billing, booking, cargo, compliance, contract, customer, finance, infrastructure, intermodal, marine, masterdata, procurement, safety, security, tariff, terminal, vessel, workforce

-- ========= asset --> compliance (4 constraint(s)) =========
-- Requires: asset schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`swl_certificate` ADD CONSTRAINT `fk_asset_swl_certificate_compliance_audit_id` FOREIGN KEY (`compliance_audit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`compliance_audit`(`compliance_audit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_compliance_audit_id` FOREIGN KEY (`compliance_audit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`compliance_audit`(`compliance_audit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_violation_id` FOREIGN KEY (`violation_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`violation`(`violation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_compliance_audit_id` FOREIGN KEY (`compliance_audit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`compliance_audit`(`compliance_audit_id`);

-- ========= asset --> contract (5 constraint(s)) =========
-- Requires: asset schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ADD CONSTRAINT `fk_asset_downtime_record_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= asset --> customer (7 constraint(s)) =========
-- Requires: asset schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ADD CONSTRAINT `fk_asset_spare_part_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ADD CONSTRAINT `fk_asset_disposal_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= asset --> finance (9 constraint(s)) =========
-- Requires: asset schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ADD CONSTRAINT `fk_asset_depreciation_schedule_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`depreciation_schedule` ADD CONSTRAINT `fk_asset_depreciation_schedule_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ADD CONSTRAINT `fk_asset_spare_part_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ADD CONSTRAINT `fk_asset_acquisition_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ADD CONSTRAINT `fk_asset_acquisition_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);

-- ========= asset --> marine (5 constraint(s)) =========
-- Requires: asset schema, marine schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_tug_id` FOREIGN KEY (`tug_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug`(`tug_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_tug_id` FOREIGN KEY (`tug_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug`(`tug_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ADD CONSTRAINT `fk_asset_downtime_record_tug_id` FOREIGN KEY (`tug_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug`(`tug_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_tug_id` FOREIGN KEY (`tug_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug`(`tug_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ADD CONSTRAINT `fk_asset_meter_tug_id` FOREIGN KEY (`tug_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug`(`tug_id`);

-- ========= asset --> masterdata (5 constraint(s)) =========
-- Requires: asset schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ADD CONSTRAINT `fk_asset_equipment_class_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ADD CONSTRAINT `fk_asset_spare_part_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_template` ADD CONSTRAINT `fk_asset_work_order_template_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);

-- ========= asset --> procurement (7 constraint(s)) =========
-- Requires: asset schema, procurement schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ADD CONSTRAINT `fk_asset_equipment_class_material_group_id` FOREIGN KEY (`material_group_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_group`(`material_group_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_procurement_plan_id` FOREIGN KEY (`procurement_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`procurement_plan`(`procurement_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition`(`purchase_requisition_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_service_entry_sheet_id` FOREIGN KEY (`service_entry_sheet_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet`(`service_entry_sheet_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ADD CONSTRAINT `fk_asset_spare_part_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ADD CONSTRAINT `fk_asset_acquisition_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= asset --> safety (5 constraint(s)) =========
-- Requires: asset schema, safety schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_risk_assessment_id` FOREIGN KEY (`risk_assessment_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`risk_assessment`(`risk_assessment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_permit_to_work_id` FOREIGN KEY (`permit_to_work_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`permit_to_work`(`permit_to_work_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_permit_to_work_id` FOREIGN KEY (`permit_to_work_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`permit_to_work`(`permit_to_work_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ADD CONSTRAINT `fk_asset_acquisition_risk_assessment_id` FOREIGN KEY (`risk_assessment_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`risk_assessment`(`risk_assessment_id`);

-- ========= asset --> security (10 constraint(s)) =========
-- Requires: asset schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_facility_security_plan_id` FOREIGN KEY (`facility_security_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`facility_security_plan`(`facility_security_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ADD CONSTRAINT `fk_asset_downtime_record_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ADD CONSTRAINT `fk_asset_spare_part_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`disposal` ADD CONSTRAINT `fk_asset_disposal_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`asset_location` ADD CONSTRAINT `fk_asset_asset_location_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);

-- ========= asset --> terminal (5 constraint(s)) =========
-- Requires: asset schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_terminal_equipment_id` FOREIGN KEY (`terminal_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment`(`terminal_equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_terminal_equipment_id` FOREIGN KEY (`terminal_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment`(`terminal_equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ADD CONSTRAINT `fk_asset_downtime_record_terminal_equipment_id` FOREIGN KEY (`terminal_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment`(`terminal_equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_terminal_equipment_id` FOREIGN KEY (`terminal_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment`(`terminal_equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ADD CONSTRAINT `fk_asset_meter_terminal_equipment_id` FOREIGN KEY (`terminal_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment`(`terminal_equipment_id`);

-- ========= asset --> vessel (2 constraint(s)) =========
-- Requires: asset schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ADD CONSTRAINT `fk_asset_downtime_record_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);

-- ========= asset --> workforce (13 constraint(s)) =========
-- Requires: asset schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_tertiary_work_approved_by_employee_id` FOREIGN KEY (`tertiary_work_approved_by_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ADD CONSTRAINT `fk_asset_work_order_task_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ADD CONSTRAINT `fk_asset_downtime_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ADD CONSTRAINT `fk_asset_downtime_record_shift_pattern_id` FOREIGN KEY (`shift_pattern_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`shift_pattern`(`shift_pattern_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`downtime_record` ADD CONSTRAINT `fk_asset_downtime_record_tertiary_downtime_approved_by_user_employee_id` FOREIGN KEY (`tertiary_downtime_approved_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`meter` ADD CONSTRAINT `fk_asset_meter_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`acquisition` ADD CONSTRAINT `fk_asset_acquisition_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`task_part_consumption` ADD CONSTRAINT `fk_asset_task_part_consumption_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= billing --> cargo (1 constraint(s)) =========
-- Requires: billing schema, cargo schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);

-- ========= billing --> compliance (11 constraint(s)) =========
-- Requires: billing schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_violation_id` FOREIGN KEY (`violation_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`violation`(`violation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_trade_document_id` FOREIGN KEY (`trade_document_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_document`(`trade_document_id`);

-- ========= billing --> contract (7 constraint(s)) =========
-- Requires: billing schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_rate_schedule_id` FOREIGN KEY (`rate_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`rate_schedule`(`rate_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_rate_schedule_id` FOREIGN KEY (`rate_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`rate_schedule`(`rate_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`performance_obligation` ADD CONSTRAINT `fk_billing_performance_obligation_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= billing --> customer (13 constraint(s)) =========
-- Requires: billing schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_service_request_id` FOREIGN KEY (`service_request_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`service_request`(`service_request_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dunning_notice` ADD CONSTRAINT `fk_billing_dunning_notice_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`statement_of_account` ADD CONSTRAINT `fk_billing_statement_of_account_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`performance_obligation` ADD CONSTRAINT `fk_billing_performance_obligation_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`billing_cycle` ADD CONSTRAINT `fk_billing_billing_cycle_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= billing --> finance (15 constraint(s)) =========
-- Requires: billing schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);

-- ========= billing --> infrastructure (11 constraint(s)) =========
-- Requires: billing schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_closure_id` FOREIGN KEY (`closure_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`closure`(`closure_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_dredging_campaign_id` FOREIGN KEY (`dredging_campaign_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign`(`dredging_campaign_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`billing_cycle` ADD CONSTRAINT `fk_billing_billing_cycle_infrastructure_terminal_id` FOREIGN KEY (`infrastructure_terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal`(`infrastructure_terminal_id`);

-- ========= billing --> intermodal (8 constraint(s)) =========
-- Requires: billing schema, intermodal schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_edi_message_id` FOREIGN KEY (`edi_message_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`edi_message`(`edi_message_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_rail_operator_id` FOREIGN KEY (`rail_operator_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_operator`(`rail_operator_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_drayage_order_id` FOREIGN KEY (`drayage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`drayage_order`(`drayage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_transport_leg_id` FOREIGN KEY (`transport_leg_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_leg`(`transport_leg_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_truck_visit_id` FOREIGN KEY (`truck_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_visit`(`truck_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_slot_booking_id` FOREIGN KEY (`slot_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`slot_booking`(`slot_booking_id`);

-- ========= billing --> marine (1 constraint(s)) =========
-- Requires: billing schema, marine schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_marine_service_order_id` FOREIGN KEY (`marine_service_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_service_order`(`marine_service_order_id`);

-- ========= billing --> masterdata (15 constraint(s)) =========
-- Requires: billing schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_edi_partner_id` FOREIGN KEY (`edi_partner_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`edi_partner`(`edi_partner_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);

-- ========= billing --> safety (7 constraint(s)) =========
-- Requires: billing schema, safety schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_contractor_safety_id` FOREIGN KEY (`contractor_safety_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`contractor_safety`(`contractor_safety_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_marpol_waste_record_id` FOREIGN KEY (`marpol_waste_record_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record`(`marpol_waste_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_sustainability_initiative_id` FOREIGN KEY (`sustainability_initiative_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`sustainability_initiative`(`sustainability_initiative_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_contractor_safety_id` FOREIGN KEY (`contractor_safety_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`contractor_safety`(`contractor_safety_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_permit_to_work_id` FOREIGN KEY (`permit_to_work_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`permit_to_work`(`permit_to_work_id`);

-- ========= billing --> security (3 constraint(s)) =========
-- Requires: billing schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);

-- ========= billing --> tariff (8 constraint(s)) =========
-- Requires: billing schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_rate_card_line_id` FOREIGN KEY (`rate_card_line_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card_line`(`rate_card_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_exception_id` FOREIGN KEY (`exception_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`exception`(`exception_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);

-- ========= billing --> terminal (2 constraint(s)) =========
-- Requires: billing schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_terminal_equipment_id` FOREIGN KEY (`terminal_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment`(`terminal_equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_terminal_equipment_id` FOREIGN KEY (`terminal_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment`(`terminal_equipment_id`);

-- ========= billing --> vessel (7 constraint(s)) =========
-- Requires: billing schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);

-- ========= billing --> workforce (18 constraint(s)) =========
-- Requires: billing schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment_allocation` ADD CONSTRAINT `fk_billing_payment_allocation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_tertiary_debit_modified_by_employee_id` FOREIGN KEY (`tertiary_debit_modified_by_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dunning_notice` ADD CONSTRAINT `fk_billing_dunning_notice_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`revenue_event` ADD CONSTRAINT `fk_billing_revenue_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`proforma_invoice` ADD CONSTRAINT `fk_billing_proforma_invoice_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`statement_of_account` ADD CONSTRAINT `fk_billing_statement_of_account_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`statement_of_account` ADD CONSTRAINT `fk_billing_statement_of_account_statement_modified_by_user_employee_id` FOREIGN KEY (`statement_modified_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`billing_cycle` ADD CONSTRAINT `fk_billing_billing_cycle_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`billing_cycle` ADD CONSTRAINT `fk_billing_billing_cycle_billing_employee_id` FOREIGN KEY (`billing_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`billing_cycle` ADD CONSTRAINT `fk_billing_billing_cycle_billing_last_modified_by_user_employee_id` FOREIGN KEY (`billing_last_modified_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`billing_run` ADD CONSTRAINT `fk_billing_billing_run_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`billing_run` ADD CONSTRAINT `fk_billing_billing_run_billing_run_employee_id` FOREIGN KEY (`billing_run_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= booking --> asset (4 constraint(s)) =========
-- Requires: booking schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking` ADD CONSTRAINT `fk_booking_booking_anchorage_booking_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`resource_allocation` ADD CONSTRAINT `fk_booking_resource_allocation_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= booking --> billing (3 constraint(s)) =========
-- Requires: booking schema, billing schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`truck_gate_booking` ADD CONSTRAINT `fk_booking_truck_gate_booking_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking` ADD CONSTRAINT `fk_booking_booking_anchorage_booking_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);

-- ========= booking --> cargo (3 constraint(s)) =========
-- Requires: booking schema, cargo schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_handling_order_id` FOREIGN KEY (`handling_order_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`handling_order`(`handling_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`slot_reservation` ADD CONSTRAINT `fk_booking_slot_reservation_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`truck_gate_booking` ADD CONSTRAINT `fk_booking_truck_gate_booking_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);

-- ========= booking --> compliance (7 constraint(s)) =========
-- Requires: booking schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`call_booking` ADD CONSTRAINT `fk_booking_call_booking_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`pre_arrival` ADD CONSTRAINT `fk_booking_pre_arrival_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`truck_gate_booking` ADD CONSTRAINT `fk_booking_truck_gate_booking_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking` ADD CONSTRAINT `fk_booking_booking_anchorage_booking_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);

-- ========= booking --> contract (5 constraint(s)) =========
-- Requires: booking schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`call_booking` ADD CONSTRAINT `fk_booking_call_booking_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_service_scope_id` FOREIGN KEY (`service_scope_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`service_scope`(`service_scope_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_sla_definition_id` FOREIGN KEY (`sla_definition_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`sla_definition`(`sla_definition_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= booking --> customer (6 constraint(s)) =========
-- Requires: booking schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`call_booking` ADD CONSTRAINT `fk_booking_call_booking_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_tertiary_cargo_notify_party_port_community_participant_id` FOREIGN KEY (`tertiary_cargo_notify_party_port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_tertiary_quaternary_cargo_freight_forwarder_port_community_participant_id` FOREIGN KEY (`tertiary_quaternary_cargo_freight_forwarder_port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`amendment` ADD CONSTRAINT `fk_booking_amendment_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`truck_gate_booking` ADD CONSTRAINT `fk_booking_truck_gate_booking_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= booking --> finance (10 constraint(s)) =========
-- Requires: booking schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`call_booking` ADD CONSTRAINT `fk_booking_call_booking_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`call_booking` ADD CONSTRAINT `fk_booking_call_booking_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking` ADD CONSTRAINT `fk_booking_booking_anchorage_booking_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`resource_allocation` ADD CONSTRAINT `fk_booking_resource_allocation_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`resource_allocation` ADD CONSTRAINT `fk_booking_resource_allocation_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`resource_allocation` ADD CONSTRAINT `fk_booking_resource_allocation_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);

-- ========= booking --> infrastructure (12 constraint(s)) =========
-- Requires: booking schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`pre_arrival` ADD CONSTRAINT `fk_booking_pre_arrival_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`truck_gate_booking` ADD CONSTRAINT `fk_booking_truck_gate_booking_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`truck_gate_booking` ADD CONSTRAINT `fk_booking_truck_gate_booking_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`truck_gate_booking` ADD CONSTRAINT `fk_booking_truck_gate_booking_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`voyage_nomination` ADD CONSTRAINT `fk_booking_voyage_nomination_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`voyage_nomination` ADD CONSTRAINT `fk_booking_voyage_nomination_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking` ADD CONSTRAINT `fk_booking_booking_anchorage_booking_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);

-- ========= booking --> intermodal (2 constraint(s)) =========
-- Requires: booking schema, intermodal schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`amendment` ADD CONSTRAINT `fk_booking_amendment_edi_message_id` FOREIGN KEY (`edi_message_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`edi_message`(`edi_message_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`voyage_nomination` ADD CONSTRAINT `fk_booking_voyage_nomination_edi_message_id` FOREIGN KEY (`edi_message_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`edi_message`(`edi_message_id`);

-- ========= booking --> masterdata (24 constraint(s)) =========
-- Requires: booking schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`call_booking` ADD CONSTRAINT `fk_booking_call_booking_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`call_booking` ADD CONSTRAINT `fk_booking_call_booking_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`call_booking` ADD CONSTRAINT `fk_booking_call_booking_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`slot_reservation` ADD CONSTRAINT `fk_booking_slot_reservation_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`pre_arrival` ADD CONSTRAINT `fk_booking_pre_arrival_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`pre_arrival` ADD CONSTRAINT `fk_booking_pre_arrival_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`truck_gate_booking` ADD CONSTRAINT `fk_booking_truck_gate_booking_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`truck_gate_booking` ADD CONSTRAINT `fk_booking_truck_gate_booking_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`voyage_nomination` ADD CONSTRAINT `fk_booking_voyage_nomination_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`voyage_nomination` ADD CONSTRAINT `fk_booking_voyage_nomination_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`voyage_nomination` ADD CONSTRAINT `fk_booking_voyage_nomination_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`service_requirement` ADD CONSTRAINT `fk_booking_service_requirement_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking` ADD CONSTRAINT `fk_booking_booking_anchorage_booking_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`resource_allocation` ADD CONSTRAINT `fk_booking_resource_allocation_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`resource_allocation` ADD CONSTRAINT `fk_booking_resource_allocation_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`resource_allocation` ADD CONSTRAINT `fk_booking_resource_allocation_resource_id` FOREIGN KEY (`resource_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`resource`(`resource_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`confirmation` ADD CONSTRAINT `fk_booking_confirmation_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);

-- ========= booking --> security (9 constraint(s)) =========
-- Requires: booking schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_dos_record_id` FOREIGN KEY (`dos_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`dos_record`(`dos_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_screening_record_id` FOREIGN KEY (`screening_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`screening_record`(`screening_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`pre_arrival` ADD CONSTRAINT `fk_booking_pre_arrival_dos_record_id` FOREIGN KEY (`dos_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`dos_record`(`dos_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`truck_gate_booking` ADD CONSTRAINT `fk_booking_truck_gate_booking_access_event_id` FOREIGN KEY (`access_event_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_event`(`access_event_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`truck_gate_booking` ADD CONSTRAINT `fk_booking_truck_gate_booking_screening_record_id` FOREIGN KEY (`screening_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`screening_record`(`screening_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking` ADD CONSTRAINT `fk_booking_booking_anchorage_booking_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking` ADD CONSTRAINT `fk_booking_booking_anchorage_booking_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`vessel_call_security_assignment` ADD CONSTRAINT `fk_booking_vessel_call_security_assignment_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);

-- ========= booking --> tariff (18 constraint(s)) =========
-- Requires: booking schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`call_booking` ADD CONSTRAINT `fk_booking_call_booking_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`call_booking` ADD CONSTRAINT `fk_booking_call_booking_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_rate_card_line_id` FOREIGN KEY (`rate_card_line_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card_line`(`rate_card_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_mooring_tariff_id` FOREIGN KEY (`mooring_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff`(`mooring_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_pilotage_tariff_id` FOREIGN KEY (`pilotage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff`(`pilotage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_towage_tariff_id` FOREIGN KEY (`towage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`towage_tariff`(`towage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_storage_tariff_id` FOREIGN KEY (`storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_thc_schedule_id` FOREIGN KEY (`thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_wharfage_schedule_id` FOREIGN KEY (`wharfage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule`(`wharfage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`slot_reservation` ADD CONSTRAINT `fk_booking_slot_reservation_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`pre_arrival` ADD CONSTRAINT `fk_booking_pre_arrival_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`amendment` ADD CONSTRAINT `fk_booking_amendment_exception_id` FOREIGN KEY (`exception_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`exception`(`exception_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`truck_gate_booking` ADD CONSTRAINT `fk_booking_truck_gate_booking_storage_tariff_id` FOREIGN KEY (`storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`voyage_nomination` ADD CONSTRAINT `fk_booking_voyage_nomination_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking` ADD CONSTRAINT `fk_booking_booking_anchorage_booking_port_dues_schedule_id` FOREIGN KEY (`port_dues_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule`(`port_dues_schedule_id`);

-- ========= booking --> vessel (15 constraint(s)) =========
-- Requires: booking schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`call_booking` ADD CONSTRAINT `fk_booking_call_booking_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`cargo_booking` ADD CONSTRAINT `fk_booking_cargo_booking_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`slot_reservation` ADD CONSTRAINT `fk_booking_slot_reservation_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`pre_arrival` ADD CONSTRAINT `fk_booking_pre_arrival_agent_appointment_id` FOREIGN KEY (`agent_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`agent_appointment`(`agent_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`pre_arrival` ADD CONSTRAINT `fk_booking_pre_arrival_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`pre_arrival` ADD CONSTRAINT `fk_booking_pre_arrival_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`pre_arrival` ADD CONSTRAINT `fk_booking_pre_arrival_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`truck_gate_booking` ADD CONSTRAINT `fk_booking_truck_gate_booking_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`voyage_nomination` ADD CONSTRAINT `fk_booking_voyage_nomination_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`voyage_nomination` ADD CONSTRAINT `fk_booking_voyage_nomination_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking` ADD CONSTRAINT `fk_booking_booking_anchorage_booking_agent_appointment_id` FOREIGN KEY (`agent_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`agent_appointment`(`agent_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking` ADD CONSTRAINT `fk_booking_booking_anchorage_booking_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking` ADD CONSTRAINT `fk_booking_booking_anchorage_booking_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`confirmation` ADD CONSTRAINT `fk_booking_confirmation_agent_appointment_id` FOREIGN KEY (`agent_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`agent_appointment`(`agent_appointment_id`);

-- ========= booking --> workforce (8 constraint(s)) =========
-- Requires: booking schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_service_order` ADD CONSTRAINT `fk_booking_booking_service_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation` ADD CONSTRAINT `fk_booking_booking_berth_reservation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`amendment` ADD CONSTRAINT `fk_booking_amendment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`voyage_nomination` ADD CONSTRAINT `fk_booking_voyage_nomination_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`service_requirement` ADD CONSTRAINT `fk_booking_service_requirement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking` ADD CONSTRAINT `fk_booking_booking_anchorage_booking_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`resource_allocation` ADD CONSTRAINT `fk_booking_resource_allocation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`booking`.`confirmation` ADD CONSTRAINT `fk_booking_confirmation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= cargo --> asset (3 constraint(s)) =========
-- Requires: cargo schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ADD CONSTRAINT `fk_cargo_damage_claim_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= cargo --> billing (6 constraint(s)) =========
-- Requires: cargo schema, billing schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ADD CONSTRAINT `fk_cargo_container_surcharge_application_billing_cycle_id` FOREIGN KEY (`billing_cycle_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`billing_cycle`(`billing_cycle_id`);

-- ========= cargo --> booking (12 constraint(s)) =========
-- Requires: cargo schema, booking schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ADD CONSTRAINT `fk_cargo_damage_claim_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);

-- ========= cargo --> compliance (15 constraint(s)) =========
-- Requires: cargo schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_trade_restriction_id` FOREIGN KEY (`trade_restriction_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_restriction`(`trade_restriction_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ADD CONSTRAINT `fk_cargo_manifest_line_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_violation_id` FOREIGN KEY (`violation_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`violation`(`violation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_violation_id` FOREIGN KEY (`violation_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`violation`(`violation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_trade_restriction_id` FOREIGN KEY (`trade_restriction_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_restriction`(`trade_restriction_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_import_export_permit_id` FOREIGN KEY (`import_export_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`import_export_permit`(`import_export_permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ADD CONSTRAINT `fk_cargo_cargo_document_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ADD CONSTRAINT `fk_cargo_damage_claim_violation_id` FOREIGN KEY (`violation_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`violation`(`violation_id`);

-- ========= cargo --> contract (5 constraint(s)) =========
-- Requires: cargo schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ADD CONSTRAINT `fk_cargo_damage_claim_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= cargo --> customer (10 constraint(s)) =========
-- Requires: cargo schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_tertiary_shipment_port_community_participant_id` FOREIGN KEY (`tertiary_shipment_port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ADD CONSTRAINT `fk_cargo_stowage_position_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_contact_person_id` FOREIGN KEY (`contact_person_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`contact_person`(`contact_person_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ADD CONSTRAINT `fk_cargo_cargo_document_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ADD CONSTRAINT `fk_cargo_damage_claim_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= cargo --> finance (6 constraint(s)) =========
-- Requires: cargo schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ADD CONSTRAINT `fk_cargo_damage_claim_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ADD CONSTRAINT `fk_cargo_damage_claim_provision_id` FOREIGN KEY (`provision_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`provision`(`provision_id`);

-- ========= cargo --> infrastructure (14 constraint(s)) =========
-- Requires: cargo schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_demurrage_terminal_zone_id` FOREIGN KEY (`demurrage_terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_weighing_station_id` FOREIGN KEY (`weighing_station_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`weighing_station`(`weighing_station_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ADD CONSTRAINT `fk_cargo_container_gate_transaction_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);

-- ========= cargo --> intermodal (3 constraint(s)) =========
-- Requires: cargo schema, intermodal schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ADD CONSTRAINT `fk_cargo_cargo_rail_wagon_load_intermodal_rail_wagon_load_id` FOREIGN KEY (`intermodal_rail_wagon_load_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load`(`intermodal_rail_wagon_load_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ADD CONSTRAINT `fk_cargo_cargo_rail_wagon_load_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ADD CONSTRAINT `fk_cargo_container_gate_transaction_truck_visit_id` FOREIGN KEY (`truck_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_visit`(`truck_visit_id`);

-- ========= cargo --> masterdata (18 constraint(s)) =========
-- Requires: cargo schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_packaging_type_id` FOREIGN KEY (`packaging_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`packaging_type`(`packaging_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_packaging_type_id` FOREIGN KEY (`packaging_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`packaging_type`(`packaging_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ADD CONSTRAINT `fk_cargo_manifest_line_packaging_type_id` FOREIGN KEY (`packaging_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`packaging_type`(`packaging_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ADD CONSTRAINT `fk_cargo_stowage_position_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_packaging_type_id` FOREIGN KEY (`packaging_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`packaging_type`(`packaging_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ADD CONSTRAINT `fk_cargo_container_preadvice_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ADD CONSTRAINT `fk_cargo_container_preadvice_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_packaging_type_id` FOREIGN KEY (`packaging_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`packaging_type`(`packaging_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ADD CONSTRAINT `fk_cargo_cargo_document_packaging_type_id` FOREIGN KEY (`packaging_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`packaging_type`(`packaging_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);

-- ========= cargo --> safety (6 constraint(s)) =========
-- Requires: cargo schema, safety schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_permit_to_work_id` FOREIGN KEY (`permit_to_work_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`permit_to_work`(`permit_to_work_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_permit_to_work_id` FOREIGN KEY (`permit_to_work_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`permit_to_work`(`permit_to_work_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_emergency_response_plan_id` FOREIGN KEY (`emergency_response_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`emergency_response_plan`(`emergency_response_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_hazard_register_id` FOREIGN KEY (`hazard_register_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`hazard_register`(`hazard_register_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_risk_assessment_id` FOREIGN KEY (`risk_assessment_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`risk_assessment`(`risk_assessment_id`);

-- ========= cargo --> security (15 constraint(s)) =========
-- Requires: cargo schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_cyber_incident_id` FOREIGN KEY (`cyber_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`cyber_incident`(`cyber_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_threat_assessment_id` FOREIGN KEY (`threat_assessment_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`threat_assessment`(`threat_assessment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_access_event_id` FOREIGN KEY (`access_event_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_event`(`access_event_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_dos_record_id` FOREIGN KEY (`dos_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`dos_record`(`dos_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_dos_record_id` FOREIGN KEY (`dos_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`dos_record`(`dos_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ADD CONSTRAINT `fk_cargo_container_preadvice_screening_record_id` FOREIGN KEY (`screening_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`screening_record`(`screening_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_access_event_id` FOREIGN KEY (`access_event_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_event`(`access_event_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_visitor_log_id` FOREIGN KEY (`visitor_log_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`visitor_log`(`visitor_log_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ADD CONSTRAINT `fk_cargo_damage_claim_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);

-- ========= cargo --> tariff (13 constraint(s)) =========
-- Requires: cargo schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_storage_tariff_id` FOREIGN KEY (`storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_wharfage_schedule_id` FOREIGN KEY (`wharfage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule`(`wharfage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_thc_schedule_id` FOREIGN KEY (`thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_demurrage_schedule_id` FOREIGN KEY (`demurrage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule`(`demurrage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_detention_schedule_id` FOREIGN KEY (`detention_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`detention_schedule`(`detention_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_thc_schedule_id` FOREIGN KEY (`thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ADD CONSTRAINT `fk_cargo_shipment_tariff_exception_exception_id` FOREIGN KEY (`exception_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`exception`(`exception_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bol_discount_application` ADD CONSTRAINT `fk_cargo_bol_discount_application_discount_scheme_id` FOREIGN KEY (`discount_scheme_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`discount_scheme`(`discount_scheme_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ADD CONSTRAINT `fk_cargo_container_surcharge_application_surcharge_rule_id` FOREIGN KEY (`surcharge_rule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule`(`surcharge_rule_id`);

-- ========= cargo --> terminal (1 constraint(s)) =========
-- Requires: cargo schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_terminal_equipment_id` FOREIGN KEY (`terminal_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment`(`terminal_equipment_id`);

-- ========= cargo --> vessel (17 constraint(s)) =========
-- Requires: cargo schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_agent_appointment_id` FOREIGN KEY (`agent_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`agent_appointment`(`agent_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ADD CONSTRAINT `fk_cargo_stowage_position_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_position` ADD CONSTRAINT `fk_cargo_stowage_position_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_preadvice` ADD CONSTRAINT `fk_cargo_container_preadvice_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ADD CONSTRAINT `fk_cargo_damage_claim_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);

-- ========= cargo --> workforce (19 constraint(s)) =========
-- Requires: cargo schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_shift_pattern_id` FOREIGN KEY (`shift_pattern_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`shift_pattern`(`shift_pattern_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_primary_stowage_employee_id` FOREIGN KEY (`primary_stowage_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`lcl_consolidation` ADD CONSTRAINT `fk_cargo_lcl_consolidation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_document` ADD CONSTRAINT `fk_cargo_cargo_document_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`damage_claim` ADD CONSTRAINT `fk_cargo_damage_claim_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment_tariff_exception` ADD CONSTRAINT `fk_cargo_shipment_tariff_exception_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ADD CONSTRAINT `fk_cargo_cargo_rail_wagon_load_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`cargo_rail_wagon_load` ADD CONSTRAINT `fk_cargo_cargo_rail_wagon_load_cargo_employee_id` FOREIGN KEY (`cargo_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_gate_transaction` ADD CONSTRAINT `fk_cargo_container_gate_transaction_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container_surcharge_application` ADD CONSTRAINT `fk_cargo_container_surcharge_application_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= compliance --> cargo (6 constraint(s)) =========
-- Requires: compliance schema, cargo schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_dangerous_goods_declaration_id` FOREIGN KEY (`dangerous_goods_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration`(`dangerous_goods_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_manifest_id` FOREIGN KEY (`manifest_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`manifest`(`manifest_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);

-- ========= compliance --> customer (1 constraint(s)) =========
-- Requires: compliance schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_broker` ADD CONSTRAINT `fk_compliance_customs_broker_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= compliance --> finance (11 constraint(s)) =========
-- Requires: compliance schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record` ADD CONSTRAINT `fk_compliance_isps_facility_record_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record` ADD CONSTRAINT `fk_compliance_isps_facility_record_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_hold` ADD CONSTRAINT `fk_compliance_customs_hold_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`violation` ADD CONSTRAINT `fk_compliance_violation_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`marpol_record` ADD CONSTRAINT `fk_compliance_marpol_record_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`marpol_record` ADD CONSTRAINT `fk_compliance_marpol_record_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`compliance_audit` ADD CONSTRAINT `fk_compliance_compliance_audit_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`compliance_audit` ADD CONSTRAINT `fk_compliance_compliance_audit_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);

-- ========= compliance --> infrastructure (1 constraint(s)) =========
-- Requires: compliance schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record` ADD CONSTRAINT `fk_compliance_isps_facility_record_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);

-- ========= compliance --> masterdata (20 constraint(s)) =========
-- Requires: compliance schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record` ADD CONSTRAINT `fk_compliance_isps_facility_record_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`import_export_permit` ADD CONSTRAINT `fk_compliance_import_export_permit_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`import_export_permit` ADD CONSTRAINT `fk_compliance_import_export_permit_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_hold` ADD CONSTRAINT `fk_compliance_customs_hold_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`violation` ADD CONSTRAINT `fk_compliance_violation_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`violation` ADD CONSTRAINT `fk_compliance_violation_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`marpol_record` ADD CONSTRAINT `fk_compliance_marpol_record_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`marpol_record` ADD CONSTRAINT `fk_compliance_marpol_record_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_restriction` ADD CONSTRAINT `fk_compliance_trade_restriction_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_restriction` ADD CONSTRAINT `fk_compliance_trade_restriction_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_broker` ADD CONSTRAINT `fk_compliance_customs_broker_edi_partner_id` FOREIGN KEY (`edi_partner_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`edi_partner`(`edi_partner_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_broker` ADD CONSTRAINT `fk_compliance_customs_broker_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`compliance_audit` ADD CONSTRAINT `fk_compliance_compliance_audit_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`compliance_audit` ADD CONSTRAINT `fk_compliance_compliance_audit_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);

-- ========= compliance --> procurement (8 constraint(s)) =========
-- Requires: compliance schema, procurement schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record` ADD CONSTRAINT `fk_compliance_isps_facility_record_procurement_plan_id` FOREIGN KEY (`procurement_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`procurement_plan`(`procurement_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`import_export_permit` ADD CONSTRAINT `fk_compliance_import_export_permit_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`violation` ADD CONSTRAINT `fk_compliance_violation_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`violation` ADD CONSTRAINT `fk_compliance_violation_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= compliance --> security (6 constraint(s)) =========
-- Requires: compliance schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_watchlist_entry_id` FOREIGN KEY (`watchlist_entry_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`watchlist_entry`(`watchlist_entry_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_hold` ADD CONSTRAINT `fk_compliance_customs_hold_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`violation` ADD CONSTRAINT `fk_compliance_violation_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`declaration_screening` ADD CONSTRAINT `fk_compliance_declaration_screening_screening_record_id` FOREIGN KEY (`screening_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`screening_record`(`screening_record_id`);

-- ========= compliance --> vessel (3 constraint(s)) =========
-- Requires: compliance schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);

-- ========= compliance --> workforce (11 constraint(s)) =========
-- Requires: compliance schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record` ADD CONSTRAINT `fk_compliance_isps_facility_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`import_export_permit` ADD CONSTRAINT `fk_compliance_import_export_permit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_hold` ADD CONSTRAINT `fk_compliance_customs_hold_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_hold` ADD CONSTRAINT `fk_compliance_customs_hold_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`violation` ADD CONSTRAINT `fk_compliance_violation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`marpol_record` ADD CONSTRAINT `fk_compliance_marpol_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`compliance_audit` ADD CONSTRAINT `fk_compliance_compliance_audit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`declaration_screening` ADD CONSTRAINT `fk_compliance_declaration_screening_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= contract --> billing (3 constraint(s)) =========
-- Requires: contract schema, billing schema
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ADD CONSTRAINT `fk_contract_sla_measurement_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ADD CONSTRAINT `fk_contract_penalty_assessment_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ADD CONSTRAINT `fk_contract_dispute_record_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);

-- ========= contract --> compliance (9 constraint(s)) =========
-- Requires: contract schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_trade_restriction_id` FOREIGN KEY (`trade_restriction_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_restriction`(`trade_restriction_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ADD CONSTRAINT `fk_contract_service_scope_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ADD CONSTRAINT `fk_contract_sla_measurement_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ADD CONSTRAINT `fk_contract_sla_breach_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ADD CONSTRAINT `fk_contract_penalty_assessment_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ADD CONSTRAINT `fk_contract_dispute_record_violation_id` FOREIGN KEY (`violation_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`violation`(`violation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ADD CONSTRAINT `fk_contract_dispute_record_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ADD CONSTRAINT `fk_contract_guarantee_bond_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);

-- ========= contract --> customer (10 constraint(s)) =========
-- Requires: contract schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ADD CONSTRAINT `fk_contract_agreement_party_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ADD CONSTRAINT `fk_contract_sla_measurement_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ADD CONSTRAINT `fk_contract_sla_breach_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ADD CONSTRAINT `fk_contract_volume_commitment_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ADD CONSTRAINT `fk_contract_penalty_assessment_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ADD CONSTRAINT `fk_contract_penalty_assessment_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ADD CONSTRAINT `fk_contract_dispute_record_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ADD CONSTRAINT `fk_contract_dispute_record_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);

-- ========= contract --> finance (12 constraint(s)) =========
-- Requires: contract schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ADD CONSTRAINT `fk_contract_service_scope_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ADD CONSTRAINT `fk_contract_service_scope_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ADD CONSTRAINT `fk_contract_sla_measurement_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ADD CONSTRAINT `fk_contract_rate_schedule_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ADD CONSTRAINT `fk_contract_volume_commitment_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ADD CONSTRAINT `fk_contract_pil_arrangement_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ADD CONSTRAINT `fk_contract_penalty_assessment_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ADD CONSTRAINT `fk_contract_penalty_assessment_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ADD CONSTRAINT `fk_contract_penalty_assessment_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ADD CONSTRAINT `fk_contract_guarantee_bond_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);

-- ========= contract --> masterdata (14 constraint(s)) =========
-- Requires: contract schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ADD CONSTRAINT `fk_contract_service_scope_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ADD CONSTRAINT `fk_contract_service_scope_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ADD CONSTRAINT `fk_contract_service_scope_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ADD CONSTRAINT `fk_contract_service_scope_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ADD CONSTRAINT `fk_contract_sla_measurement_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ADD CONSTRAINT `fk_contract_rate_schedule_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ADD CONSTRAINT `fk_contract_rate_schedule_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ADD CONSTRAINT `fk_contract_rate_schedule_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ADD CONSTRAINT `fk_contract_rate_schedule_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);

-- ========= contract --> procurement (6 constraint(s)) =========
-- Requires: contract schema, procurement schema
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ADD CONSTRAINT `fk_contract_service_scope_material_group_id` FOREIGN KEY (`material_group_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_group`(`material_group_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ADD CONSTRAINT `fk_contract_rate_schedule_material_group_id` FOREIGN KEY (`material_group_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_group`(`material_group_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ADD CONSTRAINT `fk_contract_dispute_record_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ADD CONSTRAINT `fk_contract_dispute_record_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= contract --> security (4 constraint(s)) =========
-- Requires: contract schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_party` ADD CONSTRAINT `fk_contract_agreement_party_access_credential_id` FOREIGN KEY (`access_credential_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_credential`(`access_credential_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ADD CONSTRAINT `fk_contract_sla_measurement_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ADD CONSTRAINT `fk_contract_contract_document_facility_security_plan_id` FOREIGN KEY (`facility_security_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`facility_security_plan`(`facility_security_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ADD CONSTRAINT `fk_contract_dispute_record_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);

-- ========= contract --> tariff (3 constraint(s)) =========
-- Requires: contract schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ADD CONSTRAINT `fk_contract_sla_definition_sla_rate_card_id` FOREIGN KEY (`sla_rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card`(`sla_rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ADD CONSTRAINT `fk_contract_rate_schedule_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ADD CONSTRAINT `fk_contract_penalty_assessment_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);

-- ========= contract --> terminal (2 constraint(s)) =========
-- Requires: contract schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ADD CONSTRAINT `fk_contract_sla_measurement_terminal_berth_allocation_id` FOREIGN KEY (`terminal_berth_allocation_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation`(`terminal_berth_allocation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_breach` ADD CONSTRAINT `fk_contract_sla_breach_terminal_berth_allocation_id` FOREIGN KEY (`terminal_berth_allocation_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation`(`terminal_berth_allocation_id`);

-- ========= contract --> vessel (2 constraint(s)) =========
-- Requires: contract schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ADD CONSTRAINT `fk_contract_sla_measurement_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ADD CONSTRAINT `fk_contract_penalty_assessment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);

-- ========= contract --> workforce (13 constraint(s)) =========
-- Requires: contract schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement` ADD CONSTRAINT `fk_contract_agreement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`agreement_version` ADD CONSTRAINT `fk_contract_agreement_version_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`service_scope` ADD CONSTRAINT `fk_contract_service_scope_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_definition` ADD CONSTRAINT `fk_contract_sla_definition_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`sla_measurement` ADD CONSTRAINT `fk_contract_sla_measurement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`rate_schedule` ADD CONSTRAINT `fk_contract_rate_schedule_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`volume_commitment` ADD CONSTRAINT `fk_contract_volume_commitment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`pil_arrangement` ADD CONSTRAINT `fk_contract_pil_arrangement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`contract_document` ADD CONSTRAINT `fk_contract_contract_document_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_clause` ADD CONSTRAINT `fk_contract_penalty_clause_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`penalty_assessment` ADD CONSTRAINT `fk_contract_penalty_assessment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`dispute_record` ADD CONSTRAINT `fk_contract_dispute_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`contract`.`guarantee_bond` ADD CONSTRAINT `fk_contract_guarantee_bond_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= customer --> cargo (4 constraint(s)) =========
-- Requires: customer schema, cargo schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`communication_log` ADD CONSTRAINT `fk_customer_communication_log_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`communication_log` ADD CONSTRAINT `fk_customer_communication_log_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);

-- ========= customer --> compliance (11 constraint(s)) =========
-- Requires: customer schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`accreditation` ADD CONSTRAINT `fk_customer_accreditation_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_violation_id` FOREIGN KEY (`violation_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`violation`(`violation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`communication_log` ADD CONSTRAINT `fk_customer_communication_log_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`communication_log` ADD CONSTRAINT `fk_customer_communication_log_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`onboarding_application` ADD CONSTRAINT `fk_customer_onboarding_application_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_document` ADD CONSTRAINT `fk_customer_participant_document_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_document` ADD CONSTRAINT `fk_customer_participant_document_trade_restriction_id` FOREIGN KEY (`trade_restriction_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_restriction`(`trade_restriction_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_access_permit` ADD CONSTRAINT `fk_customer_port_access_permit_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_trade_exemption` ADD CONSTRAINT `fk_customer_participant_trade_exemption_trade_restriction_id` FOREIGN KEY (`trade_restriction_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_restriction`(`trade_restriction_id`);

-- ========= customer --> contract (7 constraint(s)) =========
-- Requires: customer schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`sla_performance` ADD CONSTRAINT `fk_customer_sla_performance_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`sla_performance` ADD CONSTRAINT `fk_customer_sla_performance_sla_definition_id` FOREIGN KEY (`sla_definition_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`sla_definition`(`sla_definition_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`relationship_manager` ADD CONSTRAINT `fk_customer_relationship_manager_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_document` ADD CONSTRAINT `fk_customer_participant_document_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`edi_subscription` ADD CONSTRAINT `fk_customer_edi_subscription_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement` ADD CONSTRAINT `fk_customer_participant_service_agreement_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= customer --> finance (9 constraint(s)) =========
-- Requires: customer schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_account` ADD CONSTRAINT `fk_customer_participant_account_company_code_id` FOREIGN KEY (`company_code_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`company_code`(`company_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_account` ADD CONSTRAINT `fk_customer_participant_account_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`accreditation` ADD CONSTRAINT `fk_customer_accreditation_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`sla_performance` ADD CONSTRAINT `fk_customer_sla_performance_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`communication_log` ADD CONSTRAINT `fk_customer_communication_log_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`onboarding_application` ADD CONSTRAINT `fk_customer_onboarding_application_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);

-- ========= customer --> infrastructure (1 constraint(s)) =========
-- Requires: customer schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`edi_subscription` ADD CONSTRAINT `fk_customer_edi_subscription_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);

-- ========= customer --> masterdata (24 constraint(s)) =========
-- Requires: customer schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_community_participant` ADD CONSTRAINT `fk_customer_port_community_participant_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_community_participant` ADD CONSTRAINT `fk_customer_port_community_participant_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_account` ADD CONSTRAINT `fk_customer_participant_account_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_address` ADD CONSTRAINT `fk_customer_participant_address_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`accreditation` ADD CONSTRAINT `fk_customer_accreditation_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`accreditation` ADD CONSTRAINT `fk_customer_accreditation_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`sla_profile` ADD CONSTRAINT `fk_customer_sla_profile_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`sla_profile` ADD CONSTRAINT `fk_customer_sla_profile_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`sla_performance` ADD CONSTRAINT `fk_customer_sla_performance_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`sla_performance` ADD CONSTRAINT `fk_customer_sla_performance_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`communication_log` ADD CONSTRAINT `fk_customer_communication_log_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`communication_log` ADD CONSTRAINT `fk_customer_communication_log_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`onboarding_application` ADD CONSTRAINT `fk_customer_onboarding_application_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_document` ADD CONSTRAINT `fk_customer_participant_document_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_document` ADD CONSTRAINT `fk_customer_participant_document_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`edi_subscription` ADD CONSTRAINT `fk_customer_edi_subscription_edi_partner_id` FOREIGN KEY (`edi_partner_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`edi_partner`(`edi_partner_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`edi_subscription` ADD CONSTRAINT `fk_customer_edi_subscription_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_access_permit` ADD CONSTRAINT `fk_customer_port_access_permit_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement` ADD CONSTRAINT `fk_customer_participant_service_agreement_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`location_access_authorization` ADD CONSTRAINT `fk_customer_location_access_authorization_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`commodity_handling_authorization` ADD CONSTRAINT `fk_customer_commodity_handling_authorization_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);

-- ========= customer --> procurement (2 constraint(s)) =========
-- Requires: customer schema, procurement schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition`(`purchase_requisition_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_access_permit` ADD CONSTRAINT `fk_customer_port_access_permit_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= customer --> safety (5 constraint(s)) =========
-- Requires: customer schema, safety schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`accreditation` ADD CONSTRAINT `fk_customer_accreditation_contractor_safety_id` FOREIGN KEY (`contractor_safety_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`contractor_safety`(`contractor_safety_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_inspection_id` FOREIGN KEY (`inspection_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`inspection`(`inspection_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`communication_log` ADD CONSTRAINT `fk_customer_communication_log_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_access_permit` ADD CONSTRAINT `fk_customer_port_access_permit_contractor_safety_id` FOREIGN KEY (`contractor_safety_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`contractor_safety`(`contractor_safety_id`);

-- ========= customer --> security (4 constraint(s)) =========
-- Requires: customer schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`accreditation` ADD CONSTRAINT `fk_customer_accreditation_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`onboarding_application` ADD CONSTRAINT `fk_customer_onboarding_application_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_access_permit` ADD CONSTRAINT `fk_customer_port_access_permit_access_point_id` FOREIGN KEY (`access_point_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_point`(`access_point_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_access_permit` ADD CONSTRAINT `fk_customer_port_access_permit_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);

-- ========= customer --> vessel (2 constraint(s)) =========
-- Requires: customer schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`sla_performance` ADD CONSTRAINT `fk_customer_sla_performance_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`communication_log` ADD CONSTRAINT `fk_customer_communication_log_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);

-- ========= customer --> workforce (13 constraint(s)) =========
-- Requires: customer schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_community_participant` ADD CONSTRAINT `fk_customer_port_community_participant_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_account` ADD CONSTRAINT `fk_customer_participant_account_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`accreditation` ADD CONSTRAINT `fk_customer_accreditation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`communication_log` ADD CONSTRAINT `fk_customer_communication_log_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`credit_assessment` ADD CONSTRAINT `fk_customer_credit_assessment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`credit_assessment` ADD CONSTRAINT `fk_customer_credit_assessment_primary_credit_assessor_employee_id` FOREIGN KEY (`primary_credit_assessor_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`onboarding_application` ADD CONSTRAINT `fk_customer_onboarding_application_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`relationship_manager` ADD CONSTRAINT `fk_customer_relationship_manager_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_document` ADD CONSTRAINT `fk_customer_participant_document_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_access_permit` ADD CONSTRAINT `fk_customer_port_access_permit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`location_access_authorization` ADD CONSTRAINT `fk_customer_location_access_authorization_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`commodity_handling_authorization` ADD CONSTRAINT `fk_customer_commodity_handling_authorization_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= finance --> asset (1 constraint(s)) =========
-- Requires: finance schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_equipment_class_id` FOREIGN KEY (`equipment_class_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`equipment_class`(`equipment_class_id`);

-- ========= finance --> billing (4 constraint(s)) =========
-- Requires: finance schema, billing schema
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_billing_run_id` FOREIGN KEY (`billing_run_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`billing_run`(`billing_run_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_billing_run_id` FOREIGN KEY (`billing_run_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`billing_run`(`billing_run_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ADD CONSTRAINT `fk_finance_receivable_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);

-- ========= finance --> compliance (2 constraint(s)) =========
-- Requires: finance schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ADD CONSTRAINT `fk_finance_provision_violation_id` FOREIGN KEY (`violation_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`violation`(`violation_id`);

-- ========= finance --> contract (1 constraint(s)) =========
-- Requires: finance schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`intercompany_transaction` ADD CONSTRAINT `fk_finance_intercompany_transaction_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= finance --> customer (2 constraint(s)) =========
-- Requires: finance schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ADD CONSTRAINT `fk_finance_receivable_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);

-- ========= finance --> infrastructure (1 constraint(s)) =========
-- Requires: finance schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);

-- ========= finance --> masterdata (10 constraint(s)) =========
-- Requires: finance schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ADD CONSTRAINT `fk_finance_cost_centre_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ADD CONSTRAINT `fk_finance_profit_centre_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`receivable` ADD CONSTRAINT `fk_finance_receivable_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);

-- ========= finance --> procurement (12 constraint(s)) =========
-- Requires: finance schema, procurement schema
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition`(`purchase_requisition_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_purchase_requisition_id` FOREIGN KEY (`purchase_requisition_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition`(`purchase_requisition_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ADD CONSTRAINT `fk_finance_budget_plan_procurement_plan_id` FOREIGN KEY (`procurement_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`procurement_plan`(`procurement_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_material_group_id` FOREIGN KEY (`material_group_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_group`(`material_group_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_goods_receipt_id` FOREIGN KEY (`goods_receipt_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`goods_receipt`(`goods_receipt_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ADD CONSTRAINT `fk_finance_lease_liability_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= finance --> security (4 constraint(s)) =========
-- Requires: finance schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ADD CONSTRAINT `fk_finance_cost_centre_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_security_equipment_id` FOREIGN KEY (`security_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_equipment`(`security_equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`asset_transaction` ADD CONSTRAINT `fk_finance_asset_transaction_security_equipment_id` FOREIGN KEY (`security_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_equipment`(`security_equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ADD CONSTRAINT `fk_finance_provision_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);

-- ========= finance --> workforce (31 constraint(s)) =========
-- Requires: finance schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_centre` ADD CONSTRAINT `fk_finance_cost_centre_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`profit_centre` ADD CONSTRAINT `fk_finance_profit_centre_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order` ADD CONSTRAINT `fk_finance_internal_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`wbs_element` ADD CONSTRAINT `fk_finance_wbs_element_tertiary_wbs_last_modified_by_employee_id` FOREIGN KEY (`tertiary_wbs_last_modified_by_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry` ADD CONSTRAINT `fk_finance_journal_entry_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`journal_entry_line` ADD CONSTRAINT `fk_finance_journal_entry_line_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_invoice` ADD CONSTRAINT `fk_finance_ap_invoice_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`ap_payment` ADD CONSTRAINT `fk_finance_ap_payment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ADD CONSTRAINT `fk_finance_budget_plan_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ADD CONSTRAINT `fk_finance_budget_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_plan` ADD CONSTRAINT `fk_finance_budget_plan_tertiary_budget_modified_by_employee_id` FOREIGN KEY (`tertiary_budget_modified_by_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`budget_line` ADD CONSTRAINT `fk_finance_budget_line_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`cost_allocation` ADD CONSTRAINT `fk_finance_cost_allocation_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`fixed_asset` ADD CONSTRAINT `fk_finance_fixed_asset_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`company_code` ADD CONSTRAINT `fk_finance_company_code_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`accrual` ADD CONSTRAINT `fk_finance_accrual_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`lease_liability` ADD CONSTRAINT `fk_finance_lease_liability_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`provision` ADD CONSTRAINT `fk_finance_provision_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ADD CONSTRAINT `fk_finance_internal_order_gang_assignment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`internal_order_gang_assignment` ADD CONSTRAINT `fk_finance_internal_order_gang_assignment_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`project_gang_assignment` ADD CONSTRAINT `fk_finance_project_gang_assignment_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ADD CONSTRAINT `fk_finance_investment_program_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ADD CONSTRAINT `fk_finance_investment_program_investment_sponsor_employee_id` FOREIGN KEY (`investment_sponsor_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`finance`.`investment_program` ADD CONSTRAINT `fk_finance_investment_program_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);

-- ========= infrastructure --> asset (10 constraint(s)) =========
-- Requires: infrastructure schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ADD CONSTRAINT `fk_infrastructure_navigational_aid_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ADD CONSTRAINT `fk_infrastructure_project_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ADD CONSTRAINT `fk_infrastructure_structural_inspection_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ADD CONSTRAINT `fk_infrastructure_structural_inspection_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ADD CONSTRAINT `fk_infrastructure_utility_network_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);

-- ========= infrastructure --> booking (5 constraint(s)) =========
-- Requires: infrastructure schema, booking schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ADD CONSTRAINT `fk_infrastructure_infrastructure_berth_reservation_booking_berth_reservation_id` FOREIGN KEY (`booking_berth_reservation_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation`(`booking_berth_reservation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_reservation` ADD CONSTRAINT `fk_infrastructure_infrastructure_berth_reservation_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ADD CONSTRAINT `fk_infrastructure_infrastructure_anchorage_booking_booking_anchorage_booking_id` FOREIGN KEY (`booking_anchorage_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`booking_anchorage_booking`(`booking_anchorage_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ADD CONSTRAINT `fk_infrastructure_infrastructure_anchorage_booking_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);

-- ========= infrastructure --> compliance (7 constraint(s)) =========
-- Requires: infrastructure schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_marpol_record_id` FOREIGN KEY (`marpol_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`marpol_record`(`marpol_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ADD CONSTRAINT `fk_infrastructure_navigational_aid_compliance_audit_id` FOREIGN KEY (`compliance_audit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`compliance_audit`(`compliance_audit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_marpol_record_id` FOREIGN KEY (`marpol_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`marpol_record`(`marpol_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ADD CONSTRAINT `fk_infrastructure_utility_network_compliance_audit_id` FOREIGN KEY (`compliance_audit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`compliance_audit`(`compliance_audit_id`);

-- ========= infrastructure --> contract (6 constraint(s)) =========
-- Requires: infrastructure schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ADD CONSTRAINT `fk_infrastructure_permit_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ADD CONSTRAINT `fk_infrastructure_infrastructure_berth_allocation_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ADD CONSTRAINT `fk_infrastructure_berth_service_contract_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= infrastructure --> customer (10 constraint(s)) =========
-- Requires: infrastructure schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ADD CONSTRAINT `fk_infrastructure_project_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ADD CONSTRAINT `fk_infrastructure_facility_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ADD CONSTRAINT `fk_infrastructure_facility_facility_terminal_operator_port_community_participant_id` FOREIGN KEY (`facility_terminal_operator_port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility` ADD CONSTRAINT `fk_infrastructure_waste_reception_facility_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= infrastructure --> finance (13 constraint(s)) =========
-- Requires: infrastructure schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ADD CONSTRAINT `fk_infrastructure_quay_wall_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ADD CONSTRAINT `fk_infrastructure_navigational_aid_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ADD CONSTRAINT `fk_infrastructure_project_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ADD CONSTRAINT `fk_infrastructure_project_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ADD CONSTRAINT `fk_infrastructure_structural_inspection_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ADD CONSTRAINT `fk_infrastructure_utility_network_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ADD CONSTRAINT `fk_infrastructure_permit_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);

-- ========= infrastructure --> masterdata (16 constraint(s)) =========
-- Requires: infrastructure schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ADD CONSTRAINT `fk_infrastructure_quay_wall_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ADD CONSTRAINT `fk_infrastructure_navigational_aid_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ADD CONSTRAINT `fk_infrastructure_channel_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ADD CONSTRAINT `fk_infrastructure_depth_survey_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ADD CONSTRAINT `fk_infrastructure_anchorage_area_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ADD CONSTRAINT `fk_infrastructure_project_service_cost_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_commodity_approval` ADD CONSTRAINT `fk_infrastructure_warehouse_commodity_approval_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse_imdg_approval` ADD CONSTRAINT `fk_infrastructure_warehouse_imdg_approval_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal` ADD CONSTRAINT `fk_infrastructure_infrastructure_terminal_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ADD CONSTRAINT `fk_infrastructure_port_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);

-- ========= infrastructure --> procurement (11 constraint(s)) =========
-- Requires: infrastructure schema, procurement schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ADD CONSTRAINT `fk_infrastructure_quay_wall_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ADD CONSTRAINT `fk_infrastructure_navigational_aid_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ADD CONSTRAINT `fk_infrastructure_project_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ADD CONSTRAINT `fk_infrastructure_project_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ADD CONSTRAINT `fk_infrastructure_structural_inspection_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ADD CONSTRAINT `fk_infrastructure_utility_network_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ADD CONSTRAINT `fk_infrastructure_permit_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth_service_contract` ADD CONSTRAINT `fk_infrastructure_berth_service_contract_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= infrastructure --> safety (1 constraint(s)) =========
-- Requires: infrastructure schema, safety schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_emergency_response_plan_id` FOREIGN KEY (`emergency_response_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`emergency_response_plan`(`emergency_response_plan_id`);

-- ========= infrastructure --> security (13 constraint(s)) =========
-- Requires: infrastructure schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ADD CONSTRAINT `fk_infrastructure_navigational_aid_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ADD CONSTRAINT `fk_infrastructure_channel_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ADD CONSTRAINT `fk_infrastructure_depth_survey_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ADD CONSTRAINT `fk_infrastructure_project_facility_security_plan_id` FOREIGN KEY (`facility_security_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`facility_security_plan`(`facility_security_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ADD CONSTRAINT `fk_infrastructure_project_threat_assessment_id` FOREIGN KEY (`threat_assessment_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`threat_assessment`(`threat_assessment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ADD CONSTRAINT `fk_infrastructure_structural_inspection_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ADD CONSTRAINT `fk_infrastructure_anchorage_area_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ADD CONSTRAINT `fk_infrastructure_permit_facility_security_plan_id` FOREIGN KEY (`facility_security_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`facility_security_plan`(`facility_security_plan_id`);

-- ========= infrastructure --> tariff (1 constraint(s)) =========
-- Requires: infrastructure schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_exception_id` FOREIGN KEY (`exception_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`exception`(`exception_id`);

-- ========= infrastructure --> terminal (1 constraint(s)) =========
-- Requires: infrastructure schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation` ADD CONSTRAINT `fk_infrastructure_infrastructure_berth_allocation_terminal_berth_allocation_id` FOREIGN KEY (`terminal_berth_allocation_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation`(`terminal_berth_allocation_id`);

-- ========= infrastructure --> vessel (1 constraint(s)) =========
-- Requires: infrastructure schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ADD CONSTRAINT `fk_infrastructure_infrastructure_anchorage_booking_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);

-- ========= infrastructure --> workforce (16 constraint(s)) =========
-- Requires: infrastructure schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ADD CONSTRAINT `fk_infrastructure_quay_wall_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid` ADD CONSTRAINT `fk_infrastructure_navigational_aid_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ADD CONSTRAINT `fk_infrastructure_channel_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`depth_survey` ADD CONSTRAINT `fk_infrastructure_depth_survey_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`dredging_campaign` ADD CONSTRAINT `fk_infrastructure_dredging_campaign_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project` ADD CONSTRAINT `fk_infrastructure_project_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`structural_inspection` ADD CONSTRAINT `fk_infrastructure_structural_inspection_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`utility_network` ADD CONSTRAINT `fk_infrastructure_utility_network_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`closure` ADD CONSTRAINT `fk_infrastructure_closure_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`permit` ADD CONSTRAINT `fk_infrastructure_permit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_anchorage_booking` ADD CONSTRAINT `fk_infrastructure_infrastructure_anchorage_booking_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`project_service_cost` ADD CONSTRAINT `fk_infrastructure_project_service_cost_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= intermodal --> asset (6 constraint(s)) =========
-- Requires: intermodal schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ADD CONSTRAINT `fk_intermodal_rail_wagon_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= intermodal --> booking (6 constraint(s)) =========
-- Requires: intermodal schema, booking schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ADD CONSTRAINT `fk_intermodal_slot_booking_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);

-- ========= intermodal --> cargo (9 constraint(s)) =========
-- Requires: intermodal schema, cargo schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_manifest_id` FOREIGN KEY (`manifest_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`manifest`(`manifest_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ADD CONSTRAINT `fk_intermodal_intermodal_rail_wagon_load_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ADD CONSTRAINT `fk_intermodal_intermodal_rail_wagon_load_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ADD CONSTRAINT `fk_intermodal_edi_message_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ADD CONSTRAINT `fk_intermodal_last_mile_event_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ADD CONSTRAINT `fk_intermodal_last_mile_event_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_bill_of_lading_id` FOREIGN KEY (`bill_of_lading_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading`(`bill_of_lading_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);

-- ========= intermodal --> compliance (15 constraint(s)) =========
-- Requires: intermodal schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_trade_document_id` FOREIGN KEY (`trade_document_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_document`(`trade_document_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_import_export_permit_id` FOREIGN KEY (`import_export_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`import_export_permit`(`import_export_permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_trade_document_id` FOREIGN KEY (`trade_document_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_document`(`trade_document_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_trade_restriction_id` FOREIGN KEY (`trade_restriction_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_restriction`(`trade_restriction_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ADD CONSTRAINT `fk_intermodal_haulier_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);

-- ========= intermodal --> contract (9 constraint(s)) =========
-- Requires: intermodal schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ADD CONSTRAINT `fk_intermodal_haulier_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ADD CONSTRAINT `fk_intermodal_rail_operator_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ADD CONSTRAINT `fk_intermodal_slot_booking_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ADD CONSTRAINT `fk_intermodal_intermodal_service_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= intermodal --> customer (12 constraint(s)) =========
-- Requires: intermodal schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_port_access_permit_id` FOREIGN KEY (`port_access_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_access_permit`(`port_access_permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_tertiary_transport_carrier_participant_account_id` FOREIGN KEY (`tertiary_transport_carrier_participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ADD CONSTRAINT `fk_intermodal_edi_message_edi_subscription_id` FOREIGN KEY (`edi_subscription_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`edi_subscription`(`edi_subscription_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ADD CONSTRAINT `fk_intermodal_haulier_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ADD CONSTRAINT `fk_intermodal_rail_operator_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ADD CONSTRAINT `fk_intermodal_slot_booking_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`facility_access_agreement` ADD CONSTRAINT `fk_intermodal_facility_access_agreement_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service_subscription` ADD CONSTRAINT `fk_intermodal_service_subscription_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ADD CONSTRAINT `fk_intermodal_intermodal_service_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= intermodal --> finance (11 constraint(s)) =========
-- Requires: intermodal schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ADD CONSTRAINT `fk_intermodal_intermodal_service_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ADD CONSTRAINT `fk_intermodal_intermodal_service_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);

-- ========= intermodal --> infrastructure (15 constraint(s)) =========
-- Requires: intermodal schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ADD CONSTRAINT `fk_intermodal_slot_booking_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ADD CONSTRAINT `fk_intermodal_last_mile_event_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ADD CONSTRAINT `fk_intermodal_last_mile_event_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ADD CONSTRAINT `fk_intermodal_last_mile_event_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);

-- ========= intermodal --> masterdata (20 constraint(s)) =========
-- Requires: intermodal schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ADD CONSTRAINT `fk_intermodal_rail_wagon_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ADD CONSTRAINT `fk_intermodal_intermodal_rail_wagon_load_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ADD CONSTRAINT `fk_intermodal_edi_message_edi_partner_id` FOREIGN KEY (`edi_partner_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`edi_partner`(`edi_partner_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ADD CONSTRAINT `fk_intermodal_haulier_edi_partner_id` FOREIGN KEY (`edi_partner_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`edi_partner`(`edi_partner_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ADD CONSTRAINT `fk_intermodal_rail_operator_edi_partner_id` FOREIGN KEY (`edi_partner_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`edi_partner`(`edi_partner_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ADD CONSTRAINT `fk_intermodal_last_mile_event_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ADD CONSTRAINT `fk_intermodal_last_mile_event_primary_last_port_location_id` FOREIGN KEY (`primary_last_port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_transport_port_location_id` FOREIGN KEY (`transport_port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ADD CONSTRAINT `fk_intermodal_intermodal_service_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);

-- ========= intermodal --> procurement (2 constraint(s)) =========
-- Requires: intermodal schema, procurement schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ADD CONSTRAINT `fk_intermodal_haulier_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ADD CONSTRAINT `fk_intermodal_rail_operator_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= intermodal --> safety (8 constraint(s)) =========
-- Requires: intermodal schema, safety schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ADD CONSTRAINT `fk_intermodal_rail_wagon_ghg_emission_record_id` FOREIGN KEY (`ghg_emission_record_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record`(`ghg_emission_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ADD CONSTRAINT `fk_intermodal_rail_wagon_inspection_id` FOREIGN KEY (`inspection_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`inspection`(`inspection_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_inspection_id` FOREIGN KEY (`inspection_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`inspection`(`inspection_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_permit_to_work_id` FOREIGN KEY (`permit_to_work_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`permit_to_work`(`permit_to_work_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_inspection_id` FOREIGN KEY (`inspection_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`inspection`(`inspection_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ADD CONSTRAINT `fk_intermodal_haulier_contractor_safety_id` FOREIGN KEY (`contractor_safety_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`contractor_safety`(`contractor_safety_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ADD CONSTRAINT `fk_intermodal_rail_operator_contractor_safety_id` FOREIGN KEY (`contractor_safety_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`contractor_safety`(`contractor_safety_id`);

-- ========= intermodal --> security (13 constraint(s)) =========
-- Requires: intermodal schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_access_credential_id` FOREIGN KEY (`access_credential_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_credential`(`access_credential_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_access_event_id` FOREIGN KEY (`access_event_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_event`(`access_event_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_access_credential_id` FOREIGN KEY (`access_credential_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_credential`(`access_credential_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_facility_security_plan_id` FOREIGN KEY (`facility_security_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`facility_security_plan`(`facility_security_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`edi_message` ADD CONSTRAINT `fk_intermodal_edi_message_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ADD CONSTRAINT `fk_intermodal_haulier_access_credential_id` FOREIGN KEY (`access_credential_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_credential`(`access_credential_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ADD CONSTRAINT `fk_intermodal_driver_authorization_access_credential_id` FOREIGN KEY (`access_credential_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_credential`(`access_credential_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ADD CONSTRAINT `fk_intermodal_intermodal_service_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);

-- ========= intermodal --> tariff (5 constraint(s)) =========
-- Requires: intermodal schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ADD CONSTRAINT `fk_intermodal_slot_booking_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ADD CONSTRAINT `fk_intermodal_intermodal_service_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);

-- ========= intermodal --> terminal (2 constraint(s)) =========
-- Requires: intermodal schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_gate_transaction_id` FOREIGN KEY (`gate_transaction_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`gate_transaction`(`gate_transaction_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_equipment_dispatch_id` FOREIGN KEY (`equipment_dispatch_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch`(`equipment_dispatch_id`);

-- ========= intermodal --> vessel (5 constraint(s)) =========
-- Requires: intermodal schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ADD CONSTRAINT `fk_intermodal_intermodal_rail_wagon_load_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`slot_booking` ADD CONSTRAINT `fk_intermodal_slot_booking_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_leg` ADD CONSTRAINT `fk_intermodal_transport_leg_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);

-- ========= intermodal --> workforce (12 constraint(s)) =========
-- Requires: intermodal schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_truck_employee_id` FOREIGN KEY (`truck_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_rail_wagon_load` ADD CONSTRAINT `fk_intermodal_intermodal_rail_wagon_load_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`last_mile_event` ADD CONSTRAINT `fk_intermodal_last_mile_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier_icd_service_agreement` ADD CONSTRAINT `fk_intermodal_haulier_icd_service_agreement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`driver_authorization` ADD CONSTRAINT `fk_intermodal_driver_authorization_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`intermodal_service` ADD CONSTRAINT `fk_intermodal_intermodal_service_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= marine --> asset (6 constraint(s)) =========
-- Requires: marine schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ADD CONSTRAINT `fk_marine_launch_dispatch_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ADD CONSTRAINT `fk_marine_marpol_operation_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= marine --> billing (6 constraint(s)) =========
-- Requires: marine schema, billing schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ADD CONSTRAINT `fk_marine_launch_dispatch_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_adjustment_id` FOREIGN KEY (`adjustment_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`adjustment`(`adjustment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ADD CONSTRAINT `fk_marine_marpol_operation_charge_event_id` FOREIGN KEY (`charge_event_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`charge_event`(`charge_event_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_proforma_invoice_id` FOREIGN KEY (`proforma_invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`proforma_invoice`(`proforma_invoice_id`);

-- ========= marine --> booking (8 constraint(s)) =========
-- Requires: marine schema, booking schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ADD CONSTRAINT `fk_marine_launch_dispatch_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ADD CONSTRAINT `fk_marine_marpol_operation_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);

-- ========= marine --> compliance (5 constraint(s)) =========
-- Requires: marine schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_marpol_record_id` FOREIGN KEY (`marpol_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`marpol_record`(`marpol_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_violation_id` FOREIGN KEY (`violation_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`violation`(`violation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_violation_id` FOREIGN KEY (`violation_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`violation`(`violation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ADD CONSTRAINT `fk_marine_marpol_operation_marpol_record_id` FOREIGN KEY (`marpol_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`marpol_record`(`marpol_record_id`);

-- ========= marine --> contract (7 constraint(s)) =========
-- Requires: marine schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor_authorization` ADD CONSTRAINT `fk_marine_surveyor_authorization_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= marine --> customer (7 constraint(s)) =========
-- Requires: marine schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ADD CONSTRAINT `fk_marine_marpol_operation_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ADD CONSTRAINT `fk_marine_pilotage_exemption_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_tertiary_marine_approved_mooring_provider_port_community_participant_id` FOREIGN KEY (`tertiary_marine_approved_mooring_provider_port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= marine --> finance (11 constraint(s)) =========
-- Requires: marine schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ADD CONSTRAINT `fk_marine_launch_dispatch_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_provision_id` FOREIGN KEY (`provision_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`provision`(`provision_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ADD CONSTRAINT `fk_marine_marpol_operation_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);

-- ========= marine --> infrastructure (22 constraint(s)) =========
-- Requires: marine schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ADD CONSTRAINT `fk_marine_launch_dispatch_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ADD CONSTRAINT `fk_marine_weather_tide_window_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ADD CONSTRAINT `fk_marine_weather_tide_window_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_channel_authorisation` ADD CONSTRAINT `fk_marine_pilot_channel_authorisation_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);

-- ========= marine --> intermodal (7 constraint(s)) =========
-- Requires: marine schema, intermodal schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_truck_visit_id` FOREIGN KEY (`truck_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_visit`(`truck_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_drayage_order_id` FOREIGN KEY (`drayage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`drayage_order`(`drayage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_truck_visit_id` FOREIGN KEY (`truck_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_visit`(`truck_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ADD CONSTRAINT `fk_marine_marpol_operation_truck_visit_id` FOREIGN KEY (`truck_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_visit`(`truck_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_truck_appointment_id` FOREIGN KEY (`truck_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment`(`truck_appointment_id`);

-- ========= marine --> masterdata (22 constraint(s)) =========
-- Requires: marine schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ADD CONSTRAINT `fk_marine_pilot_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ADD CONSTRAINT `fk_marine_launch_dispatch_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`surveyor` ADD CONSTRAINT `fk_marine_surveyor_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ADD CONSTRAINT `fk_marine_marpol_operation_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ADD CONSTRAINT `fk_marine_marpol_operation_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_exemption` ADD CONSTRAINT `fk_marine_pilotage_exemption_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_vessel_type_endorsement` ADD CONSTRAINT `fk_marine_pilot_vessel_type_endorsement_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);

-- ========= marine --> procurement (1 constraint(s)) =========
-- Requires: marine schema, procurement schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= marine --> safety (3 constraint(s)) =========
-- Requires: marine schema, safety schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_permit_to_work_id` FOREIGN KEY (`permit_to_work_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`permit_to_work`(`permit_to_work_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_permit_to_work_id` FOREIGN KEY (`permit_to_work_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`permit_to_work`(`permit_to_work_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_permit_to_work_id` FOREIGN KEY (`permit_to_work_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`permit_to_work`(`permit_to_work_id`);

-- ========= marine --> security (7 constraint(s)) =========
-- Requires: marine schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ADD CONSTRAINT `fk_marine_pilot_duty_roster_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);

-- ========= marine --> tariff (4 constraint(s)) =========
-- Requires: marine schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_pilotage_tariff_id` FOREIGN KEY (`pilotage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff`(`pilotage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_mooring_tariff_id` FOREIGN KEY (`mooring_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff`(`mooring_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_pilotage_tariff_id` FOREIGN KEY (`pilotage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff`(`pilotage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_towage_tariff_id` FOREIGN KEY (`towage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`towage_tariff`(`towage_tariff_id`);

-- ========= marine --> vessel (18 constraint(s)) =========
-- Requires: marine schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_agent_appointment_id` FOREIGN KEY (`agent_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`agent_appointment`(`agent_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ADD CONSTRAINT `fk_marine_launch_dispatch_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ADD CONSTRAINT `fk_marine_marpol_operation_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ADD CONSTRAINT `fk_marine_marpol_operation_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_agent_appointment_id` FOREIGN KEY (`agent_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`agent_appointment`(`agent_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);

-- ========= marine --> workforce (17 constraint(s)) =========
-- Requires: marine schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ADD CONSTRAINT `fk_marine_pilot_labour_agreement_id` FOREIGN KEY (`labour_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`labour_agreement`(`labour_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ADD CONSTRAINT `fk_marine_pilot_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ADD CONSTRAINT `fk_marine_pilot_position_id` FOREIGN KEY (`position_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`position`(`position_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`launch_dispatch` ADD CONSTRAINT `fk_marine_launch_dispatch_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`survey_appointment` ADD CONSTRAINT `fk_marine_survey_appointment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_incident` ADD CONSTRAINT `fk_marine_marine_incident_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pni_club_notification` ADD CONSTRAINT `fk_marine_pni_club_notification_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marpol_operation` ADD CONSTRAINT `fk_marine_marpol_operation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`marine_service_order` ADD CONSTRAINT `fk_marine_marine_service_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot_duty_roster` ADD CONSTRAINT `fk_marine_pilot_duty_roster_shift_pattern_id` FOREIGN KEY (`shift_pattern_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`shift_pattern`(`shift_pattern_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`weather_tide_window` ADD CONSTRAINT `fk_marine_weather_tide_window_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= masterdata --> customer (1 constraint(s)) =========
-- Requires: masterdata schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`edi_partner` ADD CONSTRAINT `fk_masterdata_edi_partner_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= procurement --> asset (2 constraint(s)) =========
-- Requires: procurement schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ADD CONSTRAINT `fk_procurement_purchase_order_item_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_asset_location_id` FOREIGN KEY (`asset_location_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`asset_location`(`asset_location_id`);

-- ========= procurement --> booking (1 constraint(s)) =========
-- Requires: procurement schema, booking schema
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ADD CONSTRAINT `fk_procurement_service_entry_sheet_booking_service_order_id` FOREIGN KEY (`booking_service_order_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`booking_service_order`(`booking_service_order_id`);

-- ========= procurement --> compliance (1 constraint(s)) =========
-- Requires: procurement schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);

-- ========= procurement --> contract (1 constraint(s)) =========
-- Requires: procurement schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ADD CONSTRAINT `fk_procurement_tender_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= procurement --> customer (1 constraint(s)) =========
-- Requires: procurement schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ADD CONSTRAINT `fk_procurement_vendor_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= procurement --> masterdata (12 constraint(s)) =========
-- Requires: procurement schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ADD CONSTRAINT `fk_procurement_vendor_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor` ADD CONSTRAINT `fk_procurement_vendor_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ADD CONSTRAINT `fk_procurement_material_master_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_master` ADD CONSTRAINT `fk_procurement_material_master_packaging_type_id` FOREIGN KEY (`packaging_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`packaging_type`(`packaging_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`material_group` ADD CONSTRAINT `fk_procurement_material_group_cargo_category_id` FOREIGN KEY (`cargo_category_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`cargo_category`(`cargo_category_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ADD CONSTRAINT `fk_procurement_rfq_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ADD CONSTRAINT `fk_procurement_purchase_order_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order_item` ADD CONSTRAINT `fk_procurement_purchase_order_item_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`approved_vendor_list` ADD CONSTRAINT `fk_procurement_approved_vendor_list_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_service_rate_card` ADD CONSTRAINT `fk_procurement_vendor_service_rate_card_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ADD CONSTRAINT `fk_procurement_vendor_commodity_approval_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);

-- ========= procurement --> safety (1 constraint(s)) =========
-- Requires: procurement schema, safety schema
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ADD CONSTRAINT `fk_procurement_vendor_evaluation_kpi_id` FOREIGN KEY (`kpi_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`kpi`(`kpi_id`);

-- ========= procurement --> security (2 constraint(s)) =========
-- Requires: procurement schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_order` ADD CONSTRAINT `fk_procurement_purchase_order_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_access_point_id` FOREIGN KEY (`access_point_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_point`(`access_point_id`);

-- ========= procurement --> workforce (13 constraint(s)) =========
-- Requires: procurement schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_org_unit_id` FOREIGN KEY (`org_unit_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`org_unit`(`org_unit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`purchase_requisition` ADD CONSTRAINT `fk_procurement_purchase_requisition_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`rfq` ADD CONSTRAINT `fk_procurement_rfq_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_quotation` ADD CONSTRAINT `fk_procurement_vendor_quotation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`goods_receipt` ADD CONSTRAINT `fk_procurement_goods_receipt_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ADD CONSTRAINT `fk_procurement_service_entry_sheet_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ADD CONSTRAINT `fk_procurement_service_entry_sheet_service_employee_id` FOREIGN KEY (`service_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`service_entry_sheet` ADD CONSTRAINT `fk_procurement_service_entry_sheet_tertiary_service_created_by_user_employee_id` FOREIGN KEY (`tertiary_service_created_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_evaluation` ADD CONSTRAINT `fk_procurement_vendor_evaluation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ADD CONSTRAINT `fk_procurement_tender_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ADD CONSTRAINT `fk_procurement_tender_quaternary_tender_modified_by_user_employee_id` FOREIGN KEY (`quaternary_tender_modified_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`tender` ADD CONSTRAINT `fk_procurement_tender_tertiary_tender_manager_user_employee_id` FOREIGN KEY (`tertiary_tender_manager_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`procurement`.`vendor_commodity_approval` ADD CONSTRAINT `fk_procurement_vendor_commodity_approval_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= safety --> asset (3 constraint(s)) =========
-- Requires: safety schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_station` ADD CONSTRAINT `fk_safety_env_monitoring_station_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= safety --> booking (9 constraint(s)) =========
-- Requires: safety schema, booking schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_booking_berth_reservation_id` FOREIGN KEY (`booking_berth_reservation_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation`(`booking_berth_reservation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_booking_berth_reservation_id` FOREIGN KEY (`booking_berth_reservation_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`booking_berth_reservation`(`booking_berth_reservation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`safety_corrective_action` ADD CONSTRAINT `fk_safety_safety_corrective_action_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_reading` ADD CONSTRAINT `fk_safety_env_monitoring_reading_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`contractor_safety` ADD CONSTRAINT `fk_safety_contractor_safety_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);

-- ========= safety --> compliance (8 constraint(s)) =========
-- Requires: safety schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`safety_corrective_action` ADD CONSTRAINT `fk_safety_safety_corrective_action_compliance_audit_id` FOREIGN KEY (`compliance_audit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`compliance_audit`(`compliance_audit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`safety_corrective_action` ADD CONSTRAINT `fk_safety_safety_corrective_action_violation_id` FOREIGN KEY (`violation_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`violation`(`violation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_marpol_record_id` FOREIGN KEY (`marpol_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`marpol_record`(`marpol_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`iso_compliance_register` ADD CONSTRAINT `fk_safety_iso_compliance_register_compliance_audit_id` FOREIGN KEY (`compliance_audit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`compliance_audit`(`compliance_audit_id`);

-- ========= safety --> contract (6 constraint(s)) =========
-- Requires: safety schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`safety_corrective_action` ADD CONSTRAINT `fk_safety_safety_corrective_action_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`contractor_safety` ADD CONSTRAINT `fk_safety_contractor_safety_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= safety --> customer (7 constraint(s)) =========
-- Requires: safety schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`contractor_safety` ADD CONSTRAINT `fk_safety_contractor_safety_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`emergency_response_participant` ADD CONSTRAINT `fk_safety_emergency_response_participant_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`risk_assessment_participant` ADD CONSTRAINT `fk_safety_risk_assessment_participant_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= safety --> finance (11 constraint(s)) =========
-- Requires: safety schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`safety_corrective_action` ADD CONSTRAINT `fk_safety_safety_corrective_action_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`safety_corrective_action` ADD CONSTRAINT `fk_safety_safety_corrective_action_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_station` ADD CONSTRAINT `fk_safety_env_monitoring_station_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`sustainability_initiative` ADD CONSTRAINT `fk_safety_sustainability_initiative_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`sustainability_initiative` ADD CONSTRAINT `fk_safety_sustainability_initiative_wbs_element_id` FOREIGN KEY (`wbs_element_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`wbs_element`(`wbs_element_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);

-- ========= safety --> infrastructure (54 constraint(s)) =========
-- Requires: safety schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_navigational_aid_id` FOREIGN KEY (`navigational_aid_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid`(`navigational_aid_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`risk_assessment` ADD CONSTRAINT `fk_safety_risk_assessment_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`risk_assessment` ADD CONSTRAINT `fk_safety_risk_assessment_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`risk_assessment` ADD CONSTRAINT `fk_safety_risk_assessment_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`risk_assessment` ADD CONSTRAINT `fk_safety_risk_assessment_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`risk_assessment` ADD CONSTRAINT `fk_safety_risk_assessment_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`hazard_register` ADD CONSTRAINT `fk_safety_hazard_register_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`hazard_register` ADD CONSTRAINT `fk_safety_hazard_register_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`hazard_register` ADD CONSTRAINT `fk_safety_hazard_register_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`hazard_register` ADD CONSTRAINT `fk_safety_hazard_register_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_station` ADD CONSTRAINT `fk_safety_env_monitoring_station_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_station` ADD CONSTRAINT `fk_safety_env_monitoring_station_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_station` ADD CONSTRAINT `fk_safety_env_monitoring_station_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_station` ADD CONSTRAINT `fk_safety_env_monitoring_station_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_ghg_terminal_zone_id` FOREIGN KEY (`ghg_terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_waste_reception_facility_id` FOREIGN KEY (`waste_reception_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`waste_reception_facility`(`waste_reception_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`sustainability_initiative` ADD CONSTRAINT `fk_safety_sustainability_initiative_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`sustainability_initiative` ADD CONSTRAINT `fk_safety_sustainability_initiative_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`sustainability_initiative` ADD CONSTRAINT `fk_safety_sustainability_initiative_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`sustainability_initiative` ADD CONSTRAINT `fk_safety_sustainability_initiative_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`sustainability_initiative` ADD CONSTRAINT `fk_safety_sustainability_initiative_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_navigational_aid_id` FOREIGN KEY (`navigational_aid_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`navigational_aid`(`navigational_aid_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`kpi` ADD CONSTRAINT `fk_safety_kpi_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`kpi` ADD CONSTRAINT `fk_safety_kpi_infrastructure_terminal_id` FOREIGN KEY (`infrastructure_terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal`(`infrastructure_terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`kpi` ADD CONSTRAINT `fk_safety_kpi_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`kpi` ADD CONSTRAINT `fk_safety_kpi_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);

-- ========= safety --> marine (7 constraint(s)) =========
-- Requires: safety schema, marine schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_tug_id` FOREIGN KEY (`tug_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug`(`tug_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_reading` ADD CONSTRAINT `fk_safety_env_monitoring_reading_marine_incident_id` FOREIGN KEY (`marine_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_incident`(`marine_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_reading` ADD CONSTRAINT `fk_safety_env_monitoring_reading_marpol_operation_id` FOREIGN KEY (`marpol_operation_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marpol_operation`(`marpol_operation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_marine_incident_id` FOREIGN KEY (`marine_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_incident`(`marine_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_tug_id` FOREIGN KEY (`tug_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug`(`tug_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_marpol_operation_id` FOREIGN KEY (`marpol_operation_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marpol_operation`(`marpol_operation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`contractor_safety` ADD CONSTRAINT `fk_safety_contractor_safety_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);

-- ========= safety --> masterdata (12 constraint(s)) =========
-- Requires: safety schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`risk_assessment` ADD CONSTRAINT `fk_safety_risk_assessment_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`hazard_register` ADD CONSTRAINT `fk_safety_hazard_register_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_reading` ADD CONSTRAINT `fk_safety_env_monitoring_reading_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`sustainability_initiative` ADD CONSTRAINT `fk_safety_sustainability_initiative_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`contractor_safety` ADD CONSTRAINT `fk_safety_contractor_safety_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);

-- ========= safety --> procurement (15 constraint(s)) =========
-- Requires: safety schema, procurement schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`risk_assessment` ADD CONSTRAINT `fk_safety_risk_assessment_material_group_id` FOREIGN KEY (`material_group_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_group`(`material_group_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`safety_corrective_action` ADD CONSTRAINT `fk_safety_safety_corrective_action_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_station` ADD CONSTRAINT `fk_safety_env_monitoring_station_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`iso_compliance_register` ADD CONSTRAINT `fk_safety_iso_compliance_register_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`contractor_safety` ADD CONSTRAINT `fk_safety_contractor_safety_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`contractor_safety` ADD CONSTRAINT `fk_safety_contractor_safety_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`material_hazard_control` ADD CONSTRAINT `fk_safety_material_hazard_control_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_vendor_authorization` ADD CONSTRAINT `fk_safety_permit_vendor_authorization_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= safety --> security (8 constraint(s)) =========
-- Requires: safety schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`safety_corrective_action` ADD CONSTRAINT `fk_safety_safety_corrective_action_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`emergency_response_plan` ADD CONSTRAINT `fk_safety_emergency_response_plan_facility_security_plan_id` FOREIGN KEY (`facility_security_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`facility_security_plan`(`facility_security_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_station` ADD CONSTRAINT `fk_safety_env_monitoring_station_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`contractor_safety` ADD CONSTRAINT `fk_safety_contractor_safety_access_credential_id` FOREIGN KEY (`access_credential_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_credential`(`access_credential_id`);

-- ========= safety --> tariff (3 constraint(s)) =========
-- Requires: safety schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_surcharge_rule_id` FOREIGN KEY (`surcharge_rule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule`(`surcharge_rule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`sustainability_initiative` ADD CONSTRAINT `fk_safety_sustainability_initiative_discount_scheme_id` FOREIGN KEY (`discount_scheme_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`discount_scheme`(`discount_scheme_id`);

-- ========= safety --> terminal (1 constraint(s)) =========
-- Requires: safety schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_reading` ADD CONSTRAINT `fk_safety_env_monitoring_reading_terminal_equipment_id` FOREIGN KEY (`terminal_equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment`(`terminal_equipment_id`);

-- ========= safety --> vessel (4 constraint(s)) =========
-- Requires: safety schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_reading` ADD CONSTRAINT `fk_safety_env_monitoring_reading_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ghg_emission_record` ADD CONSTRAINT `fk_safety_ghg_emission_record_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);

-- ========= safety --> workforce (22 constraint(s)) =========
-- Requires: safety schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_incident` ADD CONSTRAINT `fk_safety_ohs_incident_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`ohs_investigation` ADD CONSTRAINT `fk_safety_ohs_investigation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_quaternary_inspection_last_modified_by_employee_id` FOREIGN KEY (`quaternary_inspection_last_modified_by_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_quinary_inspection_responsible_manager_employee_id` FOREIGN KEY (`quinary_inspection_responsible_manager_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`inspection` ADD CONSTRAINT `fk_safety_inspection_tertiary_inspection_employee_id` FOREIGN KEY (`tertiary_inspection_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`hazard_register` ADD CONSTRAINT `fk_safety_hazard_register_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`safety_corrective_action` ADD CONSTRAINT `fk_safety_safety_corrective_action_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`safety_corrective_action` ADD CONSTRAINT `fk_safety_safety_corrective_action_tertiary_quinary_safety_last_modified_by_employee_id` FOREIGN KEY (`tertiary_quinary_safety_last_modified_by_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`safety_corrective_action` ADD CONSTRAINT `fk_safety_safety_corrective_action_tertiary_safety_closed_by_employee_id` FOREIGN KEY (`tertiary_safety_closed_by_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`env_monitoring_station` ADD CONSTRAINT `fk_safety_env_monitoring_station_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`marpol_waste_record` ADD CONSTRAINT `fk_safety_marpol_waste_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`sustainability_initiative` ADD CONSTRAINT `fk_safety_sustainability_initiative_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`iso_compliance_register` ADD CONSTRAINT `fk_safety_iso_compliance_register_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`permit_to_work` ADD CONSTRAINT `fk_safety_permit_to_work_tertiary_permit_closure_verified_by_employee_id` FOREIGN KEY (`tertiary_permit_closure_verified_by_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`kpi` ADD CONSTRAINT `fk_safety_kpi_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`kpi` ADD CONSTRAINT `fk_safety_kpi_tertiary_kpi_verified_by_employee_id` FOREIGN KEY (`tertiary_kpi_verified_by_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`contractor_safety` ADD CONSTRAINT `fk_safety_contractor_safety_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`material_hazard_control` ADD CONSTRAINT `fk_safety_material_hazard_control_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`material_hazard_control` ADD CONSTRAINT `fk_safety_material_hazard_control_material_last_modified_by_employee_id` FOREIGN KEY (`material_last_modified_by_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`safety`.`risk_assessment_participant` ADD CONSTRAINT `fk_safety_risk_assessment_participant_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= security --> compliance (3 constraint(s)) =========
-- Requires: security schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ADD CONSTRAINT `fk_security_facility_security_plan_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ADD CONSTRAINT `fk_security_access_credential_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ADD CONSTRAINT `fk_security_threat_assessment_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);

-- ========= security --> customer (1 constraint(s)) =========
-- Requires: security schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_credential` ADD CONSTRAINT `fk_security_access_credential_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= security --> infrastructure (7 constraint(s)) =========
-- Requires: security schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ADD CONSTRAINT `fk_security_access_point_facility_building_id` FOREIGN KEY (`facility_building_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility_building`(`facility_building_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ADD CONSTRAINT `fk_security_dos_record_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ADD CONSTRAINT `fk_security_post_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ADD CONSTRAINT `fk_security_post_facility_building_id` FOREIGN KEY (`facility_building_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility_building`(`facility_building_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ADD CONSTRAINT `fk_security_post_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ADD CONSTRAINT `fk_security_patrol_route_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility`(`facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ADD CONSTRAINT `fk_security_patrol_route_infrastructure_terminal_id` FOREIGN KEY (`infrastructure_terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_terminal`(`infrastructure_terminal_id`);

-- ========= security --> marine (1 constraint(s)) =========
-- Requires: security schema, marine schema
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ADD CONSTRAINT `fk_security_patrol_marine_incident_id` FOREIGN KEY (`marine_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_incident`(`marine_incident_id`);

-- ========= security --> masterdata (10 constraint(s)) =========
-- Requires: security schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ADD CONSTRAINT `fk_security_facility_security_plan_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ADD CONSTRAINT `fk_security_facility_security_plan_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ADD CONSTRAINT `fk_security_facility_security_plan_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ADD CONSTRAINT `fk_security_zone_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_point` ADD CONSTRAINT `fk_security_access_point_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ADD CONSTRAINT `fk_security_threat_assessment_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ADD CONSTRAINT `fk_security_dos_record_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ADD CONSTRAINT `fk_security_stowaway_case_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`watchlist_entry` ADD CONSTRAINT `fk_security_watchlist_entry_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_equipment` ADD CONSTRAINT `fk_security_security_equipment_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);

-- ========= security --> procurement (1 constraint(s)) =========
-- Requires: security schema, procurement schema
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ADD CONSTRAINT `fk_security_personnel_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= security --> safety (1 constraint(s)) =========
-- Requires: security schema, safety schema
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol_route` ADD CONSTRAINT `fk_security_patrol_route_risk_assessment_id` FOREIGN KEY (`risk_assessment_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`risk_assessment`(`risk_assessment_id`);

-- ========= security --> vessel (4 constraint(s)) =========
-- Requires: security schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`threat_assessment` ADD CONSTRAINT `fk_security_threat_assessment_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`dos_record` ADD CONSTRAINT `fk_security_dos_record_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ADD CONSTRAINT `fk_security_stowaway_case_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`mda_observation` ADD CONSTRAINT `fk_security_mda_observation_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);

-- ========= security --> workforce (17 constraint(s)) =========
-- Requires: security schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`facility_security_plan` ADD CONSTRAINT `fk_security_facility_security_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ADD CONSTRAINT `fk_security_zone_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`zone` ADD CONSTRAINT `fk_security_zone_tertiary_zone_manager_employee_id` FOREIGN KEY (`tertiary_zone_manager_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`access_event` ADD CONSTRAINT `fk_security_access_event_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cctv_incident_clip` ADD CONSTRAINT `fk_security_cctv_incident_clip_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`patrol` ADD CONSTRAINT `fk_security_patrol_shift_pattern_id` FOREIGN KEY (`shift_pattern_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`shift_pattern`(`shift_pattern_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_incident` ADD CONSTRAINT `fk_security_security_incident_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`investigation` ADD CONSTRAINT `fk_security_investigation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`drill` ADD CONSTRAINT `fk_security_drill_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`stowaway_case` ADD CONSTRAINT `fk_security_stowaway_case_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_incident` ADD CONSTRAINT `fk_security_cyber_incident_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`cyber_risk_register` ADD CONSTRAINT `fk_security_cyber_risk_register_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`personnel` ADD CONSTRAINT `fk_security_personnel_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ADD CONSTRAINT `fk_security_post_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`post` ADD CONSTRAINT `fk_security_post_post_supervisor_employee_id` FOREIGN KEY (`post_supervisor_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`visitor_log` ADD CONSTRAINT `fk_security_visitor_log_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`security`.`security_corrective_action` ADD CONSTRAINT `fk_security_security_corrective_action_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= tariff --> billing (1 constraint(s)) =========
-- Requires: tariff schema, billing schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_charge_event_id` FOREIGN KEY (`charge_event_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`charge_event`(`charge_event_id`);

-- ========= tariff --> cargo (1 constraint(s)) =========
-- Requires: tariff schema, cargo schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);

-- ========= tariff --> compliance (9 constraint(s)) =========
-- Requires: tariff schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ADD CONSTRAINT `fk_tariff_port_tariff_trade_restriction_id` FOREIGN KEY (`trade_restriction_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_restriction`(`trade_restriction_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ADD CONSTRAINT `fk_tariff_wharfage_schedule_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ADD CONSTRAINT `fk_tariff_storage_tariff_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_import_export_permit_id` FOREIGN KEY (`import_export_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`import_export_permit`(`import_export_permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ADD CONSTRAINT `fk_tariff_pricing_rule_trade_restriction_id` FOREIGN KEY (`trade_restriction_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_restriction`(`trade_restriction_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ADD CONSTRAINT `fk_tariff_tariff_filing_compliance_audit_id` FOREIGN KEY (`compliance_audit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`compliance_audit`(`compliance_audit_id`);

-- ========= tariff --> contract (6 constraint(s)) =========
-- Requires: tariff schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ADD CONSTRAINT `fk_tariff_pricing_rule_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ADD CONSTRAINT `fk_tariff_free_time_allowance_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ADD CONSTRAINT `fk_tariff_negotiation_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= tariff --> customer (6 constraint(s)) =========
-- Requires: tariff schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ADD CONSTRAINT `fk_tariff_pricing_rule_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ADD CONSTRAINT `fk_tariff_negotiation_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ADD CONSTRAINT `fk_tariff_negotiation_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= tariff --> finance (7 constraint(s)) =========
-- Requires: tariff schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_gl_account_id` FOREIGN KEY (`gl_account_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`gl_account`(`gl_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ADD CONSTRAINT `fk_tariff_pricing_rule_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ADD CONSTRAINT `fk_tariff_pricing_rule_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);

-- ========= tariff --> infrastructure (16 constraint(s)) =========
-- Requires: tariff schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ADD CONSTRAINT `fk_tariff_thc_schedule_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ADD CONSTRAINT `fk_tariff_wharfage_schedule_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ADD CONSTRAINT `fk_tariff_wharfage_schedule_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ADD CONSTRAINT `fk_tariff_pilotage_tariff_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ADD CONSTRAINT `fk_tariff_pilotage_tariff_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ADD CONSTRAINT `fk_tariff_storage_tariff_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ADD CONSTRAINT `fk_tariff_storage_tariff_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ADD CONSTRAINT `fk_tariff_demurrage_schedule_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_project_id` FOREIGN KEY (`project_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`project`(`project_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ADD CONSTRAINT `fk_tariff_pricing_rule_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ADD CONSTRAINT `fk_tariff_pricing_rule_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ADD CONSTRAINT `fk_tariff_towage_tariff_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ADD CONSTRAINT `fk_tariff_mooring_tariff_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);

-- ========= tariff --> masterdata (25 constraint(s)) =========
-- Requires: tariff schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ADD CONSTRAINT `fk_tariff_port_tariff_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ADD CONSTRAINT `fk_tariff_port_tariff_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ADD CONSTRAINT `fk_tariff_wharfage_schedule_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ADD CONSTRAINT `fk_tariff_pilotage_tariff_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pilotage_tariff` ADD CONSTRAINT `fk_tariff_pilotage_tariff_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ADD CONSTRAINT `fk_tariff_storage_tariff_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule` ADD CONSTRAINT `fk_tariff_demurrage_schedule_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`detention_schedule` ADD CONSTRAINT `fk_tariff_detention_schedule_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`free_time_allowance` ADD CONSTRAINT `fk_tariff_free_time_allowance_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`towage_tariff` ADD CONSTRAINT `fk_tariff_towage_tariff_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ADD CONSTRAINT `fk_tariff_mooring_tariff_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ADD CONSTRAINT `fk_tariff_currency_adjustment_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ADD CONSTRAINT `fk_tariff_bunker_adjustment_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ADD CONSTRAINT `fk_tariff_negotiation_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);

-- ========= tariff --> security (3 constraint(s)) =========
-- Requires: tariff schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ADD CONSTRAINT `fk_tariff_storage_tariff_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);

-- ========= tariff --> vessel (1 constraint(s)) =========
-- Requires: tariff schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);

-- ========= tariff --> workforce (22 constraint(s)) =========
-- Requires: tariff schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ADD CONSTRAINT `fk_tariff_discount_scheme_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`sla_rate_card` ADD CONSTRAINT `fk_tariff_sla_rate_card_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_quaternary_exception_revoked_by_user_employee_id` FOREIGN KEY (`quaternary_exception_revoked_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`exception` ADD CONSTRAINT `fk_tariff_exception_tertiary_exception_modified_by_user_employee_id` FOREIGN KEY (`tertiary_exception_modified_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`pricing_rule` ADD CONSTRAINT `fk_tariff_pricing_rule_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ADD CONSTRAINT `fk_tariff_mooring_tariff_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`mooring_tariff` ADD CONSTRAINT `fk_tariff_mooring_tariff_tertiary_mooring_modified_by_user_employee_id` FOREIGN KEY (`tertiary_mooring_modified_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`applicability` ADD CONSTRAINT `fk_tariff_applicability_tertiary_applicability_modified_by_user_employee_id` FOREIGN KEY (`tertiary_applicability_modified_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ADD CONSTRAINT `fk_tariff_currency_adjustment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`currency_adjustment` ADD CONSTRAINT `fk_tariff_currency_adjustment_tertiary_currency_modified_by_user_employee_id` FOREIGN KEY (`tertiary_currency_modified_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment` ADD CONSTRAINT `fk_tariff_bunker_adjustment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ADD CONSTRAINT `fk_tariff_negotiation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`negotiation` ADD CONSTRAINT `fk_tariff_negotiation_tertiary_negotiation_modified_by_user_employee_id` FOREIGN KEY (`tertiary_negotiation_modified_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ADD CONSTRAINT `fk_tariff_tariff_filing_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ADD CONSTRAINT `fk_tariff_tariff_filing_tariff_filing_employee_id` FOREIGN KEY (`tariff_filing_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ADD CONSTRAINT `fk_tariff_tariff_filing_tariff_filing_modified_by_user_employee_id` FOREIGN KEY (`tariff_filing_modified_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`tariff_filing` ADD CONSTRAINT `fk_tariff_tariff_filing_tariff_filing_withdrawn_by_user_employee_id` FOREIGN KEY (`tariff_filing_withdrawn_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= terminal --> asset (2 constraint(s)) =========
-- Requires: terminal schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ADD CONSTRAINT `fk_terminal_yard_block_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ADD CONSTRAINT `fk_terminal_terminal_equipment_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= terminal --> billing (9 constraint(s)) =========
-- Requires: terminal schema, billing schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ADD CONSTRAINT `fk_terminal_container_damage_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ADD CONSTRAINT `fk_terminal_roro_activity_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ADD CONSTRAINT `fk_terminal_container_tariff_exception_application_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`invoice`(`invoice_id`);

-- ========= terminal --> booking (6 constraint(s)) =========
-- Requires: terminal schema, booking schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_call_booking_id` FOREIGN KEY (`call_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`call_booking`(`call_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_booking_service_order_id` FOREIGN KEY (`booking_service_order_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`booking_service_order`(`booking_service_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_cargo_booking_id` FOREIGN KEY (`cargo_booking_id`) REFERENCES `vibe_shipping_ports_v1`.`booking`.`cargo_booking`(`cargo_booking_id`);

-- ========= terminal --> cargo (6 constraint(s)) =========
-- Requires: terminal schema, cargo schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ADD CONSTRAINT `fk_terminal_yard_slot_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ADD CONSTRAINT `fk_terminal_container_damage_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);

-- ========= terminal --> compliance (15 constraint(s)) =========
-- Requires: terminal schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ADD CONSTRAINT `fk_terminal_container_damage_trade_document_id` FOREIGN KEY (`trade_document_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_document`(`trade_document_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_trade_restriction_id` FOREIGN KEY (`trade_restriction_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_restriction`(`trade_restriction_id`);

-- ========= terminal --> contract (3 constraint(s)) =========
-- Requires: terminal schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= terminal --> customer (8 constraint(s)) =========
-- Requires: terminal schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ADD CONSTRAINT `fk_terminal_container_damage_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_tertiary_cfs_consignee_port_community_participant_id` FOREIGN KEY (`tertiary_cfs_consignee_port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ADD CONSTRAINT `fk_terminal_roro_activity_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ADD CONSTRAINT `fk_terminal_terminal_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= terminal --> finance (7 constraint(s)) =========
-- Requires: terminal schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ADD CONSTRAINT `fk_terminal_yard_block_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_internal_order_id` FOREIGN KEY (`internal_order_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`internal_order`(`internal_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ADD CONSTRAINT `fk_terminal_terminal_equipment_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ADD CONSTRAINT `fk_terminal_terminal_equipment_fixed_asset_id` FOREIGN KEY (`fixed_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`fixed_asset`(`fixed_asset_id`);

-- ========= terminal --> infrastructure (4 constraint(s)) =========
-- Requires: terminal schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ADD CONSTRAINT `fk_terminal_yard_block_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ADD CONSTRAINT `fk_terminal_terminal_equipment_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_lane` ADD CONSTRAINT `fk_terminal_gate_lane_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);

-- ========= terminal --> intermodal (6 constraint(s)) =========
-- Requires: terminal schema, intermodal schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ADD CONSTRAINT `fk_terminal_yard_slot_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_drayage_order_id` FOREIGN KEY (`drayage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`drayage_order`(`drayage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_truck_appointment_id` FOREIGN KEY (`truck_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment`(`truck_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_edi_message_id` FOREIGN KEY (`edi_message_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`edi_message`(`edi_message_id`);

-- ========= terminal --> marine (2 constraint(s)) =========
-- Requires: terminal schema, marine schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_pilotage_assignment_id` FOREIGN KEY (`pilotage_assignment_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment`(`pilotage_assignment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ADD CONSTRAINT `fk_terminal_container_damage_surveyor_id` FOREIGN KEY (`surveyor_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`surveyor`(`surveyor_id`);

-- ========= terminal --> masterdata (12 constraint(s)) =========
-- Requires: terminal schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ADD CONSTRAINT `fk_terminal_container_damage_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_packaging_type_id` FOREIGN KEY (`packaging_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`packaging_type`(`packaging_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_service_code_id` FOREIGN KEY (`service_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`service_code`(`service_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ADD CONSTRAINT `fk_terminal_terminal_equipment_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ADD CONSTRAINT `fk_terminal_terminal_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);

-- ========= terminal --> procurement (6 constraint(s)) =========
-- Requires: terminal schema, procurement schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ADD CONSTRAINT `fk_terminal_container_damage_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_purchase_order_id` FOREIGN KEY (`purchase_order_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`purchase_order`(`purchase_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ADD CONSTRAINT `fk_terminal_terminal_equipment_material_master_id` FOREIGN KEY (`material_master_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`material_master`(`material_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ADD CONSTRAINT `fk_terminal_terminal_equipment_supplier_contract_id` FOREIGN KEY (`supplier_contract_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`supplier_contract`(`supplier_contract_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ADD CONSTRAINT `fk_terminal_terminal_equipment_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= terminal --> safety (7 constraint(s)) =========
-- Requires: terminal schema, safety schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_inspection_id` FOREIGN KEY (`inspection_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`inspection`(`inspection_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ADD CONSTRAINT `fk_terminal_container_damage_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_permit_to_work_id` FOREIGN KEY (`permit_to_work_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`permit_to_work`(`permit_to_work_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ADD CONSTRAINT `fk_terminal_roro_activity_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_hazard_register_id` FOREIGN KEY (`hazard_register_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`hazard_register`(`hazard_register_id`);

-- ========= terminal --> security (11 constraint(s)) =========
-- Requires: terminal schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_screening_record_id` FOREIGN KEY (`screening_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`screening_record`(`screening_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_access_credential_id` FOREIGN KEY (`access_credential_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_credential`(`access_credential_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_access_credential_id` FOREIGN KEY (`access_credential_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_credential`(`access_credential_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_personnel_id` FOREIGN KEY (`personnel_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`personnel`(`personnel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_dos_record_id` FOREIGN KEY (`dos_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`dos_record`(`dos_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ADD CONSTRAINT `fk_terminal_container_damage_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_access_credential_id` FOREIGN KEY (`access_credential_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_credential`(`access_credential_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ADD CONSTRAINT `fk_terminal_terminal_equipment_zone_id` FOREIGN KEY (`zone_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`zone`(`zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ADD CONSTRAINT `fk_terminal_roro_activity_screening_record_id` FOREIGN KEY (`screening_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`screening_record`(`screening_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_threat_assessment_id` FOREIGN KEY (`threat_assessment_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`threat_assessment`(`threat_assessment_id`);

-- ========= terminal --> tariff (11 constraint(s)) =========
-- Requires: terminal schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_demurrage_schedule_id` FOREIGN KEY (`demurrage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`demurrage_schedule`(`demurrage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_storage_tariff_id` FOREIGN KEY (`storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_thc_schedule_id` FOREIGN KEY (`thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_port_dues_schedule_id` FOREIGN KEY (`port_dues_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule`(`port_dues_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_wharfage_schedule_id` FOREIGN KEY (`wharfage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule`(`wharfage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ADD CONSTRAINT `fk_terminal_roro_activity_wharfage_schedule_id` FOREIGN KEY (`wharfage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule`(`wharfage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_surcharge_rule_id` FOREIGN KEY (`surcharge_rule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule`(`surcharge_rule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ADD CONSTRAINT `fk_terminal_container_tariff_exception_application_exception_id` FOREIGN KEY (`exception_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`exception`(`exception_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ADD CONSTRAINT `fk_terminal_berth_discount_application_discount_scheme_id` FOREIGN KEY (`discount_scheme_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`discount_scheme`(`discount_scheme_id`);

-- ========= terminal --> vessel (6 constraint(s)) =========
-- Requires: terminal schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ADD CONSTRAINT `fk_terminal_roro_activity_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);

-- ========= terminal --> workforce (21 constraint(s)) =========
-- Requires: terminal schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_shift_pattern_id` FOREIGN KEY (`shift_pattern_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`shift_pattern`(`shift_pattern_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_terminal_employee_id` FOREIGN KEY (`terminal_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation` ADD CONSTRAINT `fk_terminal_terminal_berth_allocation_terminal_last_modified_by_user_employee_id` FOREIGN KEY (`terminal_last_modified_by_user_employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_damage` ADD CONSTRAINT `fk_terminal_container_damage_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`cfs_activity` ADD CONSTRAINT `fk_terminal_cfs_activity_shift_pattern_id` FOREIGN KEY (`shift_pattern_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`shift_pattern`(`shift_pattern_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_service_order` ADD CONSTRAINT `fk_terminal_terminal_service_order_shift_pattern_id` FOREIGN KEY (`shift_pattern_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`shift_pattern`(`shift_pattern_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal_equipment` ADD CONSTRAINT `fk_terminal_terminal_equipment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ADD CONSTRAINT `fk_terminal_roro_activity_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`roro_activity` ADD CONSTRAINT `fk_terminal_roro_activity_shift_pattern_id` FOREIGN KEY (`shift_pattern_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`shift_pattern`(`shift_pattern_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`hazmat_declaration` ADD CONSTRAINT `fk_terminal_hazmat_declaration_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_tariff_exception_application` ADD CONSTRAINT `fk_terminal_container_tariff_exception_application_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_discount_application` ADD CONSTRAINT `fk_terminal_berth_discount_application_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= vessel --> asset (3 constraint(s)) =========
-- Requires: vessel schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ADD CONSTRAINT `fk_vessel_waste_declaration_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ADD CONSTRAINT `fk_vessel_bunker_operation_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= vessel --> billing (1 constraint(s)) =========
-- Requires: vessel schema, billing schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ADD CONSTRAINT `fk_vessel_owner_receivable_account_id` FOREIGN KEY (`receivable_account_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`receivable_account`(`receivable_account_id`);

-- ========= vessel --> compliance (6 constraint(s)) =========
-- Requires: vessel schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ADD CONSTRAINT `fk_vessel_call_document_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_compliance_audit_id` FOREIGN KEY (`compliance_audit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`compliance_audit`(`compliance_audit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ADD CONSTRAINT `fk_vessel_psc_inspection_violation_id` FOREIGN KEY (`violation_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`violation`(`violation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ADD CONSTRAINT `fk_vessel_waste_declaration_marpol_record_id` FOREIGN KEY (`marpol_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`marpol_record`(`marpol_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ADD CONSTRAINT `fk_vessel_isps_record_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);

-- ========= vessel --> contract (6 constraint(s)) =========
-- Requires: vessel schema, contract schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ADD CONSTRAINT `fk_vessel_voyage_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ADD CONSTRAINT `fk_vessel_service_route_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ADD CONSTRAINT `fk_vessel_bunker_operation_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ADD CONSTRAINT `fk_vessel_service_agreement_agreement_id` FOREIGN KEY (`agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`contract`.`agreement`(`agreement_id`);

-- ========= vessel --> customer (6 constraint(s)) =========
-- Requires: vessel schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ADD CONSTRAINT `fk_vessel_owner_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_contact_person_id` FOREIGN KEY (`contact_person_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`contact_person`(`contact_person_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ADD CONSTRAINT `fk_vessel_waste_declaration_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agency_appointment` ADD CONSTRAINT `fk_vessel_agency_appointment_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ADD CONSTRAINT `fk_vessel_charter_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= vessel --> finance (9 constraint(s)) =========
-- Requires: vessel schema, finance schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_profit_centre_id` FOREIGN KEY (`profit_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`profit_centre`(`profit_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ADD CONSTRAINT `fk_vessel_anchorage_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ADD CONSTRAINT `fk_vessel_psc_inspection_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ADD CONSTRAINT `fk_vessel_draft_survey_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ADD CONSTRAINT `fk_vessel_waste_declaration_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ADD CONSTRAINT `fk_vessel_bunker_operation_cost_centre_id` FOREIGN KEY (`cost_centre_id`) REFERENCES `vibe_shipping_ports_v1`.`finance`.`cost_centre`(`cost_centre_id`);

-- ========= vessel --> infrastructure (9 constraint(s)) =========
-- Requires: vessel schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ADD CONSTRAINT `fk_vessel_anchorage_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ADD CONSTRAINT `fk_vessel_anchorage_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ADD CONSTRAINT `fk_vessel_service_route_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ADD CONSTRAINT `fk_vessel_bunker_operation_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ADD CONSTRAINT `fk_vessel_port_call_infrastructure_berth_allocation_id` FOREIGN KEY (`infrastructure_berth_allocation_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`infrastructure_berth_allocation`(`infrastructure_berth_allocation_id`);

-- ========= vessel --> intermodal (1 constraint(s)) =========
-- Requires: vessel schema, intermodal schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_icd_allocation` ADD CONSTRAINT `fk_vessel_call_icd_allocation_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);

-- ========= vessel --> marine (4 constraint(s)) =========
-- Requires: vessel schema, marine schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ADD CONSTRAINT `fk_vessel_vts_log_marine_incident_id` FOREIGN KEY (`marine_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_incident`(`marine_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ADD CONSTRAINT `fk_vessel_vts_log_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_marine_incident_id` FOREIGN KEY (`marine_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`marine_incident`(`marine_incident_id`);

-- ========= vessel --> masterdata (15 constraint(s)) =========
-- Requires: vessel schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ADD CONSTRAINT `fk_vessel_vessel_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ADD CONSTRAINT `fk_vessel_vessel_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ADD CONSTRAINT `fk_vessel_vessel_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ADD CONSTRAINT `fk_vessel_owner_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ADD CONSTRAINT `fk_vessel_voyage_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ADD CONSTRAINT `fk_vessel_call_document_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ADD CONSTRAINT `fk_vessel_psc_inspection_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ADD CONSTRAINT `fk_vessel_call_schedule_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ADD CONSTRAINT `fk_vessel_call_schedule_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_route` ADD CONSTRAINT `fk_vessel_service_route_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ADD CONSTRAINT `fk_vessel_crew_list_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ADD CONSTRAINT `fk_vessel_waste_declaration_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`charter` ADD CONSTRAINT `fk_vessel_charter_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ADD CONSTRAINT `fk_vessel_port_call_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);

-- ========= vessel --> procurement (4 constraint(s)) =========
-- Requires: vessel schema, procurement schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ADD CONSTRAINT `fk_vessel_waste_declaration_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ADD CONSTRAINT `fk_vessel_bunker_operation_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`service_agreement` ADD CONSTRAINT `fk_vessel_service_agreement_vendor_id` FOREIGN KEY (`vendor_id`) REFERENCES `vibe_shipping_ports_v1`.`procurement`.`vendor`(`vendor_id`);

-- ========= vessel --> safety (10 constraint(s)) =========
-- Requires: vessel schema, safety schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ADD CONSTRAINT `fk_vessel_anchorage_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_contractor_safety_id` FOREIGN KEY (`contractor_safety_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`contractor_safety`(`contractor_safety_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ADD CONSTRAINT `fk_vessel_draft_survey_permit_to_work_id` FOREIGN KEY (`permit_to_work_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`permit_to_work`(`permit_to_work_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ADD CONSTRAINT `fk_vessel_crew_list_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ADD CONSTRAINT `fk_vessel_isps_record_inspection_id` FOREIGN KEY (`inspection_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`inspection`(`inspection_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ADD CONSTRAINT `fk_vessel_bunker_operation_ohs_incident_id` FOREIGN KEY (`ohs_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`ohs_incident`(`ohs_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ADD CONSTRAINT `fk_vessel_bunker_operation_permit_to_work_id` FOREIGN KEY (`permit_to_work_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`permit_to_work`(`permit_to_work_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ADD CONSTRAINT `fk_vessel_call_inspection_call_safety_inspection_id` FOREIGN KEY (`call_safety_inspection_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`inspection`(`inspection_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_inspection` ADD CONSTRAINT `fk_vessel_call_inspection_inspection_id` FOREIGN KEY (`inspection_id`) REFERENCES `vibe_shipping_ports_v1`.`safety`.`inspection`(`inspection_id`);

-- ========= vessel --> security (6 constraint(s)) =========
-- Requires: vessel schema, security schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_security_audit_id` FOREIGN KEY (`security_audit_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_audit`(`security_audit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ADD CONSTRAINT `fk_vessel_psc_inspection_security_incident_id` FOREIGN KEY (`security_incident_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`security_incident`(`security_incident_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ADD CONSTRAINT `fk_vessel_crew_list_access_credential_id` FOREIGN KEY (`access_credential_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`access_credential`(`access_credential_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`crew_list` ADD CONSTRAINT `fk_vessel_crew_list_visitor_log_id` FOREIGN KEY (`visitor_log_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`visitor_log`(`visitor_log_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ADD CONSTRAINT `fk_vessel_waste_declaration_screening_record_id` FOREIGN KEY (`screening_record_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`screening_record`(`screening_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ADD CONSTRAINT `fk_vessel_isps_record_facility_security_plan_id` FOREIGN KEY (`facility_security_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`security`.`facility_security_plan`(`facility_security_plan_id`);

-- ========= vessel --> tariff (6 constraint(s)) =========
-- Requires: vessel schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ADD CONSTRAINT `fk_vessel_voyage_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ADD CONSTRAINT `fk_vessel_anchorage_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ADD CONSTRAINT `fk_vessel_draft_survey_wharfage_schedule_id` FOREIGN KEY (`wharfage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule`(`wharfage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ADD CONSTRAINT `fk_vessel_bunker_operation_bunker_adjustment_id` FOREIGN KEY (`bunker_adjustment_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`bunker_adjustment`(`bunker_adjustment_id`);

-- ========= vessel --> terminal (2 constraint(s)) =========
-- Requires: vessel schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ADD CONSTRAINT `fk_vessel_anchorage_terminal_berth_allocation_id` FOREIGN KEY (`terminal_berth_allocation_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation`(`terminal_berth_allocation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ADD CONSTRAINT `fk_vessel_vts_log_terminal_berth_allocation_id` FOREIGN KEY (`terminal_berth_allocation_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal_berth_allocation`(`terminal_berth_allocation_id`);

-- ========= vessel --> workforce (14 constraint(s)) =========
-- Requires: vessel schema, workforce schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ADD CONSTRAINT `fk_vessel_voyage_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`anchorage` ADD CONSTRAINT `fk_vessel_anchorage_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vts_log` ADD CONSTRAINT `fk_vessel_vts_log_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_document` ADD CONSTRAINT `fk_vessel_call_document_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ADD CONSTRAINT `fk_vessel_psc_inspection_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`draft_survey` ADD CONSTRAINT `fk_vessel_draft_survey_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`waste_declaration` ADD CONSTRAINT `fk_vessel_waste_declaration_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`isps_record` ADD CONSTRAINT `fk_vessel_isps_record_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`bunker_operation` ADD CONSTRAINT `fk_vessel_bunker_operation_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`deployment` ADD CONSTRAINT `fk_vessel_deployment_gang_id` FOREIGN KEY (`gang_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`gang`(`gang_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_assignment` ADD CONSTRAINT `fk_vessel_call_assignment_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `vibe_shipping_ports_v1`.`workforce`.`employee`(`employee_id`);

-- ========= workforce --> asset (3 constraint(s)) =========
-- Requires: workforce schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ADD CONSTRAINT `fk_workforce_gang_assignment_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ADD CONSTRAINT `fk_workforce_gang_assignment_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`calibration_session` ADD CONSTRAINT `fk_workforce_calibration_session_asset_location_id` FOREIGN KEY (`asset_location_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`asset_location`(`asset_location_id`);

-- ========= workforce --> infrastructure (7 constraint(s)) =========
-- Requires: workforce schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ADD CONSTRAINT `fk_workforce_gang_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ADD CONSTRAINT `fk_workforce_gang_assignment_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ADD CONSTRAINT `fk_workforce_roster_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ADD CONSTRAINT `fk_workforce_time_attendance_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ADD CONSTRAINT `fk_workforce_time_attendance_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee_certification` ADD CONSTRAINT `fk_workforce_employee_certification_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ADD CONSTRAINT `fk_workforce_training_course_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);

-- ========= workforce --> intermodal (1 constraint(s)) =========
-- Requires: workforce schema, intermodal schema
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ADD CONSTRAINT `fk_workforce_gang_assignment_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);

-- ========= workforce --> marine (1 constraint(s)) =========
-- Requires: workforce schema, marine schema
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ADD CONSTRAINT `fk_workforce_pilot_licence_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);

-- ========= workforce --> masterdata (21 constraint(s)) =========
-- Requires: workforce schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`employee` ADD CONSTRAINT `fk_workforce_employee_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`position` ADD CONSTRAINT `fk_workforce_position_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`org_unit` ADD CONSTRAINT `fk_workforce_org_unit_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ADD CONSTRAINT `fk_workforce_gang_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ADD CONSTRAINT `fk_workforce_gang_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang` ADD CONSTRAINT `fk_workforce_gang_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ADD CONSTRAINT `fk_workforce_gang_assignment_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`shift_pattern` ADD CONSTRAINT `fk_workforce_shift_pattern_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ADD CONSTRAINT `fk_workforce_roster_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ADD CONSTRAINT `fk_workforce_time_attendance_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ADD CONSTRAINT `fk_workforce_competency_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ADD CONSTRAINT `fk_workforce_competency_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`competency` ADD CONSTRAINT `fk_workforce_competency_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ADD CONSTRAINT `fk_workforce_training_course_equipment_type_id` FOREIGN KEY (`equipment_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`equipment_type`(`equipment_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ADD CONSTRAINT `fk_workforce_training_course_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ADD CONSTRAINT `fk_workforce_training_course_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`training_course` ADD CONSTRAINT `fk_workforce_training_course_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`labour_agreement` ADD CONSTRAINT `fk_workforce_labour_agreement_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`headcount_plan` ADD CONSTRAINT `fk_workforce_headcount_plan_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ADD CONSTRAINT `fk_workforce_pilot_licence_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`pilot_licence` ADD CONSTRAINT `fk_workforce_pilot_licence_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);

-- ========= workforce --> vessel (4 constraint(s)) =========
-- Requires: workforce schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`gang_assignment` ADD CONSTRAINT `fk_workforce_gang_assignment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`roster` ADD CONSTRAINT `fk_workforce_roster_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`time_attendance` ADD CONSTRAINT `fk_workforce_time_attendance_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`workforce`.`mlc_compliance_record` ADD CONSTRAINT `fk_workforce_mlc_compliance_record_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);

