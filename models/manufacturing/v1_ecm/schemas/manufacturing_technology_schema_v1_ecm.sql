-- Schema for Domain: technology | Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:37

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`technology` COMMENT 'Manages enterprise IT assets, application portfolio, IT service management (ITSM), network infrastructure, OT/IT convergence, and digital transformation initiatives for the manufacturing enterprise';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`it_service` (
    `it_service_id` BIGINT COMMENT 'Unique system-generated identifier for each IT or OT service record in the enterprise service catalog.',
    `annual_budget` DECIMAL(18,2) COMMENT 'Total approved annual budget allocated for delivering and maintaining the service, including OPEX and CAPEX components. Used for IT financial planning and variance analysis.',
    `availability_target_pct` DECIMAL(18,2) COMMENT 'Contractual or agreed target availability percentage for the service (e.g., 99.99 for mission-critical OT services, 99.5 for standard IT services). Used for SLA compliance monitoring and reporting.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `business_owner` STRING COMMENT 'Name or identifier of the business-side stakeholder who owns the service from a business requirements and funding perspective. Distinct from the IT service owner.',
    `catalog_published` BOOLEAN COMMENT 'Indicates whether the service is currently published and visible in the end-user-facing service catalog portal. False indicates the service is internal/draft or restricted to specific teams.. Valid values are `true|false`',
    `category` STRING COMMENT 'High-level classification of the service type: infrastructure (network, compute, storage), platform (ERP hosting, MES platform), end-user (device provisioning, identity management), OT (SCADA support, PLC maintenance, historian management), security, application, data analytics, communication, cloud, or managed service.. Valid values are `infrastructure|platform|end_user|ot_operational_technology|security|application|data_analytics|communication|cloud|managed_service`',
    `change_management_category` STRING COMMENT 'Defines the change management process category applicable to changes affecting this service: standard (pre-approved low-risk), normal (requires CAB approval), emergency (expedited process), or OT-restricted (requires additional OT change controls for shop floor safety).. Valid values are `standard|normal|emergency|ot_restricted`',
    `cmdb_service_code` STRING COMMENT 'Reference identifier for this service record in the enterprise Configuration Management Database (CMDB), enabling linkage between the service catalog and the CMDB for CI relationship mapping.',
    `cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which the service unit cost and annual budget are denominated (e.g., USD, EUR, GBP). Supports multinational financial reporting.. Valid values are `^[A-Z]{3}$`',
    `cost_model` STRING COMMENT 'Defines how the cost of the service is structured and allocated: fixed (flat fee), per-user, per-device, consumption-based (usage metered), tiered, chargeback (cost allocated to consuming business units), showback (cost visibility without allocation), or free.. Valid values are `fixed|per_user|per_device|consumption_based|tiered|chargeback|showback|free`',
    `data_classification` STRING COMMENT 'Highest data classification level of the data processed or stored by this service, used to determine security controls, access restrictions, and compliance obligations.. Valid values are `public|internal|confidential|restricted`',
    `delivery_model` STRING COMMENT 'Describes how the service is delivered and hosted: on-premise (internal data center), cloud (public/private cloud), hybrid, outsourced (third-party provider), managed service, or co-managed (shared responsibility).. Valid values are `on_premise|cloud|hybrid|outsourced|managed_service|co_managed`',
    `description` STRING COMMENT 'Detailed narrative describing the scope, capabilities, and business value delivered by the service, including key features and intended consumers.',
    `is_critical_service` BOOLEAN COMMENT 'Flags whether the service is classified as business-critical, meaning its unavailability would directly impact manufacturing production, safety, or regulatory compliance. Drives priority in incident and change management.. Valid values are `true|false`',
    `is_ot_service` BOOLEAN COMMENT 'Indicates whether this service is classified as an Operational Technology (OT) service supporting manufacturing shop floor systems (e.g., SCADA, PLC, DCS, historian, MES). Drives OT-specific security and change management controls.. Valid values are `true|false`',
    `itsm_platform` STRING COMMENT 'Name of the IT Service Management (ITSM) platform where this service is registered and managed (e.g., ServiceNow, Jira Service Management, BMC Remedy). Supports cross-platform service catalog alignment.',
    `last_review_date` DATE COMMENT 'Date of the most recent formal service review, during which SLA performance, cost, and fitness-for-purpose were assessed by the service owner and stakeholders.. Valid values are `^d{4}-d{2}-d{2}$`',
    `launch_date` DATE COMMENT 'Date on which the service was officially launched and made available to consumers in the production environment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `name` STRING COMMENT 'Official business name of the IT or OT service as published in the enterprise service catalog (e.g., SAP S/4HANA ERP Hosting, SCADA Support Service, PLC Maintenance Service).',
    `next_review_date` DATE COMMENT 'Scheduled date for the next formal service review. Ensures regular governance and continual improvement cycles are maintained.. Valid values are `^d{4}-d{2}-d{2}$`',
    `owning_department` STRING COMMENT 'Name of the organizational department or IT team responsible for delivering and maintaining the service (e.g., IT Infrastructure, OT Engineering, Enterprise Applications, Cybersecurity).',
    `primary_ci_class` STRING COMMENT 'Classification of the primary Configuration Item (CI) type associated with this service in the CMDB (e.g., server, network device, PLC, SCADA system, application). Supports IT/OT asset traceability.. Valid values are `server|network_device|storage|application|database|middleware|ot_device|plc|scada|historian|endpoint|virtual_machine|cloud_resource|service`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the service record was first created in the enterprise service catalog system, used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the service catalog record, supporting change tracking and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `region` STRING COMMENT 'Geographic region(s) where the service is delivered or available (e.g., GLOBAL, USA, DEU, CHN). Supports multinational service catalog management and regional compliance reporting.',
    `regulatory_compliance_scope` STRING COMMENT 'Comma-separated list of regulatory frameworks or standards that this service must comply with (e.g., ISO 27001, IEC 62443, GDPR, REACH, RoHS, CE Marking). Used for compliance reporting and audit evidence.',
    `retirement_date` DATE COMMENT 'Planned or actual date on which the service will be or was decommissioned and removed from the service catalog. Null if the service is active with no planned retirement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `rpo_minutes` STRING COMMENT 'Maximum acceptable data loss measured in minutes, representing the point in time to which data must be recovered after a service disruption. Defined in the services SLA or business continuity plan.. Valid values are `^[0-9]+$`',
    `rto_minutes` STRING COMMENT 'Maximum acceptable time in minutes to restore the service after a disruption or outage, as defined in the services SLA or business continuity plan. Critical for manufacturing continuity planning.. Valid values are `^[0-9]+$`',
    `service_code` STRING COMMENT 'Standardized alphanumeric code uniquely identifying the service within the enterprise service catalog, used for cross-system referencing and reporting.. Valid values are `^[A-Z]{2,6}-[A-Z0-9]{3,10}$`',
    `service_manager` STRING COMMENT 'Name or identifier of the IT service manager responsible for day-to-day operational management, incident coordination, and service improvement activities.',
    `service_owner` STRING COMMENT 'Name or identifier of the individual accountable for the overall quality, performance, and lifecycle of the service. The service owner is the single point of accountability for the service.',
    `service_owner_email` STRING COMMENT 'Corporate email address of the service owner, used for escalations, notifications, and service catalog communications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `service_type` STRING COMMENT 'Distinguishes whether the service is a business-facing service (directly consumed by business users), a technical/supporting service (consumed by other IT services), a shared service (consumed across multiple business units), or an OT service (supporting operational technology environments).. Valid values are `business_service|technical_service|shared_service|ot_service`',
    `service_version` STRING COMMENT 'Version number of the service definition in the service catalog, incremented when significant changes are made to the service scope, SLA, or delivery model.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?$`',
    `sla_tier` STRING COMMENT 'SLA tier classification assigned to the service, determining the priority, response times, and recovery objectives applicable. Platinum/Gold tiers typically apply to mission-critical manufacturing systems such as MES and SCADA.. Valid values are `platinum|gold|silver|bronze|standard`',
    `status` STRING COMMENT 'Current lifecycle status of the service in the catalog: pipeline (planned, not yet live), active (currently delivered), deprecated (scheduled for retirement), retired (decommissioned), suspended (temporarily unavailable), or under_review (being assessed for change).. Valid values are `pipeline|active|deprecated|retired|suspended|under_review`',
    `subcategory` STRING COMMENT 'Secondary classification providing finer granularity within the service category (e.g., Network - WAN, OT - SCADA, Platform - ERP, End-User - Identity Management).',
    `support_hours` STRING COMMENT 'Defines the hours during which support is available for the service (e.g., 24x7 for critical OT/SCADA services, 8x5 for standard business services). Drives staffing and escalation planning.. Valid values are `8x5|12x5|16x5|24x7|24x5|follow_the_sun`',
    `unit_cost` DECIMAL(18,2) COMMENT 'Cost per unit of service consumption (e.g., cost per user per month, cost per device per year, cost per GB). Used for chargeback/showback calculations and IT financial management.',
    CONSTRAINT pk_it_service PRIMARY KEY(`it_service_id`)
) COMMENT 'Master record for all IT and OT services defined in the enterprise service catalog, including infrastructure services (network, compute, storage), platform services (ERP hosting, MES platform), end-user services (device provisioning, identity management), and OT services (SCADA support, PLC maintenance, historian management). Captures service name, service category, service owner, SLA tier, service description, delivery model, associated CIs (configuration items), cost model, and availability target. Aligned with ITIL service catalog management for the manufacturing enterprise.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`configuration_item` (
    `configuration_item_id` BIGINT COMMENT 'Unique surrogate identifier for each Configuration Item (CI) record in the Configuration Management Database (CMDB). Serves as the primary key for all CI-related operations, impact analysis, and change management processes.',
    `it_service_id` BIGINT COMMENT 'Foreign key linking to technology.it_service. Business justification: Configuration items support IT services. Normalize associated_service STRING to FK relationship with it_service master.',
    `ci_class` STRING COMMENT 'High-level classification of the CI within the CMDB taxonomy. Defines the structural category used for grouping, reporting, and applying class-specific attributes. Aligns with ITIL CI class hierarchy.. Valid values are `Hardware|Software|Network|Virtual Machine|Database|Application|Service|OT Device|Cloud Resource|Storage|Middleware|Security Appliance`',
    `ci_number` STRING COMMENT 'Human-readable, business-facing unique identifier for the CI, used in change records, incident tickets, and audit trails. Follows enterprise CMDB numbering conventions (e.g., CI-SRV001234).. Valid values are `^CI-[A-Z0-9]{6,20}$`',
    `ci_subtype` STRING COMMENT 'Further granular classification below CI type, used to distinguish variants within a type (e.g., within PLC: Safety PLC, Motion Controller; within Server: Physical, Blade, Rack). Supports detailed inventory reporting and compliance baseline management.',
    `ci_type` STRING COMMENT 'Granular type designation within the CI class, distinguishing specific device or software categories. Critical for OT/IT convergence visibility, enabling differentiation between IT infrastructure (servers, switches) and OT assets (PLC, HMI, SCADA, DCS) on the plant floor.. Valid values are `Server|Workstation|Network Switch|Router|Firewall|PLC|HMI|SCADA Server|DCS Controller|IIoT Gateway|Virtual Machine|Container|Database Instance|Application|Operating System|License|Storage Array|UPS|Printer|Mobile Device`',
    `compliance_baseline` STRING COMMENT 'Name or identifier of the security and configuration compliance baseline applied to the CI (e.g., CIS Benchmark Level 2, NIST SP 800-82, IEC 62443 SL-2). Used for compliance assessment, deviation tracking, and audit reporting.',
    `compliance_status` STRING COMMENT 'Current compliance status of the CI against its assigned compliance baseline. Non-compliant CIs trigger CAPA (Corrective and Preventive Action) workflows and are tracked in the compliance management system.. Valid values are `Compliant|Non-Compliant|Exempt|Under Review|Pending Remediation`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where the CI is physically located. Supports multi-country regulatory compliance scoping, data sovereignty requirements, and global infrastructure reporting.. Valid values are `^[A-Z]{3}$`',
    `cpu_count` STRING COMMENT 'Number of physical or virtual CPUs allocated to the CI. Used for capacity planning, software license compliance (per-core licensing), and performance baseline management.. Valid values are `^[1-9][0-9]*$`',
    `criticality` STRING COMMENT 'Business criticality rating of the CI based on its impact on manufacturing operations, safety, and revenue if unavailable. Drives change management approval levels, maintenance prioritization, and disaster recovery (DR) tier assignment.. Valid values are `Critical|High|Medium|Low`',
    `discovery_method` STRING COMMENT 'Method by which the CI was discovered and added to the CMDB. Automated discovery methods provide higher data accuracy; manual entries require additional validation. OT Passive Scan is used for OT environments where active scanning is prohibited.. Valid values are `Automated Discovery|Manual Entry|Agent-Based|Agentless|Import|API Integration|OT Passive Scan`',
    `end_of_life_date` DATE COMMENT 'Manufacturer-declared end-of-life date for the CI, after which hardware or software will no longer be supported or receive security patches. Critical for OT devices with long operational lifespans and cybersecurity risk management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `environment` STRING COMMENT 'Operational environment in which the CI is deployed. Distinguishes production systems from non-production environments for change management controls, compliance scoping, and risk assessment. Production CIs are subject to stricter change approval workflows.. Valid values are `Production|Development|Test|Staging|Disaster Recovery|Lab|Sandbox|Pre-Production`',
    `firmware_version` STRING COMMENT 'Current firmware version installed on the CI, particularly relevant for OT devices such as PLCs, HMIs, SCADA servers, and network appliances. Critical for cybersecurity vulnerability assessment and compliance baseline management per IEC 62443.',
    `hostname` STRING COMMENT 'Network hostname or DNS name assigned to the CI. Used for network discovery, monitoring, incident management, and change management. Serves as the primary operational identifier for IT infrastructure CIs.. Valid values are `^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$`',
    `install_date` DATE COMMENT 'Date on which the CI was physically installed or logically deployed into its operational environment. Used for asset age calculation, warranty tracking, and lifecycle management planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ip_address` STRING COMMENT 'Primary IP address (IPv4 or IPv6) assigned to the CI. Used for network topology mapping, incident response, OT/IT network segmentation analysis, and cybersecurity monitoring. Classified as confidential per GDPR and NIST guidance.. Valid values are `^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$|^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$`',
    `last_audit_date` DATE COMMENT 'Date of the most recent physical or logical audit/verification of the CI to confirm its existence, configuration, and compliance status. Supports ISO 27001 and IEC 62443 audit requirements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_change_date` TIMESTAMP COMMENT 'Timestamp of the most recent approved change applied to the CI, referencing the change management process. Used for change history tracking, compliance reporting, and identifying recently modified CIs during incident investigation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `location_name` STRING COMMENT 'Specific named location of the CI, such as data center name, plant name, building, floor, rack, or control room identifier. Used for physical asset tracking, maintenance dispatch, and disaster recovery planning.',
    `location_type` STRING COMMENT 'Categorization of the physical or logical location where the CI resides. Supports OT/IT convergence mapping by distinguishing plant floor and control room OT assets from data center IT infrastructure.. Valid values are `Data Center|Plant Floor|Control Room|Server Room|Network Closet|Cloud|Edge|Remote Site|Office|Warehouse`',
    `mac_address` STRING COMMENT 'Media Access Control (MAC) address of the primary network interface of the CI. Used for network access control (NAC), asset discovery reconciliation, and OT network security monitoring.. Valid values are `^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$`',
    `managed_by` STRING COMMENT 'Organizational team or group responsible for managing and maintaining the CI. Distinguishes IT-managed assets from OT-managed assets (e.g., plant maintenance team managing PLCs and HMIs), supporting OT/IT convergence governance.. Valid values are `IT Operations|OT Engineering|Plant Maintenance|Vendor|Cloud Operations|Network Operations|Security Operations`',
    `manufacturer` STRING COMMENT 'Name of the hardware or software manufacturer/vendor of the CI. Used for vendor management, warranty tracking, end-of-life (EOL) planning, and procurement decisions. Critical for OT devices where vendor support lifecycle impacts plant operations.',
    `model_number` STRING COMMENT 'Manufacturer-assigned model or part number for the CI. Enables standardization reporting, bulk procurement decisions, and vulnerability management by identifying all instances of a specific hardware or software model across the enterprise.',
    `name` STRING COMMENT 'Descriptive name of the configuration item as registered in the CMDB. Typically reflects the hostname, device label, application name, or asset tag used operationally across IT and OT environments.',
    `network_zone` STRING COMMENT 'Network security zone in which the CI resides. Critical for OT/IT convergence security architecture, defining trust boundaries, firewall rules, and access control policies per IEC 62443 zone and conduit model.. Valid values are `DMZ|Corporate LAN|OT Network|Industrial DMZ|Management Network|Internet-Facing|Restricted OT|Cloud VPC|Guest Network`',
    `operating_system` STRING COMMENT 'Name and version of the operating system running on the CI (e.g., Windows Server 2022, RHEL 8.6, VxWorks 7). Critical for patch management, vulnerability assessment, and end-of-support lifecycle planning.',
    `owner_name` STRING COMMENT 'Name of the business owner or accountable individual responsible for the CI from a business perspective. Used for change approval workflows, compliance accountability, and asset lifecycle decisions.',
    `parent_ci_number` STRING COMMENT 'CI number of the parent configuration item in the CI hierarchy. Enables hierarchical CI relationship modeling (e.g., a virtual machines parent is the physical host server; a PLCs parent is the control panel). Used for impact analysis and dependency mapping.. Valid values are `^CI-[A-Z0-9]{6,20}$`',
    `ram_gb` DECIMAL(18,2) COMMENT 'Total random-access memory (RAM) allocated to the CI in gigabytes. Used for capacity planning, performance baseline management, and infrastructure sizing decisions.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the CI record was first created in the CMDB. Used for data lineage, audit trail, and CMDB data quality reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the CI record in the CMDB, regardless of whether the update was triggered by a change, discovery, or manual correction. Supports data freshness monitoring and CMDB hygiene.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `serial_number` STRING COMMENT 'Manufacturer-assigned unique serial number for physical hardware CIs. Used for warranty claims, maintenance records, and physical asset verification. Classified as confidential as it uniquely identifies a physical device.',
    `site_code` STRING COMMENT 'Enterprise-standard code identifying the manufacturing plant, facility, or campus where the CI is physically or logically deployed. Enables multi-site reporting and plant-level OT/IT convergence analysis across the multinational enterprise.. Valid values are `^[A-Z0-9]{2,10}$`',
    `software_version` STRING COMMENT 'Current software or operating system version installed on the CI. Used for patch management, license compliance, vulnerability tracking, and compliance baseline verification. Applies to software CIs, OS instances, and application CIs.',
    `source_system` STRING COMMENT 'Operational system of record from which the CI record was originated or last synchronized. Supports data lineage tracking, reconciliation between CMDB and source systems, and audit trail completeness.. Valid values are `ServiceNow|Maximo EAM|SAP S/4HANA|Siemens MindSphere|Manual Entry|Network Discovery|Siemens Opcenter|Infor WMS`',
    `status` STRING COMMENT 'Current operational lifecycle status of the CI within the CMDB. Drives impact analysis, change management eligibility, and asset lifecycle reporting. Decommissioned and Retired statuses trigger compliance archival processes.. Valid values are `In Use|In Stock|In Maintenance|Decommissioned|Retired|Ordered|Pending Installation|Disposed|Unknown`',
    `storage_gb` DECIMAL(18,2) COMMENT 'Total storage capacity allocated to the CI in gigabytes. Used for capacity planning, storage lifecycle management, and infrastructure cost allocation.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `support_tier` STRING COMMENT 'Support tier classification indicating the level of vendor or internal support available for the CI. End-of-Life and End-of-Support CIs require risk acceptance or replacement planning, particularly critical for OT devices with long operational lifespans.. Valid values are `Tier 1|Tier 2|Tier 3|Vendor Supported|End of Life|End of Support`',
    CONSTRAINT pk_configuration_item PRIMARY KEY(`configuration_item_id`)
) COMMENT 'Configuration Management Database (CMDB) record for every managed configuration item (CI) in the IT and OT infrastructure. Captures CI type (server, network device, PLC, software, database, virtual machine), CI name, CI class, environment (production, development, DR), location (data center, plant floor, control room), operational status, parent CI, child CIs, associated services, change history reference, and compliance baseline. Supports impact analysis, change management, and OT/IT convergence visibility across manufacturing plants.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`service_ticket` (
    `service_ticket_id` BIGINT COMMENT 'Unique system-generated surrogate identifier for each service ticket record in the ITSM platform. Used as the primary key for all downstream joins and references.',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: Service tickets affect specific configuration items. Normalize affected_ci STRING to FK relationship with configuration_item for CMDB integration.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: IT service tickets often relate to equipment-specific issues (HMI failures, control system problems). IT support teams need this link to coordinate with maintenance and understand operational impact.',
    `it_service_id` BIGINT COMMENT 'Foreign key linking to technology.it_service. Business justification: Service tickets are raised against IT services. Normalize affected_service STRING to FK relationship with it_service master for proper service desk management.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: IT service tickets for vendor-supplied equipment or software issues reference the originating purchase order for warranty validation, vendor escalation, and support entitlement verification used by he',
    `technology_change_request_id` BIGINT COMMENT 'Foreign key linking to technology.change_request. Business justification: Service tickets may be linked to change requests. Normalize change_request_number STRING to FK relationship for ITSM process integration.',
    `acknowledged_timestamp` TIMESTAMP COMMENT 'Date and time when the assigned team or technician formally acknowledged receipt of the ticket. Used to measure SLA initial response time compliance. Critical for P1/P2 incidents where acknowledgement SLAs are contractually defined.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `assigned_team` STRING COMMENT 'Name of the IT or OT support team currently responsible for resolving the ticket (e.g., Level 1 Help Desk, Network Operations, OT/IIoT Support, SAP Basis Team, Cybersecurity). Used for workload balancing and team performance reporting.',
    `assigned_technician` STRING COMMENT 'Username or employee ID of the individual technician or engineer currently assigned to resolve the ticket. Tracks individual workload, resolution performance, and enables escalation management.',
    `business_impact_description` STRING COMMENT 'Free-text description of the operational or financial impact of the incident on manufacturing operations (e.g., production line stoppage, OEE degradation, delayed shipment, safety system unavailability). Used for executive reporting and post-incident reviews.',
    `category` STRING COMMENT 'Top-level classification of the service ticket subject area (e.g., Hardware, Software, Network, OT/IIoT, Security, Access Management, Application). Used for routing, reporting, and trend analysis across the IT and OT landscape.',
    `ci_type` STRING COMMENT 'Classification of the affected Configuration Item type. Distinguishes between IT infrastructure (servers, workstations, network devices) and OT/IIoT assets (PLCs, HMIs, SCADA systems, sensors) to support IT/OT convergence reporting and routing.. Valid values are `server|workstation|network_device|plc|hmi|scada|application|database|printer|mobile_device|ot_sensor|other`',
    `closed_timestamp` TIMESTAMP COMMENT 'Date and time when the ticket was formally closed after user confirmation of resolution or automatic closure after the defined waiting period. Marks the end of the full ticket lifecycle for reporting and archival purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `closure_code` STRING COMMENT 'Standardized code indicating how the ticket was ultimately closed. Used for quality reporting, identifying self-resolved incidents, tracking vendor-resolved issues, and measuring first-contact resolution rates.. Valid values are `resolved_by_support|resolved_by_user|no_fault_found|duplicate|workaround_applied|vendor_resolved|auto_closed|cancelled`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the site or location where the ticket originated. Supports multinational SLA compliance reporting, regional IT governance, and GDPR/CCPA jurisdiction determination for data handling.. Valid values are `^[A-Z]{3}$`',
    `escalation_level` STRING COMMENT 'Current escalation tier of the ticket: 1 (Level 1 – first-line support), 2 (Level 2 – specialist/technical), 3 (Level 3 – vendor/expert escalation). Tracks escalation history and is used for SLA breach prevention and management reporting.. Valid values are `1|2|3`',
    `impact` STRING COMMENT 'Assessment of the breadth of effect the incident or request has on business operations. High impact indicates enterprise-wide or plant-wide disruption; medium indicates departmental; low indicates individual user. Combined with urgency to derive priority.. Valid values are `high|medium|low`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the ticket record, including status changes, reassignments, notes additions, or resolution updates. Used for audit trail, data freshness monitoring, and change detection in the Silver layer pipeline.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `opened_timestamp` TIMESTAMP COMMENT 'Date and time when the service ticket was officially created and entered into the ITSM system. Marks the start of the SLA clock for response time measurement. Stored in ISO 8601 format with timezone offset for global operations.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `priority` STRING COMMENT 'Priority level assigned to the ticket based on impact and urgency matrix: P1 (Critical – production down), P2 (High – major degradation), P3 (Medium – partial impact), P4 (Low – minimal impact). Determines SLA response and resolution targets.. Valid values are `P1|P2|P3|P4`',
    `production_impact_flag` BOOLEAN COMMENT 'Indicates whether the incident directly impacted manufacturing production operations (True = production affected). Critical for manufacturing ITSM where OT/IT convergence means IT incidents can cause plant downtime, OEE degradation, or safety system failures.. Valid values are `true|false`',
    `related_problem_number` STRING COMMENT 'Reference to the associated Problem ticket number (PRB-XXXXXXXX) if this incident has been linked to an underlying problem record for root cause investigation. Supports ITIL Problem Management practice and recurring incident tracking.. Valid values are `^PRB-[0-9]{8}$`',
    `reported_by` STRING COMMENT 'Username or employee ID of the person who logged the ticket. May be a manufacturing employee, plant operator, or automated monitoring system (e.g., MindSphere alert). Used for requester communication, SLA accountability, and self-service analytics.',
    `reported_by_department` STRING COMMENT 'Organizational department of the person who reported the ticket (e.g., Production, Quality, Maintenance, IT, Procurement). Used for demand analysis, chargeback reporting, and identifying departments with high incident volumes.',
    `reported_by_location` STRING COMMENT 'Plant site or office location from which the ticket was reported (e.g., Plant-Chicago, HQ-Frankfurt, Warehouse-Singapore). Supports geographic incident distribution analysis and regional SLA compliance reporting for multinational operations.',
    `reported_by_name` STRING COMMENT 'Full display name of the person or system that reported the ticket. Stored for human-readable reporting and communication purposes. Subject to data privacy controls per GDPR and CCPA.',
    `resolution_description` STRING COMMENT 'Free-text narrative describing the technical actions taken to resolve the ticket, including steps performed, configurations changed, and workarounds applied. Captured by the resolving technician and used for knowledge base articles and recurring incident analysis.',
    `resolved_timestamp` TIMESTAMP COMMENT 'Date and time when the technical resolution was applied and the service was restored. Marks the end of the active resolution period for SLA resolution time measurement. Distinct from closed timestamp which requires user confirmation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `root_cause` STRING COMMENT 'Identified underlying cause of the incident or problem, documented after investigation. Mandatory for P1/P2 incidents and all Problem tickets. Feeds into CAPA processes, FMEA reviews, and recurring incident prevention programs aligned with ISO 9001 quality management.',
    `root_cause_category` STRING COMMENT 'Standardized classification of the root cause type. Enables trend analysis across incident categories to identify systemic issues, prioritize infrastructure investments, and support CAPA and continuous improvement programs.. Valid values are `hardware_failure|software_bug|configuration_error|human_error|network_issue|vendor_issue|capacity|security_breach|ot_it_integration|unknown`',
    `sla_breach_flag` BOOLEAN COMMENT 'Indicates whether the ticket breached its defined SLA resolution target (True = SLA breached, False = within SLA). Key metric for ITSM performance dashboards, vendor penalty calculations, and continuous improvement initiatives.. Valid values are `true|false`',
    `sla_resolution_target_minutes` STRING COMMENT 'Contracted or policy-defined maximum time in minutes within which the ticket must be fully resolved, based on priority and service type. Drives SLA breach monitoring and escalation triggers. Used in OEE and production availability impact reporting.. Valid values are `^[0-9]+$`',
    `sla_response_breach_flag` BOOLEAN COMMENT 'Indicates whether the initial response/acknowledgement SLA target was breached (True = response SLA breached). Distinct from resolution breach flag; enables separate tracking of response vs. resolution SLA compliance for granular performance management.. Valid values are `true|false`',
    `sla_response_target_minutes` STRING COMMENT 'Contracted or policy-defined maximum time in minutes within which the support team must acknowledge the ticket, based on priority and service type. P1 typically 15 min, P2 30 min, P3 4 hours, P4 8 hours. Used for SLA compliance measurement.. Valid values are `^[0-9]+$`',
    `source_channel` STRING COMMENT 'Channel through which the ticket was originally submitted (e.g., phone, email, self-service portal, automated IIoT alert from MindSphere, API integration from SCADA/MES). Used for channel adoption analytics and automation opportunity identification.. Valid values are `phone|email|self_service_portal|chat|automated_alert|walk_in|api`',
    `status` STRING COMMENT 'Current lifecycle state of the service ticket. Tracks progression from initial logging through resolution and closure. Pending indicates awaiting third-party or user response. Drives SLA clock management and reporting dashboards.. Valid values are `open|in_progress|pending|resolved|closed|cancelled`',
    `subcategory` STRING COMMENT 'Second-level classification providing more granular categorization within the parent category (e.g., under Hardware: Laptop, Server, PLC, HMI; under Software: ERP, MES, PLM). Enables detailed trend analysis and workload distribution reporting.',
    `ticket_number` STRING COMMENT 'Human-readable, business-facing ticket reference number generated by the ITSM system (e.g., INC-20240001). Prefixed by ticket type to enable quick identification. Displayed on all communications and SLA reports.. Valid values are `^(INC|SRQ|PRB|CHG)-[0-9]{8}$`',
    `ticket_type` STRING COMMENT 'Classification of the service ticket according to ITIL practice: Incident (unplanned interruption), Service Request (standard request), Problem (root cause investigation), or Change Request (planned modification). Drives workflow routing and SLA policy selection.. Valid values are `incident|service_request|problem|change_request`',
    `urgency` STRING COMMENT 'Assessment of how quickly the issue must be resolved to prevent business harm. High urgency indicates time-critical operations (e.g., production line stoppage); medium indicates degraded but operational; low indicates deferrable. Combined with impact to derive priority.. Valid values are `high|medium|low`',
    `workaround_applied_flag` BOOLEAN COMMENT 'Indicates whether a temporary workaround was applied to restore service before a permanent fix was implemented (True = workaround in use). Flags tickets requiring follow-up permanent resolution and feeds into Problem Management backlog tracking.. Valid values are `true|false`',
    CONSTRAINT pk_service_ticket PRIMARY KEY(`service_ticket_id`)
) COMMENT 'Core ITSM transactional record for all IT and OT service desk incidents, service requests, and problems raised by manufacturing employees, plant operators, and automated monitoring systems. Captures ticket number, ticket type (incident, service request, problem, change request), priority (P1–P4), category, subcategory, affected service, affected CI, reported by, assigned team, assigned technician, status (open, in-progress, resolved, closed), SLA breach flag, resolution description, root cause, and closure code. Aligned with ITIL incident and service request management for the manufacturing enterprise.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`technology_change_request` (
    `technology_change_request_id` BIGINT COMMENT 'Unique system-generated identifier for the change request record in the IT/OT change management system.',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: Change requests modify specific configuration items. ITIL change management requires CI linkage to assess impact, identify dependencies, and maintain accurate CMDB state after changes to infrastructur',
    `it_service_id` BIGINT COMMENT 'Foreign key linking to technology.it_service. Business justification: Change requests impact IT services. Normalize affected_services STRING to FK relationship with it_service master for change impact analysis.',
    `procurement_purchase_requisition_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_requisition. Business justification: IT change requests requiring new hardware, software, or services trigger purchase requisitions. Change management teams track requisition status to coordinate implementation timelines with procurement',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time when implementation of the change was completed or terminated, used for duration analysis and SLA compliance.',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time when implementation of the change began, used for change window compliance tracking and post-implementation review.',
    `affected_cis` STRING COMMENT 'Comma-separated list or description of Configuration Items (CIs) in the CMDB that are directly affected by this change, including servers, network devices, PLCs, SCADA systems, and applications.',
    `affected_production_lines` STRING COMMENT 'Identifies specific manufacturing production lines or shop floor areas impacted by the change, critical for OT/IT change governance to prevent unplanned production disruptions.',
    `approval_status` STRING COMMENT 'Current approval workflow status of the change request, tracking whether it is awaiting approval, has been approved, rejected, escalated to senior authority, or withdrawn by the requester.. Valid values are `pending|approved|rejected|escalated|withdrawn`',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the change request received final approval (CAB or delegated authority), authorizing implementation to proceed.',
    `approver_name` STRING COMMENT 'Name of the individual or role who provided final authorization for the change request (e.g., Change Manager, CAB Chair, or delegated authority).',
    `cab_review_date` DATE COMMENT 'Date on which the Change Advisory Board (CAB) convened to review and make a decision on this change request.',
    `cab_review_notes` STRING COMMENT 'Narrative notes from the CAB review session, including conditions of approval, concerns raised, and required actions before or after implementation.',
    `cab_review_outcome` STRING COMMENT 'Decision outcome from the Change Advisory Board (CAB) review, indicating whether the change was approved, rejected, deferred, or approved with specific conditions.. Valid values are `approved|rejected|deferred|approved_with_conditions|not_required`',
    `change_category` STRING COMMENT 'Functional category of the change, distinguishing IT infrastructure, enterprise applications, OT systems (SCADA, DCS, PLC firmware), network, and security changes to support OT/IT convergence governance.. Valid values are `infrastructure|application|network|ot_scada|ot_dcs|ot_plc_firmware|database|security|cloud|end_user_computing|middleware`',
    `change_type` STRING COMMENT 'Classification of the change by approval pathway: standard (pre-approved, low-risk), normal (requires full CAB review), or emergency (expedited approval for critical incidents).. Valid values are `standard|normal|emergency`',
    `change_window_end` TIMESTAMP COMMENT 'Scheduled end date and time of the approved maintenance/change window, defining the maximum duration allowed for implementation before rollback must be initiated.',
    `change_window_start` TIMESTAMP COMMENT 'Scheduled start date and time of the approved maintenance/change window during which the change will be implemented, aligned with production schedules to minimize disruption.',
    `closed_timestamp` TIMESTAMP COMMENT 'Date and time when the change request was formally closed after post-implementation review completion and all actions resolved.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the site or facility where the change is being implemented, supporting multinational change governance and regional compliance reporting.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Detailed narrative describing the proposed change, its scope, technical approach, and business rationale.',
    `impact_assessment_details` STRING COMMENT 'Detailed description of the business and operational impact of the change, including affected manufacturing lines, OT systems, enterprise applications, and estimated downtime.',
    `impact_level` STRING COMMENT 'Assessed level of business impact if the change is implemented or fails, considering affected production systems, services, and users.. Valid values are `critical|high|medium|low`',
    `implementation_plan` STRING COMMENT 'Step-by-step plan detailing how the change will be executed, including sequence of activities, responsible parties, and technical procedures for IT/OT system modifications.',
    `implementer_name` STRING COMMENT 'Name of the individual or team responsible for executing the change implementation during the approved change window.',
    `is_ot_change` BOOLEAN COMMENT 'Indicates whether this change involves Operational Technology (OT) systems such as SCADA, DCS, PLC firmware, or HMI, requiring additional OT/IT convergence governance and safety review.. Valid values are `true|false`',
    `number` STRING COMMENT 'Human-readable, business-facing unique identifier for the change request, used for cross-system referencing and communication (e.g., CR-2024-000123).. Valid values are `^CR-[0-9]{4}-[0-9]{6}$`',
    `post_implementation_review_notes` STRING COMMENT 'Detailed findings and lessons learned from the Post-Implementation Review, including any residual issues, follow-up actions, and recommendations for future similar changes.',
    `post_implementation_review_result` STRING COMMENT 'Outcome of the Post-Implementation Review (PIR) conducted after change execution, assessing whether the change achieved its objectives without adverse impact on production or IT/OT services.. Valid values are `successful|partially_successful|failed|pending_review`',
    `priority` STRING COMMENT 'Business priority assigned to the change request, influencing scheduling and resource allocation. Critical priority is reserved for changes preventing production disruption.. Valid values are `critical|high|medium|low`',
    `related_incident_number` STRING COMMENT 'Reference to the incident or problem record that triggered this change request, particularly relevant for emergency changes initiated in response to production or OT system failures.',
    `requester_department` STRING COMMENT 'Organizational department or business unit of the change requester, used for change volume reporting and departmental accountability.',
    `requester_name` STRING COMMENT 'Full name of the individual who submitted the change request, used for accountability and communication throughout the change lifecycle.',
    `risk_assessment_details` STRING COMMENT 'Narrative description of identified risks, including potential failure modes, impact on OT systems (SCADA, DCS, PLC), production lines, and mitigation strategies.',
    `risk_level` STRING COMMENT 'Overall risk rating assigned to the change based on the risk assessment, considering probability of failure, impact on production, and OT/IT system criticality.. Valid values are `very_high|high|medium|low`',
    `rollback_plan` STRING COMMENT 'Documented procedure to revert the change and restore systems to their pre-change state if implementation fails or causes unacceptable impact, critical for OT system safety.',
    `rollback_required` BOOLEAN COMMENT 'Indicates whether a rollback was executed during or after the change implementation due to failure or unacceptable impact on IT/OT systems.. Valid values are `true|false`',
    `site_code` STRING COMMENT 'Identifier for the specific manufacturing plant, facility, or data center where the change is being implemented, used for site-level change governance and production impact assessment.',
    `source_system` STRING COMMENT 'Operational system of record from which the change request originated, enabling data lineage tracking across SAP S/4HANA, Maximo EAM, Siemens MindSphere, and other enterprise systems.. Valid values are `sap_s4hana|servicenow|maximo|siemens_mindsphere|siemens_opcenter|manual|other`',
    `status` STRING COMMENT 'Current lifecycle status of the change request, tracking progression from initial submission through CAB review, implementation, and post-implementation closure.. Valid values are `draft|submitted|under_review|cab_approved|cab_rejected|scheduled|in_progress|implemented|closed|cancelled|failed`',
    `submitted_timestamp` TIMESTAMP COMMENT 'Date and time when the change request was formally submitted for review, marking the start of the change management workflow.',
    `title` STRING COMMENT 'Short, descriptive title summarizing the nature of the proposed change to IT/OT infrastructure or application.',
    CONSTRAINT pk_technology_change_request PRIMARY KEY(`technology_change_request_id`)
) COMMENT 'IT and OT change management record for all proposed and approved changes to IT infrastructure, enterprise applications, OT systems (SCADA, DCS, PLC firmware), and network configurations. Captures change request number, change type (standard, normal, emergency), change category, risk assessment, impact assessment, affected CIs, affected services, change window, approval status, CAB (Change Advisory Board) review outcome, implementation plan, rollback plan, and post-implementation review result. Critical for OT/IT change governance to prevent unplanned production disruptions.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`network_device` (
    `network_device_id` BIGINT COMMENT 'Unique surrogate identifier for each network infrastructure device record in the enterprise IT and OT network inventory.',
    `it_asset_id` BIGINT COMMENT 'Foreign key linking to technology.it_asset. Business justification: Network devices are IT assets. Normalize asset_tag STRING to FK relationship with it_asset master for unified asset management.',
    `building` STRING COMMENT 'Name or identifier of the building within the site where the network device is physically located, used for facilities management and incident response.',
    `configuration_backup_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent successful configuration backup for the network device, used to ensure recovery capability and compliance with change management and business continuity policies.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the network device is physically deployed, supporting multinational regulatory compliance and geographic reporting.. Valid values are `^[A-Z]{3}$`',
    `criticality_level` STRING COMMENT 'Business and operational criticality rating of the network device, used to prioritize incident response, maintenance scheduling, and redundancy planning. Critical devices support safety or production-critical OT systems.. Valid values are `critical|high|medium|low`',
    `default_gateway` STRING COMMENT 'IP address of the default gateway configured on the network device, used for routing traffic outside the local subnet.. Valid values are `^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$`',
    `device_type` STRING COMMENT 'Classification of the network device by its primary function within the enterprise IT or OT network infrastructure (e.g., router, switch, firewall, industrial Ethernet switch).. Valid values are `router|switch|firewall|wireless_access_point|industrial_ethernet_switch|sd_wan_appliance|dmz_component|load_balancer|vpn_concentrator|network_tap|ids_ips|proxy|other`',
    `end_of_life_date` DATE COMMENT 'Manufacturer-announced end-of-life date for the network device model, after which no further hardware support or security patches will be provided. Critical for vulnerability management and refresh planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `end_of_support_date` DATE COMMENT 'Date on which the manufacturer ends software and security support for the device, distinct from end-of-life hardware date. Used to prioritize cybersecurity risk remediation and upgrade scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `firmware_version` STRING COMMENT 'Current firmware or operating system version installed on the network device, used for vulnerability management, patch compliance tracking, and change management.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)*(-[a-zA-Z0-9]+)?$`',
    `hostname` STRING COMMENT 'Fully qualified or short hostname assigned to the network device, used for identification and DNS resolution across the enterprise network.. Valid values are `^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$`',
    `iec62443_security_level` STRING COMMENT 'Security level assigned to the network device per IEC 62443 industrial cybersecurity standard (SL0: No specific requirements, SL1: Protection against casual/coincidental violation, SL2: Intentional violation using simple means, SL3: Sophisticated means, SL4: State-sponsored attack). Drives security control requirements.. Valid values are `SL0|SL1|SL2|SL3|SL4`',
    `installation_date` DATE COMMENT 'Date on which the network device was physically installed and commissioned at its current location, marking the start of its operational lifecycle.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ip_address` STRING COMMENT 'Primary IPv4 or IPv6 address assigned to the network device management interface, used for network communication, monitoring, and access control.. Valid values are `^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$|^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$`',
    `is_managed` BOOLEAN COMMENT 'Indicates whether the network device is actively managed (monitored, configured, and patched) by the enterprise IT/OT network operations team, as opposed to unmanaged or shadow IT devices.. Valid values are `true|false`',
    `is_ot_device` BOOLEAN COMMENT 'Indicates whether the network device is part of the Operational Technology (OT) network (e.g., industrial Ethernet switch on plant floor) as opposed to the corporate IT network, supporting OT/IT convergence governance.. Valid values are `true|false`',
    `is_redundant` BOOLEAN COMMENT 'Indicates whether the network device is deployed in a redundant or high-availability configuration (e.g., HSRP, VRRP, stacked switches), supporting business continuity and uptime SLA management.. Valid values are `true|false`',
    `last_audit_date` DATE COMMENT 'Date of the most recent security configuration audit or compliance review performed on the network device, supporting IEC 62443 and ISO 27001 audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_patched_date` DATE COMMENT 'Date on which the most recent firmware or software patch was applied to the network device, used for patch compliance reporting and vulnerability management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `location_type` STRING COMMENT 'Category of physical location where the network device is installed (e.g., data center, plant, building, warehouse), used for infrastructure planning and incident response.. Valid values are `data_center|plant|building|warehouse|office|remote_site|colocation|other`',
    `mac_address` STRING COMMENT 'Media Access Control (MAC) address of the primary network interface of the device, used for Layer 2 identification, network access control (NAC), and security policy enforcement.. Valid values are `^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$`',
    `management_protocol` STRING COMMENT 'Primary protocol used for remote management and configuration of the network device (e.g., SSH, SNMP v3, NETCONF), used for security compliance and access control auditing.. Valid values are `ssh|telnet|snmp_v2|snmp_v3|netconf|restconf|https|http|other`',
    `management_vlan` STRING COMMENT 'VLAN identifier assigned for out-of-band management access to the network device, used to isolate management traffic from operational data traffic per network segmentation policy.. Valid values are `^([1-9]|[1-9][0-9]{1,2}|[1-3][0-9]{3}|40[0-8][0-9]|409[0-4])$`',
    `manufacturer` STRING COMMENT 'Name of the original equipment manufacturer (OEM) of the network device (e.g., Cisco, Juniper, Siemens, Rockwell Automation, Palo Alto Networks).',
    `model` STRING COMMENT 'Manufacturer-assigned model designation for the network device, used for procurement, support, and compatibility management.',
    `network_segment` STRING COMMENT 'Logical network segment to which the device belongs, distinguishing IT LAN, OT network, DMZ, plant floor network, and other segments for security zoning and traffic management.. Valid values are `it_lan|ot_network|dmz|plant_floor_network|corporate_wan|data_center|guest_network|management_network|other`',
    `network_zone_classification` STRING COMMENT 'Security zone classification assigned to the device per IEC 62443 security zone and conduit model, used to enforce access control policies and segment OT/IT networks.. Valid values are `safety|control|operations|enterprise|dmz|untrusted|restricted|public`',
    `operational_status` STRING COMMENT 'Current operational state of the network device, indicating whether it is active in production, under maintenance, decommissioned, or in another lifecycle state.. Valid values are `active|inactive|decommissioned|maintenance|provisioning|failed|retired|spare`',
    `os_version` STRING COMMENT 'Version of the network operating system (NOS) or embedded OS running on the device (e.g., Cisco IOS 15.7, Junos 21.2), distinct from firmware for devices with separate OS layers.',
    `purchase_date` DATE COMMENT 'Date on which the network device was procured by the enterprise, used for asset lifecycle management, depreciation calculation, and warranty tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `purdue_model_level` STRING COMMENT 'Network zone classification level per the Purdue Enterprise Reference Architecture (PERA) model (Level 0: Field devices, Level 1: Control, Level 2: Supervisory, Level 3: Manufacturing operations, Level 4: Business planning), supporting OT/IT convergence and IEC 62443 compliance.. Valid values are `^[0-4]$`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the network device record was first created in the enterprise data platform, used for data lineage, audit trail, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the network device record in the enterprise data platform, supporting change tracking, data quality monitoring, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `room_rack_location` STRING COMMENT 'Specific room, rack, and rack unit (U) position where the network device is physically installed (e.g., Server Room A / Rack 03 / U12), used for physical asset management and maintenance.',
    `serial_number` STRING COMMENT 'Manufacturer-assigned unique serial number for the physical network device, used for warranty tracking, asset management, and hardware lifecycle management.',
    `site_code` STRING COMMENT 'Enterprise-assigned code identifying the physical site or facility where the network device is deployed, enabling geographic and organizational reporting.',
    `snmp_community_string_encrypted` STRING COMMENT 'Encrypted SNMP community string used for network monitoring and management of the device. Stored in encrypted form to protect network access credentials per cybersecurity policy.',
    `subnet_mask` STRING COMMENT 'Subnet mask associated with the devices primary IP address, defining the network segment boundary for routing and segmentation purposes.. Valid values are `^((255|254|252|248|240|224|192|128|0).){3}(255|254|252|248|240|224|192|128|0)$`',
    `warranty_expiry_date` DATE COMMENT 'Date on which the manufacturer warranty for the network device expires, used to trigger maintenance contract renewals and hardware refresh planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_network_device PRIMARY KEY(`network_device_id`)
) COMMENT 'Master record for all network infrastructure devices across the enterprise IT and OT networks including routers, switches, firewalls, wireless access points, industrial Ethernet switches, DMZ components, and SD-WAN appliances. Captures device hostname, device type, manufacturer, model, firmware version, IP address, MAC address, network segment (IT LAN, OT network, DMZ, plant floor network), location (data center, plant, building), management VLAN, operational status, and network zone classification (Purdue Model Level 0–4). Supports OT/IT network convergence and IEC 62443 compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`software_license` (
    `software_license_id` BIGINT COMMENT 'Unique system-generated identifier for each software license or entitlement record managed within the enterprise Software Asset Management (SAM) program.',
    `application_id` BIGINT COMMENT 'Foreign key linking to technology.application. Business justification: Software licenses support specific applications. Normalize software_title STRING to FK relationship with application master for license-to-application tracking.',
    `asset_register_id` BIGINT COMMENT 'Foreign key linking to finance.asset_register. Business justification: Capitalized software licenses (perpetual licenses, major implementations) are recorded in the asset register for depreciation calculation, balance sheet reporting, and audit compliance.',
    `it_contract_id` BIGINT COMMENT 'Foreign key linking to technology.it_contract. Business justification: Software licenses are governed by contracts. Normalize contract_reference STRING to FK relationship with it_contract master.',
    `it_vendor_id` BIGINT COMMENT 'Foreign key linking to technology.it_vendor. Business justification: Software licenses are purchased from vendors. Normalize vendor_name STRING to FK relationship with it_vendor master.',
    `procurement_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_contract. Business justification: Software licenses are procured under specific contracts that define terms, pricing, and renewal conditions. IT asset managers reference procurement contracts daily for license compliance audits and re',
    `annual_maintenance_cost` DECIMAL(18,2) COMMENT 'The annual cost of vendor maintenance and support for this license. Classified as OPEX. Used for total cost of ownership (TCO) analysis and budget planning.',
    `assigned_department` STRING COMMENT 'The business department or organizational unit to which this software license is primarily assigned (e.g., Manufacturing Engineering, IT Operations, R&D, Finance). Supports license allocation and chargeback.',
    `assigned_site` STRING COMMENT 'The physical plant, facility, or geographic site where the software license is deployed or authorized for use. Relevant for site licenses and multi-site compliance tracking.',
    `auto_renewal` BOOLEAN COMMENT 'Indicates whether the software subscription or maintenance contract is set to automatically renew at expiry. Drives financial commitment tracking and procurement planning.. Valid values are `true|false`',
    `available_entitlements` STRING COMMENT 'The number of unassigned or unused license entitlements remaining (total_entitlements minus consumed_entitlements). Supports license optimization and reallocation decisions.. Valid values are `^[0-9]+$`',
    `capex_opex_classification` STRING COMMENT 'Financial classification of the software license cost as either Capital Expenditure (CAPEX) for perpetual licenses or Operational Expenditure (OPEX) for subscriptions. Drives accounting treatment and financial reporting.. Valid values are `capex|opex`',
    `category` STRING COMMENT 'Functional classification of the software product within the enterprise application portfolio (e.g., ERP, MES, PLM, SCADA, CAD/CAM, OS). Supports portfolio analysis and SAM reporting.. Valid values are `erp|mes|plm|scada|cad_cam|operating_system|database|middleware|security|analytics|collaboration|itsm|crm|wms|iot_platform|development_tools|other`',
    `compliance_status` STRING COMMENT 'Current Software Asset Management (SAM) compliance posture for this license. Indicates whether actual deployments are within licensed entitlements. Critical for audit readiness and vendor audit defense.. Valid values are `compliant|over_deployed|under_utilized|at_risk|unverified`',
    `consumed_entitlements` STRING COMMENT 'The number of license entitlements currently in active use or assigned across the enterprise. Compared against total_entitlements to determine compliance position.. Valid values are `^[0-9]+$`',
    `cost_center_code` STRING COMMENT 'The SAP CO cost center code to which the software license cost is allocated. Enables departmental cost reporting and IT chargeback/showback processes.',
    `country_code` STRING COMMENT 'The ISO 3166-1 alpha-3 country code of the jurisdiction where the software license is deployed or the legal entity holding the license is domiciled. Supports regional compliance and export control requirements.. Valid values are `^[A-Z]{3}$`',
    `currency_code` STRING COMMENT 'The ISO 4217 three-letter currency code in which the license cost is denominated (e.g., USD, EUR, GBP). Supports multi-currency financial reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `deployment_type` STRING COMMENT 'Indicates how the software is deployed and consumed within the enterprise infrastructure (e.g., on-premise, SaaS, PaaS, hybrid). Affects cost allocation and compliance tracking.. Valid values are `on_premise|cloud_saas|cloud_paas|cloud_iaas|hybrid|hosted`',
    `effective_date` DATE COMMENT 'The date from which the software license becomes valid and the licensee is authorized to use the software. May differ from purchase date for future-dated agreements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'The date on which the software license or subscription expires and the right to use the software ceases. Null for perpetual licenses. Drives renewal alerts and compliance monitoring.. Valid values are `^d{4}-d{2}-d{2}$`',
    `invoice_reference` STRING COMMENT 'The vendor invoice number associated with the purchase of this software license. Used for financial reconciliation and accounts payable matching in SAP FI.',
    `is_downgrade_rights` BOOLEAN COMMENT 'Indicates whether the license agreement grants the right to use a prior version of the software product. Relevant for compatibility with legacy manufacturing systems.. Valid values are `true|false`',
    `is_transferable` BOOLEAN COMMENT 'Indicates whether the software license can be transferred between users, devices, or organizational units per the vendor license agreement terms.. Valid values are `true|false`',
    `legal_entity` STRING COMMENT 'The legal entity or company code within the enterprise that holds the software license agreement. Critical for intercompany cost allocation and multi-entity compliance in multinational operations.',
    `license_cost` DECIMAL(18,2) COMMENT 'The total purchase or annual subscription cost of the software license in the transaction currency. Used for CAPEX/OPEX classification, budget tracking, and TCO analysis.',
    `license_key` STRING COMMENT 'The alphanumeric activation or product key issued by the software vendor to validate and activate the licensed software installation. Treated as confidential to prevent unauthorized use.',
    `license_metric` STRING COMMENT 'The unit of measure by which license consumption is counted and compliance is assessed (e.g., per user, per device, per core, per processor). Critical for SAM compliance audits.. Valid values are `per_user|per_device|per_core|per_processor|per_server|per_instance|per_seat|concurrent_users|site_wide|enterprise_wide`',
    `license_owner` STRING COMMENT 'The name or employee ID of the IT asset manager or business owner responsible for managing and renewing this software license. Accountable contact for SAM audits.',
    `license_type` STRING COMMENT 'The commercial licensing model under which the software is authorized for use. Determines how entitlements are counted and compliance is measured (e.g., perpetual, subscription, concurrent, named user).. Valid values are `perpetual|subscription|concurrent|named_user|site|oem|trial|open_source|freeware|volume`',
    `maintenance_expiry_date` DATE COMMENT 'The date on which the vendor maintenance and support contract for this license expires. Relevant for perpetual licenses where support is purchased separately from the license.. Valid values are `^d{4}-d{2}-d{2}$`',
    `notes` STRING COMMENT 'Free-text field for additional remarks, special licensing conditions, audit findings, or operational notes relevant to this software license record.',
    `po_number` STRING COMMENT 'The SAP MM Purchase Order (PO) number associated with the procurement of this software license. Links the license record to the procurement transaction for audit and financial reconciliation.',
    `purchase_date` DATE COMMENT 'The date on which the software license was purchased or the license agreement was executed. Used for depreciation, audit trails, and lifecycle tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `renewal_date` DATE COMMENT 'The target date by which the license renewal must be initiated or completed to avoid service interruption. May precede expiry_date to allow for procurement lead time.. Valid values are `^d{4}-d{2}-d{2}$`',
    `renewal_notice_days` STRING COMMENT 'The number of days prior to expiry_date that a renewal notification must be issued per the vendor contract terms. Used to trigger automated renewal alerts in the SAM workflow.. Valid values are `^[0-9]+$`',
    `software_edition` STRING COMMENT 'The edition or tier of the licensed software product (e.g., Enterprise, Professional, Standard, Developer, OEM). Determines feature set and licensing terms.',
    `software_version` STRING COMMENT 'The specific release or version number of the licensed software (e.g., 2023.1, 10.0.2, 22H2). Used to track version compliance and upgrade eligibility.',
    `status` STRING COMMENT 'Current lifecycle status of the software license record. Drives compliance alerts, renewal workflows, and SAM dashboard reporting.. Valid values are `active|expired|pending_renewal|terminated|suspended|in_procurement|retired`',
    `total_entitlements` STRING COMMENT 'The total number of license seats, users, devices, cores, or instances authorized under this license agreement. Represents the purchased quantity.. Valid values are `^[0-9]+$`',
    `vendor_part_number` STRING COMMENT 'The vendor-assigned part number or SKU for the software license product as referenced in purchase orders and vendor catalogs.',
    CONSTRAINT pk_software_license PRIMARY KEY(`software_license_id`)
) COMMENT 'Master record for all enterprise software licenses and entitlements managed across the manufacturing enterprise including ERP licenses (SAP), MES licenses (Siemens Opcenter), CAD/CAM licenses (NX, CATIA), SCADA licenses, operating system licenses, and SaaS subscriptions. Captures license key, software title, vendor, license type (perpetual, subscription, concurrent, named user), total entitlements, consumed entitlements, compliance status, purchase date, expiry date, renewal date, cost center allocation, and contract reference. Supports SAM (Software Asset Management) and license compliance audits.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`it_project` (
    `it_project_id` BIGINT COMMENT 'Unique system-generated identifier for each IT and digital transformation project in the enterprise technology portfolio.',
    `digital_initiative_id` BIGINT COMMENT 'Foreign key linking to technology.digital_initiative. Business justification: IT projects implement digital initiatives. Normalize strategic_initiative STRING to FK relationship with digital_initiative master for portfolio alignment.',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: IT projects (ERP implementations, infrastructure upgrades) use internal orders to collect costs, track budgets, and enable capitalization decisions for financial reporting.',
    `it_contract_id` BIGINT COMMENT 'Foreign key linking to technology.it_contract. Business justification: IT projects are governed by contracts. Normalize contract_ref STRING to FK relationship with it_contract master.',
    `it_vendor_id` BIGINT COMMENT 'Foreign key linking to technology.it_vendor. Business justification: IT projects may involve external vendors. Normalize vendor_name STRING to FK relationship with it_vendor master.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: IT projects implement systems to support R&D initiatives (new PLM system, lab data management, simulation infrastructure). IT portfolio management tracks which R&D projects drive technology investment',
    `sales_opportunity_id` BIGINT COMMENT 'Foreign key linking to sales.opportunity. Business justification: IT/OT implementation projects originate from won sales opportunities. Project managers track the source opportunity to understand scope, commitments, pricing, and customer expectations throughout deli',
    `actual_end_date` DATE COMMENT 'The actual date on which the IT project was formally closed or completed, used to measure schedule variance against the planned end date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `actual_start_date` DATE COMMENT 'The actual date on which the IT project formally commenced execution, which may differ from the planned start date due to approvals, resource availability, or scope changes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `affected_systems` STRING COMMENT 'Comma-separated list of enterprise systems impacted or integrated by the IT project (e.g., SAP S/4HANA, Siemens Opcenter MES, MindSphere IIoT), used for change impact assessment and cutover planning.',
    `approved_budget` DECIMAL(18,2) COMMENT 'Total capital and operational expenditure budget formally approved for the IT project by the IT governance committee or finance authority, expressed in the project currency.',
    `budget_consumed` DECIMAL(18,2) COMMENT 'Total expenditure incurred against the IT project to date, including labor, software licenses, hardware, and third-party services. Used to track budget utilization and forecast overruns.',
    `budget_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the currency in which the project budget is denominated (e.g., USD, EUR, GBP), supporting multi-currency financial reporting.. Valid values are `^[A-Z]{3}$`',
    `business_case_ref` STRING COMMENT 'Reference number or document identifier for the formal business case that justified the IT project investment, including ROI analysis, NPV, and strategic alignment rationale.',
    `business_owner` STRING COMMENT 'Full name of the business-side owner or product owner who represents the primary business stakeholder, defines requirements, and accepts deliverables for the IT project.',
    `capex_amount` DECIMAL(18,2) COMMENT 'Portion of the approved project budget classified as Capital Expenditure (CAPEX), representing investments in assets that will be capitalized on the balance sheet per IFRS/GAAP accounting standards.',
    `change_request_count` STRING COMMENT 'Total number of approved change requests (scope changes) raised against the IT project, used to track scope creep and project complexity over the project lifecycle.. Valid values are `^[0-9]+$`',
    `compliance_requirement` STRING COMMENT 'Regulatory or compliance obligation that the IT project is designed to address or support (e.g., GDPR Data Privacy, IEC 62443 Cybersecurity, ISO 9001 QMS, RoHS/REACH Compliance), used for compliance portfolio tracking.',
    `cost_center` STRING COMMENT 'SAP S/4HANA cost center code to which the IT project costs are allocated for internal financial reporting and management accounting purposes.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary country where the IT project is being executed or where the primary business impact is realized, supporting multi-country portfolio reporting.. Valid values are `^[A-Z]{3}$`',
    `delivery_methodology` STRING COMMENT 'Project management and delivery methodology applied to the IT project (e.g., Waterfall, Agile, SAFe, Hybrid), which governs how work is planned, executed, and governed.. Valid values are `Waterfall|Agile|SAFe|Hybrid|PRINCE2|Scrum|Kanban`',
    `deployment_environment` STRING COMMENT 'Target deployment environment for the IT project deliverables, indicating whether the solution will be hosted on-premise, in the cloud, in a hybrid model, or at the edge for OT/IIoT use cases.. Valid values are `On-Premise|Cloud|Hybrid|Edge|SaaS|PaaS|IaaS`',
    `description` STRING COMMENT 'Detailed narrative describing the scope, objectives, and expected outcomes of the IT project, including business problem being solved and solution approach.',
    `go_live_date` DATE COMMENT 'The planned or actual date on which the IT project deliverable (e.g., ERP system, MES module, IIoT platform) is transitioned to production and made available to business users.. Valid values are `^d{4}-d{2}-d{2}$`',
    `health_indicator` STRING COMMENT 'Red-Amber-Green (RAG) health indicator reflecting the overall project health based on schedule, budget, and scope performance. Used in IT portfolio dashboards and executive reporting.. Valid values are `Green|Amber|Red`',
    `manager` STRING COMMENT 'Full name of the IT project manager responsible for day-to-day project execution, resource coordination, risk management, and delivery of project milestones.',
    `name` STRING COMMENT 'Official name of the IT or digital transformation project as registered in the enterprise IT portfolio (e.g., SAP S/4HANA Finance Module Upgrade, MindSphere IIoT Platform Deployment).',
    `opex_amount` DECIMAL(18,2) COMMENT 'Portion of the approved project budget classified as Operational Expenditure (OPEX), representing ongoing operational costs expensed in the period per IFRS/GAAP accounting standards.',
    `phase` STRING COMMENT 'Current lifecycle phase of the IT project following standard project management methodology (Initiation, Planning, Execution, Monitoring & Control, Closure).. Valid values are `Initiation|Planning|Execution|Monitoring & Control|Closure`',
    `planned_end_date` DATE COMMENT 'The originally approved completion date for the IT project as defined in the project charter and baseline schedule.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_start_date` DATE COMMENT 'The originally approved start date for the IT project as defined in the project charter and baseline schedule.. Valid values are `^d{4}-d{2}-d{2}$`',
    `post_go_live_support_end_date` DATE COMMENT 'The date on which the dedicated post-go-live hypercare and stabilization support period ends, after which the solution transitions to standard IT operations and support.. Valid values are `^d{4}-d{2}-d{2}$`',
    `priority` STRING COMMENT 'Business priority level assigned to the IT project by the IT governance committee, used for resource allocation and portfolio sequencing decisions.. Valid values are `Critical|High|Medium|Low`',
    `project_code` STRING COMMENT 'Business-assigned alphanumeric code used to uniquely identify and reference the IT project across enterprise systems such as SAP S/4HANA and project management tools.. Valid values are `^[A-Z]{2,4}-[0-9]{4,8}$`',
    `project_type` STRING COMMENT 'Classification of the IT project by its primary technology or business function category, such as ERP upgrade, MES implementation, IIoT platform deployment, OT/IT convergence, or cybersecurity program.. Valid values are `ERP Implementation|ERP Upgrade|MES Implementation|IIoT Platform Deployment|OT/IT Convergence|Cybersecurity Program|Cloud Migration|Infrastructure Upgrade|Application Development|Digital Transformation|Network Infrastructure|Data & Analytics|Compliance & Regulatory|Maintenance & Support`',
    `region` STRING COMMENT 'Enterprise-defined geographic region where the IT project is primarily executed (e.g., North America, Europe, Asia Pacific), used for regional portfolio management and resource planning.',
    `revised_end_date` DATE COMMENT 'The most recently approved revised completion date for the IT project, reflecting approved schedule changes due to scope adjustments, resource constraints, or risk events.. Valid values are `^d{4}-d{2}-d{2}$`',
    `risk_level` STRING COMMENT 'Overall risk level assigned to the IT project based on the project risk assessment, considering technical complexity, business impact, regulatory exposure, and delivery risk.. Valid values are `Critical|High|Medium|Low`',
    `roi_target_percent` DECIMAL(18,2) COMMENT 'Target Return on Investment (ROI) percentage as defined in the approved business case, representing the expected financial return relative to the total project investment.',
    `sponsor_name` STRING COMMENT 'Full name of the executive or senior leader who sponsors the IT project, provides strategic direction, and is accountable for business outcomes and funding approval.',
    `status` STRING COMMENT 'Current operational status of the IT project indicating whether it is in draft, approved, actively executing, on hold, cancelled, completed, or archived.. Valid values are `Draft|Approved|Active|On Hold|Cancelled|Completed|Archived`',
    `technology_domain` STRING COMMENT 'The primary technology domain or capability area that the IT project belongs to, used for portfolio segmentation and resource planning (e.g., Enterprise Applications, IIoT & OT, Cybersecurity).. Valid values are `Enterprise Applications|Manufacturing Execution|IIoT & OT|Cybersecurity|Cloud & Infrastructure|Data & Analytics|Network & Connectivity|Workplace Technology|Digital Twin|IT/OT Convergence`',
    `wbs_element` STRING COMMENT 'SAP PS Work Breakdown Structure (WBS) element code that hierarchically organizes the project scope into manageable components for cost tracking, scheduling, and resource planning.',
    CONSTRAINT pk_it_project PRIMARY KEY(`it_project_id`)
) COMMENT 'Master record for all IT and digital transformation projects in the enterprise technology portfolio including ERP upgrades, MES implementations, IIoT platform deployments, OT/IT convergence initiatives, cybersecurity programs, and cloud migration projects. Captures project name, project type, project sponsor, IT project manager, business owner, project phase (initiation, planning, execution, closure), planned start/end dates, actual start/end dates, budget approved, budget consumed, project status, strategic initiative alignment, and technology domain. Supports IT portfolio management and digital transformation governance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` (
    `it_project_milestone_id` BIGINT COMMENT 'Unique system-generated identifier for each IT project milestone record within the enterprise data platform.',
    `it_project_id` BIGINT COMMENT 'Foreign key linking to technology.it_project. Business justification: Milestones belong to IT projects. Clear parent-child relationship. Establish FK to it_project for project tracking.',
    `acceptance_criteria` STRING COMMENT 'Defined conditions and measurable criteria that must be satisfied for the milestone to be formally accepted and signed off, ensuring objective completion assessment.',
    `actual_date` DATE COMMENT 'Date on which the milestone was formally achieved and accepted. Null if the milestone has not yet been completed. Used to calculate schedule variance against planned date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `associated_system` STRING COMMENT 'Name of the enterprise IT or operational technology system primarily associated with this milestone (e.g., SAP S/4HANA, Siemens Opcenter MES, Siemens MindSphere, Salesforce CRM), linking milestone to the system being implemented or upgraded.',
    `budget_impact` STRING COMMENT 'Assessment of the financial impact on project budget if this milestone is delayed or not achieved, used for Capital Expenditure (CAPEX) and Operational Expenditure (OPEX) governance decisions.. Valid values are `no_impact|minor_impact|moderate_impact|significant_impact|critical_impact`',
    `completion_percentage` DECIMAL(18,2) COMMENT 'Percentage of work completed toward achieving the milestone, ranging from 0.00 to 100.00. Used in earned value management and executive progress dashboards.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary geographic location or business unit where this milestone is being executed, supporting multinational program governance and regional reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the milestone record was first created in the system, used for audit trail and data lineage tracking in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `delay_category` STRING COMMENT 'Standardized category classifying the root cause of milestone delay, enabling trend analysis across the IT project portfolio to identify systemic delivery issues.. Valid values are `resource_constraint|scope_change|technical_issue|vendor_dependency|budget_constraint|regulatory_requirement|organizational_change|external_factor|not_applicable`',
    `delay_reason` STRING COMMENT 'Documented reason for milestone delay when status is delayed, capturing root cause categories such as resource constraints, scope changes, technical issues, or vendor dependencies.',
    `deliverables` STRING COMMENT 'Comma-separated list or description of key deliverables and artifacts associated with this milestone (e.g., UAT Sign-Off Document, Test Summary Report, Go/No-Go Decision Record).',
    `dependency_description` STRING COMMENT 'Narrative description of predecessor milestones, external dependencies, or preconditions that must be met before this milestone can be achieved (e.g., Dependent on data migration completion from SAP ECC).',
    `description` STRING COMMENT 'Detailed narrative describing the scope, acceptance criteria, and business significance of the milestone within the digital transformation program.',
    `forecast_date` DATE COMMENT 'Current best-estimate date for milestone achievement based on project team assessment, used for rolling-wave planning and executive progress reporting when actual date is not yet known.. Valid values are `^d{4}-d{2}-d{2}$`',
    `is_critical_path` BOOLEAN COMMENT 'Indicates whether this milestone lies on the critical path of the project schedule. Critical path milestones directly impact the project end date if delayed.. Valid values are `true|false`',
    `is_executive_reportable` BOOLEAN COMMENT 'Flags whether this milestone is included in executive-level steering committee and board reporting for digital transformation program governance.. Valid values are `true|false`',
    `last_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the milestone record, supporting change tracking, data freshness monitoring, and incremental processing in the lakehouse pipeline.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `milestone_category` STRING COMMENT 'High-level category grouping the milestone by its primary driver — technical delivery, business readiness, regulatory compliance, contractual obligation, financial approval, or governance review.. Valid values are `technical|business|regulatory|contractual|financial|governance`',
    `milestone_code` STRING COMMENT 'Business-assigned alphanumeric code uniquely identifying the milestone within the project management system, used for cross-system referencing and reporting.. Valid values are `^MLT-[A-Z0-9]{4,12}$`',
    `milestone_type` STRING COMMENT 'Classification of the milestone by its functional purpose within the IT project lifecycle, such as go-live, User Acceptance Testing (UAT) completion, cutover, or phase gate review.. Valid values are `go_live|uat_completion|cutover|phase_gate|design_freeze|pilot_launch|training_completion|data_migration|system_integration|project_kickoff|project_closure|steering_committee_review|other`',
    `name` STRING COMMENT 'Descriptive name of the IT project milestone (e.g., SAP S/4HANA Go-Live, UAT Completion, Phase Gate 2 Review), used in executive dashboards and project governance reports.',
    `notes` STRING COMMENT 'Free-text field for additional context, project team observations, escalation notes, or supplementary information relevant to the milestone that does not fit structured fields.',
    `phase_name` STRING COMMENT 'Name of the project phase or stage to which this milestone belongs (e.g., Prepare, Explore, Realize, Deploy in SAP Activate; or Initiation, Planning, Execution, Closure in PMBOK).',
    `phase_sequence` STRING COMMENT 'Numeric sequence order of the project phase within the overall project lifecycle, enabling chronological ordering and phase gate progression tracking.',
    `planned_date` DATE COMMENT 'Originally baselined date on which the milestone was scheduled to be achieved, as defined in the approved project plan. Used for schedule variance analysis and phase gate reviews.. Valid values are `^d{4}-d{2}-d{2}$`',
    `priority` STRING COMMENT 'Business priority level assigned to the milestone, indicating its criticality to the overall project success and digital transformation program objectives.. Valid values are `critical|high|medium|low`',
    `program_name` STRING COMMENT 'Name of the overarching digital transformation program or initiative under which this IT project milestone falls, enabling portfolio-level reporting and executive governance.',
    `region` STRING COMMENT 'Business region or geographic cluster associated with the milestone (e.g., North America, EMEA, Asia Pacific), used for regional rollout tracking in global manufacturing IT programs.',
    `responsible_owner` STRING COMMENT 'Full name or employee identifier of the individual accountable for driving the milestone to completion. Typically a project manager, workstream lead, or IT program manager.',
    `responsible_owner_role` STRING COMMENT 'Job role or title of the responsible owner (e.g., IT Program Manager, SAP Solution Architect, Digital Transformation Lead), providing organizational context for governance reporting.',
    `revised_planned_date` DATE COMMENT 'Most recently approved revised target date for milestone achievement following formal change control, reflecting re-baselined project schedule after scope or resource changes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `risk_level` STRING COMMENT 'Assessed risk level associated with achieving this milestone on time and within scope, used for proactive risk management and escalation decisions in IT project governance.. Valid values are `critical|high|medium|low|none`',
    `schedule_variance_days` STRING COMMENT 'Number of calendar days by which the milestone is ahead of (negative) or behind (positive) the planned date. Calculated as actual/forecast date minus planned date. Supports schedule performance reporting.',
    `sign_off_authority` STRING COMMENT 'Name or role of the individual or body authorized to formally approve and sign off on milestone completion (e.g., CIO, Steering Committee, Business Process Owner).',
    `sign_off_comments` STRING COMMENT 'Free-text comments or conditions recorded by the sign-off authority at the time of milestone acceptance, including any outstanding actions or conditional approvals.',
    `sign_off_date` DATE COMMENT 'Date on which the authorized sign-off authority formally approved and accepted the milestone deliverables, completing the governance acceptance process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this milestone record originates (e.g., SAP S/4HANA PS, Microsoft Project, ServiceNow), enabling data lineage and reconciliation.',
    `status` STRING COMMENT 'Current lifecycle status of the milestone, indicating whether it is pending, actively being worked on, successfully achieved, delayed beyond planned date, cancelled, or placed on hold.. Valid values are `pending|in_progress|achieved|delayed|cancelled|on_hold`',
    CONSTRAINT pk_it_project_milestone PRIMARY KEY(`it_project_milestone_id`)
) COMMENT 'Transactional record tracking planned and actual milestone achievements within IT and digital transformation projects. Captures milestone name, milestone type (go-live, UAT completion, cutover, phase gate), planned date, actual date, milestone status (pending, achieved, delayed, cancelled), completion percentage, responsible owner, sign-off authority, and associated deliverables. Enables IT project governance, executive reporting on digital transformation progress, and phase gate reviews for major manufacturing technology programs.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`digital_initiative` (
    `digital_initiative_id` BIGINT COMMENT 'Unique system-generated identifier for each enterprise digital transformation initiative or Industry 4.0 program record.',
    `account_plan_id` BIGINT COMMENT 'Foreign key linking to sales.account_plan. Business justification: Digital transformation initiatives align with strategic account plans for key manufacturing customers. Account executives coordinate technology roadmaps with sales strategies to identify expansion opp',
    `it_vendor_id` BIGINT COMMENT 'Foreign key linking to technology.it_vendor. Business justification: Digital initiatives involve vendor partners. Normalize vendor_partner STRING to FK relationship with it_vendor master.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Digital transformation initiatives (IoT deployments, smart factory projects) are often co-developed with key customer accounts as sponsors or pilot partners. Project teams track customer involvement f',
    `actual_end_date` DATE COMMENT 'Actual calendar date on which the digital initiative was completed or closed.. Valid values are `^d{4}-d{2}-d{2}$`',
    `actual_spend` DECIMAL(18,2) COMMENT 'Cumulative actual expenditure incurred on the digital initiative to date, expressed in the reporting currency.',
    `actual_start_date` DATE COMMENT 'Actual calendar date on which execution of the digital initiative commenced.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approval_date` DATE COMMENT 'Date on which the digital initiative was formally approved by the governance board and authorized for funding and execution.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_budget` DECIMAL(18,2) COMMENT 'Total approved capital and operational expenditure (CAPEX + OPEX) budget allocated to the digital initiative, expressed in the reporting currency.',
    `change_management_approach` STRING COMMENT 'Methodology or framework adopted for managing the delivery and organizational change associated with the digital initiative.. Valid values are `Agile|Waterfall|Hybrid|SAFe|PRINCE2`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the budget and financial values associated with the initiative (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `deployment_scope` STRING COMMENT 'Geographic or organizational scope of the initiative deployment, indicating whether it applies globally, regionally, at country level, or at a specific site, plant, or production line.. Valid values are `Global|Regional|Country|Site|Plant|Department|Line`',
    `description` STRING COMMENT 'Detailed narrative describing the scope, purpose, and expected outcomes of the digital initiative.',
    `executive_sponsor` STRING COMMENT 'Name of the C-level or senior executive (e.g., CDO, CTO, COO) who is the executive sponsor and accountable for the initiatives success.',
    `expected_cost_reduction_percent` DECIMAL(18,2) COMMENT 'Target percentage reduction in operational or production costs expected as a measurable business outcome of the initiative.',
    `expected_cycle_time_reduction_percent` DECIMAL(18,2) COMMENT 'Target percentage reduction in manufacturing cycle time expected as a key performance outcome of the initiative.',
    `expected_oee_improvement_percent` DECIMAL(18,2) COMMENT 'Target percentage improvement in Overall Equipment Effectiveness (OEE) expected as a key business outcome of the initiative.',
    `expected_roi_percent` DECIMAL(18,2) COMMENT 'Projected Return on Investment (ROI) percentage expected from the digital initiative upon full implementation, as approved in the business case.',
    `governance_board` STRING COMMENT 'Name of the enterprise governance body responsible for approving, reviewing, and overseeing the digital initiative, such as the Digital Transformation Steering Committee or Industry 4.0 Council.',
    `initiative_code` STRING COMMENT 'Business-assigned alphanumeric code uniquely identifying the digital initiative for cross-system reference and portfolio tracking.. Valid values are `^DI-[A-Z0-9]{4,12}$`',
    `initiative_type` STRING COMMENT 'Classification of the digital initiative by technology domain, such as Industrial Internet of Things (IIoT) deployment, smart factory program, digital twin implementation, AI/ML adoption, or cloud migration wave.. Valid values are `IIoT_Deployment|Smart_Factory|Digital_Twin|AI_ML_Adoption|Cloud_Migration|Connected_Worker|Cybersecurity|Data_Analytics|Automation|ERP_Transformation|MES_Implementation|PLM_Modernization|OT_IT_Convergence|Other`',
    `investment_category` STRING COMMENT 'Classification of the initiative investment as Capital Expenditure (CAPEX), Operational Expenditure (OPEX), or a mixed investment type.. Valid values are `CAPEX|OPEX|Mixed`',
    `kpi_targets` STRING COMMENT 'Structured text or JSON-serialized list of Key Performance Indicator (KPI) targets defined for the initiative, including metric name, baseline value, and target value.',
    `last_review_date` DATE COMMENT 'Date of the most recent formal governance review or steering committee checkpoint for the digital initiative.. Valid values are `^d{4}-d{2}-d{2}$`',
    `maturity_level` STRING COMMENT 'Current digital maturity level of the initiative based on an industry-standard capability maturity model, ranging from Initial to Optimizing.. Valid values are `Initial|Developing|Defined|Managed|Optimizing`',
    `name` STRING COMMENT 'Official name of the digital transformation initiative or Industry 4.0 program as registered in the enterprise digital portfolio.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next formal governance review or steering committee checkpoint for the digital initiative.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_end_date` DATE COMMENT 'Planned calendar date by which the digital initiative is expected to be fully completed and benefits realized.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_start_date` DATE COMMENT 'Planned calendar date on which the digital initiative is scheduled to begin execution.. Valid values are `^d{4}-d{2}-d{2}$`',
    `priority` STRING COMMENT 'Business priority level assigned to the initiative by the digital governance board, used for resource allocation and portfolio sequencing.. Valid values are `Critical|High|Medium|Low`',
    `program_manager` STRING COMMENT 'Name of the program or project manager responsible for day-to-day execution and delivery of the digital initiative.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when the digital initiative record was first created in the enterprise data platform.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when the digital initiative record was most recently updated in the enterprise data platform.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `regulatory_compliance_flags` STRING COMMENT 'Comma-separated list of regulatory frameworks or standards that the initiative must comply with, such as IEC 62443, GDPR, CCPA, RoHS, REACH, CE Marking, or OSHA.',
    `risk_level` STRING COMMENT 'Overall risk level assigned to the digital initiative based on the enterprise risk assessment, considering technical complexity, organizational change impact, and financial exposure.. Valid values are `Critical|High|Medium|Low`',
    `roadmap_phase` STRING COMMENT 'Current phase of the initiative within the enterprise digital transformation roadmap, from foundational infrastructure through pilot, scale-out, optimization, and sustainment.. Valid values are `Phase_1_Foundation|Phase_2_Pilot|Phase_3_Scale|Phase_4_Optimize|Phase_5_Sustain`',
    `sponsoring_business_unit` STRING COMMENT 'Name of the business unit or organizational division that is the primary sponsor and accountable owner of the digital initiative.',
    `status` STRING COMMENT 'Current lifecycle status of the digital initiative, from ideation through execution to completion or cancellation.. Valid values are `Ideation|Approved|In_Planning|In_Execution|On_Hold|Completed|Cancelled|Deferred`',
    `strategic_objective` STRING COMMENT 'Primary strategic objective this initiative is aligned to, such as Overall Equipment Effectiveness (OEE) improvement, cost reduction, cycle time reduction, or quality improvement.. Valid values are `OEE_Improvement|Cost_Reduction|Cycle_Time_Reduction|Quality_Improvement|Safety_Enhancement|Sustainability|Revenue_Growth|Customer_Experience|Workforce_Productivity|Supply_Chain_Resilience|Regulatory_Compliance|Other`',
    `systems_impacted` STRING COMMENT 'Comma-separated list of operational systems of record impacted or integrated by the initiative, such as SAP S/4HANA, Siemens Opcenter MES, Siemens MindSphere, Maximo EAM, or Salesforce CRM.',
    `target_business_processes` STRING COMMENT 'Comma-separated list of core business processes targeted for transformation, such as Manufacturing Execution, Quality Assurance, Supply Chain Management, or Asset Maintenance.',
    `target_countries` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes identifying the countries where the initiative will be deployed.. Valid values are `^[A-Z]{3}(,[A-Z]{3})*$`',
    `target_sites` STRING COMMENT 'Comma-separated list of manufacturing plant or facility site codes targeted for deployment of the digital initiative.',
    `technology_domains` STRING COMMENT 'Comma-separated list of technology domains impacted by the initiative, such as IIoT, MES, ERP, PLM, Cloud, AI/ML, OT/IT Convergence, Cybersecurity.',
    CONSTRAINT pk_digital_initiative PRIMARY KEY(`digital_initiative_id`)
) COMMENT 'Master record for enterprise digital transformation initiatives and Industry 4.0 programs including IIoT deployments, smart factory programs, digital twin implementations, AI/ML adoption, cloud migration waves, and connected worker platforms. Captures initiative name, initiative type, strategic objective alignment, sponsoring business unit, technology domains impacted, expected business outcomes (OEE improvement, cost reduction, cycle time reduction), investment level, implementation roadmap phase, current maturity level, and KPI targets. Supports the CDO/CTO digital transformation governance and Industry 4.0 roadmap management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`iiot_platform` (
    `iiot_platform_id` BIGINT COMMENT 'Unique system-generated identifier for each IIoT platform record in the enterprise asset registry.',
    `it_contract_id` BIGINT COMMENT 'Foreign key linking to technology.it_contract. Business justification: IIoT platforms have licensing contracts. Establish FK to it_contract master. Contract dates (contract_start_date, contract_end_date) are execution-specific and should remain on iiot_platform.',
    `it_vendor_id` BIGINT COMMENT 'Foreign key linking to technology.it_vendor. Business justification: IIoT platforms are provided by vendors. Normalize vendor_name STRING to FK relationship with it_vendor master.',
    `annual_license_cost` DECIMAL(18,2) COMMENT 'Annual licensing or subscription cost for the IIoT platform in the contract currency, used for IT budget management, OPEX tracking, and vendor spend analysis.',
    `authentication_method` STRING COMMENT 'Authentication mechanism used to control device and user access to the IIoT platform, critical for cybersecurity posture and IEC 62443 compliance.. Valid values are `certificate-based|OAuth2|API-key|username-password|MFA|SAML|Other`',
    `connected_device_count` STRING COMMENT 'Total number of IIoT-enabled devices (sensors, PLCs, CNCs, actuators, gateways) currently connected and registered to this platform, used for capacity planning and licensing.. Valid values are `^[0-9]+$`',
    `contract_end_date` DATE COMMENT 'Date on which the vendor contract or subscription for the IIoT platform expires, used for renewal planning, budget forecasting, and license compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `contract_start_date` DATE COMMENT 'Date on which the vendor contract or subscription for the IIoT platform became effective, used for license management and financial planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the IIoT platform is physically deployed, supporting regulatory compliance and data residency requirements.. Valid values are `^[A-Z]{3}$`',
    `data_classification` STRING COMMENT 'Enterprise data governance classification level assigned to the data processed by this IIoT platform, determining access controls, encryption requirements, and handling procedures.. Valid values are `restricted|confidential|internal|public`',
    `data_ingestion_rate_per_sec` DECIMAL(18,2) COMMENT 'Rated or observed data ingestion throughput of the IIoT platform measured in messages or data points per second, used for performance benchmarking and capacity management.',
    `data_retention_days` STRING COMMENT 'Number of days that raw telemetry and event data is retained on the IIoT platform before archival or deletion, aligned with data governance policies and regulatory requirements.. Valid values are `^[0-9]+$`',
    `decommission_date` DATE COMMENT 'Date on which the IIoT platform was or is scheduled to be decommissioned and removed from production, used for asset lifecycle management and data archival planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `deployment_model` STRING COMMENT 'Architectural deployment model of the IIoT platform indicating whether it runs in the cloud, at the edge (on-premise near machines), as a hybrid combination, or fully on-premise.. Valid values are `cloud|edge|hybrid|on-premise`',
    `edge_node_count` STRING COMMENT 'Number of edge computing nodes (gateways, edge servers) deployed as part of this IIoT platform to perform local data processing, filtering, and protocol translation before cloud transmission.. Valid values are `^[0-9]+$`',
    `encryption_standard` STRING COMMENT 'Encryption standard applied to data in transit and at rest on the IIoT platform, used for cybersecurity compliance audits and risk assessments.. Valid values are `AES-256|TLS-1.2|TLS-1.3|AES-128|None|Other`',
    `environment_type` STRING COMMENT 'Designates the operational environment of the IIoT platform instance — production, staging, development, disaster recovery, or test — to support change management and incident response.. Valid values are `production|staging|development|disaster_recovery|test`',
    `erp_integration_enabled` BOOLEAN COMMENT 'Indicates whether the IIoT platform is actively integrated with an ERP system (e.g., SAP S/4HANA) for bidirectional data exchange including asset master data, work orders, and production confirmations.. Valid values are `true|false`',
    `go_live_date` DATE COMMENT 'Date on which the IIoT platform was officially commissioned and transitioned to production operations, used for asset lifecycle tracking and ROI measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `historian_integration_enabled` BOOLEAN COMMENT 'Indicates whether the IIoT platform is integrated with a process historian (e.g., OSIsoft PI, Siemens SIMATIC WinCC) for time-series data archival and retrieval.. Valid values are `true|false`',
    `integration_targets` STRING COMMENT 'Comma-separated list of downstream enterprise systems integrated with this IIoT platform (e.g., Historian, MES, ERP, Data Lake, CMMS), used for IT/OT convergence mapping and impact analysis.',
    `last_patch_date` DATE COMMENT 'Date of the most recent security patch or firmware update applied to the IIoT platform, used for vulnerability management and cybersecurity compliance audits.. Valid values are `^d{4}-d{2}-d{2}$`',
    `license_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the annual license cost (e.g., USD, EUR, GBP), enabling multi-currency financial reporting across global deployments.. Valid values are `^[A-Z]{3}$`',
    `max_device_capacity` STRING COMMENT 'Maximum number of devices the IIoT platform is licensed and architected to support concurrently, used for capacity planning and license compliance.. Valid values are `^[0-9]+$`',
    `mes_integration_enabled` BOOLEAN COMMENT 'Indicates whether the IIoT platform is actively integrated with a Manufacturing Execution System (MES) for real-time shop floor data exchange and production visibility.. Valid values are `true|false`',
    `next_scheduled_maintenance_date` DATE COMMENT 'Date of the next planned maintenance window for the IIoT platform, used for change management scheduling and production impact planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `ot_it_convergence_enabled` BOOLEAN COMMENT 'Indicates whether the IIoT platform is configured to bridge OT and IT networks, enabling bidirectional data flow between shop floor operational systems and enterprise IT systems.. Valid values are `true|false`',
    `plant_site_code` STRING COMMENT 'Code identifying the manufacturing plant or facility site where the IIoT platform is deployed, enabling geographic and operational scoping of connected assets.',
    `platform_code` STRING COMMENT 'Short alphanumeric code uniquely identifying the IIoT platform within enterprise systems, used for cross-system referencing and reporting.. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `platform_name` STRING COMMENT 'Official commercial or internal name of the IIoT platform deployment (e.g., Siemens MindSphere Plant A, AWS IoT Core EMEA Hub).',
    `platform_owner` STRING COMMENT 'Name or identifier of the business or IT owner accountable for the IIoT platform, responsible for governance, budget, and strategic direction.',
    `platform_version` STRING COMMENT 'Software version or release number of the deployed IIoT platform, used for patch management, compatibility tracking, and upgrade planning.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?$`',
    `predictive_analytics_enabled` BOOLEAN COMMENT 'Indicates whether the IIoT platform has active predictive analytics capabilities deployed (e.g., predictive maintenance, anomaly detection), supporting OEE improvement and asset reliability programs.. Valid values are `true|false`',
    `primary_protocol` STRING COMMENT 'The dominant or default communication protocol used by the IIoT platform for device-to-platform data transmission, used for integration design and troubleshooting.. Valid values are `MQTT|OPC-UA|AMQP|Modbus|PROFINET|REST-HTTP|KAFKA|SPARKPLUG-B|Other`',
    `region_name` STRING COMMENT 'Geographic or organizational region name (e.g., North America, EMEA, APAC) where the IIoT platform is deployed, used for regional reporting and governance.',
    `security_zone` STRING COMMENT 'Industrial cybersecurity zone classification of the IIoT platform per IEC 62443, indicating whether it resides in the Operational Technology (OT) network, IT network, demilitarized zone (DMZ), or cloud.. Valid values are `OT|IT|DMZ|cloud|hybrid`',
    `status` STRING COMMENT 'Current operational lifecycle status of the IIoT platform, indicating whether it is actively in use, under maintenance, in pilot phase, planned for deployment, or decommissioned.. Valid values are `active|inactive|decommissioned|under_maintenance|pilot|planned`',
    `supported_protocols` STRING COMMENT 'Comma-separated list of industrial and IoT communication protocols supported by the platform (e.g., MQTT, OPC-UA, AMQP, Modbus, PROFINET, REST/HTTP), critical for device compatibility assessment.',
    `technical_contact` STRING COMMENT 'Name or identifier of the primary technical contact or administrator responsible for day-to-day operations, maintenance, and incident response for the IIoT platform.',
    `uptime_sla_percent` DECIMAL(18,2) COMMENT 'Contractually committed platform availability percentage (e.g., 99.9%) defined in the vendor SLA, used for performance monitoring and vendor management.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `vendor_support_tier` STRING COMMENT 'Level of vendor-provided technical support contracted for the IIoT platform (e.g., basic, standard, premium, enterprise 24x7), used for incident escalation and SLA management.. Valid values are `basic|standard|premium|enterprise|24x7`',
    CONSTRAINT pk_iiot_platform PRIMARY KEY(`iiot_platform_id`)
) COMMENT 'Master record for IIoT (Industrial Internet of Things) platforms and edge computing infrastructure deployed across manufacturing plants to enable machine connectivity, real-time data acquisition, and OT/IT data integration. Captures platform name, platform vendor (PTC ThingWorx, Siemens MindSphere, AWS IoT, Azure IoT Hub), deployment model (cloud, edge, hybrid), connected plant locations, number of connected devices, data ingestion rate, protocol support (MQTT, OPC-UA, AMQP), integration targets (historian, MES, ERP), operational status, and data governance classification. Foundation for IIoT-driven manufacturing intelligence.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`it_vendor` (
    `it_vendor_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each IT and technology vendor record in the enterprise vendor master.',
    `annual_spend_budget` DECIMAL(18,2) COMMENT 'Approved annual IT spend budget allocated to this vendor for the current fiscal year, used for IT financial governance, CAPEX/OPEX tracking, and vendor spend management.',
    `contract_end_date` DATE COMMENT 'Expiry date of the current master contract or framework agreement. Used to trigger renewal workflows and prevent lapsed vendor engagements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `contract_reference` STRING COMMENT 'Unique reference number or identifier of the master contract or framework agreement with the IT vendor, as recorded in SAP Ariba or the enterprise contract repository.',
    `contract_start_date` DATE COMMENT 'Effective start date of the current master contract or framework agreement with the IT vendor.. Valid values are `^d{4}-d{2}-d{2}$`',
    `contract_status` STRING COMMENT 'Current status of the master contract or framework agreement with the IT vendor. Used to manage contract renewals, sourcing decisions, and compliance obligations.. Valid values are `active|expired|pending_renewal|terminated|under_negotiation|not_contracted`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code representing the primary billing currency used in transactions with the IT vendor.. Valid values are `^[A-Z]{3}$`',
    `data_processing_agreement_date` DATE COMMENT 'Date on which the Data Processing Agreement (DPA) was formally executed with the IT vendor.. Valid values are `^d{4}-d{2}-d{2}$`',
    `data_processing_agreement_status` STRING COMMENT 'Status of the Data Processing Agreement (DPA) with the IT vendor, required under GDPR and CCPA when the vendor processes personal data on behalf of the enterprise.. Valid values are `not_required|pending|signed|expired|under_review`',
    `duns_number` STRING COMMENT 'Nine-digit Dun & Bradstreet (DUNS) number uniquely identifying the IT vendors business entity globally, used for credit risk assessment and supplier due diligence.. Valid values are `^[0-9]{9}$`',
    `geographic_coverage` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes representing the countries or regions where the IT vendor provides services or support. Used for global sourcing decisions and regional IT service planning.',
    `headquarters_city` STRING COMMENT 'City where the IT vendors corporate headquarters is located, used for geographic risk profiling and logistics coordination.',
    `headquarters_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the IT vendors corporate headquarters is registered. Used for geopolitical risk assessment and regulatory jurisdiction determination.. Valid values are `^[A-Z]{3}$`',
    `is_ot_vendor` BOOLEAN COMMENT 'Indicates whether the vendor supplies Operational Technology (OT) products or services such as PLCs, SCADA systems, DCS, HMIs, or IIoT platforms, relevant for IT/OT convergence governance and IEC 62443 compliance.. Valid values are `true|false`',
    `is_preferred_vendor` BOOLEAN COMMENT 'Indicates whether the vendor has been designated as a preferred IT supplier, qualifying them for priority engagement and streamlined procurement processes.. Valid values are `true|false`',
    `is_strategic_partner` BOOLEAN COMMENT 'Indicates whether the vendor holds a formal strategic partnership designation, typically associated with executive-level engagement, joint roadmaps, and preferred commercial terms.. Valid values are `true|false`',
    `last_review_date` DATE COMMENT 'Date of the most recent formal vendor performance or relationship review, used to track review cadence and ensure compliance with vendor management policies.. Valid values are `^d{4}-d{2}-d{2}$`',
    `name` STRING COMMENT 'Official registered legal name of the IT vendor or technology partner as recorded in the enterprise vendor master.',
    `nda_status` STRING COMMENT 'Status of the Non-Disclosure Agreement (NDA) executed with the IT vendor, ensuring protection of proprietary manufacturing technology, trade secrets, and confidential business information.. Valid values are `not_required|pending|signed|expired`',
    `onboarding_date` DATE COMMENT 'Date on which the IT vendor was formally onboarded into the enterprise vendor master and approved for engagement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `parent_vendor_name` STRING COMMENT 'Name of the parent company or ultimate holding entity of the IT vendor, used for consolidated spend reporting and group-level risk assessment.',
    `payment_terms` STRING COMMENT 'Standard payment terms agreed with the IT vendor, used for accounts payable scheduling and cash flow management in SAP S/4HANA FI module.. Valid values are `net_15|net_30|net_45|net_60|net_90|immediate|custom`',
    `primary_contact_email` STRING COMMENT 'Email address of the primary business contact at the IT vendor, used for official communications, contract notifications, and service escalations.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_contact_name` STRING COMMENT 'Full name of the primary business contact at the IT vendor organization, used for day-to-day relationship management and escalation.',
    `primary_contact_phone` STRING COMMENT 'Direct phone number of the primary business contact at the IT vendor for urgent communications and escalation management.. Valid values are `^+?[0-9s-().]{7,20}$`',
    `security_assessment_date` DATE COMMENT 'Date on which the most recent cybersecurity risk assessment was completed for the IT vendor.. Valid values are `^d{4}-d{2}-d{2}$`',
    `security_assessment_expiry_date` DATE COMMENT 'Date on which the current cybersecurity risk assessment expires, triggering reassessment workflows to maintain continuous third-party security compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `security_assessment_status` STRING COMMENT 'Current status of the cybersecurity risk assessment conducted for the IT vendor, aligned with IEC 62443 and NIST Cybersecurity Framework requirements for third-party risk management.. Valid values are `not_assessed|in_progress|passed|failed|conditionally_approved|expired`',
    `sla_tier` STRING COMMENT 'Service Level Agreement (SLA) tier classification agreed with the IT vendor, defining response time commitments, uptime guarantees, and support escalation paths.. Valid values are `platinum|gold|silver|bronze|standard`',
    `source_system` STRING COMMENT 'Operational system of record from which the IT vendor master record was originated or last synchronized, supporting data lineage and integration traceability.. Valid values are `sap_ariba|salesforce|manual|sap_s4hana|other`',
    `spend_category` STRING COMMENT 'IT procurement spend category assigned to the vendor, used for IT budget allocation, CAPEX/OPEX classification, and sourcing strategy alignment.. Valid values are `infrastructure|software_licenses|cloud_services|professional_services|managed_services|telecom|security|ot_technology|end_user_computing|data_analytics`',
    `status` STRING COMMENT 'Current lifecycle status of the IT vendor relationship. Drives vendor eligibility for new engagements, purchase order creation, and contract renewals.. Valid values are `active|inactive|pending_approval|suspended|blacklisted|under_review`',
    `support_coverage_hours` STRING COMMENT 'Support coverage hours provided by the IT vendor under the current service agreement, indicating availability for incident response and technical assistance.. Valid values are `8x5|12x5|16x5|24x7|business_hours_only|custom`',
    `tax_identification_number` STRING COMMENT 'Government-issued Tax Identification Number (TIN) or VAT registration number of the IT vendor, required for financial compliance, invoice validation, and tax reporting.',
    `trading_name` STRING COMMENT 'Commercial or brand name under which the IT vendor operates, if different from the registered legal name.',
    `vendor_code` STRING COMMENT 'Business-assigned alphanumeric code uniquely identifying the IT vendor, used for cross-system referencing and integration with SAP Ariba and SAP S/4HANA procurement modules.. Valid values are `^ITV-[A-Z0-9]{4,12}$`',
    `vendor_risk_rating` STRING COMMENT 'Overall risk rating assigned to the IT vendor based on cybersecurity posture, financial stability, geographic risk, and operational dependency. Used for third-party risk management and IT governance.. Valid values are `critical|high|medium|low`',
    `vendor_tier` STRING COMMENT 'Strategic tier classification of the vendor based on spend volume, criticality, and relationship depth. Tier 1 vendors are strategic partners; Tier 2 are preferred; Tier 3 are transactional.. Valid values are `tier_1|tier_2|tier_3`',
    `vendor_type` STRING COMMENT 'Classification of the vendor by the nature of IT products or services supplied. Includes hardware OEMs, software vendors, Managed Service Providers (MSPs), System Integrators (SIs), cloud providers, and OT/ICS vendors supporting IT/OT convergence.. Valid values are `hardware_oem|software_vendor|managed_service_provider|system_integrator|cloud_provider|ot_vendor|telecom_provider|consulting_firm|staffing_agency|value_added_reseller`',
    `website_url` STRING COMMENT 'Official website URL of the IT vendor, used for vendor due diligence, product research, and self-service portal access.. Valid values are `^https?://[^s/$.?#].[^s]*$`',
    CONSTRAINT pk_it_vendor PRIMARY KEY(`it_vendor_id`)
) COMMENT 'Master record for all IT and technology vendors, system integrators, managed service providers (MSPs), and technology partners engaged by the manufacturing enterprise. Captures vendor name, vendor type (hardware OEM, software vendor, MSP, SI, cloud provider, OT vendor), primary contact, contract status, preferred vendor flag, vendor tier classification, spend category, security assessment status, data processing agreement status, and geographic coverage. Distinct from the procurement supplier master — this is the IT-domain SSOT for technology vendor relationships supporting vendor management and IT sourcing decisions.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`it_contract` (
    `it_contract_id` BIGINT COMMENT 'Unique surrogate identifier for each IT and technology contract record in the enterprise data platform. Serves as the primary key for the it_contract entity.',
    `channel_partner_id` BIGINT COMMENT 'Foreign key linking to sales.channel_partner. Business justification: Technology service contracts for maintenance, support, and managed services are often delivered through channel partners (system integrators, VARs). Procurement tracks which partner holds the contract',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: IT contracts specify the GL account for expense recognition (software subscriptions, maintenance) ensuring proper financial classification and automated invoice posting.',
    `it_vendor_id` BIGINT COMMENT 'Foreign key linking to technology.it_vendor. Business justification: IT contracts are agreements with vendors. Normalize vendor_name STRING to FK relationship with it_vendor master.',
    `annual_value` DECIMAL(18,2) COMMENT 'Annualized value of the IT contract, representing the recurring yearly spend commitment. Used for annual IT budget planning, OPEX tracking, and year-over-year spend trend analysis.',
    `auto_renewal_flag` BOOLEAN COMMENT 'Indicates whether the IT contract automatically renews at the end of the current term unless notice of cancellation is provided within the notice period. True = auto-renews; False = requires affirmative renewal action.. Valid values are `true|false`',
    `availability_target_pct` DECIMAL(18,2) COMMENT 'The contractually committed service availability percentage (uptime) for the technology service or product covered by this contract (e.g., 99.9 for 3 nines availability). Used for SLA compliance monitoring and vendor performance management.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `business_owner` STRING COMMENT 'Full name of the business-side stakeholder who sponsors and benefits from the technology service covered by this contract. Accountable for business justification, budget approval, and value realization.',
    `capex_opex_classification` STRING COMMENT 'Financial classification of the IT contract spend as Capital Expenditure (CAPEX), Operational Expenditure (OPEX), or a mixed split. Drives accounting treatment, depreciation schedules, and financial reporting under IFRS/GAAP.. Valid values are `capex|opex|mixed`',
    `contract_category` STRING COMMENT 'High-level technology spend category for the contract, aligned to the enterprise IT taxonomy. Used for IT spend governance, budget allocation, and portfolio reporting across the manufacturing enterprise.. Valid values are `it_infrastructure|application_software|cloud_and_saas|ot_and_iiot|cybersecurity|end_user_computing|telecommunications|professional_services|data_and_analytics`',
    `contract_document_ref` STRING COMMENT 'Reference identifier or URL to the executed contract document stored in the enterprise document management system (e.g., Siemens Teamcenter or SharePoint). Enables direct access to the full contract text for legal and compliance review.',
    `contract_number` STRING COMMENT 'Business-facing unique contract reference number assigned at contract creation, used for cross-system referencing in SAP S/4HANA, SAP Ariba, and vendor correspondence. Follows enterprise contract numbering convention.. Valid values are `^ITC-[A-Z0-9]{4,20}$`',
    `contract_owner` STRING COMMENT 'Full name of the internal IT employee or manager responsible for managing the contract lifecycle, including renewals, vendor performance reviews, and compliance. The accountable business contact for this contract.',
    `contract_owner_email` STRING COMMENT 'Corporate email address of the IT contract owner. Used for automated renewal alerts, approval workflow notifications, and escalation communications in the contract management system.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `contract_type` STRING COMMENT 'Classification of the IT contract by the nature of the technology service or product being contracted. Drives contract lifecycle rules, renewal workflows, and spend categorization in IT governance reporting.. Valid values are `software_maintenance|hardware_support|managed_service|cloud_service_agreement|saas_subscription|ot_vendor_support|professional_services|network_infrastructure|cybersecurity_service|license_agreement|outsourcing`',
    `contract_value` DECIMAL(18,2) COMMENT 'Total committed financial value of the IT contract over its full term, expressed in the contract currency. Used for IT spend governance, CAPEX/OPEX classification, and budget planning. Excludes optional renewal periods unless exercised.',
    `cost_center` STRING COMMENT 'SAP S/4HANA CO cost center code to which the IT contract spend is allocated for internal financial reporting and budget control. Enables IT spend attribution to specific organizational units.',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the contract value and payment amounts (e.g., USD, EUR, GBP). Supports multi-currency IT spend consolidation across the multinational manufacturing enterprise.. Valid values are `^[A-Z]{3}$`',
    `cybersecurity_review_status` STRING COMMENT 'Status of the cybersecurity risk assessment conducted for the vendor and technology covered by this contract. Required for all IT and OT contracts under the enterprise cybersecurity governance framework aligned to NIST CSF and IEC 62443.. Valid values are `not_required|pending|in_progress|approved|conditionally_approved|rejected`',
    `data_processing_agreement_flag` BOOLEAN COMMENT 'Indicates whether a Data Processing Agreement (DPA) has been executed with the vendor as required under GDPR Article 28 for contracts involving processing of personal data. Critical for GDPR and CCPA compliance governance.. Valid values are `true|false`',
    `end_date` DATE COMMENT 'The scheduled expiration date of the IT contract. Triggers renewal planning workflows and vendor offboarding processes. Critical for IT spend governance and avoiding unplanned service disruptions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `governing_law_country` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the jurisdiction whose laws govern the IT contract (e.g., USA, DEU, GBR). Determines applicable legal framework for dispute resolution and regulatory compliance obligations.. Valid values are `^[A-Z]{3}$`',
    `is_cloud_contract` BOOLEAN COMMENT 'Indicates whether this contract is for a cloud-based service (IaaS, PaaS, SaaS, or CSA). True = cloud contract subject to cloud governance policies, data residency requirements, and GDPR/CCPA data processing agreements.. Valid values are `true|false`',
    `is_ot_contract` BOOLEAN COMMENT 'Indicates whether this IT contract covers Operational Technology (OT) systems such as SCADA, PLC, DCS, MES, or IIoT platforms. True = OT-related contract requiring OT security review under IEC 62443; False = standard IT contract.. Valid values are `true|false`',
    `notice_period_days` STRING COMMENT 'Number of calendar days prior to the contract end date by which written notice of non-renewal or termination must be provided to the vendor. Critical for renewal planning to avoid unintended auto-renewals or service gaps.. Valid values are `^[0-9]+$`',
    `owning_department` STRING COMMENT 'Name of the internal department or business unit that owns and is primarily responsible for the IT contract (e.g., IT Infrastructure, OT Engineering, Digital Transformation). Used for spend allocation and governance reporting.',
    `payment_schedule` STRING COMMENT 'Frequency or basis on which payments are made to the vendor under the IT contract. Drives accounts payable scheduling, cash flow planning, and IT budget phasing in SAP S/4HANA FI/CO.. Valid values are `monthly|quarterly|semi_annual|annual|upfront|milestone_based|usage_based`',
    `payment_terms` STRING COMMENT 'Standard payment terms agreed with the vendor specifying the number of days from invoice date by which payment is due. Aligned with SAP S/4HANA payment term configuration and accounts payable processes.. Valid values are `net_30|net_45|net_60|net_90|due_on_receipt|prepaid`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the IT contract record was first created in the enterprise data platform. Used for data lineage tracking, audit trail compliance, and Silver layer ingestion monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the IT contract record in the enterprise data platform. Used for change detection, incremental data processing, and audit trail compliance in the Databricks Lakehouse Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `region` STRING COMMENT 'Geographic region covered by or associated with the IT contract (e.g., North America, Europe, Asia Pacific). Used for regional IT spend reporting, data residency compliance, and regional IT governance oversight.',
    `renewal_status` STRING COMMENT 'Current status of the contract renewal process. Tracks the renewal lifecycle from initial review through approval or termination decision. Used in IT contract governance dashboards and renewal planning reports.. Valid values are `not_due|under_review|renewal_approved|renewal_declined|renewed|terminated|pending_negotiation`',
    `renewal_term_months` STRING COMMENT 'Duration in months of each auto-renewal or optional renewal period as specified in the contract terms. Used to project future contract end dates and associated spend commitments upon renewal.. Valid values are `^[0-9]+$`',
    `signed_date` DATE COMMENT 'Date on which the IT contract was formally executed and signed by authorized representatives of both parties. Establishes the legal binding date, which may differ from the contract start date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `sla_terms_summary` STRING COMMENT 'Free-text summary of the key SLA commitments in the contract, including availability targets, response times, resolution times, and penalty clauses. Provides a human-readable reference for IT service managers without requiring access to the full contract document.',
    `sla_tier` STRING COMMENT 'The contracted SLA tier defining the overall service quality level committed by the vendor. Maps to specific availability, response time, and resolution time targets defined in the SLA terms summary.. Valid values are `platinum|gold|silver|bronze|standard|custom`',
    `start_date` DATE COMMENT 'The effective commencement date of the IT contract, from which contractual obligations, SLA terms, and payment schedules become active. Used for contract duration calculations and renewal planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `status` STRING COMMENT 'Current lifecycle status of the IT contract. Drives renewal planning workflows, spend authorization controls, and contract governance dashboards. Active contracts authorize IT spend; expired or terminated contracts trigger vendor offboarding.. Valid values are `draft|under_review|pending_approval|active|expired|terminated|suspended|renewed|cancelled`',
    `termination_date` DATE COMMENT 'Actual date on which the IT contract was terminated early, if applicable. Populated only for contracts terminated before the scheduled end date. Used for vendor offboarding, spend reconciliation, and contract dispute tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `termination_reason` STRING COMMENT 'Reason code for early termination of the IT contract. Used for vendor performance analysis, contract risk reporting, and lessons-learned reviews in IT governance processes.. Valid values are `vendor_default|mutual_agreement|cost_reduction|technology_replacement|merger_acquisition|regulatory_non_compliance|service_failure|business_closure|other`',
    `title` STRING COMMENT 'Descriptive short title of the IT contract, summarizing the scope of the agreement (e.g., SAP S/4HANA Annual Maintenance Agreement, Azure Cloud Services CSA FY2025).',
    `vendor_contract_reference` STRING COMMENT 'The vendors own contract or agreement reference number as provided by the technology supplier. Enables cross-referencing with vendor portals, invoices, and support tickets during dispute resolution.',
    CONSTRAINT pk_it_contract PRIMARY KEY(`it_contract_id`)
) COMMENT 'Master record for all IT and technology contracts including software maintenance agreements, hardware support contracts, managed service agreements, cloud service agreements (CSAs), SaaS subscription contracts, and OT vendor support contracts. Captures contract number, contract type, vendor reference, contract value, currency, start date, end date, auto-renewal flag, notice period, SLA terms summary, payment schedule, contract owner, and renewal status. Distinct from procurement contracts — this is the IT-domain SSOT for technology contract lifecycle management supporting IT spend governance and renewal planning.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`it_budget` (
    `it_budget_id` BIGINT COMMENT 'Unique system-generated identifier for each IT budget record within the enterprise technology financial management system.',
    `actual_spend_amount` DECIMAL(18,2) COMMENT 'Cumulative actual expenditure posted against this IT budget record to date, sourced from SAP FI/CO actuals. Used to calculate budget variance and track financial performance.',
    `approval_date` DATE COMMENT 'The date on which this IT budget was formally approved by the authorized budget governance body (e.g., IT Steering Committee, CFO). Establishes the baseline for budget tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approval_status` STRING COMMENT 'The approval workflow status of this IT budget record, indicating whether it has been approved, is pending review, rejected, or conditionally approved by the budget authority.. Valid values are `pending|approved|rejected|conditionally_approved|escalated`',
    `approved_budget_amount` DECIMAL(18,2) COMMENT 'The formally approved budget amount for this IT budget record as authorized by the budget governance process. Represents the baseline against which forecast and actuals are measured.',
    `approver_name` STRING COMMENT 'Name of the individual who formally approved this IT budget (e.g., CIO, CFO, IT Finance Director). Provides audit trail for budget governance and financial controls.',
    `budget_category` STRING COMMENT 'Detailed spend category within the IT budget, providing granular classification for cost analysis and benchmarking (e.g., hardware, software licenses, cloud services, managed services, professional services).. Valid values are `hardware|software_licenses|cloud_services|managed_services|professional_services|support_contracts|internal_labor|training|telecom|facilities|other`',
    `budget_code` STRING COMMENT 'Human-readable unique business identifier for the IT budget record, used for cross-system referencing and financial reporting (e.g., IT-BDG-2025-INFRA-001).. Valid values are `^IT-BDG-[A-Z0-9]{4,20}$`',
    `budget_owner` STRING COMMENT 'Name or employee identifier of the IT leader or manager accountable for this budget record. Typically the IT domain head, cost center manager, or program director responsible for financial performance.',
    `budget_period_end_date` DATE COMMENT 'The end date of the budget period covered by this record. Enables multi-year program budgets and rolling forecast periods to be accurately represented.. Valid values are `^d{4}-d{2}-d{2}$`',
    `budget_period_start_date` DATE COMMENT 'The start date of the budget period covered by this record. Supports multi-year and partial-year budget planning cycles beyond the standard annual fiscal year.. Valid values are `^d{4}-d{2}-d{2}$`',
    `budget_type` STRING COMMENT 'Classifies the budget record as Capital Expenditure (CAPEX) for infrastructure investments, hardware refresh, and major implementations, or Operational Expenditure (OPEX) for software licenses, managed services, cloud consumption, and support contracts.. Valid values are `CAPEX|OPEX`',
    `budget_version` STRING COMMENT 'Version of the budget record indicating whether this is the original approved budget or a subsequent revision (e.g., revised_1 after mid-year reforecast). Supports budget lifecycle tracking.. Valid values are `original|revised_1|revised_2|revised_3|final`',
    `budget_year` STRING COMMENT 'The fiscal year to which this IT budget record applies. Supports annual and multi-year planning cycles aligned to the enterprise fiscal calendar.. Valid values are `^(20[2-9][0-9]|2[1-9][0-9]{2})$`',
    `committed_amount` DECIMAL(18,2) COMMENT 'Amount committed through purchase orders (POs) or contracts that have been raised but not yet invoiced or posted as actuals. Represents financial obligations already incurred against the budget.',
    `contingency_amount` DECIMAL(18,2) COMMENT 'The contingency reserve amount included within or alongside the approved budget to cover unforeseen risks and scope changes. Expressed in the same currency as the approved budget amount.',
    `contract_reference` STRING COMMENT 'Reference number of the contract or master service agreement (MSA) associated with this IT budget line. Links budget records to contractual obligations for spend governance.',
    `cost_center_code` STRING COMMENT 'SAP cost center code to which this IT budget is assigned. Enables financial accountability and cost allocation reporting across the enterprise organizational hierarchy.. Valid values are `^[A-Z0-9]{4,20}$`',
    `cost_center_name` STRING COMMENT 'Descriptive name of the SAP cost center associated with this IT budget record, providing human-readable context for financial reporting and governance.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code indicating the country where this IT budget is applicable. Supports multi-country financial reporting and regional IT spend analysis.. Valid values are `^[A-Z]{3}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all monetary amounts in this budget record (e.g., USD, EUR, GBP). Supports multi-currency financial reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `forecast_amount` DECIMAL(18,2) COMMENT 'The latest forecast of expected total spend for this IT budget record for the budget year, updated periodically (monthly or quarterly) to reflect current projections based on committed and anticipated expenditures.',
    `gl_account_code` STRING COMMENT 'SAP General Ledger (GL) account code associated with this IT budget line, enabling integration with financial accounting and ensuring proper P&L or balance sheet classification.. Valid values are `^[0-9]{6,10}$`',
    `is_contingency_included` BOOLEAN COMMENT 'Indicates whether the approved budget amount includes a contingency reserve (True) or represents a base budget without contingency (False). Important for risk-adjusted budget analysis.. Valid values are `true|false`',
    `is_multi_year` BOOLEAN COMMENT 'Indicates whether this IT budget record spans multiple fiscal years (True) or is confined to a single fiscal year (False). Relevant for large CAPEX programs such as ERP implementations or infrastructure overhauls.. Valid values are `true|false`',
    `it_domain` STRING COMMENT 'The technology domain or functional area to which this budget is allocated. Enables IT spend analysis by domain such as infrastructure, applications, OT/IT convergence, cybersecurity, and digital transformation programs.. Valid values are `infrastructure|applications|ot_it_convergence|cybersecurity|digital_transformation|end_user_computing|data_analytics|cloud|telecommunications|other`',
    `last_forecast_date` DATE COMMENT 'The date on which the forecast amount was last updated. Indicates the currency of the forecast data and supports reforecast cycle tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `legal_entity` STRING COMMENT 'The legal entity or company code within the multinational enterprise to which this IT budget belongs. Supports intercompany cost allocation and statutory financial reporting across jurisdictions.',
    `notes` STRING COMMENT 'Free-text field for additional context, justification, assumptions, or commentary related to this IT budget record. Used by budget owners and finance teams to document rationale for budget decisions.',
    `po_number` STRING COMMENT 'SAP Purchase Order (PO) number associated with committed spend against this IT budget. Enables reconciliation between budget commitments and procurement transactions.',
    `program_name` STRING COMMENT 'Name of the IT program or portfolio to which this budget record belongs. Enables program-level budget aggregation and portfolio investment analysis across multiple projects.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when this IT budget record was first created in the system. Supports audit trail, data lineage, and financial governance requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when this IT budget record was last modified. Enables change tracking, reforecast cycle monitoring, and data freshness assessment for financial reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `region` STRING COMMENT 'Geographic region associated with this IT budget record. Enables regional IT spend aggregation and benchmarking across the multinational enterprise.. Valid values are `north_america|europe|asia_pacific|latin_america|middle_east_africa|global`',
    `status` STRING COMMENT 'Current lifecycle status of the IT budget record, from initial draft through approval, active execution, and closure. Drives workflow routing and financial reporting inclusion.. Valid values are `draft|submitted|under_review|approved|active|on_hold|closed|cancelled`',
    `strategic_initiative` STRING COMMENT 'Name or code of the strategic technology initiative or digital transformation program this budget supports (e.g., IIoT Platform Rollout, ERP S/4HANA Migration, OT/IT Convergence Program). Links IT spend to business strategy.',
    `variance_amount` DECIMAL(18,2) COMMENT 'The difference between the approved budget amount and the actual spend amount (approved_budget_amount minus actual_spend_amount). A positive value indicates underspend; negative indicates overspend. Stored as a raw financial figure for governance reporting.',
    `vendor_name` STRING COMMENT 'Name of the primary external vendor or service provider associated with this IT budget line (e.g., Microsoft, SAP, Siemens, AWS). Applicable for OPEX software, cloud, and managed service budgets.',
    `wbs_element` STRING COMMENT 'SAP Work Breakdown Structure (WBS) element code linking this budget to a specific project or program within the enterprise project system. Applicable for CAPEX project-based budgets.',
    CONSTRAINT pk_it_budget PRIMARY KEY(`it_budget_id`)
) COMMENT 'Annual and multi-year IT budget records for the technology function covering CAPEX (infrastructure investments, hardware refresh, major implementations) and OPEX (software licenses, managed services, cloud consumption, support contracts) across all IT cost centers and digital transformation programs. Captures budget year, budget type (CAPEX/OPEX), IT domain (infrastructure, applications, OT/IT, cybersecurity, digital), cost center, approved budget amount, currency, forecast amount, actual spend to date, variance, and budget owner. Supports IT financial management and technology investment governance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`sla_definition` (
    `sla_definition_id` BIGINT COMMENT 'Unique system-generated identifier for each SLA definition record in the IT/OT service catalog.',
    `it_service_id` BIGINT COMMENT 'FK to technology.it_service',
    `applicable_business_units` STRING COMMENT 'Comma-separated list or description of manufacturing business units or departments to which this SLA definition applies (e.g., Production, Quality, Supply Chain).',
    `applicable_regions` STRING COMMENT 'Comma-separated ISO 3166-1 alpha-3 country codes or region identifiers indicating the geographic scope of this SLA definition for multinational operations.',
    `approved_by` STRING COMMENT 'Name or identifier of the individual who formally approved this SLA definition, ensuring accountability in the SLA governance process.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when this SLA definition was formally approved and authorized for use.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `breach_threshold` DECIMAL(18,2) COMMENT 'The numeric value at which the SLA is considered breached. For availability, this is the minimum acceptable uptime percentage; for time-based metrics, the maximum allowable duration before breach is declared.',
    `description` STRING COMMENT 'Detailed narrative describing the purpose, scope, and applicability of this SLA definition, including the business context and service commitment.',
    `effective_date` DATE COMMENT 'The date from which this SLA definition becomes active and enforceable for the associated service.. Valid values are `^d{4}-d{2}-d{2}$`',
    `escalation_level_1_minutes` STRING COMMENT 'Number of minutes after SLA warning threshold is reached before the first-level escalation is triggered (e.g., notify service owner).',
    `escalation_level_2_minutes` STRING COMMENT 'Number of minutes after the first escalation before the second-level escalation is triggered (e.g., notify IT management or business unit director).',
    `escalation_level_3_minutes` STRING COMMENT 'Number of minutes after the second escalation before the third-level escalation is triggered (e.g., notify CIO or executive leadership for critical P1 breaches).',
    `exclusion_windows` STRING COMMENT 'Description of scheduled maintenance windows, planned downtime periods, or other time exclusions that are not counted against SLA performance (e.g., Sundays 02:00-06:00 UTC for planned maintenance).',
    `expiry_date` DATE COMMENT 'The date on which this SLA definition expires and must be reviewed or renewed. Null if the SLA is open-ended.. Valid values are `^d{4}-d{2}-d{2}$`',
    `is_critical_sla` BOOLEAN COMMENT 'Indicates whether this SLA definition is classified as critical, typically associated with production-impacting or safety-critical services (e.g., MES, SCADA, PLC systems) requiring heightened monitoring.. Valid values are `true|false`',
    `is_ot_sla` BOOLEAN COMMENT 'Indicates whether this SLA definition governs an Operational Technology (OT) service (e.g., SCADA, PLC, MES, IIoT) as opposed to a standard IT service. OT SLAs typically have stricter availability and response requirements.. Valid values are `true|false`',
    `last_review_date` DATE COMMENT 'The date on which this SLA definition was most recently formally reviewed and approved.. Valid values are `^d{4}-d{2}-d{2}$`',
    `measurement_unit` STRING COMMENT 'Unit of measure for the SLA target value (e.g., percent for availability, minutes for response/resolution time, hours for MTBF/MTTR).. Valid values are `percent|minutes|hours|seconds|days|count|requests_per_second`',
    `measurement_window` STRING COMMENT 'The time window over which SLA performance is measured and evaluated (e.g., monthly for availability SLAs, rolling 30 days for MTTR SLAs).. Valid values are `hourly|daily|weekly|monthly|quarterly|annually|rolling_7_days|rolling_30_days|rolling_90_days`',
    `metric_type` STRING COMMENT 'The type of performance metric this SLA definition governs. Includes availability (uptime %), response time (time to acknowledge), resolution time (time to fix), Mean Time To Repair (MTTR), Mean Time Between Failures (MTBF), throughput, error rate, Recovery Time Objective (RTO), and Recovery Point Objective (RPO).. Valid values are `availability|response_time|resolution_time|mttr|mtbf|throughput|error_rate|recovery_time_objective|recovery_point_objective`',
    `name` STRING COMMENT 'Descriptive business name of the SLA definition (e.g., SAP S/4HANA P1 Availability SLA, MES Incident Resolution P2 SLA).',
    `next_review_date` DATE COMMENT 'The scheduled date for the next formal review of this SLA definition to ensure continued alignment with business needs.. Valid values are `^d{4}-d{2}-d{2}$`',
    `penalty_clause` STRING COMMENT 'Description of financial or contractual penalties applicable when this SLA is breached, including service credits, rebates, or remediation obligations.',
    `priority_tier` STRING COMMENT 'The incident or service request priority tier(s) to which this SLA definition applies (P1=Critical, P2=High, P3=Medium, P4=Low, or all for tier-agnostic SLAs).. Valid values are `P1|P2|P3|P4|all`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this SLA definition record was first created in the data platform, supporting audit trail and data lineage.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this SLA definition record was most recently updated in the data platform, supporting change tracking and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `regulatory_compliance_scope` STRING COMMENT 'Identifies regulatory or compliance frameworks that mandate or influence this SLA definition (e.g., ISO 9001 quality management, IEC 62443 OT cybersecurity, ISO 45001 safety, GDPR data availability).',
    `reporting_frequency` STRING COMMENT 'How frequently SLA performance against this definition is reported to stakeholders and business unit owners.. Valid values are `real_time|daily|weekly|monthly|quarterly`',
    `review_frequency` STRING COMMENT 'How frequently this SLA definition is formally reviewed and validated against actual service performance and business requirements.. Valid values are `monthly|quarterly|semi_annually|annually|ad_hoc`',
    `service_category` STRING COMMENT 'Broad category of the IT or OT service governed by this SLA, enabling segmented reporting and benchmarking across IT/OT convergence domains.. Valid values are `itsm|ot_service|infrastructure|application|network|security|end_user_computing|data_platform|cloud|integration`',
    `sla_code` STRING COMMENT 'Human-readable business code uniquely identifying the SLA definition, used for cross-system referencing and reporting (e.g., SLA-AVAIL-P1-SAP).. Valid values are `^SLA-[A-Z0-9]{3,20}$`',
    `sla_owner` STRING COMMENT 'Name or identifier of the IT service manager or business owner responsible for maintaining and governing this SLA definition.',
    `source_system` STRING COMMENT 'The operational system of record from which this SLA definition originates or is managed (e.g., SAP S/4HANA ITSM, ServiceNow, Maximo EAM).',
    `status` STRING COMMENT 'Current lifecycle status of the SLA definition. Draft indicates under development; active indicates in use; under_review indicates being reassessed; deprecated indicates superseded; retired indicates no longer applicable.. Valid values are `draft|active|under_review|deprecated|retired`',
    `support_hours_type` STRING COMMENT 'Defines the support coverage window applicable to this SLA (e.g., 24x7 for critical OT/production systems, business hours for back-office applications).. Valid values are `24x7|business_hours|extended_hours|follow_the_sun|custom`',
    `target_value` DECIMAL(18,2) COMMENT 'The numeric performance target that must be met for this SLA (e.g., 99.9 for 99.9% availability, 15 for 15-minute response time, 240 for 240-minute MTTR). Interpreted in conjunction with measurement_unit.',
    `version` STRING COMMENT 'Version number of the SLA definition, supporting change history and audit trail for SLA governance (e.g., 1.0, 2.1, 3.0).. Valid values are `^d+.d+(.d+)?$`',
    `warning_threshold` DECIMAL(18,2) COMMENT 'The numeric value at which a warning alert is triggered, indicating the SLA is at risk of breach before the breach threshold is reached. Enables proactive escalation.',
    CONSTRAINT pk_sla_definition PRIMARY KEY(`sla_definition_id`)
) COMMENT 'Reference master defining IT and OT service level agreement (SLA) definitions and performance thresholds for all services in the IT service catalog. Captures SLA name, service reference, SLA metric type (availability, response time, resolution time, MTTR, MTBF), target value, measurement unit, measurement window, breach threshold, priority tier applicability (P1–P4), escalation rules, and reporting frequency. Distinct from customer.sla_agreement (which governs customer-facing SLAs) — this governs internal IT service delivery commitments to manufacturing business units.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`sla_performance` (
    `sla_performance_id` BIGINT COMMENT 'Unique system-generated identifier for each SLA performance measurement record. Serves as the primary key for the sla_performance data product.',
    `it_service_id` BIGINT COMMENT 'Foreign key linking to technology.it_service. Business justification: SLA performance is measured per IT service. Normalize service_code and service_name to FK relationship with it_service master.',
    `sla_definition_id` BIGINT COMMENT 'Foreign key linking to technology.sla_definition. Business justification: SLA performance measurements are tracked against SLA definitions. Normalize sla_definition_name STRING to FK relationship with sla_definition master.',
    `actual_value` DECIMAL(18,2) COMMENT 'The measured actual performance value achieved for the SLA metric during the measurement period. Compared against target_value to determine compliance status.',
    `affected_ticket_count` STRING COMMENT 'Number of ITSM incident, service request, or problem tickets that were impacted by SLA breaches or at-risk conditions during the measurement period. Supports impact quantification for CSI reporting.. Valid values are `^[0-9]+$`',
    `affected_ticket_references` STRING COMMENT 'Comma-separated list or reference string of ITSM ticket numbers (incidents, service requests, or problems) that were affected by SLA breaches during the measurement period. Enables drill-down from SLA reports to individual tickets.',
    `breach_count` STRING COMMENT 'Number of individual SLA breach events recorded within the measurement period. A breach count greater than zero triggers escalation and root cause analysis workflows.. Valid values are `^[0-9]+$`',
    `breach_duration_minutes` DECIMAL(18,2) COMMENT 'Total cumulative duration in minutes of all SLA breach events within the measurement period. Used to quantify the severity and business impact of SLA non-compliance.',
    `compliance_status` STRING COMMENT 'Current compliance status of the SLA for the measurement period. Met indicates the target was achieved; Breached indicates failure to meet the target; At Risk indicates performance is trending toward a breach but has not yet occurred.. Valid values are `met|breached|at_risk|not_applicable|pending_measurement`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the service is delivered or consumed. Supports multi-country SLA performance reporting and regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `escalation_status` STRING COMMENT 'Current escalation status for this SLA performance record. Tracks whether a breach or at-risk condition has been escalated to management and at what level, supporting governance and accountability reporting.. Valid values are `not_escalated|escalated_to_manager|escalated_to_director|escalated_to_executive|resolved`',
    `escalation_timestamp` TIMESTAMP COMMENT 'Date and time when the SLA breach or at-risk condition was formally escalated to management. Null if no escalation has occurred. Used for SLA governance and response time tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `improvement_action_reference` STRING COMMENT 'Reference identifier linking this SLA performance record to a Continual Service Improvement (CSI) action, CAPA record, or improvement initiative raised in response to a breach or at-risk condition.',
    `is_ot_service` BOOLEAN COMMENT 'Indicates whether the service being measured is an Operational Technology (OT) service (e.g., SCADA, MES, PLC network) as opposed to a standard IT service. OT services may have different compliance thresholds and escalation paths.. Valid values are `true|false`',
    `measurement_number` STRING COMMENT 'Human-readable business reference number for the SLA performance measurement record, used in reports, dashboards, and communications with service owners.. Valid values are `^SLAP-[0-9]{4}-[0-9]{6}$`',
    `measurement_period_type` STRING COMMENT 'Granularity of the measurement period for this SLA performance record. Determines the reporting cadence and aggregation level used when evaluating compliance.. Valid values are `daily|weekly|monthly|quarterly|annual|custom`',
    `measurement_source` STRING COMMENT 'System or method used to collect the actual SLA performance data for this record. Indicates data provenance and reliability. Examples include ITSM tools, network monitoring platforms, or IIoT platforms such as Siemens MindSphere.. Valid values are `itsm_tool|monitoring_platform|manual_entry|iiot_platform|network_management_system|apm_tool`',
    `metric_unit` STRING COMMENT 'Unit of measure applicable to both the target_value and actual_value fields. Ensures correct interpretation of numeric performance values across different SLA metric types.. Valid values are `percent|minutes|hours|seconds|count|requests_per_second|score`',
    `notes` STRING COMMENT 'Free-text field for additional context, commentary, or exceptions related to the SLA performance measurement. May include explanations for anomalies, exclusions applied, or service review discussion points.',
    `owning_department` STRING COMMENT 'Name of the IT or business department responsible for delivering and maintaining the service. Used for organizational accountability reporting and cost allocation in SLA performance reviews.',
    `period_end_date` DATE COMMENT 'End date of the measurement period for which SLA performance is being evaluated. Combined with period_start_date, defines the exact window of measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `period_start_date` DATE COMMENT 'Start date of the measurement period for which SLA performance is being evaluated. Combined with period_end_date, defines the exact window of measurement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the SLA performance record was first created in the system. Used for data lineage, audit trail, and Silver layer ingestion tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when the SLA performance record was last modified. Supports change tracking, data freshness monitoring, and incremental processing in the Databricks Lakehouse Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `region` STRING COMMENT 'Geographic region (e.g., North America, EMEA, APAC) where the service is delivered. Supports regional SLA performance benchmarking and reporting for the multinational manufacturing enterprise.',
    `review_date` DATE COMMENT 'Date on which the SLA performance record was formally reviewed in a service review meeting or by the service owner. Supports governance and audit trail requirements.. Valid values are `^d{4}-d{2}-d{2}$`',
    `review_status` STRING COMMENT 'Workflow status of the SLA performance record within the service review process. Tracks whether the measurement has been reviewed and approved by the service owner and stakeholders.. Valid values are `pending_review|under_review|reviewed|approved|disputed|closed`',
    `reviewer_name` STRING COMMENT 'Name of the individual who reviewed and approved or disputed the SLA performance measurement. Provides accountability and audit trail for the service review process.',
    `root_cause_category` STRING COMMENT 'Standardized category classification of the root cause for SLA non-compliance. Enables trend analysis of breach drivers across the IT and OT service portfolio to prioritize improvement investments.. Valid values are `hardware_failure|software_defect|network_issue|capacity_constraint|human_error|third_party_dependency|planned_maintenance|security_incident|configuration_error|unknown`',
    `root_cause_summary` STRING COMMENT 'Narrative summary of the identified root cause(s) for SLA breaches or at-risk conditions during the measurement period. Populated by the service owner or problem management team as part of the Corrective and Preventive Action (CAPA) process.',
    `service_category` STRING COMMENT 'Functional category of the IT or OT service being measured. Enables SLA performance analysis and benchmarking by service category across the manufacturing enterprise.. Valid values are `infrastructure|application|network|security|ot_system|end_user_computing|cloud|database|integration|communication`',
    `service_owner` STRING COMMENT 'Name or identifier of the individual accountable for the IT or OT service performance. The service owner is responsible for reviewing SLA performance results and initiating improvement actions.',
    `site_code` STRING COMMENT 'Code identifying the manufacturing plant, facility, or data center site where the service is primarily delivered or consumed. Enables geographic SLA performance analysis across the multinational enterprise.',
    `sla_metric_type` STRING COMMENT 'The type of SLA metric being measured in this performance record. Determines the unit of measure and interpretation of target and actual values. Examples include availability percentage, response time in minutes, or MTTR.. Valid values are `availability|response_time|resolution_time|throughput|error_rate|recovery_time|uptime|mean_time_to_repair|mean_time_between_failures|first_call_resolution|customer_satisfaction`',
    `sla_tier` STRING COMMENT 'Service tier classification associated with the SLA definition being measured. Higher tiers (e.g., Platinum, Gold) correspond to more stringent performance targets and are typically assigned to mission-critical manufacturing systems.. Valid values are `platinum|gold|silver|bronze|standard`',
    `target_value` DECIMAL(18,2) COMMENT 'The contractually or operationally defined target value for the SLA metric in this measurement period. For availability, this may be 99.9 (percent); for response time, it may be 15 (minutes). Interpreted in conjunction with metric_unit.',
    `variance_percent` DECIMAL(18,2) COMMENT 'Percentage deviation of actual performance from the SLA target value. Calculated as ((actual_value - target_value) / target_value) * 100. Enables normalized comparison across different SLA metric types.',
    `variance_value` DECIMAL(18,2) COMMENT 'Numeric difference between actual_value and target_value for the measurement period. A positive variance indicates performance above target; a negative variance indicates underperformance. Expressed in the same unit as metric_unit.',
    CONSTRAINT pk_sla_performance PRIMARY KEY(`sla_performance_id`)
) COMMENT 'Transactional record tracking actual SLA performance measurements against defined SLA targets for IT and OT services. Captures measurement period, service reference, SLA definition reference, actual performance value, target value, compliance status (met, breached, at-risk), breach count, breach duration, affected tickets, root cause summary, and improvement action reference. Enables IT service performance reporting, SLA breach trend analysis, and continuous service improvement (CSI) for manufacturing technology operations.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`it_risk` (
    `it_risk_id` BIGINT COMMENT 'Unique system-generated identifier for each IT and OT technology risk record in the enterprise risk register.',
    `service_ticket_id` BIGINT COMMENT 'Foreign key linking to technology.service_ticket. Business justification: IT risks may generate incident tickets. Normalize related_incident_number STRING to FK relationship with service_ticket for risk-to-incident tracking.',
    `affected_business_process` STRING COMMENT 'The core manufacturing or enterprise business process(es) that would be disrupted if this risk materializes (e.g., Manufacturing Execution and Shop Floor Control, Order Management and Fulfillment).',
    `affected_domain` STRING COMMENT 'The primary technology domain impacted by this risk, enabling domain-specific risk aggregation and reporting (e.g., OT/ICS for shop floor control systems, cloud for SaaS platforms).. Valid values are `it_infrastructure|ot_ics|application|data|network|endpoint|cloud|identity|third_party|physical|cross_domain`',
    `affected_systems` STRING COMMENT 'Comma-separated list or free-text description of specific IT/OT systems, applications, or infrastructure components exposed to this risk (e.g., SAP S/4HANA, Siemens Opcenter MES, SCADA network).',
    `category` STRING COMMENT 'High-level classification of the risk type: cybersecurity (threats to IT/OT systems), operational (service disruption), compliance (regulatory breach), strategic (digital transformation), vendor (third-party dependency), infrastructure (capacity/obsolescence), data (integrity/availability), or OT/ICS (industrial control system specific).. Valid values are `cybersecurity|operational|compliance|strategic|vendor|infrastructure|data|ot_ics`',
    `control_effectiveness` STRING COMMENT 'Assessment of how effectively the existing control measures reduce the likelihood or impact of the risk materializing, informing residual risk calculation.. Valid values are `none|weak|partial|adequate|strong`',
    `control_measures` STRING COMMENT 'Description of existing security and operational controls currently in place to mitigate this risk (e.g., network segmentation, patch management, MFA, IEC 62443 security zones, SIEM monitoring).',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the geography where this risk is applicable, supporting multi-country risk reporting and jurisdiction-specific regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Detailed narrative describing the nature of the risk, its potential causes, threat sources, and the assets or processes it may affect.',
    `identified_date` DATE COMMENT 'The date on which this risk was first formally identified and entered into the risk register.. Valid values are `^d{4}-d{2}-d{2}$`',
    `iec62443_security_level` STRING COMMENT 'The IEC 62443 Security Level (SL0–SL4) associated with this OT/ICS risk, indicating the required protection level against intentional attacks on industrial automation and control systems.. Valid values are `SL0|SL1|SL2|SL3|SL4`',
    `impact_rating` STRING COMMENT 'Qualitative assessment of the potential business impact if this risk materializes, considering financial loss, operational disruption, regulatory penalty, and reputational damage.. Valid values are `very_low|low|medium|high|very_high`',
    `impact_score` STRING COMMENT 'Numeric score (1–5) corresponding to the impact rating, used for quantitative risk scoring and heat map generation (1=Very Low, 5=Very High).. Valid values are `^[1-5]$`',
    `inherent_risk_level` STRING COMMENT 'Qualitative banding of the inherent risk score into actionable risk levels (Low: 1–4, Medium: 5–9, High: 10–16, Critical: 17–25), used for executive reporting and escalation thresholds.. Valid values are `low|medium|high|critical`',
    `inherent_risk_score` STRING COMMENT 'The gross risk score calculated as likelihood_score × impact_score (range 1–25), representing the level of risk before any controls are applied. Used for risk prioritization and heat map positioning.. Valid values are `^([1-9]|[1-2][0-9]|25)$`',
    `is_ot_risk` BOOLEAN COMMENT 'Indicates whether this risk pertains to Operational Technology (OT) or Industrial Control Systems (ICS), enabling segregated OT/IT risk reporting and IEC 62443 compliance tracking.. Valid values are `true|false`',
    `last_reviewed_date` DATE COMMENT 'The date on which this risk record was most recently reviewed and validated by the risk owner or reviewer, ensuring currency of the risk assessment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `likelihood_rating` STRING COMMENT 'Qualitative assessment of the probability that this risk will materialize within the assessment period, based on threat intelligence, historical data, and control environment.. Valid values are `very_low|low|medium|high|very_high`',
    `likelihood_score` STRING COMMENT 'Numeric score (1–5) corresponding to the likelihood rating, used for quantitative risk scoring and heat map generation (1=Very Low, 5=Very High).. Valid values are `^[1-5]$`',
    `next_review_date` DATE COMMENT 'The scheduled date for the next periodic review of this risk record, ensuring timely reassessment in line with risk management policy and review cycles.. Valid values are `^d{4}-d{2}-d{2}$`',
    `record_created_timestamp` TIMESTAMP COMMENT 'The timestamp when this risk record was first created in the system, used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent update to this risk record, supporting change tracking and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `regulatory_compliance_scope` STRING COMMENT 'Comma-separated list of regulatory frameworks or standards to which this risk is relevant (e.g., IEC 62443, ISO 27001, GDPR, NIST CSF, RoHS, REACH, OSHA), supporting compliance risk reporting.',
    `residual_risk_level` STRING COMMENT 'Qualitative banding of the residual risk score (Low/Medium/High/Critical), used for risk acceptance decisions, escalation, and board-level reporting.. Valid values are `low|medium|high|critical`',
    `residual_risk_score` STRING COMMENT 'The net risk score remaining after accounting for the effectiveness of existing controls (range 1–25). Drives risk treatment prioritization and acceptance decisions.. Valid values are `^([1-9]|[1-2][0-9]|25)$`',
    `risk_acceptance_approver` STRING COMMENT 'Name or identifier of the senior authority (e.g., CISO, CIO, Risk Committee) who formally approved the acceptance of this risk, providing governance accountability.',
    `risk_acceptance_justification` STRING COMMENT 'Documented rationale for formally accepting a risk where the treatment strategy is accept, required for audit evidence and governance accountability.',
    `risk_number` STRING COMMENT 'Human-readable, business-facing unique identifier for the risk record, used in communications, reports, and audit documentation (e.g., ITR-2024-00123).. Valid values are `^ITR-[0-9]{4}-[0-9]{5}$`',
    `risk_owner` STRING COMMENT 'Name or identifier of the individual accountable for managing this risk, ensuring treatment plan execution, and reporting on risk status to governance bodies.',
    `risk_owner_department` STRING COMMENT 'The organizational department or business unit of the risk owner, supporting departmental risk aggregation and accountability reporting.',
    `risk_reviewer` STRING COMMENT 'Name or identifier of the individual responsible for periodically reviewing and validating the accuracy and currency of this risk record.',
    `site_code` STRING COMMENT 'Code identifying the manufacturing plant, facility, or site where this risk is applicable, supporting site-level risk aggregation and local risk management.',
    `source` STRING COMMENT 'The originating activity or process that identified this risk, supporting traceability and risk identification channel analytics.. Valid values are `internal_audit|penetration_test|vulnerability_scan|risk_assessment|incident_review|vendor_assessment|regulatory_audit|threat_intelligence|self_assessment|change_review|other`',
    `status` STRING COMMENT 'Current lifecycle status of the risk record, tracking progression from initial identification through assessment, treatment, and closure or acceptance.. Valid values are `identified|under_assessment|open|in_treatment|mitigated|accepted|closed|transferred`',
    `subcategory` STRING COMMENT 'Granular classification within the risk category, enabling precise risk trending and targeted control mapping (e.g., ransomware under cybersecurity, OT network exposure under OT/ICS).. Valid values are `ransomware|phishing|insider_threat|vulnerability|patch_management|application_obsolescence|capacity|single_point_of_failure|third_party_concentration|regulatory_non_compliance|data_breach|ot_network_exposure|supply_chain_attack|identity_access|cloud_risk|other`',
    `title` STRING COMMENT 'Short, descriptive title summarizing the IT or OT technology risk for quick identification in dashboards and risk registers.',
    `treatment_plan` STRING COMMENT 'Detailed description of the planned actions, projects, or controls to be implemented to address this risk, including specific remediation steps and responsible parties.',
    `treatment_status` STRING COMMENT 'Current execution status of the risk treatment plan, enabling tracking of remediation progress and overdue treatment identification.. Valid values are `not_started|in_progress|completed|on_hold|cancelled`',
    `treatment_strategy` STRING COMMENT 'The chosen approach for addressing this risk: mitigate (implement controls), accept (acknowledge and monitor), transfer (insurance/contract), avoid (eliminate activity), or defer (postpone treatment).. Valid values are `mitigate|accept|transfer|avoid|defer`',
    `treatment_target_date` DATE COMMENT 'The planned completion date by which the risk treatment actions should be fully implemented and the residual risk reduced to an acceptable level.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_it_risk PRIMARY KEY(`it_risk_id`)
) COMMENT 'Master record for identified IT and OT technology risks across the manufacturing enterprise including cybersecurity risks, OT/ICS vulnerabilities, application obsolescence risks, infrastructure capacity risks, vendor dependency risks, and digital transformation execution risks. Captures risk title, risk category (cybersecurity, operational, compliance, strategic), risk description, likelihood rating, impact rating, inherent risk score, control measures, residual risk score, risk owner, treatment plan, treatment status, and review date. Supports IT risk management and enterprise technology governance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`vulnerability` (
    `vulnerability_id` BIGINT COMMENT 'Unique system-generated identifier for each vulnerability record within the enterprise cybersecurity and OT/IT vulnerability management program.',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: Vulnerabilities are discovered on specific configuration items. Security teams prioritize remediation based on CI criticality, track exposure per asset, and verify patch deployment against vulnerable ',
    `it_asset_id` BIGINT COMMENT 'Foreign key linking to technology.it_asset. Business justification: Vulnerabilities are discovered on IT assets. Normalize affected_asset_name STRING to FK relationship with it_asset master.',
    `patch_record_id` BIGINT COMMENT 'Foreign key linking to technology.patch_record. Business justification: Vulnerabilities are remediated by patches. Normalize patch_reference STRING to FK relationship with patch_record for vulnerability lifecycle tracking.',
    `affected_asset_type` STRING COMMENT 'Category of the affected asset, distinguishing between IT infrastructure components and OT/ICS devices such as PLCs, HMIs, and SCADA servers.. Valid values are `server|workstation|network_device|plc|hmi|scada_server|historian|iot_device|ot_controller|firewall|switch|router|application|database|other`',
    `affected_ip_address` STRING COMMENT 'IP address of the affected asset at the time of vulnerability discovery. Classified as confidential as it may reveal network topology.',
    `affected_software` STRING COMMENT 'Name and version of the software, firmware, or operating system component that contains the vulnerability (e.g., Windows Server 2019, Siemens S7-1500 firmware v2.8).',
    `assigned_owner` STRING COMMENT 'Name or user ID of the IT or OT security engineer responsible for managing and remediating this vulnerability. Drives accountability in the remediation workflow.',
    `assigned_team` STRING COMMENT 'Name of the team or organizational unit responsible for remediating the vulnerability (e.g., IT Security Operations, OT Engineering, Network Team).',
    `cisa_kev_listed` BOOLEAN COMMENT 'Indicates whether this vulnerability appears in the CISA Known Exploited Vulnerabilities (KEV) catalog, mandating prioritized remediation per CISA Binding Operational Directive 22-01.. Valid values are `true|false`',
    `compliance_framework` STRING COMMENT 'Regulatory or security framework(s) to which this vulnerability is relevant for compliance reporting (e.g., IEC 62443, ISO 27001, NIST CSF, NIS2, GDPR). Pipe-separated if multiple.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the location where the affected asset resides, supporting multi-country regulatory compliance reporting.. Valid values are `^[A-Z]{3}$`',
    `cve_code` STRING COMMENT 'Standardized CVE identifier assigned by MITRE/NVD for publicly known cybersecurity vulnerabilities. May be null for zero-day or internally discovered vulnerabilities not yet assigned a CVE.. Valid values are `^CVE-[0-9]{4}-[0-9]{4,}$`',
    `cvss_base_score` DECIMAL(18,2) COMMENT 'Numerical CVSS base score (0.0–10.0) representing the intrinsic severity of the vulnerability independent of time or environment, as defined by FIRST.. Valid values are `^(10.0|[0-9].[0-9])$`',
    `cvss_vector` STRING COMMENT 'Full CVSS vector string encoding the individual metric values (attack vector, complexity, privileges required, user interaction, scope, impact) used to derive the base score.',
    `cvss_version` STRING COMMENT 'Version of the CVSS standard used to calculate the base score, enabling consistent interpretation across different scoring frameworks.. Valid values are `2.0|3.0|3.1|4.0`',
    `description` STRING COMMENT 'Detailed technical and business description of the vulnerability, including the nature of the flaw, potential exploitation vectors, and affected components.',
    `discovery_date` DATE COMMENT 'Date on which the vulnerability was first identified or reported within the enterprise environment. Used to calculate age of vulnerability and SLA compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `discovery_method` STRING COMMENT 'Method or source through which the vulnerability was identified, including automated scanning tools, penetration testing engagements, ICS-CERT advisories, or threat intelligence feeds.. Valid values are `vulnerability_scan|penetration_test|threat_intelligence_feed|ics_cert_advisory|manual_review|vendor_advisory|bug_bounty|internal_audit|siem_alert|other`',
    `exception_approved` BOOLEAN COMMENT 'Indicates whether a formal exception has been approved to allow the vulnerability to remain unpatched beyond the standard SLA, typically due to OT operational constraints or business continuity requirements.. Valid values are `true|false`',
    `exception_approver` STRING COMMENT 'Name or user ID of the authorized individual (e.g., CISO, OT Security Manager) who approved the vulnerability exception.',
    `exception_expiry_date` DATE COMMENT 'Date on which the approved vulnerability exception expires and must be reviewed or renewed, ensuring time-bound risk acceptance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `exception_reason` STRING COMMENT 'Business or technical justification for the approved exception, such as OT system unavailability for patching, vendor support constraints, or production continuity requirements.',
    `exploit_publicly_available` BOOLEAN COMMENT 'Indicates whether a working exploit for this vulnerability is publicly available (e.g., in Metasploit, ExploitDB, or threat intelligence feeds), significantly elevating remediation urgency.. Valid values are `true|false`',
    `exploitability` STRING COMMENT 'CVSS temporal metric indicating the current state of exploit techniques or code availability, used to refine prioritization beyond the base score.. Valid values are `unproven|proof_of_concept|functional|high|not_defined`',
    `ics_cert_advisory_code` STRING COMMENT 'Reference identifier for the ICS-CERT (Industrial Control Systems Cyber Emergency Response Team) advisory associated with this OT/ICS vulnerability, enabling traceability to official advisories.',
    `is_ot_vulnerability` BOOLEAN COMMENT 'Indicates whether the vulnerability affects an Operational Technology (OT) or Industrial Control System (ICS) asset, triggering specialized OT remediation workflows and IEC 62443 compliance tracking.. Valid values are `true|false`',
    `network_zone` STRING COMMENT 'Network security zone or Purdue Model level where the affected asset resides, critical for assessing blast radius and prioritizing OT/IT remediation.. Valid values are `dmz|corporate_lan|ot_level_0|ot_level_1|ot_level_2|ot_level_3|ot_level_4|cloud|remote_access|other`',
    `patch_available` BOOLEAN COMMENT 'Indicates whether a vendor-supplied patch or security update is available to remediate the vulnerability at the time of record creation or last update.. Valid values are `true|false`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the vulnerability record was first created in the data platform, used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the vulnerability record, supporting change tracking and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `remediation_action` STRING COMMENT 'Planned or applied remediation action to address the vulnerability, including patching, configuration hardening, network segmentation, or compensating controls for OT environments where patching is not feasible.. Valid values are `apply_patch|configuration_change|network_segmentation|compensating_control|firmware_upgrade|software_upgrade|decommission_asset|workaround|no_action_risk_accepted|other`',
    `remediation_completed_date` DATE COMMENT 'Actual date on which the remediation action was completed and verified, used to measure SLA compliance and time-to-remediate metrics.. Valid values are `^d{4}-d{2}-d{2}$`',
    `remediation_due_date` DATE COMMENT 'Target date by which the vulnerability must be remediated, calculated based on severity SLA policy (e.g., critical: 15 days, high: 30 days, medium: 90 days).. Valid values are `^d{4}-d{2}-d{2}$`',
    `scan_tool` STRING COMMENT 'Name and version of the scanning tool or platform used to discover the vulnerability (e.g., Tenable Nessus, Qualys, Claroty, Dragos, Rapid7).',
    `severity` STRING COMMENT 'Qualitative severity rating of the vulnerability derived from the CVSS base score. Drives prioritization and SLA-based remediation timelines.. Valid values are `critical|high|medium|low|informational`',
    `site_code` STRING COMMENT 'Code identifying the manufacturing plant, facility, or office location where the affected asset is deployed, enabling site-level vulnerability posture reporting.',
    `source_system` STRING COMMENT 'Name of the originating system or feed from which the vulnerability record was ingested (e.g., Tenable.sc, Qualys VMDR, Claroty, Dragos, Siemens MindSphere, ICS-CERT feed).',
    `status` STRING COMMENT 'Current lifecycle status of the vulnerability record, tracking progress from initial discovery through remediation, exception approval, or closure.. Valid values are `open|in_remediation|remediated|exception_approved|risk_accepted|closed|false_positive`',
    `title` STRING COMMENT 'Short descriptive title of the vulnerability, typically derived from the CVE description, ICS-CERT advisory, or internal discovery report.',
    `type` STRING COMMENT 'Classification of the vulnerability by its technical nature or weakness category, aligned with CWE (Common Weakness Enumeration) taxonomy.. Valid values are `injection|buffer_overflow|authentication_bypass|privilege_escalation|cross_site_scripting|insecure_configuration|missing_patch|default_credentials|denial_of_service|cryptographic_weakness|firmware_flaw|protocol_weakness|other`',
    CONSTRAINT pk_vulnerability PRIMARY KEY(`vulnerability_id`)
) COMMENT 'Transactional record for identified cybersecurity and OT/IT vulnerabilities discovered through vulnerability scanning, penetration testing, threat intelligence feeds, and ICS-CERT advisories across IT infrastructure and OT systems. Captures CVE identifier, vulnerability title, affected asset or system, CVSS score, severity (critical, high, medium, low), vulnerability type, discovery method, discovery date, patch availability, remediation status, remediation due date, assigned owner, and exception approval if unpatched. Critical for OT/IT cybersecurity posture management and IEC 62443 compliance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`patch_record` (
    `patch_record_id` BIGINT COMMENT 'Unique system-generated identifier for each patch deployment record in the enterprise patch management system.',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: Patch records document updates applied to specific CIs. Security and operations teams track patch compliance per asset, verify vulnerability remediation, and maintain CI configuration accuracy for aud',
    `it_asset_id` BIGINT COMMENT 'Foreign key linking to technology.it_asset. Business justification: Patches are applied to IT assets. Normalize affected_asset_tag STRING to FK relationship with it_asset master.',
    `service_ticket_id` BIGINT COMMENT 'Foreign key linking to technology.service_ticket. Business justification: Patches may be deployed in response to incidents. Normalize related_incident_number STRING to FK relationship with service_ticket.',
    `technology_change_request_id` BIGINT COMMENT 'Foreign key linking to technology.change_request. Business justification: Patches are deployed via change management process. Normalize change_request_number STRING to FK relationship with change_request.',
    `actual_deployment_date` DATE COMMENT 'Actual calendar date on which the patch was deployed to the affected system. Compared against scheduled deployment date to measure deployment timeliness and SLA adherence.. Valid values are `^d{4}-d{2}-d{2}$`',
    `affected_system_name` STRING COMMENT 'Name or hostname of the IT system, OT device, or application being patched. Provides human-readable identification of the target system for operational reporting and audit trails.',
    `affected_system_type` STRING COMMENT 'Classification of the system or device being patched. Distinguishes IT systems (servers, workstations) from OT/ICS systems (PLC, SCADA, HMI) to support OT patch management governance and IEC 62443 compliance.. Valid values are `server|workstation|laptop|plc|scada_server|hmi|network_device|iot_device|virtual_machine|container|database_server|application_server`',
    `compliance_deadline_date` DATE COMMENT 'Mandatory date by which the patch must be deployed to meet internal policy or external regulatory compliance requirements. Derived from patch severity rating and applicable compliance frameworks (e.g., critical patches within 30 days per policy).. Valid values are `^d{4}-d{2}-d{2}$`',
    `compliance_status` STRING COMMENT 'Compliance posture of this patch record relative to the applicable policy or regulatory deadline. Compliant indicates deployment within the required timeframe; non_compliant indicates overdue deployment; exempt indicates an approved exception.. Valid values are `compliant|non_compliant|exempt|pending_review`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the location where the patched asset resides. Supports multi-national patch compliance reporting and regional regulatory requirements (e.g., GDPR, CCPA, NIS2 Directive).. Valid values are `^[A-Z]{3}$`',
    `cve_reference` STRING COMMENT 'One or more CVE identifiers associated with the vulnerability addressed by this patch. Comma-separated for patches addressing multiple CVEs. Used for vulnerability tracking and regulatory compliance reporting.. Valid values are `^(CVE-[0-9]{4}-[0-9]{4,7})(,CVE-[0-9]{4}-[0-9]{4,7})*$`',
    `cvss_score` DECIMAL(18,2) COMMENT 'Numeric CVSS base score (0.0–10.0) quantifying the severity of the vulnerability addressed by this patch. Drives prioritization and SLA-based deployment timelines for security patches.. Valid values are `^(10.0|[0-9].[0-9])$`',
    `deferral_approved_by` STRING COMMENT 'Name or identifier of the authorized approver who approved the deferral of the patch deployment. Required for governance accountability and audit trail when patches are deferred beyond policy-mandated timelines.',
    `deferral_expiry_date` DATE COMMENT 'Date by which a deferred patch must be deployed or re-evaluated. Enforces time-bound deferral governance and prevents indefinite postponement of critical security patches.. Valid values are `^d{4}-d{2}-d{2}$`',
    `deferral_reason` STRING COMMENT 'Business justification for deferring a patch deployment beyond the scheduled date. Required for audit and compliance reporting when deployment_status is deferred. Common reasons include production freeze, OT vendor testing requirement, or resource unavailability.',
    `deployed_by` STRING COMMENT 'Name or user identifier of the IT/OT engineer or automated system (e.g., SCCM, Ansible) responsible for executing the patch deployment. Provides accountability and audit trail for change management.',
    `deployment_status` STRING COMMENT 'Current lifecycle status of the patch deployment. Pending indicates awaiting deployment; deployed confirms successful application; failed indicates deployment error; deferred indicates postponement beyond scheduled date; rolled_back indicates the patch was reversed post-deployment.. Valid values are `pending|in_progress|deployed|failed|deferred|cancelled|rolled_back|not_applicable`',
    `deployment_timestamp` TIMESTAMP COMMENT 'Precise date and time at which the patch deployment was executed on the target system. Provides granular audit trail for change management, incident correlation, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `exception_reference` STRING COMMENT 'Reference number of the approved compliance exception or risk acceptance record when a patch cannot be deployed within the mandated timeframe. Required for audit evidence when compliance_status is exempt.',
    `is_ot_system` BOOLEAN COMMENT 'Indicates whether the patched asset is an Operational Technology (OT) or Industrial Control System (ICS) component (e.g., PLC, SCADA, HMI, DCS). OT patches require additional change governance, vendor coordination, and production impact assessment per IEC 62443.. Valid values are `true|false`',
    `patch_category` STRING COMMENT 'Technology category of the component being patched, distinguishing between operating system patches, application-level patches, OT/ICS-specific patches (PLC, SCADA, HMI), network device firmware, and database patches. Critical for OT/IT convergence governance.. Valid values are `os|application|middleware|firmware|bios|plc|scada|hmi|network_device|database|antivirus`',
    `patch_identifier` STRING COMMENT 'Unique business identifier for the patch or update, typically referencing the vendor-assigned patch ID, bulletin number, or internal patch catalog reference (e.g., MS23-001, CVE-2023-12345-FIX).. Valid values are `^PATCH-[A-Z0-9]{4,20}$`',
    `patch_release_date` DATE COMMENT 'Date on which the vendor officially released the patch or security update. Used to calculate patch age, measure time-to-deploy compliance, and assess exposure window duration.. Valid values are `^d{4}-d{2}-d{2}$`',
    `patch_source` STRING COMMENT 'Origin or distribution mechanism through which the patch was obtained and deployed. WSUS (Windows Server Update Services) and SCCM (System Center Configuration Manager) are standard IT patch distribution tools; OT vendor portals are used for ICS/SCADA patches.. Valid values are `vendor_advisory|wsus|sccm|ansible|manual|yum_repo|apt_repo|ot_vendor_portal|third_party_tool`',
    `patch_title` STRING COMMENT 'Human-readable title or name of the patch or update as provided by the vendor or internal patch management team (e.g., Windows Server 2019 Cumulative Update KB5031364).',
    `patch_type` STRING COMMENT 'Classification of the patch by its primary purpose: security patches address vulnerabilities, functional patches deliver feature enhancements or bug fixes, firmware patches update embedded software on OT/ICS devices, drivers update hardware interface software, hotfixes address critical production issues.. Valid values are `security|functional|firmware|driver|hotfix|service_pack|configuration|cumulative_update`',
    `patch_version` STRING COMMENT 'Version number or build identifier of the patch package as released by the vendor. Used to confirm the correct patch version was applied and to distinguish between patch revisions.',
    `post_deployment_validation_notes` STRING COMMENT 'Free-text notes documenting the findings, observations, or issues identified during post-deployment validation. Captures details of any anomalies, partial failures, or compensating controls applied.',
    `post_deployment_validation_result` STRING COMMENT 'Outcome of the post-deployment validation or smoke test performed after patch application to confirm system stability, functionality, and successful patch installation. Failed results trigger rollback or incident procedures.. Valid values are `passed|failed|partial|pending|not_performed`',
    `post_patch_version` STRING COMMENT 'The software or firmware version of the affected system after successful patch application. Used to confirm the patch was correctly applied and the system is at the expected version level.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Date and time when the patch record was first created in the patch management system. Provides audit trail for record lifecycle and data lineage in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Date and time when the patch record was last modified in the patch management system. Supports incremental data loading, change detection, and audit trail maintenance in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `rollback_performed` BOOLEAN COMMENT 'Indicates whether the patch deployment was rolled back after application due to system instability, validation failure, or adverse production impact. Triggers incident and CAPA (Corrective and Preventive Action) processes.. Valid values are `true|false`',
    `rollback_timestamp` TIMESTAMP COMMENT 'Date and time at which the patch rollback was executed. Populated only when rollback_performed is true. Used for incident timeline reconstruction and change management post-implementation review.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `scheduled_deployment_date` DATE COMMENT 'Planned calendar date on which the patch is scheduled to be deployed to the affected system, as defined in the change management plan. Used for patch scheduling, resource planning, and SLA compliance tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `severity_rating` STRING COMMENT 'Vendor or internal risk-based severity classification of the patch, aligned with Common Vulnerability Scoring System (CVSS) severity bands. Critical and High severity patches require expedited deployment per patch compliance policy.. Valid values are `critical|high|medium|low|informational`',
    `site_code` STRING COMMENT 'Code identifying the manufacturing plant, facility, or data center site where the patched asset is located. Supports site-level patch compliance reporting and regional governance.',
    `target_software_version` STRING COMMENT 'The software or firmware version of the affected system prior to patch application (pre-patch baseline). Used to validate patch applicability and confirm the correct patch was deployed to the correct version.',
    `test_environment_name` STRING COMMENT 'Name or identifier of the non-production environment (e.g., OT-Lab-01, IT-Staging-EU) where the patch was validated before production deployment. Provides traceability for pre-deployment testing evidence.',
    `tested_in_non_production` BOOLEAN COMMENT 'Indicates whether the patch was validated in a non-production (test/staging/lab) environment prior to production deployment. Mandatory for OT/ICS patches per IEC 62443-2-3 to prevent unplanned production disruption.. Valid values are `true|false`',
    `vendor_advisory_reference` STRING COMMENT 'Vendor-issued security advisory or bulletin reference number associated with this patch (e.g., Microsoft Security Advisory MS23-001, Siemens ProductCERT SSA-123456). Used for vendor correspondence and regulatory audit evidence.',
    CONSTRAINT pk_patch_record PRIMARY KEY(`patch_record_id`)
) COMMENT 'Transactional record tracking the deployment of software patches, firmware updates, and security fixes across IT assets and OT systems in the manufacturing enterprise. Captures patch identifier, patch type (security, functional, firmware), affected asset or system, patch source (vendor advisory, WSUS, SCCM), patch release date, scheduled deployment date, actual deployment date, deployment status (pending, deployed, failed, deferred), tested in non-production flag, change request reference, and post-deployment validation result. Supports patch compliance reporting and OT patch management governance.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`it_service_outage` (
    `it_service_outage_id` BIGINT COMMENT 'Unique system-generated identifier for each IT or OT service outage record in the enterprise lakehouse.',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Service outages affecting customer-facing systems or customer-deployed equipment require tracking which accounts are impacted for SLA compliance, communication, and potential credits. NOC and customer',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: Service outages identify which CI failed causing service disruption. Operations teams analyze CI failure patterns, calculate MTBF/MTTR per asset, and prioritize infrastructure investments based on out',
    `incident_id` BIGINT COMMENT 'Foreign key linking to hse.incident. Business justification: IT/OT service outages affecting safety systems (gas detection, emergency alarms, safety interlocks) trigger HSE incidents. Linking outages to safety incidents enables root cause analysis and prevents ',
    `it_service_id` BIGINT COMMENT 'Foreign key linking to technology.it_service. Business justification: Service outages affect specific IT services. Normalize affected_service_code and affected_service_name to FK relationship with it_service master.',
    `it_vendor_id` BIGINT COMMENT 'Foreign key linking to technology.it_vendor. Business justification: Service outages may involve external vendors. Normalize vendor_name STRING to FK relationship with it_vendor master for vendor performance tracking.',
    `service_ticket_id` BIGINT COMMENT 'Foreign key linking to technology.service_ticket. Business justification: Service outages generate incident tickets. Normalize related_incident_number STRING to FK relationship with service_ticket for incident tracking.',
    `technology_change_request_id` BIGINT COMMENT 'Foreign key linking to technology.change_request. Business justification: Service outages may be caused by or linked to change requests. Normalize related_change_request_number STRING to FK relationship for root cause analysis.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: IT service outages impact specific warehouses operations (WMS down, network failure). Incident management requires tracking which warehouse facilities are affected to prioritize restoration and asses',
    `affected_business_unit` STRING COMMENT 'Name of the business unit or organizational division impacted by the outage (e.g., Automation Systems Division, Electrification Solutions BU).',
    `affected_plant_code` STRING COMMENT 'SAP plant code or site identifier for the manufacturing facility or business unit impacted by the outage. Enables geographic and operational impact analysis.',
    `affected_production_lines` STRING COMMENT 'Comma-separated list or description of manufacturing production lines impacted by the outage (e.g., Line-A1, Line-B3). Enables production impact quantification.',
    `assigned_resolver_team` STRING COMMENT 'Name of the IT or OT support team assigned as the primary resolver for this outage (e.g., Network Operations, SAP Basis, OT/SCADA Support, Cloud Infrastructure).',
    `capa_reference` STRING COMMENT 'Reference number or identifier of the Corrective and Preventive Action (CAPA) record raised as a result of this outage, linking to the quality management system.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the location where the outage occurred or had primary impact (e.g., USA, DEU, CHN).. Valid values are `^[A-Z]{3}$`',
    `detection_method` STRING COMMENT 'Method by which the outage was first identified — automated monitoring tools (e.g., MindSphere, SCADA), user-reported via service desk, vendor alert, or OT alarm system.. Valid values are `automated_monitoring|user_report|service_desk|vendor_alert|scheduled_check|ot_alarm`',
    `detection_timestamp` TIMESTAMP COMMENT 'Date and time when the outage was first detected, either by automated monitoring (MindSphere IIoT, SCADA alerts) or manual report. May differ from outage start if there was a detection lag.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `duration_minutes` STRING COMMENT 'Total elapsed time in minutes from outage start to service restoration. Stored as a business-recorded value from the ITSM system; used for availability reporting and SLA compliance.. Valid values are `^[0-9]+$`',
    `financial_impact_amount` DECIMAL(18,2) COMMENT 'Estimated financial impact of the outage in the specified currency, including lost production value, labor costs, and recovery expenses. Used for business case and risk reporting.',
    `financial_impact_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the financial impact amount (e.g., USD, EUR, CNY).. Valid values are `^[A-Z]{3}$`',
    `is_ot_outage` BOOLEAN COMMENT 'Indicates whether the outage affects an Operational Technology (OT) system such as a PLC, SCADA, DCS, MES, or IIoT platform, as opposed to a pure IT service. Critical for IT/OT convergence reporting.. Valid values are `true|false`',
    `oee_impact_percent` DECIMAL(18,2) COMMENT 'Estimated reduction in Overall Equipment Effectiveness (OEE) percentage attributable to this outage, as assessed by the production or MES team. Key KPI for manufacturing availability reporting.. Valid values are `^(100(.00?)?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `outage_category` STRING COMMENT 'Broad technology category of the affected service or component causing the outage, used for trend analysis and capacity planning.. Valid values are `infrastructure|application|network|ot_system|security|database|cloud|end_user_computing|vendor`',
    `outage_end_timestamp` TIMESTAMP COMMENT 'Date and time when the IT or OT service was fully restored and the outage was declared resolved. Null if the outage is still active.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `outage_number` STRING COMMENT 'Human-readable business reference number for the outage, used for cross-system tracking and communication (e.g., OUT-2024-000123). Sourced from the ITSM platform.. Valid values are `^OUT-[0-9]{4}-[0-9]{6}$`',
    `outage_start_timestamp` TIMESTAMP COMMENT 'Date and time when the IT or OT service outage began, as recorded in the ITSM platform. Used for duration calculation and SLA breach assessment.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `outage_type` STRING COMMENT 'Classification of the outage as planned maintenance, unplanned incident, partial service degradation, or emergency change. Drives reporting segmentation and SLA applicability.. Valid values are `planned_maintenance|unplanned_incident|partial_degradation|emergency_change`',
    `post_incident_review_date` DATE COMMENT 'Date on which the Post-Incident Review (PIR) was completed. Used for compliance tracking and problem management reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `post_incident_review_status` STRING COMMENT 'Status of the Post-Incident Review (PIR) or Post-Mortem process for this outage. Critical outages require a formal PIR to identify systemic issues and drive CAPA.. Valid values are `not_required|pending|in_progress|completed|waived`',
    `production_lines_affected_count` STRING COMMENT 'Number of distinct manufacturing production lines impacted by the outage. Used for production impact scoring and OEE impact analysis.. Valid values are `^[0-9]+$`',
    `production_loss_units` DECIMAL(18,2) COMMENT 'Estimated number of production units lost due to the outage, as assessed by the manufacturing operations team. Supports financial impact quantification.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the outage record was first created in the source ITSM system. Used for audit trail and data lineage in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the outage record in the source ITSM system. Supports incremental data loading and change tracking in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `reported_by` STRING COMMENT 'Name or user ID of the individual or team who first reported or logged the outage in the ITSM system.',
    `resolution_actions` STRING COMMENT 'Description of the technical and operational actions taken to restore the affected IT or OT service, including workarounds applied and permanent fixes implemented.',
    `root_cause_category` STRING COMMENT 'Standardized category of the root cause identified during post-incident analysis. Enables trend analysis and CAPA (Corrective and Preventive Action) prioritization.. Valid values are `hardware_failure|software_bug|network_failure|human_error|vendor_issue|cyber_incident|power_failure|environmental|configuration_error|capacity_exhaustion|ot_control_failure|unknown`',
    `root_cause_description` STRING COMMENT 'Detailed narrative description of the identified root cause of the outage, as documented during post-incident review or problem management investigation.',
    `rto_target_minutes` STRING COMMENT 'The Recovery Time Objective (RTO) in minutes defined in the SLA for the affected service at the time of the outage. Used to assess SLA compliance.. Valid values are `^[0-9]+$`',
    `severity` STRING COMMENT 'Business impact severity of the outage. Critical indicates full production stoppage or safety risk; high indicates major degradation; medium indicates partial impact; low indicates minimal disruption.. Valid values are `critical|high|medium|low`',
    `sla_breach_flag` BOOLEAN COMMENT 'Indicates whether the outage duration exceeded the Recovery Time Objective (RTO) or availability SLA threshold defined for the affected service.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this outage record was sourced (e.g., ServiceNow, SAP Solution Manager, Siemens Opcenter, Maximo EAM).',
    `status` STRING COMMENT 'Current lifecycle status of the outage record, from initial detection through resolution and formal closure.. Valid values are `open|in_progress|resolved|closed|cancelled`',
    `vendor_involved_flag` BOOLEAN COMMENT 'Indicates whether an external vendor or third-party support provider was engaged in the resolution of this outage (e.g., SAP support, Siemens field service, cloud provider).. Valid values are `true|false`',
    `workaround_applied` BOOLEAN COMMENT 'Indicates whether a temporary workaround was applied to restore service before a permanent fix was implemented. Relevant for problem management follow-up.. Valid values are `true|false`',
    CONSTRAINT pk_it_service_outage PRIMARY KEY(`it_service_outage_id`)
) COMMENT 'Transactional record for planned and unplanned IT and OT service outages affecting manufacturing operations. Captures outage reference number, outage type (planned maintenance, unplanned incident, partial degradation), affected service, affected plant or business unit, outage start timestamp, outage end timestamp, total duration, production impact assessment (lines affected, OEE impact), root cause category, root cause description, resolution actions, post-incident review status, and financial impact estimate. Enables outage trend analysis, availability reporting, and production impact quantification for IT/OT services.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`user_access_request` (
    `user_access_request_id` BIGINT COMMENT 'Unique system-generated identifier for each identity and access management (IAM) request record in the enterprise.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the individual who approved or rejected the access request. Supports audit trail and accountability for access governance.',
    `beneficiary_employee_id` BIGINT COMMENT 'Employee identifier of the user who will receive the requested access. May differ from the requester when a manager submits on behalf of a team member.',
    `requester_employee_id` BIGINT COMMENT 'Employee identifier of the person who submitted the access request on behalf of themselves or another user. Sourced from HR system (Kronos/SAP HCM).',
    `access_expiry_date` DATE COMMENT 'Calendar date on which the granted access automatically expires and must be renewed or revoked. Mandatory for contractor, temporary worker, and privileged access grants.. Valid values are `^d{4}-d{2}-d{2}$`',
    `access_granted_date` DATE COMMENT 'Calendar date from which the beneficiary users access becomes effective in the target system. Used for access certification and entitlement reviews.. Valid values are `^d{4}-d{2}-d{2}$`',
    `access_level` STRING COMMENT 'Degree of access being requested, ranging from read-only to full administrative or privileged/super-user access. Critical for PAM governance and SOD compliance.. Valid values are `read_only|read_write|full_access|admin|privileged|super_user|emergency_access`',
    `access_review_due_date` DATE COMMENT 'Date by which the granted access must be reviewed and recertified by the access owner or manager as part of periodic access certification campaigns.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approval_level` STRING COMMENT 'Organizational level at which the access request was approved, reflecting the approval hierarchy (e.g., line manager for standard access, CISO for privileged access).. Valid values are `line_manager|department_head|it_security|ciso|system_owner|privileged_access_committee`',
    `approval_status` STRING COMMENT 'Current status of the approval workflow for the access request, tracking whether it is pending review, approved, rejected, escalated to a higher authority, or conditionally approved with restrictions.. Valid values are `pending|approved|rejected|escalated|withdrawn|conditionally_approved`',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the access request received final approval, used to measure approval SLA compliance and audit response times.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `approver_name` STRING COMMENT 'Full name of the approver who reviewed and actioned the access request. Used for audit trail and governance reporting.',
    `beneficiary_job_title` STRING COMMENT 'Job title of the beneficiary user, used to validate that the requested access is appropriate for their role and responsibilities.',
    `beneficiary_name` STRING COMMENT 'Full name of the user who will receive the requested access rights. Used for identity verification and audit trail.',
    `beneficiary_user_type` STRING COMMENT 'Classification of the beneficiary indicating whether they are a full-time employee, contractor, vendor, service account, system identity, or temporary worker. Drives access policy and expiry rules.. Valid values are `employee|contractor|vendor|service_account|system|temporary_worker`',
    `business_justification` STRING COMMENT 'Free-text explanation provided by the requester describing the business need for the requested access, used by approvers to validate legitimacy and by auditors for compliance evidence.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the beneficiary users primary work location, used for regional data privacy compliance (GDPR, CCPA) and access policy enforcement.. Valid values are `^[A-Z]{3}$`',
    `is_emergency_access` BOOLEAN COMMENT 'Indicates whether the request is an emergency break-glass access request that bypasses standard approval workflow. Emergency access requires post-hoc review and mandatory time-limited expiry.. Valid values are `true|false`',
    `is_ot_system` BOOLEAN COMMENT 'Indicates whether the target system is an Operational Technology (OT) system (e.g., SCADA, PLC, DCS, MES shop floor). OT access requests require additional cybersecurity review per IEC 62443.. Valid values are `true|false`',
    `is_privileged_access` BOOLEAN COMMENT 'Indicates whether the request involves privileged access (admin, super-user, root, or emergency break-glass access) requiring enhanced PAM controls and additional approval steps.. Valid values are `true|false`',
    `priority` STRING COMMENT 'Business priority level assigned to the access request, influencing SLA targets for approval and provisioning turnaround times.. Valid values are `critical|high|medium|low`',
    `provisioned_timestamp` TIMESTAMP COMMENT 'Date and time when the approved access was successfully provisioned in the target system, marking the completion of the provisioning SLA.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `provisioning_method` STRING COMMENT 'Indicates whether access was provisioned through automated IAM tooling, manually by an IT administrator, or via a semi-automated process requiring human confirmation.. Valid values are `automated|manual|semi_automated`',
    `provisioning_status` STRING COMMENT 'Technical execution status of the access provisioning action in the target system, distinct from the approval status. Tracks whether the approved access has been successfully implemented.. Valid values are `not_started|in_progress|completed|failed|partially_completed|rolled_back`',
    `rejection_reason` STRING COMMENT 'Explanation provided by the approver when an access request is rejected, documenting the rationale for denial for audit and compliance purposes.',
    `related_ticket_number` STRING COMMENT 'Reference number of the associated IT service management (ITSM) ticket (e.g., ServiceNow incident or service request) linked to this access request for end-to-end traceability.',
    `request_category` STRING COMMENT 'Operational category of the access request distinguishing standard user requests from emergency break-glass access, privileged/PAM requests, service account provisioning, bulk provisioning events, or contractor access.. Valid values are `standard|emergency|privileged|service_account|bulk|contractor`',
    `request_number` STRING COMMENT 'Human-readable, business-facing reference number for the access request, used for tracking and communication across approval workflows.. Valid values are `^UAR-[0-9]{4}-[0-9]{6}$`',
    `request_type` STRING COMMENT 'Classification of the IAM request indicating whether it is for new access provisioning, modification of existing access, revocation/deprovisioning, privileged access (PAM), role change, or temporary access grant.. Valid values are `new_access|access_modification|access_revocation|privileged_access|role_change|temporary_access`',
    `requested_role` STRING COMMENT 'Specific role, permission set, or authorization profile being requested within the target system (e.g., SAP MM Buyer, MES Operator, PLM Engineer, SCADA Read-Only).',
    `requester_department` STRING COMMENT 'Organizational department of the requester, used for SOD (Segregation of Duties) analysis and access governance reporting.',
    `requester_name` STRING COMMENT 'Full name of the individual who submitted the access request. Used for audit trail and approval workflow communication.',
    `revocation_reason` STRING COMMENT 'Reason for revoking the access, such as employee offboarding, role change, periodic access review finding, security incident, or contract end. Required for deprovisioning audit compliance.. Valid values are `offboarding|role_change|access_review|security_incident|policy_violation|project_completion|contract_end|voluntary`',
    `revoked_timestamp` TIMESTAMP COMMENT 'Date and time when the access was revoked or deprovisioned from the target system, used for offboarding compliance and access lifecycle audit trails.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `site_code` STRING COMMENT 'Manufacturing plant or office site code where the beneficiary user is physically located, used for OT/IT access zoning and regional compliance requirements.',
    `sod_conflict_description` STRING COMMENT 'Description of the identified SOD conflict, specifying which existing roles or permissions conflict with the requested access. Populated when sod_conflict_flag is True.',
    `sod_conflict_flag` BOOLEAN COMMENT 'Indicates whether the requested access creates a Segregation of Duties (SOD) conflict with the beneficiarys existing access rights. A True value triggers mandatory SOD exception review.. Valid values are `true|false`',
    `source_system` STRING COMMENT 'Name of the IAM or ITSM system from which this access request record originated (e.g., SailPoint IdentityNow, ServiceNow, SAP GRC, CyberArk), supporting data lineage and integration traceability.',
    `status` STRING COMMENT 'Current lifecycle status of the access request from initial submission through approval, provisioning, and eventual revocation or expiry.. Valid values are `draft|submitted|pending_approval|approved|rejected|provisioning|provisioned|failed|revoked|expired|cancelled`',
    `submitted_timestamp` TIMESTAMP COMMENT 'Date and time when the access request was formally submitted by the requester, marking the start of the SLA clock for approval and provisioning.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `target_system_name` STRING COMMENT 'Name of the enterprise IT or OT system for which access is being requested (e.g., SAP S/4HANA, Siemens Opcenter MES, Teamcenter PLM, MindSphere, Salesforce CRM, Maximo EAM, SCADA).',
    `target_system_type` STRING COMMENT 'Category of the target system (e.g., ERP, MES, PLM, SCADA, CRM, EAM, WMS, IIoT platform) to support access governance reporting and OT/IT convergence risk analysis.. Valid values are `erp|mes|plm|scada|crm|eam|wms|iam|cloud_platform|ot_system|network|database|application|iiot_platform`',
    CONSTRAINT pk_user_access_request PRIMARY KEY(`user_access_request_id`)
) COMMENT 'Transactional record for identity and access management (IAM) requests covering provisioning, modification, and deprovisioning of user access to enterprise IT systems (SAP, MES, PLM, SCADA, cloud platforms) and OT systems. Captures request number, request type (new access, access modification, access revocation, privileged access), requester, beneficiary user, target system, requested role or permission, business justification, approval workflow status, approver identity, provisioning status, access granted date, and access expiry date. Supports IAM governance, SOD (Segregation of Duties) compliance, and privileged access management (PAM) for manufacturing systems.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`standard` (
    `standard_id` BIGINT COMMENT 'Unique surrogate identifier for each enterprise technology standard record in the manufacturing IT governance framework.',
    `applicable_countries` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes identifying the countries where this standard is applicable. Used for regional compliance scoping in multinational manufacturing operations.. Valid values are `^([A-Z]{3})(,[A-Z]{3})*$`',
    `applicable_sites` STRING COMMENT 'Comma-separated list of plant or site codes to which this standard applies when compliance scope is plant-level or site-specific. Aligns with the enterprise site master for manufacturing facility identification.',
    `approval_date` DATE COMMENT 'Date on which the owning architecture board formally approved this version of the technology standard for enterprise use.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approved_by` STRING COMMENT 'Name or role of the architecture board chair or executive authority who formally approved this technology standard.',
    `category` STRING COMMENT 'Secondary classification indicating the form of the standard — whether it defines a platform choice, communication protocol, design pattern, policy mandate, advisory guideline, technical specification, or reference architecture.. Valid values are `platform|protocol|pattern|policy|guideline|specification|framework|reference_architecture`',
    `code` STRING COMMENT 'Unique alphanumeric business code assigned to the technology standard for cross-system reference and governance tracking (e.g., ARCH-STD-00142).. Valid values are `^[A-Z]{2,6}-STD-[0-9]{4,6}$`',
    `compliance_assessment_result` STRING COMMENT 'Overall compliance assessment result from the most recent audit or self-assessment of this standard across the enterprise. Supports governance reporting and remediation prioritization.. Valid values are `compliant|partially_compliant|non_compliant|not_assessed`',
    `compliance_classification` STRING COMMENT 'Indicates whether adherence to this standard is mandatory (required for all applicable systems), advisory (recommended best practice), or conditional (required only under specific circumstances such as regulated environments or specific technology tiers).. Valid values are `mandatory|advisory|conditional`',
    `compliance_scope` STRING COMMENT 'Geographic and organizational scope of applicability for this standard. Global standards apply enterprise-wide across all countries and sites; plant-level standards apply only to specific manufacturing facilities.. Valid values are `global|regional|country|plant_level|business_unit`',
    `description` STRING COMMENT 'Detailed narrative describing the purpose, scope, and intent of the technology standard, including the business problem it addresses and the architectural principles it enforces.',
    `deviation_allowed` BOOLEAN COMMENT 'Indicates whether formal deviations from this standard are permissible with appropriate approval. False indicates zero-tolerance standards (e.g., critical cybersecurity controls) where no deviation is permitted.. Valid values are `true|false`',
    `deviation_approval_process` STRING COMMENT 'Description of the formal process by which projects or systems may request and obtain an approved exception or deviation from this standard. Includes the approving authority, required documentation, and time-bound validity of deviations.',
    `document_reference` STRING COMMENT 'Reference identifier or URL pointing to the full standard document stored in the enterprise document management system (e.g., Siemens Teamcenter PLM or SharePoint). Enables direct access to the authoritative standard text.',
    `effective_date` DATE COMMENT 'Date on which this version of the technology standard becomes officially effective and enforceable across the applicable compliance scope.. Valid values are `^d{4}-d{2}-d{2}$`',
    `enforcement_mechanism` STRING COMMENT 'Method by which compliance with this standard is enforced across the enterprise. Architecture review gates block non-compliant designs; automated policy checks enforce via tooling; audit and assessment validates post-deployment compliance.. Valid values are `architecture_review_gate|automated_policy_check|audit_and_assessment|self_attestation|tooling_enforcement|none`',
    `exception_count` STRING COMMENT 'Number of currently active approved exceptions or deviations from this standard across the enterprise. A high exception count may indicate the standard needs revision or is impractical for certain use cases.. Valid values are `^[0-9]+$`',
    `it_ot_applicability` STRING COMMENT 'Indicates whether this standard applies to Information Technology (IT) systems, Operational Technology (OT) systems such as PLCs, SCADA, DCS, or both. Critical for IT/OT convergence governance in the manufacturing enterprise.. Valid values are `it_only|ot_only|it_and_ot`',
    `last_audit_date` DATE COMMENT 'Date of the most recent compliance audit or assessment conducted to verify adherence to this technology standard across applicable systems and sites.. Valid values are `^d{4}-d{2}-d{2}$`',
    `name` STRING COMMENT 'Official name of the enterprise technology standard as approved by the architecture governance board (e.g., Enterprise API Integration Standard, OT Network Segmentation Standard).',
    `owner` STRING COMMENT 'Name or employee ID of the individual accountable for maintaining this technology standard, coordinating reviews, and managing deviation requests. Typically a Principal Architect or Domain Lead.',
    `owning_architecture_board` STRING COMMENT 'Name of the enterprise architecture governance body responsible for authoring, approving, and maintaining this standard (e.g., Enterprise Architecture Review Board, OT Security Council, Data Governance Committee).',
    `previous_version` STRING COMMENT 'Version number of the immediately preceding version of this standard, enabling version lineage tracking and change impact analysis.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?$`',
    `purdue_model_levels` STRING COMMENT 'Comma-separated list of Purdue Enterprise Reference Architecture (PERA) model levels (0–5) to which this standard applies. Level 0 is field devices; Level 5 is enterprise network. Supports OT/IT convergence architecture governance.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this technology standard record was first created in the enterprise data platform. Used for data lineage, audit trail, and Silver Layer ingestion tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to this technology standard record in the enterprise data platform. Supports change detection, incremental processing, and audit compliance in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `regulatory_drivers` STRING COMMENT 'Comma-separated list of regulatory frameworks, laws, or certifications that mandate or influence this standard (e.g., IEC 62443, GDPR, RoHS, ISO 27001, OSHA, CE Marking). Supports compliance traceability and audit evidence.',
    `related_standards` STRING COMMENT 'Comma-separated list of standard codes that are related to, dependent on, or complementary to this standard. Supports architecture coherence and impact analysis when standards are updated.',
    `retirement_date` DATE COMMENT 'Date on which this technology standard was or is planned to be retired or superseded. Populated when status transitions to deprecated, retired, or superseded.. Valid values are `^d{4}-d{2}-d{2}$`',
    `review_date` DATE COMMENT 'Date by which this technology standard must be reviewed and reaffirmed, updated, or retired by the owning architecture board. Supports governance cadence and prevents standards from becoming stale.. Valid values are `^d{4}-d{2}-d{2}$`',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this technology standard record originates (e.g., Enterprise Architecture Repository, ServiceNow CMDB, Confluence). Supports data lineage in the Databricks Silver Layer.',
    `status` STRING COMMENT 'Current lifecycle status of the technology standard. Active standards are mandatorily or advisorily enforced; deprecated standards are scheduled for retirement; superseded standards have been replaced by a newer version.. Valid values are `draft|under_review|approved|active|deprecated|retired|superseded`',
    `superseded_by_code` STRING COMMENT 'Standard code of the newer technology standard that replaces this one when status is superseded. Enables traceability of standard lineage and migration path for affected systems.',
    `technology_domain` STRING COMMENT 'The enterprise technology domain to which this standard applies. Enables domain-specific governance reporting and ensures standards are surfaced to the correct architecture review boards and technology owners.. Valid values are `network_infrastructure|cybersecurity|cloud_and_hosting|application_architecture|data_and_analytics|ot_and_iiot|integration_and_middleware|end_user_computing|identity_and_access|it_service_management|digital_manufacturing`',
    `technology_lifecycle_phase` STRING COMMENT 'Indicates the enterprise technology lifecycle phase of the technologies governed by this standard. Strategic technologies are actively invested in; contained technologies are maintained but not expanded; declining technologies are being phased out.. Valid values are `emerging|strategic|standard|contained|declining|end_of_life`',
    `type` STRING COMMENT 'Classification of the technology standard by its primary governance domain. Architecture standards govern design patterns; security standards enforce cybersecurity controls; integration standards define API and messaging protocols; OT standards govern operational technology environments; data standards define data management rules.. Valid values are `architecture_standard|security_standard|integration_standard|ot_standard|data_standard|infrastructure_standard|application_standard|compliance_standard`',
    `version` STRING COMMENT 'Version number of the technology standard following semantic versioning convention (e.g., 1.0, 2.3, 3.1.2). Enables tracking of standard evolution and ensures stakeholders reference the correct approved version.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?$`',
    CONSTRAINT pk_standard PRIMARY KEY(`standard_id`)
) COMMENT 'Reference master defining approved enterprise technology standards, architecture principles, and IT governance policies for the manufacturing enterprise. Captures standard name, standard type (architecture standard, security standard, integration standard, OT standard, data standard), standard version, applicable technology domain, mandatory or advisory classification, compliance scope (global, regional, plant-level), effective date, review date, owning architecture board, and deviation approval process. Supports enterprise architecture governance, technology standardization, and IT/OT convergence architecture decisions.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`data_integration` (
    `data_integration_id` BIGINT COMMENT 'Unique surrogate identifier for each enterprise data integration interface record in the silver layer lakehouse.',
    `application_id` BIGINT COMMENT 'Foreign key linking to technology.application. Business justification: Data integrations extract from a source application. IT architecture teams track which application is the source for data lineage, troubleshooting, and impact analysis when systems change.',
    `warehouse_id` BIGINT COMMENT 'Foreign key linking to inventory.warehouse. Business justification: Data integrations extract inventory data from specific warehouse systems. IT architects need to map which warehouses WMS/WCS is the source for each integration flow for data lineage and troubleshooti',
    `authentication_method` STRING COMMENT 'Authentication mechanism used to secure the integration interface (e.g., OAuth2, API key, certificate, mutual TLS). Supports cybersecurity compliance and IEC 62443 security level assessment.. Valid values are `OAuth2|API_key|certificate|basic_auth|SAML|Kerberos|mutual_TLS|none|custom`',
    `avg_daily_volume_records` BIGINT COMMENT 'Average number of records or messages exchanged per day through this integration interface. Used for capacity planning, performance monitoring, and SLA baseline setting.',
    `avg_payload_size_kb` DECIMAL(18,2) COMMENT 'Average size of each message or file payload in kilobytes. Used for network bandwidth planning, middleware sizing, and performance SLA definition.',
    `business_owner` STRING COMMENT 'Name or role of the business stakeholder accountable for the data and business process supported by this integration. Serves as the primary escalation contact for business-impacting integration failures.',
    `business_process` STRING COMMENT 'Core business process supported by this integration (e.g., Manufacturing Execution and Shop Floor Control, Materials Procurement and Supply Chain Management, Quality Assurance and Inspection). Links integration to business value.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary country where this integration operates. Supports regional compliance, data residency, and GDPR/CCPA jurisdiction determination.. Valid values are `^[A-Z]{3}$`',
    `data_classification` STRING COMMENT 'Sensitivity classification of the data exchanged through this integration interface (restricted, confidential, internal, public). Governs encryption requirements, access controls, and audit obligations.. Valid values are `restricted|confidential|internal|public`',
    `data_domain` STRING COMMENT 'Primary business data domain served by this integration interface (e.g., Production, Supply Chain, Quality Management). Aligns with the enterprise data domain taxonomy for governance and stewardship assignment.. Valid values are `Product Engineering|Production|Supply Chain|Quality Management|Inventory|Sales and Orders|Customer|Asset Management|Workforce|Finance|Procurement|Logistics|Health Safety and Environment|Research and Development|Service and Aftermarket`',
    `description` STRING COMMENT 'Detailed narrative describing the business purpose, data exchanged, and operational context of the integration interface. Supports impact analysis and onboarding documentation.',
    `direction` STRING COMMENT 'Indicates whether data flows in one direction (source to target) or bidirectionally between systems. Bidirectional interfaces require conflict resolution and master data governance controls.. Valid values are `unidirectional|bidirectional`',
    `encryption_in_transit` BOOLEAN COMMENT 'Indicates whether data transmitted through this integration interface is encrypted in transit (e.g., TLS/SSL). Mandatory for interfaces carrying confidential or restricted data per cybersecurity policy.. Valid values are `true|false`',
    `environment` STRING COMMENT 'Deployment environment in which this integration instance operates (e.g., production, UAT, development). Ensures monitoring and SLA enforcement is scoped to production interfaces.. Valid values are `production|staging|uat|development|sandbox|dr`',
    `error_handling_strategy` STRING COMMENT 'Defined strategy for handling integration failures or message processing errors (e.g., retry, dead-letter queue, alert and stop). Ensures operational resilience and data integrity across connected systems.. Valid values are `retry|dead_letter_queue|alert_and_stop|compensating_transaction|manual_intervention|discard|custom`',
    `frequency` STRING COMMENT 'Operational frequency or trigger mode of the integration (e.g., real-time, near-real-time, batch daily, event-driven). Determines latency expectations, SLA targets, and infrastructure sizing.. Valid values are `real_time|near_real_time|micro_batch|batch_hourly|batch_daily|batch_weekly|batch_monthly|event_driven|on_demand|scheduled`',
    `go_live_date` DATE COMMENT 'Date on which this integration interface was first deployed and activated in the production environment. Used for integration age analysis, lifecycle management, and audit trails.. Valid values are `^d{4}-d{2}-d{2}$`',
    `integration_code` STRING COMMENT 'Unique business code identifying the integration interface (e.g., SAP-MES-001, PLM-ERP-002). Used as the natural key for cross-system reference and integration landscape documentation.. Valid values are `^[A-Z0-9_-]{3,30}$`',
    `integration_pattern` STRING COMMENT 'Architectural pattern used for the integration (e.g., API, EDI, file transfer, message queue, OPC-UA). Drives middleware selection, monitoring approach, and OT/IT convergence classification.. Valid values are `API|EDI|file_transfer|message_queue|OPC-UA|database_replication|event_streaming|web_service|FTP|SFTP|direct_database|custom`',
    `integration_type` STRING COMMENT 'Architectural topology classification of the integration (e.g., point-to-point, hub-and-spoke, ESB, iPaaS, event-driven). Supports enterprise architecture governance and rationalization.. Valid values are `point_to_point|hub_and_spoke|ESB|iPaaS|event_driven|B2B|OT_IT|IIoT|EDI|custom`',
    `it_owner` STRING COMMENT 'Name or role of the IT team or individual technically responsible for maintaining and supporting this integration interface. Primary contact for technical incidents and change requests.',
    `last_reviewed_date` DATE COMMENT 'Date on which this integration record was last reviewed for accuracy, relevance, and compliance. Supports integration governance cadence and audit readiness.. Valid values are `^d{4}-d{2}-d{2}$`',
    `middleware_platform` STRING COMMENT 'Integration middleware or platform facilitating the data exchange (e.g., SAP Integration Suite, MuleSoft, IBM MQ, Azure Service Bus, Kafka, Dell Boomi). Identifies the technology layer enabling the interface.',
    `name` STRING COMMENT 'Descriptive business name of the integration interface (e.g., SAP S/4HANA to Opcenter MES Production Order Sync). Used in integration landscape catalogs and governance reporting.',
    `ot_it_classification` STRING COMMENT 'Classifies the integration as IT-only, OT-only, OT/IT convergence, IIoT, or B2B external. Critical for cybersecurity zone management, IEC 62443 compliance, and digital transformation tracking.. Valid values are `IT_only|OT_only|OT_IT_convergence|IIoT|B2B_external`',
    `owning_department` STRING COMMENT 'Organizational department or business unit that owns and funds this integration interface (e.g., IT Architecture, Manufacturing Operations, Supply Chain). Supports cost allocation and governance accountability.',
    `planned_decommission_date` DATE COMMENT 'Planned date for retiring or decommissioning this integration interface. Supports integration landscape rationalization, digital transformation roadmap planning, and dependency management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `protocol` STRING COMMENT 'Technical communication protocol used for data exchange in the integration (e.g., REST, SOAP, OPC-UA, MQTT, AS2, SFTP). Critical for OT/IT convergence interfaces and cybersecurity zone classification.. Valid values are `REST|SOAP|OPC-UA|MQTT|AMQP|AS2|SFTP|FTP|JDBC|ODBC|HTTP|HTTPS|OData|GraphQL|gRPC|Modbus|PROFINET|custom`',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when this integration record was first created in the enterprise data platform. Supports data lineage, audit trail, and silver layer ingestion tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp when this integration record was last updated in the enterprise data platform. Supports change tracking, data freshness monitoring, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `regulatory_compliance_scope` STRING COMMENT 'Regulatory frameworks or standards applicable to this integration interface (e.g., GDPR, CCPA, IEC 62443, ISO 9001, RoHS, REACH). Drives audit requirements and data handling obligations.',
    `retry_max_attempts` STRING COMMENT 'Maximum number of automatic retry attempts configured for failed message delivery or processing. Balances resilience with prevention of duplicate processing in downstream systems.. Valid values are `^[0-9]+$`',
    `site_code` STRING COMMENT 'Code identifying the manufacturing plant or site where this integration is primarily deployed or operationally relevant. Supports multi-site integration landscape management.. Valid values are `^[A-Z0-9_-]{2,20}$`',
    `sla_availability_target_pct` DECIMAL(18,2) COMMENT 'Contractual or operational availability target for this integration interface expressed as a percentage (e.g., 99.9). Drives monitoring thresholds and incident escalation criteria.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `sla_latency_target_seconds` DECIMAL(18,2) COMMENT 'Maximum acceptable end-to-end message latency in seconds as defined in the integration SLA. Particularly critical for real-time OT/IT and MES-ERP interfaces supporting shop floor execution.',
    `source_system` STRING COMMENT 'Name of the originating system that produces or sends data in this integration (e.g., SAP S/4HANA, Siemens Teamcenter PLM, Siemens Opcenter MES, Siemens MindSphere, Maximo EAM). Aligns with the enterprise application portfolio.',
    `source_system_module` STRING COMMENT 'Specific functional module or component within the source system involved in the integration (e.g., SAP MM, SAP PP, Teamcenter BOM Management, Opcenter Shop Floor Execution). Enables granular impact analysis.',
    `status` STRING COMMENT 'Current operational lifecycle status of the integration interface. Drives monitoring scope, change management eligibility, and integration landscape rationalization decisions.. Valid values are `active|inactive|deprecated|under_development|testing|suspended|decommissioned`',
    `target_system` STRING COMMENT 'Name of the destination system that receives or consumes data in this integration (e.g., Siemens Opcenter MES, Infor WMS, Salesforce CRM, SAP Ariba). Aligns with the enterprise application portfolio.',
    `target_system_module` STRING COMMENT 'Specific functional module or component within the target system involved in the integration (e.g., Opcenter Scheduling, Infor WMS Inventory Tracking, Salesforce Service Cloud). Enables granular impact analysis.',
    CONSTRAINT pk_data_integration PRIMARY KEY(`data_integration_id`)
) COMMENT 'Master record for all enterprise data integration interfaces and middleware connections linking IT and OT systems across the manufacturing enterprise including ERP-MES interfaces, PLM-ERP integrations, SCADA-historian connections, IIoT platform integrations, and B2B EDI connections. Captures interface name, integration pattern (API, EDI, file transfer, message queue, OPC-UA), source system, target system, data domain, integration frequency (real-time, near-real-time, batch), protocol, operational status, data volume, SLA target, and business owner. SSOT for enterprise integration landscape visibility supporting OT/IT convergence and digital transformation.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` (
    `it_cost_allocation_id` BIGINT COMMENT 'Unique surrogate identifier for each IT cost allocation transaction record in the manufacturing enterprise.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: IT costs from vendor invoices (cloud services, maintenance contracts) are allocated to cost centers or projects. IT finance uses this for chargeback models and budget variance analysis.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: IT costs are allocated to finance cost centers for internal reporting, budget tracking, and P&L responsibility. Cost center is the primary organizational dimension for cost management.',
    `it_service_id` BIGINT COMMENT 'Foreign key linking to technology.it_service. Business justification: IT costs are allocated to services. Normalize service_reference and service_name to FK relationship with it_service master.',
    `it_vendor_id` BIGINT COMMENT 'Foreign key linking to technology.it_vendor. Business justification: IT costs may be vendor-related. Normalize vendor_name STRING to FK relationship with it_vendor master for vendor spend tracking.',
    `allocated_amount` DECIMAL(18,2) COMMENT 'The portion of the total IT cost allocated to the specific business unit, plant, cost center, or production line for the allocation period. This is the primary financial figure for chargeback or showback reporting.',
    `allocation_driver_unit` STRING COMMENT 'The unit of measure for the allocation driver value (e.g., users, CPU hours, GB storage, transaction count), enabling consistent interpretation of the driver metric across different IT cost types.. Valid values are `users|headcount|cpu_hours|gb_storage|transactions|licenses|tickets|devices|square_meters|revenue_pct`',
    `allocation_driver_value` DECIMAL(18,2) COMMENT 'The quantitative value of the allocation driver used to compute the allocated amount (e.g., number of users, CPU hours consumed, transaction count, headcount). Provides auditability of the allocation calculation.',
    `allocation_method` STRING COMMENT 'The methodology used to distribute IT costs to the receiving business unit or cost center. Usage-based allocates by actual consumption metrics; headcount by number of employees; fixed by predetermined agreement.. Valid values are `usage_based|headcount|fixed|revenue_based|transaction_volume|square_footage|equal_split|negotiated`',
    `allocation_model` STRING COMMENT 'Indicates whether the allocation results in an actual financial chargeback (real journal entry to the business unit), a showback (informational reporting only with no financial transaction), or a pure internal allocation.. Valid values are `chargeback|showback|allocation_only`',
    `allocation_number` STRING COMMENT 'Human-readable business reference number uniquely identifying the IT cost allocation transaction, used for cross-referencing in financial systems and chargeback reporting.. Valid values are `^ICA-[0-9]{4}-[0-9]{6}$`',
    `allocation_percentage` DECIMAL(18,2) COMMENT 'The percentage of the total IT cost pool assigned to this specific business unit or cost center, used to validate allocation completeness and audit distribution logic.',
    `allocation_period_end_date` DATE COMMENT 'The last date of the fiscal or calendar period for which IT costs are being allocated to the business unit or cost center.. Valid values are `^d{4}-d{2}-d{2}$`',
    `allocation_period_start_date` DATE COMMENT 'The first date of the fiscal or calendar period for which IT costs are being allocated to the business unit or cost center.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approval_status` STRING COMMENT 'Indicates the approval workflow status for the IT cost allocation, tracking whether the allocation has been reviewed and approved by the relevant financial or IT governance authority.. Valid values are `pending|approved|rejected|not_required`',
    `approved_by` STRING COMMENT 'Name or user ID of the individual who approved the IT cost allocation, supporting audit trail requirements and financial governance controls.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the IT cost allocation was approved by the authorized approver, providing a precise audit trail for financial governance and SOX compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `capex_opex_classification` STRING COMMENT 'Indicates whether the allocated IT cost is classified as Capital Expenditure (CAPEX) for asset investments or Operational Expenditure (OPEX) for ongoing operational costs, critical for financial reporting and tax treatment.. Valid values are `capex|opex|mixed`',
    `cost_element_code` STRING COMMENT 'SAP cost element code (primary or secondary) associated with the IT cost being allocated, enabling integration with the general ledger and controlling module.',
    `cost_type` STRING COMMENT 'Classification of the IT cost category being allocated, aligned with TBM taxonomy. Enables cost transparency by technology tower (e.g., infrastructure, application, cloud, OT/IT convergence).. Valid values are `infrastructure|application|support|cloud|license|network|security|end_user_computing|data_and_analytics|ot_it_convergence`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the receiving entity, supporting regional IT cost analysis and compliance with country-specific financial reporting requirements.. Valid values are `^[A-Z]{3}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the allocated amount (e.g., USD, EUR, GBP), supporting multi-currency operations across the multinational manufacturing enterprise.. Valid values are `^[A-Z]{3}$`',
    `fiscal_period` STRING COMMENT 'The fiscal period (month number 1–12) within the fiscal year for which the IT cost allocation is recorded.. Valid values are `^(1[0-2]|[1-9])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the IT cost allocation is recorded, used for annual financial reporting and IT budget management.. Valid values are `^[0-9]{4}$`',
    `gl_account_code` STRING COMMENT 'The General Ledger account code in SAP S/4HANA to which the IT cost allocation is posted, enabling reconciliation between IT cost management and financial accounting.',
    `internal_order_number` STRING COMMENT 'SAP internal order number used to collect and settle IT costs for specific projects, campaigns, or activities before allocation to cost centers, supporting detailed cost tracking.',
    `legal_entity` STRING COMMENT 'The legal entity or company code within the multinational manufacturing enterprise to which the IT cost allocation is attributed, supporting intercompany cost allocation and statutory reporting.',
    `notes` STRING COMMENT 'Free-text field for additional context, justification, or commentary on the IT cost allocation, such as special allocation agreements, exceptions, or period-specific adjustments.',
    `po_number` STRING COMMENT 'Reference to the Purchase Order number associated with the IT cost being allocated, applicable when costs originate from external vendor invoices for IT services or cloud subscriptions.',
    `posting_date` DATE COMMENT 'The date on which the IT cost allocation is posted to the general ledger in SAP S/4HANA, determining the accounting period for financial reporting purposes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `receiving_business_unit` STRING COMMENT 'The name or code of the manufacturing business unit receiving the IT cost allocation (e.g., Automation Systems Division, Electrification Solutions BU). Used for business-unit-level IT cost transparency reporting.',
    `receiving_cost_center` STRING COMMENT 'The SAP cost center code of the organizational unit receiving the IT cost allocation. Enables granular cost center-level IT financial management and chargeback journal entries.',
    `receiving_plant_code` STRING COMMENT 'The SAP plant code of the manufacturing facility receiving the IT cost allocation, enabling plant-level IT cost analysis and operational technology cost attribution.',
    `receiving_production_line` STRING COMMENT 'Identifier of the specific production line or shop floor area receiving the IT cost allocation, enabling granular OT/IT convergence cost attribution at the production line level.',
    `record_created_timestamp` TIMESTAMP COMMENT 'Timestamp when the IT cost allocation record was first created in the system, used for data lineage tracking and audit trail purposes in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `record_updated_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the IT cost allocation record, supporting change tracking and incremental data processing in the Databricks Silver lakehouse layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `reversal_reason` STRING COMMENT 'Reason code explaining why an IT cost allocation was reversed, required for audit trail completeness and financial period correction documentation.. Valid values are `data_correction|duplicate_entry|period_adjustment|business_unit_change|cancelled_service|other`',
    `source_system` STRING COMMENT 'The operational system of record from which the IT cost allocation data originates (e.g., SAP S/4HANA CO module, Apptio TBM platform, ServiceNow ITSM), supporting data lineage and reconciliation.. Valid values are `SAP_S4HANA|APPTIO|SERVICENOW|MANUAL|OTHER`',
    `status` STRING COMMENT 'Current processing status of the IT cost allocation record, tracking its lifecycle from initial draft through financial posting or reversal.. Valid values are `draft|pending_approval|approved|posted|reversed|cancelled`',
    `total_cost` DECIMAL(18,2) COMMENT 'The total IT cost pool amount before allocation, representing the full cost of the IT service or asset for the allocation period prior to distribution across business units.',
    `wbs_element` STRING COMMENT 'SAP Work Breakdown Structure element associated with the IT cost allocation, used when costs relate to a specific IT project or capital expenditure initiative.',
    CONSTRAINT pk_it_cost_allocation PRIMARY KEY(`it_cost_allocation_id`)
) COMMENT 'Transactional record capturing the allocation of IT and technology costs to manufacturing business units, plants, cost centers, and production lines using Technology Business Management (TBM) principles. Captures allocation period, IT service or asset reference, cost type (infrastructure, application, support, cloud), total cost, allocation method (usage-based, headcount, fixed), allocated business unit, allocated cost center, allocated amount, currency, and chargeback or showback model indicator. Enables IT cost transparency, chargeback/showback reporting, and business-aligned IT financial management for the manufacturing enterprise.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ADD CONSTRAINT `fk_technology_configuration_item_it_service_id` FOREIGN KEY (`it_service_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_service`(`it_service_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ADD CONSTRAINT `fk_technology_service_ticket_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ADD CONSTRAINT `fk_technology_service_ticket_it_service_id` FOREIGN KEY (`it_service_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_service`(`it_service_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ADD CONSTRAINT `fk_technology_service_ticket_technology_change_request_id` FOREIGN KEY (`technology_change_request_id`) REFERENCES `manufacturing_ecm`.`technology`.`technology_change_request`(`technology_change_request_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ADD CONSTRAINT `fk_technology_technology_change_request_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ADD CONSTRAINT `fk_technology_technology_change_request_it_service_id` FOREIGN KEY (`it_service_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_service`(`it_service_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ADD CONSTRAINT `fk_technology_software_license_it_contract_id` FOREIGN KEY (`it_contract_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_contract`(`it_contract_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ADD CONSTRAINT `fk_technology_software_license_it_vendor_id` FOREIGN KEY (`it_vendor_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_vendor`(`it_vendor_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ADD CONSTRAINT `fk_technology_it_project_digital_initiative_id` FOREIGN KEY (`digital_initiative_id`) REFERENCES `manufacturing_ecm`.`technology`.`digital_initiative`(`digital_initiative_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ADD CONSTRAINT `fk_technology_it_project_it_contract_id` FOREIGN KEY (`it_contract_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_contract`(`it_contract_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ADD CONSTRAINT `fk_technology_it_project_it_vendor_id` FOREIGN KEY (`it_vendor_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_vendor`(`it_vendor_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ADD CONSTRAINT `fk_technology_it_project_milestone_it_project_id` FOREIGN KEY (`it_project_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_project`(`it_project_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ADD CONSTRAINT `fk_technology_digital_initiative_it_vendor_id` FOREIGN KEY (`it_vendor_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_vendor`(`it_vendor_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ADD CONSTRAINT `fk_technology_iiot_platform_it_contract_id` FOREIGN KEY (`it_contract_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_contract`(`it_contract_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ADD CONSTRAINT `fk_technology_iiot_platform_it_vendor_id` FOREIGN KEY (`it_vendor_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_vendor`(`it_vendor_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ADD CONSTRAINT `fk_technology_it_contract_it_vendor_id` FOREIGN KEY (`it_vendor_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_vendor`(`it_vendor_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ADD CONSTRAINT `fk_technology_sla_definition_it_service_id` FOREIGN KEY (`it_service_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_service`(`it_service_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ADD CONSTRAINT `fk_technology_sla_performance_it_service_id` FOREIGN KEY (`it_service_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_service`(`it_service_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ADD CONSTRAINT `fk_technology_sla_performance_sla_definition_id` FOREIGN KEY (`sla_definition_id`) REFERENCES `manufacturing_ecm`.`technology`.`sla_definition`(`sla_definition_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ADD CONSTRAINT `fk_technology_it_risk_service_ticket_id` FOREIGN KEY (`service_ticket_id`) REFERENCES `manufacturing_ecm`.`technology`.`service_ticket`(`service_ticket_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ADD CONSTRAINT `fk_technology_vulnerability_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ADD CONSTRAINT `fk_technology_vulnerability_patch_record_id` FOREIGN KEY (`patch_record_id`) REFERENCES `manufacturing_ecm`.`technology`.`patch_record`(`patch_record_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ADD CONSTRAINT `fk_technology_patch_record_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ADD CONSTRAINT `fk_technology_patch_record_service_ticket_id` FOREIGN KEY (`service_ticket_id`) REFERENCES `manufacturing_ecm`.`technology`.`service_ticket`(`service_ticket_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ADD CONSTRAINT `fk_technology_patch_record_technology_change_request_id` FOREIGN KEY (`technology_change_request_id`) REFERENCES `manufacturing_ecm`.`technology`.`technology_change_request`(`technology_change_request_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ADD CONSTRAINT `fk_technology_it_service_outage_configuration_item_id` FOREIGN KEY (`configuration_item_id`) REFERENCES `manufacturing_ecm`.`technology`.`configuration_item`(`configuration_item_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ADD CONSTRAINT `fk_technology_it_service_outage_it_service_id` FOREIGN KEY (`it_service_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_service`(`it_service_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ADD CONSTRAINT `fk_technology_it_service_outage_it_vendor_id` FOREIGN KEY (`it_vendor_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_vendor`(`it_vendor_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ADD CONSTRAINT `fk_technology_it_service_outage_service_ticket_id` FOREIGN KEY (`service_ticket_id`) REFERENCES `manufacturing_ecm`.`technology`.`service_ticket`(`service_ticket_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ADD CONSTRAINT `fk_technology_it_service_outage_technology_change_request_id` FOREIGN KEY (`technology_change_request_id`) REFERENCES `manufacturing_ecm`.`technology`.`technology_change_request`(`technology_change_request_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ADD CONSTRAINT `fk_technology_it_cost_allocation_it_service_id` FOREIGN KEY (`it_service_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_service`(`it_service_id`);
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ADD CONSTRAINT `fk_technology_it_cost_allocation_it_vendor_id` FOREIGN KEY (`it_vendor_id`) REFERENCES `manufacturing_ecm`.`technology`.`it_vendor`(`it_vendor_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`technology` SET TAGS ('dbx_division' = 'corporate');
ALTER SCHEMA `manufacturing_ecm`.`technology` SET TAGS ('dbx_domain' = 'technology');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` SET TAGS ('dbx_subdomain' = 'service_operations');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `it_service_id` SET TAGS ('dbx_business_glossary_term' = 'IT Service ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `annual_budget` SET TAGS ('dbx_business_glossary_term' = 'IT Service Annual Budget');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `annual_budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `availability_target_pct` SET TAGS ('dbx_business_glossary_term' = 'Service Availability Target Percentage');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `availability_target_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `business_owner` SET TAGS ('dbx_business_glossary_term' = 'Business Service Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `catalog_published` SET TAGS ('dbx_business_glossary_term' = 'Service Catalog Published Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `catalog_published` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'IT Service Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'infrastructure|platform|end_user|ot_operational_technology|security|application|data_analytics|communication|cloud|managed_service');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `change_management_category` SET TAGS ('dbx_business_glossary_term' = 'Change Management Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `change_management_category` SET TAGS ('dbx_value_regex' = 'standard|normal|emergency|ot_restricted');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `cmdb_service_code` SET TAGS ('dbx_business_glossary_term' = 'Configuration Management Database (CMDB) Service ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `cost_currency` SET TAGS ('dbx_business_glossary_term' = 'IT Service Cost Currency');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `cost_model` SET TAGS ('dbx_business_glossary_term' = 'IT Service Cost Model');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `cost_model` SET TAGS ('dbx_value_regex' = 'fixed|per_user|per_device|consumption_based|tiered|chargeback|showback|free');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `data_classification` SET TAGS ('dbx_business_glossary_term' = 'IT Service Data Classification');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `data_classification` SET TAGS ('dbx_value_regex' = 'public|internal|confidential|restricted');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `delivery_model` SET TAGS ('dbx_business_glossary_term' = 'IT Service Delivery Model');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `delivery_model` SET TAGS ('dbx_value_regex' = 'on_premise|cloud|hybrid|outsourced|managed_service|co_managed');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'IT Service Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `is_critical_service` SET TAGS ('dbx_business_glossary_term' = 'Critical Service Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `is_critical_service` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `is_ot_service` SET TAGS ('dbx_business_glossary_term' = 'Operational Technology (OT) Service Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `is_ot_service` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `itsm_platform` SET TAGS ('dbx_business_glossary_term' = 'IT Service Management (ITSM) Platform');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'IT Service Last Review Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `last_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `launch_date` SET TAGS ('dbx_business_glossary_term' = 'IT Service Launch Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `launch_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'IT Service Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'IT Service Next Review Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `owning_department` SET TAGS ('dbx_business_glossary_term' = 'IT Service Owning Department');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `primary_ci_class` SET TAGS ('dbx_business_glossary_term' = 'Primary Configuration Item (CI) Class');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `primary_ci_class` SET TAGS ('dbx_value_regex' = 'server|network_device|storage|application|database|middleware|ot_device|plc|scada|historian|endpoint|virtual_machine|cloud_resource|service');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'IT Service Region');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `regulatory_compliance_scope` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Scope');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `retirement_date` SET TAGS ('dbx_business_glossary_term' = 'IT Service Retirement Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `retirement_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `rpo_minutes` SET TAGS ('dbx_business_glossary_term' = 'Recovery Point Objective (RPO) in Minutes');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `rpo_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `rto_minutes` SET TAGS ('dbx_business_glossary_term' = 'Recovery Time Objective (RTO) in Minutes');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `rto_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `service_code` SET TAGS ('dbx_business_glossary_term' = 'IT Service Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `service_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,6}-[A-Z0-9]{3,10}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `service_manager` SET TAGS ('dbx_business_glossary_term' = 'IT Service Manager');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `service_owner` SET TAGS ('dbx_business_glossary_term' = 'IT Service Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `service_owner_email` SET TAGS ('dbx_business_glossary_term' = 'IT Service Owner Email Address');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `service_owner_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `service_owner_email` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `service_type` SET TAGS ('dbx_business_glossary_term' = 'IT Service Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `service_type` SET TAGS ('dbx_value_regex' = 'business_service|technical_service|shared_service|ot_service');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `service_version` SET TAGS ('dbx_business_glossary_term' = 'IT Service Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `service_version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'IT Service Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'pipeline|active|deprecated|retired|suspended|under_review');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `subcategory` SET TAGS ('dbx_business_glossary_term' = 'IT Service Subcategory');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `support_hours` SET TAGS ('dbx_business_glossary_term' = 'IT Service Support Hours');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `support_hours` SET TAGS ('dbx_value_regex' = '8x5|12x5|16x5|24x7|24x5|follow_the_sun');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `unit_cost` SET TAGS ('dbx_business_glossary_term' = 'IT Service Unit Cost');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service` ALTER COLUMN `unit_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` SET TAGS ('dbx_subdomain' = 'service_operations');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item (CI) ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `it_service_id` SET TAGS ('dbx_business_glossary_term' = 'It Service Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `ci_class` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item (CI) Class');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `ci_class` SET TAGS ('dbx_value_regex' = 'Hardware|Software|Network|Virtual Machine|Database|Application|Service|OT Device|Cloud Resource|Storage|Middleware|Security Appliance');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `ci_number` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item (CI) Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `ci_number` SET TAGS ('dbx_value_regex' = '^CI-[A-Z0-9]{6,20}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `ci_subtype` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item (CI) Subtype');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `ci_type` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item (CI) Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `ci_type` SET TAGS ('dbx_value_regex' = 'Server|Workstation|Network Switch|Router|Firewall|PLC|HMI|SCADA Server|DCS Controller|IIoT Gateway|Virtual Machine|Container|Database Instance|Application|Operating System|License|Storage Array|UPS|Printer|Mobile Device');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `compliance_baseline` SET TAGS ('dbx_business_glossary_term' = 'CI Compliance Baseline');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'CI Compliance Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'Compliant|Non-Compliant|Exempt|Under Review|Pending Remediation');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `cpu_count` SET TAGS ('dbx_business_glossary_term' = 'CI CPU Count');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `cpu_count` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `criticality` SET TAGS ('dbx_business_glossary_term' = 'CI Business Criticality');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `criticality` SET TAGS ('dbx_value_regex' = 'Critical|High|Medium|Low');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `discovery_method` SET TAGS ('dbx_business_glossary_term' = 'CI Discovery Method');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `discovery_method` SET TAGS ('dbx_value_regex' = 'Automated Discovery|Manual Entry|Agent-Based|Agentless|Import|API Integration|OT Passive Scan');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `end_of_life_date` SET TAGS ('dbx_business_glossary_term' = 'CI End-of-Life (EOL) Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `end_of_life_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `environment` SET TAGS ('dbx_business_glossary_term' = 'CI Deployment Environment');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `environment` SET TAGS ('dbx_value_regex' = 'Production|Development|Test|Staging|Disaster Recovery|Lab|Sandbox|Pre-Production');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `firmware_version` SET TAGS ('dbx_business_glossary_term' = 'CI Firmware Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `hostname` SET TAGS ('dbx_business_glossary_term' = 'CI Hostname');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `hostname` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `install_date` SET TAGS ('dbx_business_glossary_term' = 'CI Installation Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `install_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `ip_address` SET TAGS ('dbx_business_glossary_term' = 'CI IP Address');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `ip_address` SET TAGS ('dbx_value_regex' = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$|^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `ip_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `ip_address` SET TAGS ('dbx_pii_ip' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'CI Last Audit Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `last_change_date` SET TAGS ('dbx_business_glossary_term' = 'CI Last Change Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `last_change_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `location_name` SET TAGS ('dbx_business_glossary_term' = 'CI Physical Location Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `location_type` SET TAGS ('dbx_business_glossary_term' = 'CI Physical Location Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `location_type` SET TAGS ('dbx_value_regex' = 'Data Center|Plant Floor|Control Room|Server Room|Network Closet|Cloud|Edge|Remote Site|Office|Warehouse');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `mac_address` SET TAGS ('dbx_business_glossary_term' = 'CI MAC Address');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `mac_address` SET TAGS ('dbx_value_regex' = '^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `mac_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `mac_address` SET TAGS ('dbx_pii_device' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `managed_by` SET TAGS ('dbx_business_glossary_term' = 'CI Managed By Team');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `managed_by` SET TAGS ('dbx_value_regex' = 'IT Operations|OT Engineering|Plant Maintenance|Vendor|Cloud Operations|Network Operations|Security Operations');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `manufacturer` SET TAGS ('dbx_business_glossary_term' = 'CI Manufacturer Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `model_number` SET TAGS ('dbx_business_glossary_term' = 'CI Model Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item (CI) Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `network_zone` SET TAGS ('dbx_business_glossary_term' = 'CI Network Security Zone');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `network_zone` SET TAGS ('dbx_value_regex' = 'DMZ|Corporate LAN|OT Network|Industrial DMZ|Management Network|Internet-Facing|Restricted OT|Cloud VPC|Guest Network');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `operating_system` SET TAGS ('dbx_business_glossary_term' = 'CI Operating System');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `owner_name` SET TAGS ('dbx_business_glossary_term' = 'CI Business Owner Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `parent_ci_number` SET TAGS ('dbx_business_glossary_term' = 'Parent CI Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `parent_ci_number` SET TAGS ('dbx_value_regex' = '^CI-[A-Z0-9]{6,20}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `ram_gb` SET TAGS ('dbx_business_glossary_term' = 'CI RAM Capacity (GB)');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `ram_gb` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'CI Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'CI Record Last Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'CI Serial Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `serial_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_device' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `site_code` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Site Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `site_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `software_version` SET TAGS ('dbx_business_glossary_term' = 'CI Software Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'CI Source System');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'ServiceNow|Maximo EAM|SAP S/4HANA|Siemens MindSphere|Manual Entry|Network Discovery|Siemens Opcenter|Infor WMS');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item (CI) Operational Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'In Use|In Stock|In Maintenance|Decommissioned|Retired|Ordered|Pending Installation|Disposed|Unknown');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `storage_gb` SET TAGS ('dbx_business_glossary_term' = 'CI Storage Capacity (GB)');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `storage_gb` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `support_tier` SET TAGS ('dbx_business_glossary_term' = 'CI Support Tier');
ALTER TABLE `manufacturing_ecm`.`technology`.`configuration_item` ALTER COLUMN `support_tier` SET TAGS ('dbx_value_regex' = 'Tier 1|Tier 2|Tier 3|Vendor Supported|End of Life|End of Support');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` SET TAGS ('dbx_subdomain' = 'service_operations');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `service_ticket_id` SET TAGS ('dbx_business_glossary_term' = 'Service Ticket ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `it_service_id` SET TAGS ('dbx_business_glossary_term' = 'It Service Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `technology_change_request_id` SET TAGS ('dbx_business_glossary_term' = 'Change Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `acknowledged_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Ticket Acknowledged Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `acknowledged_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `assigned_team` SET TAGS ('dbx_business_glossary_term' = 'Assigned Support Team');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `assigned_technician` SET TAGS ('dbx_business_glossary_term' = 'Assigned Technician (Resolver)');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `assigned_technician` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `business_impact_description` SET TAGS ('dbx_business_glossary_term' = 'Business Impact Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Ticket Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `ci_type` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item (CI) Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `ci_type` SET TAGS ('dbx_value_regex' = 'server|workstation|network_device|plc|hmi|scada|application|database|printer|mobile_device|ot_sensor|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Ticket Closed Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `closure_code` SET TAGS ('dbx_business_glossary_term' = 'Ticket Closure Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `closure_code` SET TAGS ('dbx_value_regex' = 'resolved_by_support|resolved_by_user|no_fault_found|duplicate|workaround_applied|vendor_resolved|auto_closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `escalation_level` SET TAGS ('dbx_business_glossary_term' = 'Escalation Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `escalation_level` SET TAGS ('dbx_value_regex' = '1|2|3');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `impact` SET TAGS ('dbx_business_glossary_term' = 'Ticket Impact');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `impact` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `opened_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Ticket Opened Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `opened_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Ticket Priority');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'P1|P2|P3|P4');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `production_impact_flag` SET TAGS ('dbx_business_glossary_term' = 'Production Impact Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `production_impact_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `related_problem_number` SET TAGS ('dbx_business_glossary_term' = 'Related Problem Ticket Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `related_problem_number` SET TAGS ('dbx_value_regex' = '^PRB-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `reported_by` SET TAGS ('dbx_business_glossary_term' = 'Reported By (Requester)');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `reported_by` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `reported_by_department` SET TAGS ('dbx_business_glossary_term' = 'Requester Department');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `reported_by_location` SET TAGS ('dbx_business_glossary_term' = 'Requester Site Location');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `reported_by_name` SET TAGS ('dbx_business_glossary_term' = 'Reported By Full Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `reported_by_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `reported_by_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `resolution_description` SET TAGS ('dbx_business_glossary_term' = 'Resolution Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `resolved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Ticket Resolved Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `resolved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `root_cause` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'hardware_failure|software_bug|configuration_error|human_error|network_issue|vendor_issue|capacity|security_breach|ot_it_integration|unknown');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `sla_resolution_target_minutes` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Resolution Target (Minutes)');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `sla_resolution_target_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `sla_response_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Response Breach Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `sla_response_breach_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `sla_response_target_minutes` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Response Target (Minutes)');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `sla_response_target_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `source_channel` SET TAGS ('dbx_business_glossary_term' = 'Ticket Source Channel');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `source_channel` SET TAGS ('dbx_value_regex' = 'phone|email|self_service_portal|chat|automated_alert|walk_in|api');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Ticket Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|in_progress|pending|resolved|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `subcategory` SET TAGS ('dbx_business_glossary_term' = 'Ticket Subcategory');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `ticket_number` SET TAGS ('dbx_business_glossary_term' = 'Ticket Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `ticket_number` SET TAGS ('dbx_value_regex' = '^(INC|SRQ|PRB|CHG)-[0-9]{8}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `ticket_type` SET TAGS ('dbx_business_glossary_term' = 'Ticket Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `ticket_type` SET TAGS ('dbx_value_regex' = 'incident|service_request|problem|change_request');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `urgency` SET TAGS ('dbx_business_glossary_term' = 'Ticket Urgency');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `urgency` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `workaround_applied_flag` SET TAGS ('dbx_business_glossary_term' = 'Workaround Applied Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`service_ticket` ALTER COLUMN `workaround_applied_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` SET TAGS ('dbx_subdomain' = 'service_operations');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `technology_change_request_id` SET TAGS ('dbx_business_glossary_term' = 'Change Request ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `it_service_id` SET TAGS ('dbx_business_glossary_term' = 'It Service Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `procurement_purchase_requisition_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Requisition Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Implementation End Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Implementation Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `affected_cis` SET TAGS ('dbx_business_glossary_term' = 'Affected Configuration Items (CIs)');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `affected_production_lines` SET TAGS ('dbx_business_glossary_term' = 'Affected Production Lines');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|escalated|withdrawn');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Change Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `approver_name` SET TAGS ('dbx_business_glossary_term' = 'Change Approver Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `cab_review_date` SET TAGS ('dbx_business_glossary_term' = 'Change Advisory Board (CAB) Review Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `cab_review_notes` SET TAGS ('dbx_business_glossary_term' = 'Change Advisory Board (CAB) Review Notes');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `cab_review_outcome` SET TAGS ('dbx_business_glossary_term' = 'Change Advisory Board (CAB) Review Outcome');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `cab_review_outcome` SET TAGS ('dbx_value_regex' = 'approved|rejected|deferred|approved_with_conditions|not_required');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `change_category` SET TAGS ('dbx_business_glossary_term' = 'Change Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `change_category` SET TAGS ('dbx_value_regex' = 'infrastructure|application|network|ot_scada|ot_dcs|ot_plc_firmware|database|security|cloud|end_user_computing|middleware');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `change_type` SET TAGS ('dbx_business_glossary_term' = 'Change Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `change_type` SET TAGS ('dbx_value_regex' = 'standard|normal|emergency');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `change_window_end` SET TAGS ('dbx_business_glossary_term' = 'Change Window End Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `change_window_start` SET TAGS ('dbx_business_glossary_term' = 'Change Window Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `closed_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Change Closure Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Change Request Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `impact_assessment_details` SET TAGS ('dbx_business_glossary_term' = 'Impact Assessment Details');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `impact_level` SET TAGS ('dbx_business_glossary_term' = 'Impact Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `impact_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `implementation_plan` SET TAGS ('dbx_business_glossary_term' = 'Implementation Plan');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `implementer_name` SET TAGS ('dbx_business_glossary_term' = 'Change Implementer Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `is_ot_change` SET TAGS ('dbx_business_glossary_term' = 'Operational Technology (OT) Change Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `is_ot_change` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Change Request Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^CR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `post_implementation_review_notes` SET TAGS ('dbx_business_glossary_term' = 'Post-Implementation Review (PIR) Notes');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `post_implementation_review_result` SET TAGS ('dbx_business_glossary_term' = 'Post-Implementation Review (PIR) Result');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `post_implementation_review_result` SET TAGS ('dbx_value_regex' = 'successful|partially_successful|failed|pending_review');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Change Priority');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `related_incident_number` SET TAGS ('dbx_business_glossary_term' = 'Related Incident Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `requester_department` SET TAGS ('dbx_business_glossary_term' = 'Requester Department');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `requester_name` SET TAGS ('dbx_business_glossary_term' = 'Change Requester Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `risk_assessment_details` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Details');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Risk Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'very_high|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `rollback_plan` SET TAGS ('dbx_business_glossary_term' = 'Rollback Plan');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `rollback_required` SET TAGS ('dbx_business_glossary_term' = 'Rollback Required Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `rollback_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `site_code` SET TAGS ('dbx_business_glossary_term' = 'Site Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'sap_s4hana|servicenow|maximo|siemens_mindsphere|siemens_opcenter|manual|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Change Request Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|cab_approved|cab_rejected|scheduled|in_progress|implemented|closed|cancelled|failed');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `submitted_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Change Request Submitted Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`technology_change_request` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Change Request Title');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` SET TAGS ('dbx_subdomain' = 'infrastructure_assets');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `network_device_id` SET TAGS ('dbx_business_glossary_term' = 'Network Device ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `it_asset_id` SET TAGS ('dbx_business_glossary_term' = 'It Asset Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `building` SET TAGS ('dbx_business_glossary_term' = 'Building');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `configuration_backup_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Configuration Backup Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `configuration_backup_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `criticality_level` SET TAGS ('dbx_business_glossary_term' = 'Criticality Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `criticality_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `default_gateway` SET TAGS ('dbx_business_glossary_term' = 'Default Gateway IP Address');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `default_gateway` SET TAGS ('dbx_value_regex' = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `device_type` SET TAGS ('dbx_business_glossary_term' = 'Network Device Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `device_type` SET TAGS ('dbx_value_regex' = 'router|switch|firewall|wireless_access_point|industrial_ethernet_switch|sd_wan_appliance|dmz_component|load_balancer|vpn_concentrator|network_tap|ids_ips|proxy|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `end_of_life_date` SET TAGS ('dbx_business_glossary_term' = 'End of Life (EOL) Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `end_of_life_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `end_of_support_date` SET TAGS ('dbx_business_glossary_term' = 'End of Support (EOS) Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `end_of_support_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `firmware_version` SET TAGS ('dbx_business_glossary_term' = 'Firmware Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `firmware_version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)*(-[a-zA-Z0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `hostname` SET TAGS ('dbx_business_glossary_term' = 'Device Hostname');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `hostname` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `iec62443_security_level` SET TAGS ('dbx_business_glossary_term' = 'IEC 62443 Security Level (SL)');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `iec62443_security_level` SET TAGS ('dbx_value_regex' = 'SL0|SL1|SL2|SL3|SL4');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `installation_date` SET TAGS ('dbx_business_glossary_term' = 'Installation Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `installation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `ip_address` SET TAGS ('dbx_business_glossary_term' = 'IP Address');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `ip_address` SET TAGS ('dbx_value_regex' = '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$|^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `ip_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `ip_address` SET TAGS ('dbx_pii_ip' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `is_managed` SET TAGS ('dbx_business_glossary_term' = 'Is Managed Device Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `is_managed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `is_ot_device` SET TAGS ('dbx_business_glossary_term' = 'Is Operational Technology (OT) Device Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `is_ot_device` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `is_redundant` SET TAGS ('dbx_business_glossary_term' = 'Is Redundant Device Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `is_redundant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Security Audit Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `last_patched_date` SET TAGS ('dbx_business_glossary_term' = 'Last Patched Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `last_patched_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `location_type` SET TAGS ('dbx_business_glossary_term' = 'Location Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `location_type` SET TAGS ('dbx_value_regex' = 'data_center|plant|building|warehouse|office|remote_site|colocation|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `mac_address` SET TAGS ('dbx_business_glossary_term' = 'MAC Address');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `mac_address` SET TAGS ('dbx_value_regex' = '^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `mac_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `mac_address` SET TAGS ('dbx_pii_device' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `management_protocol` SET TAGS ('dbx_business_glossary_term' = 'Management Protocol');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `management_protocol` SET TAGS ('dbx_value_regex' = 'ssh|telnet|snmp_v2|snmp_v3|netconf|restconf|https|http|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `management_vlan` SET TAGS ('dbx_business_glossary_term' = 'Management VLAN (Virtual Local Area Network) ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `management_vlan` SET TAGS ('dbx_value_regex' = '^([1-9]|[1-9][0-9]{1,2}|[1-3][0-9]{3}|40[0-8][0-9]|409[0-4])$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `manufacturer` SET TAGS ('dbx_business_glossary_term' = 'Device Manufacturer');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `model` SET TAGS ('dbx_business_glossary_term' = 'Device Model');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `network_segment` SET TAGS ('dbx_business_glossary_term' = 'Network Segment');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `network_segment` SET TAGS ('dbx_value_regex' = 'it_lan|ot_network|dmz|plant_floor_network|corporate_wan|data_center|guest_network|management_network|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `network_zone_classification` SET TAGS ('dbx_business_glossary_term' = 'Network Zone Classification');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `network_zone_classification` SET TAGS ('dbx_value_regex' = 'safety|control|operations|enterprise|dmz|untrusted|restricted|public');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `operational_status` SET TAGS ('dbx_business_glossary_term' = 'Operational Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `operational_status` SET TAGS ('dbx_value_regex' = 'active|inactive|decommissioned|maintenance|provisioning|failed|retired|spare');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `os_version` SET TAGS ('dbx_business_glossary_term' = 'Operating System (OS) Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `purchase_date` SET TAGS ('dbx_business_glossary_term' = 'Purchase Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `purchase_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `purdue_model_level` SET TAGS ('dbx_business_glossary_term' = 'Purdue Model Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `purdue_model_level` SET TAGS ('dbx_value_regex' = '^[0-4]$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `room_rack_location` SET TAGS ('dbx_business_glossary_term' = 'Room and Rack Location');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Device Serial Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `serial_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `serial_number` SET TAGS ('dbx_pii_device' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `site_code` SET TAGS ('dbx_business_glossary_term' = 'Site Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `snmp_community_string_encrypted` SET TAGS ('dbx_business_glossary_term' = 'Simple Network Management Protocol (SNMP) Community String (Encrypted)');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `snmp_community_string_encrypted` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `subnet_mask` SET TAGS ('dbx_business_glossary_term' = 'Subnet Mask');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `subnet_mask` SET TAGS ('dbx_value_regex' = '^((255|254|252|248|240|224|192|128|0).){3}(255|254|252|248|240|224|192|128|0)$');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Warranty Expiry Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`network_device` ALTER COLUMN `warranty_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` SET TAGS ('dbx_subdomain' = 'infrastructure_assets');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `software_license_id` SET TAGS ('dbx_business_glossary_term' = 'Software License ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `application_id` SET TAGS ('dbx_business_glossary_term' = 'Application Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `asset_register_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Register Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `it_contract_id` SET TAGS ('dbx_business_glossary_term' = 'It Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `it_vendor_id` SET TAGS ('dbx_business_glossary_term' = 'It Vendor Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `procurement_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `annual_maintenance_cost` SET TAGS ('dbx_business_glossary_term' = 'Annual Maintenance Cost');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `annual_maintenance_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `assigned_department` SET TAGS ('dbx_business_glossary_term' = 'Assigned Department');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `assigned_site` SET TAGS ('dbx_business_glossary_term' = 'Assigned Site');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `auto_renewal` SET TAGS ('dbx_business_glossary_term' = 'Auto-Renewal Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `auto_renewal` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `available_entitlements` SET TAGS ('dbx_business_glossary_term' = 'Available Entitlements');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `available_entitlements` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `capex_opex_classification` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) / Operational Expenditure (OPEX) Classification');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `capex_opex_classification` SET TAGS ('dbx_value_regex' = 'capex|opex');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Software Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'erp|mes|plm|scada|cad_cam|operating_system|database|middleware|security|analytics|collaboration|itsm|crm|wms|iot_platform|development_tools|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Compliance Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|over_deployed|under_utilized|at_risk|unverified');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `consumed_entitlements` SET TAGS ('dbx_business_glossary_term' = 'Consumed Entitlements');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `consumed_entitlements` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `deployment_type` SET TAGS ('dbx_business_glossary_term' = 'Deployment Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `deployment_type` SET TAGS ('dbx_value_regex' = 'on_premise|cloud_saas|cloud_paas|cloud_iaas|hybrid|hosted');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'License Effective Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'License Expiry Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `invoice_reference` SET TAGS ('dbx_business_glossary_term' = 'Invoice Reference Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `is_downgrade_rights` SET TAGS ('dbx_business_glossary_term' = 'Downgrade Rights Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `is_downgrade_rights` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `is_transferable` SET TAGS ('dbx_business_glossary_term' = 'Is Transferable Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `is_transferable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `legal_entity` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `license_cost` SET TAGS ('dbx_business_glossary_term' = 'License Cost');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `license_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `license_key` SET TAGS ('dbx_business_glossary_term' = 'License Key');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `license_key` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `license_metric` SET TAGS ('dbx_business_glossary_term' = 'License Metric');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `license_metric` SET TAGS ('dbx_value_regex' = 'per_user|per_device|per_core|per_processor|per_server|per_instance|per_seat|concurrent_users|site_wide|enterprise_wide');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `license_owner` SET TAGS ('dbx_business_glossary_term' = 'License Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `license_type` SET TAGS ('dbx_business_glossary_term' = 'License Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `license_type` SET TAGS ('dbx_value_regex' = 'perpetual|subscription|concurrent|named_user|site|oem|trial|open_source|freeware|volume');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `maintenance_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Maintenance and Support Expiry Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `maintenance_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'License Notes');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `purchase_date` SET TAGS ('dbx_business_glossary_term' = 'Purchase Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `purchase_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `renewal_date` SET TAGS ('dbx_business_glossary_term' = 'License Renewal Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `renewal_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Period (Days)');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `software_edition` SET TAGS ('dbx_business_glossary_term' = 'Software Edition');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `software_version` SET TAGS ('dbx_business_glossary_term' = 'Software Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'License Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|expired|pending_renewal|terminated|suspended|in_procurement|retired');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `total_entitlements` SET TAGS ('dbx_business_glossary_term' = 'Total Entitlements');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `total_entitlements` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`software_license` ALTER COLUMN `vendor_part_number` SET TAGS ('dbx_business_glossary_term' = 'Vendor Part Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` SET TAGS ('dbx_subdomain' = 'portfolio_management');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `it_project_id` SET TAGS ('dbx_business_glossary_term' = 'IT Project ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `digital_initiative_id` SET TAGS ('dbx_business_glossary_term' = 'Digital Initiative Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `it_contract_id` SET TAGS ('dbx_business_glossary_term' = 'It Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `it_vendor_id` SET TAGS ('dbx_business_glossary_term' = 'It Vendor Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `sales_opportunity_id` SET TAGS ('dbx_business_glossary_term' = 'Opportunity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_business_glossary_term' = 'Actual End Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `affected_systems` SET TAGS ('dbx_business_glossary_term' = 'Affected Systems');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `approved_budget` SET TAGS ('dbx_business_glossary_term' = 'Approved Budget');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `approved_budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `budget_consumed` SET TAGS ('dbx_business_glossary_term' = 'Budget Consumed');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `budget_consumed` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `budget_currency` SET TAGS ('dbx_business_glossary_term' = 'Budget Currency Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `budget_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `business_case_ref` SET TAGS ('dbx_business_glossary_term' = 'Business Case Reference');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `business_owner` SET TAGS ('dbx_business_glossary_term' = 'Business Owner Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `capex_amount` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) Amount');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `capex_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `change_request_count` SET TAGS ('dbx_business_glossary_term' = 'Change Request Count');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `change_request_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `compliance_requirement` SET TAGS ('dbx_business_glossary_term' = 'Compliance Requirement');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `delivery_methodology` SET TAGS ('dbx_business_glossary_term' = 'Project Delivery Methodology');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `delivery_methodology` SET TAGS ('dbx_value_regex' = 'Waterfall|Agile|SAFe|Hybrid|PRINCE2|Scrum|Kanban');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `deployment_environment` SET TAGS ('dbx_business_glossary_term' = 'Deployment Environment');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `deployment_environment` SET TAGS ('dbx_value_regex' = 'On-Premise|Cloud|Hybrid|Edge|SaaS|PaaS|IaaS');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'IT Project Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `go_live_date` SET TAGS ('dbx_business_glossary_term' = 'Go-Live Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `go_live_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `health_indicator` SET TAGS ('dbx_business_glossary_term' = 'IT Project Health Indicator (RAG Status)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `health_indicator` SET TAGS ('dbx_value_regex' = 'Green|Amber|Red');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `manager` SET TAGS ('dbx_business_glossary_term' = 'IT Project Manager Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'IT Project Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `opex_amount` SET TAGS ('dbx_business_glossary_term' = 'Operational Expenditure (OPEX) Amount');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `opex_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `phase` SET TAGS ('dbx_business_glossary_term' = 'IT Project Phase');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `phase` SET TAGS ('dbx_value_regex' = 'Initiation|Planning|Execution|Monitoring & Control|Closure');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `planned_end_date` SET TAGS ('dbx_business_glossary_term' = 'Planned End Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `planned_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `post_go_live_support_end_date` SET TAGS ('dbx_business_glossary_term' = 'Post Go-Live Support End Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `post_go_live_support_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'IT Project Priority');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'Critical|High|Medium|Low');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `project_code` SET TAGS ('dbx_business_glossary_term' = 'IT Project Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `project_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,4}-[0-9]{4,8}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `project_type` SET TAGS ('dbx_business_glossary_term' = 'IT Project Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `project_type` SET TAGS ('dbx_value_regex' = 'ERP Implementation|ERP Upgrade|MES Implementation|IIoT Platform Deployment|OT/IT Convergence|Cybersecurity Program|Cloud Migration|Infrastructure Upgrade|Application Development|Digital Transformation|Network Infrastructure|Data & Analytics|Compli...');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `revised_end_date` SET TAGS ('dbx_business_glossary_term' = 'Revised End Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `revised_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'IT Project Risk Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'Critical|High|Medium|Low');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `roi_target_percent` SET TAGS ('dbx_business_glossary_term' = 'Return on Investment (ROI) Target Percentage');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `roi_target_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `sponsor_name` SET TAGS ('dbx_business_glossary_term' = 'IT Project Sponsor Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'IT Project Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'Draft|Approved|Active|On Hold|Cancelled|Completed|Archived');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'Enterprise Applications|Manufacturing Execution|IIoT & OT|Cybersecurity|Cloud & Infrastructure|Data & Analytics|Network & Connectivity|Workplace Technology|Digital Twin|IT/OT Convergence');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` SET TAGS ('dbx_subdomain' = 'portfolio_management');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `it_project_milestone_id` SET TAGS ('dbx_business_glossary_term' = 'IT Project Milestone ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `it_project_id` SET TAGS ('dbx_business_glossary_term' = 'It Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `acceptance_criteria` SET TAGS ('dbx_business_glossary_term' = 'Milestone Acceptance Criteria');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `actual_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Milestone Achievement Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `actual_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `associated_system` SET TAGS ('dbx_business_glossary_term' = 'Associated IT System');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `budget_impact` SET TAGS ('dbx_business_glossary_term' = 'Budget Impact Classification');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `budget_impact` SET TAGS ('dbx_value_regex' = 'no_impact|minor_impact|moderate_impact|significant_impact|critical_impact');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `completion_percentage` SET TAGS ('dbx_business_glossary_term' = 'Milestone Completion Percentage');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `completion_percentage` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `delay_category` SET TAGS ('dbx_business_glossary_term' = 'Delay Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `delay_category` SET TAGS ('dbx_value_regex' = 'resource_constraint|scope_change|technical_issue|vendor_dependency|budget_constraint|regulatory_requirement|organizational_change|external_factor|not_applicable');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `delay_reason` SET TAGS ('dbx_business_glossary_term' = 'Milestone Delay Reason');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `deliverables` SET TAGS ('dbx_business_glossary_term' = 'Associated Deliverables');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `dependency_description` SET TAGS ('dbx_business_glossary_term' = 'Milestone Dependency Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Milestone Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `forecast_date` SET TAGS ('dbx_business_glossary_term' = 'Forecasted Milestone Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `forecast_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `is_critical_path` SET TAGS ('dbx_business_glossary_term' = 'Critical Path Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `is_critical_path` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `is_executive_reportable` SET TAGS ('dbx_business_glossary_term' = 'Executive Reportable Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `is_executive_reportable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `last_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `milestone_category` SET TAGS ('dbx_business_glossary_term' = 'Milestone Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `milestone_category` SET TAGS ('dbx_value_regex' = 'technical|business|regulatory|contractual|financial|governance');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `milestone_code` SET TAGS ('dbx_business_glossary_term' = 'Milestone Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `milestone_code` SET TAGS ('dbx_value_regex' = '^MLT-[A-Z0-9]{4,12}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `milestone_type` SET TAGS ('dbx_business_glossary_term' = 'Milestone Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `milestone_type` SET TAGS ('dbx_value_regex' = 'go_live|uat_completion|cutover|phase_gate|design_freeze|pilot_launch|training_completion|data_migration|system_integration|project_kickoff|project_closure|steering_committee_review|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Milestone Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Milestone Notes');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `phase_name` SET TAGS ('dbx_business_glossary_term' = 'Project Phase Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `phase_sequence` SET TAGS ('dbx_business_glossary_term' = 'Phase Sequence Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `planned_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Milestone Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `planned_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Milestone Priority');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `program_name` SET TAGS ('dbx_business_glossary_term' = 'Digital Transformation Program Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Business Region');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `responsible_owner` SET TAGS ('dbx_business_glossary_term' = 'Milestone Responsible Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `responsible_owner_role` SET TAGS ('dbx_business_glossary_term' = 'Milestone Owner Role');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `revised_planned_date` SET TAGS ('dbx_business_glossary_term' = 'Revised Planned Milestone Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `revised_planned_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Milestone Risk Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|none');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `schedule_variance_days` SET TAGS ('dbx_business_glossary_term' = 'Schedule Variance (Days)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `sign_off_authority` SET TAGS ('dbx_business_glossary_term' = 'Milestone Sign-Off Authority');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `sign_off_comments` SET TAGS ('dbx_business_glossary_term' = 'Milestone Sign-Off Comments');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `sign_off_date` SET TAGS ('dbx_business_glossary_term' = 'Milestone Sign-Off Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `sign_off_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Milestone Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_project_milestone` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|achieved|delayed|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` SET TAGS ('dbx_subdomain' = 'portfolio_management');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `digital_initiative_id` SET TAGS ('dbx_business_glossary_term' = 'Digital Initiative ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `account_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Account Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `it_vendor_id` SET TAGS ('dbx_business_glossary_term' = 'It Vendor Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Sponsor Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_business_glossary_term' = 'Actual End Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `actual_spend` SET TAGS ('dbx_business_glossary_term' = 'Actual Spend');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `actual_spend` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `approved_budget` SET TAGS ('dbx_business_glossary_term' = 'Approved Budget');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `approved_budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `change_management_approach` SET TAGS ('dbx_business_glossary_term' = 'Change Management Approach');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `change_management_approach` SET TAGS ('dbx_value_regex' = 'Agile|Waterfall|Hybrid|SAFe|PRINCE2');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `deployment_scope` SET TAGS ('dbx_business_glossary_term' = 'Deployment Scope');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `deployment_scope` SET TAGS ('dbx_value_regex' = 'Global|Regional|Country|Site|Plant|Department|Line');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Digital Initiative Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `executive_sponsor` SET TAGS ('dbx_business_glossary_term' = 'Executive Sponsor Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `expected_cost_reduction_percent` SET TAGS ('dbx_business_glossary_term' = 'Expected Cost Reduction Percent');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `expected_cycle_time_reduction_percent` SET TAGS ('dbx_business_glossary_term' = 'Expected Cycle Time Reduction Percent');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `expected_oee_improvement_percent` SET TAGS ('dbx_business_glossary_term' = 'Expected Overall Equipment Effectiveness (OEE) Improvement Percent');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `expected_roi_percent` SET TAGS ('dbx_business_glossary_term' = 'Expected Return on Investment (ROI) Percent');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `expected_roi_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `governance_board` SET TAGS ('dbx_business_glossary_term' = 'Governance Board');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `initiative_code` SET TAGS ('dbx_business_glossary_term' = 'Digital Initiative Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `initiative_code` SET TAGS ('dbx_value_regex' = '^DI-[A-Z0-9]{4,12}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `initiative_type` SET TAGS ('dbx_business_glossary_term' = 'Digital Initiative Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `initiative_type` SET TAGS ('dbx_value_regex' = 'IIoT_Deployment|Smart_Factory|Digital_Twin|AI_ML_Adoption|Cloud_Migration|Connected_Worker|Cybersecurity|Data_Analytics|Automation|ERP_Transformation|MES_Implementation|PLM_Modernization|OT_IT_Convergence|Other');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `investment_category` SET TAGS ('dbx_business_glossary_term' = 'Investment Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `investment_category` SET TAGS ('dbx_value_regex' = 'CAPEX|OPEX|Mixed');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `kpi_targets` SET TAGS ('dbx_business_glossary_term' = 'Key Performance Indicator (KPI) Targets');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Review Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `last_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `maturity_level` SET TAGS ('dbx_business_glossary_term' = 'Digital Maturity Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `maturity_level` SET TAGS ('dbx_value_regex' = 'Initial|Developing|Defined|Managed|Optimizing');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Digital Initiative Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `planned_end_date` SET TAGS ('dbx_business_glossary_term' = 'Planned End Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `planned_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Start Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Initiative Priority');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'Critical|High|Medium|Low');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `program_manager` SET TAGS ('dbx_business_glossary_term' = 'Program Manager Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `regulatory_compliance_flags` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flags');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Initiative Risk Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'Critical|High|Medium|Low');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `roadmap_phase` SET TAGS ('dbx_business_glossary_term' = 'Implementation Roadmap Phase');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `roadmap_phase` SET TAGS ('dbx_value_regex' = 'Phase_1_Foundation|Phase_2_Pilot|Phase_3_Scale|Phase_4_Optimize|Phase_5_Sustain');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `sponsoring_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Sponsoring Business Unit');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Digital Initiative Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'Ideation|Approved|In_Planning|In_Execution|On_Hold|Completed|Cancelled|Deferred');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `strategic_objective` SET TAGS ('dbx_business_glossary_term' = 'Strategic Objective Alignment');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `strategic_objective` SET TAGS ('dbx_value_regex' = 'OEE_Improvement|Cost_Reduction|Cycle_Time_Reduction|Quality_Improvement|Safety_Enhancement|Sustainability|Revenue_Growth|Customer_Experience|Workforce_Productivity|Supply_Chain_Resilience|Regulatory_Compliance|Other');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `systems_impacted` SET TAGS ('dbx_business_glossary_term' = 'Systems Impacted');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `target_business_processes` SET TAGS ('dbx_business_glossary_term' = 'Target Business Processes');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `target_countries` SET TAGS ('dbx_business_glossary_term' = 'Target Countries');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `target_countries` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}(,[A-Z]{3})*$');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `target_sites` SET TAGS ('dbx_business_glossary_term' = 'Target Sites');
ALTER TABLE `manufacturing_ecm`.`technology`.`digital_initiative` ALTER COLUMN `technology_domains` SET TAGS ('dbx_business_glossary_term' = 'Technology Domains Impacted');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` SET TAGS ('dbx_subdomain' = 'portfolio_management');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `iiot_platform_id` SET TAGS ('dbx_business_glossary_term' = 'Industrial Internet of Things (IIoT) Platform ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `it_contract_id` SET TAGS ('dbx_business_glossary_term' = 'It Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `it_vendor_id` SET TAGS ('dbx_business_glossary_term' = 'It Vendor Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `annual_license_cost` SET TAGS ('dbx_business_glossary_term' = 'Annual Platform License Cost');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `annual_license_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `authentication_method` SET TAGS ('dbx_business_glossary_term' = 'Authentication Method');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `authentication_method` SET TAGS ('dbx_value_regex' = 'certificate-based|OAuth2|API-key|username-password|MFA|SAML|Other');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `connected_device_count` SET TAGS ('dbx_business_glossary_term' = 'Connected Device Count');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `connected_device_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_business_glossary_term' = 'Platform Contract End Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_business_glossary_term' = 'Platform Contract Start Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `data_classification` SET TAGS ('dbx_business_glossary_term' = 'Data Classification Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `data_classification` SET TAGS ('dbx_value_regex' = 'restricted|confidential|internal|public');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `data_ingestion_rate_per_sec` SET TAGS ('dbx_business_glossary_term' = 'Data Ingestion Rate (Messages Per Second)');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `data_retention_days` SET TAGS ('dbx_business_glossary_term' = 'Data Retention Period (Days)');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `data_retention_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `decommission_date` SET TAGS ('dbx_business_glossary_term' = 'Platform Decommission Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `decommission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `deployment_model` SET TAGS ('dbx_business_glossary_term' = 'IIoT Platform Deployment Model');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `deployment_model` SET TAGS ('dbx_value_regex' = 'cloud|edge|hybrid|on-premise');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `edge_node_count` SET TAGS ('dbx_business_glossary_term' = 'Edge Node Count');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `edge_node_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `encryption_standard` SET TAGS ('dbx_business_glossary_term' = 'Data Encryption Standard');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `encryption_standard` SET TAGS ('dbx_value_regex' = 'AES-256|TLS-1.2|TLS-1.3|AES-128|None|Other');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `environment_type` SET TAGS ('dbx_business_glossary_term' = 'IIoT Platform Environment Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `environment_type` SET TAGS ('dbx_value_regex' = 'production|staging|development|disaster_recovery|test');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `erp_integration_enabled` SET TAGS ('dbx_business_glossary_term' = 'Enterprise Resource Planning (ERP) Integration Enabled');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `erp_integration_enabled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `go_live_date` SET TAGS ('dbx_business_glossary_term' = 'Platform Go-Live Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `go_live_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `historian_integration_enabled` SET TAGS ('dbx_business_glossary_term' = 'Historian Integration Enabled');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `historian_integration_enabled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `integration_targets` SET TAGS ('dbx_business_glossary_term' = 'Integration Target Systems');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `last_patch_date` SET TAGS ('dbx_business_glossary_term' = 'Last Security Patch Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `last_patch_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `license_currency_code` SET TAGS ('dbx_business_glossary_term' = 'License Currency Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `license_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `max_device_capacity` SET TAGS ('dbx_business_glossary_term' = 'Maximum Device Capacity');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `max_device_capacity` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `mes_integration_enabled` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Execution System (MES) Integration Enabled');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `mes_integration_enabled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `next_scheduled_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Maintenance Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `next_scheduled_maintenance_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `ot_it_convergence_enabled` SET TAGS ('dbx_business_glossary_term' = 'Operational Technology (OT) / Information Technology (IT) Convergence Enabled');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `ot_it_convergence_enabled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `plant_site_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Site Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `platform_code` SET TAGS ('dbx_business_glossary_term' = 'IIoT Platform Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `platform_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `platform_name` SET TAGS ('dbx_business_glossary_term' = 'IIoT Platform Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `platform_owner` SET TAGS ('dbx_business_glossary_term' = 'IIoT Platform Business Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `platform_version` SET TAGS ('dbx_business_glossary_term' = 'IIoT Platform Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `platform_version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `predictive_analytics_enabled` SET TAGS ('dbx_business_glossary_term' = 'Predictive Analytics Capability Enabled');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `predictive_analytics_enabled` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `primary_protocol` SET TAGS ('dbx_business_glossary_term' = 'Primary Communication Protocol');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `primary_protocol` SET TAGS ('dbx_value_regex' = 'MQTT|OPC-UA|AMQP|Modbus|PROFINET|REST-HTTP|KAFKA|SPARKPLUG-B|Other');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `region_name` SET TAGS ('dbx_business_glossary_term' = 'Deployment Region Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `security_zone` SET TAGS ('dbx_business_glossary_term' = 'IEC 62443 Security Zone');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `security_zone` SET TAGS ('dbx_value_regex' = 'OT|IT|DMZ|cloud|hybrid');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'IIoT Platform Operational Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|decommissioned|under_maintenance|pilot|planned');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `supported_protocols` SET TAGS ('dbx_business_glossary_term' = 'Supported Communication Protocols');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `technical_contact` SET TAGS ('dbx_business_glossary_term' = 'IIoT Platform Technical Contact');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `uptime_sla_percent` SET TAGS ('dbx_business_glossary_term' = 'Uptime Service Level Agreement (SLA) Percentage');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `uptime_sla_percent` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `vendor_support_tier` SET TAGS ('dbx_business_glossary_term' = 'Vendor Support Tier');
ALTER TABLE `manufacturing_ecm`.`technology`.`iiot_platform` ALTER COLUMN `vendor_support_tier` SET TAGS ('dbx_value_regex' = 'basic|standard|premium|enterprise|24x7');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` SET TAGS ('dbx_subdomain' = 'vendor_relations');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `it_vendor_id` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `annual_spend_budget` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Annual Spend Budget');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `annual_spend_budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Contract End Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `contract_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Contract Reference Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `contract_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Contract Start Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `contract_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `contract_status` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Contract Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `contract_status` SET TAGS ('dbx_value_regex' = 'active|expired|pending_renewal|terminated|under_negotiation|not_contracted');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Billing Currency Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `data_processing_agreement_date` SET TAGS ('dbx_business_glossary_term' = 'Data Processing Agreement (DPA) Signed Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `data_processing_agreement_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `data_processing_agreement_status` SET TAGS ('dbx_business_glossary_term' = 'Data Processing Agreement (DPA) Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `data_processing_agreement_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|signed|expired|under_review');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `duns_number` SET TAGS ('dbx_business_glossary_term' = 'Dun & Bradstreet (DUNS) Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `duns_number` SET TAGS ('dbx_value_regex' = '^[0-9]{9}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `geographic_coverage` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Geographic Coverage');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `headquarters_city` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Headquarters City');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `headquarters_country_code` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Headquarters Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `headquarters_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `is_ot_vendor` SET TAGS ('dbx_business_glossary_term' = 'Operational Technology (OT) Vendor Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `is_ot_vendor` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `is_preferred_vendor` SET TAGS ('dbx_business_glossary_term' = 'Preferred IT Vendor Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `is_preferred_vendor` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `is_strategic_partner` SET TAGS ('dbx_business_glossary_term' = 'Strategic IT Partner Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `is_strategic_partner` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Last Review Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `last_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `nda_status` SET TAGS ('dbx_business_glossary_term' = 'Non-Disclosure Agreement (NDA) Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `nda_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|signed|expired');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `onboarding_date` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Onboarding Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `onboarding_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `parent_vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Parent Vendor Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Payment Terms');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'net_15|net_30|net_45|net_60|net_90|immediate|custom');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Primary Vendor Contact Email');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Vendor Contact Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Vendor Contact Phone Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_value_regex' = '^+?[0-9s-().]{7,20}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `security_assessment_date` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Security Assessment Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `security_assessment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `security_assessment_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Security Assessment Expiry Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `security_assessment_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `security_assessment_status` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Security Assessment Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `security_assessment_status` SET TAGS ('dbx_value_regex' = 'not_assessed|in_progress|passed|failed|conditionally_approved|expired');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'sap_ariba|salesforce|manual|sap_s4hana|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `spend_category` SET TAGS ('dbx_business_glossary_term' = 'IT Spend Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `spend_category` SET TAGS ('dbx_value_regex' = 'infrastructure|software_licenses|cloud_services|professional_services|managed_services|telecom|security|ot_technology|end_user_computing|data_analytics');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_approval|suspended|blacklisted|under_review');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `support_coverage_hours` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Support Coverage Hours');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `support_coverage_hours` SET TAGS ('dbx_value_regex' = '8x5|12x5|16x5|24x7|business_hours_only|custom');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_business_glossary_term' = 'Tax Identification Number (TIN)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `tax_identification_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `trading_name` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Trading Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `vendor_code` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `vendor_code` SET TAGS ('dbx_value_regex' = '^ITV-[A-Z0-9]{4,12}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `vendor_risk_rating` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Risk Rating');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `vendor_risk_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `vendor_tier` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Tier Classification');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `vendor_tier` SET TAGS ('dbx_value_regex' = 'tier_1|tier_2|tier_3');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `vendor_type` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `vendor_type` SET TAGS ('dbx_value_regex' = 'hardware_oem|software_vendor|managed_service_provider|system_integrator|cloud_provider|ot_vendor|telecom_provider|consulting_firm|staffing_agency|value_added_reseller');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'IT Vendor Website URL');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_vendor` ALTER COLUMN `website_url` SET TAGS ('dbx_value_regex' = '^https?://[^s/$.?#].[^s]*$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` SET TAGS ('dbx_subdomain' = 'vendor_relations');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `it_contract_id` SET TAGS ('dbx_business_glossary_term' = 'IT Contract ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `channel_partner_id` SET TAGS ('dbx_business_glossary_term' = 'Channel Partner Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `it_vendor_id` SET TAGS ('dbx_business_glossary_term' = 'It Vendor Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `annual_value` SET TAGS ('dbx_business_glossary_term' = 'Annual Contract Value');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `annual_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_business_glossary_term' = 'Auto-Renewal Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `auto_renewal_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `availability_target_pct` SET TAGS ('dbx_business_glossary_term' = 'Contracted Availability Target (%)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `availability_target_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `business_owner` SET TAGS ('dbx_business_glossary_term' = 'Business Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `capex_opex_classification` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) / Operational Expenditure (OPEX) Classification');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `capex_opex_classification` SET TAGS ('dbx_value_regex' = 'capex|opex|mixed');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_category` SET TAGS ('dbx_business_glossary_term' = 'IT Contract Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_category` SET TAGS ('dbx_value_regex' = 'it_infrastructure|application_software|cloud_and_saas|ot_and_iiot|cybersecurity|end_user_computing|telecommunications|professional_services|data_and_analytics');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_document_ref` SET TAGS ('dbx_business_glossary_term' = 'Contract Document Reference');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_number` SET TAGS ('dbx_business_glossary_term' = 'IT Contract Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_number` SET TAGS ('dbx_value_regex' = '^ITC-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_owner` SET TAGS ('dbx_business_glossary_term' = 'IT Contract Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_owner_email` SET TAGS ('dbx_business_glossary_term' = 'IT Contract Owner Email Address');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_owner_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_owner_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_owner_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_business_glossary_term' = 'IT Contract Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_type` SET TAGS ('dbx_value_regex' = 'software_maintenance|hardware_support|managed_service|cloud_service_agreement|saas_subscription|ot_vendor_support|professional_services|network_infrastructure|cybersecurity_service|license_agreement|outsourcing');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_value` SET TAGS ('dbx_business_glossary_term' = 'Total Contract Value');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `contract_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Contract Currency Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `cybersecurity_review_status` SET TAGS ('dbx_business_glossary_term' = 'Cybersecurity Review Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `cybersecurity_review_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|in_progress|approved|conditionally_approved|rejected');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `data_processing_agreement_flag` SET TAGS ('dbx_business_glossary_term' = 'Data Processing Agreement (DPA) Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `data_processing_agreement_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Contract End Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `governing_law_country` SET TAGS ('dbx_business_glossary_term' = 'Governing Law Country');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `governing_law_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `is_cloud_contract` SET TAGS ('dbx_business_glossary_term' = 'Cloud Contract Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `is_cloud_contract` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `is_ot_contract` SET TAGS ('dbx_business_glossary_term' = 'Operational Technology (OT) Contract Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `is_ot_contract` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `notice_period_days` SET TAGS ('dbx_business_glossary_term' = 'Contract Notice Period (Days)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `notice_period_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `owning_department` SET TAGS ('dbx_business_glossary_term' = 'Owning Department');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `payment_schedule` SET TAGS ('dbx_business_glossary_term' = 'Payment Schedule');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `payment_schedule` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annual|annual|upfront|milestone_based|usage_based');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `payment_terms` SET TAGS ('dbx_business_glossary_term' = 'Payment Terms');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `payment_terms` SET TAGS ('dbx_value_regex' = 'net_30|net_45|net_60|net_90|due_on_receipt|prepaid');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Contract Region');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `renewal_status` SET TAGS ('dbx_business_glossary_term' = 'Contract Renewal Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `renewal_status` SET TAGS ('dbx_value_regex' = 'not_due|under_review|renewal_approved|renewal_declined|renewed|terminated|pending_negotiation');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `renewal_term_months` SET TAGS ('dbx_business_glossary_term' = 'Renewal Term Duration (Months)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `renewal_term_months` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `signed_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Signed Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `signed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `sla_terms_summary` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Terms Summary');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard|custom');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Start Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Contract Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|pending_approval|active|expired|terminated|suspended|renewed|cancelled');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Contract Termination Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `termination_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Contract Termination Reason');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `termination_reason` SET TAGS ('dbx_value_regex' = 'vendor_default|mutual_agreement|cost_reduction|technology_replacement|merger_acquisition|regulatory_non_compliance|service_failure|business_closure|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Contract Title');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_contract` ALTER COLUMN `vendor_contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Vendor Contract Reference Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` SET TAGS ('dbx_subdomain' = 'vendor_relations');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `it_budget_id` SET TAGS ('dbx_business_glossary_term' = 'IT Budget ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `actual_spend_amount` SET TAGS ('dbx_business_glossary_term' = 'IT Actual Spend Amount');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `actual_spend_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Approval Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Approval Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|conditionally_approved|escalated');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `approved_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Approved IT Budget Amount');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `approved_budget_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `approver_name` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Approver Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_category` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_category` SET TAGS ('dbx_value_regex' = 'hardware|software_licenses|cloud_services|managed_services|professional_services|support_contracts|internal_labor|training|telecom|facilities|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_code` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_code` SET TAGS ('dbx_value_regex' = '^IT-BDG-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_owner` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Period End Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_period_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Period Start Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_period_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_type` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Type — Capital Expenditure (CAPEX) / Operational Expenditure (OPEX)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_type` SET TAGS ('dbx_value_regex' = 'CAPEX|OPEX');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_version` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_version` SET TAGS ('dbx_value_regex' = 'original|revised_1|revised_2|revised_3|final');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_year` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Year');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `budget_year` SET TAGS ('dbx_value_regex' = '^(20[2-9][0-9]|2[1-9][0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `committed_amount` SET TAGS ('dbx_business_glossary_term' = 'IT Committed Amount');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `committed_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `contingency_amount` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Contingency Amount');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `contingency_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `contract_reference` SET TAGS ('dbx_business_glossary_term' = 'Contract Reference');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `cost_center_name` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `forecast_amount` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Forecast Amount');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `forecast_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_value_regex' = '^[0-9]{6,10}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `is_contingency_included` SET TAGS ('dbx_business_glossary_term' = 'Contingency Budget Included Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `is_contingency_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `is_multi_year` SET TAGS ('dbx_business_glossary_term' = 'Multi-Year Budget Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `is_multi_year` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `it_domain` SET TAGS ('dbx_business_glossary_term' = 'IT Domain');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `it_domain` SET TAGS ('dbx_value_regex' = 'infrastructure|applications|ot_it_convergence|cybersecurity|digital_transformation|end_user_computing|data_analytics|cloud|telecommunications|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `last_forecast_date` SET TAGS ('dbx_business_glossary_term' = 'Last Forecast Update Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `last_forecast_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `legal_entity` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Notes');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `program_name` SET TAGS ('dbx_business_glossary_term' = 'IT Program Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `region` SET TAGS ('dbx_value_regex' = 'north_america|europe|asia_pacific|latin_america|middle_east_africa|global');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|under_review|approved|active|on_hold|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `strategic_initiative` SET TAGS ('dbx_business_glossary_term' = 'Strategic Initiative');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `variance_amount` SET TAGS ('dbx_business_glossary_term' = 'IT Budget Variance Amount');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `variance_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_budget` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` SET TAGS ('dbx_subdomain' = 'service_operations');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `sla_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Definition ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `it_service_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `applicable_business_units` SET TAGS ('dbx_business_glossary_term' = 'Applicable Business Units');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `applicable_regions` SET TAGS ('dbx_business_glossary_term' = 'Applicable Regions');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'SLA Approved By');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'SLA Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `breach_threshold` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Threshold');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'SLA Definition Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'SLA Effective Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `escalation_level_1_minutes` SET TAGS ('dbx_business_glossary_term' = 'SLA Escalation Level 1 Threshold (Minutes)');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `escalation_level_2_minutes` SET TAGS ('dbx_business_glossary_term' = 'SLA Escalation Level 2 Threshold (Minutes)');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `escalation_level_3_minutes` SET TAGS ('dbx_business_glossary_term' = 'SLA Escalation Level 3 Threshold (Minutes)');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `exclusion_windows` SET TAGS ('dbx_business_glossary_term' = 'SLA Exclusion Windows');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'SLA Expiry Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `is_critical_sla` SET TAGS ('dbx_business_glossary_term' = 'Critical SLA Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `is_critical_sla` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `is_ot_sla` SET TAGS ('dbx_business_glossary_term' = 'Operational Technology (OT) SLA Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `is_ot_sla` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `last_review_date` SET TAGS ('dbx_business_glossary_term' = 'SLA Last Review Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `last_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_business_glossary_term' = 'SLA Measurement Unit');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `measurement_unit` SET TAGS ('dbx_value_regex' = 'percent|minutes|hours|seconds|days|count|requests_per_second');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `measurement_window` SET TAGS ('dbx_business_glossary_term' = 'SLA Measurement Window');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `measurement_window` SET TAGS ('dbx_value_regex' = 'hourly|daily|weekly|monthly|quarterly|annually|rolling_7_days|rolling_30_days|rolling_90_days');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `metric_type` SET TAGS ('dbx_business_glossary_term' = 'SLA Metric Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `metric_type` SET TAGS ('dbx_value_regex' = 'availability|response_time|resolution_time|mttr|mtbf|throughput|error_rate|recovery_time_objective|recovery_point_objective');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'SLA Definition Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'SLA Next Review Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `penalty_clause` SET TAGS ('dbx_business_glossary_term' = 'SLA Penalty Clause');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `penalty_clause` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `priority_tier` SET TAGS ('dbx_business_glossary_term' = 'Priority Tier Applicability');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `priority_tier` SET TAGS ('dbx_value_regex' = 'P1|P2|P3|P4|all');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `regulatory_compliance_scope` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Scope');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `reporting_frequency` SET TAGS ('dbx_business_glossary_term' = 'SLA Reporting Frequency');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `reporting_frequency` SET TAGS ('dbx_value_regex' = 'real_time|daily|weekly|monthly|quarterly');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `review_frequency` SET TAGS ('dbx_business_glossary_term' = 'SLA Review Frequency');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `review_frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annually|annually|ad_hoc');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `service_category` SET TAGS ('dbx_business_glossary_term' = 'IT Service Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `service_category` SET TAGS ('dbx_value_regex' = 'itsm|ot_service|infrastructure|application|network|security|end_user_computing|data_platform|cloud|integration');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `sla_code` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `sla_code` SET TAGS ('dbx_value_regex' = '^SLA-[A-Z0-9]{3,20}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `sla_owner` SET TAGS ('dbx_business_glossary_term' = 'SLA Definition Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'SLA Definition Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|active|under_review|deprecated|retired');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `support_hours_type` SET TAGS ('dbx_business_glossary_term' = 'SLA Support Hours Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `support_hours_type` SET TAGS ('dbx_value_regex' = '24x7|business_hours|extended_hours|follow_the_sun|custom');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `target_value` SET TAGS ('dbx_business_glossary_term' = 'SLA Target Value');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'SLA Definition Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `version` SET TAGS ('dbx_value_regex' = '^d+.d+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_definition` ALTER COLUMN `warning_threshold` SET TAGS ('dbx_business_glossary_term' = 'SLA Warning Threshold');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` SET TAGS ('dbx_subdomain' = 'service_operations');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `sla_performance_id` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Performance ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `it_service_id` SET TAGS ('dbx_business_glossary_term' = 'It Service Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `sla_definition_id` SET TAGS ('dbx_business_glossary_term' = 'Sla Definition Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `actual_value` SET TAGS ('dbx_business_glossary_term' = 'SLA Actual Performance Value');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `affected_ticket_count` SET TAGS ('dbx_business_glossary_term' = 'Affected Ticket Count');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `affected_ticket_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `affected_ticket_references` SET TAGS ('dbx_business_glossary_term' = 'Affected Ticket References');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `breach_count` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Count');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `breach_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `breach_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'SLA Breach Duration (Minutes)');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'SLA Compliance Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'met|breached|at_risk|not_applicable|pending_measurement');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `escalation_status` SET TAGS ('dbx_business_glossary_term' = 'SLA Escalation Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `escalation_status` SET TAGS ('dbx_value_regex' = 'not_escalated|escalated_to_manager|escalated_to_director|escalated_to_executive|resolved');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `escalation_timestamp` SET TAGS ('dbx_business_glossary_term' = 'SLA Escalation Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `escalation_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `improvement_action_reference` SET TAGS ('dbx_business_glossary_term' = 'Continual Service Improvement (CSI) Action Reference');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `is_ot_service` SET TAGS ('dbx_business_glossary_term' = 'Operational Technology (OT) Service Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `is_ot_service` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `measurement_number` SET TAGS ('dbx_business_glossary_term' = 'SLA Performance Measurement Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `measurement_number` SET TAGS ('dbx_value_regex' = '^SLAP-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `measurement_period_type` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `measurement_period_type` SET TAGS ('dbx_value_regex' = 'daily|weekly|monthly|quarterly|annual|custom');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `measurement_source` SET TAGS ('dbx_business_glossary_term' = 'Measurement Data Source');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `measurement_source` SET TAGS ('dbx_value_regex' = 'itsm_tool|monitoring_platform|manual_entry|iiot_platform|network_management_system|apm_tool');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `metric_unit` SET TAGS ('dbx_business_glossary_term' = 'SLA Metric Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `metric_unit` SET TAGS ('dbx_value_regex' = 'percent|minutes|hours|seconds|count|requests_per_second|score');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'SLA Performance Notes');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `owning_department` SET TAGS ('dbx_business_glossary_term' = 'Owning Department');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period End Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `period_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Measurement Period Start Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `period_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'SLA Performance Review Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `review_status` SET TAGS ('dbx_business_glossary_term' = 'SLA Performance Review Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `review_status` SET TAGS ('dbx_value_regex' = 'pending_review|under_review|reviewed|approved|disputed|closed');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `reviewer_name` SET TAGS ('dbx_business_glossary_term' = 'SLA Performance Reviewer Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'hardware_failure|software_defect|network_issue|capacity_constraint|human_error|third_party_dependency|planned_maintenance|security_incident|configuration_error|unknown');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `root_cause_summary` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Summary');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `service_category` SET TAGS ('dbx_business_glossary_term' = 'IT Service Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `service_category` SET TAGS ('dbx_value_regex' = 'infrastructure|application|network|security|ot_system|end_user_computing|cloud|database|integration|communication');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `service_owner` SET TAGS ('dbx_business_glossary_term' = 'IT Service Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `site_code` SET TAGS ('dbx_business_glossary_term' = 'Site Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `sla_metric_type` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Metric Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `sla_metric_type` SET TAGS ('dbx_value_regex' = 'availability|response_time|resolution_time|throughput|error_rate|recovery_time|uptime|mean_time_to_repair|mean_time_between_failures|first_call_resolution|customer_satisfaction');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `sla_tier` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Tier');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `sla_tier` SET TAGS ('dbx_value_regex' = 'platinum|gold|silver|bronze|standard');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `target_value` SET TAGS ('dbx_business_glossary_term' = 'SLA Target Value');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `variance_percent` SET TAGS ('dbx_business_glossary_term' = 'SLA Performance Variance Percentage');
ALTER TABLE `manufacturing_ecm`.`technology`.`sla_performance` ALTER COLUMN `variance_value` SET TAGS ('dbx_business_glossary_term' = 'SLA Performance Variance');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` SET TAGS ('dbx_subdomain' = 'security_compliance');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `it_risk_id` SET TAGS ('dbx_business_glossary_term' = 'IT Risk ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `service_ticket_id` SET TAGS ('dbx_business_glossary_term' = 'Service Ticket Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `affected_business_process` SET TAGS ('dbx_business_glossary_term' = 'Affected Business Process');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `affected_domain` SET TAGS ('dbx_business_glossary_term' = 'Affected Technology Domain');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `affected_domain` SET TAGS ('dbx_value_regex' = 'it_infrastructure|ot_ics|application|data|network|endpoint|cloud|identity|third_party|physical|cross_domain');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `affected_systems` SET TAGS ('dbx_business_glossary_term' = 'Affected Systems');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Risk Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'cybersecurity|operational|compliance|strategic|vendor|infrastructure|data|ot_ics');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `control_effectiveness` SET TAGS ('dbx_business_glossary_term' = 'Control Effectiveness');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `control_effectiveness` SET TAGS ('dbx_value_regex' = 'none|weak|partial|adequate|strong');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `control_measures` SET TAGS ('dbx_business_glossary_term' = 'Control Measures');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Risk Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `identified_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Identified Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `identified_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `iec62443_security_level` SET TAGS ('dbx_business_glossary_term' = 'IEC 62443 Security Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `iec62443_security_level` SET TAGS ('dbx_value_regex' = 'SL0|SL1|SL2|SL3|SL4');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `impact_rating` SET TAGS ('dbx_business_glossary_term' = 'Impact Rating');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `impact_rating` SET TAGS ('dbx_value_regex' = 'very_low|low|medium|high|very_high');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `impact_score` SET TAGS ('dbx_business_glossary_term' = 'Impact Score');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `impact_score` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `inherent_risk_level` SET TAGS ('dbx_business_glossary_term' = 'Inherent Risk Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `inherent_risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `inherent_risk_score` SET TAGS ('dbx_business_glossary_term' = 'Inherent Risk Score');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `inherent_risk_score` SET TAGS ('dbx_value_regex' = '^([1-9]|[1-2][0-9]|25)$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `is_ot_risk` SET TAGS ('dbx_business_glossary_term' = 'Operational Technology (OT) Risk Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `is_ot_risk` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Last Reviewed Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `likelihood_rating` SET TAGS ('dbx_business_glossary_term' = 'Likelihood Rating');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `likelihood_rating` SET TAGS ('dbx_value_regex' = 'very_low|low|medium|high|very_high');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `likelihood_score` SET TAGS ('dbx_business_glossary_term' = 'Likelihood Score');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `likelihood_score` SET TAGS ('dbx_value_regex' = '^[1-5]$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `regulatory_compliance_scope` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Scope');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `residual_risk_level` SET TAGS ('dbx_business_glossary_term' = 'Residual Risk Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `residual_risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `residual_risk_score` SET TAGS ('dbx_business_glossary_term' = 'Residual Risk Score');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `residual_risk_score` SET TAGS ('dbx_value_regex' = '^([1-9]|[1-2][0-9]|25)$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `risk_acceptance_approver` SET TAGS ('dbx_business_glossary_term' = 'Risk Acceptance Approver');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `risk_acceptance_justification` SET TAGS ('dbx_business_glossary_term' = 'Risk Acceptance Justification');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `risk_number` SET TAGS ('dbx_business_glossary_term' = 'IT Risk Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `risk_number` SET TAGS ('dbx_value_regex' = '^ITR-[0-9]{4}-[0-9]{5}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `risk_owner` SET TAGS ('dbx_business_glossary_term' = 'Risk Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `risk_owner_department` SET TAGS ('dbx_business_glossary_term' = 'Risk Owner Department');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `risk_reviewer` SET TAGS ('dbx_business_glossary_term' = 'Risk Reviewer');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `site_code` SET TAGS ('dbx_business_glossary_term' = 'Site Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `source` SET TAGS ('dbx_business_glossary_term' = 'Risk Source');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `source` SET TAGS ('dbx_value_regex' = 'internal_audit|penetration_test|vulnerability_scan|risk_assessment|incident_review|vendor_assessment|regulatory_audit|threat_intelligence|self_assessment|change_review|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Risk Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'identified|under_assessment|open|in_treatment|mitigated|accepted|closed|transferred');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `subcategory` SET TAGS ('dbx_business_glossary_term' = 'Risk Subcategory');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `subcategory` SET TAGS ('dbx_value_regex' = 'ransomware|phishing|insider_threat|vulnerability|patch_management|application_obsolescence|capacity|single_point_of_failure|third_party_concentration|regulatory_non_compliance|data_breach|ot_network_exposure|supply_chain_attack|identity_access|clo...');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Risk Title');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `treatment_plan` SET TAGS ('dbx_business_glossary_term' = 'Risk Treatment Plan');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `treatment_status` SET TAGS ('dbx_business_glossary_term' = 'Risk Treatment Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `treatment_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|on_hold|cancelled');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `treatment_strategy` SET TAGS ('dbx_business_glossary_term' = 'Risk Treatment Strategy');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `treatment_strategy` SET TAGS ('dbx_value_regex' = 'mitigate|accept|transfer|avoid|defer');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `treatment_target_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Treatment Target Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_risk` ALTER COLUMN `treatment_target_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` SET TAGS ('dbx_subdomain' = 'security_compliance');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `vulnerability_id` SET TAGS ('dbx_business_glossary_term' = 'Vulnerability ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `it_asset_id` SET TAGS ('dbx_business_glossary_term' = 'It Asset Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `patch_record_id` SET TAGS ('dbx_business_glossary_term' = 'Patch Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `affected_asset_type` SET TAGS ('dbx_business_glossary_term' = 'Affected Asset Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `affected_asset_type` SET TAGS ('dbx_value_regex' = 'server|workstation|network_device|plc|hmi|scada_server|historian|iot_device|ot_controller|firewall|switch|router|application|database|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `affected_ip_address` SET TAGS ('dbx_business_glossary_term' = 'Affected Asset IP Address');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `affected_ip_address` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `affected_ip_address` SET TAGS ('dbx_pii_ip' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `affected_software` SET TAGS ('dbx_business_glossary_term' = 'Affected Software or Firmware');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `assigned_owner` SET TAGS ('dbx_business_glossary_term' = 'Assigned Vulnerability Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `assigned_team` SET TAGS ('dbx_business_glossary_term' = 'Assigned Remediation Team');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `cisa_kev_listed` SET TAGS ('dbx_business_glossary_term' = 'CISA Known Exploited Vulnerability (KEV) Listed Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `cisa_kev_listed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `compliance_framework` SET TAGS ('dbx_business_glossary_term' = 'Compliance Framework');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `cve_code` SET TAGS ('dbx_business_glossary_term' = 'Common Vulnerabilities and Exposures (CVE) Identifier');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `cve_code` SET TAGS ('dbx_value_regex' = '^CVE-[0-9]{4}-[0-9]{4,}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `cvss_base_score` SET TAGS ('dbx_business_glossary_term' = 'Common Vulnerability Scoring System (CVSS) Base Score');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `cvss_base_score` SET TAGS ('dbx_value_regex' = '^(10.0|[0-9].[0-9])$');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `cvss_vector` SET TAGS ('dbx_business_glossary_term' = 'Common Vulnerability Scoring System (CVSS) Vector String');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `cvss_version` SET TAGS ('dbx_business_glossary_term' = 'Common Vulnerability Scoring System (CVSS) Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `cvss_version` SET TAGS ('dbx_value_regex' = '2.0|3.0|3.1|4.0');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Vulnerability Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `discovery_date` SET TAGS ('dbx_business_glossary_term' = 'Vulnerability Discovery Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `discovery_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `discovery_method` SET TAGS ('dbx_business_glossary_term' = 'Vulnerability Discovery Method');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `discovery_method` SET TAGS ('dbx_value_regex' = 'vulnerability_scan|penetration_test|threat_intelligence_feed|ics_cert_advisory|manual_review|vendor_advisory|bug_bounty|internal_audit|siem_alert|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `exception_approved` SET TAGS ('dbx_business_glossary_term' = 'Exception Approval Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `exception_approved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `exception_approver` SET TAGS ('dbx_business_glossary_term' = 'Exception Approver');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `exception_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Exception Expiry Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `exception_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `exception_reason` SET TAGS ('dbx_business_glossary_term' = 'Exception Reason');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `exploit_publicly_available` SET TAGS ('dbx_business_glossary_term' = 'Public Exploit Availability Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `exploit_publicly_available` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `exploitability` SET TAGS ('dbx_business_glossary_term' = 'Exploitability Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `exploitability` SET TAGS ('dbx_value_regex' = 'unproven|proof_of_concept|functional|high|not_defined');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `ics_cert_advisory_code` SET TAGS ('dbx_business_glossary_term' = 'ICS-CERT Advisory Identifier');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `is_ot_vulnerability` SET TAGS ('dbx_business_glossary_term' = 'Operational Technology (OT) Vulnerability Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `is_ot_vulnerability` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `network_zone` SET TAGS ('dbx_business_glossary_term' = 'Network Zone');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `network_zone` SET TAGS ('dbx_value_regex' = 'dmz|corporate_lan|ot_level_0|ot_level_1|ot_level_2|ot_level_3|ot_level_4|cloud|remote_access|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `patch_available` SET TAGS ('dbx_business_glossary_term' = 'Patch Availability Indicator');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `patch_available` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `remediation_action` SET TAGS ('dbx_business_glossary_term' = 'Remediation Action');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `remediation_action` SET TAGS ('dbx_value_regex' = 'apply_patch|configuration_change|network_segmentation|compensating_control|firmware_upgrade|software_upgrade|decommission_asset|workaround|no_action_risk_accepted|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `remediation_completed_date` SET TAGS ('dbx_business_glossary_term' = 'Remediation Completed Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `remediation_completed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `remediation_due_date` SET TAGS ('dbx_business_glossary_term' = 'Remediation Due Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `remediation_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `scan_tool` SET TAGS ('dbx_business_glossary_term' = 'Vulnerability Scan Tool');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Vulnerability Severity');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|informational');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `site_code` SET TAGS ('dbx_business_glossary_term' = 'Site Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Vulnerability Remediation Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|in_remediation|remediated|exception_approved|risk_accepted|closed|false_positive');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Vulnerability Title');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Vulnerability Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`vulnerability` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'injection|buffer_overflow|authentication_bypass|privilege_escalation|cross_site_scripting|insecure_configuration|missing_patch|default_credentials|denial_of_service|cryptographic_weakness|firmware_flaw|protocol_weakness|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` SET TAGS ('dbx_subdomain' = 'security_compliance');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `patch_record_id` SET TAGS ('dbx_business_glossary_term' = 'Patch Record ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `it_asset_id` SET TAGS ('dbx_business_glossary_term' = 'It Asset Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `service_ticket_id` SET TAGS ('dbx_business_glossary_term' = 'Service Ticket Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `technology_change_request_id` SET TAGS ('dbx_business_glossary_term' = 'Change Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `actual_deployment_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Deployment Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `actual_deployment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `affected_system_name` SET TAGS ('dbx_business_glossary_term' = 'Affected System Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `affected_system_type` SET TAGS ('dbx_business_glossary_term' = 'Affected System Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `affected_system_type` SET TAGS ('dbx_value_regex' = 'server|workstation|laptop|plc|scada_server|hmi|network_device|iot_device|virtual_machine|container|database_server|application_server');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `compliance_deadline_date` SET TAGS ('dbx_business_glossary_term' = 'Compliance Deadline Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `compliance_deadline_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `compliance_status` SET TAGS ('dbx_business_glossary_term' = 'Patch Compliance Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `compliance_status` SET TAGS ('dbx_value_regex' = 'compliant|non_compliant|exempt|pending_review');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `cve_reference` SET TAGS ('dbx_business_glossary_term' = 'Common Vulnerabilities and Exposures (CVE) Reference');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `cve_reference` SET TAGS ('dbx_value_regex' = '^(CVE-[0-9]{4}-[0-9]{4,7})(,CVE-[0-9]{4}-[0-9]{4,7})*$');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `cvss_score` SET TAGS ('dbx_business_glossary_term' = 'Common Vulnerability Scoring System (CVSS) Score');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `cvss_score` SET TAGS ('dbx_value_regex' = '^(10.0|[0-9].[0-9])$');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `deferral_approved_by` SET TAGS ('dbx_business_glossary_term' = 'Deferral Approved By');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `deferral_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Deferral Expiry Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `deferral_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `deferral_reason` SET TAGS ('dbx_business_glossary_term' = 'Deferral Reason');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `deployed_by` SET TAGS ('dbx_business_glossary_term' = 'Deployed By');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `deployment_status` SET TAGS ('dbx_business_glossary_term' = 'Deployment Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `deployment_status` SET TAGS ('dbx_value_regex' = 'pending|in_progress|deployed|failed|deferred|cancelled|rolled_back|not_applicable');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `deployment_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Deployment Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `deployment_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `exception_reference` SET TAGS ('dbx_business_glossary_term' = 'Compliance Exception Reference');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `is_ot_system` SET TAGS ('dbx_business_glossary_term' = 'Operational Technology (OT) System Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `is_ot_system` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `patch_category` SET TAGS ('dbx_business_glossary_term' = 'Patch Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `patch_category` SET TAGS ('dbx_value_regex' = 'os|application|middleware|firmware|bios|plc|scada|hmi|network_device|database|antivirus');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `patch_identifier` SET TAGS ('dbx_business_glossary_term' = 'Patch Identifier');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `patch_identifier` SET TAGS ('dbx_value_regex' = '^PATCH-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `patch_release_date` SET TAGS ('dbx_business_glossary_term' = 'Patch Release Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `patch_release_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `patch_source` SET TAGS ('dbx_business_glossary_term' = 'Patch Source');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `patch_source` SET TAGS ('dbx_value_regex' = 'vendor_advisory|wsus|sccm|ansible|manual|yum_repo|apt_repo|ot_vendor_portal|third_party_tool');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `patch_title` SET TAGS ('dbx_business_glossary_term' = 'Patch Title');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `patch_type` SET TAGS ('dbx_business_glossary_term' = 'Patch Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `patch_type` SET TAGS ('dbx_value_regex' = 'security|functional|firmware|driver|hotfix|service_pack|configuration|cumulative_update');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `patch_version` SET TAGS ('dbx_business_glossary_term' = 'Patch Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `post_deployment_validation_notes` SET TAGS ('dbx_business_glossary_term' = 'Post-Deployment Validation Notes');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `post_deployment_validation_result` SET TAGS ('dbx_business_glossary_term' = 'Post-Deployment Validation Result');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `post_deployment_validation_result` SET TAGS ('dbx_value_regex' = 'passed|failed|partial|pending|not_performed');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `post_patch_version` SET TAGS ('dbx_business_glossary_term' = 'Post-Patch Software Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `rollback_performed` SET TAGS ('dbx_business_glossary_term' = 'Rollback Performed Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `rollback_performed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `rollback_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Rollback Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `rollback_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `scheduled_deployment_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Deployment Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `scheduled_deployment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `severity_rating` SET TAGS ('dbx_business_glossary_term' = 'Patch Severity Rating');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `severity_rating` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|informational');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `site_code` SET TAGS ('dbx_business_glossary_term' = 'Site Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `target_software_version` SET TAGS ('dbx_business_glossary_term' = 'Target Software Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `test_environment_name` SET TAGS ('dbx_business_glossary_term' = 'Test Environment Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `tested_in_non_production` SET TAGS ('dbx_business_glossary_term' = 'Tested in Non-Production Environment Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `tested_in_non_production` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`patch_record` ALTER COLUMN `vendor_advisory_reference` SET TAGS ('dbx_business_glossary_term' = 'Vendor Advisory Reference');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` SET TAGS ('dbx_subdomain' = 'service_operations');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `it_service_outage_id` SET TAGS ('dbx_business_glossary_term' = 'IT Service Outage ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Affected Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `incident_id` SET TAGS ('dbx_business_glossary_term' = 'Incident Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `it_service_id` SET TAGS ('dbx_business_glossary_term' = 'It Service Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `it_vendor_id` SET TAGS ('dbx_business_glossary_term' = 'It Vendor Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `service_ticket_id` SET TAGS ('dbx_business_glossary_term' = 'Service Ticket Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `technology_change_request_id` SET TAGS ('dbx_business_glossary_term' = 'Change Request Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `affected_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Affected Business Unit');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `affected_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Affected Plant Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `affected_production_lines` SET TAGS ('dbx_business_glossary_term' = 'Affected Production Lines');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `assigned_resolver_team` SET TAGS ('dbx_business_glossary_term' = 'Assigned Resolver Team');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `capa_reference` SET TAGS ('dbx_business_glossary_term' = 'Corrective and Preventive Action (CAPA) Reference');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `detection_method` SET TAGS ('dbx_business_glossary_term' = 'Outage Detection Method');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `detection_method` SET TAGS ('dbx_value_regex' = 'automated_monitoring|user_report|service_desk|vendor_alert|scheduled_check|ot_alarm');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `detection_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Outage Detection Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `detection_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Outage Duration (Minutes)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `duration_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `financial_impact_amount` SET TAGS ('dbx_business_glossary_term' = 'Financial Impact Amount');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `financial_impact_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `financial_impact_currency` SET TAGS ('dbx_business_glossary_term' = 'Financial Impact Currency Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `financial_impact_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `is_ot_outage` SET TAGS ('dbx_business_glossary_term' = 'Operational Technology (OT) Outage Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `is_ot_outage` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `oee_impact_percent` SET TAGS ('dbx_business_glossary_term' = 'Overall Equipment Effectiveness (OEE) Impact Percentage');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `oee_impact_percent` SET TAGS ('dbx_value_regex' = '^(100(.00?)?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `outage_category` SET TAGS ('dbx_business_glossary_term' = 'Outage Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `outage_category` SET TAGS ('dbx_value_regex' = 'infrastructure|application|network|ot_system|security|database|cloud|end_user_computing|vendor');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `outage_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Outage End Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `outage_end_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `outage_number` SET TAGS ('dbx_business_glossary_term' = 'Outage Reference Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `outage_number` SET TAGS ('dbx_value_regex' = '^OUT-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `outage_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Outage Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `outage_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `outage_type` SET TAGS ('dbx_business_glossary_term' = 'Outage Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `outage_type` SET TAGS ('dbx_value_regex' = 'planned_maintenance|unplanned_incident|partial_degradation|emergency_change');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `post_incident_review_date` SET TAGS ('dbx_business_glossary_term' = 'Post-Incident Review (PIR) Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `post_incident_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `post_incident_review_status` SET TAGS ('dbx_business_glossary_term' = 'Post-Incident Review (PIR) Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `post_incident_review_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|in_progress|completed|waived');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `production_lines_affected_count` SET TAGS ('dbx_business_glossary_term' = 'Production Lines Affected Count');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `production_lines_affected_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `production_loss_units` SET TAGS ('dbx_business_glossary_term' = 'Production Loss Units');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `reported_by` SET TAGS ('dbx_business_glossary_term' = 'Reported By');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `resolution_actions` SET TAGS ('dbx_business_glossary_term' = 'Resolution Actions');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `root_cause_category` SET TAGS ('dbx_value_regex' = 'hardware_failure|software_bug|network_failure|human_error|vendor_issue|cyber_incident|power_failure|environmental|configuration_error|capacity_exhaustion|ot_control_failure|unknown');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `root_cause_description` SET TAGS ('dbx_business_glossary_term' = 'Root Cause Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `rto_target_minutes` SET TAGS ('dbx_business_glossary_term' = 'Recovery Time Objective (RTO) Target (Minutes)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `rto_target_minutes` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `severity` SET TAGS ('dbx_business_glossary_term' = 'Outage Severity');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `severity` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_business_glossary_term' = 'Service Level Agreement (SLA) Breach Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `sla_breach_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Outage Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'open|in_progress|resolved|closed|cancelled');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `vendor_involved_flag` SET TAGS ('dbx_business_glossary_term' = 'Vendor Involvement Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `vendor_involved_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `workaround_applied` SET TAGS ('dbx_business_glossary_term' = 'Workaround Applied Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_service_outage` ALTER COLUMN `workaround_applied` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` SET TAGS ('dbx_subdomain' = 'service_operations');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `user_access_request_id` SET TAGS ('dbx_business_glossary_term' = 'User Access Request ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Approver Employee ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `beneficiary_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Beneficiary Employee ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `beneficiary_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `beneficiary_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `requester_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Requester Employee ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `requester_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `requester_employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `access_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Access Expiry Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `access_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `access_granted_date` SET TAGS ('dbx_business_glossary_term' = 'Access Granted Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `access_granted_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `access_level` SET TAGS ('dbx_business_glossary_term' = 'Access Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `access_level` SET TAGS ('dbx_value_regex' = 'read_only|read_write|full_access|admin|privileged|super_user|emergency_access');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `access_review_due_date` SET TAGS ('dbx_business_glossary_term' = 'Access Certification Review Due Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `access_review_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `approval_level` SET TAGS ('dbx_business_glossary_term' = 'Approval Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `approval_level` SET TAGS ('dbx_value_regex' = 'line_manager|department_head|it_security|ciso|system_owner|privileged_access_committee');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|escalated|withdrawn|conditionally_approved');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Request Approved Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `approver_name` SET TAGS ('dbx_business_glossary_term' = 'Approver Full Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `beneficiary_job_title` SET TAGS ('dbx_business_glossary_term' = 'Beneficiary Job Title');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `beneficiary_name` SET TAGS ('dbx_business_glossary_term' = 'Beneficiary User Full Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `beneficiary_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `beneficiary_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `beneficiary_user_type` SET TAGS ('dbx_business_glossary_term' = 'Beneficiary User Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `beneficiary_user_type` SET TAGS ('dbx_value_regex' = 'employee|contractor|vendor|service_account|system|temporary_worker');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `business_justification` SET TAGS ('dbx_business_glossary_term' = 'Business Justification');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `is_emergency_access` SET TAGS ('dbx_business_glossary_term' = 'Emergency Access Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `is_emergency_access` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `is_ot_system` SET TAGS ('dbx_business_glossary_term' = 'Operational Technology (OT) System Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `is_ot_system` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `is_privileged_access` SET TAGS ('dbx_business_glossary_term' = 'Privileged Access Management (PAM) Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `is_privileged_access` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Access Request Priority');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `provisioned_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Access Provisioned Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `provisioned_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `provisioning_method` SET TAGS ('dbx_business_glossary_term' = 'Provisioning Method');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `provisioning_method` SET TAGS ('dbx_value_regex' = 'automated|manual|semi_automated');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `provisioning_status` SET TAGS ('dbx_business_glossary_term' = 'Provisioning Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `provisioning_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|failed|partially_completed|rolled_back');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `rejection_reason` SET TAGS ('dbx_business_glossary_term' = 'Rejection Reason');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `related_ticket_number` SET TAGS ('dbx_business_glossary_term' = 'Related ITSM Ticket Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `request_category` SET TAGS ('dbx_business_glossary_term' = 'Access Request Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `request_category` SET TAGS ('dbx_value_regex' = 'standard|emergency|privileged|service_account|bulk|contractor');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `request_number` SET TAGS ('dbx_business_glossary_term' = 'Access Request Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `request_number` SET TAGS ('dbx_value_regex' = '^UAR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `request_type` SET TAGS ('dbx_business_glossary_term' = 'Access Request Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `request_type` SET TAGS ('dbx_value_regex' = 'new_access|access_modification|access_revocation|privileged_access|role_change|temporary_access');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `requested_role` SET TAGS ('dbx_business_glossary_term' = 'Requested Role or Permission');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `requester_department` SET TAGS ('dbx_business_glossary_term' = 'Requester Department');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `requester_name` SET TAGS ('dbx_business_glossary_term' = 'Requester Full Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `requester_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `requester_name` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_business_glossary_term' = 'Access Revocation Reason');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `revocation_reason` SET TAGS ('dbx_value_regex' = 'offboarding|role_change|access_review|security_incident|policy_violation|project_completion|contract_end|voluntary');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `revoked_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Access Revoked Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `revoked_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `site_code` SET TAGS ('dbx_business_glossary_term' = 'Site Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `sod_conflict_description` SET TAGS ('dbx_business_glossary_term' = 'Segregation of Duties (SOD) Conflict Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `sod_conflict_flag` SET TAGS ('dbx_business_glossary_term' = 'Segregation of Duties (SOD) Conflict Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `sod_conflict_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Access Request Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|submitted|pending_approval|approved|rejected|provisioning|provisioned|failed|revoked|expired|cancelled');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `submitted_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Request Submitted Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `submitted_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `target_system_name` SET TAGS ('dbx_business_glossary_term' = 'Target System Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `target_system_type` SET TAGS ('dbx_business_glossary_term' = 'Target System Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`user_access_request` ALTER COLUMN `target_system_type` SET TAGS ('dbx_value_regex' = 'erp|mes|plm|scada|crm|eam|wms|iam|cloud_platform|ot_system|network|database|application|iiot_platform');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` SET TAGS ('dbx_data_type' = 'reference_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` SET TAGS ('dbx_subdomain' = 'infrastructure_assets');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` SET TAGS ('dbx_original_name' = 'technology_standard');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `standard_id` SET TAGS ('dbx_business_glossary_term' = 'Technology Standard ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `applicable_countries` SET TAGS ('dbx_business_glossary_term' = 'Applicable Countries');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `applicable_countries` SET TAGS ('dbx_value_regex' = '^([A-Z]{3})(,[A-Z]{3})*$');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `applicable_sites` SET TAGS ('dbx_business_glossary_term' = 'Applicable Sites');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Approval Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `category` SET TAGS ('dbx_business_glossary_term' = 'Technology Standard Category');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `category` SET TAGS ('dbx_value_regex' = 'platform|protocol|pattern|policy|guideline|specification|framework|reference_architecture');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Technology Standard Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^[A-Z]{2,6}-STD-[0-9]{4,6}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `compliance_assessment_result` SET TAGS ('dbx_business_glossary_term' = 'Compliance Assessment Result');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `compliance_assessment_result` SET TAGS ('dbx_value_regex' = 'compliant|partially_compliant|non_compliant|not_assessed');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `compliance_classification` SET TAGS ('dbx_business_glossary_term' = 'Compliance Classification');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `compliance_classification` SET TAGS ('dbx_value_regex' = 'mandatory|advisory|conditional');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `compliance_scope` SET TAGS ('dbx_business_glossary_term' = 'Compliance Scope');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `compliance_scope` SET TAGS ('dbx_value_regex' = 'global|regional|country|plant_level|business_unit');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Technology Standard Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `deviation_allowed` SET TAGS ('dbx_business_glossary_term' = 'Deviation Allowed Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `deviation_allowed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `deviation_approval_process` SET TAGS ('dbx_business_glossary_term' = 'Deviation Approval Process');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `document_reference` SET TAGS ('dbx_business_glossary_term' = 'Document Reference');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `enforcement_mechanism` SET TAGS ('dbx_business_glossary_term' = 'Enforcement Mechanism');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `enforcement_mechanism` SET TAGS ('dbx_value_regex' = 'architecture_review_gate|automated_policy_check|audit_and_assessment|self_attestation|tooling_enforcement|none');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `exception_count` SET TAGS ('dbx_business_glossary_term' = 'Active Exception Count');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `exception_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `it_ot_applicability` SET TAGS ('dbx_business_glossary_term' = 'IT/OT Applicability');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `it_ot_applicability` SET TAGS ('dbx_value_regex' = 'it_only|ot_only|it_and_ot');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_business_glossary_term' = 'Last Audit Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `last_audit_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Technology Standard Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `owner` SET TAGS ('dbx_business_glossary_term' = 'Standard Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `owning_architecture_board` SET TAGS ('dbx_business_glossary_term' = 'Owning Architecture Board');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `previous_version` SET TAGS ('dbx_business_glossary_term' = 'Previous Standard Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `previous_version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `purdue_model_levels` SET TAGS ('dbx_business_glossary_term' = 'Purdue Model Levels');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `regulatory_drivers` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Drivers');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `related_standards` SET TAGS ('dbx_business_glossary_term' = 'Related Standards');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `retirement_date` SET TAGS ('dbx_business_glossary_term' = 'Retirement Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `retirement_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Review Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Technology Standard Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|approved|active|deprecated|retired|superseded');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `superseded_by_code` SET TAGS ('dbx_business_glossary_term' = 'Superseded By Standard Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'network_infrastructure|cybersecurity|cloud_and_hosting|application_architecture|data_and_analytics|ot_and_iiot|integration_and_middleware|end_user_computing|identity_and_access|it_service_management|digital_manufacturing');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `technology_lifecycle_phase` SET TAGS ('dbx_business_glossary_term' = 'Technology Lifecycle Phase');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `technology_lifecycle_phase` SET TAGS ('dbx_value_regex' = 'emerging|strategic|standard|contained|declining|end_of_life');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Technology Standard Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'architecture_standard|security_standard|integration_standard|ot_standard|data_standard|infrastructure_standard|application_standard|compliance_standard');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Standard Version');
ALTER TABLE `manufacturing_ecm`.`technology`.`standard` ALTER COLUMN `version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` SET TAGS ('dbx_subdomain' = 'infrastructure_assets');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `data_integration_id` SET TAGS ('dbx_business_glossary_term' = 'Data Integration ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `application_id` SET TAGS ('dbx_business_glossary_term' = 'Source Application Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `warehouse_id` SET TAGS ('dbx_business_glossary_term' = 'Warehouse Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `authentication_method` SET TAGS ('dbx_business_glossary_term' = 'Authentication Method');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `authentication_method` SET TAGS ('dbx_value_regex' = 'OAuth2|API_key|certificate|basic_auth|SAML|Kerberos|mutual_TLS|none|custom');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `avg_daily_volume_records` SET TAGS ('dbx_business_glossary_term' = 'Average Daily Data Volume (Records)');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `avg_payload_size_kb` SET TAGS ('dbx_business_glossary_term' = 'Average Payload Size (Kilobytes)');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `business_owner` SET TAGS ('dbx_business_glossary_term' = 'Business Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `business_process` SET TAGS ('dbx_business_glossary_term' = 'Supported Business Process');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `data_classification` SET TAGS ('dbx_business_glossary_term' = 'Data Classification Level');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `data_classification` SET TAGS ('dbx_value_regex' = 'restricted|confidential|internal|public');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `data_domain` SET TAGS ('dbx_business_glossary_term' = 'Data Domain');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `data_domain` SET TAGS ('dbx_value_regex' = 'Product Engineering|Production|Supply Chain|Quality Management|Inventory|Sales and Orders|Customer|Asset Management|Workforce|Finance|Procurement|Logistics|Health Safety and Environment|Research and Development|Service and Aftermarket');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Integration Description');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `direction` SET TAGS ('dbx_business_glossary_term' = 'Integration Direction');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `direction` SET TAGS ('dbx_value_regex' = 'unidirectional|bidirectional');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `encryption_in_transit` SET TAGS ('dbx_business_glossary_term' = 'Encryption in Transit Flag');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `encryption_in_transit` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `environment` SET TAGS ('dbx_business_glossary_term' = 'Deployment Environment');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `environment` SET TAGS ('dbx_value_regex' = 'production|staging|uat|development|sandbox|dr');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `error_handling_strategy` SET TAGS ('dbx_business_glossary_term' = 'Error Handling Strategy');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `error_handling_strategy` SET TAGS ('dbx_value_regex' = 'retry|dead_letter_queue|alert_and_stop|compensating_transaction|manual_intervention|discard|custom');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `frequency` SET TAGS ('dbx_business_glossary_term' = 'Integration Frequency');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `frequency` SET TAGS ('dbx_value_regex' = 'real_time|near_real_time|micro_batch|batch_hourly|batch_daily|batch_weekly|batch_monthly|event_driven|on_demand|scheduled');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `go_live_date` SET TAGS ('dbx_business_glossary_term' = 'Go-Live Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `go_live_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `integration_code` SET TAGS ('dbx_business_glossary_term' = 'Integration Interface Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `integration_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `integration_pattern` SET TAGS ('dbx_business_glossary_term' = 'Integration Pattern');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `integration_pattern` SET TAGS ('dbx_value_regex' = 'API|EDI|file_transfer|message_queue|OPC-UA|database_replication|event_streaming|web_service|FTP|SFTP|direct_database|custom');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `integration_type` SET TAGS ('dbx_business_glossary_term' = 'Integration Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `integration_type` SET TAGS ('dbx_value_regex' = 'point_to_point|hub_and_spoke|ESB|iPaaS|event_driven|B2B|OT_IT|IIoT|EDI|custom');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `it_owner` SET TAGS ('dbx_business_glossary_term' = 'IT Owner');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Last Reviewed Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `middleware_platform` SET TAGS ('dbx_business_glossary_term' = 'Middleware Platform');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Integration Interface Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `ot_it_classification` SET TAGS ('dbx_business_glossary_term' = 'OT/IT Convergence Classification');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `ot_it_classification` SET TAGS ('dbx_value_regex' = 'IT_only|OT_only|OT_IT_convergence|IIoT|B2B_external');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `owning_department` SET TAGS ('dbx_business_glossary_term' = 'Owning Department');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `planned_decommission_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Decommission Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `planned_decommission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `protocol` SET TAGS ('dbx_business_glossary_term' = 'Communication Protocol');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `protocol` SET TAGS ('dbx_value_regex' = 'REST|SOAP|OPC-UA|MQTT|AMQP|AS2|SFTP|FTP|JDBC|ODBC|HTTP|HTTPS|OData|GraphQL|gRPC|Modbus|PROFINET|custom');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `regulatory_compliance_scope` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Scope');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `retry_max_attempts` SET TAGS ('dbx_business_glossary_term' = 'Maximum Retry Attempts');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `retry_max_attempts` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `site_code` SET TAGS ('dbx_business_glossary_term' = 'Site Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `site_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9_-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `sla_availability_target_pct` SET TAGS ('dbx_business_glossary_term' = 'SLA Availability Target Percentage');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `sla_availability_target_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `sla_latency_target_seconds` SET TAGS ('dbx_business_glossary_term' = 'SLA Latency Target (Seconds)');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `source_system_module` SET TAGS ('dbx_business_glossary_term' = 'Source System Module');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Integration Operational Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|deprecated|under_development|testing|suspended|decommissioned');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `target_system` SET TAGS ('dbx_business_glossary_term' = 'Target System Name');
ALTER TABLE `manufacturing_ecm`.`technology`.`data_integration` ALTER COLUMN `target_system_module` SET TAGS ('dbx_business_glossary_term' = 'Target System Module');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` SET TAGS ('dbx_subdomain' = 'vendor_relations');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `it_cost_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'IT Cost Allocation ID');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `it_service_id` SET TAGS ('dbx_business_glossary_term' = 'It Service Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `it_vendor_id` SET TAGS ('dbx_business_glossary_term' = 'It Vendor Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocated_amount` SET TAGS ('dbx_business_glossary_term' = 'Allocated IT Cost Amount');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocated_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_driver_unit` SET TAGS ('dbx_business_glossary_term' = 'Allocation Driver Unit');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_driver_unit` SET TAGS ('dbx_value_regex' = 'users|headcount|cpu_hours|gb_storage|transactions|licenses|tickets|devices|square_meters|revenue_pct');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_driver_value` SET TAGS ('dbx_business_glossary_term' = 'Allocation Driver Value');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_method` SET TAGS ('dbx_business_glossary_term' = 'IT Cost Allocation Method');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_method` SET TAGS ('dbx_value_regex' = 'usage_based|headcount|fixed|revenue_based|transaction_volume|square_footage|equal_split|negotiated');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_model` SET TAGS ('dbx_business_glossary_term' = 'IT Cost Allocation Model');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_model` SET TAGS ('dbx_value_regex' = 'chargeback|showback|allocation_only');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_number` SET TAGS ('dbx_business_glossary_term' = 'IT Cost Allocation Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_number` SET TAGS ('dbx_value_regex' = '^ICA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_percentage` SET TAGS ('dbx_business_glossary_term' = 'Allocation Percentage');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_period_end_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation Period End Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_period_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_period_start_date` SET TAGS ('dbx_business_glossary_term' = 'Allocation Period Start Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `allocation_period_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Approval Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|not_required');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `capex_opex_classification` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure / Operational Expenditure (CAPEX/OPEX) Classification');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `capex_opex_classification` SET TAGS ('dbx_value_regex' = 'capex|opex|mixed');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `cost_element_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Element Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `cost_type` SET TAGS ('dbx_business_glossary_term' = 'IT Cost Type');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `cost_type` SET TAGS ('dbx_value_regex' = 'infrastructure|application|support|cloud|license|network|security|end_user_computing|data_and_analytics|ot_it_convergence');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(1[0-2]|[1-9])$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `gl_account_code` SET TAGS ('dbx_business_glossary_term' = 'General Ledger (GL) Account Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `internal_order_number` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `legal_entity` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Allocation Notes');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `po_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Posting Date');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `receiving_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Receiving Business Unit');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `receiving_cost_center` SET TAGS ('dbx_business_glossary_term' = 'Receiving Cost Center');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `receiving_plant_code` SET TAGS ('dbx_business_glossary_term' = 'Receiving Plant Code');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `receiving_production_line` SET TAGS ('dbx_business_glossary_term' = 'Receiving Production Line');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `record_created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Updated Timestamp');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `record_updated_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_business_glossary_term' = 'Reversal Reason');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `reversal_reason` SET TAGS ('dbx_value_regex' = 'data_correction|duplicate_entry|period_adjustment|business_unit_change|cancelled_service|other');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|APPTIO|SERVICENOW|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Allocation Status');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|posted|reversed|cancelled');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `total_cost` SET TAGS ('dbx_business_glossary_term' = 'Total IT Cost');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `total_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`technology`.`it_cost_allocation` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
