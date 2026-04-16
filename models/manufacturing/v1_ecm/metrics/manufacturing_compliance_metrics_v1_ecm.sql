-- Metric views for domain: compliance | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`compliance_compliance_audit_finding`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Key performance indicators for audit findings management, tracking finding severity distribution, closure performance, and repeat finding trends to drive continuous improvement in compliance posture."
  source: "`manufacturing_ecm`.`compliance`.`compliance_audit_finding`"
  dimensions:
    - name: "Finding Type"
      expr: finding_type
      comment: "Classification of audit finding severity (major non-conformance, minor non-conformance, observation, opportunity for improvement)"
    - name: "Finding Status"
      expr: finding_status
      comment: "Current lifecycle status of the audit finding (open, in progress, closed, verified)"
    - name: "Audit Type"
      expr: audit_type
      comment: "Type of audit during which finding was raised (internal, external, certification, regulatory)"
    - name: "Risk Severity"
      expr: risk_severity
      comment: "Risk severity rating assigned to the audit finding based on potential impact"
    - name: "Process Area"
      expr: process_area
      comment: "Business process or functional area where the finding was identified"
    - name: "Department"
      expr: department
      comment: "Organizational department where the audit finding was identified"
    - name: "Country"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of jurisdiction where audit finding was raised"
    - name: "Repeat Finding Flag"
      expr: repeat_finding
      comment: "Indicates whether this finding is a recurrence of a previously identified audit finding"
    - name: "Finding Year"
      expr: YEAR(finding_date)
      comment: "Calendar year when the audit finding was identified"
    - name: "Finding Month"
      expr: DATE_TRUNC('MONTH', finding_date)
      comment: "Month when the audit finding was identified, for trend analysis"
  measures:
    - name: "Total Findings"
      expr: COUNT(1)
      comment: "Total number of audit findings raised across all audits"
    - name: "Major Findings Count"
      expr: COUNT(CASE WHEN finding_type = 'Major Non-Conformance' THEN 1 END)
      comment: "Count of major non-conformance findings requiring immediate corrective action"
    - name: "Critical Findings Count"
      expr: COUNT(CASE WHEN finding_type = 'Critical' THEN 1 END)
      comment: "Count of critical-severity findings representing immediate regulatory risk"
    - name: "Closed Findings Count"
      expr: COUNT(CASE WHEN finding_status = 'Closed' THEN 1 END)
      comment: "Count of audit findings that have been successfully closed and verified"
    - name: "Overdue Findings Count"
      expr: COUNT(CASE WHEN target_closure_date < CURRENT_DATE() AND finding_status NOT IN ('Closed', 'Verified') THEN 1 END)
      comment: "Count of audit findings past their target closure date and still open"
    - name: "Repeat Findings Count"
      expr: COUNT(CASE WHEN repeat_finding = TRUE THEN 1 END)
      comment: "Count of findings that are recurrences of previously identified issues, indicating systemic problems"
    - name: "Findings Requiring Regulatory Notification"
      expr: COUNT(CASE WHEN regulatory_notification_required = TRUE THEN 1 END)
      comment: "Count of findings requiring formal notification to regulatory authorities"
    - name: "Avg Days to Close"
      expr: AVG(DATEDIFF(actual_closure_date, finding_date))
      comment: "Average number of days from finding identification to verified closure"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`compliance_internal_audit`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic KPIs for internal audit program effectiveness, measuring audit coverage, finding rates, schedule adherence, and follow-up completion to ensure continuous compliance monitoring."
  source: "`manufacturing_ecm`.`compliance`.`internal_audit`"
  dimensions:
    - name: "Audit Type"
      expr: audit_type
      comment: "Classification of internal audit by primary focus (system-level, process-level, product-level, compliance-specific)"
    - name: "Audit Status"
      expr: status
      comment: "Current lifecycle status of the internal audit (planned, in progress, completed, closed)"
    - name: "Overall Result"
      expr: overall_result
      comment: "Overall outcome of the internal audit (compliant, non-compliant, partially compliant)"
    - name: "Business Unit"
      expr: business_unit
      comment: "Organizational business unit or division subject to the audit"
    - name: "Facility Country"
      expr: facility_country_code
      comment: "ISO 3166-1 alpha-3 country code of facility where internal audit was conducted"
    - name: "Process Area"
      expr: process_area
      comment: "Specific business process or functional area within scope of the audit"
    - name: "Audit Method"
      expr: audit_method
      comment: "Method by which internal audit was conducted (on-site, remote, hybrid)"
    - name: "Audit Year"
      expr: YEAR(actual_start_date)
      comment: "Calendar year when the internal audit was conducted"
    - name: "Audit Quarter"
      expr: CONCAT('Q', QUARTER(actual_start_date), ' ', YEAR(actual_start_date))
      comment: "Fiscal quarter when the internal audit was conducted"
  measures:
    - name: "Total Audits"
      expr: COUNT(1)
      comment: "Total number of internal audits conducted across all business units and facilities"
    - name: "Completed Audits"
      expr: COUNT(CASE WHEN status IN ('Completed', 'Closed') THEN 1 END)
      comment: "Count of internal audits that have been completed and closed"
    - name: "Non-Compliant Audits"
      expr: COUNT(CASE WHEN overall_result = 'Non-Compliant' THEN 1 END)
      comment: "Count of audits with overall non-compliant result requiring corrective action"
    - name: "Audits Requiring CAPA"
      expr: COUNT(CASE WHEN capa_required = TRUE THEN 1 END)
      comment: "Count of audits triggering formal Corrective and Preventive Action process"
    - name: "Total Critical Findings"
      expr: SUM(CAST(findings_critical_count AS INT))
      comment: "Sum of all critical-severity findings across all audits"
    - name: "Total Major Findings"
      expr: SUM(CAST(findings_major_count AS INT))
      comment: "Sum of all major non-conformance findings across all audits"
    - name: "Total Minor Findings"
      expr: SUM(CAST(findings_minor_count AS INT))
      comment: "Sum of all minor non-conformance findings across all audits"
    - name: "Avg Findings Per Audit"
      expr: AVG(CAST(findings_critical_count AS INT) + CAST(findings_major_count AS INT) + CAST(findings_minor_count AS INT))
      comment: "Average total findings per audit, indicating audit rigor and compliance maturity"
    - name: "Audits With Overdue Follow-Up"
      expr: COUNT(CASE WHEN followup_due_date < CURRENT_DATE() AND followup_status != 'Completed' THEN 1 END)
      comment: "Count of audits with overdue corrective action follow-up, indicating remediation delays"
    - name: "Avg Audit Duration Days"
      expr: AVG(DATEDIFF(actual_end_date, actual_start_date))
      comment: "Average number of days from audit start to completion"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`compliance_certification_audit`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Executive KPIs for external certification audit performance, tracking certification outcomes, non-conformance rates, audit costs, and corrective action timeliness to maintain ISO and regulatory certifications."
  source: "`manufacturing_ecm`.`compliance`.`certification_audit`"
  dimensions:
    - name: "Audit Type"
      expr: audit_type
      comment: "Classification of certification audit by purpose (initial, surveillance, recertification, special, transfer)"
    - name: "Audit Status"
      expr: status
      comment: "Current lifecycle status of the certification audit (planned, in progress, completed, closed)"
    - name: "Audit Outcome"
      expr: outcome
      comment: "Formal certification decision resulting from the audit (certified, conditional, suspended, denied)"
    - name: "Certification Body"
      expr: certification_body_name
      comment: "Name of accredited certification body conducting the audit"
    - name: "Audit Site Country"
      expr: audit_site_country_code
      comment: "ISO 3166-1 alpha-3 country code of audit site location"
    - name: "Audit Stage"
      expr: audit_stage
      comment: "For initial certification audits, identifies Stage 1 or Stage 2"
    - name: "Remote Audit Flag"
      expr: is_remote_audit
      comment: "Indicates whether audit was conducted remotely using ICT tools"
    - name: "Audit Year"
      expr: YEAR(actual_start_date)
      comment: "Calendar year when the certification audit was conducted"
    - name: "Audit Quarter"
      expr: CONCAT('Q', QUARTER(actual_start_date), ' ', YEAR(actual_start_date))
      comment: "Fiscal quarter when the certification audit was conducted"
  measures:
    - name: "Total Certification Audits"
      expr: COUNT(1)
      comment: "Total number of external certification audits conducted by accredited bodies"
    - name: "Successful Certifications"
      expr: COUNT(CASE WHEN outcome IN ('Certified', 'Certificate Issued', 'Approved') THEN 1 END)
      comment: "Count of audits resulting in successful certification or approval"
    - name: "Audits With Major NCRs"
      expr: COUNT(CASE WHEN CAST(major_nonconformance_count AS INT) > 0 THEN 1 END)
      comment: "Count of audits with one or more major non-conformances raised"
    - name: "Total Major NCRs"
      expr: SUM(CAST(major_nonconformance_count AS INT))
      comment: "Sum of all major non-conformances raised across all certification audits"
    - name: "Total Minor NCRs"
      expr: SUM(CAST(minor_nonconformance_count AS INT))
      comment: "Sum of all minor non-conformances raised across all certification audits"
    - name: "Total Observations"
      expr: SUM(CAST(observation_count AS INT))
      comment: "Sum of all observations or opportunities for improvement noted by auditors"
    - name: "Audits Requiring Corrective Action"
      expr: COUNT(CASE WHEN corrective_action_required = TRUE THEN 1 END)
      comment: "Count of audits requiring formal CAPA submission before certification decision"
    - name: "Total Audit Cost"
      expr: SUM(CAST(audit_cost_amount AS DOUBLE))
      comment: "Total cost charged by certification bodies for conducting audits, for compliance budget management"
    - name: "Avg Audit Duration Days"
      expr: AVG(CAST(audit_duration_days AS DOUBLE))
      comment: "Average auditor-days consumed per certification audit"
    - name: "Overdue Corrective Actions"
      expr: COUNT(CASE WHEN corrective_action_due_date < CURRENT_DATE() AND corrective_action_submission_date IS NULL THEN 1 END)
      comment: "Count of audits with overdue corrective action submissions, risking certification status"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`compliance_data_subject_request`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Critical GDPR and CCPA compliance KPIs tracking data subject rights request fulfillment, response timeliness, SLA adherence, and regulatory breach rates to ensure privacy regulation compliance."
  source: "`manufacturing_ecm`.`compliance`.`data_subject_request`"
  dimensions:
    - name: "Request Type"
      expr: request_type
      comment: "Classification of data subject right being exercised (access, erasure, rectification, portability, opt-out)"
    - name: "Request Status"
      expr: status
      comment: "Current processing status of the data subject request (received, in progress, completed, denied)"
    - name: "Regulatory Framework"
      expr: regulatory_framework
      comment: "Data privacy regulation under which request is submitted (GDPR, CCPA, other)"
    - name: "Data Subject Category"
      expr: data_subject_category
      comment: "Classification of data subject relationship to organization (employee, customer, supplier, job applicant)"
    - name: "Request Channel"
      expr: channel
      comment: "Channel through which data subject submitted the request (web form, email, phone, postal mail)"
    - name: "Identity Verification Status"
      expr: identity_verification_status
      comment: "Status of identity verification process for the requestor"
    - name: "SLA Breach Flag"
      expr: is_sla_breached
      comment: "Indicates whether regulatory response deadline was breached"
    - name: "Jurisdiction Country"
      expr: jurisdiction_country_code
      comment: "ISO 3166-1 alpha-3 country code of jurisdiction under which request is governed"
    - name: "Request Year"
      expr: YEAR(received_date)
      comment: "Calendar year when data subject request was received"
    - name: "Request Month"
      expr: DATE_TRUNC('MONTH', received_date)
      comment: "Month when data subject request was received, for trend analysis"
  measures:
    - name: "Total DSR Requests"
      expr: COUNT(1)
      comment: "Total number of data subject rights requests received under GDPR and CCPA"
    - name: "Completed Requests"
      expr: COUNT(CASE WHEN status = 'Completed' THEN 1 END)
      comment: "Count of data subject requests successfully fulfilled and closed"
    - name: "SLA Breached Requests"
      expr: COUNT(CASE WHEN is_sla_breached = TRUE THEN 1 END)
      comment: "Count of requests where regulatory response deadline was breached, indicating compliance risk"
    - name: "Requests Requiring Extension"
      expr: COUNT(CASE WHEN extension_granted = TRUE THEN 1 END)
      comment: "Count of requests requiring statutory extension due to complexity or volume"
    - name: "Denied Requests"
      expr: COUNT(CASE WHEN status = 'Denied' THEN 1 END)
      comment: "Count of data subject requests denied with documented legal basis"
    - name: "Requests With Supervisory Authority Notification"
      expr: COUNT(CASE WHEN supervisory_authority_notified = TRUE THEN 1 END)
      comment: "Count of requests escalated to data protection supervisory authority"
    - name: "Avg Response Time Days"
      expr: AVG(DATEDIFF(response_sent_date, received_date))
      comment: "Average number of days from request receipt to response delivery, measuring fulfillment efficiency"
    - name: "Avg Verification Time Days"
      expr: AVG(DATEDIFF(identity_verified_date, received_date))
      comment: "Average number of days to complete identity verification, impacting overall response time"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`compliance_privacy_breach`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Executive KPIs for personal data breach incident management, tracking breach severity, notification timeliness, data subject impact, and regulatory reporting compliance under GDPR Article 33/34."
  source: "`manufacturing_ecm`.`compliance`.`privacy_breach`"
  dimensions:
    - name: "Breach Type"
      expr: breach_type
      comment: "Classification by security principle violated (confidentiality, integrity, availability)"
    - name: "Breach Category"
      expr: breach_category
      comment: "Operational category describing root cause or mechanism of breach"
    - name: "Breach Status"
      expr: status
      comment: "Current lifecycle status of privacy breach incident (under investigation, contained, remediated, closed)"
    - name: "Risk Level to Data Subjects"
      expr: risk_level_to_data_subjects
      comment: "Assessed risk level to rights and freedoms of affected data subjects"
    - name: "Business Unit"
      expr: business_unit_name
      comment: "Business unit or organizational division where breach originated"
    - name: "Facility Country"
      expr: facility_country_code
      comment: "ISO 3166-1 alpha-3 country code of facility where breach originated"
    - name: "Special Category Data Involved"
      expr: special_category_data_involved
      comment: "Indicates whether breach involves special categories of personal data (GDPR Article 9)"
    - name: "Third Party Involved"
      expr: third_party_involved
      comment: "Indicates whether third-party data processor or supplier was involved in breach"
    - name: "Breach Year"
      expr: YEAR(discovery_timestamp)
      comment: "Calendar year when privacy breach was discovered"
    - name: "Breach Quarter"
      expr: CONCAT('Q', QUARTER(discovery_timestamp), ' ', YEAR(discovery_timestamp))
      comment: "Fiscal quarter when privacy breach was discovered"
  measures:
    - name: "Total Privacy Breaches"
      expr: COUNT(1)
      comment: "Total number of personal data breach incidents requiring GDPR/CCPA notification"
    - name: "High Risk Breaches"
      expr: COUNT(CASE WHEN risk_level_to_data_subjects IN ('High', 'Critical') THEN 1 END)
      comment: "Count of breaches assessed as high risk to data subjects, requiring direct notification"
    - name: "Breaches Requiring Supervisory Authority Notification"
      expr: COUNT(CASE WHEN supervisory_authority_notification_required = TRUE THEN 1 END)
      comment: "Count of breaches requiring formal notification to data protection authority under GDPR Article 33"
    - name: "Breaches Requiring Data Subject Notification"
      expr: COUNT(CASE WHEN data_subject_notification_required = TRUE THEN 1 END)
      comment: "Count of breaches requiring direct notification to affected data subjects under GDPR Article 34"
    - name: "Total Confirmed Data Subjects Affected"
      expr: SUM(CAST(confirmed_data_subjects_affected AS INT))
      comment: "Total confirmed count of individual data subjects affected across all breaches"
    - name: "Breaches With Special Category Data"
      expr: COUNT(CASE WHEN special_category_data_involved = TRUE THEN 1 END)
      comment: "Count of breaches involving special categories of personal data, triggering heightened obligations"
    - name: "Avg Time to Containment Hours"
      expr: AVG(CAST(UNIX_TIMESTAMP(containment_timestamp) - UNIX_TIMESTAMP(discovery_timestamp) AS DOUBLE) / 3600)
      comment: "Average hours from breach discovery to containment, measuring incident response effectiveness"
    - name: "Avg Time to Supervisory Authority Notification Hours"
      expr: AVG(CAST(UNIX_TIMESTAMP(supervisory_authority_notification_timestamp) - UNIX_TIMESTAMP(discovery_timestamp) AS DOUBLE) / 3600)
      comment: "Average hours from discovery to supervisory authority notification, measuring GDPR 72-hour compliance"
    - name: "Breaches Missing 72-Hour Deadline"
      expr: COUNT(CASE WHEN supervisory_authority_notification_required = TRUE AND CAST(UNIX_TIMESTAMP(supervisory_authority_notification_timestamp) - UNIX_TIMESTAMP(discovery_timestamp) AS DOUBLE) / 3600 > 72 THEN 1 END)
      comment: "Count of breaches where GDPR 72-hour notification deadline was missed, indicating regulatory non-compliance"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`compliance_cybersecurity_incident`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic KPIs for industrial cybersecurity incident response, tracking incident severity, detection speed, containment effectiveness, and production impact to protect OT/IT environments."
  source: "`manufacturing_ecm`.`compliance`.`cybersecurity_incident`"
  dimensions:
    - name: "Incident Type"
      expr: incident_type
      comment: "Classification of cybersecurity incident by attack or threat type"
    - name: "Incident Status"
      expr: status
      comment: "Current lifecycle status of cybersecurity incident (detected, contained, eradicated, recovered, closed)"
    - name: "Severity"
      expr: severity
      comment: "Severity rating of cybersecurity incident based on IEC 62443 criteria and business impact"
    - name: "Affected Zone"
      expr: affected_zone
      comment: "IEC 62443 industrial security zone or conduit affected by incident"
    - name: "Attack Vector"
      expr: attack_vector
      comment: "Pathway or method used by threat actor to gain initial access"
    - name: "Detection Method"
      expr: detection_method
      comment: "Mechanism or tool by which cybersecurity incident was first detected"
    - name: "Facility Country"
      expr: affected_facility_country_code
      comment: "ISO 3166-1 alpha-3 country code of facility where incident occurred"
    - name: "Personal Data Breach Flag"
      expr: personal_data_breach
      comment: "Indicates whether incident constitutes personal data breach under GDPR Article 4(12)"
    - name: "Data Loss Occurred"
      expr: data_loss_occurred
      comment: "Indicates whether confirmed data loss, exfiltration, or destruction occurred"
    - name: "Incident Year"
      expr: YEAR(detection_timestamp)
      comment: "Calendar year when cybersecurity incident was detected"
    - name: "Incident Month"
      expr: DATE_TRUNC('MONTH', detection_timestamp)
      comment: "Month when cybersecurity incident was detected, for trend analysis"
  measures:
    - name: "Total Cybersecurity Incidents"
      expr: COUNT(1)
      comment: "Total number of cybersecurity incidents affecting OT/IT systems"
    - name: "Critical Severity Incidents"
      expr: COUNT(CASE WHEN severity IN ('Critical', 'High') THEN 1 END)
      comment: "Count of critical or high-severity incidents requiring immediate response"
    - name: "Incidents With Data Loss"
      expr: COUNT(CASE WHEN data_loss_occurred = TRUE THEN 1 END)
      comment: "Count of incidents resulting in confirmed data loss or exfiltration"
    - name: "Incidents Triggering Personal Data Breach"
      expr: COUNT(CASE WHEN personal_data_breach = TRUE THEN 1 END)
      comment: "Count of incidents constituting personal data breach requiring GDPR notification"
    - name: "Incidents Requiring Regulatory Notification"
      expr: COUNT(CASE WHEN regulatory_notification_required = TRUE THEN 1 END)
      comment: "Count of incidents requiring formal notification to regulatory authorities"
    - name: "Total Production Downtime Hours"
      expr: SUM(CAST(production_downtime_hours AS DOUBLE))
      comment: "Total hours of manufacturing production downtime directly caused by cybersecurity incidents"
    - name: "Total Estimated Financial Impact"
      expr: SUM(CAST(estimated_financial_impact_amount AS DOUBLE))
      comment: "Total estimated financial impact including production losses, remediation costs, and fines"
    - name: "Avg Time to Containment Hours"
      expr: AVG(CAST(UNIX_TIMESTAMP(containment_timestamp) - UNIX_TIMESTAMP(detection_timestamp) AS DOUBLE) / 3600)
      comment: "Average hours from incident detection to containment, measuring mean time to contain (MTTC)"
    - name: "Avg Time to Eradication Hours"
      expr: AVG(CAST(UNIX_TIMESTAMP(eradication_timestamp) - UNIX_TIMESTAMP(detection_timestamp) AS DOUBLE) / 3600)
      comment: "Average hours from detection to root cause eradication, measuring remediation effectiveness"
    - name: "Avg Time to Recovery Hours"
      expr: AVG(CAST(UNIX_TIMESTAMP(recovery_timestamp) - UNIX_TIMESTAMP(detection_timestamp) AS DOUBLE) / 3600)
      comment: "Average hours from detection to full system recovery, measuring mean time to recover (MTTR)"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`compliance_env_compliance_record`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Executive environmental compliance KPIs tracking regulatory performance against ISO 14001, EPA, and EU environmental directives, measuring exceedance rates, reporting timeliness, and variance from limits."
  source: "`manufacturing_ecm`.`compliance`.`env_compliance_record`"
  dimensions:
    - name: "Compliance Area"
      expr: compliance_area
      comment: "Classification of environmental compliance domain (air emissions, wastewater, hazardous waste, energy, carbon)"
    - name: "Compliance Status"
      expr: compliance_status
      comment: "Current compliance status relative to regulatory limit (compliant, at-risk, non-compliant)"
    - name: "Regulatory Framework"
      expr: regulatory_framework
      comment: "Governing environmental standard or directive (ISO 14001, EPA, EU IED, EU ETS)"
    - name: "Parameter Name"
      expr: parameter_name
      comment: "Specific environmental parameter being measured (NOx, BOD, CO2, energy intensity)"
    - name: "Facility Name"
      expr: facility_name
      comment: "Manufacturing facility or plant to which environmental compliance record applies"
    - name: "Jurisdiction Country"
      expr: jurisdiction_country_code
      comment: "ISO 3166-1 alpha-3 country code of national jurisdiction"
    - name: "Exceedance Flag"
      expr: exceedance_flag
      comment: "Indicates whether actual performance value exceeds regulatory limit"
    - name: "Measurement Method"
      expr: measurement_method
      comment: "Method used to obtain environmental performance value (CEMS, sampling, calculation)"
    - name: "Reporting Authority"
      expr: reporting_authority
      comment: "Regulatory body to which compliance record must be reported"
    - name: "Measurement Year"
      expr: YEAR(measurement_period_start)
      comment: "Calendar year of measurement period start"
    - name: "Measurement Quarter"
      expr: CONCAT('Q', QUARTER(measurement_period_start), ' ', YEAR(measurement_period_start))
      comment: "Fiscal quarter of measurement period start"
  measures:
    - name: "Total Compliance Records"
      expr: COUNT(1)
      comment: "Total number of environmental compliance records tracked across all facilities and parameters"
    - name: "Non-Compliant Records"
      expr: COUNT(CASE WHEN compliance_status = 'Non-Compliant' THEN 1 END)
      comment: "Count of environmental compliance records in non-compliant status, triggering corrective action"
    - name: "Exceedance Events"
      expr: COUNT(CASE WHEN exceedance_flag = TRUE THEN 1 END)
      comment: "Count of environmental performance measurements exceeding regulatory limits"
    - name: "Records Requiring Regulatory Notification"
      expr: COUNT(CASE WHEN regulatory_notification_required = TRUE THEN 1 END)
      comment: "Count of compliance records requiring mandatory regulatory notification"
    - name: "Total Actual Value"
      expr: SUM(CAST(actual_value AS DOUBLE))
      comment: "Sum of actual environmental performance values across all records (use with caution - unit-dependent)"
    - name: "Total Regulatory Limit"
      expr: SUM(CAST(regulatory_limit AS DOUBLE))
      comment: "Sum of regulatory limit values across all records (use with caution - unit-dependent)"
    - name: "Total Variance From Limit"
      expr: SUM(CAST(variance_from_limit AS DOUBLE))
      comment: "Sum of variance from regulatory limits, indicating aggregate compliance headroom or deficit"
    - name: "Avg Variance Percent"
      expr: AVG(CAST(variance_percent AS DOUBLE))
      comment: "Average percentage variance of actual performance relative to regulatory limits"
    - name: "Overdue Reports"
      expr: COUNT(CASE WHEN report_submission_deadline < CURRENT_DATE() AND report_submission_date IS NULL THEN 1 END)
      comment: "Count of environmental compliance reports past submission deadline, indicating reporting non-compliance"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`compliance_regulatory_filing`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic KPIs for regulatory filing and submission management, tracking filing timeliness, approval rates, fee costs, and renewal compliance across all jurisdictions and regulatory frameworks."
  source: "`manufacturing_ecm`.`compliance`.`regulatory_filing`"
  dimensions:
    - name: "Filing Type"
      expr: filing_type
      comment: "Classification of regulatory filing type (REACH, RoHS, CE, EPA, OSHA, GDPR DPA registration)"
    - name: "Filing Status"
      expr: status
      comment: "Current lifecycle status of regulatory filing (draft, submitted, acknowledged, approved, rejected)"
    - name: "Filing Category"
      expr: filing_category
      comment: "High-level regulatory category (product compliance, environmental, OHS, data privacy)"
    - name: "Filing Authority"
      expr: filing_authority_name
      comment: "Government agency or regulatory authority to which filing was submitted"
    - name: "Jurisdiction Country"
      expr: jurisdiction_country
      comment: "ISO 3166-1 alpha-3 country code of jurisdiction"
    - name: "Regulatory Framework"
      expr: regulatory_framework
      comment: "Specific regulation or standard under which filing is made"
    - name: "Is Mandatory"
      expr: is_mandatory
      comment: "Indicates whether filing is mandatory regulatory obligation or voluntary submission"
    - name: "Is Recurring"
      expr: is_recurring
      comment: "Indicates whether filing is recurring periodic obligation or one-time submission"
    - name: "Submission Method"
      expr: submission_method
      comment: "Method used to submit regulatory filing (electronic portal, email, postal mail)"
    - name: "Filing Year"
      expr: YEAR(submission_date)
      comment: "Calendar year when regulatory filing was submitted"
    - name: "Filing Quarter"
      expr: CONCAT('Q', QUARTER(submission_date), ' ', YEAR(submission_date))
      comment: "Fiscal quarter when regulatory filing was submitted"
  measures:
    - name: "Total Regulatory Filings"
      expr: COUNT(1)
      comment: "Total number of regulatory filings submitted across all jurisdictions and frameworks"
    - name: "Approved Filings"
      expr: COUNT(CASE WHEN status IN ('Approved', 'Acknowledged', 'Accepted') THEN 1 END)
      comment: "Count of regulatory filings granted approval or acceptance by regulatory authority"
    - name: "Rejected Filings"
      expr: COUNT(CASE WHEN status = 'Rejected' THEN 1 END)
      comment: "Count of regulatory filings rejected by authority, requiring resubmission"
    - name: "Overdue Filings"
      expr: COUNT(CASE WHEN submission_deadline < CURRENT_DATE() AND submission_date IS NULL THEN 1 END)
      comment: "Count of regulatory filings past submission deadline, indicating compliance risk"
    - name: "Total Filing Fees"
      expr: SUM(CAST(filing_fee_amount AS DOUBLE))
      comment: "Total monetary amount paid in regulatory filing fees across all submissions"
    - name: "Avg Filing Fee"
      expr: AVG(CAST(filing_fee_amount AS DOUBLE))
      comment: "Average filing fee per regulatory submission"
    - name: "Filings Requiring Renewal"
      expr: COUNT(CASE WHEN renewal_due_date <= DATE_ADD(CURRENT_DATE(), 90) AND renewal_due_date >= CURRENT_DATE() THEN 1 END)
      comment: "Count of filings requiring renewal within next 90 days, for proactive renewal planning"
    - name: "Avg Days to Acknowledgment"
      expr: AVG(DATEDIFF(acknowledgment_date, submission_date))
      comment: "Average number of days from submission to regulatory authority acknowledgment"
    - name: "Avg Days to Approval"
      expr: AVG(DATEDIFF(approval_date, submission_date))
      comment: "Average number of days from submission to formal approval by regulatory authority"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`compliance_sanctions_screening`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Critical trade compliance KPIs tracking sanctions screening effectiveness, match rates, review timeliness, and blocked transaction rates to ensure OFAC, EU, and UN sanctions compliance."
  source: "`manufacturing_ecm`.`compliance`.`sanctions_screening`"
  dimensions:
    - name: "Screened Entity Type"
      expr: screened_entity_type
      comment: "Classification of party being screened (customer, supplier, end-user, business partner)"
    - name: "Screening Decision"
      expr: screening_decision
      comment: "Initial automated decision (clear, potential match, confirmed match)"
    - name: "Review Outcome"
      expr: review_outcome
      comment: "Outcome after human review (false positive, true match, pending)"
    - name: "Disposition"
      expr: disposition
      comment: "Final business action taken (proceed, block, license obtained, legal review)"
    - name: "Screening List Name"
      expr: screening_list_name
      comment: "Sanctions or restricted party list screened against (OFAC SDN, EU Consolidated, UN, BIS Entity)"
    - name: "Match Type"
      expr: match_type
      comment: "Classification of name match (exact, fuzzy, alias, phonetic)"
    - name: "Jurisdiction"
      expr: jurisdiction
      comment: "Legal jurisdiction under which screening obligation arises (USA, EU, UN, GBR)"
    - name: "Business Unit"
      expr: business_unit
      comment: "Internal business unit or division owning transaction requiring screening"
    - name: "Enhanced Due Diligence Required"
      expr: enhanced_due_diligence_required
      comment: "Indicates whether enhanced due diligence was required due to elevated risk"
    - name: "Screening Year"
      expr: YEAR(screening_date)
      comment: "Calendar year when sanctions screening was executed"
    - name: "Screening Month"
      expr: DATE_TRUNC('MONTH', screening_date)
      comment: "Month when sanctions screening was executed, for trend analysis"
  measures:
    - name: "Total Screenings"
      expr: COUNT(1)
      comment: "Total number of sanctions and restricted party screenings performed"
    - name: "Clear Screenings"
      expr: COUNT(CASE WHEN screening_decision = 'Clear' THEN 1 END)
      comment: "Count of screenings with no match, allowing transaction to proceed"
    - name: "Potential Matches"
      expr: COUNT(CASE WHEN screening_decision = 'Potential Match' THEN 1 END)
      comment: "Count of screenings flagged as potential match requiring human review"
    - name: "Confirmed Matches"
      expr: COUNT(CASE WHEN screening_decision = 'Confirmed Match' THEN 1 END)
      comment: "Count of screenings with confirmed match to sanctions list"
    - name: "True Matches After Review"
      expr: COUNT(CASE WHEN review_outcome = 'True Match' THEN 1 END)
      comment: "Count of screenings confirmed as true match after human review, requiring transaction block"
    - name: "False Positives"
      expr: COUNT(CASE WHEN review_outcome = 'False Positive' THEN 1 END)
      comment: "Count of potential matches determined to be false positives after review"
    - name: "Blocked Transactions"
      expr: COUNT(CASE WHEN disposition = 'Block' THEN 1 END)
      comment: "Count of transactions blocked due to confirmed sanctions match"
    - name: "Screenings Requiring EDD"
      expr: COUNT(CASE WHEN enhanced_due_diligence_required = TRUE THEN 1 END)
      comment: "Count of screenings requiring enhanced due diligence due to elevated risk factors"
    - name: "Screenings With Red Flags"
      expr: COUNT(CASE WHEN red_flag_indicator = TRUE THEN 1 END)
      comment: "Count of screenings with BIS or OFAC red flag indicators identified"
    - name: "Avg Match Score"
      expr: AVG(CAST(match_score AS DOUBLE))
      comment: "Average similarity score for screenings with potential or confirmed matches"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`compliance_third_party_risk`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Executive KPIs for third-party compliance risk management, tracking risk ratings, due diligence completion, control effectiveness, and remediation status across suppliers, subcontractors, and service providers."
  source: "`manufacturing_ecm`.`compliance`.`third_party_risk`"
  dimensions:
    - name: "Entity Type"
      expr: entity_type
      comment: "Classification of third-party relationship (supplier, subcontractor, distributor, service provider)"
    - name: "Risk Category"
      expr: risk_category
      comment: "Primary risk domain (cybersecurity, data privacy, environmental, labor, sanctions, anti-bribery)"
    - name: "Inherent Risk Rating"
      expr: inherent_risk_rating
      comment: "Risk rating before considering mitigating controls (low, medium, high, critical)"
    - name: "Residual Risk Rating"
      expr: residual_risk_rating
      comment: "Risk rating after accounting for control effectiveness (low, medium, high, critical)"
    - name: "Due Diligence Status"
      expr: due_diligence_status
      comment: "Current status of due diligence assessment (not started, in progress, completed, waived)"
    - name: "Control Effectiveness Rating"
      expr: control_effectiveness_rating
      comment: "Assessment of third party internal control effectiveness (effective, partially effective, ineffective)"
    - name: "Entity Country"
      expr: entity_country_code
      comment: "ISO 3166-1 alpha-3 country code of third-party entity primary country"
    - name: "Critical Supplier Flag"
      expr: critical_supplier_flag
      comment: "Indicates whether third party is critical or sole-source supplier"
    - name: "ISO Certification Status"
      expr: iso_certification_status
      comment: "Status of third party relevant ISO management system certifications"
    - name: "GDPR Processor Flag"
      expr: gdpr_processor_flag
      comment: "Indicates whether third party acts as data processor under GDPR Article 28"
    - name: "Assessment Year"
      expr: YEAR(last_review_date)
      comment: "Calendar year of most recent risk review"
  measures:
    - name: "Total Third Parties"
      expr: COUNT(1)
      comment: "Total number of third-party entities under compliance risk assessment"
    - name: "High Risk Third Parties"
      expr: COUNT(CASE WHEN residual_risk_rating IN ('High', 'Critical') THEN 1 END)
      comment: "Count of third parties with high or critical residual risk rating requiring enhanced monitoring"
    - name: "Critical Suppliers"
      expr: COUNT(CASE WHEN critical_supplier_flag = TRUE THEN 1 END)
      comment: "Count of critical or sole-source suppliers whose disruption would materially impact operations"
    - name: "Third Parties With Incomplete Due Diligence"
      expr: COUNT(CASE WHEN due_diligence_status IN ('Not Started', 'In Progress') THEN 1 END)
      comment: "Count of third parties with incomplete due diligence assessment, indicating compliance gap"
    - name: "Third Parties With Ineffective Controls"
      expr: COUNT(CASE WHEN control_effectiveness_rating = 'Ineffective' THEN 1 END)
      comment: "Count of third parties with ineffective internal controls, requiring remediation"
    - name: "Third Parties Requiring Remediation"
      expr: COUNT(CASE WHEN remediation_due_date IS NOT NULL AND remediation_due_date >= CURRENT_DATE() THEN 1 END)
      comment: "Count of third parties with active remediation plans to address compliance gaps"
    - name: "Overdue Remediation Plans"
      expr: COUNT(CASE WHEN remediation_due_date < CURRENT_DATE() THEN 1 END)
      comment: "Count of third parties with overdue remediation plans, indicating unresolved compliance risk"
    - name: "Third Parties Overdue for Review"
      expr: COUNT(CASE WHEN next_review_date < CURRENT_DATE() THEN 1 END)
      comment: "Count of third parties overdue for periodic compliance risk review"
    - name: "GDPR Data Processors"
      expr: COUNT(CASE WHEN gdpr_processor_flag = TRUE THEN 1 END)
      comment: "Count of third parties acting as data processors requiring GDPR Article 28 DPA"
    - name: "Third Parties With ISO Certification"
      expr: COUNT(CASE WHEN iso_certification_status IN ('Certified', 'Active') THEN 1 END)
      comment: "Count of third parties holding active ISO management system certifications"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`compliance_policy_acknowledgment`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Strategic KPIs for compliance policy acknowledgment and training completion, tracking acknowledgment rates, overdue completions, exemptions, and assessment pass rates to ensure workforce compliance awareness."
  source: "`manufacturing_ecm`.`compliance`.`policy_acknowledgment`"
  dimensions:
    - name: "Policy Name"
      expr: policy_name
      comment: "Official name of compliance policy or training program acknowledged"
    - name: "Acknowledgment Status"
      expr: status
      comment: "Current lifecycle status of acknowledgment (active, expired, superseded, overdue)"
    - name: "Acknowledgment Method"
      expr: acknowledgment_method
      comment: "Mechanism by which employee confirmed acknowledgment (electronic signature, training completion, checkbox)"
    - name: "Regulatory Framework"
      expr: regulatory_framework
      comment: "Regulatory framework mandating policy acknowledgment (GDPR, FCPA, IEC 62443, CCPA)"
    - name: "Business Unit"
      expr: business_unit
      comment: "Organizational business unit of acknowledging employee"
    - name: "Employee Type"
      expr: employee_type
      comment: "Classification of acknowledging individual (full-time, contractor, temporary, intern)"
    - name: "Job Role"
      expr: job_role
      comment: "Employee job role or position title at time of acknowledgment"
    - name: "Is Mandatory"
      expr: is_mandatory
      comment: "Indicates whether acknowledgment is mandatory for employee role"
    - name: "Exemption Flag"
      expr: exemption_flag
      comment: "Indicates whether employee was granted exemption from acknowledgment requirement"
    - name: "Escalation Status"
      expr: escalation_status
      comment: "Current escalation level for overdue or non-compliant acknowledgments"
    - name: "Acknowledgment Year"
      expr: YEAR(acknowledgment_date)
      comment: "Calendar year when acknowledgment was completed"
    - name: "Acknowledgment Quarter"
      expr: CONCAT('Q', QUARTER(acknowledgment_date), ' ', YEAR(acknowledgment_date))
      comment: "Fiscal quarter when acknowledgment was completed"
  measures:
    - name: "Total Acknowledgments"
      expr: COUNT(1)
      comment: "Total number of policy acknowledgment records across all employees and policies"
    - name: "Active Acknowledgments"
      expr: COUNT(CASE WHEN status = 'Active' THEN 1 END)
      comment: "Count of acknowledgments currently active and within validity period"
    - name: "Expired Acknowledgments"
      expr: COUNT(CASE WHEN status = 'Expired' THEN 1 END)
      comment: "Count of acknowledgments past expiry date requiring renewal"
    - name: "Overdue Acknowledgments"
      expr: COUNT(CASE WHEN status = 'Overdue' THEN 1 END)
      comment: "Count of mandatory acknowledgments not completed by required deadline"
    - name: "Exempted Acknowledgments"
      expr: COUNT(CASE WHEN exemption_flag = TRUE THEN 1 END)
      comment: "Count of employees granted formal exemption from acknowledgment requirement"
    - name: "Acknowledgments With Assessment"
      expr: COUNT(CASE WHEN training_score IS NOT NULL THEN 1 END)
      comment: "Count of acknowledgments including formal knowledge assessment or quiz"
    - name: "Passed Assessments"
      expr: COUNT(CASE WHEN is_passed = TRUE THEN 1 END)
      comment: "Count of acknowledgments where employee met or exceeded passing score threshold"
    - name: "Failed Assessments"
      expr: COUNT(CASE WHEN is_passed = FALSE THEN 1 END)
      comment: "Count of acknowledgments where employee failed assessment, triggering remediation"
    - name: "Avg Training Score"
      expr: AVG(CAST(training_score AS DOUBLE))
      comment: "Average percentage score achieved on training assessments"
    - name: "Acknowledgments Requiring Escalation"
      expr: COUNT(CASE WHEN escalation_status IN ('Manager Notified', 'HR Escalated', 'Legal Escalated') THEN 1 END)
      comment: "Count of overdue acknowledgments escalated for enforcement action"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`compliance_obligation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Executive KPIs for compliance obligation portfolio management, tracking obligation status, gap closure, audit results, and risk levels to ensure comprehensive regulatory compliance across all business units."
  source: "`manufacturing_ecm`.`compliance`.`obligation`"
  dimensions:
    - name: "Obligation Status"
      expr: status
      comment: "Current lifecycle status of compliance obligation (compliant, in progress, non-compliant, at risk)"
    - name: "Obligation Category"
      expr: category
      comment: "Functional domain category (product safety, environmental, OHS, data privacy, cybersecurity)"
    - name: "Obligation Type"
      expr: type
      comment: "Classification by source (legal/regulatory, contractual, voluntary, internal policy)"
    - name: "Regulatory Framework"
      expr: regulatory_framework
      comment: "Governing regulation or standard (ISO 9001, IEC 62443, GDPR, REACH, RoHS, OSHA)"
    - name: "Business Unit"
      expr: business_unit_name
      comment: "Business unit to which compliance obligation is assigned"
    - name: "Applicability Scope"
      expr: applicability_scope
      comment: "Organizational scope (enterprise, business unit, facility, product line, process)"
    - name: "Risk Level"
      expr: risk_level
      comment: "Assessed risk level of non-compliance (low, medium, high, critical)"
    - name: "Mandatory Flag"
      expr: mandatory_flag
      comment: "Indicates whether obligation is legally mandatory or voluntary"
    - name: "Reporting Required Flag"
      expr: reporting_required_flag
      comment: "Indicates whether obligation requires formal regulatory reporting"
    - name: "Last Audit Result"
      expr: last_audit_result
      comment: "Outcome of most recent audit (compliant, major NC, minor NC, not assessed)"
    - name: "Obligation Year"
      expr: YEAR(effective_date)
      comment: "Calendar year when obligation became effective"
  measures:
    - name: "Total Obligations"
      expr: COUNT(1)
      comment: "Total number of compliance obligations tracked across all business units and frameworks"
    - name: "Compliant Obligations"
      expr: COUNT(CASE WHEN status = 'Compliant' THEN 1 END)
      comment: "Count of obligations in compliant status with no identified gaps"
    - name: "Non-Compliant Obligations"
      expr: COUNT(CASE WHEN status = 'Non-Compliant' THEN 1 END)
      comment: "Count of obligations in non-compliant status requiring immediate remediation"
    - name: "At-Risk Obligations"
      expr: COUNT(CASE WHEN status = 'At Risk' THEN 1 END)
      comment: "Count of obligations at risk of non-compliance requiring proactive intervention"
    - name: "High Risk Obligations"
      expr: COUNT(CASE WHEN risk_level IN ('High', 'Critical') THEN 1 END)
      comment: "Count of obligations with high or critical risk level requiring priority attention"
    - name: "Mandatory Obligations"
      expr: COUNT(CASE WHEN mandatory_flag = TRUE THEN 1 END)
      comment: "Count of legally mandatory obligations carrying regulatory enforcement risk"
    - name: "Obligations Requiring Reporting"
      expr: COUNT(CASE WHEN reporting_required_flag = TRUE THEN 1 END)
      comment: "Count of obligations requiring formal regulatory reporting or submission"
    - name: "Obligations With Compliance Gaps"
      expr: COUNT(CASE WHEN compliance_gap_description IS NOT NULL AND compliance_gap_description != '' THEN 1 END)
      comment: "Count of obligations with documented compliance gaps requiring remediation"
    - name: "Overdue Obligations"
      expr: COUNT(CASE WHEN due_date < CURRENT_DATE() AND status != 'Compliant' THEN 1 END)
      comment: "Count of obligations past due date and not yet compliant, indicating compliance breach"
    - name: "Obligations Overdue for Review"
      expr: COUNT(CASE WHEN next_review_date < CURRENT_DATE() THEN 1 END)
      comment: "Count of obligations overdue for periodic compliance review"
    - name: "Obligations With Major Audit Findings"
      expr: COUNT(CASE WHEN last_audit_result IN ('Major Non-Conformance', 'Critical') THEN 1 END)
      comment: "Count of obligations with major or critical findings in most recent audit"
$$;