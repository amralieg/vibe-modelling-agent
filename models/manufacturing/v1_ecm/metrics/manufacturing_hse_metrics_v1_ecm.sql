-- Metric views for domain: hse | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`hse_ghg_emission`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Greenhouse gas emissions metrics for carbon footprint tracking, climate reporting (CDP, TCFD), and decarbonization target management"
  source: "`manufacturing_ecm`.`hse`.`ghg_emission`"
  dimensions:
    - name: "ghg_scope"
      expr: ghg_scope
      comment: "GHG Protocol scope classification (Scope 1, 2, 3) for emissions categorization"
    - name: "ghg_type"
      expr: ghg_type
      comment: "Type of greenhouse gas (CO2, CH4, N2O, HFCs, etc.)"
    - name: "emission_source_type"
      expr: emission_source_type
      comment: "Category of emission source (stationary combustion, mobile, fugitive, purchased electricity)"
    - name: "facility_code"
      expr: facility_code
      comment: "Manufacturing facility or site code for location-based emissions tracking"
    - name: "facility_country_code"
      expr: facility_country_code
      comment: "Country code for geographic emissions analysis and regulatory reporting"
    - name: "reporting_period_year"
      expr: YEAR(reporting_period_start_date)
      comment: "Reporting year for annual emissions disclosure and target tracking"
    - name: "reporting_period_month"
      expr: DATE_TRUNC('MONTH', reporting_period_start_date)
      comment: "Reporting month for emissions trending and forecasting"
    - name: "scope3_category"
      expr: scope3_category
      comment: "Scope 3 category per GHG Protocol (purchased goods, business travel, etc.)"
    - name: "verification_status"
      expr: verification_status
      comment: "Third-party verification status for assured emissions data"
    - name: "renewable_energy_flag"
      expr: renewable_energy_flag
      comment: "Indicates if emissions offset by renewable energy certificates"
  measures:
    - name: "total_co2e_tonnes"
      expr: SUM(CAST(co2e_quantity_tonnes AS DOUBLE))
      comment: "Total CO2 equivalent emissions in metric tonnes for carbon footprint reporting"
    - name: "total_biogenic_co2_tonnes"
      expr: SUM(CAST(biogenic_co2_tonnes AS DOUBLE))
      comment: "Total biogenic CO2 emissions reported separately per GHG Protocol"
    - name: "total_activity_data"
      expr: SUM(CAST(activity_data_quantity AS DOUBLE))
      comment: "Total activity data quantity (fuel consumed, electricity used, etc.) driving emissions"
    - name: "unique_emission_sources"
      expr: COUNT(DISTINCT emission_source_name)
      comment: "Number of distinct emission sources for inventory completeness assessment"
    - name: "emission_records"
      expr: COUNT(1)
      comment: "Total number of emission records for data quality and coverage tracking"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`hse_energy_consumption`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Energy consumption and cost metrics for ISO 50001 energy management, efficiency tracking, and operational cost optimization"
  source: "`manufacturing_ecm`.`hse`.`energy_consumption`"
  dimensions:
    - name: "energy_source_type"
      expr: energy_source_type
      comment: "Primary energy source category (electricity, natural gas, diesel, steam, etc.)"
    - name: "energy_source_subtype"
      expr: energy_source_subtype
      comment: "Detailed energy source classification for granular analysis"
    - name: "facility_code"
      expr: facility_code
      comment: "Manufacturing facility or site code for location-based energy tracking"
    - name: "facility_country_code"
      expr: facility_country_code
      comment: "Country code for geographic energy analysis and benchmarking"
    - name: "ghg_scope"
      expr: ghg_scope
      comment: "GHG scope associated with energy consumption for emissions linkage"
    - name: "renewable_energy_flag"
      expr: renewable_energy_flag
      comment: "Indicates renewable energy source for sustainability reporting"
    - name: "billing_period_year"
      expr: YEAR(billing_period_start_date)
      comment: "Year of energy billing period for annual consumption analysis"
    - name: "billing_period_month"
      expr: DATE_TRUNC('MONTH', billing_period_start_date)
      comment: "Month of billing period for seasonal consumption patterns"
    - name: "department_code"
      expr: department_code
      comment: "Department or cost center for energy cost allocation"
    - name: "meter_type"
      expr: meter_type
      comment: "Type of metering (main, sub-meter, virtual) for data quality assessment"
  measures:
    - name: "total_consumption_gj"
      expr: SUM(CAST(consumption_quantity_gj AS DOUBLE))
      comment: "Total energy consumption in gigajoules for normalized energy performance tracking"
    - name: "total_energy_cost"
      expr: SUM(CAST(energy_cost AS DOUBLE))
      comment: "Total energy expenditure for cost management and budget variance analysis"
    - name: "total_co2e_emissions_kg"
      expr: SUM(CAST(co2e_emissions_kg AS DOUBLE))
      comment: "Total CO2 equivalent emissions from energy consumption for carbon accounting"
    - name: "total_consumption_quantity"
      expr: SUM(CAST(consumption_quantity AS DOUBLE))
      comment: "Total energy consumption in native units (kWh, therms, liters, etc.)"
    - name: "unique_meters"
      expr: COUNT(DISTINCT meter_name)
      comment: "Number of distinct energy meters for coverage and data completeness assessment"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`hse_safety_audit`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Safety audit performance metrics for management system effectiveness, compliance verification, and continuous improvement tracking"
  source: "`manufacturing_ecm`.`hse`.`safety_audit`"
  dimensions:
    - name: "audit_type"
      expr: audit_type
      comment: "Type of audit (internal, external, certification, regulatory, supplier)"
    - name: "audit_category"
      expr: audit_category
      comment: "Audit category (ISO 45001, ISO 14001, OSHA VPP, process safety, etc.)"
    - name: "regulatory_standard"
      expr: regulatory_standard
      comment: "Regulatory or voluntary standard being audited against"
    - name: "facility_site_code"
      expr: facility_site_code
      comment: "Facility or site code where audit was conducted"
    - name: "facility_country_code"
      expr: facility_country_code
      comment: "Country where audit was conducted for regional compliance tracking"
    - name: "overall_rating"
      expr: overall_rating
      comment: "Overall audit rating or grade (excellent, satisfactory, needs improvement, etc.)"
    - name: "audit_year"
      expr: YEAR(actual_start_date)
      comment: "Year when audit was conducted for annual compliance tracking"
    - name: "audit_quarter"
      expr: DATE_TRUNC('QUARTER', actual_start_date)
      comment: "Quarter when audit was conducted for quarterly performance review"
    - name: "certifying_body"
      expr: certifying_body
      comment: "Certification body or auditing organization for third-party audits"
    - name: "status"
      expr: status
      comment: "Audit status (planned, in progress, completed, closed)"
  measures:
    - name: "total_audits"
      expr: COUNT(1)
      comment: "Total number of safety audits conducted for audit program coverage tracking"
    - name: "avg_conformance_score"
      expr: AVG(CAST(conformance_score AS DOUBLE))
      comment: "Average conformance score across audits for management system effectiveness assessment"
    - name: "audits_with_follow_up_required"
      expr: COUNT(CASE WHEN follow_up_required = TRUE THEN 1 END)
      comment: "Number of audits requiring follow-up actions for corrective action workload planning"
    - name: "unique_facilities_audited"
      expr: COUNT(DISTINCT facility_site_code)
      comment: "Number of distinct facilities audited for audit program coverage assessment"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`hse_hse_audit_finding`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Audit finding and non-conformance metrics for corrective action management, compliance gap analysis, and audit effectiveness measurement"
  source: "`manufacturing_ecm`.`hse`.`hse_audit_finding`"
  dimensions:
    - name: "finding_type"
      expr: finding_type
      comment: "Type of finding (non-conformance, observation, opportunity for improvement, positive finding)"
    - name: "severity"
      expr: severity
      comment: "Severity classification (critical, major, minor) for prioritization"
    - name: "finding_category"
      expr: finding_category
      comment: "Category of finding (documentation, training, equipment, procedure, etc.)"
    - name: "facility_code"
      expr: facility_code
      comment: "Facility where finding was identified"
    - name: "facility_country_code"
      expr: facility_country_code
      comment: "Country where finding was identified for regional analysis"
    - name: "status"
      expr: status
      comment: "Finding status (open, in progress, closed, verified)"
    - name: "repeat_finding"
      expr: repeat_finding
      comment: "Indicates if finding is a repeat from previous audit for effectiveness assessment"
    - name: "regulatory_reportable"
      expr: regulatory_reportable
      comment: "Whether finding requires regulatory notification"
    - name: "identified_year"
      expr: YEAR(identified_date)
      comment: "Year when finding was identified for annual trending"
    - name: "identified_month"
      expr: DATE_TRUNC('MONTH', identified_date)
      comment: "Month when finding was identified for monthly tracking"
    - name: "root_cause_category"
      expr: root_cause_category
      comment: "Root cause classification for systemic issue identification"
  measures:
    - name: "total_findings"
      expr: COUNT(1)
      comment: "Total number of audit findings for audit program effectiveness tracking"
    - name: "open_findings"
      expr: COUNT(CASE WHEN status IN ('Open', 'In Progress') THEN 1 END)
      comment: "Number of open findings requiring corrective action for workload management"
    - name: "repeat_findings"
      expr: COUNT(CASE WHEN repeat_finding = TRUE THEN 1 END)
      comment: "Number of repeat findings indicating ineffective corrective actions"
    - name: "regulatory_reportable_findings"
      expr: COUNT(CASE WHEN regulatory_reportable = TRUE THEN 1 END)
      comment: "Number of findings requiring regulatory notification for compliance risk assessment"
    - name: "unique_facilities_with_findings"
      expr: COUNT(DISTINCT facility_code)
      comment: "Number of facilities with findings for geographic risk distribution analysis"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`hse_compliance_evaluation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Regulatory compliance evaluation metrics for legal obligation fulfillment tracking, compliance risk assessment, and audit readiness"
  source: "`manufacturing_ecm`.`hse`.`compliance_evaluation`"
  dimensions:
    - name: "compliance_status"
      expr: compliance_status
      comment: "Compliance status (compliant, non-compliant, partially compliant, not applicable)"
    - name: "evaluation_type"
      expr: evaluation_type
      comment: "Type of compliance evaluation (self-assessment, third-party, regulatory inspection)"
    - name: "obligation_category"
      expr: obligation_category
      comment: "Category of regulatory obligation (environmental, safety, health, process safety)"
    - name: "facility_code"
      expr: facility_code
      comment: "Facility where compliance was evaluated"
    - name: "facility_country_code"
      expr: facility_country_code
      comment: "Country where compliance was evaluated for jurisdictional analysis"
    - name: "regulatory_body"
      expr: regulatory_body
      comment: "Regulatory authority or agency overseeing compliance"
    - name: "evaluation_year"
      expr: YEAR(evaluation_date)
      comment: "Year when evaluation was conducted for annual compliance tracking"
    - name: "evaluation_quarter"
      expr: DATE_TRUNC('QUARTER', evaluation_date)
      comment: "Quarter when evaluation was conducted for quarterly compliance review"
    - name: "follow_up_action_required"
      expr: follow_up_action_required
      comment: "Indicates if follow-up action is required to achieve compliance"
    - name: "status"
      expr: status
      comment: "Evaluation status (open, in progress, closed)"
  measures:
    - name: "total_evaluations"
      expr: COUNT(1)
      comment: "Total number of compliance evaluations conducted for program coverage tracking"
    - name: "non_compliant_evaluations"
      expr: COUNT(CASE WHEN compliance_status IN ('Non-Compliant', 'Partially Compliant') THEN 1 END)
      comment: "Number of evaluations identifying compliance gaps for risk prioritization"
    - name: "evaluations_requiring_follow_up"
      expr: COUNT(CASE WHEN follow_up_action_required = TRUE THEN 1 END)
      comment: "Number of evaluations requiring corrective action for workload planning"
    - name: "unique_obligations_evaluated"
      expr: COUNT(DISTINCT regulatory_obligation_id)
      comment: "Number of distinct regulatory obligations evaluated for coverage assessment"
    - name: "unique_facilities_evaluated"
      expr: COUNT(DISTINCT facility_code)
      comment: "Number of distinct facilities evaluated for geographic compliance coverage"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`hse_environmental_permit`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Environmental permit management metrics for regulatory authorization tracking, renewal planning, and compliance risk management"
  source: "`manufacturing_ecm`.`hse`.`environmental_permit`"
  dimensions:
    - name: "permit_type"
      expr: permit_type
      comment: "Type of environmental permit (air, water, waste, hazardous materials, etc.)"
    - name: "status"
      expr: status
      comment: "Permit status (active, expired, pending renewal, suspended, revoked)"
    - name: "facility_code"
      expr: facility_code
      comment: "Facility covered by permit"
    - name: "facility_country_code"
      expr: facility_country_code
      comment: "Country where permit is issued for jurisdictional tracking"
    - name: "facility_state_province"
      expr: facility_state_province
      comment: "State or province where permit is issued for regional compliance"
    - name: "issuing_authority_name"
      expr: issuing_authority_name
      comment: "Regulatory authority that issued permit"
    - name: "renewal_status"
      expr: renewal_status
      comment: "Renewal status (not due, pending, submitted, approved)"
    - name: "major_source_flag"
      expr: major_source_flag
      comment: "Indicates if facility is classified as major source requiring enhanced oversight"
    - name: "open_violation_flag"
      expr: open_violation_flag
      comment: "Indicates if permit has open violations requiring resolution"
    - name: "issue_year"
      expr: YEAR(issue_date)
      comment: "Year when permit was issued for permit portfolio age analysis"
  measures:
    - name: "total_permits"
      expr: COUNT(1)
      comment: "Total number of environmental permits for portfolio management"
    - name: "active_permits"
      expr: COUNT(CASE WHEN status = 'Active' THEN 1 END)
      comment: "Number of active permits for operational compliance tracking"
    - name: "permits_expiring_soon"
      expr: COUNT(CASE WHEN status = 'Active' AND expiration_date <= DATE_ADD(CURRENT_DATE, 180) THEN 1 END)
      comment: "Number of permits expiring within 180 days for renewal planning"
    - name: "permits_with_violations"
      expr: COUNT(CASE WHEN open_violation_flag = TRUE THEN 1 END)
      comment: "Number of permits with open violations for compliance risk assessment"
    - name: "total_permit_fees"
      expr: SUM(CAST(permit_fee_amount AS DOUBLE))
      comment: "Total permit fee expenditure for budget management"
    - name: "unique_facilities_with_permits"
      expr: COUNT(DISTINCT facility_code)
      comment: "Number of facilities with environmental permits for coverage assessment"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`hse_waste_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Waste generation and disposal metrics for waste minimization programs, regulatory reporting (RCRA, EPA), and circular economy initiatives"
  source: "`manufacturing_ecm`.`hse`.`waste_record`"
  dimensions:
    - name: "waste_type"
      expr: waste_type
      comment: "Type of waste (hazardous, non-hazardous, universal, special)"
    - name: "disposal_method"
      expr: disposal_method
      comment: "Method of waste disposal (landfill, incineration, recycling, treatment, energy recovery)"
    - name: "waste_minimization_category"
      expr: waste_minimization_category
      comment: "Waste hierarchy category (reduce, reuse, recycle, recover, dispose)"
    - name: "generator_category"
      expr: generator_category
      comment: "EPA generator category (CESQG, SQG, LQG) for regulatory classification"
    - name: "facility_country_code"
      expr: facility_country_code
      comment: "Country where waste was generated for geographic analysis"
    - name: "generation_source"
      expr: generation_source
      comment: "Process or activity generating waste for source reduction targeting"
    - name: "generation_year"
      expr: YEAR(generation_date)
      comment: "Year when waste was generated for annual reporting"
    - name: "generation_month"
      expr: DATE_TRUNC('MONTH', generation_date)
      comment: "Month when waste was generated for monthly trending"
    - name: "epa_waste_code"
      expr: epa_waste_code
      comment: "EPA hazardous waste code for regulatory classification"
    - name: "status"
      expr: status
      comment: "Waste record status (generated, stored, shipped, disposed)"
  measures:
    - name: "total_waste_quantity"
      expr: SUM(CAST(quantity_generated AS DOUBLE))
      comment: "Total waste quantity generated for waste minimization program tracking"
    - name: "total_disposal_cost"
      expr: SUM(CAST(disposal_cost AS DOUBLE))
      comment: "Total waste disposal expenditure for cost reduction opportunity identification"
    - name: "waste_records"
      expr: COUNT(1)
      comment: "Total number of waste records for data completeness assessment"
    - name: "unique_waste_types"
      expr: COUNT(DISTINCT waste_type)
      comment: "Number of distinct waste types for waste stream diversity analysis"
    - name: "unique_disposal_facilities"
      expr: COUNT(DISTINCT disposal_facility_name)
      comment: "Number of distinct disposal facilities for vendor management"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`hse_chemical_inventory`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Chemical inventory and hazardous materials management metrics for regulatory compliance (EPCRA Tier II, OSHA PSM), safety stock optimization, and exposure risk management"
  source: "`manufacturing_ecm`.`hse`.`chemical_inventory`"
  dimensions:
    - name: "chemical_category"
      expr: chemical_category
      comment: "Chemical category classification (solvent, acid, base, oxidizer, etc.)"
    - name: "physical_state"
      expr: physical_state
      comment: "Physical state of chemical (solid, liquid, gas) for storage and handling requirements"
    - name: "facility_code"
      expr: facility_code
      comment: "Facility where chemical is stored"
    - name: "facility_name"
      expr: facility_name
      comment: "Facility name for location-based inventory management"
    - name: "country_code"
      expr: country_code
      comment: "Country where chemical is stored for jurisdictional compliance"
    - name: "storage_location_code"
      expr: storage_location_code
      comment: "Storage location code for warehouse management"
    - name: "psm_covered"
      expr: psm_covered
      comment: "Indicates if chemical is covered under OSHA Process Safety Management"
    - name: "tier2_reportable"
      expr: tier2_reportable
      comment: "Indicates if chemical requires EPCRA Tier II reporting"
    - name: "status"
      expr: status
      comment: "Inventory record status (active, expired, disposed)"
    - name: "reporting_year"
      expr: reporting_year
      comment: "Reporting year for annual regulatory submissions"
  measures:
    - name: "total_quantity_on_hand"
      expr: SUM(CAST(quantity_on_hand AS DOUBLE))
      comment: "Total chemical quantity on hand for inventory value and regulatory threshold tracking"
    - name: "total_max_authorized_quantity"
      expr: SUM(CAST(max_authorized_quantity AS DOUBLE))
      comment: "Total maximum authorized quantity for capacity planning and compliance verification"
    - name: "unique_chemical_substances"
      expr: COUNT(DISTINCT chemical_substance_id)
      comment: "Number of distinct chemical substances for inventory complexity assessment"
    - name: "inventory_records"
      expr: COUNT(1)
      comment: "Total number of chemical inventory records for data completeness tracking"
    - name: "psm_covered_chemicals"
      expr: COUNT(CASE WHEN psm_covered = TRUE THEN 1 END)
      comment: "Number of chemicals covered under OSHA PSM for process safety program scope"
    - name: "tier2_reportable_chemicals"
      expr: COUNT(CASE WHEN tier2_reportable = TRUE THEN 1 END)
      comment: "Number of chemicals requiring Tier II reporting for regulatory submission planning"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`hse_safety_training`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Safety training program metrics for regulatory compliance (OSHA training requirements), competency management, and training effectiveness assessment"
  source: "`manufacturing_ecm`.`hse`.`safety_training`"
  dimensions:
    - name: "training_type"
      expr: training_type
      comment: "Type of safety training (initial, refresher, specialized, emergency response)"
    - name: "training_category"
      expr: training_category
      comment: "Training category (general safety, hazard-specific, equipment-specific, regulatory)"
    - name: "program_name"
      expr: program_name
      comment: "Training program name for curriculum management"
    - name: "delivery_method"
      expr: delivery_method
      comment: "Training delivery method (classroom, online, hands-on, blended)"
    - name: "facility_code"
      expr: facility_code
      comment: "Facility where training was conducted"
    - name: "facility_country_code"
      expr: facility_country_code
      comment: "Country where training was conducted for regional program tracking"
    - name: "training_year"
      expr: YEAR(training_date)
      comment: "Year when training was conducted for annual program assessment"
    - name: "training_month"
      expr: DATE_TRUNC('MONTH', training_date)
      comment: "Month when training was conducted for monthly activity tracking"
    - name: "trainer_type"
      expr: trainer_type
      comment: "Type of trainer (internal, external, certified, subject matter expert)"
    - name: "status"
      expr: status
      comment: "Training session status (scheduled, completed, cancelled)"
  measures:
    - name: "total_training_sessions"
      expr: COUNT(1)
      comment: "Total number of safety training sessions conducted for program activity tracking"
    - name: "total_training_hours"
      expr: SUM(CAST(duration_hours AS DOUBLE))
      comment: "Total training hours delivered for resource investment and compliance documentation"
    - name: "avg_training_duration"
      expr: AVG(CAST(duration_hours AS DOUBLE))
      comment: "Average training session duration for program efficiency assessment"
    - name: "unique_training_programs"
      expr: COUNT(DISTINCT program_code)
      comment: "Number of distinct training programs for curriculum diversity assessment"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`hse_emission_monitoring`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Air and water emission monitoring metrics for permit compliance verification, exceedance management, and environmental performance tracking"
  source: "`manufacturing_ecm`.`hse`.`emission_monitoring`"
  dimensions:
    - name: "pollutant_name"
      expr: pollutant_name
      comment: "Name of pollutant being monitored (NOx, SOx, PM, VOC, etc.)"
    - name: "emission_medium"
      expr: emission_medium
      comment: "Medium of emission (air, water, soil) for regulatory program classification"
    - name: "emission_source_type"
      expr: emission_source_type
      comment: "Type of emission source (stack, vent, outfall, fugitive)"
    - name: "monitoring_point_name"
      expr: monitoring_point_name
      comment: "Monitoring point identifier for location-specific tracking"
    - name: "facility_code"
      expr: facility_code
      comment: "Facility where monitoring is conducted"
    - name: "facility_country_code"
      expr: facility_country_code
      comment: "Country where monitoring is conducted for jurisdictional compliance"
    - name: "exceedance_flag"
      expr: exceedance_flag
      comment: "Indicates if measurement exceeded permit limit for compliance violation tracking"
    - name: "monitoring_method"
      expr: monitoring_method
      comment: "Monitoring method (continuous, periodic, manual, automated)"
    - name: "monitoring_year"
      expr: YEAR(monitoring_date)
      comment: "Year when monitoring was conducted for annual reporting"
    - name: "monitoring_month"
      expr: DATE_TRUNC('MONTH', monitoring_date)
      comment: "Month when monitoring was conducted for monthly trending"
  measures:
    - name: "total_measurements"
      expr: COUNT(1)
      comment: "Total number of emission measurements for monitoring program coverage assessment"
    - name: "exceedances"
      expr: COUNT(CASE WHEN exceedance_flag = TRUE THEN 1 END)
      comment: "Number of permit limit exceedances for compliance risk assessment"
    - name: "avg_measurement_value"
      expr: AVG(CAST(measurement_value AS DOUBLE))
      comment: "Average measured emission value for performance trending"
    - name: "max_measurement_value"
      expr: MAX(CAST(measurement_value AS DOUBLE))
      comment: "Maximum measured emission value for peak excursion analysis"
    - name: "unique_monitoring_points"
      expr: COUNT(DISTINCT monitoring_point_name)
      comment: "Number of distinct monitoring points for program coverage assessment"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`hse_contractor_qualification`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Contractor HSE qualification metrics for supplier safety performance tracking, pre-qualification management, and contractor risk assessment"
  source: "`manufacturing_ecm`.`hse`.`contractor_qualification`"
  dimensions:
    - name: "qualification_status"
      expr: qualification_status
      comment: "Contractor qualification status (qualified, disqualified, pending, expired)"
    - name: "contractor_type"
      expr: contractor_type
      comment: "Type of contractor (construction, maintenance, service, professional)"
    - name: "risk_tier"
      expr: risk_tier
      comment: "Risk tier classification (high, medium, low) for oversight intensity"
    - name: "hse_program_rating"
      expr: hse_program_rating
      comment: "HSE program rating (excellent, good, acceptable, needs improvement)"
    - name: "facility_code"
      expr: facility_code
      comment: "Facility where contractor is qualified to work"
    - name: "facility_country_code"
      expr: facility_country_code
      comment: "Country where contractor is qualified for regional tracking"
    - name: "qualification_year"
      expr: YEAR(qualification_date)
      comment: "Year when contractor was qualified for annual program assessment"
    - name: "osha_10_certified"
      expr: osha_10_certified
      comment: "Indicates if contractor has OSHA 10-hour certification"
    - name: "osha_30_certified"
      expr: osha_30_certified
      comment: "Indicates if contractor has OSHA 30-hour certification"
  measures:
    - name: "total_contractors"
      expr: COUNT(1)
      comment: "Total number of contractor qualification records for supplier base tracking"
    - name: "qualified_contractors"
      expr: COUNT(CASE WHEN qualification_status = 'Qualified' THEN 1 END)
      comment: "Number of qualified contractors for approved supplier pool management"
    - name: "avg_hse_program_score"
      expr: AVG(CAST(hse_program_score AS DOUBLE))
      comment: "Average HSE program score for contractor safety performance benchmarking"
    - name: "avg_trir"
      expr: AVG(CAST(trir AS DOUBLE))
      comment: "Average Total Recordable Incident Rate for contractor safety performance assessment"
    - name: "unique_contractor_companies"
      expr: COUNT(DISTINCT contractor_company_code)
      comment: "Number of distinct contractor companies for supplier diversity tracking"
$$;