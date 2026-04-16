-- Metric views for domain: research | Business: Manufacturing | Version: 1 | Generated on: 2026-04-16 08:28:54

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_rd_budget_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "R&D budget performance metrics tracking approved budgets, actual spend, commitments, and remaining capacity across projects, technology domains, and fiscal periods. Enables portfolio investment governance and CAPEX/OPEX variance analysis."
  source: "`manufacturing_ecm`.`research`.`rd_budget`"
  dimensions:
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year of the budget authorization"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Fiscal period within the year (Q1, Q2, H1, FY, M01-M12)"
    - name: "technology_domain"
      expr: technology_domain
      comment: "Technology area (automation, electrification, smart infrastructure)"
    - name: "business_unit"
      expr: business_unit
      comment: "Business unit or division responsible for the budget"
    - name: "budget_category"
      expr: budget_category
      comment: "Expenditure type (labor, materials, external services, capital equipment, travel)"
    - name: "expenditure_type"
      expr: expenditure_type
      comment: "CAPEX or OPEX classification per accounting standards"
    - name: "funding_source"
      expr: funding_source
      comment: "Origin of funding (internal R&D fund, government grant, customer-funded development)"
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the budget authorization"
    - name: "stage_gate_phase"
      expr: stage_gate_phase
      comment: "Stage-gate process phase associated with the budget"
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code where R&D activity is conducted"
  measures:
    - name: "total_approved_budget_usd"
      expr: SUM(CAST(approved_amount_usd AS DOUBLE))
      comment: "Total approved R&D budget in USD across all authorizations"
    - name: "total_actual_spend"
      expr: SUM(CAST(actual_spend AS DOUBLE))
      comment: "Total actual expenditure posted against R&D budgets"
    - name: "total_committed_spend"
      expr: SUM(CAST(committed_spend AS DOUBLE))
      comment: "Total committed but not yet realized expenditure (POs, contracts)"
    - name: "total_remaining_budget"
      expr: SUM(CAST(remaining_budget AS DOUBLE))
      comment: "Total unencumbered budget available for future spend"
    - name: "budget_utilization_rate"
      expr: ROUND(100.0 * SUM(CAST(actual_spend AS DOUBLE)) / NULLIF(SUM(CAST(approved_amount_usd AS DOUBLE)), 0), 2)
      comment: "Percentage of approved budget actually spent, indicating execution velocity"
    - name: "budget_commitment_rate"
      expr: ROUND(100.0 * (SUM(CAST(actual_spend AS DOUBLE)) + SUM(CAST(committed_spend AS DOUBLE))) / NULLIF(SUM(CAST(approved_amount_usd AS DOUBLE)), 0), 2)
      comment: "Percentage of approved budget spent or committed, indicating total encumbrance"
    - name: "count_budget_authorizations"
      expr: COUNT(1)
      comment: "Number of R&D budget authorization records"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_rd_expense_analysis`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "R&D expenditure transaction metrics tracking actual spend by category, project, technology domain, and capitalization status. Supports detailed cost accounting, tax credit eligibility analysis, and CAPEX/OPEX classification reporting."
  source: "`manufacturing_ecm`.`research`.`rd_expense`"
  dimensions:
    - name: "fiscal_year"
      expr: fiscal_year
      comment: "Fiscal year in which the expense is recognized"
    - name: "fiscal_period"
      expr: fiscal_period
      comment: "Accounting period (month 1-12) within the fiscal year"
    - name: "expense_category"
      expr: expense_category
      comment: "Classification by cost type (labor, materials, external services, equipment, travel)"
    - name: "expense_subcategory"
      expr: expense_subcategory
      comment: "Granular classification within expense category"
    - name: "technology_domain"
      expr: technology_domain
      comment: "Technology domain or innovation area of the expense"
    - name: "is_capitalized"
      expr: is_capitalized
      comment: "CAPEX (True) or OPEX (False) classification per IAS 38"
    - name: "tax_credit_eligible"
      expr: tax_credit_eligible
      comment: "Whether expense qualifies for R&D tax credits or incentives"
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code where expense was incurred"
    - name: "cost_center"
      expr: cost_center
      comment: "SAP cost center to which expense is allocated"
    - name: "approval_status"
      expr: approval_status
      comment: "Current workflow approval status of the expense"
    - name: "apqp_phase"
      expr: apqp_phase
      comment: "APQP stage-gate phase during which expense was incurred"
  measures:
    - name: "total_expense_amount_usd"
      expr: SUM(CAST(amount_usd AS DOUBLE))
      comment: "Total R&D expenditure in USD across all transactions"
    - name: "total_expense_amount_local"
      expr: SUM(CAST(amount AS DOUBLE))
      comment: "Total R&D expenditure in transaction currency"
    - name: "avg_expense_amount_usd"
      expr: AVG(CAST(amount_usd AS DOUBLE))
      comment: "Average R&D expense transaction amount in USD"
    - name: "count_expense_transactions"
      expr: COUNT(1)
      comment: "Number of R&D expense transactions"
    - name: "count_distinct_vendors"
      expr: COUNT(DISTINCT vendor_name)
      comment: "Number of unique vendors receiving R&D expenditure"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_rd_milestone_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "R&D project milestone achievement metrics tracking planned vs actual completion, schedule variance, and milestone status across projects and stage-gate phases. Supports portfolio timeline management and stage-gate governance."
  source: "`manufacturing_ecm`.`research`.`rd_milestone`"
  dimensions:
    - name: "milestone_type"
      expr: milestone_type
      comment: "Classification by business nature (technical, commercial, regulatory, contractual, financial, IP, safety)"
    - name: "status"
      expr: status
      comment: "Current execution status of the milestone"
    - name: "stage_gate_phase"
      expr: stage_gate_phase
      comment: "Stage-gate phase to which milestone belongs"
    - name: "technology_domain"
      expr: technology_domain
      comment: "Primary technology domain of the milestone"
    - name: "is_critical_path"
      expr: is_critical_path
      comment: "Whether milestone lies on project critical path"
    - name: "is_gate_milestone"
      expr: is_gate_milestone
      comment: "Whether milestone represents formal stage-gate decision point"
    - name: "is_grant_reportable"
      expr: is_grant_reportable
      comment: "Whether milestone must be reported to external funding body"
    - name: "is_contractual"
      expr: is_contractual
      comment: "Whether milestone is contractually committed"
    - name: "regulatory_compliance_flag"
      expr: regulatory_compliance_flag
      comment: "Whether milestone has regulatory compliance dimension"
    - name: "payment_trigger_flag"
      expr: payment_trigger_flag
      comment: "Whether completion triggers payment event"
    - name: "apqp_phase"
      expr: apqp_phase
      comment: "APQP phase associated with the milestone"
  measures:
    - name: "count_milestones"
      expr: COUNT(1)
      comment: "Total number of R&D project milestones"
    - name: "count_completed_milestones"
      expr: SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END)
      comment: "Number of milestones successfully completed"
    - name: "count_delayed_milestones"
      expr: SUM(CASE WHEN status = 'delayed' THEN 1 ELSE 0 END)
      comment: "Number of milestones currently delayed"
    - name: "count_critical_path_milestones"
      expr: SUM(CASE WHEN is_critical_path = TRUE THEN 1 ELSE 0 END)
      comment: "Number of milestones on project critical path"
    - name: "total_payment_amount"
      expr: SUM(CAST(payment_amount AS DOUBLE))
      comment: "Total monetary value of payments triggered by milestone completion"
    - name: "milestone_completion_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of milestones completed, indicating project execution velocity"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_grant_funding_performance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Government grant and public R&D funding performance metrics tracking awarded amounts, disbursements, claims, and co-funding rates. Supports grant compliance reporting and public funding portfolio management."
  source: "`manufacturing_ecm`.`research`.`grant_funding`"
  dimensions:
    - name: "funding_agency"
      expr: funding_agency
      comment: "Government body or institution that awarded the grant"
    - name: "program_name"
      expr: program_name
      comment: "Official name of the public funding program or grant scheme"
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the grant funding"
    - name: "technology_domain"
      expr: technology_domain
      comment: "Primary technology domain addressed by grant-funded R&D"
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of primary jurisdiction"
    - name: "owning_business_unit"
      expr: owning_business_unit
      comment: "Business unit responsible for executing grant-funded activities"
    - name: "consortium_role"
      expr: consortium_role
      comment: "Manufacturing's role within grant consortium (coordinator, partner, associate)"
    - name: "external_partner_involved"
      expr: external_partner_involved
      comment: "Whether external research partners are involved"
    - name: "funding_instrument_type"
      expr: funding_instrument_type
      comment: "Classification of funding instrument (research grant, innovation action, cooperative agreement)"
  measures:
    - name: "total_awarded_amount_usd"
      expr: SUM(CAST(awarded_amount_usd AS DOUBLE))
      comment: "Total grant funding awarded in USD"
    - name: "total_disbursed_amount"
      expr: SUM(CAST(total_disbursed_amount AS DOUBLE))
      comment: "Total grant funds actually received from funding agencies"
    - name: "total_claimed_amount"
      expr: SUM(CAST(total_claimed_amount AS DOUBLE))
      comment: "Total eligible costs claimed against grants"
    - name: "total_manufacturing_contribution"
      expr: SUM(CAST(manufacturing_contribution_amount AS DOUBLE))
      comment: "Total co-funding contributed by Manufacturing"
    - name: "avg_co_funding_rate"
      expr: AVG(CAST(co_funding_rate_pct AS DOUBLE))
      comment: "Average percentage of project costs covered by grants"
    - name: "grant_drawdown_rate"
      expr: ROUND(100.0 * SUM(CAST(total_disbursed_amount AS DOUBLE)) / NULLIF(SUM(CAST(awarded_amount_usd AS DOUBLE)), 0), 2)
      comment: "Percentage of awarded grant funds actually received, indicating execution progress"
    - name: "count_active_grants"
      expr: COUNT(1)
      comment: "Number of grant funding records"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_ip_asset_portfolio`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Intellectual property asset portfolio metrics tracking patent counts, commercial value, licensing status, and IP protection coverage across technology domains and jurisdictions. Supports IP portfolio management and licensing strategy."
  source: "`manufacturing_ecm`.`research`.`ip_asset`"
  dimensions:
    - name: "ip_type"
      expr: ip_type
      comment: "Legal category (patent, trade secret, proprietary algorithm, software invention, know-how)"
    - name: "status"
      expr: status
      comment: "Current lifecycle status within portfolio management process"
    - name: "technology_domain"
      expr: technology_domain
      comment: "Primary technology area of the IP asset"
    - name: "jurisdiction"
      expr: jurisdiction
      comment: "Country or regional jurisdiction where IP is filed or protected"
    - name: "owning_business_unit"
      expr: owning_business_unit
      comment: "Business unit that owns the IP asset"
    - name: "is_licensed_externally"
      expr: is_licensed_externally
      comment: "Whether IP is currently licensed to external parties"
    - name: "is_standard_essential"
      expr: is_standard_essential
      comment: "Whether patent is declared as Standard Essential Patent (SEP)"
    - name: "freedom_to_operate_status"
      expr: freedom_to_operate_status
      comment: "Result of freedom-to-operate analysis"
    - name: "stage_gate_phase"
      expr: stage_gate_phase
      comment: "Current stage-gate phase of associated R&D project"
  measures:
    - name: "count_ip_assets"
      expr: COUNT(1)
      comment: "Total number of IP assets in portfolio"
    - name: "count_patents"
      expr: SUM(CASE WHEN ip_type = 'patent' THEN 1 ELSE 0 END)
      comment: "Number of patent IP assets"
    - name: "count_licensed_assets"
      expr: SUM(CASE WHEN is_licensed_externally = TRUE THEN 1 ELSE 0 END)
      comment: "Number of IP assets licensed to external parties"
    - name: "count_standard_essential_patents"
      expr: SUM(CASE WHEN is_standard_essential = TRUE THEN 1 ELSE 0 END)
      comment: "Number of Standard Essential Patents (SEPs)"
    - name: "total_estimated_value_usd"
      expr: SUM(CAST(estimated_commercial_value_usd AS DOUBLE))
      comment: "Total estimated commercial value of IP portfolio in USD"
    - name: "avg_estimated_value_usd"
      expr: AVG(CAST(estimated_commercial_value_usd AS DOUBLE))
      comment: "Average estimated commercial value per IP asset in USD"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_patent_filing_lifecycle`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Patent filing and prosecution lifecycle metrics tracking application counts, grant rates, costs, and prosecution status across jurisdictions and technology domains. Supports IP cost management and patent office performance analysis."
  source: "`manufacturing_ecm`.`research`.`patent_filing`"
  dimensions:
    - name: "patent_office"
      expr: patent_office
      comment: "National or international patent office where application was filed"
    - name: "jurisdiction_country_code"
      expr: jurisdiction_country_code
      comment: "ISO 3166-1 alpha-3 country code of filing jurisdiction"
    - name: "prosecution_status"
      expr: prosecution_status
      comment: "Current stage in prosecution lifecycle at patent office"
    - name: "patent_type"
      expr: patent_type
      comment: "Classification by type (utility, design, PCT)"
    - name: "technology_domain"
      expr: technology_domain
      comment: "Primary technology area of the invention"
    - name: "business_unit"
      expr: business_unit
      comment: "Business unit that owns or sponsored the invention"
    - name: "is_licensed"
      expr: is_licensed
      comment: "Whether patent has been licensed to third parties"
    - name: "standard_essential_patent_flag"
      expr: standard_essential_patent_flag
      comment: "Whether patent is declared as SEP"
  measures:
    - name: "count_patent_filings"
      expr: COUNT(1)
      comment: "Total number of patent filing records"
    - name: "count_granted_patents"
      expr: SUM(CASE WHEN prosecution_status = 'granted' THEN 1 ELSE 0 END)
      comment: "Number of patents successfully granted"
    - name: "total_filing_costs"
      expr: SUM(CAST(filing_cost_amount AS DOUBLE))
      comment: "Total legal and official fees incurred at filing"
    - name: "total_prosecution_costs"
      expr: SUM(CAST(prosecution_cost_amount AS DOUBLE))
      comment: "Total costs incurred during prosecution phase"
    - name: "total_annuity_costs"
      expr: SUM(CAST(annuity_cost_amount AS DOUBLE))
      comment: "Total annuity or renewal fees paid to maintain patents"
    - name: "patent_grant_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN prosecution_status = 'granted' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of patent applications successfully granted, indicating prosecution effectiveness"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_prototype_development`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "R&D prototype development metrics tracking prototype counts, build costs, test outcomes, and development cycle times across technology domains and prototype types. Supports prototype portfolio management and design validation efficiency analysis."
  source: "`manufacturing_ecm`.`research`.`research_prototype`"
  dimensions:
    - name: "type"
      expr: type
      comment: "Classification by development maturity (proof-of-concept, engineering prototype, pre-production pilot)"
    - name: "status"
      expr: status
      comment: "Current lifecycle status of the prototype"
    - name: "technology_domain"
      expr: technology_domain
      comment: "Primary technology area addressed by prototype"
    - name: "stage_gate_phase"
      expr: stage_gate_phase
      comment: "R&D stage-gate phase during which prototype was created"
    - name: "test_outcome"
      expr: test_outcome
      comment: "Overall result of prototype testing phase"
    - name: "disposition"
      expr: disposition
      comment: "Planned or executed end-of-life action for prototype"
    - name: "is_virtual"
      expr: is_virtual
      comment: "Whether prototype is virtual/simulation-based or physical hardware"
    - name: "external_partner_involved"
      expr: external_partner_involved
      comment: "Whether external research partner collaborated on prototype"
    - name: "build_site_country"
      expr: build_site_country
      comment: "ISO 3166-1 alpha-3 country code where prototype was built"
  measures:
    - name: "count_prototypes"
      expr: COUNT(1)
      comment: "Total number of R&D prototypes"
    - name: "count_physical_prototypes"
      expr: SUM(CASE WHEN is_virtual = FALSE THEN 1 ELSE 0 END)
      comment: "Number of physical hardware prototypes"
    - name: "count_virtual_prototypes"
      expr: SUM(CASE WHEN is_virtual = TRUE THEN 1 ELSE 0 END)
      comment: "Number of virtual/simulation-based prototypes"
    - name: "count_successful_tests"
      expr: SUM(CASE WHEN test_outcome = 'pass' THEN 1 ELSE 0 END)
      comment: "Number of prototypes that passed testing"
    - name: "total_build_cost_usd"
      expr: SUM(CAST(build_cost_amount AS DOUBLE))
      comment: "Total actual cost to build all prototypes"
    - name: "avg_build_cost_usd"
      expr: AVG(CAST(build_cost_amount AS DOUBLE))
      comment: "Average cost per prototype build"
    - name: "prototype_success_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN test_outcome = 'pass' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of prototypes that passed testing, indicating design quality"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_rd_test_execution`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "R&D test execution metrics tracking test pass rates, failure modes, retest frequency, and test coverage across test types and technology domains. Supports technology readiness assessment and quality gate decisions."
  source: "`manufacturing_ecm`.`research`.`rd_test_result`"
  dimensions:
    - name: "result_status"
      expr: result_status
      comment: "Overall pass/fail determination for test execution"
    - name: "test_type"
      expr: test_type
      comment: "Classification by technical nature (functional, performance, environmental, safety, EMC, regulatory)"
    - name: "test_category"
      expr: test_category
      comment: "Business classification (design verification, design validation, process validation)"
    - name: "stage_gate_phase"
      expr: stage_gate_phase
      comment: "Product development stage-gate phase during test"
    - name: "test_environment"
      expr: test_environment
      comment: "Physical or virtual environment where test was conducted"
    - name: "disposition"
      expr: disposition
      comment: "Recommended disposition action based on test outcome"
    - name: "retest_required"
      expr: retest_required
      comment: "Whether test result requires retest"
    - name: "failure_mode"
      expr: failure_mode
      comment: "Categorized description of failure manner"
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of test facility"
  measures:
    - name: "count_test_results"
      expr: COUNT(1)
      comment: "Total number of test execution records"
    - name: "count_passed_tests"
      expr: SUM(CASE WHEN result_status = 'pass' THEN 1 ELSE 0 END)
      comment: "Number of tests that passed acceptance criteria"
    - name: "count_failed_tests"
      expr: SUM(CASE WHEN result_status = 'fail' THEN 1 ELSE 0 END)
      comment: "Number of tests that failed acceptance criteria"
    - name: "count_retests_required"
      expr: SUM(CASE WHEN retest_required = TRUE THEN 1 ELSE 0 END)
      comment: "Number of test results requiring retest"
    - name: "test_pass_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN result_status = 'pass' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of tests passing on first execution, indicating design maturity and test quality"
    - name: "test_retest_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN retest_required = TRUE THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of tests requiring retest, indicating test execution quality"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_stage_gate_governance`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Stage-gate review governance metrics tracking gate decisions, approval rates, committee scores, and action item counts across R&D portfolio. Supports portfolio governance effectiveness and stage-gate process performance analysis."
  source: "`manufacturing_ecm`.`research`.`stage_gate_review`"
  dimensions:
    - name: "gate_number"
      expr: gate_number
      comment: "Specific gate in stage-gate process (G0-G5)"
    - name: "decision"
      expr: decision
      comment: "Formal outcome decision (Go, No-Go, Hold, Recycle)"
    - name: "status"
      expr: status
      comment: "Current lifecycle status of stage-gate review event"
    - name: "apqp_phase"
      expr: apqp_phase
      comment: "Corresponding APQP phase associated with gate review"
    - name: "review_type"
      expr: review_type
      comment: "Classification of review event (scheduled, informal, emergency, ad-hoc)"
    - name: "external_partner_involved"
      expr: external_partner_involved
      comment: "Whether external research partner was involved in review"
    - name: "ip_risk_flag"
      expr: ip_risk_flag
      comment: "Whether IP risks were identified during review"
    - name: "regulatory_compliance_flag"
      expr: regulatory_compliance_flag
      comment: "Whether regulatory compliance concerns were identified"
    - name: "country_code"
      expr: country_code
      comment: "ISO 3166-1 alpha-3 country code of primary project location"
  measures:
    - name: "count_gate_reviews"
      expr: COUNT(1)
      comment: "Total number of stage-gate review events"
    - name: "count_go_decisions"
      expr: SUM(CASE WHEN decision = 'Go' THEN 1 ELSE 0 END)
      comment: "Number of reviews resulting in Go decision"
    - name: "count_no_go_decisions"
      expr: SUM(CASE WHEN decision = 'No-Go' THEN 1 ELSE 0 END)
      comment: "Number of reviews resulting in No-Go decision"
    - name: "count_hold_decisions"
      expr: SUM(CASE WHEN decision = 'Hold' THEN 1 ELSE 0 END)
      comment: "Number of reviews resulting in Hold decision"
    - name: "total_budget_approved"
      expr: SUM(CAST(budget_approved_amount AS DOUBLE))
      comment: "Total budget approved across all gate reviews"
    - name: "avg_overall_gate_score"
      expr: AVG(CAST(overall_gate_score AS DOUBLE))
      comment: "Average composite gate readiness score across reviews"
    - name: "avg_technical_readiness_score"
      expr: AVG(CAST(technical_readiness_score AS DOUBLE))
      comment: "Average technical maturity score across reviews"
    - name: "avg_commercial_viability_score"
      expr: AVG(CAST(commercial_viability_score AS DOUBLE))
      comment: "Average commercial attractiveness score across reviews"
    - name: "gate_approval_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN decision = 'Go' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of gate reviews resulting in Go decision, indicating portfolio quality and readiness"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_technology_readiness_maturation`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Technology Readiness Level (TRL) assessment metrics tracking TRL progression, assessment frequency, and gate decisions across technology domains. Supports technology maturation tracking and stage-gate advancement analysis."
  source: "`manufacturing_ecm`.`research`.`technology_readiness`"
  dimensions:
    - name: "assessed_trl"
      expr: assessed_trl
      comment: "TRL level (1-9) assigned as result of assessment"
    - name: "previous_trl"
      expr: previous_trl
      comment: "TRL level at time of preceding assessment"
    - name: "target_trl"
      expr: target_trl
      comment: "Next TRL milestone expected to be achieved"
    - name: "technology_domain"
      expr: technology_domain
      comment: "Primary technology domain of assessed technology"
    - name: "assessment_type"
      expr: assessment_type
      comment: "Classification by business trigger (Initial baseline, Stage-Gate review, EU grant milestone, external audit)"
    - name: "gate_decision"
      expr: gate_decision
      comment: "Formal stage-gate decision outcome associated with TRL assessment"
    - name: "status"
      expr: status
      comment: "Current lifecycle status of TRL assessment record"
    - name: "stage_gate_phase"
      expr: stage_gate_phase
      comment: "Stage-gate phase of R&D project at time of assessment"
    - name: "external_partner_involved"
      expr: external_partner_involved
      comment: "Whether external research partner was involved in technology development"
    - name: "owning_business_unit"
      expr: owning_business_unit
      comment: "Business unit responsible for the technology"
    - name: "owning_country_code"
      expr: owning_country_code
      comment: "ISO 3166-1 alpha-3 country code where R&D activity was conducted"
  measures:
    - name: "count_trl_assessments"
      expr: COUNT(1)
      comment: "Total number of TRL assessment records"
    - name: "count_go_decisions"
      expr: SUM(CASE WHEN gate_decision = 'Go' THEN 1 ELSE 0 END)
      comment: "Number of assessments resulting in Go decision"
    - name: "count_no_go_decisions"
      expr: SUM(CASE WHEN gate_decision = 'No-Go' THEN 1 ELSE 0 END)
      comment: "Number of assessments resulting in No-Go decision"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_lab_resource_utilization`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Laboratory resource utilization metrics tracking booking counts, utilization hours, booking conflicts, and resource availability across lab locations and test phases. Supports lab capacity planning and resource optimization."
  source: "`manufacturing_ecm`.`research`.`lab_booking`"
  dimensions:
    - name: "status"
      expr: status
      comment: "Current lifecycle status of lab booking"
    - name: "booking_type"
      expr: booking_type
      comment: "Classification of booking purpose (standard R&D, recurring, emergency, external partner, maintenance)"
    - name: "lab_location"
      expr: lab_location
      comment: "Physical location or site identifier of laboratory"
    - name: "lab_location_country_code"
      expr: lab_location_country_code
      comment: "ISO 3166-1 alpha-3 country code of laboratory site"
    - name: "stage_gate_phase"
      expr: stage_gate_phase
      comment: "Stage-gate process phase associated with lab booking"
    - name: "apqp_phase"
      expr: apqp_phase
      comment: "APQP phase associated with lab booking"
    - name: "priority"
      expr: priority
      comment: "Business priority level assigned to lab booking"
    - name: "conflict_flag"
      expr: conflict_flag
      comment: "Whether booking had scheduling conflict"
    - name: "external_partner_involved"
      expr: external_partner_involved
      comment: "Whether external research partner participated in lab session"
    - name: "hazardous_material_involved"
      expr: hazardous_material_involved
      comment: "Whether lab session involved hazardous materials"
    - name: "safety_clearance_required"
      expr: safety_clearance_required
      comment: "Whether lab activity required safety clearance or permit-to-work"
  measures:
    - name: "count_lab_bookings"
      expr: COUNT(1)
      comment: "Total number of laboratory resource bookings"
    - name: "count_completed_bookings"
      expr: SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END)
      comment: "Number of bookings successfully completed"
    - name: "count_cancelled_bookings"
      expr: SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END)
      comment: "Number of bookings cancelled"
    - name: "count_conflict_bookings"
      expr: SUM(CASE WHEN conflict_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of bookings with scheduling conflicts"
    - name: "total_scheduled_hours"
      expr: SUM(CAST(scheduled_duration_hours AS DOUBLE))
      comment: "Total planned lab resource hours across all bookings"
    - name: "total_actual_utilization_hours"
      expr: SUM(CAST(actual_utilization_hours AS DOUBLE))
      comment: "Total actual lab resource utilization hours"
    - name: "lab_utilization_efficiency"
      expr: ROUND(100.0 * SUM(CAST(actual_utilization_hours AS DOUBLE)) / NULLIF(SUM(CAST(scheduled_duration_hours AS DOUBLE)), 0), 2)
      comment: "Percentage of scheduled lab hours actually utilized, indicating booking accuracy and resource efficiency"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_innovation_pipeline_funnel`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "Innovation pipeline funnel metrics tracking idea submissions, stage progression, feasibility scores, and estimated commercial value across pipeline stages and technology categories. Supports portfolio investment prioritization and innovation funnel health analysis."
  source: "`manufacturing_ecm`.`research`.`innovation_pipeline`"
  dimensions:
    - name: "pipeline_stage"
      expr: pipeline_stage
      comment: "Current stage in innovation funnel (ideation, concept screening, feasibility, development, validation, pilot, commercialization)"
    - name: "innovation_category"
      expr: innovation_category
      comment: "Primary technology domain classification (automation, electrification, smart infrastructure, digital manufacturing)"
    - name: "innovation_type"
      expr: innovation_type
      comment: "Classification by novelty degree (incremental, adjacent, disruptive)"
    - name: "stage_gate_status"
      expr: stage_gate_status
      comment: "Decision outcome at most recent stage-gate review"
    - name: "strategic_priority_tier"
      expr: strategic_priority_tier
      comment: "Executive-assigned strategic priority classification"
    - name: "risk_level"
      expr: risk_level
      comment: "Overall risk classification (technical, schedule, commercial)"
    - name: "source_of_idea"
      expr: source_of_idea
      comment: "Origin channel of innovation idea (internal R&D, customer request, market analysis, technology scouting)"
    - name: "external_partner_involved"
      expr: external_partner_involved
      comment: "Whether external research partner is collaborating"
    - name: "regulatory_compliance_required"
      expr: regulatory_compliance_required
      comment: "Whether innovation requires regulatory approval or certification"
    - name: "prototype_required"
      expr: prototype_required
      comment: "Whether physical or digital prototype development is required"
    - name: "owning_business_unit"
      expr: owning_business_unit
      comment: "Business unit that owns and sponsors the innovation"
    - name: "owning_country_code"
      expr: owning_country_code
      comment: "ISO 3166-1 alpha-3 country code where innovation is being developed"
  measures:
    - name: "count_innovations"
      expr: COUNT(1)
      comment: "Total number of innovation pipeline entries"
    - name: "count_approved_innovations"
      expr: SUM(CASE WHEN stage_gate_status = 'approved' THEN 1 ELSE 0 END)
      comment: "Number of innovations approved at stage-gate"
    - name: "count_rejected_innovations"
      expr: SUM(CASE WHEN stage_gate_status = 'rejected' THEN 1 ELSE 0 END)
      comment: "Number of innovations rejected at stage-gate"
    - name: "total_estimated_commercial_value_usd"
      expr: SUM(CAST(estimated_commercial_value_usd AS DOUBLE))
      comment: "Total estimated addressable commercial value across pipeline"
    - name: "total_estimated_rd_investment_usd"
      expr: SUM(CAST(estimated_rd_investment_usd AS DOUBLE))
      comment: "Total estimated R&D investment required across pipeline"
    - name: "avg_feasibility_score"
      expr: AVG(CAST(feasibility_score AS DOUBLE))
      comment: "Average composite feasibility score (0-100) across innovations"
    - name: "avg_expected_roi_percent"
      expr: AVG(CAST(expected_roi_percent AS DOUBLE))
      comment: "Average projected ROI percentage across innovations"
    - name: "innovation_approval_rate"
      expr: ROUND(100.0 * SUM(CASE WHEN stage_gate_status = 'approved' THEN 1 ELSE 0 END) / NULLIF(COUNT(1), 0), 2)
      comment: "Percentage of innovations approved at stage-gate, indicating pipeline quality"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_rd_risk_portfolio`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "R&D risk portfolio metrics tracking risk counts, severity scores, mitigation status, and cost impacts across risk categories and technology domains. Supports portfolio risk management and stage-gate risk reviews."
  source: "`manufacturing_ecm`.`research`.`rd_risk`"
  dimensions:
    - name: "risk_category"
      expr: risk_category
      comment: "High-level classification (technical, commercial, regulatory, resource)"
    - name: "risk_subcategory"
      expr: risk_subcategory
      comment: "Granular classification within risk category"
    - name: "status"
      expr: status
      comment: "Current lifecycle status of risk record"
    - name: "impact_severity"
      expr: impact_severity
      comment: "Qualitative assessment of consequence magnitude"
    - name: "probability_rating"
      expr: probability_rating
      comment: "Qualitative assessment of likelihood"
    - name: "risk_response_strategy"
      expr: risk_response_strategy
      comment: "Selected strategic approach (avoid, mitigate, transfer, accept, escalate)"
    - name: "technology_domain"
      expr: technology_domain
      comment: "Technology area to which risk pertains"
    - name: "stage_gate_phase"
      expr: stage_gate_phase
      comment: "R&D stage-gate phase during which risk was identified"
    - name: "escalation_flag"
      expr: escalation_flag
      comment: "Whether risk has been escalated to senior management"
    - name: "ip_risk_flag"
      expr: ip_risk_flag
      comment: "Whether risk involves IP concerns"
    - name: "freedom_to_operate_concern"
      expr: freedom_to_operate_concern
      comment: "Whether risk involves freedom-to-operate concern"
    - name: "external_partner_involved"
      expr: external_partner_involved
      comment: "Whether risk involves external research partner"
  measures:
    - name: "count_risks"
      expr: COUNT(1)
      comment: "Total number of identified R&D risks"
    - name: "count_open_risks"
      expr: SUM(CASE WHEN status = 'open' THEN 1 ELSE 0 END)
      comment: "Number of risks currently open and active"
    - name: "count_closed_risks"
      expr: SUM(CASE WHEN status = 'closed' THEN 1 ELSE 0 END)
      comment: "Number of risks formally closed or accepted"
    - name: "count_escalated_risks"
      expr: SUM(CASE WHEN escalation_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of risks escalated to senior management"
    - name: "count_ip_risks"
      expr: SUM(CASE WHEN ip_risk_flag = TRUE THEN 1 ELSE 0 END)
      comment: "Number of risks involving IP concerns"
    - name: "total_estimated_cost_impact_usd"
      expr: SUM(CAST(estimated_cost_impact_usd AS DOUBLE))
      comment: "Total estimated financial impact if risks materialize"
    - name: "avg_risk_score"
      expr: AVG(CAST(risk_score AS DOUBLE))
      comment: "Average composite risk score across portfolio"
    - name: "avg_residual_risk_score"
      expr: AVG(CAST(residual_risk_score AS DOUBLE))
      comment: "Average residual risk score after mitigation"
    - name: "avg_probability_score"
      expr: AVG(CAST(probability_score AS DOUBLE))
      comment: "Average probability score (0.00-1.00) across risks"
$$;

CREATE OR REPLACE VIEW `manufacturing_ecm`.`_metrics`.`research_collaboration_agreement_portfolio`
WITH METRICS
LANGUAGE YAML
AS $$
  version: 1.1
  comment: "External research collaboration agreement portfolio metrics tracking agreement counts, financial commitments, IP ownership terms, and agreement status across partner types and technology domains. Supports partner relationship management and collaboration governance."
  source: "`manufacturing_ecm`.`research`.`collaboration_agreement`"
  dimensions:
    - name: "agreement_type"
      expr: agreement_type
      comment: "Classification of collaboration agreement type (JDA, CRA, consortium_membership, sponsored_research, NDA, MOU)"
    - name: "status"
      expr: status
      comment: "Current lifecycle status of collaboration agreement"
    - name: "partner_type"
      expr: partner_type
      comment: "Classification of external research partner organization type"
    - name: "technology_domain"
      expr: technology_domain
      comment: "Primary technology domain covered by collaboration"
    - name: "ip_ownership_model"
      expr: ip_ownership_model
      comment: "IP ownership structure for foreground IP generated under agreement"
    - name: "stage_gate_phase"
      expr: stage_gate_phase
      comment: "Current stage-gate phase of R&D initiative associated with agreement"
    - name: "export_control_flag"
      expr: export_control_flag
      comment: "Whether agreement involves technology subject to export control regulations"
    - name: "nda_included"
      expr: nda_included
      comment: "Whether NDA or confidentiality provisions are embedded"
    - name: "renewal_option"
      expr: renewal_option
      comment: "Whether agreement contains provisions for renewal or extension"
    - name: "partner_country_code"
      expr: partner_country_code
      comment: "ISO 3166-1 alpha-3 country code of partner's primary location"
  measures:
    - name: "count_agreements"
      expr: COUNT(1)
      comment: "Total number of collaboration agreements"
    - name: "count_active_agreements"
      expr: SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END)
      comment: "Number of currently active collaboration agreements"
    - name: "total_agreement_value"
      expr: SUM(CAST(total_agreement_value AS DOUBLE))
      comment: "Total monetary value of collaboration agreements"
    - name: "total_company_financial_commitment"
      expr: SUM(CAST(company_financial_commitment AS DOUBLE))
      comment: "Total financial commitment by company under agreements"
    - name: "avg_ip_ownership_company_pct"
      expr: AVG(CAST(ip_ownership_company_pct AS DOUBLE))
      comment: "Average percentage of foreground IP ownership attributed to company"
$$;