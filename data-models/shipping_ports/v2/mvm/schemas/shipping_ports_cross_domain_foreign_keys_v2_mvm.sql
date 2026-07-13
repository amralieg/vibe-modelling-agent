-- Cross-Domain Foreign Keys for Business: Shipping_Ports | Version: v2_mvm
-- Generated on: 2026-07-13 10:24:20
-- Total cross-domain FK constraints: 883
--
-- EXECUTION ORDER:
--   1. Run ALL domain schema files first (any order).
--   2. Run this file LAST.
--
-- PREREQUISITE DOMAINS: asset, billing, cargo, compliance, customer, infrastructure, intermodal, marine, masterdata, tariff, terminal, vessel

-- ========= asset --> compliance (6 constraint(s)) =========
-- Requires: asset schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_marpol_record_id` FOREIGN KEY (`marpol_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`marpol_record`(`marpol_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_marpol_record_id` FOREIGN KEY (`marpol_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`marpol_record`(`marpol_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ADD CONSTRAINT `fk_asset_spare_part_import_export_permit_id` FOREIGN KEY (`import_export_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`import_export_permit`(`import_export_permit_id`);

-- ========= asset --> customer (12 constraint(s)) =========
-- Requires: asset schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order_task` ADD CONSTRAINT `fk_asset_work_order_task_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ADD CONSTRAINT `fk_asset_spare_part_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= asset --> infrastructure (17 constraint(s)) =========
-- Requires: asset schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility`(`facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ADD CONSTRAINT `fk_asset_spare_part_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);

-- ========= asset --> intermodal (4 constraint(s)) =========
-- Requires: asset schema, intermodal schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_rail_wagon_id` FOREIGN KEY (`rail_wagon_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon`(`rail_wagon_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_rail_wagon_id` FOREIGN KEY (`rail_wagon_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon`(`rail_wagon_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_rail_wagon_id` FOREIGN KEY (`rail_wagon_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon`(`rail_wagon_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_rail_wagon_id` FOREIGN KEY (`rail_wagon_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon`(`rail_wagon_id`);

-- ========= asset --> marine (3 constraint(s)) =========
-- Requires: asset schema, marine schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_tug_id` FOREIGN KEY (`tug_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug`(`tug_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_tug_id` FOREIGN KEY (`tug_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug`(`tug_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_tug_id` FOREIGN KEY (`tug_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`tug`(`tug_id`);

-- ========= asset --> masterdata (8 constraint(s)) =========
-- Requires: asset schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`port_asset` ADD CONSTRAINT `fk_asset_port_asset_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`equipment_class` ADD CONSTRAINT `fk_asset_equipment_class_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`maintenance_plan` ADD CONSTRAINT `fk_asset_maintenance_plan_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`spare_part` ADD CONSTRAINT `fk_asset_spare_part_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);

-- ========= asset --> tariff (2 constraint(s)) =========
-- Requires: asset schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);

-- ========= asset --> terminal (3 constraint(s)) =========
-- Requires: asset schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`work_order` ADD CONSTRAINT `fk_asset_work_order_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`equipment`(`equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`equipment`(`equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`inspection_record` ADD CONSTRAINT `fk_asset_inspection_record_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`equipment`(`equipment_id`);

-- ========= asset --> vessel (2 constraint(s)) =========
-- Requires: asset schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`asset`.`failure_report` ADD CONSTRAINT `fk_asset_failure_report_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);

-- ========= billing --> asset (7 constraint(s)) =========
-- Requires: billing schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_spare_part_id` FOREIGN KEY (`spare_part_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`spare_part`(`spare_part_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_failure_report_id` FOREIGN KEY (`failure_report_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`failure_report`(`failure_report_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_inspection_record_id` FOREIGN KEY (`inspection_record_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`inspection_record`(`inspection_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);

-- ========= billing --> cargo (8 constraint(s)) =========
-- Requires: billing schema, cargo schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_handling_order_id` FOREIGN KEY (`handling_order_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`handling_order`(`handling_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_demurrage_detention_id` FOREIGN KEY (`demurrage_detention_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention`(`demurrage_detention_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_demurrage_detention_id` FOREIGN KEY (`demurrage_detention_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention`(`demurrage_detention_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_manifest_id` FOREIGN KEY (`manifest_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`manifest`(`manifest_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);

-- ========= billing --> compliance (20 constraint(s)) =========
-- Requires: billing schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_import_export_permit_id` FOREIGN KEY (`import_export_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`import_export_permit`(`import_export_permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_marpol_record_id` FOREIGN KEY (`marpol_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`marpol_record`(`marpol_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_import_export_permit_id` FOREIGN KEY (`import_export_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`import_export_permit`(`import_export_permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_marpol_record_id` FOREIGN KEY (`marpol_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`marpol_record`(`marpol_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_import_export_permit_id` FOREIGN KEY (`import_export_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`import_export_permit`(`import_export_permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_marpol_record_id` FOREIGN KEY (`marpol_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`marpol_record`(`marpol_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_trade_document_id` FOREIGN KEY (`trade_document_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_document`(`trade_document_id`);

-- ========= billing --> customer (22 constraint(s)) =========
-- Requires: billing schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_contact_person_id` FOREIGN KEY (`contact_person_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`contact_person`(`contact_person_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_service_request_id` FOREIGN KEY (`service_request_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`service_request`(`service_request_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_credit_assessment_id` FOREIGN KEY (`credit_assessment_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`credit_assessment`(`credit_assessment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= billing --> infrastructure (27 constraint(s)) =========
-- Requires: billing schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility`(`facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility`(`facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility`(`facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility`(`facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility`(`facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility`(`facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);

-- ========= billing --> intermodal (30 constraint(s)) =========
-- Requires: billing schema, intermodal schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_service_id` FOREIGN KEY (`service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`service`(`service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_drayage_order_id` FOREIGN KEY (`drayage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`drayage_order`(`drayage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_service_id` FOREIGN KEY (`service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`service`(`service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_truck_visit_id` FOREIGN KEY (`truck_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_visit`(`truck_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_drayage_order_id` FOREIGN KEY (`drayage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`drayage_order`(`drayage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_truck_appointment_id` FOREIGN KEY (`truck_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment`(`truck_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_truck_visit_id` FOREIGN KEY (`truck_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_visit`(`truck_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_drayage_order_id` FOREIGN KEY (`drayage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`drayage_order`(`drayage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_truck_appointment_id` FOREIGN KEY (`truck_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment`(`truck_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_truck_visit_id` FOREIGN KEY (`truck_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_visit`(`truck_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_drayage_order_id` FOREIGN KEY (`drayage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`drayage_order`(`drayage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_truck_appointment_id` FOREIGN KEY (`truck_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment`(`truck_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_truck_visit_id` FOREIGN KEY (`truck_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_visit`(`truck_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_haulier_id` FOREIGN KEY (`haulier_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`haulier`(`haulier_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_rail_operator_id` FOREIGN KEY (`rail_operator_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_operator`(`rail_operator_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_service_id` FOREIGN KEY (`service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`service`(`service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_truck_appointment_id` FOREIGN KEY (`truck_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment`(`truck_appointment_id`);

-- ========= billing --> marine (1 constraint(s)) =========
-- Requires: billing schema, marine schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);

-- ========= billing --> masterdata (19 constraint(s)) =========
-- Requires: billing schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`payment` ADD CONSTRAINT `fk_billing_payment_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`receivable_account` ADD CONSTRAINT `fk_billing_receivable_account_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);

-- ========= billing --> tariff (30 constraint(s)) =========
-- Requires: billing schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_discount_scheme_id` FOREIGN KEY (`discount_scheme_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`discount_scheme`(`discount_scheme_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_port_dues_schedule_id` FOREIGN KEY (`port_dues_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule`(`port_dues_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_rate_card_line_id` FOREIGN KEY (`rate_card_line_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card_line`(`rate_card_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_storage_tariff_id` FOREIGN KEY (`storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_surcharge_rule_id` FOREIGN KEY (`surcharge_rule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule`(`surcharge_rule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_thc_schedule_id` FOREIGN KEY (`thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_wharfage_schedule_id` FOREIGN KEY (`wharfage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule`(`wharfage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_discount_scheme_id` FOREIGN KEY (`discount_scheme_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`discount_scheme`(`discount_scheme_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_discount_scheme_id` FOREIGN KEY (`discount_scheme_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`discount_scheme`(`discount_scheme_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_storage_tariff_id` FOREIGN KEY (`storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_port_dues_schedule_id` FOREIGN KEY (`port_dues_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule`(`port_dues_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_rate_card_line_id` FOREIGN KEY (`rate_card_line_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card_line`(`rate_card_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_storage_tariff_id` FOREIGN KEY (`storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_surcharge_rule_id` FOREIGN KEY (`surcharge_rule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule`(`surcharge_rule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_thc_schedule_id` FOREIGN KEY (`thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_wharfage_schedule_id` FOREIGN KEY (`wharfage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule`(`wharfage_schedule_id`);

-- ========= billing --> terminal (2 constraint(s)) =========
-- Requires: billing schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`equipment`(`equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`equipment`(`equipment_id`);

-- ========= billing --> vessel (12 constraint(s)) =========
-- Requires: billing schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_agent_appointment_id` FOREIGN KEY (`agent_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`agent_appointment`(`agent_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_port_call_id` FOREIGN KEY (`port_call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`port_call`(`port_call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_psc_inspection_id` FOREIGN KEY (`psc_inspection_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`psc_inspection`(`psc_inspection_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice` ADD CONSTRAINT `fk_billing_invoice_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`invoice_line` ADD CONSTRAINT `fk_billing_invoice_line_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`adjustment` ADD CONSTRAINT `fk_billing_adjustment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`debit_note` ADD CONSTRAINT `fk_billing_debit_note_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`dispute` ADD CONSTRAINT `fk_billing_dispute_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_movement_id` FOREIGN KEY (`movement_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`movement`(`movement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`billing`.`charge_event` ADD CONSTRAINT `fk_billing_charge_event_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);

-- ========= cargo --> asset (6 constraint(s)) =========
-- Requires: cargo schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_equipment_class_id` FOREIGN KEY (`equipment_class_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`equipment_class`(`equipment_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= cargo --> billing (1 constraint(s)) =========
-- Requires: cargo schema, billing schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_charge_event_id` FOREIGN KEY (`charge_event_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`charge_event`(`charge_event_id`);

-- ========= cargo --> compliance (12 constraint(s)) =========
-- Requires: cargo schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ADD CONSTRAINT `fk_cargo_manifest_line_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_customs_declaration_id` FOREIGN KEY (`customs_declaration_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_declaration`(`customs_declaration_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_import_export_permit_id` FOREIGN KEY (`import_export_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`import_export_permit`(`import_export_permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);

-- ========= cargo --> customer (14 constraint(s)) =========
-- Requires: cargo schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_tertiary_shipment_port_community_participant_id` FOREIGN KEY (`tertiary_shipment_port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ADD CONSTRAINT `fk_cargo_manifest_line_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_contact_person_id` FOREIGN KEY (`contact_person_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`contact_person`(`contact_person_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= cargo --> infrastructure (23 constraint(s)) =========
-- Requires: cargo schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);

-- ========= cargo --> marine (3 constraint(s)) =========
-- Requires: cargo schema, marine schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_mooring_operation_id` FOREIGN KEY (`mooring_operation_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`mooring_operation`(`mooring_operation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_pilotage_assignment_id` FOREIGN KEY (`pilotage_assignment_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment`(`pilotage_assignment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_towage_order_id` FOREIGN KEY (`towage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`towage_order`(`towage_order_id`);

-- ========= cargo --> masterdata (39 constraint(s)) =========
-- Requires: cargo schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ADD CONSTRAINT `fk_cargo_manifest_line_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ADD CONSTRAINT `fk_cargo_manifest_line_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);

-- ========= cargo --> tariff (9 constraint(s)) =========
-- Requires: cargo schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_storage_tariff_id` FOREIGN KEY (`storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_wharfage_schedule_id` FOREIGN KEY (`wharfage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule`(`wharfage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest_line` ADD CONSTRAINT `fk_cargo_manifest_line_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_thc_schedule_id` FOREIGN KEY (`thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_item_id` FOREIGN KEY (`item_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`item`(`item_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);

-- ========= cargo --> terminal (3 constraint(s)) =========
-- Requires: cargo schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_berth_allocation_id` FOREIGN KEY (`berth_allocation_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`berth_allocation`(`berth_allocation_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_equipment_id` FOREIGN KEY (`equipment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`equipment`(`equipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_gate_transaction_id` FOREIGN KEY (`gate_transaction_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`gate_transaction`(`gate_transaction_id`);

-- ========= cargo --> vessel (20 constraint(s)) =========
-- Requires: cargo schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`shipment` ADD CONSTRAINT `fk_cargo_shipment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`container` ADD CONSTRAINT `fk_cargo_container_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`bill_of_lading` ADD CONSTRAINT `fk_cargo_bill_of_lading_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_agent_appointment_id` FOREIGN KEY (`agent_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`agent_appointment`(`agent_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`manifest` ADD CONSTRAINT `fk_cargo_manifest_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`handling_order` ADD CONSTRAINT `fk_cargo_handling_order_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`move` ADD CONSTRAINT `fk_cargo_move_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`stowage_plan` ADD CONSTRAINT `fk_cargo_stowage_plan_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`dangerous_goods_declaration` ADD CONSTRAINT `fk_cargo_dangerous_goods_declaration_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`delivery_order` ADD CONSTRAINT `fk_cargo_delivery_order_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`demurrage_detention` ADD CONSTRAINT `fk_cargo_demurrage_detention_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_vessel_id` FOREIGN KEY (`vessel_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`vessel`(`vessel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`cargo`.`verified_gross_mass` ADD CONSTRAINT `fk_cargo_verified_gross_mass_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);

-- ========= compliance --> asset (2 constraint(s)) =========
-- Requires: compliance schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`marpol_record` ADD CONSTRAINT `fk_compliance_marpol_record_equipment_class_id` FOREIGN KEY (`equipment_class_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`equipment_class`(`equipment_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`marpol_record` ADD CONSTRAINT `fk_compliance_marpol_record_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= compliance --> cargo (3 constraint(s)) =========
-- Requires: compliance schema, cargo schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_manifest_id` FOREIGN KEY (`manifest_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`manifest`(`manifest_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);

-- ========= compliance --> customer (9 constraint(s)) =========
-- Requires: compliance schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record` ADD CONSTRAINT `fk_compliance_isps_facility_record_contact_person_id` FOREIGN KEY (`contact_person_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`contact_person`(`contact_person_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`import_export_permit` ADD CONSTRAINT `fk_compliance_import_export_permit_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_hold` ADD CONSTRAINT `fk_compliance_customs_hold_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`marpol_record` ADD CONSTRAINT `fk_compliance_marpol_record_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_broker` ADD CONSTRAINT `fk_compliance_customs_broker_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= compliance --> infrastructure (8 constraint(s)) =========
-- Requires: compliance schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record` ADD CONSTRAINT `fk_compliance_isps_facility_record_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`import_export_permit` ADD CONSTRAINT `fk_compliance_import_export_permit_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_hold` ADD CONSTRAINT `fk_compliance_customs_hold_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_hold` ADD CONSTRAINT `fk_compliance_customs_hold_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_hold` ADD CONSTRAINT `fk_compliance_customs_hold_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`marpol_record` ADD CONSTRAINT `fk_compliance_marpol_record_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`marpol_record` ADD CONSTRAINT `fk_compliance_marpol_record_facility_id` FOREIGN KEY (`facility_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`facility`(`facility_id`);

-- ========= compliance --> masterdata (26 constraint(s)) =========
-- Requires: compliance schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`hs_code` ADD CONSTRAINT `fk_compliance_hs_code_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening` ADD CONSTRAINT `fk_compliance_sanctions_screening_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record` ADD CONSTRAINT `fk_compliance_isps_facility_record_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record` ADD CONSTRAINT `fk_compliance_isps_facility_record_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record` ADD CONSTRAINT `fk_compliance_isps_facility_record_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`import_export_permit` ADD CONSTRAINT `fk_compliance_import_export_permit_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`import_export_permit` ADD CONSTRAINT `fk_compliance_import_export_permit_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`import_export_permit` ADD CONSTRAINT `fk_compliance_import_export_permit_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_hold` ADD CONSTRAINT `fk_compliance_customs_hold_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`marpol_record` ADD CONSTRAINT `fk_compliance_marpol_record_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`marpol_record` ADD CONSTRAINT `fk_compliance_marpol_record_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`marpol_record` ADD CONSTRAINT `fk_compliance_marpol_record_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_broker` ADD CONSTRAINT `fk_compliance_customs_broker_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);

-- ========= compliance --> vessel (3 constraint(s)) =========
-- Requires: compliance schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_declaration` ADD CONSTRAINT `fk_compliance_customs_declaration_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`trade_document` ADD CONSTRAINT `fk_compliance_trade_document_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`compliance`.`customs_hold` ADD CONSTRAINT `fk_compliance_customs_hold_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);

-- ========= customer --> asset (1 constraint(s)) =========
-- Requires: customer schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_equipment_class_id` FOREIGN KEY (`equipment_class_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`equipment_class`(`equipment_class_id`);

-- ========= customer --> cargo (1 constraint(s)) =========
-- Requires: customer schema, cargo schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);

-- ========= customer --> compliance (4 constraint(s)) =========
-- Requires: customer schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_account` ADD CONSTRAINT `fk_customer_participant_account_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_marpol_record_id` FOREIGN KEY (`marpol_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`marpol_record`(`marpol_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_access_permit` ADD CONSTRAINT `fk_customer_port_access_permit_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);

-- ========= customer --> infrastructure (1 constraint(s)) =========
-- Requires: customer schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);

-- ========= customer --> intermodal (4 constraint(s)) =========
-- Requires: customer schema, intermodal schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_service_id` FOREIGN KEY (`service_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`service`(`service_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_transport_order_id` FOREIGN KEY (`transport_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`transport_order`(`transport_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_truck_appointment_id` FOREIGN KEY (`truck_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment`(`truck_appointment_id`);

-- ========= customer --> masterdata (14 constraint(s)) =========
-- Requires: customer schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_community_participant` ADD CONSTRAINT `fk_customer_port_community_participant_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_community_participant` ADD CONSTRAINT `fk_customer_port_community_participant_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_account` ADD CONSTRAINT `fk_customer_participant_account_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_address` ADD CONSTRAINT `fk_customer_participant_address_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_address` ADD CONSTRAINT `fk_customer_participant_address_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`sla_profile` ADD CONSTRAINT `fk_customer_sla_profile_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`sla_profile` ADD CONSTRAINT `fk_customer_sla_profile_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`sla_profile` ADD CONSTRAINT `fk_customer_sla_profile_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_access_permit` ADD CONSTRAINT `fk_customer_port_access_permit_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_access_permit` ADD CONSTRAINT `fk_customer_port_access_permit_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_access_permit` ADD CONSTRAINT `fk_customer_port_access_permit_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);

-- ========= customer --> tariff (5 constraint(s)) =========
-- Requires: customer schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_account` ADD CONSTRAINT `fk_customer_participant_account_discount_scheme_id` FOREIGN KEY (`discount_scheme_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`discount_scheme`(`discount_scheme_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_thc_schedule_id` FOREIGN KEY (`thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement` ADD CONSTRAINT `fk_customer_participant_service_agreement_discount_scheme_id` FOREIGN KEY (`discount_scheme_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`discount_scheme`(`discount_scheme_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement` ADD CONSTRAINT `fk_customer_participant_service_agreement_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);

-- ========= customer --> terminal (4 constraint(s)) =========
-- Requires: customer schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`sla_profile` ADD CONSTRAINT `fk_customer_sla_profile_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_gate_appointment_id` FOREIGN KEY (`gate_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`gate_appointment`(`gate_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`service_request` ADD CONSTRAINT `fk_customer_service_request_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`customer`.`port_access_permit` ADD CONSTRAINT `fk_customer_port_access_permit_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);

-- ========= infrastructure --> asset (3 constraint(s)) =========
-- Requires: infrastructure schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ADD CONSTRAINT `fk_infrastructure_quay_wall_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_equipment_class_id` FOREIGN KEY (`equipment_class_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`equipment_class`(`equipment_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= infrastructure --> compliance (6 constraint(s)) =========
-- Requires: infrastructure schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ADD CONSTRAINT `fk_infrastructure_anchorage_area_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ADD CONSTRAINT `fk_infrastructure_facility_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);

-- ========= infrastructure --> customer (13 constraint(s)) =========
-- Requires: infrastructure schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ADD CONSTRAINT `fk_infrastructure_quay_wall_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ADD CONSTRAINT `fk_infrastructure_channel_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ADD CONSTRAINT `fk_infrastructure_facility_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ADD CONSTRAINT `fk_infrastructure_port_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= infrastructure --> masterdata (19 constraint(s)) =========
-- Requires: infrastructure schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`berth` ADD CONSTRAINT `fk_infrastructure_berth_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ADD CONSTRAINT `fk_infrastructure_quay_wall_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall` ADD CONSTRAINT `fk_infrastructure_quay_wall_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone` ADD CONSTRAINT `fk_infrastructure_terminal_zone_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`warehouse` ADD CONSTRAINT `fk_infrastructure_warehouse_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ADD CONSTRAINT `fk_infrastructure_channel_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`channel` ADD CONSTRAINT `fk_infrastructure_channel_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port_gate` ADD CONSTRAINT `fk_infrastructure_port_gate_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ADD CONSTRAINT `fk_infrastructure_anchorage_area_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area` ADD CONSTRAINT `fk_infrastructure_anchorage_area_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ADD CONSTRAINT `fk_infrastructure_facility_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`facility` ADD CONSTRAINT `fk_infrastructure_facility_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ADD CONSTRAINT `fk_infrastructure_port_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`infrastructure`.`port` ADD CONSTRAINT `fk_infrastructure_port_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);

-- ========= intermodal --> asset (5 constraint(s)) =========
-- Requires: intermodal schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ADD CONSTRAINT `fk_intermodal_rail_wagon_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= intermodal --> cargo (4 constraint(s)) =========
-- Requires: intermodal schema, cargo schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_delivery_order_id` FOREIGN KEY (`delivery_order_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`delivery_order`(`delivery_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);

-- ========= intermodal --> compliance (10 constraint(s)) =========
-- Requires: intermodal schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_import_export_permit_id` FOREIGN KEY (`import_export_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`import_export_permit`(`import_export_permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_trade_document_id` FOREIGN KEY (`trade_document_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_document`(`trade_document_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_import_export_permit_id` FOREIGN KEY (`import_export_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`import_export_permit`(`import_export_permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_trade_document_id` FOREIGN KEY (`trade_document_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`trade_document`(`trade_document_id`);

-- ========= intermodal --> customer (35 constraint(s)) =========
-- Requires: intermodal schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_port_access_permit_id` FOREIGN KEY (`port_access_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_access_permit`(`port_access_permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_contact_person_id` FOREIGN KEY (`contact_person_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`contact_person`(`contact_person_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_contact_person_id` FOREIGN KEY (`contact_person_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`contact_person`(`contact_person_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_tertiary_transport_carrier_participant_account_id` FOREIGN KEY (`tertiary_transport_carrier_participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ADD CONSTRAINT `fk_intermodal_haulier_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ADD CONSTRAINT `fk_intermodal_haulier_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ADD CONSTRAINT `fk_intermodal_haulier_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ADD CONSTRAINT `fk_intermodal_rail_operator_credit_assessment_id` FOREIGN KEY (`credit_assessment_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`credit_assessment`(`credit_assessment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ADD CONSTRAINT `fk_intermodal_rail_operator_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ADD CONSTRAINT `fk_intermodal_rail_operator_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ADD CONSTRAINT `fk_intermodal_rail_operator_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ADD CONSTRAINT `fk_intermodal_service_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ADD CONSTRAINT `fk_intermodal_service_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ADD CONSTRAINT `fk_intermodal_service_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);

-- ========= intermodal --> infrastructure (24 constraint(s)) =========
-- Requires: intermodal schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ADD CONSTRAINT `fk_intermodal_haulier_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ADD CONSTRAINT `fk_intermodal_rail_operator_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ADD CONSTRAINT `fk_intermodal_service_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ADD CONSTRAINT `fk_intermodal_service_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);

-- ========= intermodal --> marine (2 constraint(s)) =========
-- Requires: intermodal schema, marine schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ADD CONSTRAINT `fk_intermodal_haulier_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ADD CONSTRAINT `fk_intermodal_rail_operator_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);

-- ========= intermodal --> masterdata (23 constraint(s)) =========
-- Requires: intermodal schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ADD CONSTRAINT `fk_intermodal_rail_wagon_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_wagon` ADD CONSTRAINT `fk_intermodal_rail_wagon_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`icd_facility` ADD CONSTRAINT `fk_intermodal_icd_facility_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`haulier` ADD CONSTRAINT `fk_intermodal_haulier_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_operator` ADD CONSTRAINT `fk_intermodal_rail_operator_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ADD CONSTRAINT `fk_intermodal_service_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);

-- ========= intermodal --> tariff (7 constraint(s)) =========
-- Requires: intermodal schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_thc_schedule_id` FOREIGN KEY (`thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_thc_schedule_id` FOREIGN KEY (`thc_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`thc_schedule`(`thc_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ADD CONSTRAINT `fk_intermodal_service_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);

-- ========= intermodal --> terminal (6 constraint(s)) =========
-- Requires: intermodal schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_visit` ADD CONSTRAINT `fk_intermodal_truck_visit_gate_transaction_id` FOREIGN KEY (`gate_transaction_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`gate_transaction`(`gate_transaction_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`service` ADD CONSTRAINT `fk_intermodal_service_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);

-- ========= intermodal --> vessel (6 constraint(s)) =========
-- Requires: intermodal schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`rail_visit` ADD CONSTRAINT `fk_intermodal_rail_visit_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment` ADD CONSTRAINT `fk_intermodal_truck_appointment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`drayage_order` ADD CONSTRAINT `fk_intermodal_drayage_order_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`intermodal`.`transport_order` ADD CONSTRAINT `fk_intermodal_transport_order_call_schedule_id` FOREIGN KEY (`call_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call_schedule`(`call_schedule_id`);

-- ========= marine --> asset (5 constraint(s)) =========
-- Requires: marine schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_failure_report_id` FOREIGN KEY (`failure_report_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`failure_report`(`failure_report_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);

-- ========= marine --> billing (1 constraint(s)) =========
-- Requires: marine schema, billing schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_charge_event_id` FOREIGN KEY (`charge_event_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`charge_event`(`charge_event_id`);

-- ========= marine --> compliance (4 constraint(s)) =========
-- Requires: marine schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);

-- ========= marine --> customer (13 constraint(s)) =========
-- Requires: marine schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_participant_service_agreement_id` FOREIGN KEY (`participant_service_agreement_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_service_agreement`(`participant_service_agreement_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_service_request_id` FOREIGN KEY (`service_request_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`service_request`(`service_request_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_tertiary_marine_approved_mooring_provider_port_community_participant_id` FOREIGN KEY (`tertiary_marine_approved_mooring_provider_port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= marine --> infrastructure (14 constraint(s)) =========
-- Requires: marine schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ADD CONSTRAINT `fk_marine_pilot_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_quay_wall_id` FOREIGN KEY (`quay_wall_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`quay_wall`(`quay_wall_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ADD CONSTRAINT `fk_marine_pilotage_route_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);

-- ========= marine --> masterdata (22 constraint(s)) =========
-- Requires: marine schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ADD CONSTRAINT `fk_marine_pilot_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilot` ADD CONSTRAINT `fk_marine_pilot_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug` ADD CONSTRAINT `fk_marine_tug_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ADD CONSTRAINT `fk_marine_pilotage_route_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);

-- ========= marine --> tariff (7 constraint(s)) =========
-- Requires: marine schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_surcharge_rule_id` FOREIGN KEY (`surcharge_rule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule`(`surcharge_rule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_route` ADD CONSTRAINT `fk_marine_pilotage_route_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);

-- ========= marine --> vessel (10 constraint(s)) =========
-- Requires: marine schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment` ADD CONSTRAINT `fk_marine_pilotage_assignment_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_agent_appointment_id` FOREIGN KEY (`agent_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`agent_appointment`(`agent_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`towage_order` ADD CONSTRAINT `fk_marine_towage_order_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`mooring_operation` ADD CONSTRAINT `fk_marine_mooring_operation_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_agent_appointment_id` FOREIGN KEY (`agent_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`agent_appointment`(`agent_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`service_order` ADD CONSTRAINT `fk_marine_service_order_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`marine`.`tug_assignment` ADD CONSTRAINT `fk_marine_tug_assignment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);

-- ========= masterdata --> customer (1 constraint(s)) =========
-- Requires: masterdata schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`masterdata`.`shipping_line` ADD CONSTRAINT `fk_masterdata_shipping_line_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= tariff --> billing (1 constraint(s)) =========
-- Requires: tariff schema, billing schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_receivable_account_id` FOREIGN KEY (`receivable_account_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`receivable_account`(`receivable_account_id`);

-- ========= tariff --> compliance (7 constraint(s)) =========
-- Requires: tariff schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ADD CONSTRAINT `fk_tariff_wharfage_schedule_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ADD CONSTRAINT `fk_tariff_surcharge_rule_hs_code_id` FOREIGN KEY (`hs_code_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`hs_code`(`hs_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ADD CONSTRAINT `fk_tariff_surcharge_rule_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);

-- ========= tariff --> customer (2 constraint(s)) =========
-- Requires: tariff schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= tariff --> infrastructure (20 constraint(s)) =========
-- Requires: tariff schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ADD CONSTRAINT `fk_tariff_port_tariff_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ADD CONSTRAINT `fk_tariff_thc_schedule_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ADD CONSTRAINT `fk_tariff_wharfage_schedule_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ADD CONSTRAINT `fk_tariff_wharfage_schedule_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ADD CONSTRAINT `fk_tariff_storage_tariff_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ADD CONSTRAINT `fk_tariff_storage_tariff_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ADD CONSTRAINT `fk_tariff_surcharge_rule_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ADD CONSTRAINT `fk_tariff_surcharge_rule_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ADD CONSTRAINT `fk_tariff_surcharge_rule_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ADD CONSTRAINT `fk_tariff_discount_scheme_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);

-- ========= tariff --> masterdata (25 constraint(s)) =========
-- Requires: tariff schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ADD CONSTRAINT `fk_tariff_port_tariff_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ADD CONSTRAINT `fk_tariff_port_tariff_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_tariff` ADD CONSTRAINT `fk_tariff_port_tariff_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`item` ADD CONSTRAINT `fk_tariff_item_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card_line` ADD CONSTRAINT `fk_tariff_rate_card_line_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`thc_schedule` ADD CONSTRAINT `fk_tariff_thc_schedule_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ADD CONSTRAINT `fk_tariff_wharfage_schedule_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ADD CONSTRAINT `fk_tariff_wharfage_schedule_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule` ADD CONSTRAINT `fk_tariff_wharfage_schedule_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ADD CONSTRAINT `fk_tariff_storage_tariff_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ADD CONSTRAINT `fk_tariff_storage_tariff_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`storage_tariff` ADD CONSTRAINT `fk_tariff_storage_tariff_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`surcharge_rule` ADD CONSTRAINT `fk_tariff_surcharge_rule_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ADD CONSTRAINT `fk_tariff_discount_scheme_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`discount_scheme` ADD CONSTRAINT `fk_tariff_discount_scheme_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule` ADD CONSTRAINT `fk_tariff_port_dues_schedule_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);

-- ========= tariff --> terminal (1 constraint(s)) =========
-- Requires: tariff schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`tariff`.`rate_card` ADD CONSTRAINT `fk_tariff_rate_card_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);

-- ========= terminal --> asset (6 constraint(s)) =========
-- Requires: terminal schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ADD CONSTRAINT `fk_terminal_yard_block_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_inspection_record_id` FOREIGN KEY (`inspection_record_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`inspection_record`(`inspection_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_work_order_id` FOREIGN KEY (`work_order_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`work_order`(`work_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ADD CONSTRAINT `fk_terminal_equipment_maintenance_plan_id` FOREIGN KEY (`maintenance_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`maintenance_plan`(`maintenance_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ADD CONSTRAINT `fk_terminal_equipment_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= terminal --> billing (3 constraint(s)) =========
-- Requires: terminal schema, billing schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_charge_event_id` FOREIGN KEY (`charge_event_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`charge_event`(`charge_event_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_charge_event_id` FOREIGN KEY (`charge_event_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`charge_event`(`charge_event_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_charge_event_id` FOREIGN KEY (`charge_event_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`charge_event`(`charge_event_id`);

-- ========= terminal --> cargo (3 constraint(s)) =========
-- Requires: terminal schema, cargo schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_shipment_id` FOREIGN KEY (`shipment_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`shipment`(`shipment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_stowage_plan_id` FOREIGN KEY (`stowage_plan_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`stowage_plan`(`stowage_plan_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_container_id` FOREIGN KEY (`container_id`) REFERENCES `vibe_shipping_ports_v1`.`cargo`.`container`(`container_id`);

-- ========= terminal --> compliance (10 constraint(s)) =========
-- Requires: terminal schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ADD CONSTRAINT `fk_terminal_yard_block_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_import_export_permit_id` FOREIGN KEY (`import_export_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`import_export_permit`(`import_export_permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_import_export_permit_id` FOREIGN KEY (`import_export_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`import_export_permit`(`import_export_permit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_customs_hold_id` FOREIGN KEY (`customs_hold_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_hold`(`customs_hold_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_import_export_permit_id` FOREIGN KEY (`import_export_permit_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`import_export_permit`(`import_export_permit_id`);

-- ========= terminal --> customer (6 constraint(s)) =========
-- Requires: terminal schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ADD CONSTRAINT `fk_terminal_terminal_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);

-- ========= terminal --> infrastructure (12 constraint(s)) =========
-- Requires: terminal schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ADD CONSTRAINT `fk_terminal_yard_block_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_warehouse_id` FOREIGN KEY (`warehouse_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`warehouse`(`warehouse_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_port_gate_id` FOREIGN KEY (`port_gate_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port_gate`(`port_gate_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ADD CONSTRAINT `fk_terminal_equipment_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ADD CONSTRAINT `fk_terminal_equipment_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ADD CONSTRAINT `fk_terminal_terminal_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);

-- ========= terminal --> intermodal (7 constraint(s)) =========
-- Requires: terminal schema, intermodal schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_slot` ADD CONSTRAINT `fk_terminal_yard_slot_icd_facility_id` FOREIGN KEY (`icd_facility_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`icd_facility`(`icd_facility_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_truck_appointment_id` FOREIGN KEY (`truck_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment`(`truck_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_truck_appointment_id` FOREIGN KEY (`truck_appointment_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`truck_appointment`(`truck_appointment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_rail_visit_id` FOREIGN KEY (`rail_visit_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`rail_visit`(`rail_visit_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_drayage_order_id` FOREIGN KEY (`drayage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`intermodal`.`drayage_order`(`drayage_order_id`);

-- ========= terminal --> marine (2 constraint(s)) =========
-- Requires: terminal schema, marine schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_pilotage_assignment_id` FOREIGN KEY (`pilotage_assignment_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment`(`pilotage_assignment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_towage_order_id` FOREIGN KEY (`towage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`towage_order`(`towage_order_id`);

-- ========= terminal --> masterdata (14 constraint(s)) =========
-- Requires: terminal schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ADD CONSTRAINT `fk_terminal_yard_block_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_container_type_id` FOREIGN KEY (`container_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`container_type`(`container_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_un_locode_id` FOREIGN KEY (`un_locode_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`un_locode`(`un_locode_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_transaction` ADD CONSTRAINT `fk_terminal_gate_transaction_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_commodity_code_id` FOREIGN KEY (`commodity_code_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`commodity_code`(`commodity_code_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`reefer_monitoring` ADD CONSTRAINT `fk_terminal_reefer_monitoring_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment` ADD CONSTRAINT `fk_terminal_equipment_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ADD CONSTRAINT `fk_terminal_terminal_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);

-- ========= terminal --> tariff (5 constraint(s)) =========
-- Requires: terminal schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`yard_block` ADD CONSTRAINT `fk_terminal_yard_block_storage_tariff_id` FOREIGN KEY (`storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_storage_tariff_id` FOREIGN KEY (`storage_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`storage_tariff`(`storage_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_port_dues_schedule_id` FOREIGN KEY (`port_dues_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule`(`port_dues_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_wharfage_schedule_id` FOREIGN KEY (`wharfage_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`wharfage_schedule`(`wharfage_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`terminal` ADD CONSTRAINT `fk_terminal_terminal_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);

-- ========= terminal --> vessel (6 constraint(s)) =========
-- Requires: terminal schema, vessel schema
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`container_visit` ADD CONSTRAINT `fk_terminal_container_visit_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`gate_appointment` ADD CONSTRAINT `fk_terminal_gate_appointment_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`equipment_dispatch` ADD CONSTRAINT `fk_terminal_equipment_dispatch_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`vessel_bay_plan` ADD CONSTRAINT `fk_terminal_vessel_bay_plan_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_call_id` FOREIGN KEY (`call_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`call`(`call_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`terminal`.`berth_allocation` ADD CONSTRAINT `fk_terminal_berth_allocation_voyage_id` FOREIGN KEY (`voyage_id`) REFERENCES `vibe_shipping_ports_v1`.`vessel`.`voyage`(`voyage_id`);

-- ========= vessel --> asset (2 constraint(s)) =========
-- Requires: vessel schema, asset schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ADD CONSTRAINT `fk_vessel_call_schedule_port_asset_id` FOREIGN KEY (`port_asset_id`) REFERENCES `vibe_shipping_ports_v1`.`asset`.`port_asset`(`port_asset_id`);

-- ========= vessel --> billing (2 constraint(s)) =========
-- Requires: vessel schema, billing schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ADD CONSTRAINT `fk_vessel_owner_receivable_account_id` FOREIGN KEY (`receivable_account_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`receivable_account`(`receivable_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_receivable_account_id` FOREIGN KEY (`receivable_account_id`) REFERENCES `vibe_shipping_ports_v1`.`billing`.`receivable_account`(`receivable_account_id`);

-- ========= vessel --> compliance (4 constraint(s)) =========
-- Requires: vessel schema, compliance schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ADD CONSTRAINT `fk_vessel_owner_sanctions_screening_id` FOREIGN KEY (`sanctions_screening_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`sanctions_screening`(`sanctions_screening_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_isps_facility_record_id` FOREIGN KEY (`isps_facility_record_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`isps_facility_record`(`isps_facility_record_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_customs_broker_id` FOREIGN KEY (`customs_broker_id`) REFERENCES `vibe_shipping_ports_v1`.`compliance`.`customs_broker`(`customs_broker_id`);

-- ========= vessel --> customer (10 constraint(s)) =========
-- Requires: vessel schema, customer schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ADD CONSTRAINT `fk_vessel_owner_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_contact_person_id` FOREIGN KEY (`contact_person_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`contact_person`(`contact_person_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_sla_profile_id` FOREIGN KEY (`sla_profile_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`sla_profile`(`sla_profile_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ADD CONSTRAINT `fk_vessel_voyage_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_contact_person_id` FOREIGN KEY (`contact_person_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`contact_person`(`contact_person_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_port_community_participant_id` FOREIGN KEY (`port_community_participant_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`port_community_participant`(`port_community_participant_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ADD CONSTRAINT `fk_vessel_port_call_participant_account_id` FOREIGN KEY (`participant_account_id`) REFERENCES `vibe_shipping_ports_v1`.`customer`.`participant_account`(`participant_account_id`);

-- ========= vessel --> infrastructure (11 constraint(s)) =========
-- Requires: vessel schema, infrastructure schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_anchorage_area_id` FOREIGN KEY (`anchorage_area_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`anchorage_area`(`anchorage_area_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_channel_id` FOREIGN KEY (`channel_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`channel`(`channel_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ADD CONSTRAINT `fk_vessel_call_schedule_berth_id` FOREIGN KEY (`berth_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`berth`(`berth_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ADD CONSTRAINT `fk_vessel_call_schedule_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ADD CONSTRAINT `fk_vessel_port_call_port_id` FOREIGN KEY (`port_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`port`(`port_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ADD CONSTRAINT `fk_vessel_port_call_terminal_zone_id` FOREIGN KEY (`terminal_zone_id`) REFERENCES `vibe_shipping_ports_v1`.`infrastructure`.`terminal_zone`(`terminal_zone_id`);

-- ========= vessel --> marine (4 constraint(s)) =========
-- Requires: vessel schema, marine schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_pilot_id` FOREIGN KEY (`pilot_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilot`(`pilot_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_pilotage_assignment_id` FOREIGN KEY (`pilotage_assignment_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment`(`pilotage_assignment_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_towage_order_id` FOREIGN KEY (`towage_order_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`towage_order`(`towage_order_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_pilotage_assignment_id` FOREIGN KEY (`pilotage_assignment_id`) REFERENCES `vibe_shipping_ports_v1`.`marine`.`pilotage_assignment`(`pilotage_assignment_id`);

-- ========= vessel --> masterdata (22 constraint(s)) =========
-- Requires: vessel schema, masterdata schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ADD CONSTRAINT `fk_vessel_vessel_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ADD CONSTRAINT `fk_vessel_vessel_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ADD CONSTRAINT `fk_vessel_vessel_vessel_master_id` FOREIGN KEY (`vessel_master_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_master`(`vessel_master_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`vessel` ADD CONSTRAINT `fk_vessel_vessel_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ADD CONSTRAINT `fk_vessel_owner_country_id` FOREIGN KEY (`country_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`country`(`country_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ADD CONSTRAINT `fk_vessel_voyage_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ADD CONSTRAINT `fk_vessel_voyage_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_imdg_class_id` FOREIGN KEY (`imdg_class_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`imdg_class`(`imdg_class_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`movement` ADD CONSTRAINT `fk_vessel_movement_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`certificate` ADD CONSTRAINT `fk_vessel_certificate_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ADD CONSTRAINT `fk_vessel_psc_inspection_flag_state_id` FOREIGN KEY (`flag_state_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`flag_state`(`flag_state_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ADD CONSTRAINT `fk_vessel_psc_inspection_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`psc_inspection` ADD CONSTRAINT `fk_vessel_psc_inspection_vessel_type_id` FOREIGN KEY (`vessel_type_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`vessel_type`(`vessel_type_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`agent_appointment` ADD CONSTRAINT `fk_vessel_agent_appointment_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ADD CONSTRAINT `fk_vessel_call_schedule_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ADD CONSTRAINT `fk_vessel_call_schedule_shipping_line_id` FOREIGN KEY (`shipping_line_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`shipping_line`(`shipping_line_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ADD CONSTRAINT `fk_vessel_port_call_port_location_id` FOREIGN KEY (`port_location_id`) REFERENCES `vibe_shipping_ports_v1`.`masterdata`.`port_location`(`port_location_id`);

-- ========= vessel --> tariff (6 constraint(s)) =========
-- Requires: vessel schema, tariff schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`owner` ADD CONSTRAINT `fk_vessel_owner_discount_scheme_id` FOREIGN KEY (`discount_scheme_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`discount_scheme`(`discount_scheme_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_port_tariff_id` FOREIGN KEY (`port_tariff_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_tariff`(`port_tariff_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call` ADD CONSTRAINT `fk_vessel_call_port_dues_schedule_id` FOREIGN KEY (`port_dues_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule`(`port_dues_schedule_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ADD CONSTRAINT `fk_vessel_voyage_rate_card_id` FOREIGN KEY (`rate_card_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`rate_card`(`rate_card_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`voyage` ADD CONSTRAINT `fk_vessel_voyage_port_dues_schedule_id` FOREIGN KEY (`port_dues_schedule_id`) REFERENCES `vibe_shipping_ports_v1`.`tariff`.`port_dues_schedule`(`port_dues_schedule_id`);

-- ========= vessel --> terminal (2 constraint(s)) =========
-- Requires: vessel schema, terminal schema
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`call_schedule` ADD CONSTRAINT `fk_vessel_call_schedule_terminal_id` FOREIGN KEY (`terminal_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`terminal`(`terminal_id`);
ALTER TABLE `vibe_shipping_ports_v1`.`vessel`.`port_call` ADD CONSTRAINT `fk_vessel_port_call_berth_allocation_id` FOREIGN KEY (`berth_allocation_id`) REFERENCES `vibe_shipping_ports_v1`.`terminal`.`berth_allocation`(`berth_allocation_id`);

