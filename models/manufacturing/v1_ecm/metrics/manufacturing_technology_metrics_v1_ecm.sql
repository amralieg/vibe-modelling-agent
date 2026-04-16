-- Metric views for domain: technology | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`technology_it_budget`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "IT budget performance metrics tracking approved budget, actual spend, forecast, variance, and commitment levels across IT domains, cost centers, and strategic initiatives. Enables IT financial governance, budget variance analysis, and CAPEX/OPEX tracking for manufacturing technology investments."
  source: "`manufacturing_ecm`.`technology`.`it_budget`"
  dimensions:
    - name: "budget_year"
      expr: budget_year
      comment: "Fiscal year to which the IT budget record applies, enabling annual and multi-year planning cycle analysis."
    - name: "budget_type"
      expr: budget_type
      comment: "Classification as Capital Expenditure (CAPEX) or Operational Expenditure (OPEX), driving accounting treatment and financial reporting."
    - name: "it_domain"
      expr: it_domain
      comment: "Technology domain or functional area (infrastructure, applications, OT/IT convergence, cybersecurity, digital transformation) for spend analysis."
    - name: "budget_category"
      expr: budget_category
      comment: "Detailed spend category (hardware, software licenses, cloud services, managed services, professional services) for granular cost analysis."
    - name: "cost_center_code"
      expr: cost_center_code
      comment: "SAP cost center code for financial accountability and cost allocation reporting across organizational hierarchy."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code for multi-country financial reporting and regional IT spend analysis."
    - name: "region"
      expr: region
      comment: "Geographic region for regional IT spend aggregation and benchmarking across the multinational enterprise."
    - name: "strategic_initiative"
      expr: strategic_initiative
      comment: "Strategic technology initiative or digital transformation program this budget supports, linking IT spend to business strategy."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the IT budget record, driving workflow routing and financial reporting inclusion."
    - name: "approval_status"
      expr: approval_status
      comment: "Approval workflow status indicating whether budget is approved, pending review, rejected, or conditionally approved."
    - name: "currency_code"
      expr: currency_code
      comment: "ISO 4217 three-letter currency code for multi-currency financial reporting across multinational operations."
  measures:
    - name: "total_approved_budget"
      expr: SUM(CAST(approved_budget_amount AS DOUBLE))
      comment: "Total formally approved budget amount authorized by budget governance process, representing baseline for variance measurement."
    - name: "total_actual_spend"
      expr: SUM(CAST(actual_spend_amount AS DOUBLE))
      comment: "Cumulative actual expenditure posted against IT budgets, sourced from SAP FI/CO actuals for budget variance tracking."
    - name: "total_forecast_amount"
      expr: SUM(CAST(forecast_amount AS DOUBLE))
      comment: "Latest forecast of expected total spend updated periodically to reflect current projections based on committed and anticipated expenditures."
    - name: "total_committed_amount"
      expr: SUM(CAST(committed_amount AS DOUBLE))
      comment: "Amount committed through purchase orders or contracts raised but not yet invoiced, representing financial obligations already incurred."
    - name: "total_variance_amount"
      expr: SUM(CAST(variance_amount AS DOUBLE))
      comment: "Total difference between approved budget and actual spend (positive = underspend, negative = overspend) for governance reporting."
    - name: "budget_utilization_pct"
      expr: ROUND(100.0 * SUM(CAST(actual_spend_amount AS DOUBLE)) / NULLIF(SUM(CAST(approved_budget_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of approved budget consumed by actual spend, key KPI for IT financial performance and budget control."
    - name: "forecast_accuracy_pct"
      expr: ROUND(100.0 * (1 - ABS(SUM(CAST(forecast_amount AS DOUBLE)) - SUM(CAST(actual_spend_amount AS DOUBLE))) / NULLIF(SUM(CAST(forecast_amount AS DOUBLE)), 0)), 2)
      comment: "Forecast accuracy percentage measuring how closely actual spend aligns with forecast, indicating financial planning quality."
    - name: "commitment_rate_pct"
      expr: ROUND(100.0 * SUM(CAST(committed_amount AS DOUBLE)) / NULLIF(SUM(CAST(approved_budget_amount AS DOUBLE)), 0), 2)
      comment: "Percentage of approved budget committed through POs or contracts, indicating budget execution velocity and procurement pipeline."
    - name: "budget_record_count"
      expr: COUNT(1)
      comment: "Number of IT budget records for portfolio complexity analysis and budget line item tracking."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`technology_it_project`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "IT and digital transformation project portfolio metrics tracking budget performance, schedule variance, project health, and delivery outcomes across ERP upgrades, MES implementations, IIoT deployments, and OT/IT convergence initiatives. Enables IT portfolio management and digital transformation governance."
  source: "`manufacturing_ecm`.`technology`.`it_project`"
  dimensions:
    - name: "project_type"
      expr: project_type
      comment: "Classification by primary technology or business function (ERP upgrade, MES implementation, IIoT platform deployment, OT/IT convergence, cybersecurity program)."
    - name: "technology_domain"
      expr: technology_domain
      comment: "Primary technology domain or capability area (Enterprise Applications, IIoT & OT, Cybersecurity) for portfolio segmentation."
    - name: "status"
      expr: status
      comment: "Current operational status (draft, approved, executing, on hold, cancelled, completed, archived) for portfolio health tracking."
    - name: "phase"
      expr: phase
      comment: "Current lifecycle phase (Initiation, Planning, Execution, Monitoring & Control, Closure) following standard project management methodology."
    - name: "health_indicator"
      expr: health_indicator
      comment: "Red-Amber-Green (RAG) health indicator reflecting overall project health based on schedule, budget, and scope performance."
    - name: "priority"
      expr: priority
      comment: "Business priority level assigned by IT governance committee for resource allocation and portfolio sequencing decisions."
    - name: "risk_level"
      expr: risk_level
      comment: "Overall risk level based on project risk assessment considering technical complexity, business impact, regulatory exposure, and delivery risk."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of primary country where project is executed for multi-country portfolio reporting."
    - name: "region"
      expr: region
      comment: "Enterprise-defined geographic region (North America, Europe, Asia Pacific) for regional portfolio management and resource planning."
    - name: "delivery_methodology"
      expr: delivery_methodology
      comment: "Project management and delivery methodology applied (Waterfall, Agile, SAFe, Hybrid) governing work planning and execution."
    - name: "deployment_environment"
      expr: deployment_environment
      comment: "Target deployment environment (on-premise, cloud, hybrid, edge) for IT project deliverables."
  measures:
    - name: "total_approved_budget"
      expr: SUM(CAST(approved_budget AS DOUBLE))
      comment: "Total capital and operational expenditure budget formally approved for IT projects by governance committee or finance authority."
    - name: "total_budget_consumed"
      expr: SUM(CAST(budget_consumed AS DOUBLE))
      comment: "Total expenditure incurred against IT projects including labor, software licenses, hardware, and third-party services."
    - name: "total_capex_amount"
      expr: SUM(CAST(capex_amount AS DOUBLE))
      comment: "Total Capital Expenditure (CAPEX) portion of project budgets representing investments to be capitalized on balance sheet."
    - name: "total_opex_amount"
      expr: SUM(CAST(opex_amount AS DOUBLE))
      comment: "Total Operational Expenditure (OPEX) portion of project budgets representing ongoing operational costs expensed in period."
    - name: "budget_utilization_pct"
      expr: ROUND(100.0 * SUM(CAST(budget_consumed AS DOUBLE)) / NULLIF(SUM(CAST(approved_budget AS DOUBLE)), 0), 2)
      comment: "Percentage of approved project budget consumed, key KPI for project financial performance and cost control."
    - name: "avg_roi_target_pct"
      expr: AVG(CAST(roi_target_percent AS DOUBLE))
      comment: "Average target Return on Investment (ROI) percentage across projects as defined in approved business cases."
    - name: "project_count"
      expr: COUNT(1)
      comment: "Number of IT and digital transformation projects in portfolio for capacity planning and portfolio complexity analysis."
    - name: "avg_change_request_count"
      expr: AVG(CAST(change_request_count AS DOUBLE))
      comment: "Average number of approved change requests per project, indicating scope creep and project complexity over lifecycle."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`technology_it_service_outage`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "IT and OT service outage impact metrics tracking downtime duration, production impact, OEE degradation, financial loss, and SLA breach rates across manufacturing operations. Enables availability reporting, production impact quantification, and service reliability improvement for IT/OT services."
  source: "`manufacturing_ecm`.`technology`.`it_service_outage`"
  dimensions:
    - name: "outage_type"
      expr: outage_type
      comment: "Classification as planned maintenance, unplanned incident, partial service degradation, or emergency change for reporting segmentation."
    - name: "outage_category"
      expr: outage_category
      comment: "Broad technology category of affected service or component causing outage for trend analysis and capacity planning."
    - name: "severity"
      expr: severity
      comment: "Business impact severity (Critical = production stoppage/safety risk, High = major degradation, Medium = partial impact, Low = minimal disruption)."
    - name: "is_ot_outage"
      expr: is_ot_outage
      comment: "Indicates whether outage affects Operational Technology (OT) system (PLC, SCADA, DCS, MES, IIoT) vs pure IT service for IT/OT convergence reporting."
    - name: "affected_plant_code"
      expr: affected_plant_code
      comment: "SAP plant code or site identifier for manufacturing facility impacted by outage for geographic and operational impact analysis."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of location where outage occurred or had primary impact."
    - name: "root_cause_category"
      expr: root_cause_category
      comment: "Standardized category of root cause identified during post-incident analysis for trend analysis and CAPA prioritization."
    - name: "detection_method"
      expr: detection_method
      comment: "Method by which outage was first identified (automated monitoring, user-reported, vendor alert, OT alarm system)."
    - name: "status"
      expr: status
      comment: "Current lifecycle status of outage record from initial detection through resolution and formal closure."
    - name: "post_incident_review_status"
      expr: post_incident_review_status
      comment: "Status of Post-Incident Review (PIR) or Post-Mortem process for outage requiring formal PIR to identify systemic issues."
    - name: "sla_breach_flag"
      expr: sla_breach_flag
      comment: "Indicates whether outage duration exceeded Recovery Time Objective (RTO) or availability SLA threshold for affected service."
  measures:
    - name: "total_outage_duration_minutes"
      expr: SUM(CAST(duration_minutes AS DOUBLE))
      comment: "Total elapsed time in minutes from outage start to service restoration for availability reporting and SLA compliance."
    - name: "avg_outage_duration_minutes"
      expr: AVG(CAST(duration_minutes AS DOUBLE))
      comment: "Average outage duration in minutes indicating typical recovery time and service reliability performance."
    - name: "total_financial_impact"
      expr: SUM(CAST(financial_impact_amount AS DOUBLE))
      comment: "Total estimated financial impact including lost production value, labor costs, and recovery expenses for business case and risk reporting."
    - name: "avg_oee_impact_pct"
      expr: AVG(CAST(oee_impact_percent AS DOUBLE))
      comment: "Average reduction in Overall Equipment Effectiveness (OEE) percentage attributable to outages, key KPI for manufacturing availability."
    - name: "total_production_loss_units"
      expr: SUM(CAST(production_loss_units AS DOUBLE))
      comment: "Total estimated number of production units lost due to outages for financial impact quantification."
    - name: "total_production_lines_affected"
      expr: SUM(CAST(production_lines_affected_count AS DOUBLE))
      comment: "Total number of distinct manufacturing production lines impacted by outages for production impact scoring."
    - name: "outage_count"
      expr: COUNT(1)
      comment: "Number of IT and OT service outage events for availability trend analysis and service reliability tracking."
    - name: "sla_breach_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN sla_breach_flag = true THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of outages that breached SLA thresholds, critical KPI for service level management and vendor performance."
    - name: "ot_outage_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN is_ot_outage = true THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of outages affecting Operational Technology systems for IT/OT convergence risk assessment and OT reliability tracking."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`technology_service_ticket`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "IT and OT service desk performance metrics tracking ticket volume, resolution times, SLA compliance, production impact, and support team workload across manufacturing ITSM operations. Enables service desk performance management, SLA compliance reporting, and IT/OT support optimization."
  source: "`manufacturing_ecm`.`technology`.`service_ticket`"
  dimensions:
    - name: "ticket_type"
      expr: ticket_type
      comment: "Classification according to ITIL practice (Incident, Service Request, Problem, Change Request) driving workflow routing and SLA policy."
    - name: "priority"
      expr: priority
      comment: "Priority level (P1 Critical, P2 High, P3 Medium, P4 Low) determining SLA response and resolution targets."
    - name: "category"
      expr: category
      comment: "Top-level classification (Hardware, Software, Network, OT/IIoT, Security, Access Management, Application) for routing and trend analysis."
    - name: "subcategory"
      expr: subcategory
      comment: "Second-level classification providing granular categorization for detailed trend analysis and workload distribution reporting."
    - name: "status"
      expr: status
      comment: "Current lifecycle state tracking progression from initial logging through resolution and closure."
    - name: "assigned_team"
      expr: assigned_team
      comment: "IT or OT support team currently responsible for resolving ticket for workload balancing and team performance reporting."
    - name: "impact"
      expr: impact
      comment: "Assessment of breadth of effect (High = enterprise/plant-wide, Medium = departmental, Low = individual user) combined with urgency to derive priority."
    - name: "urgency"
      expr: urgency
      comment: "Assessment of how quickly issue must be resolved (High = time-critical, Medium = degraded but operational, Low = deferrable)."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of site or location where ticket originated for multinational SLA compliance reporting."
    - name: "reported_by_department"
      expr: reported_by_department
      comment: "Organizational department of person who reported ticket for demand analysis and identifying departments with high incident volumes."
    - name: "production_impact_flag"
      expr: production_impact_flag
      comment: "Indicates whether incident directly impacted manufacturing production operations for OT/IT convergence impact tracking."
    - name: "sla_breach_flag"
      expr: sla_breach_flag
      comment: "Indicates whether ticket breached defined SLA resolution target for ITSM performance dashboards and continuous improvement."
    - name: "closure_code"
      expr: closure_code
      comment: "Standardized code indicating how ticket was ultimately closed for quality reporting and first-contact resolution measurement."
  measures:
    - name: "ticket_count"
      expr: COUNT(1)
      comment: "Number of service tickets for volume trend analysis, capacity planning, and support team workload assessment."
    - name: "sla_breach_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN sla_breach_flag = true THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of tickets that breached SLA resolution targets, key metric for ITSM performance and vendor penalty calculations."
    - name: "production_impact_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN production_impact_flag = true THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of tickets that directly impacted manufacturing production operations for OT/IT convergence risk assessment."
    - name: "avg_escalation_level"
      expr: AVG(CAST(escalation_level AS DOUBLE))
      comment: "Average escalation tier (1=first-line, 2=specialist, 3=vendor/expert) indicating support complexity and first-contact resolution effectiveness."
    - name: "distinct_affected_ci_count"
      expr: COUNT(DISTINCT configuration_item_id)
      comment: "Number of distinct Configuration Items affected by tickets for asset reliability analysis and infrastructure investment prioritization."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`technology_patch_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Patch deployment compliance and vulnerability remediation metrics tracking patch deployment timeliness, compliance status, OT/IT patch coverage, and security posture across IT assets and OT systems. Enables patch compliance reporting, vulnerability management, and OT patch governance per IEC 62443."
  source: "`manufacturing_ecm`.`technology`.`patch_record`"
  dimensions:
    - name: "patch_type"
      expr: patch_type
      comment: "Classification by primary purpose (security, functional, firmware, drivers, hotfixes) for patch portfolio management."
    - name: "patch_category"
      expr: patch_category
      comment: "Technology category (OS, application, OT/ICS, network device firmware, database) for OT/IT convergence governance."
    - name: "deployment_status"
      expr: deployment_status
      comment: "Current lifecycle status (pending, deployed, failed, deferred, rolled_back) for patch deployment tracking."
    - name: "compliance_status"
      expr: compliance_status
      comment: "Compliance posture relative to policy or regulatory deadline (compliant, non_compliant, exempt) for audit readiness."
    - name: "severity_rating"
      expr: severity_rating
      comment: "Vendor or internal risk-based severity classification (Critical, High, Medium, Low) aligned with CVSS severity bands."
    - name: "is_ot_system"
      expr: is_ot_system
      comment: "Indicates whether patched asset is OT/ICS component (PLC, SCADA, HMI, DCS) requiring additional change governance per IEC 62443."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of location where patched asset resides for multi-national patch compliance reporting."
    - name: "site_code"
      expr: site_code
      comment: "Code identifying manufacturing plant, facility, or data center site for site-level patch compliance reporting."
    - name: "patch_source"
      expr: patch_source
      comment: "Origin or distribution mechanism (WSUS, SCCM, OT vendor portals) for patch deployment tracking."
    - name: "tested_in_non_production"
      expr: tested_in_non_production
      comment: "Indicates whether patch was validated in non-production environment prior to production deployment, mandatory for OT/ICS patches."
    - name: "rollback_performed"
      expr: rollback_performed
      comment: "Indicates whether patch deployment was rolled back after application due to system instability or validation failure."
  measures:
    - name: "patch_record_count"
      expr: COUNT(1)
      comment: "Number of patch deployment records for patch volume analysis and vulnerability remediation tracking."
    - name: "avg_cvss_score"
      expr: AVG(CAST(cvss_score AS DOUBLE))
      comment: "Average CVSS base score (0.0-10.0) quantifying severity of vulnerabilities addressed by patches for risk prioritization."
    - name: "compliance_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN compliance_status = 'Compliant' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of patches deployed within required compliance timeframe, key KPI for patch compliance and audit readiness."
    - name: "ot_patch_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN is_ot_system = true THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of patches applied to OT/ICS systems for OT patch management governance and IEC 62443 compliance tracking."
    - name: "rollback_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN rollback_performed = true THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of patch deployments that required rollback indicating patch quality and testing effectiveness."
    - name: "pre_production_test_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN tested_in_non_production = true THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of patches validated in non-production environment prior to production deployment for change management quality."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`technology_vulnerability`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Cybersecurity and OT/IT vulnerability exposure metrics tracking vulnerability severity, remediation timeliness, OT/ICS risk exposure, and security posture across IT infrastructure and OT systems. Enables vulnerability management, OT/IT cybersecurity posture management, and IEC 62443 compliance."
  source: "`manufacturing_ecm`.`technology`.`vulnerability`"
  dimensions:
    - name: "severity"
      expr: severity
      comment: "Qualitative severity rating (Critical, High, Medium, Low) derived from CVSS base score driving prioritization and SLA-based remediation timelines."
    - name: "status"
      expr: status
      comment: "Current lifecycle status tracking progress from initial discovery through remediation, exception approval, or closure."
    - name: "is_ot_vulnerability"
      expr: is_ot_vulnerability
      comment: "Indicates whether vulnerability affects OT/ICS asset triggering specialized OT remediation workflows and IEC 62443 compliance tracking."
    - name: "type"
      expr: type
      comment: "Classification by technical nature or weakness category aligned with CWE (Common Weakness Enumeration) taxonomy."
    - name: "affected_asset_type"
      expr: affected_asset_type
      comment: "Category of affected asset distinguishing between IT infrastructure components and OT/ICS devices (PLCs, HMIs, SCADA servers)."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of location where affected asset resides for multi-country regulatory compliance reporting."
    - name: "site_code"
      expr: site_code
      comment: "Code identifying manufacturing plant, facility, or office location for site-level vulnerability posture reporting."
    - name: "network_zone"
      expr: network_zone
      comment: "Network security zone or Purdue Model level where affected asset resides for assessing blast radius and prioritizing OT/IT remediation."
    - name: "discovery_method"
      expr: discovery_method
      comment: "Method or source through which vulnerability was identified (automated scanning, penetration testing, ICS-CERT advisories, threat intelligence)."
    - name: "patch_available"
      expr: patch_available
      comment: "Indicates whether vendor-supplied patch or security update is available to remediate vulnerability."
    - name: "exploit_publicly_available"
      expr: exploit_publicly_available
      comment: "Indicates whether working exploit is publicly available significantly elevating remediation urgency."
    - name: "cisa_kev_listed"
      expr: cisa_kev_listed
      comment: "Indicates whether vulnerability appears in CISA Known Exploited Vulnerabilities (KEV) catalog mandating prioritized remediation."
    - name: "exception_approved"
      expr: exception_approved
      comment: "Indicates whether formal exception has been approved to allow vulnerability to remain unpatched beyond standard SLA."
  measures:
    - name: "vulnerability_count"
      expr: COUNT(1)
      comment: "Number of identified vulnerabilities for vulnerability exposure tracking and security posture assessment."
    - name: "avg_cvss_base_score"
      expr: AVG(CAST(cvss_base_score AS DOUBLE))
      comment: "Average CVSS base score (0.0-10.0) representing intrinsic severity of vulnerabilities for risk prioritization."
    - name: "critical_vulnerability_count"
      expr: SUM(CASE WHEN severity = 'Critical' THEN 1 ELSE 0 END)
      comment: "Number of critical severity vulnerabilities requiring immediate remediation for executive risk reporting."
    - name: "ot_vulnerability_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN is_ot_vulnerability = true THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of vulnerabilities affecting OT/ICS assets for OT cybersecurity risk assessment and IEC 62443 compliance tracking."
    - name: "patch_availability_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN patch_available = true THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of vulnerabilities with vendor-supplied patches available indicating remediation feasibility."
    - name: "exploit_available_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN exploit_publicly_available = true THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of vulnerabilities with publicly available exploits indicating elevated risk and remediation urgency."
    - name: "cisa_kev_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN cisa_kev_listed = true THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of vulnerabilities in CISA KEV catalog mandating prioritized remediation per CISA Binding Operational Directive 22-01."
    - name: "exception_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN exception_approved = true THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of vulnerabilities with approved exceptions to remain unpatched for risk acceptance governance tracking."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`technology_sla_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "IT and OT service level agreement performance metrics tracking actual vs target performance, compliance status, breach frequency, and service quality across manufacturing technology operations. Enables SLA compliance reporting, service performance management, and continuous service improvement (CSI)."
  source: "`manufacturing_ecm`.`technology`.`sla_performance`"
  dimensions:
    - name: "compliance_status"
      expr: compliance_status
      comment: "Current compliance status (Met, Breached, At Risk) indicating whether target was achieved for SLA governance."
    - name: "sla_metric_type"
      expr: sla_metric_type
      comment: "Type of SLA metric being measured (availability, response time, resolution time, MTTR, MTBF, throughput, error rate, RTO, RPO)."
    - name: "measurement_period_type"
      expr: measurement_period_type
      comment: "Granularity of measurement period (daily, weekly, monthly, quarterly, annual) determining reporting cadence and aggregation level."
    - name: "is_ot_service"
      expr: is_ot_service
      comment: "Indicates whether service being measured is OT service (SCADA, MES, PLC network) vs standard IT service with different compliance thresholds."
    - name: "service_category"
      expr: service_category
      comment: "Functional category of IT or OT service being measured for SLA performance analysis and benchmarking by service category."
    - name: "sla_tier"
      expr: sla_tier
      comment: "Service tier classification (Platinum, Gold, Silver, Bronze) corresponding to stringent performance targets for mission-critical systems."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code where service is delivered or consumed for multi-country SLA performance reporting."
    - name: "region"
      expr: region
      comment: "Geographic region (North America, EMEA, APAC) where service is delivered for regional SLA performance benchmarking."
    - name: "site_code"
      expr: site_code
      comment: "Code identifying manufacturing plant, facility, or data center site for geographic SLA performance analysis."
    - name: "escalation_status"
      expr: escalation_status
      comment: "Current escalation status tracking whether breach or at-risk condition has been escalated to management for governance reporting."
    - name: "review_status"
      expr: review_status
      comment: "Workflow status tracking whether measurement has been reviewed and approved by service owner and stakeholders."
  measures:
    - name: "sla_measurement_count"
      expr: COUNT(1)
      comment: "Number of SLA performance measurement records for SLA governance tracking and service portfolio coverage analysis."
    - name: "avg_actual_value"
      expr: AVG(CAST(actual_value AS DOUBLE))
      comment: "Average measured actual performance value achieved for SLA metric during measurement period for performance trending."
    - name: "avg_target_value"
      expr: AVG(CAST(target_value AS DOUBLE))
      comment: "Average contractually or operationally defined target value for SLA metric for baseline comparison."
    - name: "avg_variance_value"
      expr: AVG(CAST(variance_value AS DOUBLE))
      comment: "Average numeric difference between actual and target values (positive = above target, negative = underperformance) for variance analysis."
    - name: "total_breach_count"
      expr: SUM(CAST(breach_count AS DOUBLE))
      comment: "Total number of individual SLA breach events recorded triggering escalation and root cause analysis workflows."
    - name: "total_breach_duration_minutes"
      expr: SUM(CAST(breach_duration_minutes AS DOUBLE))
      comment: "Total cumulative duration in minutes of all SLA breach events for quantifying severity and business impact of non-compliance."
    - name: "total_affected_ticket_count"
      expr: SUM(CAST(affected_ticket_count AS DOUBLE))
      comment: "Total number of ITSM tickets impacted by SLA breaches or at-risk conditions for impact quantification and CSI reporting."
    - name: "sla_compliance_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN compliance_status = 'Met' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of SLA measurements that met target performance, key KPI for service level management and vendor performance."
    - name: "ot_service_rate_pct"
      expr: ROUND(100.0 * SUM(CASE WHEN is_ot_service = true THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of SLA measurements for OT services for OT/IT convergence service quality tracking and IEC 62443 compliance."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`technology_it_cost_allocation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "IT cost allocation and chargeback metrics tracking cost distribution, allocation methods, business unit consumption, and IT financial transparency using Technology Business Management (TBM) principles. Enables IT cost transparency, chargeback/showback reporting, and business-aligned IT financial management."
  source: "`manufacturing_ecm`.`technology`.`it_cost_allocation`"
  dimensions:
    - name: "allocation_method"
      expr: allocation_method
      comment: "Methodology used to distribute IT costs (usage-based, headcount, fixed) for allocation transparency and audit."
    - name: "allocation_model"
      expr: allocation_model
      comment: "Indicates whether allocation results in chargeback (real journal entry), showback (informational only), or pure internal allocation."
    - name: "cost_type"
      expr: cost_type
      comment: "Classification of IT cost category being allocated aligned with TBM taxonomy (infrastructure, application, cloud, OT/IT convergence)."
    - name: "capex_opex_classification"
      expr: capex_opex_classification
      comment: "Indicates whether allocated IT cost is CAPEX (asset investments) or OPEX (ongoing operational costs) for financial reporting."
    - name: "receiving_business_unit"
      expr: receiving_business_unit
      comment: "Name or code of manufacturing business unit receiving IT cost allocation for business-unit-level IT cost transparency reporting."
    - name: "receiving_cost_center"
      expr: receiving_cost_center
      comment: "SAP cost center code of organizational unit receiving IT cost allocation for granular cost center-level IT financial management."
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of receiving entity for regional IT cost analysis and country-specific financial reporting."
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year in which IT cost allocation is recorded for annual financial reporting and IT budget management."
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period (month number 1-12) within fiscal year for IT cost allocation recording."
    - name: "status"
      expr: status
      comment: "Current processing status tracking lifecycle from initial draft through financial posting or reversal."
    - name: "approval_status"
      expr: approval_status
      comment: "Approval workflow status tracking whether allocation has been reviewed and approved by relevant financial or IT governance authority."
  measures:
    - name: "total_allocated_amount"
      expr: SUM(CAST(allocated_amount AS DOUBLE))
      comment: "Total portion of IT cost allocated to business units, plants, cost centers, or production lines for chargeback or showback reporting."
    - name: "total_cost_pool"
      expr: SUM(CAST(total_cost AS DOUBLE))
      comment: "Total IT cost pool amount before allocation representing full cost of IT service or asset prior to distribution."
    - name: "avg_allocation_percentage"
      expr: AVG(CAST(allocation_percentage AS DOUBLE))
      comment: "Average percentage of total IT cost pool assigned to business units or cost centers for allocation distribution validation."
    - name: "allocation_record_count"
      expr: COUNT(1)
      comment: "Number of IT cost allocation transaction records for allocation complexity analysis and chargeback volume tracking."
    - name: "allocation_efficiency_pct"
      expr: ROUND(100.0 * SUM(CAST(allocated_amount AS DOUBLE)) / NULLIF(SUM(CAST(total_cost AS DOUBLE)), 0), 2)
      comment: "Percentage of total IT cost pool successfully allocated to business units indicating allocation completeness and accuracy."
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`technology_digital_initiative`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Digital transformation initiative and Industry 4.0 program performance metrics tracking investment, spend, expected outcomes (OEE improvement, cost reduction, cycle time reduction), and maturity progression. Supports CDO/CTO digital transformation governance and Industry 4.0 roadmap management."
  source: "`manufacturing_ecm`.`technology`.`digital_initiative`"
  dimensions:
    - name: "initiative_type"
      expr: initiative_type
      comment: "Classification by technology domain (IIoT deployment, smart factory program, digital twin implementation, AI/ML adoption, cloud migration wave)."
    - name: "status"
      expr: status
      comment: "Current lifecycle status from ideation through execution to completion or cancellation for portfolio health tracking."
    - name: "roadmap_phase"
      expr: roadmap_phase
      comment: "Current phase within enterprise digital transformation roadmap (foundational infrastructure, pilot, scale-out, optimization, sustainment)."
    - name: "maturity_level"
      expr: maturity_level
      comment: "Current digital maturity level based on industry-standard capability maturity model (Initial to Optimizing)."
    - name: "strategic_objective"
      expr: strategic_objective
      comment: "Primary strategic objective (OEE improvement, cost reduction, cycle time reduction, quality improvement) for outcome tracking."
    - name: "priority"
      expr: priority
      comment: "Business priority level assigned by digital governance board for resource allocation and portfolio sequencing."
    - name: "risk_level"
      expr: risk_level
      comment: "Overall risk level based on enterprise risk assessment considering technical complexity, organizational change impact, and financial exposure."
    - name: "deployment_scope"
      expr: deployment_scope
      comment: "Geographic or organizational scope (global, regional, country level, specific site/plant/production line) for deployment tracking."
    - name: "investment_category"
      expr: investment_category
      comment: "Classification of initiative investment as CAPEX, OPEX, or mixed investment type for financial reporting."
    - name: "sponsoring_business_unit"
      expr: sponsoring_business_unit
      comment: "Name of business unit or organizational division that is primary sponsor and accountable owner of digital initiative."
  measures:
    - name: "total_approved_budget"
      expr: SUM(CAST(approved_budget AS DOUBLE))
      comment: "Total approved capital and operational expenditure (CAPEX + OPEX) budget allocated to digital initiatives."
    - name: "total_actual_spend"
      expr: SUM(CAST(actual_spend AS DOUBLE))
      comment: "Cumulative actual expenditure incurred on digital initiatives to date for budget variance tracking."
    - name: "budget_utilization_pct"
      expr: ROUND(100.0 * SUM(CAST(actual_spend AS DOUBLE)) / NULLIF(SUM(CAST(approved_budget AS DOUBLE)), 0), 2)
      comment: "Percentage of approved digital initiative budget consumed by actual spend for financial performance tracking."
    - name: "avg_expected_oee_improvement_pct"
      expr: AVG(CAST(expected_oee_improvement_percent AS DOUBLE))
      comment: "Average target percentage improvement in Overall Equipment Effectiveness (OEE) expected as key business outcome."
    - name: "avg_expected_cost_reduction_pct"
      expr: AVG(CAST(expected_cost_reduction_percent AS DOUBLE))
      comment: "Average target percentage reduction in operational or production costs expected as measurable business outcome."
    - name: "avg_expected_cycle_time_reduction_pct"
      expr: AVG(CAST(expected_cycle_time_reduction_percent AS DOUBLE))
      comment: "Average target percentage reduction in manufacturing cycle time expected as key performance outcome."
    - name: "avg_expected_roi_pct"
      expr: AVG(CAST(expected_roi_percent AS DOUBLE))
      comment: "Average projected Return on Investment (ROI) percentage expected from digital initiatives upon full implementation."
    - name: "initiative_count"
      expr: COUNT(1)
      comment: "Number of enterprise digital transformation initiatives and Industry 4.0 programs for portfolio complexity analysis."
$$;