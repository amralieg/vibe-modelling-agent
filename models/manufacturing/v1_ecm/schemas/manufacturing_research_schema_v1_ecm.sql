-- Schema for Domain: research | Business: Manufacturing | Version: v1_ecm
-- Generated on: 2026-04-16 07:42:36

-- ========= DATABASE =========
CREATE DATABASE IF NOT EXISTS `manufacturing_ecm`.`research` COMMENT 'Manages R&D project portfolios, innovation pipelines, technology roadmaps, prototype development, testing and validation, intellectual property management, and experimental BOM tracking. Supports stage-gate processes, APQP planning, and collaboration with external research partners for automation, electrification, and smart infrastructure technologies.';

-- ========= TABLES =========
CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` (
    `innovation_pipeline_id` BIGINT COMMENT 'Unique system-generated identifier for each innovation pipeline record within the R&D portfolio management system.',
    `technology_roadmap_id` BIGINT COMMENT 'Foreign key linking to research.technology_roadmap. Business justification: An innovation pipeline item is aligned to a specific technology roadmap. innovation_pipeline has roadmap_alignment_code (string) as a denormalized reference. Adding technology_roadmap_id as a proper F',
    `applicable_regulation` STRING COMMENT 'Comma-separated list of specific regulatory standards or certifications applicable to this innovation (e.g., CE Marking, UL, RoHS, REACH, IEC 62443, ISO 9001). Used for compliance planning and certification tracking.',
    `apqp_phase` STRING COMMENT 'Current phase within the Advanced Product Quality Planning (APQP) framework applicable to this innovation. Used to align R&D pipeline activities with quality planning milestones for innovations transitioning toward production.. Valid values are `phase_1_planning|phase_2_product_design|phase_3_process_design|phase_4_validation|phase_5_launch|not_applicable`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when the innovation pipeline record was first created in the data platform. Used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code representing the base currency in which financial estimates for this innovation pipeline record are denominated (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Detailed narrative describing the innovation concept, its technical approach, and intended application within automation, electrification, or smart infrastructure domains.',
    `estimated_commercial_value_usd` DECIMAL(18,2) COMMENT 'Estimated total addressable commercial value or revenue potential of the innovation in US Dollars, as assessed during feasibility or business case development. Used for portfolio-level investment prioritization.',
    `estimated_rd_investment_usd` DECIMAL(18,2) COMMENT 'Total estimated capital and operational expenditure required to develop the innovation from current stage through commercialization, expressed in US Dollars. Supports Capital Expenditure (CAPEX) and Operational Expenditure (OPEX) planning.',
    `expected_roi_percent` DECIMAL(18,2) COMMENT 'Projected Return on Investment (ROI) percentage for the innovation, calculated as part of the business case. Expressed as a percentage of the estimated R&D investment. Used for portfolio prioritization and investment committee decisions.',
    `external_partner_involved` BOOLEAN COMMENT 'Indicates whether an external research partner (university, research institute, technology partner, or consortium) is collaborating on this innovation. Supports partner collaboration tracking and IP ownership governance.. Valid values are `true|false`',
    `external_partner_name` STRING COMMENT 'Name of the primary external research partner, university, or technology consortium collaborating on this innovation. Populated when external_partner_involved is true.',
    `feasibility_completion_date` DATE COMMENT 'Date on which the technical and commercial feasibility assessment was formally completed and documented.. Valid values are `^d{4}-d{2}-d{2}$`',
    `feasibility_score` DECIMAL(18,2) COMMENT 'Composite feasibility assessment score (0–100) assigned during the feasibility gate review, reflecting technical, commercial, and operational viability. Used to rank and prioritize innovations within the pipeline.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `innovation_category` STRING COMMENT 'Primary technology domain classification of the innovation. Aligns with Manufacturings strategic focus areas: automation systems, electrification solutions, smart infrastructure, and digital manufacturing capabilities.. Valid values are `automation|electrification|smart_infrastructure|digital_manufacturing|sustainability|materials|process_improvement|other`',
    `innovation_type` STRING COMMENT 'Classification of the innovation by its degree of novelty and strategic impact. Distinguishes between incremental improvements, adjacent expansions, and disruptive breakthroughs to support portfolio balance decisions.. Valid values are `incremental|adjacent|disruptive|platform|product|process|business_model`',
    `ip_protection_type` STRING COMMENT 'Type of intellectual property (IP) protection applied or planned for the innovation. Tracks patent status, trade secret designation, or open-source licensing to support IP portfolio management.. Valid values are `patent_pending|patent_granted|trade_secret|copyright|open_source|none|under_review`',
    `last_stage_transition_date` DATE COMMENT 'Date on which the innovation most recently transitioned from one pipeline stage to the next. Used to calculate stage cycle times and identify bottlenecks in the innovation funnel.. Valid values are `^d{4}-d{2}-d{2}$`',
    `modified_timestamp` TIMESTAMP COMMENT 'System timestamp recording the most recent update to the innovation pipeline record. Used for change tracking, audit compliance, and incremental data processing in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `owning_business_unit` STRING COMMENT 'Name of the business unit or division within Manufacturing that owns and sponsors the innovation pipeline entry. Used for portfolio segmentation and budget allocation reporting.',
    `owning_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary country where the innovation is being developed or managed. Supports multi-national portfolio reporting and regional technology roadmap alignment.. Valid values are `^[A-Z]{3}$`',
    `patent_application_number` STRING COMMENT 'Official patent application reference number assigned by the relevant patent authority (e.g., USPTO, EPO) for innovations with pending or granted patent protection.',
    `payback_period_months` STRING COMMENT 'Estimated number of months required to recover the R&D investment from commercial revenues or cost savings generated by the innovation. Used in investment committee evaluations.',
    `pipeline_code` STRING COMMENT 'Human-readable business reference code for the innovation pipeline entry, used for cross-system tracking and reporting. Format: INN-[CATEGORY]-[YEAR]-[SEQUENCE].. Valid values are `^INN-[A-Z]{2,6}-[0-9]{4}-[0-9]{4}$`',
    `pipeline_owner` STRING COMMENT 'Full name or employee identifier of the individual accountable for managing and advancing this innovation through the pipeline. Serves as the primary point of contact for stage-gate reviews and portfolio reporting.',
    `pipeline_stage` STRING COMMENT 'Current stage of the innovation within the structured stage-gate funnel. Tracks progression from initial ideation through concept screening, feasibility assessment, development, validation, pilot, and commercialization. Supports Advanced Product Quality Planning (APQP) stage-gate governance.. Valid values are `ideation|concept_screening|feasibility|development|validation|pilot|commercialization|archived`',
    `prototype_required` BOOLEAN COMMENT 'Indicates whether physical or digital prototype development is required as part of the innovation validation process. Drives resource planning for prototype labs and engineering capacity.. Valid values are `true|false`',
    `regulatory_compliance_required` BOOLEAN COMMENT 'Indicates whether the innovation requires regulatory approval or compliance certification (e.g., CE Marking, UL certification, RoHS/REACH compliance, IEC standards) prior to commercialization.. Valid values are `true|false`',
    `risk_level` STRING COMMENT 'Overall risk classification assigned to the innovation based on technical complexity, market uncertainty, regulatory requirements, and investment exposure. Supports portfolio risk balancing.. Valid values are `very_low|low|medium|high|very_high`',
    `screening_date` DATE COMMENT 'Date on which the initial concept screening review was completed and a go/no-go decision was recorded for the innovation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `source_of_idea` STRING COMMENT 'Origin channel through which the innovation idea was generated. Supports analysis of innovation pipeline health and effectiveness of idea generation programs across internal and external sources.. Valid values are `internal_rd|customer_feedback|market_research|competitor_analysis|academic_research|supplier_suggestion|regulatory_requirement|employee_suggestion|other`',
    `stage_gate_status` STRING COMMENT 'Decision outcome at the most recent stage-gate review. Indicates whether the innovation has been approved to proceed, conditionally approved with conditions, placed on hold, or rejected at the current gate.. Valid values are `pending_review|approved|conditionally_approved|on_hold|rejected|cancelled`',
    `strategic_priority_tier` STRING COMMENT 'Executive-assigned strategic priority classification indicating the relative importance of this innovation to the corporate technology roadmap and portfolio investment strategy. Tier 1 represents highest strategic alignment.. Valid values are `tier_1_critical|tier_2_high|tier_3_medium|tier_4_low`',
    `submission_date` DATE COMMENT 'Calendar date on which the innovation idea was formally submitted to the pipeline for initial screening and evaluation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `submitter_name` STRING COMMENT 'Name of the individual or team who originally submitted the innovation idea to the pipeline. Supports innovation culture tracking and inventor recognition programs.',
    `sustainability_impact` STRING COMMENT 'Assessment of the innovations expected environmental and sustainability impact. Supports alignment with ISO 14001 environmental management objectives and corporate ESG reporting commitments.. Valid values are `positive|neutral|negative|under_assessment`',
    `target_commercialization_date` DATE COMMENT 'Planned calendar date by which the innovation is expected to reach commercial readiness or market launch. Used for technology roadmap planning and portfolio milestone tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `target_market_segment` STRING COMMENT 'Primary market or industry segment that the innovation is intended to address upon commercialization. Aligns with Manufacturings end-market focus areas for strategic portfolio planning.. Valid values are `factory_automation|building_infrastructure|transportation|urban_environment|energy_utilities|cross_industry|other`',
    `technology_readiness_level` STRING COMMENT 'NASA/EU-standard Technology Readiness Level (TRL) score from 1 to 9 indicating the maturity of the underlying technology. TRL 1 = basic principles observed; TRL 9 = proven in operational environment. Used for portfolio risk assessment.. Valid values are `^([1-9])$`',
    `title` STRING COMMENT 'Short, descriptive title of the innovation concept or technology initiative as submitted to the pipeline. Used for portfolio dashboards and executive reporting.',
    CONSTRAINT pk_innovation_pipeline PRIMARY KEY(`innovation_pipeline_id`)
) COMMENT 'Master record representing the structured innovation funnel and technology pipeline for Manufacturings R&D portfolio. Tracks ideation submissions, concept screening outcomes, feasibility assessments, and pipeline stage transitions from idea to approved project. Captures innovation category (automation, electrification, smart infrastructure), strategic priority tier, estimated commercial value, and pipeline owner. Supports portfolio-level investment decisions and technology roadmap alignment.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`technology_roadmap` (
    `technology_roadmap_id` BIGINT COMMENT 'Unique system-generated identifier for each technology roadmap record within the R&D portfolio management system.',
    `annual_investment_usd` DECIMAL(18,2) COMMENT 'Planned annual R&D investment for the current fiscal year associated with this technology roadmap, expressed in US Dollars. Used for annual budget planning and variance tracking.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `approved_date` DATE COMMENT 'Date on which the current version of the technology roadmap was formally approved by the R&D governance board or executive sponsor.. Valid values are `^d{4}-d{2}-d{2}$`',
    `capability_gap_summary` STRING COMMENT 'Narrative summary of the key capability gaps identified between the current state and the target state defined in this technology roadmap, informing R&D investment priorities.',
    `competitive_benchmark_summary` STRING COMMENT 'Summary of competitive benchmarking findings that informed this roadmap, including key competitor capabilities, market trends, and technology differentiators.',
    `corporate_strategy_alignment` STRING COMMENT 'Description of how this technology roadmap aligns to specific corporate strategic pillars, initiatives, or transformation programs (e.g., Digital Factory 2030, Electrification Leadership, Sustainability Net Zero).',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when the technology roadmap record was first created in the data platform, used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Detailed narrative describing the scope, objectives, and strategic intent of the technology roadmap, including key technology themes and innovation focus areas.',
    `external_partner_involved` BOOLEAN COMMENT 'Indicates whether external research partners (universities, research institutes, joint ventures, or technology partners) are involved in delivering this technology roadmap.. Valid values are `true|false`',
    `external_partner_names` STRING COMMENT 'Comma-separated list of external research partners, universities, or technology collaborators contributing to this technology roadmap (e.g., MIT, Fraunhofer Institute, ABB Research).',
    `gate_review_outcome` STRING COMMENT 'Outcome decision from the most recent stage-gate review: Go (proceed), Conditional Go (proceed with conditions), Hold (pause pending resolution), Recycle (return to prior gate), or Kill (terminate).. Valid values are `Go|Conditional Go|Hold|Recycle|Kill`',
    `geographic_scope` STRING COMMENT 'Comma-separated list of ISO 3166-1 alpha-3 country codes or regions where this technology roadmap is applicable or where R&D activities will be conducted (e.g., USA, DEU, CHN, JPN).',
    `horizon_end_date` DATE COMMENT 'The calendar date marking the end of the technology roadmap planning horizon, defining the multi-year scope of the roadmap (e.g., 3-year, 5-year, 10-year horizon).. Valid values are `^d{4}-d{2}-d{2}$`',
    `horizon_start_date` DATE COMMENT 'The calendar date marking the beginning of the technology roadmap planning horizon, typically aligned to a fiscal or calendar year.. Valid values are `^d{4}-d{2}-d{2}$`',
    `horizon_years` STRING COMMENT 'Total duration of the technology roadmap planning horizon expressed in years (e.g., 3, 5, 10). Used for portfolio-level horizon filtering and strategic planning analytics.. Valid values are `^[1-9][0-9]?$`',
    `investment_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the planned R&D investment amount (e.g., USD, EUR, GBP), supporting multi-currency reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `ip_strategy` STRING COMMENT 'Intellectual property strategy associated with the technologies developed under this roadmap, defining how innovations will be protected, licensed, or shared.. Valid values are `Patent|Trade Secret|Open Source|Licensing|Joint IP|Defensive Publication|Not Applicable`',
    `last_gate_review_date` DATE COMMENT 'Date of the most recently completed stage-gate review for this technology roadmap, providing an audit trail of governance decisions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_reviewed_date` DATE COMMENT 'Date on which the technology roadmap was most recently reviewed for currency, strategic alignment, and milestone progress, regardless of whether a formal revision was made.. Valid values are `^d{4}-d{2}-d{2}$`',
    `lead_engineer` STRING COMMENT 'Name or employee identifier of the principal engineer or technical lead responsible for the day-to-day technical execution and milestone tracking of this technology roadmap.',
    `maturity_level` STRING COMMENT 'Current maturity level of the technology covered by this roadmap, based on a Technology Readiness Level (TRL) or equivalent internal scale, indicating readiness for commercialization.. Valid values are `Concept|Research|Development|Validation|Pilot|Production Ready|Mature|End of Life`',
    `modified_timestamp` TIMESTAMP COMMENT 'System timestamp recording the most recent update to the technology roadmap record, supporting change tracking and data freshness monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `name` STRING COMMENT 'Descriptive name of the technology roadmap, typically referencing the product family, platform, or technology domain (e.g., PLC/DCS Automation Roadmap 2025-2030).',
    `next_gate_review_date` DATE COMMENT 'Scheduled date for the next stage-gate review meeting where the roadmaps progress, investment, and strategic alignment will be formally evaluated by the R&D governance board.. Valid values are `^d{4}-d{2}-d{2}$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of the technology roadmap to assess progress, update milestones, and realign with corporate strategy.. Valid values are `^d{4}-d{2}-d{2}$`',
    `patent_count_target` STRING COMMENT 'Target number of patent applications or grants expected to be generated from R&D activities associated with this technology roadmap over its planning horizon.. Valid values are `^[0-9]+$`',
    `planned_rd_investment_usd` DECIMAL(18,2) COMMENT 'Total planned R&D investment budget allocated to this technology roadmap over its full horizon, expressed in US Dollars. Used for CAPEX/OPEX planning and ROI analysis.. Valid values are `^[0-9]+(.[0-9]{1,2})?$`',
    `product_family` STRING COMMENT 'The product family or platform grouping to which this technology roadmap applies (e.g., SIMATIC PLC Series, SINAMICS Drives, SINUMERIK CNC).',
    `regulatory_compliance_requirements` STRING COMMENT 'Summary of applicable regulatory standards and compliance requirements that technologies developed under this roadmap must satisfy (e.g., CE Marking, RoHS, REACH, IEC 62443, UL Certification).',
    `responsible_business_unit` STRING COMMENT 'Name of the business unit or division accountable for executing and delivering this technology roadmap (e.g., Factory Automation Division, Electrification Products Division).',
    `roadmap_code` STRING COMMENT 'Business-assigned alphanumeric code uniquely identifying the technology roadmap, used for cross-system referencing and reporting (e.g., TRM-PLC-2025).. Valid values are `^TRM-[A-Z0-9]{3,10}-[0-9]{4}$`',
    `roadmap_owner` STRING COMMENT 'Name or employee identifier of the senior R&D leader or Chief Technology Officer (CTO) delegate who is the primary business owner and accountable executive for this technology roadmap.',
    `roadmap_type` STRING COMMENT 'Classification of the roadmap by its strategic focus: Product (specific product evolution), Platform (shared technology platform), Technology (emerging technology adoption), Market (market-driven features), Capability (internal capability building), or Integration (system integration roadmap).. Valid values are `Product|Platform|Technology|Market|Capability|Integration`',
    `stage_gate_phase` STRING COMMENT 'Current stage-gate phase of the technology roadmap within the R&D governance process, used to control progression from ideation through commercialization.. Valid values are `Gate 0 - Ideation|Gate 1 - Scoping|Gate 2 - Business Case|Gate 3 - Development|Gate 4 - Testing and Validation|Gate 5 - Launch|Post-Launch Review`',
    `status` STRING COMMENT 'Current lifecycle status of the technology roadmap, governing its visibility and use in planning and investment decisions.. Valid values are `Draft|Under Review|Approved|Active|On Hold|Superseded|Archived|Cancelled`',
    `strategic_priority` STRING COMMENT 'Corporate-assigned strategic priority level of the technology roadmap, reflecting its importance to the overall business strategy and competitive positioning.. Valid values are `Critical|High|Medium|Low`',
    `sustainability_alignment` STRING COMMENT 'Indicates how this technology roadmap aligns to corporate sustainability goals, such as Net Zero emissions, energy efficiency improvements, or circular economy principles.. Valid values are `Net Zero|Energy Efficiency|Circular Economy|Emissions Reduction|Sustainable Materials|Not Applicable`',
    `technology_domain` STRING COMMENT 'The primary technology domain or discipline covered by this roadmap, such as PLC/DCS Automation, Electrification Drives, or IIoT Smart Infrastructure.. Valid values are `PLC/DCS Automation|Electrification Drives|IIoT Smart Infrastructure|Industrial Robotics|Power Electronics|Edge Computing|Digital Twin|Cybersecurity|Human-Machine Interface|Other`',
    `technology_readiness_level` STRING COMMENT 'Numeric Technology Readiness Level (TRL) score from 1 (basic research) to 9 (proven in operational environment), used to assess the maturity of the technology for deployment.. Valid values are `^[1-9]$`',
    `version_number` STRING COMMENT 'Version number of the technology roadmap document, following semantic versioning (e.g., 1.0, 2.1, 3.0), used to track revisions and ensure stakeholders reference the current approved version.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?$`',
    CONSTRAINT pk_technology_roadmap PRIMARY KEY(`technology_roadmap_id`)
) COMMENT 'Master record defining the multi-year technology roadmap for each product family, platform, or technology domain (e.g., PLC/DCS automation, electrification drives, IIoT smart infrastructure). Captures roadmap horizon, technology milestones, capability gaps, planned R&D investments, competitive benchmarks, and alignment to corporate strategy. Links to R&D projects and innovation pipeline entries that deliver roadmap milestones.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`stage_gate_review` (
    `stage_gate_review_id` BIGINT COMMENT 'Unique system-generated identifier for each formal stage-gate review event conducted for an R&D project. Serves as the primary key for this transactional record.',
    `apqp_project_id` BIGINT COMMENT 'Foreign key linking to quality.apqp_project. Business justification: Stage-gate reviews in R&D require APQP project status as a gate criterion. Project managers verify APQP deliverables (FMEA, control plan, PPAP) are on track before approving transition to next develop',
    `assessment_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_assessment. Business justification: Stage-gate reviews require formal compliance assessments before advancing to next phase. Gate criteria include passing compliance checks for safety, environmental, and regulatory standards before inve',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: A stage_gate_review is a formal gate review event conducted FOR a specific R&D project. This is a child→parent relationship (many reviews per project). The stage_gate_review currently has no FK to rd_',
    `action_items` STRING COMMENT 'Structured text or summary of action items raised during the gate review, including required deliverables, corrective actions, and conditions that must be met before the project can proceed. Supports CAPA tracking and follow-up governance.',
    `apqp_phase` STRING COMMENT 'The corresponding Advanced Product Quality Planning (APQP) phase associated with this gate review. Maps the stage-gate decision to the formal APQP governance framework used in automotive and industrial manufacturing.. Valid values are `Phase 1 – Plan and Define|Phase 2 – Product Design and Development|Phase 3 – Process Design and Development|Phase 4 – Product and Process Validation|Phase 5 – Feedback Assessment and Corrective Action`',
    `budget_approved_amount` DECIMAL(18,2) COMMENT 'Total budget amount formally approved by the review committee for the next stage of the R&D project, expressed in the projects base currency. Supports CAPEX/OPEX planning and portfolio investment governance.. Valid values are `^-?[0-9]+(.[0-9]{1,2})?$`',
    `budget_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the budget approved amount (e.g., USD, EUR, GBP). Supports multi-currency financial reporting for multinational R&D portfolio management.. Valid values are `^[A-Z]{3}$`',
    `commercial_viability_score` DECIMAL(18,2) COMMENT 'Numerical score (0–100) assigned by the review committee assessing the commercial attractiveness and market potential of the project, including market size, competitive positioning, and revenue opportunity.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `committee_members` STRING COMMENT 'Comma-separated list or structured text identifying the members of the gate review committee, including their names and functional roles (e.g., R&D Director, Product Manager, Finance Controller, Quality Manager). Supports accountability and audit trail.',
    `committee_size` STRING COMMENT 'Total number of committee members who participated in the stage-gate review. Used for quorum validation and governance reporting.. Valid values are `^[1-9][0-9]*$`',
    `conditions_for_go` STRING COMMENT 'Specific conditions, deliverables, or criteria that must be satisfied before a conditional Go decision becomes unconditional and the project is formally advanced to the next stage. Applicable when decision is Go with conditions or Hold.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary location where the R&D project is being executed at the time of this gate review. Supports multi-country portfolio reporting and regional regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `decision` STRING COMMENT 'The formal outcome decision rendered by the review committee at the conclusion of the stage-gate review. Go advances the project to the next stage; No-Go terminates or suspends the project; Hold pauses pending additional information; Recycle returns the project to the current stage for rework.. Valid values are `Go|No-Go|Hold|Recycle`',
    `decision_rationale` STRING COMMENT 'Narrative explanation documenting the reasoning behind the gate decision, including key factors, risks, and considerations that influenced the committees outcome. Required for audit and governance purposes.',
    `external_partner_involved` BOOLEAN COMMENT 'Boolean indicator (True/False) denoting whether an external research partner, university, or third-party collaborator was involved in or presented at this stage-gate review. Relevant for joint development agreements and IP governance.. Valid values are `true|false`',
    `external_partner_name` STRING COMMENT 'Name of the external research partner, university, or third-party collaborator involved in the project at the time of this gate review. Populated only when external_partner_involved is True.',
    `gate_name` STRING COMMENT 'Descriptive name of the gate milestone being reviewed (e.g., Concept Approval, Feasibility Gate, Design Freeze, Pilot Readiness, Launch Readiness). Provides human-readable context for the gate number.',
    `gate_number` STRING COMMENT 'The specific gate in the stage-gate process being reviewed, ranging from G0 (project initiation/ideation) through G5 (product launch/commercialization). Aligns with APQP phase governance milestones.. Valid values are `G0|G1|G2|G3|G4|G5`',
    `gate_score_threshold` DECIMAL(18,2) COMMENT 'Minimum overall gate score required for a Go decision at this gate. Projects scoring below this threshold require committee deliberation for Hold, Recycle, or No-Go decisions. Enables consistent, criteria-based governance.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `ip_risk_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) flagging whether intellectual property risks, patent conflicts, or IP ownership concerns were identified and raised during this gate review. Triggers IP management review workflows.. Valid values are `true|false`',
    `next_gate_number` STRING COMMENT 'The gate number that the project is expected to reach next following this review. For a Go decision, this is the subsequent gate; for Recycle, it may be the same gate; for No-Go, this field may be null.. Valid values are `G0|G1|G2|G3|G4|G5`',
    `next_gate_target_date` DATE COMMENT 'Target calendar date by which the project is expected to be ready for the next stage-gate review. Used for project scheduling, portfolio timeline management, and APQP milestone tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `notes` STRING COMMENT 'Free-text field for additional observations, committee commentary, or supplementary information recorded during the stage-gate review that does not fit into structured fields. Supports qualitative governance documentation.',
    `open_action_item_count` STRING COMMENT 'Number of action items from this gate review that remain open or unresolved at the time of record capture. Used for portfolio governance dashboards and escalation tracking.. Valid values are `^[0-9]+$`',
    `overall_gate_score` DECIMAL(18,2) COMMENT 'Composite weighted score (0–100) combining all individual criteria scores (technical readiness, commercial viability, resource availability, strategic alignment, risk) to produce a single gate readiness indicator used to support the Go/No-Go decision.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `planned_review_date` DATE COMMENT 'Originally scheduled date for this stage-gate review before any rescheduling. Enables schedule variance analysis and on-time delivery tracking for R&D portfolio governance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `presentation_document_ref` STRING COMMENT 'Reference identifier or URL to the gate review presentation package submitted by the project team, stored in the PLM document management system. Contains project status, deliverable evidence, and criteria scoring justification.',
    `project_phase` STRING COMMENT 'The current development phase of the R&D project at the time of the gate review. Provides context for the stage being exited and the stage being entered upon a Go decision.. Valid values are `Ideation|Concept|Feasibility|Development|Validation|Launch|Post-Launch`',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Boolean indicator (True/False) flagging whether regulatory compliance concerns (e.g., CE Marking, RoHS, REACH, UL certification, IEC 62443 cybersecurity) were identified as open issues during this gate review.. Valid values are `true|false`',
    `resource_availability_score` DECIMAL(18,2) COMMENT 'Numerical score (0–100) assigned by the review committee assessing the availability and adequacy of human, financial, and material resources required to advance the project to the next stage.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `review_chair` STRING COMMENT 'Name or identifier of the individual chairing the stage-gate review meeting, typically a senior R&D leader, portfolio manager, or chief engineer responsible for facilitating the review and recording the formal decision.',
    `review_date` DATE COMMENT 'The calendar date on which the formal stage-gate review meeting was conducted. Used for timeline tracking, APQP phase governance, and portfolio reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `review_duration_minutes` STRING COMMENT 'Total duration of the stage-gate review meeting in minutes. Supports meeting efficiency analysis and resource utilization reporting for the R&D governance process.. Valid values are `^[1-9][0-9]*$`',
    `review_location` STRING COMMENT 'Physical location, virtual meeting platform, or facility where the stage-gate review was conducted (e.g., Berlin R&D Center – Conference Room A, Microsoft Teams – Virtual). Supports multi-site and global project governance.',
    `review_minutes_document_ref` STRING COMMENT 'Reference identifier or URL to the formal meeting minutes document for this stage-gate review, stored in the PLM document management system (e.g., Siemens Teamcenter). Supports audit trail and document traceability.',
    `review_number` STRING COMMENT 'Human-readable business reference number for the stage-gate review event, used for cross-referencing in project documentation, APQP records, and audit trails.. Valid values are `^SGR-[0-9]{4}-[0-9]{6}$`',
    `review_timestamp` TIMESTAMP COMMENT 'Precise date and time when the stage-gate review session commenced, including timezone offset. Supports audit trail requirements and global multi-timezone project coordination.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `review_type` STRING COMMENT 'Classification of the stage-gate review event indicating whether it was a formally scheduled review, an informal checkpoint, an emergency review triggered by a critical risk event, or an ad-hoc review requested by the project team.. Valid values are `Formal|Informal|Emergency|Scheduled|Ad-Hoc`',
    `risk_assessment_score` DECIMAL(18,2) COMMENT 'Numerical score (0–100) reflecting the overall risk level of the project at the gate, incorporating technical, commercial, regulatory, and execution risks. Higher scores indicate lower risk.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `status` STRING COMMENT 'Current lifecycle status of the stage-gate review event. Tracks whether the review has been scheduled, is in progress, has been completed with a decision, or has been cancelled or deferred.. Valid values are `Scheduled|In Progress|Completed|Cancelled|Deferred`',
    `strategic_alignment_score` DECIMAL(18,2) COMMENT 'Numerical score (0–100) evaluating how well the R&D project aligns with the companys technology roadmap, innovation pipeline priorities, and strategic business objectives for automation, electrification, and smart infrastructure.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `technical_readiness_score` DECIMAL(18,2) COMMENT 'Numerical score (0–100) assigned by the review committee assessing the technical maturity and readiness of the project at the gate. Evaluates technology readiness level (TRL), prototype status, and engineering completeness.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    CONSTRAINT pk_stage_gate_review PRIMARY KEY(`stage_gate_review_id`)
) COMMENT 'Transactional record of each formal stage-gate review event conducted for an R&D project. Captures the gate number (G0–G5), review date, gate decision (Go/No-Go/Hold/Recycle), review committee members, key criteria scores (technical readiness, commercial viability, resource availability), action items raised, and next gate target date. Supports APQP phase governance and portfolio investment decisions.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`research_prototype` (
    `research_prototype_id` BIGINT COMMENT 'Unique system-generated identifier for each R&D prototype record within the research domain. Serves as the primary key for all downstream references to this prototype.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Successful prototypes transition to catalog items for commercialization. Product management tracks which catalog item a prototype became for version control, costing rollup, and product portfolio mana',
    `contract_id` BIGINT COMMENT 'Foreign key linking to service.service_contract. Business justification: Prototypes deployed at customer pilot sites require service contracts defining support terms, maintenance schedules, and SLAs during beta testing phases.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Prototypes are built and tested using manufacturing equipment. R&D teams book specific equipment for prototype fabrication and testing, tracking which machines were used for reproducibility and capaci',
    `fmea_id` BIGINT COMMENT 'Foreign key linking to quality.fmea. Business justification: Prototypes are built and tested based on DFMEA risk mitigation strategies. R&D engineers reference FMEA to validate that prototype design addresses identified failure modes and design risks.',
    `hazard_assessment_id` BIGINT COMMENT 'Foreign key linking to hse.hazard_assessment. Business justification: Prototypes in manufacturing require mandatory hazard assessments before testing or production scale-up. Safety teams evaluate new designs for worker risks, chemical exposures, and equipment hazards be',
    `installation_record_id` BIGINT COMMENT 'Foreign key linking to service.installation_record. Business justification: Prototypes deployed to pilot sites require installation records for tracking commissioning, configuration, and handover. Field service teams install and document prototype deployments for R&D feedback',
    `inventory_sku_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Prototypes transition to production SKUs when approved. Engineering teams reference the final SKU assigned to track prototype-to-production lineage for traceability and cost rollup.',
    `ot_system_id` BIGINT COMMENT 'Foreign key linking to technology.ot_system. Business justification: Prototypes in manufacturing R&D are tested on operational technology systems (PLCs, SCADA, robotics controllers). Engineers track which OT system was used for prototype validation and testing cycles.',
    `packaging_id` BIGINT COMMENT 'Foreign key linking to logistics.packaging. Business justification: Prototypes require custom packaging specifications for safe transport to testing sites, customer demonstrations, and certification labs. Engineering defines packaging requirements that logistics must ',
    `account_id` BIGINT COMMENT 'Foreign key linking to customer.account. Business justification: Prototypes are frequently piloted at customer facilities in industrial manufacturing. Field testing of automation systems, electrification solutions at actual customer sites is standard practice befor',
    `procurement_goods_receipt_id` BIGINT COMMENT 'Foreign key linking to procurement.goods_receipt. Business justification: Prototypes require specialized materials and components that arrive via goods receipts. Engineering tracks which materials were received and used in specific prototype builds for traceability and cost',
    `product_certification_id` BIGINT COMMENT 'Foreign key linking to compliance.product_certification. Business justification: Prototypes require certification testing before production release. R&D teams track which certifications (UL, CE, ISO) each prototype has achieved to validate design compliance and readiness for manuf',
    `production_plant_id` BIGINT COMMENT 'Foreign key linking to production.production_plant. Business justification: Prototypes are built at specific manufacturing plants to validate producibility with actual production equipment. R&D teams coordinate with plant engineering for prototype fabrication access.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: A prototype is developed during an R&D project. This is a child→parent relationship (many prototypes per project). The prototype table has no FK to rd_project, only a string experimental_bom_reference',
    `serialized_unit_id` BIGINT COMMENT 'Foreign key linking to inventory.serialized_unit. Business justification: High-value prototypes are serialized for tracking through testing, validation, and field trials. Engineering tracks each prototype units location, test history, and disposition using serial numbers.',
    `actual_build_date` DATE COMMENT 'Date on which the prototype build was actually completed. Compared against planned build date to measure schedule adherence and identify R&D execution delays.. Valid values are `^d{4}-d{2}-d{2}$`',
    `actual_test_completion_date` DATE COMMENT 'Date on which all prototype testing activities were actually completed. Used to calculate test cycle time and assess R&D schedule performance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `actual_test_start_date` DATE COMMENT 'Date on which prototype testing activities actually commenced. Used to measure schedule variance and support R&D project performance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `build_cost_amount` DECIMAL(18,2) COMMENT 'Total actual cost incurred to build this prototype, including materials, labor, and overhead. Used for R&D budget tracking, CAPEX/OPEX reporting, and cost-of-innovation analytics.',
    `build_cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the build cost amount (e.g., USD, EUR, CNY). Supports multi-currency R&D financial reporting across global operations.. Valid values are `^[A-Z]{3}$`',
    `build_location` STRING COMMENT 'Physical or virtual location where the prototype was or is being built, such as a specific R&D lab, pilot plant, or simulation environment. Supports resource planning and traceability.',
    `build_site_country` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the prototype is physically built or hosted. Supports multinational R&D portfolio management, export control compliance, and regulatory reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the prototype record was first created in the system. Supports audit trail requirements and data lineage tracking in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `dfmea_reference` STRING COMMENT 'Document number or identifier of the Design Failure Mode and Effects Analysis (DFMEA) associated with this prototype. Ensures risk analysis is linked to the prototype for traceability and stage-gate compliance.',
    `dimensions_mm` STRING COMMENT 'Overall envelope dimensions of the prototype expressed as Length x Width x Height in millimeters (e.g., 450.0x300.0x200.0). Used for lab space planning, packaging, and comparison against design envelope targets.. Valid values are `^d+(.d+)?xd+(.d+)?xd+(.d+)?$`',
    `disposition` STRING COMMENT 'Planned or executed end-of-life action for the prototype after testing is complete. Determines whether the physical or virtual prototype is retained for reference, subjected to further testing, destroyed, or transferred to the engineering domain for design validation.. Valid values are `retain|test|destroy|transfer_to_engineering|archive|donate`',
    `experimental_bom_reference` STRING COMMENT 'Reference identifier for the experimental Bill of Materials (BOM) associated with this prototype. Tracks the specific component configuration used in the R&D build, distinct from the released engineering BOM.',
    `external_partner_involved` BOOLEAN COMMENT 'Indicates whether an external research partner (university, contract research organization, supplier, or consortium) is involved in the development or testing of this prototype. Triggers NDA and IP agreement tracking requirements.. Valid values are `true|false`',
    `external_partner_name` STRING COMMENT 'Name of the external organization (university, research institute, contract manufacturer, or technology partner) collaborating on this prototype. Populated when external_partner_involved is True.',
    `generation_number` STRING COMMENT 'Sequential generation counter indicating the major design generation of the prototype (e.g., Gen 1, Gen 2). Increments when a fundamentally new design approach is adopted, distinct from iteration number which tracks minor revisions within a generation.. Valid values are `^[1-9][0-9]*$`',
    `ip_classification` STRING COMMENT 'Intellectual property status of the technology embodied in this prototype. Drives IP protection strategy, patent filing decisions, and collaboration agreements with external research partners.. Valid values are `proprietary|patent_pending|patented|trade_secret|open_source|licensed|unclassified`',
    `is_virtual` BOOLEAN COMMENT 'Indicates whether the prototype is a virtual/simulation-based prototype (True) or a physical hardware prototype (False). Virtual prototypes include CAD simulations, digital models, and software emulations.. Valid values are `true|false`',
    `iteration_number` STRING COMMENT 'Sequential iteration counter within a generation, tracking incremental design revisions and build cycles. Used to distinguish successive builds of the same generation (e.g., Gen 2, Iteration 3).. Valid values are `^[1-9][0-9]*$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the prototype record. Used for change tracking, data freshness monitoring, and audit compliance in the Silver Layer lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `name` STRING COMMENT 'Descriptive short name for the prototype, typically referencing the target product concept or technology area (e.g., Gen-2 Motor Controller PoC, Smart Grid Node Alpha). Used in reports and dashboards.',
    `number` STRING COMMENT 'Human-readable business identifier for the prototype, used in engineering documents, lab notebooks, and cross-functional communications. Follows the enterprise prototype numbering convention (e.g., PRO-AUTO-000123).. Valid values are `^PRO-[A-Z0-9]{4}-[0-9]{6}$`',
    `patent_application_number` STRING COMMENT 'Official patent application number filed with a patent authority for the technology embodied in this prototype. Populated when ip_classification is patent_pending or patented.',
    `planned_build_date` DATE COMMENT 'Target date by which the prototype build is scheduled to be completed. Used for R&D project scheduling, resource allocation, and milestone tracking in the stage-gate process.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_test_completion_date` DATE COMMENT 'Target date by which all prototype testing activities are expected to be completed. Drives stage-gate review scheduling and downstream design release planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_test_start_date` DATE COMMENT 'Scheduled date for commencement of prototype testing activities. Supports test lab scheduling, resource planning, and stage-gate milestone management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `quantity_built` STRING COMMENT 'Number of physical units built for this prototype iteration. Relevant for pre-production pilots and engineering prototypes where multiple units are required for parallel testing or distribution to test sites.. Valid values are `^[0-9]+$`',
    `regulatory_compliance_scope` STRING COMMENT 'Comma-separated list of applicable regulatory frameworks or certifications that this prototype must be validated against (e.g., CE Marking, UL, RoHS, REACH, IEC 62443). Guides test planning and documentation requirements.',
    `safety_review_status` STRING COMMENT 'Status of the formal safety review for this prototype, required before physical testing commences. Aligns with ISO 45001 occupational health and safety obligations and internal permit-to-work processes.. Valid values are `not_required|pending|in_review|approved|rejected`',
    `source_system` STRING COMMENT 'Operational system of record from which this prototype record originated (e.g., Siemens Teamcenter PLM, Siemens Opcenter MES). Supports data lineage, reconciliation, and Silver Layer ingestion traceability.. Valid values are `teamcenter_plm|opcenter_mes|sap_s4hana|mindsphere|manual|other`',
    `stage_gate_phase` STRING COMMENT 'The R&D stage-gate phase during which this prototype was created or is being evaluated. Aligns with the enterprise innovation pipeline phases and APQP planning milestones.. Valid values are `ideation|concept|feasibility|development|validation|launch_readiness`',
    `status` STRING COMMENT 'Current lifecycle status of the prototype, tracking its progression from planning through build, testing, and final disposition. Drives workflow routing in stage-gate and APQP processes.. Valid values are `planned|in_build|build_complete|under_test|test_complete|on_hold|cancelled|disposed`',
    `storage_location` STRING COMMENT 'Physical storage location identifier (e.g., lab room, shelf, cage, or warehouse bin) where the prototype is currently stored. Supports physical asset tracking and retrieval for ongoing or future testing.',
    `target_spec_reference` STRING COMMENT 'Document number or identifier of the target product specification or design requirement document that this prototype is built to validate. Links the prototype to its governing requirements baseline.',
    `technology_domain` STRING COMMENT 'Primary technology area that the prototype addresses, aligned with the companys core innovation pillars: automation systems, electrification solutions, and smart infrastructure components.. Valid values are `automation|electrification|smart_infrastructure|robotics|power_electronics|connectivity|sensing|software|other`',
    `test_outcome` STRING COMMENT 'Overall result of the prototype testing phase, indicating whether the prototype met its target specifications. Drives disposition decisions and stage-gate advancement approvals.. Valid values are `pass|fail|partial_pass|inconclusive|pending`',
    `test_report_reference` STRING COMMENT 'Document number or identifier of the formal test report documenting prototype test results, observations, and conclusions. Provides traceability to the detailed test evidence.',
    `type` STRING COMMENT 'Classification of the prototype by its development maturity and purpose. Proof-of-concept validates feasibility; engineering prototype validates design; pre-production pilot validates manufacturing readiness. Aligns with APQP stage-gate definitions.. Valid values are `proof_of_concept|engineering_prototype|pre_production_pilot|virtual_simulation|breadboard|alpha|beta`',
    `weight_kg` DECIMAL(18,2) COMMENT 'Physical weight of the prototype in kilograms. Used for logistics planning, lab handling safety assessments, and comparison against target product weight specifications.',
    CONSTRAINT pk_research_prototype PRIMARY KEY(`research_prototype_id`)
) COMMENT 'Master record for physical and virtual prototypes developed during R&D projects for automation systems, electrification solutions, and smart infrastructure components. Captures prototype identifier, generation/iteration number, prototype type (proof-of-concept, engineering prototype, pre-production pilot), associated R&D project, build status, target specification reference, and disposition (test, destroy, retain). Distinct from engineering.prototype which is owned by the engineering domain for design validation; this record tracks R&D-phase experimental prototypes prior to formal design release.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`experimental_bom` (
    `experimental_bom_id` BIGINT COMMENT 'Unique system-generated identifier for the experimental Bill of Materials record. Serves as the primary key for the experimental_bom entity within the R&D domain.',
    `chemical_substance_id` BIGINT COMMENT 'Foreign key linking to hse.chemical_substance. Business justification: Experimental BOMs specify chemical substances used in prototypes. HSE maintains master chemical registry with hazard classifications, exposure limits, and handling requirements that R&D must reference',
    `compliance_reach_substance_declaration_id` BIGINT COMMENT 'Foreign key linking to compliance.reach_substance_declaration. Business justification: Experimental BOMs must declare REACH substances (SVHCs) in materials for EU market compliance. Materials engineering tracks REACH declarations during design phase to avoid costly redesigns after produ',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: An experimental BOM belongs to an R&D project. The experimental_bom has a project_code string attribute that is a denormalized reference to rd_project. Adding rd_project_id as a proper FK normalizes t',
    `research_prototype_id` BIGINT COMMENT 'Foreign key linking to research.prototype. Business justification: An experimental BOM defines the component structure of a specific prototype. experimental_bom has prototype_number (string) as a denormalized reference. Adding prototype_id as a proper FK normalizes t',
    `engineering_bom_id` BIGINT COMMENT 'The native BOM identifier from the originating system of record (e.g., Teamcenter BOM ID or SAP BOM number). Enables traceability back to the source system for reconciliation and audit purposes.',
    `apqp_phase` STRING COMMENT 'The specific Advanced Product Quality Planning (APQP) phase associated with this experimental BOM. Indicates the maturity level of the design and the corresponding quality planning activities required.. Valid values are `phase_1_plan_define|phase_2_product_design|phase_3_process_design|phase_4_product_validation|phase_5_launch`',
    `bom_number` STRING COMMENT 'Human-readable business identifier for the experimental BOM, used for cross-system reference and communication with R&D teams. Follows the EBOM numbering convention distinct from released production BOM numbers.. Valid values are `^EBOM-[A-Z0-9]{4,20}$`',
    `bom_type` STRING COMMENT 'Classification of the experimental BOM by its R&D lifecycle stage. prototype is for physical build experiments; pre_production is for near-release assemblies; feasibility is for early-stage concept evaluation; concept is for ideation-phase structures; validation is for design verification and validation builds.. Valid values are `prototype|pre_production|feasibility|concept|validation`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the R&D site or facility where this experimental BOM is being developed or prototyped. Supports multi-national R&D portfolio management and regulatory compliance tracking.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time when the experimental BOM record was first created in the system of record. Used for audit trail, lifecycle tracking, and R&D project timeline analysis.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the estimated material cost is expressed (e.g., USD, EUR, GBP). Supports multi-currency operations across global R&D sites.. Valid values are `^[A-Z]{3}$`',
    `design_maturity_level` STRING COMMENT 'NASA/EU-aligned Technology Readiness Level (TRL) score indicating the maturity of the technology or design captured in this experimental BOM, from TRL1 (basic principles observed) to TRL9 (system proven in operational environment). Used for R&D portfolio management and stage-gate decisions.. Valid values are `TRL1|TRL2|TRL3|TRL4|TRL5|TRL6|TRL7|TRL8|TRL9`',
    `ecn_reference` STRING COMMENT 'Reference to the Engineering Change Notice (ECN) or Engineering Change Order (ECO) that formally released or superseded this experimental BOM. Populated when the experimental BOM transitions to a released production BOM in engineering.bom.',
    `estimated_material_cost` DECIMAL(18,2) COMMENT 'Total estimated cost of all materials and components listed in this experimental BOM, expressed in the BOM currency. Used for R&D budget tracking, cost feasibility analysis, and comparison against target cost objectives during prototype development.',
    `external_partner_code` STRING COMMENT 'Identifier of the external research partner, university, or contract R&D organization collaborating on this experimental BOM. Relevant for joint development agreements and IP ownership tracking.',
    `frozen_date` DATE COMMENT 'The date on which the experimental BOM was frozen, locking the component structure for a specific prototype build or test event. A frozen BOM cannot be modified without a formal change process, supporting traceability of prototype builds.. Valid values are `^d{4}-d{2}-d{2}$`',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether any component or material in this experimental BOM is classified as hazardous under applicable regulations (e.g., REACH, RoHS, OSHA HazCom). Triggers additional handling, storage, and disposal requirements during prototype development.. Valid values are `true|false`',
    `ip_classification` STRING COMMENT 'Classification of the intellectual property status of the experimental BOM content. Indicates whether the design is proprietary, jointly developed with a partner, based on licensed-in technology, open source, or public domain. Critical for IP management and commercialization decisions.. Valid values are `proprietary|joint_development|licensed_in|open_source|public_domain`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent modification to the experimental BOM record. Supports change tracking, audit compliance, and incremental data loading in the lakehouse Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `line_count` STRING COMMENT 'Total number of component or material line items included in this experimental BOM. Provides a quick indicator of BOM complexity and completeness for review and approval workflows.',
    `notes` STRING COMMENT 'Free-text field for capturing additional context, assumptions, constraints, or experimental observations related to this BOM, such as material substitution rationale, test conditions, or design trade-off notes recorded by the R&D team.',
    `owning_department` STRING COMMENT 'The R&D or engineering department responsible for this experimental BOM, such as Automation R&D, Electrification Engineering, or Smart Infrastructure Lab. Supports organizational reporting and resource allocation.',
    `parent_assembly_number` STRING COMMENT 'Identifier of the top-level or parent assembly that this experimental BOM represents. Used to navigate multi-level BOM hierarchies during prototype development and to trace sub-assembly relationships.',
    `patent_reference` STRING COMMENT 'Reference to any patent application or granted patent number associated with the technology or design captured in this experimental BOM. Supports intellectual property management and freedom-to-operate analysis.',
    `plant_code` STRING COMMENT 'SAP plant code identifying the manufacturing or R&D facility where the prototype assembly is being built or tested. Determines plant-specific material availability and costing.',
    `product_line` STRING COMMENT 'The product line or technology family that this experimental BOM belongs to, such as Automation Systems, Electrification Solutions, or Smart Infrastructure Components. Supports portfolio segmentation and R&D investment reporting.',
    `quantity` DECIMAL(18,2) COMMENT 'The base quantity of the top-level assembly that this experimental BOM describes. Typically 1 for a single prototype unit but may be greater for batch prototype builds.',
    `regulatory_compliance_flags` STRING COMMENT 'Indicates which regulatory compliance frameworks are applicable to the materials and components in this experimental BOM, such as REACH, RoHS, CE Marking, or UL certification requirements. Supports early-stage compliance planning before formal product release.. Valid values are `reach|rohs|ce_marking|ul|none|multiple`',
    `responsible_engineer` STRING COMMENT 'Name or employee identifier of the lead design or R&D engineer accountable for the accuracy and completeness of this experimental BOM. Used for ownership tracking and review workflow routing.',
    `revision` STRING COMMENT 'Alphanumeric revision level of the experimental BOM indicating the iteration of the prototype or pre-design-release assembly structure. Incremented with each significant change during R&D experimentation prior to formal Engineering Change Notice (ECN) release.. Valid values are `^[A-Z]{1,3}[0-9]{0,3}$`',
    `source_system` STRING COMMENT 'The operational system of record from which this experimental BOM record originated, such as Siemens Teamcenter PLM or SAP S/4HANA. Supports data lineage tracking and reconciliation across the enterprise data lakehouse.. Valid values are `teamcenter|sap_s4hana|opcenter|manual|other`',
    `stage_gate_phase` STRING COMMENT 'The current stage-gate process phase in which this experimental BOM exists. Reflects the APQP-aligned innovation pipeline phase from ideation through launch readiness, governing what level of BOM completeness and review is required.. Valid values are `ideation|concept|feasibility|development|validation|launch_readiness`',
    `status` STRING COMMENT 'Current lifecycle status of the experimental BOM. draft indicates initial authoring; under_review indicates active stage-gate or peer review; frozen indicates the BOM is locked for prototype build or testing; superseded indicates replaced by a newer revision; cancelled indicates the R&D effort was terminated.. Valid values are `draft|under_review|frozen|superseded|cancelled`',
    `target_cost` DECIMAL(18,2) COMMENT 'The design-to-cost target for the experimental BOM, representing the maximum allowable material cost for the prototype assembly to meet product profitability objectives. Compared against estimated_material_cost to assess cost feasibility.',
    `technology_domain` STRING COMMENT 'The primary technology domain that the experimental BOM addresses. Aligns with the companys core innovation pillars: automation, electrification, smart infrastructure, robotics, and digitalization.. Valid values are `automation|electrification|smart_infrastructure|robotics|digitalization|other`',
    `title` STRING COMMENT 'Descriptive title of the experimental BOM identifying the prototype assembly or R&D sub-system being structured, e.g., Electrification Module Prototype Rev A or Smart Sensor Array Pre-Release Assembly.',
    `unit_of_measure` STRING COMMENT 'The unit of measure for the BOM header quantity, such as EA (each), KG (kilogram), M (meter), or ASY (assembly). Follows ISO 80000 and SAP unit of measure conventions.. Valid values are `EA|KG|M|M2|M3|L|SET|PCE|ASY`',
    `valid_from_date` DATE COMMENT 'The date from which this experimental BOM revision is considered valid and applicable for prototype builds or R&D experiments. Supports time-based BOM validity management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `valid_to_date` DATE COMMENT 'The date until which this experimental BOM revision is considered valid. After this date, the BOM is superseded by a newer revision or formally released via ECN/ECO. Supports BOM lifecycle management.. Valid values are `^d{4}-d{2}-d{2}$`',
    CONSTRAINT pk_experimental_bom PRIMARY KEY(`experimental_bom_id`)
) COMMENT 'Experimental Bill of Materials record tracking the component and material structure of R&D prototypes and pre-design-release assemblies. Captures BOM header for an experimental build, revision level, associated prototype or R&D project, BOM status (draft, under review, frozen), and total estimated material cost. Distinct from engineering.bom which is the released production BOM; this entity manages the fluid, iterative BOM used during R&D experimentation before formal ECN/ECO release.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` (
    `experimental_bom_line_id` BIGINT COMMENT 'Unique system-generated identifier for each individual line item within an experimental Bill of Materials (BOM). Serves as the primary key for the experimental_bom_line entity in the research domain.',
    `catalog_item_id` BIGINT COMMENT 'Foreign key linking to product.catalog_item. Business justification: Experimental BOMs reference actual catalog items as components for cost estimation and sourcing feasibility. R&D engineers use existing parts from the catalog to build prototypes and assess manufactur',
    `component_id` BIGINT COMMENT 'Foreign key linking to engineering.component. Business justification: Experimental BOMs reference actual engineering components being tested in new configurations. R&D must use real component specifications and part numbers from engineering master data for material proc',
    `experimental_bom_id` BIGINT COMMENT 'Foreign key linking to research.experimental_bom. Business justification: An experimental BOM line is a child line item that belongs to an experimental BOM header. This is a classic header-line child→parent relationship. experimental_bom_line has no FK to experimental_bom. ',
    `inventory_sku_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Experimental BOMs use actual inventory SKUs as components for testing. R&D must reference real parts from inventory to requisition materials and calculate prototype costs accurately.',
    `procurement_material_info_record_id` BIGINT COMMENT 'Foreign key linking to procurement.material_info_record. Business justification: Experimental BOMs reference material info records to access supplier-specific pricing, lead times, and specifications. R&D uses this for cost estimation and sourcing feasibility during design phases.',
    `approved_manufacturer_name` STRING COMMENT 'Name of the approved or preferred manufacturer for this component. Supports Approved Manufacturer List (AML) management during prototype development and early supplier qualification activities aligned with APQP and PPAP processes.',
    `approved_manufacturer_number` STRING COMMENT 'Manufacturers original part number for this component as listed on the Approved Manufacturer List (AML). Used to cross-reference the internal component number with the manufacturers catalog number for procurement and quality verification.. Valid values are `^[A-Z0-9-]{3,40}$`',
    `bom_change_reason` STRING COMMENT 'Free-text description of the reason for adding, modifying, or removing this line item from the experimental BOM. Supports traceability of iterative design changes during prototype development and links to Engineering Change Notice (ECN) or Engineering Change Order (ECO) processes.',
    `component_type` STRING COMMENT 'Classification of the BOM line item indicating whether it is a raw material, purchased component, sub-assembly, semi-finished good, consumable, tooling item, or phantom assembly. Drives procurement and manufacturing execution logic.. Valid values are `raw_material|purchased_component|sub_assembly|semi_finished|consumable|tooling|phantom`',
    `cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the unit cost estimate on this BOM line (e.g., USD, EUR, GBP). Supports multi-currency cost tracking for multinational R&D programs.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when this experimental BOM line record was first created in the system. Provides audit trail for BOM line creation events and supports data lineage tracking in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `ecn_reference` STRING COMMENT 'Reference number of the Engineering Change Notice (ECN) or Engineering Change Order (ECO) that authorized the addition or modification of this experimental BOM line. Provides formal change traceability in the PLM system.. Valid values are `^[A-Z0-9-]{3,30}$`',
    `effective_from_date` DATE COMMENT 'Date from which this experimental BOM line item becomes effective and applicable to the prototype build. Supports date-effective BOM management for iterative design changes during R&D development cycles.. Valid values are `^d{4}-d{2}-d{2}$`',
    `effective_to_date` DATE COMMENT 'Date on which this experimental BOM line item expires or is superseded. Used to manage date-effective BOM versioning during iterative prototype development. A null value indicates the line is currently active with no defined end date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `find_number` STRING COMMENT 'Balloon or find number referencing the components position on an engineering drawing or assembly diagram. Used to cross-reference BOM line items with visual assembly documentation in Teamcenter PLM and CAD drawings.. Valid values are `^[0-9]{1,6}$`',
    `hazardous_material_flag` BOOLEAN COMMENT 'Indicates whether this component contains hazardous substances subject to regulatory compliance requirements such as RoHS, REACH, or OSHA Hazard Communication Standards. Triggers mandatory safety data sheet (SDS) review and handling controls.. Valid values are `true|false`',
    `is_critical_component` BOOLEAN COMMENT 'Indicates whether this component is designated as critical to the prototypes form, fit, or function. Critical components receive heightened scrutiny during Design Failure Mode and Effects Analysis (DFMEA), First Article Inspection (FAI), and APQP stage-gate reviews.. Valid values are `true|false`',
    `is_long_lead_item` BOOLEAN COMMENT 'Indicates whether this component has an extended procurement lead time that requires early purchasing action to meet prototype build schedules. Long lead items are flagged for priority procurement planning in R&D project timelines.. Valid values are `true|false`',
    `is_substitute` BOOLEAN COMMENT 'Indicates whether this BOM line item is a substitute component replacing the originally specified part. When True, the substitute_for_component_number field identifies the original component being replaced during prototype development.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this experimental BOM line record. Supports change tracking, audit compliance, and incremental data loading in the Databricks Silver Layer lakehouse architecture.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `lead_time_days` STRING COMMENT 'Estimated procurement or manufacturing lead time in calendar days for this component. Used in R&D prototype scheduling and Materials Requirements Planning (MRP) to determine earliest availability for prototype builds.. Valid values are `^[0-9]{1,4}$`',
    `line_notes` STRING COMMENT 'Free-text engineering or procurement notes specific to this BOM line item. May include special handling instructions, testing requirements, supplier qualification notes, or design intent commentary relevant to the prototype build.',
    `line_number` STRING COMMENT 'Sequential position number of this component line within the experimental BOM. Used to order and reference individual line items during prototype build and iterative BOM revision cycles.. Valid values are `^[0-9]{1,6}$`',
    `line_status` STRING COMMENT 'Current lifecycle status of the experimental BOM line item. Tracks progression from initial draft through review, approval, and potential supersession during iterative prototype development cycles without impacting released production BOMs.. Valid values are `draft|active|under_review|approved|superseded|cancelled`',
    `make_or_buy` STRING COMMENT 'Indicates whether the component is manufactured in-house (make), procured from an external supplier (buy), or can be either depending on capacity and availability. Drives procurement and production planning decisions for prototype builds.. Valid values are `make|buy|either`',
    `material_spec_reference` STRING COMMENT 'Reference identifier linking this BOM line to the applicable material specification, engineering drawing, or technical standard document that defines the material requirements for the component. Typically references a Teamcenter document number or SAP document info record.',
    `preferred_supplier_name` STRING COMMENT 'Name of the preferred or approved supplier for this component during the experimental prototype phase. May differ from the production-approved supplier. Supports early-stage sourcing decisions and supplier qualification activities.',
    `prototype_build_quantity` DECIMAL(18,2) COMMENT 'Total quantity of this component required for the specific prototype build run, accounting for the number of prototype units being built and the quantity per assembly. Used for prototype material requisition and procurement.. Valid values are `^[0-9]{1,12}(.[0-9]{1,6})?$`',
    `quantity` DECIMAL(18,2) COMMENT 'Required quantity of the component or material for one unit of the experimental prototype assembly. Supports up to six decimal places to accommodate precise engineering quantities for R&D builds.. Valid values are `^[0-9]{1,12}(.[0-9]{1,6})?$`',
    `quantity_per_assembly` DECIMAL(18,2) COMMENT 'Number of units of this component required per single assembly of the parent experimental prototype. Distinct from total quantity ordered; used for BOM explosion and prototype build planning calculations.. Valid values are `^[0-9]{1,12}(.[0-9]{1,6})?$`',
    `reach_compliant` BOOLEAN COMMENT 'Indicates whether this component complies with the EU REACH regulation governing the registration, evaluation, authorization, and restriction of chemical substances. Critical for electrification and automation product compliance.. Valid values are `true|false`',
    `reference_designator` STRING COMMENT 'Engineering reference designator identifying the specific location or instance of this component within the prototype assembly or schematic (e.g., R1, C12, U5 for electronic assemblies). Used in CAD/CAM and PCB design documentation.',
    `revision_level` STRING COMMENT 'Engineering revision level or version of the component specification applicable to this BOM line. Tracks iterative design changes during prototype development cycles and aligns with the Engineering Change Notice (ECN) process.. Valid values are `^[A-Z0-9]{1,5}$`',
    `rohs_compliant` BOOLEAN COMMENT 'Indicates whether this component complies with the EU Restriction of Hazardous Substances (RoHS) Directive, restricting the use of specific hazardous materials in electrical and electronic equipment. Required for CE Marking compliance.. Valid values are `true|false`',
    `scrap_factor_percent` DECIMAL(18,2) COMMENT 'Expected scrap or yield loss percentage for this component during prototype manufacturing. Applied to the base quantity to calculate the total required quantity including anticipated waste. Supports accurate prototype material planning.. Valid values are `^[0-9]{1,3}(.[0-9]{1,4})?$`',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this experimental BOM line record originated (e.g., Siemens Teamcenter PLM, SAP S/4HANA). Supports data lineage, reconciliation, and Silver Layer ingestion traceability.. Valid values are `teamcenter|sap_s4hana|opcenter|manual`',
    `sourcing_status` STRING COMMENT 'Current procurement and availability status of the component for the experimental prototype build. Indicates whether the item is available in inventory, needs to be sourced, has an approved substitute, or is on order. Supports R&D procurement planning.. Valid values are `available|to_be_sourced|substitute|on_order|in_stock|obsolete|under_evaluation`',
    `stage_gate_phase` STRING COMMENT 'Advanced Product Quality Planning (APQP) stage-gate phase during which this BOM line was introduced or is applicable. Tracks the maturity of component selection across the R&D development lifecycle from concept through production release.. Valid values are `concept|feasibility|design|prototype|validation|pilot|release`',
    `substitute_for_component_number` STRING COMMENT 'Component number of the original part that this line item is substituting. Populated only when is_substitute is True. Enables traceability of substitution decisions during iterative prototype development and supports APQP documentation.. Valid values are `^[A-Z0-9-]{3,40}$`',
    `unit_cost_estimate` DECIMAL(18,2) COMMENT 'Estimated cost per unit of the component for this experimental BOM line. Used for R&D prototype cost estimation and budget tracking. Represents a line-level cost estimate and does not reflect final production costing.. Valid values are `^[0-9]{1,14}(.[0-9]{1,4})?$`',
    `unit_of_measure` STRING COMMENT 'Standard unit of measure for the component quantity on this BOM line (e.g., EA for each, KG for kilogram, M for meter). Aligned with ISO 80000 international units and SAP S/4HANA base unit of measure configuration.. Valid values are `EA|KG|G|LB|M|MM|CM|L|ML|M2|M3|PC|SET|LOT|HR|MIN`',
    CONSTRAINT pk_experimental_bom_line PRIMARY KEY(`experimental_bom_line_id`)
) COMMENT 'Individual line-item within an experimental BOM defining each component, raw material, or sub-assembly used in an R&D prototype build. Captures component description, quantity, unit of measure, material specification reference, substitution flag, sourcing status (available, to-be-sourced, substitute), and line-level cost estimate. Supports iterative BOM changes during prototype development cycles without impacting released production BOMs.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`rd_test_plan` (
    `rd_test_plan_id` BIGINT COMMENT 'Unique system-generated identifier for the R&D test and validation plan record. Serves as the primary key for all downstream references to this test plan.',
    `application_id` BIGINT COMMENT 'Foreign key linking to technology.application. Business justification: R&D test plans specify which software applications (CAD, simulation, PLM, testing software) are required to execute the test protocol. Lab technicians need this to prepare test environments.',
    `employee_id` BIGINT COMMENT 'Enterprise employee identifier of the lead test engineer responsible for this test plan. Used for system-level assignment and integration with workforce management systems.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Test plans specify which production equipment will be used for validation testing. Quality and R&D departments must reserve and reference actual manufacturing equipment for testing new designs and pro',
    `fmea_id` BIGINT COMMENT 'Foreign key linking to quality.fmea. Business justification: R&D test plans are designed to validate high-risk failure modes identified in DFMEA. Test engineers use FMEA to prioritize testing on critical characteristics with high RPN scores.',
    `inventory_sku_id` BIGINT COMMENT 'Foreign key linking to inventory.sku. Business justification: Test plans validate specific prototype SKUs before production release. Quality and R&D teams link test protocols to SKUs for compliance documentation and production readiness gates.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: A test and validation plan is defined for an R&D project. This is a child→parent relationship. rd_test_plan has no FK to rd_project. Adding rd_project_id establishes the authoritative project ownershi',
    `research_prototype_id` BIGINT COMMENT 'Foreign key linking to research.prototype. Business justification: A test plan is defined for a specific prototype under test. rd_test_plan has prototype_identifier (string) as a denormalized reference. Adding prototype_id as a proper FK normalizes this relationship ',
    `safety_audit_id` BIGINT COMMENT 'Foreign key linking to hse.safety_audit. Business justification: R&D test plans involving hazardous materials, high-voltage equipment, or novel processes require safety audit approval. HSE audits lab procedures before experimental work begins to ensure regulatory c',
    `work_center_id` BIGINT COMMENT 'Foreign key linking to production.work_center. Business justification: R&D test plans execute at production work centers to validate process capability and equipment compatibility. Process engineers schedule testing on actual manufacturing equipment before full productio',
    `acceptance_criteria` STRING COMMENT 'Formal pass/fail criteria that must be satisfied for the test plan to be considered successfully completed. Includes quantitative thresholds, performance benchmarks, and regulatory compliance requirements.',
    `actual_end_date` DATE COMMENT 'The date on which all test activities in this plan were completed. Used for schedule variance analysis, design handoff readiness, and R&D portfolio reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `actual_start_date` DATE COMMENT 'The date on which test plan execution actually commenced. Compared against planned_start_date to measure schedule adherence and identify delays in the R&D validation pipeline.. Valid values are `^d{4}-d{2}-d{2}$`',
    `applicable_standards` STRING COMMENT 'Comma-separated list of regulatory and technical standards governing this test plan (e.g., IEC 61131-3, UL 508A, CE Marking Directive, RoHS 2011/65/EU, REACH Regulation EC 1907/2006, ISO 9001). Drives acceptance criteria and test methodology selection.',
    `approved_date` DATE COMMENT 'The date on which the test plan was formally approved by the designated authority. Required for audit trail, regulatory compliance documentation, and stage-gate records.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approver_name` STRING COMMENT 'Full name of the authorized individual (e.g., R&D Manager, Chief Engineer) who formally approved this test plan for execution. Required for stage-gate and APQP compliance documentation.',
    `apqp_phase` STRING COMMENT 'The APQP phase during which this test plan is executed. Aligns test activities with the five APQP phases to ensure structured quality planning from concept through production launch.. Valid values are `plan_and_define|product_design_and_development|process_design_and_development|product_and_process_validation|launch_feedback_and_corrective_action`',
    `budget_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the test plan budget amount (e.g., USD, EUR, GBP). Supports multi-currency R&D financial reporting across global operations.. Valid values are `^[A-Z]{3}$`',
    `calibration_required` BOOLEAN COMMENT 'Indicates whether the test equipment used in this plan requires calibration certification prior to test execution. Supports compliance with ISO/IEC 17025 and ISO 9001 measurement traceability requirements.. Valid values are `true|false`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when the test plan record was first created in the data platform. Supports audit trail, data lineage, and compliance documentation requirements.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `design_handoff_cleared` BOOLEAN COMMENT 'Indicates whether this test plan has been successfully completed and the design has been formally cleared for handoff to production engineering or the next development phase. Set to true only when all acceptance criteria are met.. Valid values are `true|false`',
    `external_partner_involved` BOOLEAN COMMENT 'Indicates whether an external research partner, contract test laboratory, or third-party organization is involved in executing this test plan. Triggers additional NDA, IP protection, and supplier qualification workflows.. Valid values are `true|false`',
    `external_partner_name` STRING COMMENT 'Name of the external organization (contract lab, university, research institute, or third-party test house) collaborating on this test plan. Populated only when external_partner_involved is true.',
    `ip_classification` STRING COMMENT 'Intellectual property classification of the technology or innovation being validated by this test plan. Governs information sharing, external partner access, and publication restrictions.. Valid values are `proprietary|trade_secret|patent_pending|patented|open_source|confidential|public`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp recording the most recent update to the test plan record. Used for change tracking, version control, and data freshness monitoring in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `number_of_test_cases` STRING COMMENT 'Total count of individual test cases or test procedures defined within this test plan. Used for workload estimation, resource planning, and test execution progress tracking.. Valid values are `^[0-9]+$`',
    `plan_number` STRING COMMENT 'Human-readable, business-assigned unique identifier for the test plan, used for cross-referencing in documents, stage-gate reviews, and APQP packages. Follows the enterprise test plan numbering convention.. Valid values are `^TP-[A-Z0-9]{4}-[0-9]{6}$`',
    `planned_end_date` DATE COMMENT 'The scheduled completion date for all test activities defined in this plan. Used for project timeline management, design handoff scheduling, and stage-gate readiness assessment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `planned_start_date` DATE COMMENT 'The scheduled start date for test plan execution as defined during planning. Used for resource scheduling, milestone tracking, and variance analysis against actual execution.. Valid values are `^d{4}-d{2}-d{2}$`',
    `regulatory_compliance_scope` STRING COMMENT 'Comma-separated list of regulatory compliance frameworks that this test plan is designed to satisfy (e.g., CE Marking, UL 508A, RoHS, REACH, IEC 62443, OSHA 1910). Drives test methodology and documentation requirements.',
    `required_test_equipment` STRING COMMENT 'Comma-separated list of test equipment, instruments, and facilities required to execute this test plan (e.g., environmental chamber, oscilloscope, EMC test cell, vibration table, calibrated torque wrench). Supports resource planning and calibration scheduling.',
    `responsible_engineer` STRING COMMENT 'Full name of the lead test engineer accountable for planning, executing, and reporting on this test plan. Used for assignment tracking, workload management, and audit trail purposes.',
    `risk_level` STRING COMMENT 'Assessed risk level of the test plan based on the complexity of the technology under test, regulatory exposure, and potential impact of test failure on the product development timeline. Derived from DFMEA/PFMEA risk assessments.. Valid values are `low|medium|high|critical`',
    `scope_description` STRING COMMENT 'Detailed narrative describing the boundaries, objectives, and inclusions/exclusions of the test plan. Defines what systems, subsystems, components, or functions are within scope for validation.',
    `stage_gate` STRING COMMENT 'The stage-gate checkpoint in the product development process to which this test plan is aligned. Supports APQP and structured R&D portfolio management by linking validation activities to formal go/no-go decision points.. Valid values are `gate_0|gate_1|gate_2|gate_3|gate_4|gate_5`',
    `status` STRING COMMENT 'Current lifecycle status of the test plan, from initial drafting through approval, active execution, and final completion or cancellation.. Valid values are `draft|under_review|approved|active|on_hold|completed|cancelled`',
    `technology_domain` STRING COMMENT 'The primary technology domain to which this test plan belongs, aligned with the companys core product lines: automation systems, electrification solutions, smart infrastructure, transportation, or building systems.. Valid values are `automation|electrification|smart_infrastructure|transportation|building_systems|industrial_iot|robotics|power_electronics|other`',
    `test_budget_amount` DECIMAL(18,2) COMMENT 'Approved budget allocated for executing this test plan, covering equipment usage, external lab fees, materials, and personnel costs. Used for R&D OPEX tracking and project financial management.',
    `test_location_country` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the test is being conducted. Supports multi-country R&D operations, regulatory jurisdiction determination, and export control compliance.. Valid values are `^[A-Z]{3}$`',
    `test_phase` STRING COMMENT 'Indicates the execution phase of the test plan: laboratory (controlled bench testing), environmental (temperature, humidity, vibration chambers), field (real-world deployment), pilot, or production validation.. Valid values are `lab|environmental|field|pilot|production_validation`',
    `test_result_summary` STRING COMMENT 'Overall outcome of the test plan execution, summarizing whether the prototype or system under test met all acceptance criteria. Drives design handoff decisions and stage-gate go/no-go outcomes.. Valid values are `pass|fail|partial_pass|inconclusive|not_yet_executed`',
    `test_type` STRING COMMENT 'Classification of the test plan by its primary purpose, distinguishing between design verification (DV), design validation (DVP), environmental stress, safety, regulatory compliance, or field trial testing.. Valid values are `design_verification|design_validation|prototype_testing|environmental|performance|safety|compliance|field_trial|accelerated_life`',
    `title` STRING COMMENT 'Descriptive title of the test and validation plan, summarizing the technology, prototype, or system under test (e.g., Electrification Module EMC Validation Plan v2).',
    `version` STRING COMMENT 'Version number of the test plan document, incremented upon each approved revision. Supports traceability of changes through the design and validation lifecycle.. Valid values are `^[0-9]+.[0-9]+$`',
    CONSTRAINT pk_rd_test_plan PRIMARY KEY(`rd_test_plan_id`)
) COMMENT 'Master record defining the formal test and validation plan for an R&D project or prototype. Captures test plan title, test scope, applicable standards (IEC 61131, UL, CE, RoHS/REACH), test phases (lab, environmental, field), acceptance criteria, required test equipment, responsible test engineer, and planned vs. actual test schedule. Supports structured validation of automation, electrification, and smart infrastructure technologies prior to design handoff.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`rd_test_result` (
    `rd_test_result_id` BIGINT COMMENT 'Unique system-generated identifier for each individual test result record within the R&D test execution repository.',
    `characteristic_id` BIGINT COMMENT 'Foreign key linking to quality.quality_characteristic. Business justification: R&D test results measure specific quality characteristics defined by quality engineering. Test engineers reference quality characteristics to ensure prototype testing aligns with production control re',
    `design_validation_test_id` BIGINT COMMENT 'Foreign key linking to engineering.design_validation_test. Business justification: R&D test results feed into formal engineering design validation tests (DVT). Engineering uses R&D test data to validate designs meet specifications before production release and regulatory certificati',
    `employee_id` BIGINT COMMENT 'Employee identifier of the engineer or quality authority who reviewed and approved the test result record. Required for four-eyes principle compliance and regulatory audit trails.',
    `field_service_order_id` BIGINT COMMENT 'Foreign key linking to service.field_service_order. Business justification: Field testing of prototypes and new technologies requires service orders to coordinate technician dispatch, equipment access, and on-site test execution. Common in industrial equipment validation.',
    `product_regulatory_certification_id` BIGINT COMMENT 'Foreign key linking to product.regulatory_certification. Business justification: Test results support regulatory certification applications. Quality and compliance teams link test data to specific certifications (UL, CE, ISO) for submission packages and audit evidence.',
    `rd_test_plan_id` BIGINT COMMENT 'Foreign key linking to research.rd_test_plan. Business justification: An R&D test result is the outcome of a test execution performed against a test plan. rd_test_result has test_plan_number (string) as a denormalized reference. Adding rd_test_plan_id as a proper FK nor',
    `research_prototype_id` BIGINT COMMENT 'Identifier of the specific prototype, sample, or test article subjected to this test execution. Enables traceability of results to a physical or virtual test specimen.',
    `rohs_compliance_record_id` BIGINT COMMENT 'Foreign key linking to compliance.rohs_compliance_record. Business justification: R&D testing includes RoHS material composition analysis for prototypes. Test results directly link to RoHS compliance records showing restricted substance levels, required for product launch approval ',
    `case_id` BIGINT COMMENT 'Business identifier referencing the specific test case definition from the test plan that this result is associated with. Enables traceability from result back to the test specification.. Valid values are `^TC-[A-Z0-9]{4,20}$`',
    `test_engineer_employee_id` BIGINT COMMENT 'Employee identifier of the R&D engineer responsible for executing the test. Required for accountability, competency verification, and regulatory traceability.',
    `equipment_id` BIGINT COMMENT 'Identifier of the primary measurement or test equipment used during the test execution. Required for measurement system analysis (MSA), calibration traceability, and equipment qualification records.',
    `calibration_certificate_number` STRING COMMENT 'Certificate number of the calibration record for the test equipment used. Ensures measurement traceability to national or international standards as required by ISO/IEC 17025.',
    `comments` STRING COMMENT 'Free-text field for additional observations, anomalies, or contextual notes recorded by the test engineer during or after test execution. Supplements structured fields with qualitative engineering judgment.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the facility or laboratory where the test was conducted. Supports multi-site, multinational R&D operations reporting and regulatory jurisdiction tracking.. Valid values are `^[A-Z]{3}$`',
    `deviation_from_nominal` DECIMAL(18,2) COMMENT 'Calculated difference between the measured value and the nominal target value. Provides a direct quantitative indicator of how far the result deviates from the design intent, supporting FMEA and CAPA analysis.',
    `disposition` STRING COMMENT 'Recommended disposition action for the test article based on the test outcome. Drives downstream decisions on prototype advancement, rework, or rejection within the stage-gate process.. Valid values are `accept|reject|use_as_is|rework|scrap|return_to_supplier|hold_for_review|deviate`',
    `disposition_rationale` STRING COMMENT 'Narrative justification for the disposition recommendation, particularly required for use-as-is or deviate dispositions. Provides the engineering basis for accepting non-conforming results.',
    `failure_description` STRING COMMENT 'Detailed narrative description of the observed failure, anomaly, or non-conformance identified during the test. Provides the evidentiary basis for NCR initiation and CAPA activities.',
    `failure_mode` STRING COMMENT 'Categorized description of the manner in which the test item failed to meet acceptance criteria. Aligned with FMEA failure mode taxonomy to support root cause analysis and corrective action.',
    `lower_acceptance_limit` DECIMAL(18,2) COMMENT 'Minimum acceptable value for the measured parameter as defined in the test specification or acceptance criteria. Used for pass/fail determination and process capability analysis.',
    `measured_value` DECIMAL(18,2) COMMENT 'The primary quantitative measurement recorded during the test execution. Represents the actual observed value of the parameter under test, used for pass/fail determination and statistical analysis.',
    `ncr_number` STRING COMMENT 'Reference number of the Non-Conformance Report (NCR) raised as a result of a test failure. Links the test result to the formal quality management corrective action process.',
    `nominal_value` DECIMAL(18,2) COMMENT 'The ideal or target value for the measured parameter as specified in the design or test plan. Used to calculate deviation and assess centering of the process relative to the target.',
    `project_code` STRING COMMENT 'Identifier of the R&D project under which this test was conducted. Supports portfolio-level aggregation of test outcomes and stage-gate reporting.. Valid values are `^RD-[A-Z0-9]{4,20}$`',
    `result_status` STRING COMMENT 'Overall pass/fail determination for this individual test execution based on comparison of the measured value against acceptance limits. Core field for stage-gate decisions and technology readiness assessments.. Valid values are `pass|fail|conditional_pass|inconclusive|void|pending_review`',
    `retest_required` BOOLEAN COMMENT 'Indicates whether this test result requires a retest to be performed, either due to a failure, inconclusive result, or test execution anomaly. Drives retest scheduling and workload planning.. Valid values are `true|false`',
    `retest_sequence_number` STRING COMMENT 'Sequential iteration number indicating whether this result is from the original test (1) or a subsequent retest attempt (2, 3, etc.). Enables tracking of test history and convergence toward acceptance.. Valid values are `^[0-9]+$`',
    `review_timestamp` TIMESTAMP COMMENT 'Date and time when the test result was formally reviewed and approved by the responsible authority. Supports audit trail requirements and stage-gate timeline tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `severity_rating` STRING COMMENT 'Numeric severity rating (1-10 scale) assigned to the failure based on its potential impact on product function, safety, or regulatory compliance. Aligned with FMEA severity scoring to prioritize corrective actions.. Valid values are `^([1-9]|10)$`',
    `site_code` STRING COMMENT 'Code identifying the specific manufacturing or R&D facility where the test was performed. Enables geographic segmentation of test results across the global enterprise.',
    `stage_gate_phase` STRING COMMENT 'The product development stage-gate phase during which this test was conducted. Enables filtering of test results by development phase for technology readiness level (TRL) assessments and gate review packages.. Valid values are `concept|feasibility|design|prototype|validation|pilot|launch|post_launch`',
    `technology_readiness_level` STRING COMMENT 'Technology Readiness Level (TRL) score (1-9 scale) associated with this test result, indicating the maturity of the technology being validated. Used for R&D portfolio management and stage-gate advancement decisions.. Valid values are `^([1-9])$`',
    `test_category` STRING COMMENT 'Business classification of the test within the product development lifecycle. Distinguishes design verification (DV) from design validation (DV) and process validation (PV) activities per APQP and PPAP requirements.. Valid values are `design_verification|design_validation|process_validation|first_article_inspection|qualification|certification|exploratory|regression`',
    `test_condition_humidity_pct` DECIMAL(18,2) COMMENT 'Relative humidity percentage recorded at the test environment during execution. Required for environmental condition traceability and result validity assessment per ISO/IEC 17025.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `test_condition_temperature_c` DECIMAL(18,2) COMMENT 'Ambient or controlled temperature in degrees Celsius at the time of test execution. Environmental conditions are required for result validity and reproducibility per ISO/IEC 17025.',
    `test_end_timestamp` TIMESTAMP COMMENT 'Precise date and time when the test execution concluded. Combined with test_start_timestamp to derive test duration for lab efficiency and capacity planning.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `test_engineer_name` STRING COMMENT 'Full name of the R&D engineer who executed the test. Displayed on test reports and certificates of conformance for regulatory and customer-facing documentation.',
    `test_environment` STRING COMMENT 'Physical or virtual environment in which the test was conducted. Relevant for result validity assessment, environmental condition traceability, and regulatory certification.. Valid values are `laboratory|field|simulation|test_bench|climatic_chamber|anechoic_chamber|clean_room|production_floor`',
    `test_execution_date` DATE COMMENT 'Calendar date on which the test was physically or virtually executed. Used for scheduling compliance, trend analysis, and stage-gate timeline tracking.. Valid values are `^d{4}-d{2}-d{2}$`',
    `test_method_code` STRING COMMENT 'Code referencing the standardized test method or procedure (e.g., ASTM, IEC, internal SOP) applied during test execution. Ensures reproducibility and regulatory compliance.',
    `test_report_number` STRING COMMENT 'Reference number of the formal test report document that contains this result. Enables linkage to the official test documentation package submitted for stage-gate reviews or customer/regulatory submissions.',
    `test_start_timestamp` TIMESTAMP COMMENT 'Precise date and time when the test execution commenced. Used for duration calculation, lab scheduling, and audit trail purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `test_type` STRING COMMENT 'Classification of the test by its technical nature and purpose. Drives reporting segmentation, resource allocation, and compliance mapping to specific regulatory standards.. Valid values are `functional|performance|environmental|reliability|safety|electrical|mechanical|chemical|software|integration|regression|acceptance|destructive|non_destructive`',
    `unit_of_measure` STRING COMMENT 'Engineering unit associated with the measured value (e.g., V, A, Nm, MPa, °C, Hz, mm). Required for correct interpretation of test results and cross-test comparability.',
    `upper_acceptance_limit` DECIMAL(18,2) COMMENT 'Maximum acceptable value for the measured parameter as defined in the test specification or acceptance criteria. Used for pass/fail determination and process capability analysis.',
    CONSTRAINT pk_rd_test_result PRIMARY KEY(`rd_test_result_id`)
) COMMENT 'Transactional record capturing the outcome of individual test executions performed against an R&D test plan. Records test case identifier, test date, test engineer, measured values, pass/fail determination, deviation from acceptance criteria, failure description, retest flag, and disposition recommendation. Provides the evidentiary record for technology readiness assessments and stage-gate decisions.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`ip_asset` (
    `ip_asset_id` BIGINT COMMENT 'Unique system-generated identifier for each intellectual property asset record in the R&D portfolio.',
    `asset_register_id` BIGINT COMMENT 'Foreign key linking to finance.asset_register. Business justification: Intellectual property assets (patents, trademarks) are capitalized and tracked in the fixed asset register. Finance uses this for amortization schedules and balance sheet reporting.',
    `export_classification_id` BIGINT COMMENT 'Foreign key linking to compliance.export_classification. Business justification: Intellectual property (especially technology and designs) requires export classification for international collaboration and licensing. IP management tracks ECCN/ITAR classifications to control techno',
    `employee_id` BIGINT COMMENT 'Employee identifier of the primary or lead inventor responsible for the invention, used for inventor recognition, compensation, and HR linkage.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: An IP asset is generated by R&D activities and belongs to an R&D project. ip_asset has rd_project_reference (string) as a denormalized reference. Adding rd_project_id as a proper FK normalizes this re',
    `abstract` STRING COMMENT 'Brief technical summary or abstract describing the invention, innovation, or know-how captured by this IP asset. Mirrors the patent abstract for filed patents.',
    `annuity_due_date` DATE COMMENT 'Next scheduled date for payment of patent maintenance fees or annuities to the relevant patent office to keep the patent in force. Critical for portfolio maintenance management.',
    `application_number` STRING COMMENT 'Official application number assigned by the patent office upon filing of the patent application, used to track prosecution status.',
    `associated_product_line` STRING COMMENT 'Name of the product line or product family to which this IP asset is commercially linked, supporting product-IP portfolio alignment and licensing strategy.',
    `claims_summary` STRING COMMENT 'High-level summary of the key claims or scope of protection for the IP asset, used for portfolio review and freedom-to-operate analysis.',
    `confidentiality_level` STRING COMMENT 'Data classification level for the IP asset record, governing access controls and information sharing. Trade secrets and undisclosed inventions are typically restricted.. Valid values are `restricted|confidential|internal|public`',
    `cpc_classification` STRING COMMENT 'Cooperative Patent Classification code assigned jointly by USPTO and EPO, providing more granular technical classification than IPC for patent analytics.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the IP asset record was first created in the system, used for audit trail and data lineage tracking.',
    `estimated_commercial_value_usd` DECIMAL(18,2) COMMENT 'Estimated monetary value of the IP asset in US dollars, based on internal valuation models considering licensing potential, competitive advantage, and market applicability. Used for IP portfolio prioritization and balance sheet reporting.',
    `expiry_date` DATE COMMENT 'Date on which the IP protection expires or lapses, typically 20 years from filing date for patents. Used for portfolio renewal management and competitive intelligence.',
    `external_law_firm` STRING COMMENT 'Name of the external law firm engaged for patent prosecution, IP registration, or IP litigation activities related to this asset.',
    `filing_date` DATE COMMENT 'Date on which the patent application or IP registration was formally filed with the relevant patent or IP office. Establishes priority date for patent prosecution.',
    `freedom_to_operate_status` STRING COMMENT 'Result of the freedom-to-operate analysis indicating whether the company can commercialize products using this IP without infringing third-party rights.. Valid values are `cleared|at_risk|blocked|not_assessed|in_review`',
    `grant_date` DATE COMMENT 'Date on which the patent was officially granted by the patent office. Null for applications not yet granted or non-patent IP types.',
    `invention_disclosure_date` DATE COMMENT 'Date on which the invention disclosure was formally submitted by the inventor(s) to the IP management team, initiating the IP evaluation process.',
    `inventors` STRING COMMENT 'Comma-separated list of inventor names as listed on the patent application or IP disclosure. Required for legal attribution and inventor compensation programs.',
    `ip_type` STRING COMMENT 'Classification of the IP asset by legal category: patent, trade secret, proprietary algorithm, software invention, know-how, trademark, copyright, utility model, or design right.. Valid values are `patent|trade_secret|proprietary_algorithm|software_invention|know_how|trademark|copyright|utility_model|design_right`',
    `ipc_classification` STRING COMMENT 'International Patent Classification code assigned to the IP asset, enabling standardized categorization and prior art searching across global patent databases.',
    `is_licensed_externally` BOOLEAN COMMENT 'Indicates whether this IP asset is currently licensed to one or more external parties, enabling quick identification of revenue-generating IP in the portfolio.. Valid values are `true|false`',
    `is_standard_essential` BOOLEAN COMMENT 'Indicates whether this patent is declared as a Standard Essential Patent (SEP), meaning it is essential to implement an industry standard (e.g., IEC, ISO, IEEE). SEPs carry FRAND licensing obligations.. Valid values are `true|false`',
    `jurisdiction` STRING COMMENT 'Country or regional jurisdiction in which the IP asset is filed or protected, using ISO 3166-1 alpha-3 country codes (e.g., USA, DEU, GBR, CHN) or regional designations (e.g., EPO for European Patent Office, PCT for international).',
    `jurisdiction_office` STRING COMMENT 'The specific patent or intellectual property office where the IP asset is filed or registered, such as USPTO (US), EPO (Europe), WIPO (international PCT), CNIPA (China), JPO (Japan).. Valid values are `USPTO|EPO|WIPO|CNIPA|JPO|KIPO|UKIPO|INPI|DPMA|other`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the IP asset record, supporting change tracking and audit compliance.',
    `licensing_model` STRING COMMENT 'Type of licensing arrangement applied to this IP asset, indicating whether it is exclusively licensed, non-exclusively licensed, cross-licensed, or not yet licensed.. Valid values are `exclusive|non_exclusive|cross_license|sublicense|royalty_free|not_licensed|open_source|pending`',
    `maintenance_fee_status` STRING COMMENT 'Current status of patent maintenance fee or annuity payments, indicating whether fees are current, overdue, or not applicable for this IP type.. Valid values are `current|overdue|paid|waived|not_applicable`',
    `owning_business_unit` STRING COMMENT 'Name of the internal business unit or division that owns the IP asset and is responsible for its commercialization and maintenance decisions.',
    `owning_legal_entity` STRING COMMENT 'Legal entity name within the corporate group that holds formal ownership of the IP asset, relevant for multinational IP portfolio management and tax structuring.',
    `patent_number` STRING COMMENT 'Official patent number assigned by the relevant patent office upon grant. Null for non-patent IP types or pre-grant filings.',
    `priority_date` DATE COMMENT 'Earliest claimed priority date for the IP asset, typically the date of the first filing in any jurisdiction. Determines novelty and prior art assessment.',
    `prosecution_attorney` STRING COMMENT 'Name or identifier of the internal or external patent attorney or agent responsible for prosecuting this IP asset before the patent office.',
    `reference_number` STRING COMMENT 'Internal company reference or docket number assigned to the IP asset for tracking purposes within the PLM and legal systems, distinct from the official patent number.',
    `stage_gate_phase` STRING COMMENT 'Current stage-gate phase of the associated R&D project at the time of IP asset creation or last update, supporting APQP planning and innovation pipeline management.. Valid values are `ideation|concept|feasibility|development|validation|launch|post_launch`',
    `status` STRING COMMENT 'Current lifecycle status of the IP asset within the portfolio management process, from initial invention disclosure through filing, grant, licensing, or abandonment.. Valid values are `invention_disclosure|filed|granted|abandoned|licensed|expired|under_review|withdrawn`',
    `technology_domain` STRING COMMENT 'Primary technology domain or area of innovation to which the IP asset belongs, aligned with the companys core R&D focus areas in automation, electrification, and smart infrastructure.. Valid values are `automation|electrification|smart_infrastructure|robotics|power_electronics|industrial_iot|software_controls|drive_systems|energy_management|digital_twin|cybersecurity|sensing_and_measurement|other`',
    `title` STRING COMMENT 'Official title or name of the intellectual property asset as registered or internally designated, e.g., patent title or trade secret name.',
    `valuation_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the currency in which the IP asset commercial value is expressed (e.g., USD, EUR, GBP).. Valid values are `^[A-Z]{3}$`',
    CONSTRAINT pk_ip_asset PRIMARY KEY(`ip_asset_id`)
) COMMENT 'Master record for intellectual property assets generated by R&D activities including patents, trade secrets, proprietary algorithms, software inventions, and know-how. Captures IP type, title, inventors, filing date, patent number, jurisdiction, IP status (invention disclosure, filed, granted, abandoned, licensed), associated R&D project, technology domain, and estimated commercial value. Supports IP portfolio management and licensing strategy.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`patent_filing` (
    `patent_filing_id` BIGINT COMMENT 'Unique system-generated identifier for each patent filing record within the IP lifecycle management system.',
    `ip_asset_id` BIGINT COMMENT 'Foreign key linking to research.ip_asset. Business justification: A patent filing tracks the formal patent application and prosecution lifecycle for a specific IP asset. This is a child→parent relationship (one IP asset can have multiple patent filings across jurisd',
    `legal_entity_id` BIGINT COMMENT 'Foreign key linking to finance.legal_entity. Business justification: Patents are filed under specific legal entities for IP ownership and tax optimization. Legal and finance teams use this for asset registration and intercompany licensing.',
    `abstract` STRING COMMENT 'Brief technical summary of the invention as filed with the patent office, describing the technical field, problem solved, and key aspects of the solution.',
    `annuity_cost_amount` DECIMAL(18,2) COMMENT 'Total annuity or renewal fees paid to date to maintain the patent in force across all jurisdictions. Used for IP maintenance budget planning and cost-benefit analysis of patent portfolio.. Valid values are `^d+(.d{1,2})?$`',
    `annuity_year` STRING COMMENT 'The current annuity year number for which the next renewal fee is due. Increments annually from the filing date. Used to determine the applicable fee schedule for each jurisdiction.. Valid values are `^([1-9]|[1-2][0-9]|20)$`',
    `application_number` STRING COMMENT 'Official application number assigned by the patent office (e.g., USPTO, EPO, WIPO) upon receipt of the patent application. Used for all official correspondence and prosecution tracking.',
    `assigned_attorney` STRING COMMENT 'Name or identifier of the registered patent attorney or patent agent responsible for prosecuting the application before the patent office. Used for workload management, legal accountability, and outside counsel billing.',
    `assignee_name` STRING COMMENT 'Legal name of the entity (company or individual) to whom the patent rights have been assigned. Typically the employing company for employee inventions. Determines ownership for licensing, enforcement, and IP valuation.',
    `business_unit` STRING COMMENT 'The internal business unit or division that owns or sponsored the invention. Used for IP portfolio allocation, cost center charging, and strategic alignment reporting.',
    `confidentiality_status` STRING COMMENT 'Indicates the confidentiality classification of the patent filing record. Unpublished applications are confidential; published applications are public. Governs internal access controls and information sharing with external partners.. Valid values are `confidential|published|restricted`',
    `cost_center_code` STRING COMMENT 'SAP cost center code to which patent filing and prosecution costs are charged. Enables financial allocation of IP costs to the responsible organizational unit for management accounting.. Valid values are `^[A-Z0-9-]{2,20}$`',
    `cost_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for all cost amounts recorded on this patent filing (filing cost, prosecution cost, annuity cost). Supports multi-currency IP financial reporting for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `cpc_classification` STRING COMMENT 'The Cooperative Patent Classification code assigned to the patent, providing a more granular technical classification than IPC. Used by USPTO and EPO for examination and portfolio analytics.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the patent filing record was first created in the IP management system. Used for audit trail, data lineage, and record management compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `expiry_date` DATE COMMENT 'The calculated date on which the patent protection expires, typically 20 years from the filing date for utility patents, subject to patent term adjustments or extensions. Critical for annuity payment scheduling and IP portfolio lifecycle management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `filing_cost_amount` DECIMAL(18,2) COMMENT 'Total legal and official fees incurred at the time of filing the patent application, including government filing fees and attorney fees. Used for IP budget tracking and CAPEX/OPEX reporting.. Valid values are `^d+(.d{1,2})?$`',
    `filing_date` DATE COMMENT 'The official date on which the patent application was received and accorded a filing date by the patent office. Establishes the priority date for the application and determines patent term calculation.. Valid values are `^d{4}-d{2}-d{2}$`',
    `filing_language` STRING COMMENT 'ISO 639-1/639-2 language code of the language in which the patent application was filed. Relevant for translation requirements, EPO language regime compliance, and PCT national phase entry.. Valid values are `^[a-z]{2,3}$`',
    `filing_reference_number` STRING COMMENT 'Internal reference number assigned by the companys IP management system to uniquely identify and track the patent application across all jurisdictions and prosecution stages.. Valid values are `^[A-Z0-9-/]{3,50}$`',
    `grant_date` DATE COMMENT 'The official date on which the patent was granted by the patent office, conferring exclusive rights to the patent holder. Null until the patent is granted. Used to calculate patent expiry and annuity schedules.. Valid values are `^d{4}-d{2}-d{2}$`',
    `grant_number` STRING COMMENT 'Official patent number assigned by the patent office upon grant of the patent. Null until the patent is granted. Used for licensing, enforcement, and IP portfolio reporting.',
    `inventor_names` STRING COMMENT 'Comma-separated list of full names of all inventors listed on the patent application. Required for legal validity of the patent and inventor compensation programs. Stored as a denormalized string; detailed inventor records are managed in the IP inventor registry.',
    `ipc_classification` STRING COMMENT 'The International Patent Classification code assigned to the patent application, categorizing the invention by technical subject matter. Used for patent searching, portfolio analysis, and competitive intelligence.. Valid values are `^[A-H][0-9]{2}[A-Z][0-9]{1,4}/[0-9]{2,6}$`',
    `is_encumbered` BOOLEAN COMMENT 'Indicates whether the patent is subject to a security interest, lien, or other encumbrance (e.g., pledged as collateral). Important for IP asset valuation, M&A due diligence, and financial reporting.. Valid values are `true|false`',
    `is_licensed` BOOLEAN COMMENT 'Indicates whether the patent has been licensed to one or more third parties. Used for IP commercialization tracking, revenue recognition, and portfolio strategy reporting.. Valid values are `true|false`',
    `jurisdiction_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the national jurisdiction in which the patent application is filed or validated. Supports multi-jurisdictional IP portfolio management.. Valid values are `^[A-Z]{3}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the patent filing record in the IP management system. Supports audit trail, change tracking, and data quality monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_office_action_date` DATE COMMENT 'Date of the most recent office action (examination report or rejection) issued by the patent office. Used to track prosecution timelines, response deadlines, and examiner interaction history.. Valid values are `^d{4}-d{2}-d{2}$`',
    `law_firm_name` STRING COMMENT 'Name of the external law firm or IP services firm engaged to prosecute the patent application. Used for outside counsel management, billing reconciliation, and performance tracking.',
    `next_annuity_due_date` DATE COMMENT 'The date by which the next annual renewal or maintenance fee must be paid to the patent office to keep the patent application or granted patent in force. Critical for annuity payment scheduling and avoiding unintentional lapse.. Valid values are `^d{4}-d{2}-d{2}$`',
    `parent_application_number` STRING COMMENT 'Application number of the parent patent application from which this filing derives (e.g., for continuation, divisional, or continuation-in-part applications). Establishes the prosecution family hierarchy.',
    `patent_family_code` STRING COMMENT 'Identifier grouping all related patent applications (across jurisdictions and continuation types) that share a common priority application. Enables portfolio-level analysis of IP protection coverage across markets.',
    `patent_office` STRING COMMENT 'The national or international patent office where the application was filed. Determines applicable prosecution rules, fee schedules, and legal requirements. Examples: USPTO (United States), EPO (European Patent Office), WIPO (World Intellectual Property Organization).. Valid values are `USPTO|EPO|WIPO|JPO|CNIPA|KIPO|UKIPO|INPI|DPMA|CIPO|IP_AUSTRALIA|OTHER`',
    `patent_type` STRING COMMENT 'Classification of the patent application by type. Utility patents protect functional inventions; design patents protect ornamental designs; PCT applications are international filings under the Patent Cooperation Treaty.. Valid values are `utility|design|plant|provisional|PCT|divisional|continuation|continuation_in_part|reissue`',
    `priority_date` DATE COMMENT 'The earliest claimed priority date for the patent application, typically the filing date of the first application in a priority chain (e.g., provisional application or first national filing). Governs prior art assessment and patent term.. Valid values are `^d{4}-d{2}-d{2}$`',
    `prosecution_cost_amount` DECIMAL(18,2) COMMENT 'Cumulative legal and official fees incurred during the prosecution phase of the patent application, including office action responses, examination fees, and attorney fees. Supports IP cost management and ROI analysis.. Valid values are `^d+(.d{1,2})?$`',
    `prosecution_status` STRING COMMENT 'Current stage of the patent application in the prosecution lifecycle at the patent office. Tracks the application from initial filing through examination, allowance, grant, or abandonment. Used for IP portfolio management and reporting.. Valid values are `draft|filed|pending_examination|under_examination|office_action_received|response_filed|allowed|granted|abandoned|withdrawn|lapsed|expired|appealed|opposition_filed|licensed`',
    `publication_date` DATE COMMENT 'The date on which the patent application was officially published by the patent office, making the application publicly available. Typically occurs 18 months after the earliest priority date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `publication_number` STRING COMMENT 'Official number assigned by the patent office when the patent application is published, typically 18 months after the earliest priority date. Used for public search and citation tracking.',
    `related_rd_project_code` STRING COMMENT 'Internal R&D project code or identifier of the research project from which the invention originated. Links the patent filing to the innovation pipeline and supports APQP stage-gate tracking and R&D ROI analysis.',
    `response_deadline_date` DATE COMMENT 'The statutory or extended deadline by which a response to the most recent office action must be filed to avoid abandonment of the application. Critical for prosecution management and docketing.. Valid values are `^d{4}-d{2}-d{2}$`',
    `standard_essential_patent_flag` BOOLEAN COMMENT 'Indicates whether the patent has been declared as a Standard Essential Patent (SEP), meaning it is necessarily infringed by implementing a specific industry standard (e.g., IEC, ISO, IEEE). SEPs are subject to FRAND licensing obligations and require special legal management.. Valid values are `true|false`',
    `technology_domain` STRING COMMENT 'The primary technology area or domain of the invention, aligned with the companys R&D focus areas (e.g., automation systems, electrification, smart infrastructure, IIoT, robotics, power electronics). Used for IP portfolio segmentation and technology roadmap alignment.',
    `title` STRING COMMENT 'Official title of the invention as submitted in the patent application. Describes the subject matter of the patent in concise technical terms.',
    CONSTRAINT pk_patent_filing PRIMARY KEY(`patent_filing_id`)
) COMMENT 'Transactional record tracking the formal patent application and prosecution lifecycle for each IP asset. Captures filing reference number, patent office (USPTO, EPO, WIPO, national offices), filing date, publication date, grant date, annuity due dates, prosecution status, assigned patent attorney/agent, and associated legal costs. Supports IP lifecycle management and annuity payment scheduling across global jurisdictions.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`partner` (
    `partner_id` BIGINT COMMENT 'Unique system-generated identifier for the external research partner organization within the R&D collaboration management system.',
    `sanctions_screening_id` BIGINT COMMENT 'Foreign key linking to compliance.sanctions_screening. Business justification: Research partners (universities, suppliers, co-developers) must be screened against sanctions lists before collaboration. Legal/compliance performs screening before contracts are executed to prevent p',
    `active_project_count` STRING COMMENT 'Number of currently active R&D projects in which this research partner is participating. Used for portfolio load balancing and partner engagement reporting.. Valid values are `^[0-9]+$`',
    `agreement_end_date` DATE COMMENT 'Scheduled expiry date of the collaboration agreement. Used for renewal tracking, compliance monitoring, and portfolio lifecycle management.. Valid values are `^d{4}-d{2}-d{2}$`',
    `agreement_start_date` DATE COMMENT 'Effective start date of the collaboration agreement, marking the commencement of the formal R&D partnership relationship.. Valid values are `^d{4}-d{2}-d{2}$`',
    `agreement_type` STRING COMMENT 'Type of formal legal agreement governing the research collaboration, determining the structure of IP ownership, funding obligations, and deliverable responsibilities.. Valid values are `joint_development_agreement|research_services_agreement|consortium_agreement|memorandum_of_understanding|sponsored_research_agreement|technology_license_agreement|material_transfer_agreement|other`',
    `annual_collaboration_budget` DECIMAL(18,2) COMMENT 'Total annual budget allocated for the research collaboration with this partner, covering sponsored research fees, milestone payments, and resource contributions.',
    `budget_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the annual collaboration budget (e.g., USD, EUR, GBP), supporting multi-currency financial reporting.. Valid values are `^[A-Z]{3}$`',
    `city` STRING COMMENT 'City where the research partner organizations primary office or research facility is located.',
    `code` STRING COMMENT 'Business-assigned alphanumeric code uniquely identifying the research partner for use in cross-system references, agreements, and reporting.. Valid values are `^RP-[A-Z0-9]{4,12}$`',
    `collaboration_agreement_ref` STRING COMMENT 'Reference number or identifier of the formal collaboration agreement (e.g., Joint Development Agreement, Research Services Agreement, Consortium Agreement) governing the R&D partnership.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 three-letter country code representing the primary country of registration or headquarters of the research partner organization.. Valid values are `^[A-Z]{3}$`',
    `data_sharing_agreement_in_place` BOOLEAN COMMENT 'Indicates whether a formal data sharing agreement is in place with the research partner, governing the exchange of proprietary data, test results, and experimental datasets in compliance with GDPR and CCPA.. Valid values are `true|false`',
    `due_diligence_date` DATE COMMENT 'Date on which the most recent due diligence assessment of the research partner was completed, used to determine when re-assessment is required.. Valid values are `^d{4}-d{2}-d{2}$`',
    `due_diligence_status` STRING COMMENT 'Current status of the due diligence assessment conducted on the research partner, covering financial stability, compliance posture, cybersecurity maturity, and reputational risk.. Valid values are `not_started|in_progress|completed|waived|expired`',
    `export_control_classification` STRING COMMENT 'Export control classification applicable to the technology and information shared with this research partner, ensuring compliance with US EAR, ITAR, and EU dual-use regulations.. Valid values are `EAR99|ECCN_controlled|ITAR_controlled|not_applicable|under_review`',
    `ip_agreement_in_place` BOOLEAN COMMENT 'Indicates whether a formal Intellectual Property (IP) ownership and rights agreement is in place with the research partner, governing ownership of jointly developed innovations, patents, and trade secrets.. Valid values are `true|false`',
    `ip_ownership_model` STRING COMMENT 'Defines the IP ownership structure agreed upon with the research partner, determining how patents, trade secrets, and innovations arising from the collaboration are allocated.. Valid values are `company_owned|partner_owned|jointly_owned|licensed_to_company|licensed_to_partner|background_ip_retained|negotiated_per_project`',
    `last_performance_review_date` DATE COMMENT 'Date of the most recent formal performance review conducted for this research partner, used to schedule next review and track evaluation cadence.. Valid values are `^d{4}-d{2}-d{2}$`',
    `name` STRING COMMENT 'Full legal name of the external research partner organization as registered in their jurisdiction of incorporation or establishment.',
    `nda_expiry_date` DATE COMMENT 'Expiry date of the Non-Disclosure Agreement with the research partner. Enables proactive renewal management to ensure continuous confidentiality protection.. Valid values are `^d{4}-d{2}-d{2}$`',
    `nda_in_place` BOOLEAN COMMENT 'Indicates whether a valid Non-Disclosure Agreement (NDA) is currently in place with the research partner, protecting confidential information exchanged during collaboration.. Valid values are `true|false`',
    `notes` STRING COMMENT 'Free-text field for capturing additional context, strategic rationale, collaboration history highlights, or special conditions relevant to the research partner relationship.',
    `onboarding_date` DATE COMMENT 'Date on which the research partner was formally onboarded into the companys R&D collaboration program, marking the start of the master relationship record.. Valid values are `^d{4}-d{2}-d{2}$`',
    `performance_rating` DECIMAL(18,2) COMMENT 'Periodic performance rating of the research partner on a 0.0 to 5.0 scale, based on delivery quality, milestone adherence, innovation contribution, and collaboration effectiveness.. Valid values are `^([0-4].[0-9]|5.0)$`',
    `preferred_collaboration_mode` STRING COMMENT 'Preferred mode of collaboration engagement with the research partner, indicating whether work is conducted on-site, remotely, in a joint laboratory, or through researcher secondment.. Valid values are `on_site|remote|hybrid|secondment|joint_lab`',
    `primary_contact_email` STRING COMMENT 'Official email address of the primary contact at the research partner organization for collaboration communications and notifications.. Valid values are `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$`',
    `primary_contact_name` STRING COMMENT 'Full name of the primary point of contact at the research partner organization responsible for managing the collaboration relationship.',
    `primary_contact_phone` STRING COMMENT 'Direct phone number of the primary contact at the research partner organization for urgent collaboration communications.. Valid values are `^+?[0-9s-().]{7,20}$`',
    `primary_contact_title` STRING COMMENT 'Professional title or role of the primary contact at the research partner organization (e.g., Principal Investigator, Research Director, Technology Transfer Officer).',
    `region` STRING COMMENT 'Geographic region or continent where the research partner is headquartered, used for regional portfolio analysis and collaboration reporting.',
    `research_focus_area` STRING COMMENT 'Primary research focus area or scientific discipline of the partner organization relevant to the collaboration (e.g., Industrial Automation, Electrification, Smart Grid, Cybersecurity, Advanced Materials).',
    `short_name` STRING COMMENT 'Abbreviated or commonly used name for the research partner organization, used in reports, dashboards, and internal communications.',
    `status` STRING COMMENT 'Current operational status of the research partner relationship, indicating whether the collaboration is active, pending, suspended, or terminated.. Valid values are `active|inactive|pending_approval|suspended|terminated|under_review`',
    `technology_domains` STRING COMMENT 'Comma-separated list of technology domains in which the research partner has recognized expertise, such as automation, electrification, power electronics, AI/ML, robotics, smart infrastructure, or materials science.',
    `technology_readiness_level` STRING COMMENT 'NASA/EU Technology Readiness Level (TRL) scale (1-9) indicating the maturity of the technology being developed or contributed by the research partner, used in stage-gate and APQP planning.. Valid values are `^([1-9])$`',
    `termination_date` DATE COMMENT 'Date on which the research partnership was formally terminated or concluded. Null if the relationship is still active.. Valid values are `^d{4}-d{2}-d{2}$`',
    `tier` STRING COMMENT 'Strategic classification tier of the research partner based on collaboration depth, investment level, and strategic importance to the companys R&D roadmap.. Valid values are `strategic|preferred|standard|exploratory`',
    `type` STRING COMMENT 'Classification of the external research partner by organizational type, distinguishing universities, national laboratories, technology startups, industry consortia, and other research entities.. Valid values are `university|research_institute|technology_startup|national_laboratory|industry_consortium|government_agency|nonprofit_foundation|corporate_research_center|other`',
    `website_url` STRING COMMENT 'Official website URL of the research partner organization, used for reference, due diligence, and partner profile enrichment.. Valid values are `^https?://[^s/$.?#].[^s]*$`',
    CONSTRAINT pk_partner PRIMARY KEY(`partner_id`)
) COMMENT 'Master record for external research partners collaborating on R&D projects including universities, research institutes, technology startups, national laboratories, and industry consortia. Captures partner organization name, partner type, country, primary contact, collaboration agreement reference, active collaboration status, technology domains of expertise, and NDA/IP agreement flags. Distinct from supply.supplier which manages commercial procurement vendors; this entity manages R&D collaboration relationships.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` (
    `collaboration_agreement_id` BIGINT COMMENT 'Unique system-generated identifier for the collaboration agreement record within the R&D partnership management system.',
    `data_privacy_record_id` BIGINT COMMENT 'Foreign key linking to compliance.data_privacy_record. Business justification: Collaboration agreements involving data sharing require documented privacy compliance (GDPR, CCPA). Legal teams link agreements to privacy records detailing data processing terms, transfer mechanisms,',
    `legal_entity_id` BIGINT COMMENT 'FK to finance.legal_entity',
    `partner_id` BIGINT COMMENT 'FK to research.research_partner',
    `procurement_contract_id` BIGINT COMMENT 'Foreign key linking to procurement.procurement_contract. Business justification: Research partnerships with external labs or universities are formalized through procurement contracts covering services, IP rights, and deliverables. Legal and procurement manage these as formal suppl',
    `agreement_currency` STRING COMMENT 'ISO 4217 three-letter currency code in which the financial terms of the collaboration agreement are denominated.. Valid values are `^[A-Z]{3}$`',
    `agreement_number` STRING COMMENT 'Human-readable business reference number assigned to the collaboration agreement, used for cross-system referencing and legal documentation.. Valid values are `^CA-[0-9]{4}-[0-9]{6}$`',
    `agreement_owner` STRING COMMENT 'Name or employee identifier of the internal business owner accountable for the collaboration agreements performance and compliance.',
    `agreement_type` STRING COMMENT 'Classification of the collaboration agreement type. JDA = Joint Development Agreement, CRA = Collaborative Research Agreement, consortium_membership = participation in a research consortium, sponsored_research = company-funded external research, NDA = Non-Disclosure Agreement, MOU = Memorandum of Understanding.. Valid values are `JDA|CRA|consortium_membership|sponsored_research|NDA|MOU|technology_license|co_development`',
    `company_financial_commitment` DECIMAL(18,2) COMMENT 'Total financial commitment by the company under the collaboration agreement, including cash contributions, in-kind resources, and equipment.',
    `confidentiality_level` STRING COMMENT 'Data classification level assigned to the collaboration agreement and its associated information, governing access and disclosure controls.. Valid values are `public|internal|confidential|restricted|top_secret`',
    `cost_sharing_model` STRING COMMENT 'Structure defining how research and development costs are shared between the company and the external partner(s) under the agreement.. Valid values are `equal_split|proportional|company_funded|partner_funded|grant_funded|milestone_based|in_kind_contribution`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the collaboration agreement record was first created in the system, used for audit trail and data lineage.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `dispute_resolution_mechanism` STRING COMMENT 'Contractually agreed mechanism for resolving disputes between parties arising from the collaboration agreement.. Valid values are `negotiation|mediation|arbitration|litigation|expert_determination`',
    `effective_date` DATE COMMENT 'Date on which the collaboration agreement becomes legally effective and binding on all parties.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date on which the collaboration agreement is scheduled to expire unless renewed or extended.. Valid values are `^d{4}-d{2}-d{2}$`',
    `export_control_classification` STRING COMMENT 'Export Control Classification Number (ECCN) or equivalent classification code applicable to the technology or materials covered by the collaboration agreement.',
    `export_control_flag` BOOLEAN COMMENT 'Indicates whether the collaboration agreement involves technology, data, or materials subject to export control regulations such as EAR, ITAR, or EU Dual-Use regulations.. Valid values are `true|false`',
    `governing_law_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the jurisdiction whose laws govern the interpretation and enforcement of the collaboration agreement.. Valid values are `^[A-Z]{3}$`',
    `ip_ownership_company_pct` DECIMAL(18,2) COMMENT 'Percentage of foreground intellectual property ownership attributed to the company under the collaboration agreement, applicable when IP is jointly owned.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `ip_ownership_model` STRING COMMENT 'Defines the intellectual property ownership structure for foreground IP generated under the collaboration agreement, critical for patent strategy and commercialization planning.. Valid values are `company_owned|partner_owned|jointly_owned|background_ip_retained|field_of_use_license|negotiated_split`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the collaboration agreement record, supporting change tracking and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `legal_counsel_name` STRING COMMENT 'Name of the internal or external legal counsel responsible for reviewing and approving the collaboration agreement.',
    `nda_expiry_date` DATE COMMENT 'Date on which the confidentiality obligations under the NDA provisions of the agreement expire, which may extend beyond the agreements own expiry date.. Valid values are `^d{4}-d{2}-d{2}$`',
    `nda_included` BOOLEAN COMMENT 'Indicates whether a non-disclosure agreement (NDA) or confidentiality provisions are embedded within or attached to the collaboration agreement.. Valid values are `true|false`',
    `partner_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the external research partners primary registered location, used for export control and regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `partner_type` STRING COMMENT 'Classification of the external research partner organization type, used for portfolio analysis and compliance reporting.. Valid values are `university|research_institute|national_laboratory|technology_company|startup|industry_consortium|government_agency|non_profit`',
    `publication_embargo_days` STRING COMMENT 'Number of days that publication of research results must be withheld to allow for patent filing or proprietary review before public disclosure.. Valid values are `^[0-9]+$`',
    `publication_rights` STRING COMMENT 'Terms governing the rights of parties to publish research findings, papers, or results arising from the collaboration, including any approval or embargo requirements.. Valid values are `unrestricted|company_approval_required|joint_approval_required|embargo_period|restricted|no_publication`',
    `renewal_notice_days` STRING COMMENT 'Number of days prior to expiry by which notice must be given to exercise the renewal option, ensuring timely contract management actions.. Valid values are `^[0-9]+$`',
    `renewal_option` BOOLEAN COMMENT 'Indicates whether the collaboration agreement contains provisions for renewal or extension beyond the original expiry date.. Valid values are `true|false`',
    `research_scope` STRING COMMENT 'Narrative description of the research objectives, deliverables, and scope of work covered under the collaboration agreement.',
    `responsible_department` STRING COMMENT 'Internal department or business unit responsible for managing and executing the collaboration agreement.',
    `signed_date` DATE COMMENT 'Date on which all parties executed and signed the collaboration agreement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `source_system` STRING COMMENT 'Operational system of record from which the collaboration agreement data was sourced or originated, supporting data lineage and audit traceability.. Valid values are `SAP_S4HANA|Teamcenter_PLM|SAP_Ariba|Salesforce_CRM|manual|other`',
    `stage_gate_phase` STRING COMMENT 'Current stage-gate phase of the R&D initiative associated with this collaboration agreement, aligned with the companys APQP and innovation pipeline process.. Valid values are `ideation|concept|feasibility|development|validation|launch|post_launch`',
    `status` STRING COMMENT 'Current lifecycle status of the collaboration agreement, tracking progression from drafting through execution to closure.. Valid values are `draft|under_review|pending_signature|active|suspended|expired|terminated|closed|renewed`',
    `technology_domain` STRING COMMENT 'Primary technology domain or research area covered by the collaboration agreement, aligned with the companys strategic R&D focus areas.. Valid values are `automation|electrification|smart_infrastructure|digitalization|materials_science|power_electronics|robotics|ai_ml|cybersecurity|energy_management|other`',
    `termination_date` DATE COMMENT 'Actual date on which the collaboration agreement was terminated prior to its scheduled expiry, if applicable.. Valid values are `^d{4}-d{2}-d{2}$`',
    `termination_reason` STRING COMMENT 'Reason for early termination of the collaboration agreement, required for legal records and partner relationship management.. Valid values are `mutual_agreement|breach_of_contract|project_completion|funding_withdrawal|regulatory_issue|partner_insolvency|strategic_change|other`',
    `title` STRING COMMENT 'Official title or name of the collaboration agreement as stated in the executed legal document.',
    `total_agreement_value` DECIMAL(18,2) COMMENT 'Total monetary value of the collaboration agreement representing the combined financial commitment from all parties over the agreement term.',
    CONSTRAINT pk_collaboration_agreement PRIMARY KEY(`collaboration_agreement_id`)
) COMMENT 'Master record for formal collaboration agreements established with external research partners for joint R&D activities. Captures agreement type (JDA - Joint Development Agreement, CRA - Collaborative Research Agreement, consortium membership, sponsored research), agreement start and end dates, IP ownership terms, cost-sharing structure, confidentiality provisions, publication rights, and agreement status. Manages the contractual framework governing external R&D partnerships.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`rd_budget` (
    `rd_budget_id` BIGINT COMMENT 'Unique system-generated identifier for each R&D budget authorization record. Serves as the primary key for the rd_budget data product.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: R&D budgets are allocated to specific cost centers for financial tracking and reporting. Finance controllers use this daily to monitor R&D spending against organizational cost structures.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: An R&D budget authorization belongs to an R&D project. This is a child→parent relationship (many budget records per project across fiscal years). rd_budget has no FK to rd_project. Adding rd_project_i',
    `actual_spend` DECIMAL(18,2) COMMENT 'The cumulative actual expenditure posted against this R&D budget authorization to date, sourced from the ERP financial postings. Used for budget utilization tracking and variance analysis.',
    `approval_date` DATE COMMENT 'The date on which the budget authorization was formally approved by the designated authority (e.g., R&D portfolio committee, CFO, or business unit head). Marks the start of authorized spend eligibility.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `approved_amount` DECIMAL(18,2) COMMENT 'The total authorized budget amount for this R&D budget record, as approved through the stage-gate or portfolio governance process. Represents the maximum authorized spend for the defined scope, category, and fiscal period.',
    `approved_amount_usd` DECIMAL(18,2) COMMENT 'The approved budget amount converted to US Dollars (USD) using the applicable exchange rate at the time of approval. Enables consolidated global R&D portfolio investment reporting in a common currency.',
    `approved_by` STRING COMMENT 'Name or identifier of the individual or governance body that formally approved the budget authorization (e.g., R&D Portfolio Committee, VP Engineering, CFO). Supports audit trail and accountability requirements.',
    `apqp_phase` STRING COMMENT 'The Advanced Product Quality Planning (APQP) phase associated with this R&D budget, where applicable. Links R&D investment to the structured product development lifecycle used in automotive and industrial manufacturing quality planning.. Valid values are `phase_1_planning|phase_2_product_design|phase_3_process_design|phase_4_product_validation|phase_5_launch|not_applicable`',
    `budget_category` STRING COMMENT 'Classification of the budget by expenditure type. Enables granular tracking of R&D spend across labor, materials, external services, capital equipment, travel, and other cost categories for portfolio investment governance.. Valid values are `labor|materials|external_services|capital_equipment|travel|overhead|software_licenses|prototype_tooling|testing_and_validation|intellectual_property`',
    `budget_code` STRING COMMENT 'Human-readable, business-facing unique code for the budget authorization record, used for cross-system referencing and reporting. Typically structured to encode fiscal year and project identifiers.. Valid values are `^RDB-[A-Z0-9]{4}-[0-9]{4}-[0-9]{4}$`',
    `budget_name` STRING COMMENT 'Descriptive name of the R&D budget authorization, typically referencing the associated project, program, or initiative for which the budget is approved.',
    `budget_revision_number` STRING COMMENT 'Sequential revision counter tracking the number of times this budget authorization has been formally amended. Version 0 represents the original approved budget; subsequent revisions reflect supplemental approvals, reductions, or reallocation adjustments.. Valid values are `^[0-9]+$`',
    `budget_type` STRING COMMENT 'Classifies the nature of the budget authorization. Original is the initial approved budget; Supplemental represents additional funding approved mid-cycle; Revised reflects formal amendments; Carryover represents unspent prior-year budget rolled forward.. Valid values are `original|supplemental|revised|carryover|contingency|emergency`',
    `business_unit` STRING COMMENT 'The business unit or division responsible for this R&D budget authorization. Used for organizational-level R&D investment reporting and portfolio governance across the multinational enterprise.',
    `committed_spend` DECIMAL(18,2) COMMENT 'The total value of purchase orders, contracts, and other financial commitments raised against this budget that have not yet been invoiced or posted as actual spend. Represents obligated but not yet realized expenditure.',
    `cost_center` STRING COMMENT 'The SAP cost center code to which this R&D budget is assigned for financial controlling and cost allocation purposes. Enables departmental R&D spend tracking and internal charge-back.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code identifying the country where the R&D activity is being conducted. Supports country-level R&D tax credit eligibility assessment, regulatory compliance, and geographic investment reporting.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'The timestamp when this R&D budget authorization record was first created in the system. Used for audit trail, data lineage, and compliance reporting.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code in which the budget amounts are denominated (e.g., USD, EUR, GBP). Supports multi-currency R&D portfolio management across global operations.. Valid values are `^[A-Z]{3}$`',
    `effective_end_date` DATE COMMENT 'The date on which the budget authorization expires and no further expenditures can be charged. Typically aligns with fiscal year end, project completion milestone, or grant expiry date.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `effective_start_date` DATE COMMENT 'The date from which the approved budget becomes effective and expenditures can be charged against it. May align with fiscal year start, project kickoff, or grant commencement date.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}$`',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The exchange rate applied to convert the budget currency to USD at the time of budget approval or last revaluation. Used for multi-currency budget consolidation and variance reporting.',
    `expenditure_type` STRING COMMENT 'Classifies the R&D budget authorization as Capital Expenditure (CAPEX) or Operational Expenditure (OPEX) in accordance with accounting standards. Critical for financial reporting, tax treatment, and balance sheet vs. income statement classification of R&D investments.. Valid values are `CAPEX|OPEX`',
    `fiscal_period` STRING COMMENT 'The fiscal period granularity within the fiscal year for which this budget is authorized (e.g., Q1, Q2, H1, FY for full-year, or monthly period M01–M12). Supports phased budget tracking.. Valid values are `^(Q[1-4]|H[12]|FY|M(0[1-9]|1[0-2]))$`',
    `fiscal_year` STRING COMMENT 'The fiscal year to which this budget authorization applies. Used for annual R&D investment governance, portfolio planning, and CAPEX/OPEX classification reporting.. Valid values are `^[0-9]{4}$`',
    `funding_source` STRING COMMENT 'Identifies the origin of funding for this R&D budget authorization. Distinguishes between internal R&D fund allocations, government grants (e.g., EU Horizon, national programs), customer-funded development contracts, and other external funding mechanisms.. Valid values are `internal_rd_fund|government_grant|customer_funded|joint_venture|venture_capital|innovation_fund|eu_horizon_grant|other`',
    `grant_reference_number` STRING COMMENT 'Official reference number assigned by the granting authority (e.g., EU Horizon grant number, national R&D fund reference) for government-funded R&D budgets. Required for grant compliance reporting and audit.',
    `internal_order_number` STRING COMMENT 'SAP internal order number used to collect and settle R&D costs for specific initiatives that do not require a full project structure. Commonly used for smaller R&D activities, feasibility studies, or pre-project investigations.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'The timestamp of the most recent modification to this R&D budget authorization record. Supports change tracking, audit compliance, and incremental data loading in the Silver Layer.. Valid values are `^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$`',
    `notes` STRING COMMENT 'Free-text field for capturing additional context, justification, approval conditions, or special instructions associated with this R&D budget authorization. Used by budget owners and finance controllers for governance documentation.',
    `portfolio_category` STRING COMMENT 'Strategic classification of the R&D investment within the portfolio governance framework. Distinguishes between core technology development, adjacent innovation, transformational/disruptive research, sustaining engineering, and regulatory compliance activities.. Valid values are `core_technology|adjacent_innovation|transformational|sustaining_engineering|regulatory_compliance|customer_funded|exploratory_research`',
    `rd_tax_credit_eligible` BOOLEAN COMMENT 'Indicates whether this R&D budget authorization qualifies for R&D tax credits or incentives under applicable national tax legislation (e.g., US R&D Tax Credit IRC Section 41, UK R&D Tax Relief, EU national schemes). Supports tax planning and compliance reporting.. Valid values are `true|false`',
    `remaining_budget` DECIMAL(18,2) COMMENT 'The unencumbered budget balance available for future spend, calculated as approved amount minus actual spend minus committed spend. Supports real-time budget availability checks and portfolio reallocation decisions.',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which this R&D budget record was sourced (e.g., SAP S/4HANA PS/CO, Siemens Teamcenter PLM). Supports data lineage tracking and reconciliation in the Databricks Silver Layer.. Valid values are `SAP_S4HANA|TEAMCENTER|MANUAL|OTHER`',
    `stage_gate_phase` STRING COMMENT 'The stage-gate process phase at which this budget authorization was created or is currently active. Supports R&D portfolio governance by linking budget authorizations to specific innovation funnel stages.. Valid values are `ideation|scoping|business_case|development|testing|launch|post_launch|not_applicable`',
    `status` STRING COMMENT 'Current lifecycle status of the R&D budget authorization. Drives workflow routing, spend control enforcement, and portfolio reporting. Active indicates the budget is open for spend; Closed indicates the budget period has ended.. Valid values are `draft|pending_approval|approved|active|on_hold|closed|cancelled|over_budget|under_review`',
    `technology_domain` STRING COMMENT 'The primary technology domain to which this R&D budget is allocated. Aligns with the companys strategic technology roadmap areas including automation, electrification, smart infrastructure, and Industrial Internet of Things (IIoT).. Valid values are `automation|electrification|smart_infrastructure|digital_manufacturing|iiot|robotics|energy_management|cybersecurity|materials_science|software_platform|other`',
    `wbs_element` STRING COMMENT 'The Work Breakdown Structure (WBS) element code from SAP PS that links this budget authorization to a specific project deliverable or work package. Enables project-level budget tracking and earned value analysis.',
    CONSTRAINT pk_rd_budget PRIMARY KEY(`rd_budget_id`)
) COMMENT 'Master record for R&D project and portfolio budget authorizations. Captures approved budget amount by fiscal year, budget category (labor, materials, external services, capital equipment, travel), funding source (internal R&D fund, government grant, customer-funded development), actual spend-to-date, committed spend, remaining budget, and budget status. Supports R&D portfolio investment governance and CAPEX/OPEX classification of R&D expenditures.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`rd_expense` (
    `rd_expense_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each individual R&D expenditure transaction record in the silver layer lakehouse.',
    `billing_invoice_id` BIGINT COMMENT 'Foreign key linking to billing.invoice. Business justification: R&D expenses often originate from vendor invoices (lab equipment, materials, consulting services). Accounting tracks which supplier invoice generated each R&D expense for audit and cost allocation.',
    `cost_center_id` BIGINT COMMENT 'Foreign key linking to finance.cost_center. Business justification: Each R&D expense must be charged to a cost center for financial accounting. AP teams process these expenses daily against authorized cost centers for budget control.',
    `cost_object_internal_order_id` BIGINT COMMENT 'The specific SAP CO cost object identifier (e.g., internal order number, WBS element ID, or network activity number) to which the expense is posted. Primary SAP reference for cost allocation.',
    `freight_invoice_id` BIGINT COMMENT 'Foreign key linking to logistics.freight_invoice. Business justification: R&D projects incur freight costs for prototype shipments, equipment moves, and material testing samples. Finance requires freight invoice linkage for R&D cost accounting and project budget tracking.',
    `gl_account_id` BIGINT COMMENT 'Foreign key linking to finance.gl_account. Business justification: R&D expenses post to specific GL accounts (e.g., 6200-Research Materials, 6210-Lab Supplies). Accounting teams use this for financial statement preparation and audit trails.',
    `internal_order_id` BIGINT COMMENT 'Foreign key linking to finance.internal_order. Business justification: R&D expenses are charged to internal orders for project-level cost accumulation. Finance uses this to track actual costs against project budgets and calculate WIP.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: R&D expenses for materials, equipment, and services are procured through formal purchase orders. Finance tracks R&D spending against POs for budget control and cost allocation to projects.',
    `rd_budget_id` BIGINT COMMENT 'Foreign key linking to research.rd_budget. Business justification: An R&D expense transaction is charged against an R&D budget authorization. This is a child→parent relationship enabling budget vs. actual spend tracking. rd_expense has no FK to rd_budget. Adding rd_b',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: An R&D expense transaction is charged against an R&D project. rd_expense has rd_project_code (string) as a denormalized reference. Adding rd_project_id as a proper FK normalizes this relationship and ',
    `supplier_id` BIGINT COMMENT 'SAP Ariba or SAP S/4HANA vendor master identifier for external supplier expenses (e.g., contract research organizations, testing labs, prototype fabricators). Blank for internal cost center charges.',
    `amount` DECIMAL(18,2) COMMENT 'The gross monetary value of the R&D expenditure in the transaction currency. Represents the actual cost charged to the R&D project budget before any currency conversion.',
    `amount_usd` DECIMAL(18,2) COMMENT 'The R&D expense amount converted to US Dollars using the applicable exchange rate at the time of posting. Enables consolidated global R&D spend reporting across all legal entities.',
    `approval_status` STRING COMMENT 'Current workflow approval status of the R&D expense transaction. Drives financial posting eligibility and budget commitment tracking in SAP S/4HANA.. Valid values are `pending|approved|rejected|on_hold|cancelled`',
    `approved_by` STRING COMMENT 'Employee ID of the manager or budget owner who approved the R&D expense. Supports segregation of duties compliance and audit trail requirements.',
    `approved_timestamp` TIMESTAMP COMMENT 'Date and time when the R&D expense was formally approved by the authorized approver. Used for approval cycle time analytics and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `apqp_phase` STRING COMMENT 'The APQP stage-gate phase during which the R&D expense was incurred. Enables cost tracking by APQP phase for product development cost analysis and stage-gate financial reviews.. Valid values are `phase_1_plan_and_define|phase_2_product_design|phase_3_process_design|phase_4_product_validation|phase_5_launch_and_feedback|not_applicable`',
    `capitalization_justification` STRING COMMENT 'Free-text justification documenting why the expense meets IAS 38 development phase capitalization criteria (technical feasibility, intention to complete, ability to use/sell, probable future economic benefits, adequate resources, ability to measure reliably). Required for audit and tax compliance.',
    `cost_center` STRING COMMENT 'SAP S/4HANA CO cost center to which the R&D expense is allocated. Identifies the organizational unit responsible for the expenditure for internal cost accounting and departmental budget tracking.',
    `cost_object_type` STRING COMMENT 'Type of SAP CO cost object to which the expense is assigned. Determines the controlling object hierarchy and reporting structure for R&D cost accounting.. Valid values are `wbs_element|internal_order|cost_center|network_activity|production_order`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the R&D expense was incurred. Supports country-level R&D tax credit eligibility analysis (e.g., R&D tax incentives in USA, DEU, GBR, CHN).. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the R&D expense record was first created in the source system. Used for data lineage, audit trail, and silver layer ingestion tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code of the transaction currency in which the expense was incurred (e.g., USD, EUR, CNY). Supports multi-currency R&D cost management for multinational operations.. Valid values are `^[A-Z]{3}$`',
    `description` STRING COMMENT 'Free-text narrative describing the nature and business purpose of the R&D expenditure. Required for audit trail and IAS 38 capitalization justification documentation.',
    `exchange_rate` DECIMAL(18,2) COMMENT 'The foreign exchange rate applied to convert the transaction currency amount to USD at the time of posting. Sourced from SAP S/4HANA exchange rate tables.',
    `expense_category` STRING COMMENT 'Classification of the R&D expenditure by cost type. Drives IAS 38 capitalization eligibility assessment and supports cost-by-category analytics for R&D portfolio management.. Valid values are `labor|materials|equipment|software_licenses|external_services|travel|prototype_fabrication|testing_and_validation|patent_and_legal|overhead|other`',
    `expense_date` DATE COMMENT 'The calendar date on which the R&D expenditure was incurred or the cost was recognized. Used for period-end cost accruals and IAS 38 capitalization timing.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expense_number` STRING COMMENT 'Business-facing unique document number assigned to the R&D expense transaction, typically sourced from SAP S/4HANA CO/FI document numbering. Used for audit trail and cross-system reconciliation.. Valid values are `^RDE-[0-9]{4}-[0-9]{6}$`',
    `expense_subcategory` STRING COMMENT 'Further granular classification within the expense category (e.g., within labor: engineering, testing, project management; within materials: raw materials, consumables). Supports detailed cost analytics.',
    `fiscal_period` STRING COMMENT 'The accounting period (month 1–12) within the fiscal year in which the expense is posted. Used for monthly budget variance reporting and period-end close.. Valid values are `^([1-9]|1[0-2])$`',
    `fiscal_year` STRING COMMENT 'The fiscal year in which the R&D expense is recognized for financial reporting and budget tracking purposes.. Valid values are `^[0-9]{4}$`',
    `is_capitalized` BOOLEAN COMMENT 'Indicates whether the R&D expense is classified as Capital Expenditure (CAPEX) to be capitalized on the balance sheet per IAS 38 development phase criteria, or as Operational Expenditure (OPEX) to be expensed immediately. True = CAPEX; False = OPEX.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the R&D expense record in the source system. Supports incremental data loading, change detection, and audit trail in the lakehouse.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `legal_entity_code` STRING COMMENT 'Code identifying the legal entity (company code in SAP) incurring the R&D expense. Critical for multinational R&D cost allocation, transfer pricing compliance, and statutory financial reporting.',
    `posting_date` DATE COMMENT 'The date on which the expense was posted to the general ledger in SAP S/4HANA. May differ from expense_date due to period-end close timing or late submissions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `purchase_order_number` STRING COMMENT 'SAP MM purchase order number associated with the R&D expense for externally procured goods or services. Links the expense to the procurement process and goods receipt.',
    `sap_document_number` STRING COMMENT 'The SAP S/4HANA FI/CO accounting document number generated upon posting of the R&D expense. Primary reference for cross-system reconciliation and audit trail back to the ERP system of record.',
    `source_system` STRING COMMENT 'Identifies the operational system of record from which the R&D expense transaction was sourced (e.g., SAP S/4HANA CO/FI, SAP Ariba). Supports data lineage tracking in the lakehouse silver layer.. Valid values are `SAP_S4HANA|SAP_ARIBA|MANUAL|OTHER`',
    `tax_credit_eligible` BOOLEAN COMMENT 'Indicates whether the R&D expense qualifies for government R&D tax credits or incentives (e.g., US R&D Tax Credit IRC Section 41, UK R&D Relief, German R&D Tax Incentive Act). Supports tax planning and compliance reporting.. Valid values are `true|false`',
    `technology_domain` STRING COMMENT 'The technology domain or innovation area to which the R&D expense relates. Supports R&D investment analysis by technology portfolio (e.g., automation, electrification, smart infrastructure) aligned with corporate technology roadmaps.. Valid values are `automation|electrification|smart_infrastructure|digital_twin|iiot|robotics|power_electronics|software_embedded|materials|other`',
    `vendor_name` STRING COMMENT 'Name of the external vendor or supplier associated with the R&D expense. Supports vendor spend analysis and supplier relationship management for R&D procurement.',
    `wbs_element` STRING COMMENT 'SAP PS Work Breakdown Structure element code identifying the specific project task or deliverable against which the expense is charged. Enables granular project cost tracking at the work package level.',
    CONSTRAINT pk_rd_expense PRIMARY KEY(`rd_expense_id`)
) COMMENT 'Transactional record capturing individual R&D expenditure transactions charged against an R&D project budget. Captures expense date, expense category, vendor or cost center, amount, currency, SAP cost object reference, expense description, approval status, and capitalization flag (CAPEX vs. OPEX per IAS 38 R&D capitalization rules). Provides the detailed spend audit trail for R&D project cost accounting.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`grant_funding` (
    `grant_funding_id` BIGINT COMMENT 'Unique system-generated identifier for each grant funding master record within the Manufacturing R&D portfolio.',
    `bank_account_id` BIGINT COMMENT 'Foreign key linking to finance.bank_account. Business justification: Grant funds are received into specific bank accounts and must be tracked separately for compliance and audit. Treasury teams reconcile grant receipts daily against these accounts.',
    `credit_note_id` BIGINT COMMENT 'Foreign key linking to billing.credit_note. Business justification: Government grants may issue credit notes for adjustments or partial refunds of R&D funding. Finance links these to grant records for accurate funding reconciliation and compliance reporting.',
    `obligation_id` BIGINT COMMENT 'Foreign key linking to compliance.compliance_obligation. Business justification: Government grants impose specific compliance obligations (reporting, audits, IP rights, domestic sourcing). Finance and R&D track these obligations to ensure grant terms are met and funding isnt jeop',
    `rd_budget_id` BIGINT COMMENT 'Foreign key linking to research.rd_budget. Business justification: Grant funding contributes to and is tracked against an R&D budget authorization. grant_funding has no FK to rd_budget. Adding rd_budget_id establishes the link between external grant receipts and the ',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: Grant funding is received to support specific R&D projects. This is a child→parent relationship (a grant may fund a specific project). grant_funding has no FK to rd_project. Adding rd_project_id enabl',
    `agreement_signed_date` DATE COMMENT 'Date on which the grant agreement was formally executed and signed by both Manufacturing and the funding agency, making the award legally binding.. Valid values are `^d{4}-d{2}-d{2}$`',
    `application_submission_date` DATE COMMENT 'Date on which Manufacturing formally submitted the grant application to the funding agency.. Valid values are `^d{4}-d{2}-d{2}$`',
    `audit_requirement` STRING COMMENT 'Type of financial or compliance audit required by the funding agency for this grant (e.g., no audit, internal audit only, independent external auditor, agency-conducted audit, or Single Audit under 2 CFR 200 Subpart F).. Valid values are `none|internal_only|external_auditor|agency_audit|single_audit`',
    `award_date` DATE COMMENT 'Date on which the funding agency officially notified Manufacturing of the grant award decision.. Valid values are `^d{4}-d{2}-d{2}$`',
    `awarded_amount` DECIMAL(18,2) COMMENT 'Total monetary amount awarded by the funding agency under this grant, expressed in the grants base currency. Represents the maximum eligible funding commitment.',
    `awarded_amount_usd` DECIMAL(18,2) COMMENT 'Awarded grant amount converted to US Dollars (USD) using the exchange rate at the time of award, to support consolidated global R&D investment reporting.',
    `co_funding_rate_pct` DECIMAL(18,2) COMMENT 'Percentage of eligible project costs covered by the grant (funding intensity rate). The remaining percentage represents Manufacturings own contribution or co-funding obligation.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `compliance_standards` STRING COMMENT 'Comma-separated list of regulatory, environmental, or ethical compliance standards that must be adhered to as a condition of the grant (e.g., REACH, RoHS, ISO 14001, GDPR, export control regulations, ethics requirements).',
    `consortium_role` STRING COMMENT 'Manufacturings role within the grant consortium (e.g., coordinator, partner, associate partner), which determines governance responsibilities and reporting obligations.. Valid values are `coordinator|partner|associate_partner|subcontractor|observer`',
    `cost_center` STRING COMMENT 'SAP cost center code to which grant-funded expenditures are assigned for internal financial reporting and controlling purposes.',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the primary jurisdiction or country in which the grant-funded R&D activities are being conducted.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the grant funding master record was first created in the system, used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the awarded amount and all financial values recorded on this grant (e.g., EUR, USD, GBP).. Valid values are `^[A-Z]{3}$`',
    `disbursement_schedule_type` STRING COMMENT 'Structure of how grant funds are disbursed to Manufacturing by the funding agency (e.g., upfront lump sum, milestone-based tranches, periodic installments, or cost reimbursement).. Valid values are `upfront_lump_sum|milestone_based|periodic_installment|reimbursement|advance_plus_balance`',
    `eligible_cost_categories` STRING COMMENT 'Comma-separated list of cost categories that are eligible for reimbursement under the grant (e.g., personnel costs, subcontracting, equipment, travel, indirect costs/overheads), as defined in the grant agreement.',
    `external_partner_involved` BOOLEAN COMMENT 'Indicates whether the grant involves collaboration with external research partners, universities, or consortium members outside of Manufacturing.. Valid values are `true|false`',
    `final_report_due_date` DATE COMMENT 'Deadline for submission of the final technical and financial report to the funding agency upon completion of the grant period.. Valid values are `^d{4}-d{2}-d{2}$`',
    `funding_agency` STRING COMMENT 'Name of the government body, public institution, or intergovernmental organization that awarded the grant (e.g., European Commission, U.S. Department of Energy, NIST, Innovate UK, BMBF).',
    `funding_instrument_type` STRING COMMENT 'Classification of the funding instrument used (e.g., research grant, innovation action, cooperative agreement, subsidy, loan guarantee) as defined by the funding agency.. Valid values are `research_grant|innovation_action|collaborative_project|framework_agreement|cooperative_agreement|loan_guarantee|tax_credit|subsidy|fellowship|prize`',
    `grant_end_date` DATE COMMENT 'Official end date of the grant period as defined in the grant agreement, after which no further eligible costs may be incurred unless an extension is approved.. Valid values are `^d{4}-d{2}-d{2}$`',
    `grant_manager` STRING COMMENT 'Name of the internal Manufacturing employee responsible for overall grant management, compliance, reporting, and liaison with the funding agency.',
    `grant_reference_number` STRING COMMENT 'Official reference or award number assigned by the funding agency to uniquely identify the grant (e.g., EU Horizon grant agreement number, DOE award number, NIST MEP project number).',
    `grant_start_date` DATE COMMENT 'Official start date of the grant period as defined in the grant agreement, from which eligible costs may be incurred.. Valid values are `^d{4}-d{2}-d{2}$`',
    `indirect_cost_rate_pct` DECIMAL(18,2) COMMENT 'Approved overhead or indirect cost rate (as a percentage of direct costs) applicable to this grant, as negotiated with or mandated by the funding agency.. Valid values are `^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$`',
    `ip_ownership_terms` STRING COMMENT 'Terms governing ownership of intellectual property (IP) generated under the grant, as stipulated in the grant agreement (e.g., Manufacturing-owned, jointly owned with consortium, open access mandate).. Valid values are `manufacturing_owned|jointly_owned|agency_owned|open_access|licensed_back|to_be_negotiated`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the grant funding record, supporting change tracking, audit compliance, and Silver layer data freshness monitoring.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `legal_entity_name` STRING COMMENT 'Name of the Manufacturing legal entity that is the formal grant recipient and signatory to the grant agreement (relevant for multinational structures where different subsidiaries may hold grants).',
    `manufacturing_contribution_amount` DECIMAL(18,2) COMMENT 'Monetary amount that Manufacturing is obligated to contribute as co-funding or matching funds alongside the grant award, in the grants base currency.',
    `next_report_due_date` DATE COMMENT 'Date by which the next mandatory progress or financial report must be submitted to the funding agency to remain in compliance with grant obligations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `notes` STRING COMMENT 'Free-text field for capturing additional context, special conditions, amendments, or operational notes relevant to the management of this grant funding record.',
    `open_access_required` BOOLEAN COMMENT 'Indicates whether the grant agreement mandates open access publication of research results, data, or outputs as a compliance obligation.. Valid values are `true|false`',
    `owning_business_unit` STRING COMMENT 'Internal Manufacturing business unit or division responsible for executing the grant-funded R&D activities and managing compliance obligations.',
    `principal_investigator` STRING COMMENT 'Name of the lead scientist, engineer, or researcher at Manufacturing designated as the principal investigator (PI) responsible for the technical execution of the grant-funded project.',
    `program_name` STRING COMMENT 'Official name of the public funding program or grant scheme under which the award was made (e.g., Horizon Europe, DOE Office of Energy Efficiency, NIST MEP, Innovate UK).',
    `reporting_frequency` STRING COMMENT 'Frequency at which Manufacturing is obligated to submit progress, financial, or technical reports to the funding agency as stipulated in the grant agreement.. Valid values are `monthly|quarterly|semi_annual|annual|milestone_based|final_only`',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this grant funding data was sourced (e.g., SAP S/4HANA PS, internal grant management system, EU Participant Portal).',
    `status` STRING COMMENT 'Current lifecycle status of the grant funding record, from initial application through award, active execution, and final closure.. Valid values are `applied|under_review|awarded|active|suspended|completed|closed|rejected|withdrawn`',
    `technology_domain` STRING COMMENT 'Primary technology domain or innovation area that the grant-funded R&D activity addresses, aligned with Manufacturings strategic technology pillars (e.g., automation, electrification, smart infrastructure).. Valid values are `automation|electrification|smart_infrastructure|digitalization|energy_management|advanced_manufacturing|cybersecurity|materials|robotics|other`',
    `total_claimed_amount` DECIMAL(18,2) COMMENT 'Cumulative amount of eligible costs claimed by Manufacturing against the grant to date, submitted to the funding agency for reimbursement or verification.',
    `total_disbursed_amount` DECIMAL(18,2) COMMENT 'Cumulative amount of grant funds actually received/disbursed to Manufacturing from the funding agency to date, in the grants base currency.',
    `wbs_element` STRING COMMENT 'SAP Work Breakdown Structure (WBS) element code used to track and allocate grant-funded costs within the ERP financial controlling module.',
    CONSTRAINT pk_grant_funding PRIMARY KEY(`grant_funding_id`)
) COMMENT 'Master record for government grants, public funding programs, and subsidized R&D funding received by Manufacturing for innovation projects. Captures grant program name, funding agency, grant reference number, awarded amount, currency, eligible cost categories, reporting obligations, compliance requirements, grant period, and disbursement schedule. Supports management of EU Horizon, DOE, NIST MEP, and other public R&D funding instruments.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`lab_resource` (
    `lab_resource_id` BIGINT COMMENT 'Unique system-generated identifier for each laboratory resource record in the R&D lab resource master.',
    `employee_id` BIGINT COMMENT 'Employee ID of the laboratory manager responsible for this resource. Used for system-level accountability, access control, and HR system cross-referencing.. Valid values are `^[A-Z0-9-]{3,20}$`',
    `ppe_requirement_id` BIGINT COMMENT 'Foreign key linking to hse.ppe_requirement. Business justification: Lab equipment and workstations have specific PPE requirements (safety glasses, gloves, respirators). HSE defines mandatory protective equipment for each lab resource based on hazard exposure levels.',
    `procurement_purchase_order_id` BIGINT COMMENT 'Foreign key linking to procurement.purchase_order. Business justification: Lab equipment and resources are capital assets procured through purchase orders. Asset management tracks the originating PO for warranty, maintenance contracts, and depreciation calculations.',
    `responsible_lab_manager_employee_id` BIGINT COMMENT 'FK to workforce.employee',
    `acquisition_cost_usd` DECIMAL(18,2) COMMENT 'Original purchase or acquisition cost of the laboratory resource in US dollars. Used for capital expenditure (CAPEX) tracking, asset valuation, and depreciation reporting.',
    `applicable_standards` STRING COMMENT 'Comma-separated list of industry or regulatory standards that this resource is qualified to support (e.g., IEC 61131, IEC 62443, UL 508A). Used in test plan feasibility checks.',
    `asset_tag` STRING COMMENT 'Internal fixed asset tag number assigned by the companys asset management system (Maximo EAM / SAP PM). Links the lab resource to the enterprise asset register for financial and maintenance tracking.. Valid values are `^[A-Z0-9-]{4,20}$`',
    `availability_schedule` STRING COMMENT 'Standard availability schedule pattern for the laboratory resource, indicating when it can be booked for test campaigns or prototype builds. Supports automated scheduling in Siemens Opcenter MES.. Valid values are `24x7|weekdays_only|day_shift|night_shift|custom|on_request`',
    `building` STRING COMMENT 'Building identifier or name within the site where the laboratory resource is housed (e.g., Building 7, R&D Block C). Used for physical resource location and logistics.',
    `calibration_certificate_number` STRING COMMENT 'Reference number of the most recent calibration certificate issued for this laboratory resource. Required for traceability audits and regulatory compliance documentation.',
    `calibration_interval_days` STRING COMMENT 'Defined periodic interval in days between required calibrations for this resource. Set based on manufacturer recommendations, usage intensity, and regulatory requirements.. Valid values are `^[1-9][0-9]*$`',
    `calibration_required` BOOLEAN COMMENT 'Indicates whether this laboratory resource requires periodic calibration to maintain measurement traceability. Mandatory for measurement instruments per ISO/IEC 17025 and regulatory compliance.. Valid values are `true|false`',
    `calibration_status` STRING COMMENT 'Current calibration status of the laboratory resource. Resources with overdue or expired calibration must not be used for measurement activities per ISO/IEC 17025 requirements.. Valid values are `calibrated|due_for_calibration|overdue|not_required|in_calibration`',
    `capacity_description` STRING COMMENT 'Textual description of the resources capacity or throughput capability (e.g., Max load: 500 kg, Temperature range: -70°C to +180°C, Up to 3 simultaneous DUT). Supports test campaign feasibility assessment.',
    `commissioning_date` DATE COMMENT 'Date on which the laboratory resource was formally commissioned and made available for use in R&D activities. Marks the start of the operational lifecycle for scheduling and compliance purposes.. Valid values are `^d{4}-d{2}-d{2}$`',
    `cost_center` STRING COMMENT 'SAP cost center code to which the operating costs of this laboratory resource are charged. Enables financial tracking of R&D lab resource expenditure.. Valid values are `^[A-Z0-9-]{4,15}$`',
    `country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the laboratory resource is physically located. Supports multinational regulatory compliance and resource planning.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the laboratory resource record was first created in the system. Used for audit trail, data lineage, and compliance reporting.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `decommission_date` DATE COMMENT 'Date on which the laboratory resource was or is planned to be decommissioned and removed from active service. Used for asset lifecycle planning and replacement scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `description` STRING COMMENT 'Detailed narrative description of the laboratory resource including its purpose, technical specifications summary, and primary use cases within R&D test campaigns.',
    `laboratory_name` STRING COMMENT 'Name of the laboratory or lab facility where the resource is physically located (e.g., Electrification Test Lab, Automation R&D Center). Supports multi-site lab resource planning.',
    `last_calibration_date` DATE COMMENT 'Date on which the most recent calibration of the laboratory resource was completed. Used to determine calibration currency and schedule next calibration.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_maintenance_date` DATE COMMENT 'Date on which the most recent preventive or corrective maintenance was performed on this laboratory resource. Used to assess equipment health and schedule next maintenance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the laboratory resource record. Used for change tracking, data freshness monitoring, and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `manufacturer` STRING COMMENT 'Name of the original equipment manufacturer (OEM) of the laboratory resource. Used for maintenance, spare parts sourcing, and calibration certificate validation.',
    `max_concurrent_bookings` STRING COMMENT 'Maximum number of simultaneous test campaigns or prototype builds that can be scheduled on this resource at the same time. Drives scheduling conflict detection in lab resource planning.. Valid values are `^[1-9][0-9]*$`',
    `model_number` STRING COMMENT 'Manufacturers model or part number for the laboratory resource. Used for procurement, spare parts identification, and technical documentation lookup.',
    `name` STRING COMMENT 'Descriptive name of the laboratory resource (e.g., High-Voltage Test Bench 3, Thermal Shock Chamber A). Used in scheduling interfaces and lab resource planning.',
    `next_calibration_due_date` DATE COMMENT 'Scheduled date by which the next calibration of the laboratory resource must be completed. Drives calibration planning and prevents use of out-of-calibration equipment in test campaigns.. Valid values are `^d{4}-d{2}-d{2}$`',
    `next_maintenance_due_date` DATE COMMENT 'Scheduled date for the next planned preventive maintenance activity on this laboratory resource. Drives maintenance planning and resource availability forecasting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `owning_department` STRING COMMENT 'Name of the R&D department or business unit that owns and is accountable for this laboratory resource. Used for cost allocation, budgeting, and resource governance.',
    `permit_to_work_required` BOOLEAN COMMENT 'Indicates whether a formal permit-to-work (PTW) is required before operating or maintaining this laboratory resource. Mandatory for high-voltage, hazardous, or confined-space equipment per OSHA and ISO 45001.. Valid values are `true|false`',
    `resource_category` STRING COMMENT 'Broad technical discipline category of the resource, used for domain-based filtering and assignment to R&D projects in automation, electrification, or smart infrastructure.. Valid values are `mechanical|electrical|electronic|thermal|environmental|optical|chemical|software|mixed`',
    `resource_code` STRING COMMENT 'Human-readable alphanumeric code uniquely identifying the lab resource, used for cross-system referencing and scheduling (e.g., TB-001, ETC-042). Sourced from Maximo EAM asset numbering conventions.. Valid values are `^[A-Z0-9-]{3,20}$`',
    `resource_type` STRING COMMENT 'Classification of the laboratory resource by its functional category. Drives scheduling rules, calibration requirements, and resource allocation logic in R&D planning.. Valid values are `test_bench|measurement_instrument|environmental_chamber|simulation_rig|prototype_assembly_station|data_acquisition_system|climatic_chamber|vibration_rig|anechoic_chamber|other`',
    `room_number` STRING COMMENT 'Specific room or bay number within the building where the resource is installed. Enables precise physical location tracking for lab scheduling and maintenance.',
    `safety_classification` STRING COMMENT 'Safety classification of the laboratory resource based on the hazards associated with its operation. Drives safety permit requirements, PPE mandates, and access control per OSHA and ISO 45001.. Valid values are `standard|high_voltage|hazardous_materials|radiation|cryogenic|high_pressure|biological|none`',
    `scheduled_downtime_hours_per_week` DECIMAL(18,2) COMMENT 'Average number of hours per week the resource is planned to be unavailable due to scheduled maintenance, calibration, or preventive activities. Used in capacity planning for test campaigns.',
    `serial_number` STRING COMMENT 'Manufacturer-assigned serial number uniquely identifying the physical equipment unit. Required for warranty tracking, calibration records, and regulatory compliance.',
    `site_code` STRING COMMENT 'Code identifying the physical manufacturing or R&D site where the laboratory resource is located. Supports multi-site resource planning and geographic reporting.. Valid values are `^[A-Z0-9-]{2,10}$`',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this laboratory resource record was sourced (e.g., Maximo EAM, SAP S/4HANA PM). Supports data lineage and integration traceability in the Databricks Silver layer.. Valid values are `Maximo|SAP_S4HANA|Teamcenter|Opcenter|MindSphere|Manual|Other`',
    `status` STRING COMMENT 'Current operational status of the laboratory resource. Drives availability logic in lab scheduling systems and prevents booking of resources that are unavailable.. Valid values are `available|in_use|under_calibration|under_maintenance|out_of_service|decommissioned|reserved`',
    `technology_domain` STRING COMMENT 'Primary technology domain for which this laboratory resource is used. Aligns with the companys core R&D focus areas in automation, electrification, and smart infrastructure.. Valid values are `automation|electrification|smart_infrastructure|power_electronics|drives|sensors|robotics|software|cross_domain|other`',
    CONSTRAINT pk_lab_resource PRIMARY KEY(`lab_resource_id`)
) COMMENT 'Master record for R&D laboratory resources including test benches, specialized measurement instruments, environmental test chambers, simulation rigs, and dedicated R&D equipment. Captures resource name, resource type, laboratory location, capacity, calibration status, availability schedule, responsible lab manager, and associated asset reference. Supports lab resource planning and scheduling for prototype builds and test campaigns.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`lab_booking` (
    `lab_booking_id` BIGINT COMMENT 'Unique system-generated identifier for each laboratory resource booking record in the R&D domain.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Lab bookings reserve specific manufacturing equipment for R&D use. Shared equipment between production and R&D requires formal booking systems to manage availability and prevent scheduling conflicts.',
    `it_asset_id` BIGINT COMMENT 'Foreign key linking to technology.it_asset. Business justification: Lab bookings reserve specific IT assets (test equipment, computers, measurement devices) for R&D activities. Asset management tracks utilization and availability for scheduling experiments.',
    `lab_resource_id` BIGINT COMMENT 'Identifier of the specific laboratory resource (equipment, instrument, test bench, or facility area) being reserved, as registered in the asset or lab management system.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: A lab booking is made against an R&D project for laboratory resource utilization. lab_booking has rd_project_code (string) as a denormalized reference. Adding rd_project_id as a proper FK normalizes t',
    `rd_test_plan_id` BIGINT COMMENT 'Foreign key linking to research.rd_test_plan. Business justification: A lab booking is made to execute a specific test plan, reserving laboratory resources for test activities. lab_booking has test_plan_reference (string) as a denormalized reference. Adding rd_test_plan',
    `employee_id` BIGINT COMMENT 'Employee identifier of the person who submitted the lab booking request, used for accountability, approval workflows, and resource utilization reporting by requester.',
    `actual_end_timestamp` TIMESTAMP COMMENT 'Actual date and time at which the laboratory resource utilization concluded, recorded upon check-out or session closure.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `actual_start_timestamp` TIMESTAMP COMMENT 'Actual date and time at which the laboratory resource utilization commenced, recorded upon check-in or session activation.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `actual_utilization_hours` DECIMAL(18,2) COMMENT 'Actual number of hours the laboratory resource was utilized during the booking session, recorded at session completion for OEE and capacity reporting.. Valid values are `^d{1,5}(.d{1,2})?$`',
    `approval_timestamp` TIMESTAMP COMMENT 'Date and time at which the lab booking was formally approved by the authorized lab manager or resource owner.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `approved_by_name` STRING COMMENT 'Name of the lab manager or authorized approver who confirmed the booking request, supporting approval audit trails and governance.',
    `apqp_phase` STRING COMMENT 'Advanced Product Quality Planning (APQP) phase associated with the lab booking, linking resource utilization to formal product development quality milestones.. Valid values are `plan_and_define|product_design_and_development|process_design_and_development|product_and_process_validation|launch_feedback_assessment`',
    `booking_date` DATE COMMENT 'Calendar date on which the lab resource booking was created and submitted by the requesting party.. Valid values are `^d{4}-d{2}-d{2}$`',
    `booking_number` STRING COMMENT 'Human-readable, business-facing reference number for the lab booking, used in communications, scheduling boards, and audit trails.. Valid values are `^LAB-[0-9]{4}-[0-9]{6}$`',
    `booking_type` STRING COMMENT 'Classification of the booking purpose, distinguishing standard R&D project bookings from recurring reservations, emergency requests, external partner sessions, or administrative blocks for maintenance and calibration.. Valid values are `standard|recurring|emergency|external_partner|maintenance_block|calibration_block`',
    `calibration_required` BOOLEAN COMMENT 'Indicates whether the booked laboratory resource requires calibration verification before use in this session, ensuring measurement traceability and test result validity.. Valid values are `true|false`',
    `cancellation_reason` STRING COMMENT 'Standardized reason code explaining why a lab booking was cancelled, used for capacity loss analysis and process improvement.. Valid values are `project_cancelled|resource_unavailable|schedule_conflict|requester_request|equipment_failure|safety_concern|other`',
    `conflict_description` STRING COMMENT 'Free-text description of the resource scheduling conflict, including the conflicting booking reference and resolution approach taken.',
    `conflict_flag` BOOLEAN COMMENT 'Indicates whether this booking was identified as having a scheduling conflict with another booking for the same resource during the same time window.. Valid values are `true|false`',
    `cost_center` STRING COMMENT 'SAP cost center code to which the lab resource utilization costs are allocated, enabling financial chargeback and R&D cost tracking.',
    `created_timestamp` TIMESTAMP COMMENT 'Date and time at which the lab booking record was first created in the system, used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `external_partner_involved` BOOLEAN COMMENT 'Indicates whether the lab booking involves participation from an external research partner, university, or third-party organization, triggering additional access control and IP protection protocols.. Valid values are `true|false`',
    `external_partner_name` STRING COMMENT 'Name of the external research partner, university, or third-party organization participating in the lab session, used for access management and collaboration tracking.',
    `hazardous_material_involved` BOOLEAN COMMENT 'Indicates whether the lab session involves handling of hazardous materials, triggering REACH/RoHS compliance checks and safety protocol requirements.. Valid values are `true|false`',
    `lab_location` STRING COMMENT 'Physical location or site identifier of the laboratory where the booked resource resides, supporting multi-site R&D operations and geographic capacity management.',
    `lab_location_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the laboratory site where the booked resource is located, supporting multinational R&D resource management and regulatory compliance.. Valid values are `^[A-Z]{3}$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Date and time of the most recent update to the lab booking record, supporting change tracking and Silver Layer incremental processing.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `notes` STRING COMMENT 'Free-text field for additional operational notes, special setup requirements, equipment configurations, or instructions relevant to the lab booking session.',
    `priority` STRING COMMENT 'Business priority level assigned to the lab booking, used to resolve scheduling conflicts and allocate constrained resources to highest-value R&D activities.. Valid values are `critical|high|medium|low`',
    `purpose_description` STRING COMMENT 'Free-text description of the intended use of the laboratory resource during the booked session, including test objectives, experiment details, or prototype activities.',
    `requested_by_name` STRING COMMENT 'Full name of the employee who submitted the lab booking request, displayed in scheduling interfaces and booking confirmations.',
    `requesting_department` STRING COMMENT 'Name of the organizational department or business unit that initiated the lab booking, used for departmental capacity allocation and chargeback reporting.',
    `safety_clearance_required` BOOLEAN COMMENT 'Indicates whether the lab booking activity requires a safety clearance or permit-to-work due to hazardous materials, high-voltage equipment, or other occupational health and safety risks.. Valid values are `true|false`',
    `scheduled_duration_hours` DECIMAL(18,2) COMMENT 'Planned duration of the laboratory resource booking in decimal hours, derived from scheduled start and end timestamps and used for capacity planning.. Valid values are `^d{1,5}(.d{1,2})?$`',
    `scheduled_end_timestamp` TIMESTAMP COMMENT 'Planned date and time at which the reserved laboratory resource session is expected to conclude.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `scheduled_start_timestamp` TIMESTAMP COMMENT 'Planned date and time at which the reserved laboratory resource is scheduled to begin use for the booked session.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$`',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this lab booking record originated, supporting data lineage and integration traceability in the Databricks Silver Layer.',
    `stage_gate_phase` STRING COMMENT 'Stage-gate process phase associated with the R&D activity for which the lab is being booked, enabling resource utilization analysis by innovation lifecycle phase.. Valid values are `concept|feasibility|development|validation|launch|post_launch`',
    `status` STRING COMMENT 'Current lifecycle status of the lab booking, tracking progression from initial request through confirmation, active utilization, and completion or cancellation.. Valid values are `requested|confirmed|in_use|completed|cancelled|on_hold`',
    CONSTRAINT pk_lab_booking PRIMARY KEY(`lab_booking_id`)
) COMMENT 'Transactional record for reservations and utilization bookings of R&D laboratory resources against specific R&D projects or test plans. Captures booking date, requested resource, booked time slot (start/end datetime), requesting project, booking status (requested, confirmed, in-use, completed, cancelled), actual utilization hours, and any resource conflicts. Supports lab capacity management and R&D resource scheduling.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`rd_milestone` (
    `rd_milestone_id` BIGINT COMMENT 'Unique system-generated identifier for each R&D project milestone record within the research domain.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: An R&D milestone tracks planned and actual achievements within an R&D project. This is a child→parent relationship (many milestones per project). rd_milestone has no FK to rd_project. Adding rd_projec',
    `stage_gate_review_id` BIGINT COMMENT 'Foreign key linking to research.stage_gate_review. Business justification: R&D milestones are validated through stage-gate reviews. Project management uses this to track which milestones require formal gate approval before proceeding to next development phase.',
    `acceptance_criteria` STRING COMMENT 'Formal, measurable criteria that must be satisfied for this milestone to be considered complete and accepted by the project governance body, partner, or funding agency.',
    `actual_completion_date` DATE COMMENT 'The date on which the milestone was actually completed and formally accepted, used to calculate schedule variance and support grant compliance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `applicable_regulation` STRING COMMENT 'Name or code of the specific regulation, directive, or standard that this milestone must satisfy (e.g., CE Marking, RoHS, REACH, ISO 9001, IEC 62443, OSHA 29 CFR 1910), supporting compliance traceability.',
    `apqp_phase` STRING COMMENT 'The APQP phase associated with this milestone, aligning R&D milestone tracking with the structured product quality planning process used in industrial manufacturing.. Valid values are `phase_1_planning|phase_2_product_design|phase_3_process_design|phase_4_product_validation|phase_5_launch_feedback`',
    `completion_evidence_reference` STRING COMMENT 'Reference identifier or document link pointing to the formal evidence of milestone completion (e.g., test report number, approval document ID, regulatory submission reference, Teamcenter document ID), required for stage-gate sign-off and grant compliance audits.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp recording when this milestone record was first created in the system, supporting audit trail requirements and data lineage tracking in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `delay_description` STRING COMMENT 'Free-text narrative providing additional context for the delay reason, including specific circumstances, impact assessment, and mitigation actions taken.',
    `delay_reason` STRING COMMENT 'Categorized reason for milestone delay when the actual or revised completion date exceeds the planned date, supporting root cause analysis and corrective action planning.. Valid values are `resource_constraint|technical_complexity|supplier_delay|regulatory_hold|scope_change|budget_constraint|external_partner_delay|force_majeure|other`',
    `description` STRING COMMENT 'Detailed narrative describing the scope, deliverables, and success criteria associated with this milestone, supporting stage-gate review and partner reporting.',
    `evidence_type` STRING COMMENT 'Classification of the evidence document type used to substantiate milestone completion, enabling structured audit trails for stage-gate governance and grant compliance.. Valid values are `test_report|design_review_minutes|regulatory_approval|prototype_sign_off|customer_acceptance|patent_filing|audit_report|inspection_record|other`',
    `external_partner_name` STRING COMMENT 'Name of the external research partner, university, consortium, or subcontractor responsible for or involved in delivering this milestone, supporting partner reporting and collaboration governance.',
    `external_partner_obligation` STRING COMMENT 'Description of the specific deliverable or obligation the external partner is responsible for in relation to this milestone, used for partner performance management and contractual compliance.',
    `is_contractual` BOOLEAN COMMENT 'Indicates whether this milestone is formally committed in a contractual agreement with an external partner, customer, or funding body, triggering legal or financial obligations upon completion or delay.. Valid values are `true|false`',
    `is_critical_path` BOOLEAN COMMENT 'Indicates whether this milestone lies on the critical path of the R&D project schedule, meaning any delay directly impacts the overall project completion date.. Valid values are `true|false`',
    `is_gate_milestone` BOOLEAN COMMENT 'Indicates whether this milestone represents a formal stage-gate decision point requiring executive or governance committee review and approval before the project may proceed to the next phase.. Valid values are `true|false`',
    `is_grant_reportable` BOOLEAN COMMENT 'Indicates whether this milestone must be formally reported to an external funding body (e.g., government grant agency, EU Horizon program) as part of grant compliance obligations.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp recording the most recent update to this milestone record, enabling change detection, incremental data loading, and audit trail maintenance in the Databricks Silver Layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `milestone_code` STRING COMMENT 'Human-readable business reference code uniquely identifying the milestone, used in project reporting, partner communications, and grant compliance documentation.. Valid values are `^MS-[A-Z0-9]{3,10}-[0-9]{4}$`',
    `milestone_sequence` STRING COMMENT 'Ordinal sequence number defining the order of this milestone within the project plan, supporting Gantt chart rendering, dependency tracking, and stage-gate progression logic.',
    `milestone_type` STRING COMMENT 'Classification of the milestone by its business nature: technical (engineering deliverable), commercial (market or customer commitment), regulatory (compliance submission or approval), contractual (partner or grant obligation), financial (budget gate), IP (intellectual property filing), or safety (HSE checkpoint).. Valid values are `technical|commercial|regulatory|contractual|financial|ip|safety`',
    `name` STRING COMMENT 'Descriptive name of the R&D milestone as defined in the project plan or stage-gate governance framework (e.g., Prototype Functional Validation Complete, Regulatory Submission Approved).',
    `owning_department` STRING COMMENT 'Name of the organizational department or business unit responsible for delivering this milestone (e.g., R&D Engineering, Product Development, Regulatory Affairs).',
    `payment_amount` DECIMAL(18,2) COMMENT 'Monetary value of the payment triggered upon completion of this milestone, applicable for contractual milestones linked to grant disbursements, partner agreements, or customer contracts.',
    `payment_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the milestone payment amount (e.g., USD, EUR, GBP), supporting multi-currency financial reporting in multinational operations.. Valid values are `^[A-Z]{3}$`',
    `payment_trigger_flag` BOOLEAN COMMENT 'Indicates whether completion of this milestone triggers a payment event, such as a grant disbursement, partner payment, or customer invoice milestone, requiring financial system notification.. Valid values are `true|false`',
    `planned_completion_date` DATE COMMENT 'The originally scheduled date by which this milestone was planned to be completed, as defined in the project plan or contractual agreement.. Valid values are `^d{4}-d{2}-d{2}$`',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether this milestone has a regulatory compliance dimension, such as CE Marking submission, RoHS/REACH compliance verification, or OSHA safety validation, requiring regulatory authority engagement.. Valid values are `true|false`',
    `responsible_engineer` STRING COMMENT 'Full name of the lead engineer or technical owner responsible for executing the technical deliverables associated with this milestone.',
    `responsible_project_manager` STRING COMMENT 'Full name of the project manager accountable for ensuring this milestone is achieved on time and to the defined acceptance criteria.',
    `review_date` DATE COMMENT 'Date on which the formal milestone review or stage-gate decision meeting was conducted by the governance committee or project board.. Valid values are `^d{4}-d{2}-d{2}$`',
    `review_outcome` STRING COMMENT 'Outcome of the formal milestone review or stage-gate decision meeting, indicating whether the milestone was approved, conditionally approved, rejected, or deferred by the governance committee.. Valid values are `approved|approved_with_conditions|rejected|deferred|pending_review`',
    `reviewer_name` STRING COMMENT 'Name of the individual or governance body chair who conducted the formal milestone review and recorded the review outcome.',
    `revised_completion_date` DATE COMMENT 'Updated target completion date following an approved schedule change or delay, capturing the most current committed date for milestone delivery.. Valid values are `^d{4}-d{2}-d{2}$`',
    `schedule_variance_days` STRING COMMENT 'Number of calendar days by which the actual or revised completion date deviates from the planned completion date. Positive values indicate delay; negative values indicate early completion. Supports portfolio performance analytics.',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this milestone record originates (e.g., Siemens Teamcenter PLM for project milestone tracking, SAP S/4HANA PS for project system milestones), supporting data lineage and integration governance.. Valid values are `Teamcenter|Opcenter_MES|SAP_S4HANA|MindSphere|Manual|Other`',
    `stage_gate_phase` STRING COMMENT 'The stage-gate phase of the R&D project to which this milestone belongs, enabling governance tracking across the innovation pipeline from ideation through commercialization.. Valid values are `ideation|feasibility|concept|development|validation|launch|post_launch`',
    `status` STRING COMMENT 'Current execution status of the milestone within the R&D project lifecycle, used for stage-gate governance, portfolio dashboards, and grant compliance reporting.. Valid values are `not_started|in_progress|completed|delayed|cancelled|on_hold`',
    `technology_domain` STRING COMMENT 'The primary technology domain to which this milestone belongs, aligning with the companys strategic R&D focus areas in automation, electrification, and smart infrastructure.. Valid values are `automation|electrification|smart_infrastructure|digitalization|materials|energy_management|cybersecurity|robotics|ai_ml|other`',
    `trl` STRING COMMENT 'Technology Readiness Level (TRL) expected to be achieved upon completion of this milestone, on the standard 1-9 scale. Supports innovation pipeline maturity tracking and stage-gate governance.. Valid values are `^[1-9]$`',
    CONSTRAINT pk_rd_milestone PRIMARY KEY(`rd_milestone_id`)
) COMMENT 'Transactional record tracking planned and actual milestone achievements within an R&D project. Captures milestone name, milestone type (technical, commercial, regulatory, contractual), planned completion date, actual completion date, milestone status (not started, in progress, completed, delayed, cancelled), completion evidence reference, and responsible project manager. Supports stage-gate governance, partner reporting, and grant compliance milestone tracking.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`technology_readiness` (
    `technology_readiness_id` BIGINT COMMENT 'Unique surrogate identifier for each formal Technology Readiness Level (TRL) assessment record in the silver layer lakehouse.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the principal assessor from the HR system of record. Enables workforce analytics and competency tracking for TRL assessment activities.',
    `equipment_id` BIGINT COMMENT 'Foreign key linking to asset.equipment. Business justification: Technology readiness assessments evaluate if new technologies can run on existing production equipment. Manufacturing readiness levels (MRL) explicitly require identifying target equipment for product',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: A TRL assessment is conducted for an R&D project. technology_readiness has a project_code string attribute that is a denormalized reference to rd_project. Adding rd_project_id as a proper FK normalize',
    `research_prototype_id` BIGINT COMMENT 'Foreign key linking to research.prototype. Business justification: A TRL assessment is conducted against a specific prototype as evidence of technology maturity. technology_readiness has prototype_identifier (string) as a denormalized reference. Adding prototype_id a',
    `approved_date` DATE COMMENT 'Date on which the TRL assessment was formally approved by the authorized approver. Marks the official record date for stage-gate decisions and grant milestone submissions.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approver_name` STRING COMMENT 'Name of the authorized individual (e.g., R&D Director, Chief Engineer) who formally approved the TRL assessment outcome. Required for stage-gate governance and grant compliance.',
    `apqp_phase` STRING COMMENT 'The APQP phase active at the time of this TRL assessment. Supports alignment between technology readiness and product quality planning milestones.. Valid values are `Phase 1 - Plan and Define|Phase 2 - Product Design and Development|Phase 3 - Process Design and Development|Phase 4 - Product and Process Validation|Phase 5 - Feedback Assessment and Corrective Action`',
    `assessed_trl` STRING COMMENT 'The TRL level (1–9) formally assigned to the technology as a result of this assessment, per the NASA/EU Horizon scale. TRL 1 = Basic principles observed; TRL 9 = Actual system proven in operational environment.. Valid values are `^[1-9]$`',
    `assessment_date` DATE COMMENT 'Calendar date on which the formal TRL assessment was conducted. Used for tracking technology maturation timelines and stage-gate scheduling.. Valid values are `^d{4}-d{2}-d{2}$`',
    `assessment_number` STRING COMMENT 'Human-readable business reference number uniquely identifying the TRL assessment record, used in stage-gate documentation, grant reporting, and audit trails.. Valid values are `^TRL-[A-Z0-9]{2,10}-[0-9]{4}-[0-9]{4}$`',
    `assessment_panel` STRING COMMENT 'Comma-separated list of names or employee IDs of additional panel members who participated in the TRL assessment review. Supports multi-reviewer governance for high-stakes assessments.',
    `assessment_rationale` STRING COMMENT 'Detailed narrative justification for the assigned TRL level, including key evidence considered, gaps identified, and reasoning for the assessment outcome. Required for grant reporting and audit compliance.',
    `assessment_type` STRING COMMENT 'Classification of the TRL assessment by its business trigger or purpose (e.g., Initial baseline, Stage-Gate review, EU grant milestone, external audit). Supports filtering and reporting by assessment context.. Valid values are `Initial|Periodic|Stage-Gate|Grant Milestone|External Audit|Self-Assessment|Exit Review`',
    `assessor_name` STRING COMMENT 'Full name of the principal assessor who conducted and is accountable for the TRL assessment. Required for audit trails and grant reporting.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the TRL assessment record was first created in the source system or lakehouse. Used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `evidence_artifacts` STRING COMMENT 'Comma-separated list or free-text reference to supporting evidence artifacts (e.g., test reports, lab results, prototype documentation, simulation outputs, FAI reports) that substantiate the assigned TRL level.',
    `external_partner_involved` BOOLEAN COMMENT 'Indicates whether an external research partner (e.g., university, national lab, consortium partner) was involved in the technology development or assessment process. Relevant for grant compliance and IP ownership tracking.. Valid values are `true|false`',
    `external_partner_name` STRING COMMENT 'Name of the external research partner organization involved in the technology development or TRL assessment. Populated when external_partner_involved is true.',
    `fmea_reference` STRING COMMENT 'Reference identifier of the DFMEA or PFMEA document associated with the technology at the time of this TRL assessment. Links readiness assessment to risk analysis artifacts.',
    `gate_decision` STRING COMMENT 'Formal stage-gate decision outcome associated with this TRL assessment (e.g., Go, No-Go, Conditional Go). Directly drives project progression, resource commitment, and portfolio management actions.. Valid values are `Go|No-Go|Conditional Go|Hold|Redirect|Terminate`',
    `gate_decision_date` DATE COMMENT 'Date on which the stage-gate decision was formally recorded based on this TRL assessment outcome. Used for project timeline tracking and governance reporting.. Valid values are `^d{4}-d{2}-d{2}$`',
    `grant_reference` STRING COMMENT 'Reference number of the public or private research grant under which this TRL assessment is being reported (e.g., EU Horizon Europe grant agreement number). Supports grant compliance and milestone reporting.',
    `ip_classification` STRING COMMENT 'Confidentiality and IP sensitivity classification of the technology and assessment content. Governs access control, sharing with external partners, and publication eligibility.. Valid values are `Confidential|Internal|Public|Restricted|Trade Secret`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to the TRL assessment record. Supports change tracking, audit compliance, and incremental lakehouse data loading.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `next_assessment_date` DATE COMMENT 'Planned date for the next TRL assessment of this technology. Supports proactive scheduling of stage-gate reviews and grant milestone planning.. Valid values are `^d{4}-d{2}-d{2}$`',
    `owning_business_unit` STRING COMMENT 'Name or code of the business unit responsible for the technology being assessed. Supports portfolio-level TRL reporting and resource allocation decisions across the multinational enterprise.',
    `owning_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the country where the R&D activity and assessment was conducted. Supports geographic TRL portfolio analytics and multi-jurisdiction grant reporting.. Valid values are `^[A-Z]{3}$`',
    `previous_trl` STRING COMMENT 'The TRL level recorded for this technology at the time of the immediately preceding formal assessment. Enables maturation delta tracking and stage-gate progression analysis.. Valid values are `^[1-9]$`',
    `regulatory_compliance_scope` STRING COMMENT 'Comma-separated list of applicable regulatory frameworks or standards relevant to the technology being assessed (e.g., CE Marking, RoHS, REACH, IEC 62443, UL). Supports compliance tracking and certification planning.',
    `risk_level` STRING COMMENT 'Overall risk level assigned to the technology at the time of this TRL assessment, reflecting technical, schedule, and commercial risks. Informs stage-gate go/no-go decisions.. Valid values are `Low|Medium|High|Critical`',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this TRL assessment record was ingested into the lakehouse silver layer. Supports data lineage tracking and reconciliation.. Valid values are `Teamcenter PLM|SAP S4HANA|MindSphere|Manual Entry|Other`',
    `stage_gate_phase` STRING COMMENT 'The stage-gate phase of the R&D project at the time of this TRL assessment. Enables correlation between TRL maturity and formal stage-gate progression decisions.. Valid values are `Concept|Feasibility|Development|Validation|Pilot|Launch|Post-Launch`',
    `status` STRING COMMENT 'Current lifecycle status of the TRL assessment record. Controls workflow progression from draft through formal approval and archival.. Valid values are `Draft|Pending Review|Approved|Rejected|Superseded|Archived`',
    `sustainability_alignment` STRING COMMENT 'Primary sustainability objective that the assessed technology supports. Enables ESG portfolio reporting and alignment with ISO 14001 environmental management and ISO 50001 energy management commitments.. Valid values are `Energy Efficiency|Carbon Reduction|Circular Economy|Hazardous Material Reduction|Water Conservation|Not Applicable|Multiple`',
    `target_trl` STRING COMMENT 'The next TRL milestone the technology is expected to achieve, as defined by the assessor or stage-gate committee. Drives planning for subsequent R&D activities and resource allocation.. Valid values are `^[1-9]$`',
    `target_trl_date` DATE COMMENT 'Planned date by which the technology is expected to reach the target TRL. Used for stage-gate scheduling, grant milestone reporting, and technology roadmap alignment.. Valid values are `^d{4}-d{2}-d{2}$`',
    `technology_domain` STRING COMMENT 'Primary technology domain of the assessed technology, aligned to the companys strategic innovation pillars (e.g., Automation, Electrification, IIoT). Supports portfolio-level TRL analytics.. Valid values are `Automation|Electrification|Smart Infrastructure|IIoT|Power Electronics|Motion Control|Drive Systems|Digital Twin|Robotics|Energy Storage|Cybersecurity|Other`',
    `test_environment` STRING COMMENT 'Classification of the environment in which the technology was demonstrated or validated for this TRL assessment. Directly maps to TRL level criteria (e.g., TRL 5 requires relevant environment, TRL 7 requires operational environment).. Valid values are `Laboratory|Simulated Environment|Relevant Environment|Operational Environment|Field Trial|Customer Site|External Test Facility`',
    `version_number` STRING COMMENT 'Version number of the TRL assessment record, incremented when the assessment is revised or updated (e.g., following additional evidence review or panel feedback). Supports document control and audit traceability.. Valid values are `^[0-9]+.[0-9]+$`',
    CONSTRAINT pk_technology_readiness PRIMARY KEY(`technology_readiness_id`)
) COMMENT 'Transactional record capturing formal Technology Readiness Level (TRL) assessments conducted for R&D projects and technology platforms. Records assessment date, assessed TRL level (TRL 1–9 per NASA/EU Horizon scale), previous TRL level, assessment rationale, evidence artifacts referenced, assessor identity, and next TRL target. Supports stage-gate decisions, grant reporting, and technology maturation tracking for automation, electrification, and IIoT technologies.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`rd_document` (
    `rd_document_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each R&D technical document or knowledge artifact in the repository.',
    `employee_id` BIGINT COMMENT 'Enterprise employee identifier of the document author, enabling linkage to workforce records and accountability tracking.',
    `configuration_item_id` BIGINT COMMENT 'Foreign key linking to technology.configuration_item. Business justification: R&D documentation references specific configuration items (system designs, software versions, hardware specs) to maintain traceability between research outputs and IT/OT configurations for compliance ',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: An R&D technical document belongs to an R&D project. rd_document has project_code (string) as a denormalized reference. Adding rd_project_id as a proper FK normalizes this relationship and allows proj',
    `rd_test_plan_id` BIGINT COMMENT 'Foreign key linking to research.rd_test_plan. Business justification: An R&D document (e.g., test report, validation report) is associated with a specific test plan. rd_document has related_test_plan_number (string) as a denormalized reference. Adding rd_test_plan_id as',
    `access_classification` STRING COMMENT 'Data access and confidentiality classification level assigned to the document, controlling who may view, edit, or distribute the document content. Aligns with enterprise data governance policy.. Valid values are `restricted|confidential|internal|public`',
    `applicable_standards` STRING COMMENT 'Comma-separated list of industry, regulatory, or internal standards (e.g., ISO 9001, IEC 61131, RoHS, REACH, CE Marking) that this document addresses or must comply with.',
    `approved_date` DATE COMMENT 'Date on which the document received formal approval, marking it as the authoritative version for use in R&D activities.. Valid values are `^d{4}-d{2}-d{2}$`',
    `approver_name` STRING COMMENT 'Name of the authorized individual who formally approved the document, granting it official status for use in R&D activities.',
    `apqp_phase` STRING COMMENT 'APQP phase to which this document is associated, enabling alignment of R&D documentation with the structured product quality planning process.. Valid values are `plan_and_define|product_design_and_development|process_design_and_development|product_and_process_validation|launch_feedback_and_corrective_action|not_applicable`',
    `author_name` STRING COMMENT 'Full name of the primary author or originator responsible for creating the document content.',
    `country_of_origin` STRING COMMENT 'ISO 3166-1 alpha-3 country code of the site or location where the document was originally created, supporting regional compliance and export control requirements.. Valid values are `^[A-Z]{3}$`',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp recording when the document record was first created in the source system, used for audit trail and data lineage purposes.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `document_date` DATE COMMENT 'Official date of the document as stated on the document itself, representing when the document content was finalized or issued.. Valid values are `^d{4}-d{2}-d{2}$`',
    `document_number` STRING COMMENT 'Business-assigned unique document identifier used for cross-referencing in PLM, MES, and ERP systems. Follows the enterprise document numbering standard.. Valid values are `^RD-DOC-[A-Z0-9]{4,20}$`',
    `document_type` STRING COMMENT 'Classification of the R&D document by its functional purpose and content type, used to route documents through appropriate review and approval workflows.. Valid values are `research_report|feasibility_study|test_protocol|experimental_data_package|invention_disclosure|technical_white_paper|regulatory_pre_submission|design_specification|literature_review|project_charter|meeting_minutes|risk_assessment|standard_operating_procedure`',
    `ecn_reference` STRING COMMENT 'Reference number of the Engineering Change Notice (ECN) or Engineering Change Order (ECO) that triggered the creation or revision of this document, ensuring traceability to the change management process.',
    `effective_date` DATE COMMENT 'Date from which the approved document version becomes effective and supersedes any prior version for operational use.. Valid values are `^d{4}-d{2}-d{2}$`',
    `expiry_date` DATE COMMENT 'Date on which the document is scheduled to expire or require mandatory review and renewal, supporting periodic document control obligations.. Valid values are `^d{4}-d{2}-d{2}$`',
    `external_partner_involved` BOOLEAN COMMENT 'Indicates whether an external research partner, university, or third-party organization contributed to or co-authored this document.. Valid values are `true|false`',
    `external_partner_name` STRING COMMENT 'Name of the external research partner, university, or third-party organization that collaborated on or contributed to this document.',
    `file_format` STRING COMMENT 'Electronic file format of the document, used for access planning, archival compatibility, and rendering requirements.. Valid values are `PDF|DOCX|XLSX|PPTX|XML|HTML|TXT|ZIP|other`',
    `ip_classification` STRING COMMENT 'Intellectual property classification of the document content, indicating the IP protection status and governing the permissible use, sharing, and licensing of the knowledge contained.. Valid values are `proprietary|trade_secret|patent_pending|patented|open_source|public_domain|licensed_third_party`',
    `keywords` STRING COMMENT 'Comma-separated list of subject keywords or tags assigned to the document to facilitate full-text search and knowledge discovery within the R&D repository.',
    `language_code` STRING COMMENT 'ISO 639-1/639-2 language code indicating the primary language in which the document is authored, supporting multilingual knowledge management in global operations.. Valid values are `^[a-z]{2,3}(-[A-Z]{2})?$`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'System timestamp recording the most recent modification to the document record, supporting change tracking and audit compliance.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `next_review_date` DATE COMMENT 'Scheduled date for the next periodic review of the document to ensure continued accuracy, relevance, and compliance.. Valid values are `^d{4}-d{2}-d{2}$`',
    `owning_business_unit` STRING COMMENT 'Business unit or division within the enterprise that owns and is accountable for the R&D document, supporting multi-divisional knowledge management.',
    `owning_department` STRING COMMENT 'Name of the organizational department or business unit responsible for the documents content, maintenance, and lifecycle management.',
    `prototype_identifier` STRING COMMENT 'Identifier of the prototype or experimental build to which this document is associated, linking knowledge artifacts to physical development artifacts.',
    `regulatory_compliance_flag` BOOLEAN COMMENT 'Indicates whether this document is required for regulatory compliance purposes (e.g., pre-submission to a regulatory body, CE marking technical file, RoHS/REACH declaration).. Valid values are `true|false`',
    `reviewer_name` STRING COMMENT 'Name of the designated technical reviewer responsible for evaluating the document for accuracy, completeness, and compliance prior to approval.',
    `source_system` STRING COMMENT 'Name of the operational system of record from which this document record was sourced or ingested into the data lakehouse.. Valid values are `Teamcenter|SAP_S4HANA|MindSphere|Manual|Other`',
    `stage_gate_phase` STRING COMMENT 'Stage-gate process phase during which this document was created or is applicable, supporting traceability across the product development lifecycle and APQP planning.. Valid values are `ideation|concept|feasibility|development|validation|launch|post_launch|not_applicable`',
    `status` STRING COMMENT 'Current lifecycle status of the R&D document within the document control workflow, from initial draft through approval to eventual supersession or obsolescence.. Valid values are `draft|under_review|approved|superseded|obsolete|cancelled|on_hold`',
    `storage_location_reference` STRING COMMENT 'Reference path, URL, or identifier indicating where the physical or digital document file is stored (e.g., Teamcenter vault path, SharePoint URL, or network drive path).',
    `submission_date` DATE COMMENT 'Date on which the document was formally submitted for review or approval within the document control workflow.. Valid values are `^d{4}-d{2}-d{2}$`',
    `technology_domain` STRING COMMENT 'Primary technology domain or discipline that the document addresses, used for knowledge management categorization and routing to subject matter experts.. Valid values are `automation|electrification|smart_infrastructure|robotics|power_electronics|motion_control|industrial_software|sensors_and_instrumentation|energy_management|connectivity|other`',
    `title` STRING COMMENT 'Full descriptive title of the R&D technical document or knowledge artifact as it appears on the document cover page.',
    `version` STRING COMMENT 'Current version or revision identifier of the document following the enterprise versioning convention (e.g., 1.0, 2.1, 3.0A). Incremented upon each approved revision.. Valid values are `^[0-9]+.[0-9]+(.[0-9]+)?[A-Z]?$`',
    CONSTRAINT pk_rd_document PRIMARY KEY(`rd_document_id`)
) COMMENT 'Master record for R&D technical documents and knowledge artifacts including research reports, feasibility studies, test protocols, experimental data packages, invention disclosures, technical white papers, and regulatory pre-submission documents. Captures document title, document type, version, author, associated R&D project, document status (draft, under review, approved, superseded), storage location reference, and access classification (restricted, confidential, internal). Manages the R&D knowledge repository distinct from engineering drawings owned by engineering domain.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` (
    `competitive_intelligence_id` BIGINT COMMENT 'Unique system-generated surrogate key identifying each competitive intelligence record in the research domain.',
    `competitor_id` BIGINT COMMENT 'Foreign key linking to sales.competitor. Business justification: R&D teams analyze competitor products, patents, and technical capabilities to inform innovation strategy. This intelligence directly supports the same competitor entities that sales tracks for win/los',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: Competitive intelligence records are gathered to inform R&D strategy and are linked to specific R&D projects. competitive_intelligence has related_rd_project_code (string) as a denormalized reference.',
    `action_priority` STRING COMMENT 'Priority classification for the recommended action derived from this intelligence, guiding R&D resource allocation and roadmap adjustment timelines.. Valid values are `immediate|short_term|medium_term|long_term|monitor_only`',
    `analyst_owner` STRING COMMENT 'Name or employee identifier of the R&D analyst or researcher responsible for gathering, validating, and maintaining this competitive intelligence record.',
    `applicable_regulation` STRING COMMENT 'Specific regulation, directive, or standard referenced in this intelligence record, such as CE Marking, RoHS, REACH, IEC 62443, or ISO 9001.',
    `competitor_country_code` STRING COMMENT 'ISO 3166-1 alpha-3 country code representing the primary country of operation or headquarters of the competitor.. Valid values are `^[A-Z]{3}$`',
    `competitor_product_category` STRING COMMENT 'Product or solution category of the competitor offering referenced in this intelligence, used for benchmarking against the companys own product portfolio.',
    `competitor_product_name` STRING COMMENT 'Name of the specific competitor product, solution, or technology platform referenced in this intelligence record.',
    `confidence_level` STRING COMMENT 'Analysts assessed confidence level in the accuracy and completeness of the intelligence findings, based on source credibility and corroboration.. Valid values are `high|medium|low`',
    `confidentiality_level` STRING COMMENT 'Data classification level assigned to this competitive intelligence record, governing access control and distribution within the organization.. Valid values are `restricted|confidential|internal|public`',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp indicating when this competitive intelligence record was first created in the system, used for audit trail and data lineage tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `expiry_date` DATE COMMENT 'Date after which this competitive intelligence record is considered stale and should be re-validated or archived, based on the volatility of the technology domain.. Valid values are `^d{4}-d{2}-d{2}$`',
    `freedom_to_operate_impact` STRING COMMENT 'Assessment of whether the competitors identified IP or technology creates a freedom-to-operate concern for the companys current or planned product development.. Valid values are `no_impact|potential_risk|requires_fto_analysis|blocking_risk|cleared`',
    `geographic_scope` STRING COMMENT 'Geographic scope of the competitors activity or the intelligence finding, indicating whether the competitive threat or opportunity is global or regionally specific.. Valid values are `global|north_america|europe|asia_pacific|latin_america|middle_east_africa|specific_country`',
    `intelligence_date` DATE COMMENT 'Date on which the competitive intelligence was gathered, observed, or published, used for temporal relevance assessment and trend analysis.. Valid values are `^d{4}-d{2}-d{2}$`',
    `intelligence_type` STRING COMMENT 'Classification of the method or source type used to gather this competitive intelligence, such as patent analysis, product teardown, or market report.. Valid values are `patent_analysis|product_teardown|market_report|conference_intelligence|technical_publication|regulatory_filing|supplier_intelligence|customer_feedback|benchmark_study|trade_show|other`',
    `ip_risk_flag` BOOLEAN COMMENT 'Indicates whether this competitive intelligence record has identified a potential intellectual property risk, such as a competitor patent that may affect freedom to operate.. Valid values are `true|false`',
    `ipc_classification` STRING COMMENT 'International Patent Classification (IPC) code associated with the competitors patent or technology domain, used for patent landscape analysis.',
    `key_findings_summary` STRING COMMENT 'Structured narrative summarizing the principal findings from the competitive intelligence analysis, including observed capabilities, product features, or market positions.',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent modification to this competitive intelligence record, supporting audit trail requirements and change tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `market_segment` STRING COMMENT 'Market segment in which the competitors technology or product is positioned, used for competitive landscape mapping and R&D investment prioritization.. Valid values are `factory_automation|building_automation|transportation|energy|utilities|process_industries|discrete_manufacturing|smart_infrastructure|other`',
    `owning_business_unit` STRING COMMENT 'Business unit or division within the organization that owns and is primarily responsible for acting on this competitive intelligence.',
    `patent_reference_number` STRING COMMENT 'Patent application or grant number associated with this intelligence record when the intelligence type is patent analysis, enabling cross-reference with the IP asset registry.',
    `recommended_action` STRING COMMENT 'Analysts recommended strategic or tactical action in response to the competitive intelligence, such as accelerating R&D investment, filing a patent, or initiating a technology benchmark study.',
    `record_code` STRING COMMENT 'Human-readable business identifier for the competitive intelligence record, used for cross-referencing in reports, roadmaps, and stage-gate reviews.. Valid values are `^CI-[A-Z0-9]{4,12}$`',
    `regulatory_relevance_flag` BOOLEAN COMMENT 'Indicates whether this intelligence has implications for regulatory compliance, such as a competitor achieving CE Marking, RoHS/REACH compliance, or IEC certification ahead of the company.. Valid values are `true|false`',
    `review_date` DATE COMMENT 'Date on which this competitive intelligence record was last formally reviewed for continued relevance and accuracy.. Valid values are `^d{4}-d{2}-d{2}$`',
    `roadmap_alignment_code` STRING COMMENT 'Reference code linking this competitive intelligence record to a specific technology roadmap entry, enabling direct traceability from intelligence to strategic planning.',
    `source_name` STRING COMMENT 'Name of the specific source from which the intelligence was obtained, such as a publication title, conference name, patent database, or analyst firm.',
    `source_system` STRING COMMENT 'Name of the operational system or platform from which this competitive intelligence record was ingested or originated, such as Siemens Teamcenter PLM or a market intelligence platform.',
    `source_type` STRING COMMENT 'Category of the source from which the competitive intelligence was obtained, enabling filtering and credibility assessment.. Valid values are `patent_database|industry_report|conference|trade_publication|regulatory_database|supplier_network|customer_interview|web_scraping|internal_teardown|analyst_briefing|other`',
    `source_url` STRING COMMENT 'Web address or document link pointing to the original source of the competitive intelligence, enabling traceability and verification.. Valid values are `^https?://.+`',
    `status` STRING COMMENT 'Current lifecycle status of the competitive intelligence record, from initial draft through validation, publication, and eventual archival.. Valid values are `draft|under_review|validated|published|archived|superseded`',
    `strategic_impact_level` STRING COMMENT 'Assessed level of strategic impact this intelligence has on the companys technology roadmap and R&D investment decisions.. Valid values are `critical|high|medium|low|negligible`',
    `strategic_implication` STRING COMMENT 'Analysts assessment of the strategic implications of the intelligence for the companys R&D investment priorities, technology roadmap, and competitive positioning.',
    `technology_domain` STRING COMMENT 'Primary technology domain to which this competitive intelligence record pertains, aligning with the companys R&D technology roadmap domains.. Valid values are `automation|electrification|smart_infrastructure|robotics|digitalization|energy_management|motion_control|industrial_iot|cybersecurity|other`',
    `technology_readiness_level` STRING COMMENT 'Estimated Technology Readiness Level (TRL) of the competitors technology as assessed by the analyst, on a scale of 1 (basic research) to 9 (proven in operational environment).. Valid values are `^[1-9]$`',
    `title` STRING COMMENT 'Short descriptive title summarizing the competitive intelligence finding, used for quick identification in dashboards and reports.',
    `validation_status` STRING COMMENT 'Indicates the degree to which the intelligence findings have been corroborated by multiple sources or subject matter expert review.. Valid values are `unvalidated|partially_validated|validated|disputed`',
    CONSTRAINT pk_competitive_intelligence PRIMARY KEY(`competitive_intelligence_id`)
) COMMENT 'Master record capturing structured competitive and market intelligence data gathered to inform R&D strategy and technology roadmap decisions. Captures competitor name, technology domain, intelligence type (patent analysis, product teardown, market report, conference intelligence), source, intelligence date, key findings summary, strategic implication assessment, and analyst owner. Supports technology benchmarking and R&D investment prioritization.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`rd_risk` (
    `rd_risk_id` BIGINT COMMENT 'Unique system-generated identifier for each R&D risk record in the master risk register.',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to research.rd_project. Business justification: An R&D risk is associated with a specific R&D project. This is a child→parent relationship (many risks per project). rd_risk has no FK to rd_project. Adding rd_project_id enables project-level risk re',
    `regulatory_obligation_id` BIGINT COMMENT 'Foreign key linking to hse.regulatory_obligation. Business justification: R&D risks include regulatory compliance failures (REACH, RoHS, safety standards). Research teams track which regulatory obligations impact project feasibility and market approval timelines.',
    `employee_id` BIGINT COMMENT 'Employee identifier of the risk owner, enabling linkage to workforce records and accountability tracking in portfolio risk management.',
    `actual_closure_date` DATE COMMENT 'Date on which the risk was formally closed or accepted, completing the risk lifecycle and enabling closure rate analytics.. Valid values are `^d{4}-d{2}-d{2}$`',
    `apqp_phase` STRING COMMENT 'APQP phase associated with the risk, enabling alignment of risk management activities with the structured APQP product development process.. Valid values are `plan_and_define|product_design_and_development|process_design_and_development|product_and_process_validation|launch_feedback_and_corrective_action`',
    `contingency_plan` STRING COMMENT 'Fallback actions to be executed if the risk materializes despite mitigation efforts, ensuring project continuity and minimizing impact on stage-gate timelines.',
    `created_timestamp` TIMESTAMP COMMENT 'Timestamp when the risk record was first created in the system, supporting audit trail, data lineage, and Silver layer ingestion tracking.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `description` STRING COMMENT 'Detailed narrative describing the risk event, its context, potential triggers, and the conditions under which it may materialize.',
    `detectability_rating` STRING COMMENT 'Assessment of the ability to detect the risk or its precursors before the risk event materializes, used in FMEA-based RPN calculation.. Valid values are `very_high|high|moderate|low|very_low`',
    `escalation_date` DATE COMMENT 'Date on which the risk was formally escalated to senior management or the portfolio risk committee for decision and action.. Valid values are `^d{4}-d{2}-d{2}$`',
    `escalation_flag` BOOLEAN COMMENT 'Indicates whether the risk has been escalated to senior management or the portfolio risk committee due to high severity, unresolved mitigation, or stage-gate blocking status.. Valid values are `true|false`',
    `estimated_cost_impact_usd` DECIMAL(18,2) COMMENT 'Estimated financial impact in USD if the risk materializes, used for financial risk quantification, budget contingency planning, and portfolio-level risk exposure reporting.',
    `estimated_schedule_impact_days` STRING COMMENT 'Estimated number of calendar days of project schedule delay if the risk materializes, used for critical path analysis and stage-gate timeline risk assessment.',
    `external_partner_involved` BOOLEAN COMMENT 'Indicates whether the risk involves or is attributable to an external research partner, university, or contract R&D organization, relevant for partner risk management and agreement compliance.. Valid values are `true|false`',
    `freedom_to_operate_concern` BOOLEAN COMMENT 'Indicates whether the risk specifically involves a freedom-to-operate concern, where the technology under development may infringe third-party patents, requiring legal review.. Valid values are `true|false`',
    `identification_date` DATE COMMENT 'Date on which the risk was formally identified and entered into the R&D risk register.. Valid values are `^d{4}-d{2}-d{2}$`',
    `identified_by` STRING COMMENT 'Name of the person who originally identified and logged the risk, supporting audit trail and risk identification source analysis.',
    `impact_score` STRING COMMENT 'Numeric impact severity score on a 1–10 scale used in risk priority number calculations and stage-gate risk scoring matrices.. Valid values are `^([1-9]|10)$`',
    `impact_severity` STRING COMMENT 'Qualitative assessment of the potential consequence magnitude if the risk materializes, covering schedule, cost, technical performance, regulatory, and safety dimensions.. Valid values are `negligible|minor|moderate|major|critical`',
    `ip_risk_flag` BOOLEAN COMMENT 'Indicates whether the risk involves intellectual property concerns such as freedom-to-operate issues, patent infringement exposure, or IP ownership disputes with research partners.. Valid values are `true|false`',
    `last_modified_timestamp` TIMESTAMP COMMENT 'Timestamp of the most recent update to the risk record, used for change detection, incremental data loading, and audit compliance in the Databricks Silver layer.. Valid values are `^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$`',
    `last_reviewed_date` DATE COMMENT 'Date of the most recent formal review of the risk record, used to ensure risks are regularly reassessed during stage-gate reviews and portfolio risk meetings.. Valid values are `^d{4}-d{2}-d{2}$`',
    `mitigation_plan` STRING COMMENT 'Detailed description of the actions, controls, and countermeasures planned or in progress to reduce the probability or impact of the identified risk.',
    `next_review_date` DATE COMMENT 'Scheduled date for the next formal review of the risk, ensuring timely reassessment aligned with project milestones and stage-gate cadence.. Valid values are `^d{4}-d{2}-d{2}$`',
    `probability_rating` STRING COMMENT 'Qualitative assessment of the likelihood that the risk event will occur during the R&D project lifecycle, used in risk scoring matrices.. Valid values are `very_low|low|medium|high|very_high`',
    `probability_score` DECIMAL(18,2) COMMENT 'Quantitative probability value between 0.00 and 1.00 representing the estimated likelihood of risk occurrence, enabling numerical risk scoring and portfolio analytics.. Valid values are `^(0(.d{1,2})?|1(.0{1,2})?)$`',
    `regulatory_standard_reference` STRING COMMENT 'Specific regulatory standard or certification requirement associated with the risk (e.g., CE Marking, UL, RoHS, REACH, IEC 62443), enabling compliance risk tracking and regulatory reporting.',
    `residual_risk_score` DECIMAL(18,2) COMMENT 'Risk score remaining after planned mitigation actions are applied, representing the accepted level of risk exposure used in stage-gate go/no-go decisions.',
    `risk_category` STRING COMMENT 'High-level classification of the risk type. Technical covers technology feasibility and TRL gaps; commercial covers market timing and IP freedom-to-operate; regulatory covers CE/UL/RoHS compliance uncertainty; resource covers key personnel and lab capacity.. Valid values are `technical|commercial|regulatory|resource|ip|safety|environmental|financial|schedule|supplier`',
    `risk_number` STRING COMMENT 'Human-readable business reference number for the risk record, used in stage-gate reviews, APQP documentation, and portfolio risk reporting.. Valid values are `^RD-RSK-[0-9]{4}-[0-9]{5}$`',
    `risk_owner` STRING COMMENT 'Name of the individual accountable for monitoring the risk, executing the mitigation plan, and reporting risk status at stage-gate reviews.',
    `risk_priority_number` STRING COMMENT 'Risk Priority Number calculated as the product of severity, occurrence, and detectability ratings, consistent with FMEA methodology used in APQP and DFMEA/PFMEA processes.. Valid values are `^([1-9][0-9]{0,2}|1000)$`',
    `risk_response_strategy` STRING COMMENT 'Selected strategic approach for addressing the risk: avoid (eliminate the risk), mitigate (reduce probability/impact), transfer (shift to third party), accept (acknowledge and monitor), or escalate.. Valid values are `avoid|mitigate|transfer|accept|escalate|monitor`',
    `risk_score` DECIMAL(18,2) COMMENT 'Composite risk score derived from probability and impact assessments, used to prioritize risks in portfolio risk reviews and stage-gate decisions.',
    `risk_subcategory` STRING COMMENT 'Granular classification within the risk category to enable precise risk analysis and targeted mitigation planning (e.g., TRL gap, freedom-to-operate, CE compliance uncertainty).. Valid values are `trl_gap|technology_feasibility|freedom_to_operate|market_timing|ip_infringement|ce_compliance|ul_certification|rohs_reach_compliance|key_person_dependency|lab_capacity|budget_overrun|schedule_delay|supplier_dependency|cybersecurity|safety_hazard`',
    `source_system` STRING COMMENT 'Operational system of record from which the risk record originated (e.g., Siemens Teamcenter PLM for change-driven risks, SAP S/4HANA for resource/financial risks), supporting data lineage in the Databricks Silver layer.. Valid values are `Siemens_Teamcenter|SAP_S4HANA|Siemens_Opcenter|Manual|Other`',
    `stage_gate_phase` STRING COMMENT 'R&D stage-gate phase during which the risk was identified or is most relevant, aligning risk management with APQP stage-gate decision points.. Valid values are `concept|feasibility|development|validation|launch|post_launch`',
    `status` STRING COMMENT 'Current lifecycle status of the risk record, tracking progression from initial identification through active mitigation to closure or acceptance.. Valid values are `identified|under_assessment|open|mitigating|escalated|closed|accepted|transferred`',
    `target_closure_date` DATE COMMENT 'Planned date by which the risk is expected to be fully mitigated or closed, used for tracking mitigation progress against project schedule.. Valid values are `^d{4}-d{2}-d{2}$`',
    `technology_domain` STRING COMMENT 'Technology area to which the risk pertains, enabling domain-specific risk aggregation and portfolio analysis across automation, electrification, and smart infrastructure programs.. Valid values are `automation|electrification|smart_infrastructure|robotics|power_electronics|connectivity|sensing|software|materials|mechanical|thermal|cybersecurity|other`',
    `title` STRING COMMENT 'Short, descriptive title summarizing the nature of the identified R&D risk for quick identification in dashboards and reports.',
    `trl_at_identification` STRING COMMENT 'Technology Readiness Level of the associated technology at the time the risk was identified, providing context for technical risk assessment and TRL gap analysis.. Valid values are `^([1-9])$`',
    CONSTRAINT pk_rd_risk PRIMARY KEY(`rd_risk_id`)
) COMMENT 'Master record for identified risks associated with R&D projects covering technical risks (technology feasibility, TRL gaps), commercial risks (market timing, IP freedom-to-operate), regulatory risks (CE/UL/RoHS compliance uncertainty), and resource risks (key personnel, lab capacity). Captures risk description, risk category, probability, impact severity, risk score, mitigation plan, risk owner, and current risk status. Supports stage-gate risk reviews and portfolio risk management.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` (
    `project_partner_assignment_id` BIGINT COMMENT 'Unique system-generated identifier for each project-partner assignment record',
    `partner_id` BIGINT COMMENT 'Foreign key linking to the external research partner assigned to this project',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to the R&D project that this partner is assigned to',
    `allocated_budget_amount` DECIMAL(18,2) COMMENT 'The budget amount allocated to this specific partner for this specific project. Explicitly identified in detection phase.',
    `assignment_status` STRING COMMENT 'Current operational status of this partner assignment to this project (e.g., Planned, Active, On Hold, Completed, Terminated)',
    `budget_currency_code` STRING COMMENT 'ISO 4217 three-letter currency code for the allocated budget amount',
    `contribution_type` STRING COMMENT 'The type of contribution the partner provides to this specific project (e.g., Research, Development, Testing, Prototyping). Explicitly identified in detection phase.',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this assignment record was created in the system',
    `deliverable_reference` STRING COMMENT 'Reference identifier or description of the specific deliverables this partner is responsible for in this project. Explicitly identified in detection phase.',
    `end_date` DATE COMMENT 'The date when this partners involvement in this specific project ends or is planned to end. Explicitly identified in detection phase.',
    `ip_contribution_flag` BOOLEAN COMMENT 'Indicates whether this partner is contributing intellectual property to this specific project. Explicitly identified in detection phase.',
    `last_modified_by` STRING COMMENT 'User identifier of the person who last modified this assignment record',
    `last_modified_date` TIMESTAMP COMMENT 'Timestamp when this assignment record was last modified',
    `role_in_project` STRING COMMENT 'The specific role that the research partner plays in this R&D project (e.g., Lead Partner, Co-Investigator, Technology Provider, Testing Partner). Explicitly identified in detection phase.',
    `start_date` DATE COMMENT 'The date when this partners involvement in this specific project begins. Explicitly identified in detection phase.',
    `work_package_reference` STRING COMMENT 'Reference to the specific work package or WBS element within the project that this partner is assigned to',
    `created_by` STRING COMMENT 'User identifier of the person who created this assignment record',
    CONSTRAINT pk_project_partner_assignment PRIMARY KEY(`project_partner_assignment_id`)
) COMMENT 'This association product represents the operational assignment of an external research partner to a specific R&D project. It captures the partners role, contribution type, allocated budget, timeline, deliverables, and IP contribution for each project collaboration. Each record links one rd_project to one research_partner with attributes that exist only in the context of this specific project-partner collaboration.. Existence Justification: In industrial manufacturing R&D operations, a single project routinely engages multiple external research partners simultaneously (e.g., a smart infrastructure project may involve a university for algorithm research, a startup for sensor technology, and a national lab for testing), and each research partner participates in multiple R&D projects concurrently. The business actively manages these assignments as operational entities with specific roles, budgets, timelines, and deliverables for each project-partner combination.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` (
    `prototype_sourcing_id` BIGINT COMMENT 'Unique system-generated identifier for each prototype-supplier sourcing relationship record',
    `procurement_supplier_id` BIGINT COMMENT 'Foreign key linking to the supplier who provided components for this prototype',
    `research_prototype_id` BIGINT COMMENT 'Foreign key linking to the R&D prototype record that required component sourcing',
    `component_supplied` STRING COMMENT 'Description or part number of the component/material supplied by this supplier for this prototype build. Identifies what was sourced.',
    `cost` DECIMAL(18,2) COMMENT 'Actual cost paid to this supplier for the component supplied for this prototype. Used for prototype cost tracking and supplier cost comparison.',
    `cost_currency` STRING COMMENT 'ISO 4217 three-letter currency code for the component cost (e.g., USD, EUR, CNY).',
    `created_timestamp` TIMESTAMP COMMENT 'System timestamp when this prototype sourcing record was created in the system.',
    `lead_time_days` STRING COMMENT 'Actual lead time in days from component order to delivery for this prototype build. Used to evaluate supplier responsiveness and plan future prototype schedules.',
    `notes` STRING COMMENT 'Free-text notes capturing additional context about this sourcing relationship, such as quality issues, delivery problems, or special accommodations made by the supplier.',
    `performance_rating` STRING COMMENT 'Evaluation rating of how the supplied component performed during prototype testing. Used to assess supplier quality and suitability for production sourcing.',
    `prototype_phase` STRING COMMENT 'The prototype development phase during which this supplier provided components (proof-of-concept, engineering prototype, pre-production pilot). Aligns with prototype.type classification.',
    `qualification_status` STRING COMMENT 'Qualification decision for this supplier based on their component performance in this prototype. Informs whether the supplier should be considered for production sourcing of this component type.',
    `quantity_supplied` DECIMAL(18,2) COMMENT 'Quantity of the component supplied by this supplier for this prototype build. May be fractional for materials measured by weight or volume.',
    `supply_date` DATE COMMENT 'Date on which the supplier delivered the component for this prototype build. Used to track lead times and supplier responsiveness during R&D.',
    `unit_of_measure` STRING COMMENT 'Unit of measure for the quantity supplied (e.g., EA, KG, M, L). Aligns with procurement and inventory UOM standards.',
    `updated_timestamp` TIMESTAMP COMMENT 'System timestamp when this prototype sourcing record was last updated.',
    CONSTRAINT pk_prototype_sourcing PRIMARY KEY(`prototype_sourcing_id`)
) COMMENT 'This association product represents the sourcing relationship between R&D prototypes and suppliers who provide components for prototype builds. It captures which supplier provided which component for a specific prototype, in which development phase, at what cost, and with what performance outcome. Each record links one prototype to one supplier for a specific component supply transaction, tracking evaluation data critical for production sourcing decisions.. Existence Justification: In industrial manufacturing R&D, prototypes require components from multiple suppliers for experimental builds and comparative evaluation, while suppliers provide parts across multiple prototype iterations and projects. The business actively manages these sourcing relationships to evaluate supplier performance, cost, quality, and lead times during the prototype phase to inform downstream production sourcing decisions. Each prototype-supplier relationship captures specific component supply transactions with performance data and qualification outcomes.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` (
    `prototype_asset_allocation_id` BIGINT COMMENT 'Primary key for prototype_asset_allocation',
    `employee_id` BIGINT COMMENT 'Employee identifier of the lab manager or resource coordinator who created this allocation record',
    `equipment_allocation_id` BIGINT COMMENT 'Unique system-generated identifier for each prototype-asset allocation record',
    `it_asset_id` BIGINT COMMENT 'Foreign key linking to the IT asset (hardware or software) allocated to the prototype project',
    `research_prototype_id` BIGINT COMMENT 'Foreign key linking to the R&D prototype that is using the IT asset during development or testing',
    `allocation_end` DATE COMMENT 'Date on which the IT asset allocation to the prototype project ended and the asset was released back to the shared pool or reassigned. Identified in detection phase as relationship-specific data.',
    `allocation_notes` STRING COMMENT 'Free-text notes capturing special requirements, configuration details, or usage constraints for this specific prototype-asset allocation',
    `allocation_start` DATE COMMENT 'Date on which the IT asset was allocated to the prototype project and became available for use by the R&D team. Identified in detection phase as relationship-specific data.',
    `allocation_status` STRING COMMENT 'Current status of the asset allocation indicating whether it is planned, actively in use, on hold, completed, or cancelled',
    `test_phase` STRING COMMENT 'The R&D test phase during which this IT asset is allocated to the prototype, aligning with the prototype lifecycle and stage-gate process. Identified in detection phase as relationship-specific data.',
    `usage_purpose` STRING COMMENT 'The specific purpose for which the IT asset is being used in the context of this prototype project, such as testing, measurement, control, simulation, or data collection. Identified in detection phase as relationship-specific data.',
    `utilization_hours` DECIMAL(18,2) COMMENT 'Total number of hours the IT asset was actively utilized for this prototype project during the allocation period. Used for capacity planning and asset utilization analysis. Identified in detection phase as relationship-specific data.',
    CONSTRAINT pk_prototype_asset_allocation PRIMARY KEY(`prototype_asset_allocation_id`)
) COMMENT 'This association product represents the allocation of IT assets to R&D prototypes during development and testing phases. It captures the operational assignment of lab equipment, test computers, measurement devices, controllers, and other IT assets to specific prototype projects. Each record links one prototype to one IT asset with allocation periods, usage purpose, test phase context, and utilization metrics that exist only in the context of this relationship. Lab managers actively create, update, and track these allocations to manage shared resource utilization across concurrent prototype projects.. Existence Justification: In industrial manufacturing R&D operations, prototypes require multiple IT assets simultaneously during development and testing (test computers, PLCs, SCADA systems, measurement devices, controllers), and IT assets are shared across multiple concurrent prototype projects. Lab managers actively manage these allocations as operational records, tracking allocation periods, usage purpose, test phase context, and utilization hours for capacity planning and resource optimization.';

CREATE OR REPLACE TABLE `manufacturing_ecm`.`research`.`project_certification` (
    `project_certification_id` BIGINT COMMENT 'Unique surrogate identifier for each project-certification requirement record',
    `engineering_regulatory_certification_id` BIGINT COMMENT 'Foreign key linking to the regulatory certification required for this project',
    `rd_project_id` BIGINT COMMENT 'Foreign key linking to the R&D project requiring this certification',
    `actual_completion_date` DATE COMMENT 'Actual date on which this certification was achieved for this R&D project',
    `certification_scope` STRING COMMENT 'Detailed description of the certification scope specific to this R&D project, including which components, subsystems, or product variants within the project require this certification',
    `certification_status` STRING COMMENT 'Current status of the certification effort for this specific project. Tracks progress from planning through approval specific to this project-certification combination.',
    `compliance_level` STRING COMMENT 'Assessment of the compliance level achieved or expected for this project against this certification requirement',
    `created_date` TIMESTAMP COMMENT 'Timestamp when this project-certification requirement record was created',
    `estimated_cost` DECIMAL(18,2) COMMENT 'Estimated cost for achieving this certification for this project, including testing, documentation, and certification body fees',
    `last_updated_date` TIMESTAMP COMMENT 'Timestamp when this project-certification requirement record was last modified',
    `market_requirement_flag` BOOLEAN COMMENT 'Indicates whether this certification is mandatory for the target markets of this R&D project',
    `notes` STRING COMMENT 'Free-text notes capturing project-specific considerations, risks, or special requirements for this certification effort',
    `priority` STRING COMMENT 'Business priority of achieving this certification for this project, based on market access requirements and customer commitments',
    `responsible_engineer` STRING COMMENT 'Name or employee ID of the engineer from the R&D project team responsible for coordinating this certification effort',
    `target_completion_date` DATE COMMENT 'Target date by which this certification must be achieved for this specific R&D project to meet market launch requirements or stage-gate milestones',
    `testing_phase` STRING COMMENT 'Current phase of testing and validation activities for achieving this certification within this R&D project',
    CONSTRAINT pk_project_certification PRIMARY KEY(`project_certification_id`)
) COMMENT 'This association product represents the regulatory certification requirements and compliance tracking for R&D projects. It captures the specific certifications that each R&D project must achieve for market access, along with project-specific certification scope, target completion dates, testing phases, and compliance status. Each record links one R&D project to one regulatory certification with attributes that exist only in the context of this project-certification relationship.. Existence Justification: In industrial manufacturing R&D operations, projects routinely require multiple regulatory certifications (UL, CE, RoHS, REACH, IEC) for different markets and product components, and each certification standard applies across multiple concurrent R&D projects. The business actively manages project-specific certification requirements as part of stage-gate processes, tracking target dates, testing phases, compliance status, and certification scope unique to each project-certification combination.';

-- ========= FOREIGN KEYS =========
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ADD CONSTRAINT `fk_research_innovation_pipeline_technology_roadmap_id` FOREIGN KEY (`technology_roadmap_id`) REFERENCES `manufacturing_ecm`.`research`.`technology_roadmap`(`technology_roadmap_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ADD CONSTRAINT `fk_research_experimental_bom_research_prototype_id` FOREIGN KEY (`research_prototype_id`) REFERENCES `manufacturing_ecm`.`research`.`research_prototype`(`research_prototype_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ADD CONSTRAINT `fk_research_experimental_bom_line_experimental_bom_id` FOREIGN KEY (`experimental_bom_id`) REFERENCES `manufacturing_ecm`.`research`.`experimental_bom`(`experimental_bom_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ADD CONSTRAINT `fk_research_rd_test_plan_research_prototype_id` FOREIGN KEY (`research_prototype_id`) REFERENCES `manufacturing_ecm`.`research`.`research_prototype`(`research_prototype_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ADD CONSTRAINT `fk_research_rd_test_result_rd_test_plan_id` FOREIGN KEY (`rd_test_plan_id`) REFERENCES `manufacturing_ecm`.`research`.`rd_test_plan`(`rd_test_plan_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ADD CONSTRAINT `fk_research_rd_test_result_research_prototype_id` FOREIGN KEY (`research_prototype_id`) REFERENCES `manufacturing_ecm`.`research`.`research_prototype`(`research_prototype_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ADD CONSTRAINT `fk_research_patent_filing_ip_asset_id` FOREIGN KEY (`ip_asset_id`) REFERENCES `manufacturing_ecm`.`research`.`ip_asset`(`ip_asset_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ADD CONSTRAINT `fk_research_collaboration_agreement_partner_id` FOREIGN KEY (`partner_id`) REFERENCES `manufacturing_ecm`.`research`.`partner`(`partner_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ADD CONSTRAINT `fk_research_rd_expense_rd_budget_id` FOREIGN KEY (`rd_budget_id`) REFERENCES `manufacturing_ecm`.`research`.`rd_budget`(`rd_budget_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ADD CONSTRAINT `fk_research_grant_funding_rd_budget_id` FOREIGN KEY (`rd_budget_id`) REFERENCES `manufacturing_ecm`.`research`.`rd_budget`(`rd_budget_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ADD CONSTRAINT `fk_research_lab_booking_lab_resource_id` FOREIGN KEY (`lab_resource_id`) REFERENCES `manufacturing_ecm`.`research`.`lab_resource`(`lab_resource_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ADD CONSTRAINT `fk_research_lab_booking_rd_test_plan_id` FOREIGN KEY (`rd_test_plan_id`) REFERENCES `manufacturing_ecm`.`research`.`rd_test_plan`(`rd_test_plan_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ADD CONSTRAINT `fk_research_rd_milestone_stage_gate_review_id` FOREIGN KEY (`stage_gate_review_id`) REFERENCES `manufacturing_ecm`.`research`.`stage_gate_review`(`stage_gate_review_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ADD CONSTRAINT `fk_research_technology_readiness_research_prototype_id` FOREIGN KEY (`research_prototype_id`) REFERENCES `manufacturing_ecm`.`research`.`research_prototype`(`research_prototype_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ADD CONSTRAINT `fk_research_rd_document_rd_test_plan_id` FOREIGN KEY (`rd_test_plan_id`) REFERENCES `manufacturing_ecm`.`research`.`rd_test_plan`(`rd_test_plan_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ADD CONSTRAINT `fk_research_project_partner_assignment_partner_id` FOREIGN KEY (`partner_id`) REFERENCES `manufacturing_ecm`.`research`.`partner`(`partner_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ADD CONSTRAINT `fk_research_prototype_sourcing_research_prototype_id` FOREIGN KEY (`research_prototype_id`) REFERENCES `manufacturing_ecm`.`research`.`research_prototype`(`research_prototype_id`);
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ADD CONSTRAINT `fk_research_prototype_asset_allocation_research_prototype_id` FOREIGN KEY (`research_prototype_id`) REFERENCES `manufacturing_ecm`.`research`.`research_prototype`(`research_prototype_id`);

-- ========= TAGS =========
ALTER SCHEMA `manufacturing_ecm`.`research` SET TAGS ('dbx_division' = 'operations');
ALTER SCHEMA `manufacturing_ecm`.`research` SET TAGS ('dbx_domain' = 'research');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` SET TAGS ('dbx_subdomain' = 'portfolio_strategy');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `innovation_pipeline_id` SET TAGS ('dbx_business_glossary_term' = 'Innovation Pipeline ID');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `technology_roadmap_id` SET TAGS ('dbx_business_glossary_term' = 'Technology Roadmap Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `applicable_regulation` SET TAGS ('dbx_business_glossary_term' = 'Applicable Regulation or Standard');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'phase_1_planning|phase_2_product_design|phase_3_process_design|phase_4_validation|phase_5_launch|not_applicable');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Innovation Description');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `description` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `estimated_commercial_value_usd` SET TAGS ('dbx_business_glossary_term' = 'Estimated Commercial Value (USD)');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `estimated_commercial_value_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `estimated_rd_investment_usd` SET TAGS ('dbx_business_glossary_term' = 'Estimated R&D Investment (USD)');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `estimated_rd_investment_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `expected_roi_percent` SET TAGS ('dbx_business_glossary_term' = 'Expected Return on Investment (ROI) Percent');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `expected_roi_percent` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Involved Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `external_partner_name` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Name');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `feasibility_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Feasibility Assessment Completion Date');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `feasibility_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `feasibility_score` SET TAGS ('dbx_business_glossary_term' = 'Feasibility Score');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `feasibility_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `innovation_category` SET TAGS ('dbx_business_glossary_term' = 'Innovation Category');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `innovation_category` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|digital_manufacturing|sustainability|materials|process_improvement|other');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `innovation_type` SET TAGS ('dbx_business_glossary_term' = 'Innovation Type');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `innovation_type` SET TAGS ('dbx_value_regex' = 'incremental|adjacent|disruptive|platform|product|process|business_model');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `ip_protection_type` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Protection Type');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `ip_protection_type` SET TAGS ('dbx_value_regex' = 'patent_pending|patent_granted|trade_secret|copyright|open_source|none|under_review');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `ip_protection_type` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `last_stage_transition_date` SET TAGS ('dbx_business_glossary_term' = 'Last Stage Transition Date');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `last_stage_transition_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `owning_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Owning Business Unit');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `owning_country_code` SET TAGS ('dbx_business_glossary_term' = 'Owning Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `owning_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `patent_application_number` SET TAGS ('dbx_business_glossary_term' = 'Patent Application Number');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `patent_application_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `payback_period_months` SET TAGS ('dbx_business_glossary_term' = 'Payback Period (Months)');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `payback_period_months` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `pipeline_code` SET TAGS ('dbx_business_glossary_term' = 'Innovation Pipeline Code');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `pipeline_code` SET TAGS ('dbx_value_regex' = '^INN-[A-Z]{2,6}-[0-9]{4}-[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `pipeline_owner` SET TAGS ('dbx_business_glossary_term' = 'Pipeline Owner');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `pipeline_stage` SET TAGS ('dbx_business_glossary_term' = 'Pipeline Stage');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `pipeline_stage` SET TAGS ('dbx_value_regex' = 'ideation|concept_screening|feasibility|development|validation|pilot|commercialization|archived');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `prototype_required` SET TAGS ('dbx_business_glossary_term' = 'Prototype Required Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `prototype_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `regulatory_compliance_required` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Required Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `regulatory_compliance_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Innovation Risk Level');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'very_low|low|medium|high|very_high');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `screening_date` SET TAGS ('dbx_business_glossary_term' = 'Concept Screening Date');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `screening_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `source_of_idea` SET TAGS ('dbx_business_glossary_term' = 'Source of Innovation Idea');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `source_of_idea` SET TAGS ('dbx_value_regex' = 'internal_rd|customer_feedback|market_research|competitor_analysis|academic_research|supplier_suggestion|regulatory_requirement|employee_suggestion|other');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `stage_gate_status` SET TAGS ('dbx_business_glossary_term' = 'Stage Gate Status');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `stage_gate_status` SET TAGS ('dbx_value_regex' = 'pending_review|approved|conditionally_approved|on_hold|rejected|cancelled');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `strategic_priority_tier` SET TAGS ('dbx_business_glossary_term' = 'Strategic Priority Tier');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `strategic_priority_tier` SET TAGS ('dbx_value_regex' = 'tier_1_critical|tier_2_high|tier_3_medium|tier_4_low');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Submission Date');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `submitter_name` SET TAGS ('dbx_business_glossary_term' = 'Innovation Submitter Name');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `sustainability_impact` SET TAGS ('dbx_business_glossary_term' = 'Sustainability Impact Classification');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `sustainability_impact` SET TAGS ('dbx_value_regex' = 'positive|neutral|negative|under_assessment');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `target_commercialization_date` SET TAGS ('dbx_business_glossary_term' = 'Target Commercialization Date');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `target_commercialization_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `target_market_segment` SET TAGS ('dbx_business_glossary_term' = 'Target Market Segment');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `target_market_segment` SET TAGS ('dbx_value_regex' = 'factory_automation|building_infrastructure|transportation|urban_environment|energy_utilities|cross_industry|other');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `technology_readiness_level` SET TAGS ('dbx_business_glossary_term' = 'Technology Readiness Level (TRL)');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `technology_readiness_level` SET TAGS ('dbx_value_regex' = '^([1-9])$');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Innovation Title');
ALTER TABLE `manufacturing_ecm`.`research`.`innovation_pipeline` ALTER COLUMN `title` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` SET TAGS ('dbx_subdomain' = 'portfolio_strategy');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `technology_roadmap_id` SET TAGS ('dbx_business_glossary_term' = 'Technology Roadmap ID');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `annual_investment_usd` SET TAGS ('dbx_business_glossary_term' = 'Annual Research and Development (R&D) Investment (USD)');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `annual_investment_usd` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `annual_investment_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Roadmap Approved Date');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `capability_gap_summary` SET TAGS ('dbx_business_glossary_term' = 'Capability Gap Summary');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `competitive_benchmark_summary` SET TAGS ('dbx_business_glossary_term' = 'Competitive Benchmark Summary');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `corporate_strategy_alignment` SET TAGS ('dbx_business_glossary_term' = 'Corporate Strategy Alignment');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Technology Roadmap Description');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Involved Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `external_partner_names` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Names');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `gate_review_outcome` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Review Outcome');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `gate_review_outcome` SET TAGS ('dbx_value_regex' = 'Go|Conditional Go|Hold|Recycle|Kill');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_business_glossary_term' = 'Geographic Scope');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `horizon_end_date` SET TAGS ('dbx_business_glossary_term' = 'Roadmap Horizon End Date');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `horizon_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `horizon_start_date` SET TAGS ('dbx_business_glossary_term' = 'Roadmap Horizon Start Date');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `horizon_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `horizon_years` SET TAGS ('dbx_business_glossary_term' = 'Roadmap Horizon Duration (Years)');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `horizon_years` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]?$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `investment_currency` SET TAGS ('dbx_business_glossary_term' = 'Investment Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `investment_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `ip_strategy` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Strategy');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `ip_strategy` SET TAGS ('dbx_value_regex' = 'Patent|Trade Secret|Open Source|Licensing|Joint IP|Defensive Publication|Not Applicable');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `ip_strategy` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `last_gate_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Stage-Gate Review Date');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `last_gate_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Last Reviewed Date');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `lead_engineer` SET TAGS ('dbx_business_glossary_term' = 'Lead Engineer');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `maturity_level` SET TAGS ('dbx_business_glossary_term' = 'Technology Maturity Level');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `maturity_level` SET TAGS ('dbx_value_regex' = 'Concept|Research|Development|Validation|Pilot|Production Ready|Mature|End of Life');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Technology Roadmap Name');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `next_gate_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Stage-Gate Review Date');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `next_gate_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Review Date');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `patent_count_target` SET TAGS ('dbx_business_glossary_term' = 'Target Patent Count');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `patent_count_target` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `planned_rd_investment_usd` SET TAGS ('dbx_business_glossary_term' = 'Planned Research and Development (R&D) Investment (USD)');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `planned_rd_investment_usd` SET TAGS ('dbx_value_regex' = '^[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `planned_rd_investment_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `product_family` SET TAGS ('dbx_business_glossary_term' = 'Product Family');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `regulatory_compliance_requirements` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Requirements');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `responsible_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Responsible Business Unit');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `roadmap_code` SET TAGS ('dbx_business_glossary_term' = 'Technology Roadmap Code');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `roadmap_code` SET TAGS ('dbx_value_regex' = '^TRM-[A-Z0-9]{3,10}-[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `roadmap_owner` SET TAGS ('dbx_business_glossary_term' = 'Technology Roadmap Owner');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `roadmap_type` SET TAGS ('dbx_business_glossary_term' = 'Roadmap Type');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `roadmap_type` SET TAGS ('dbx_value_regex' = 'Product|Platform|Technology|Market|Capability|Integration');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_value_regex' = 'Gate 0 - Ideation|Gate 1 - Scoping|Gate 2 - Business Case|Gate 3 - Development|Gate 4 - Testing and Validation|Gate 5 - Launch|Post-Launch Review');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Technology Roadmap Status');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'Draft|Under Review|Approved|Active|On Hold|Superseded|Archived|Cancelled');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `strategic_priority` SET TAGS ('dbx_business_glossary_term' = 'Strategic Priority');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `strategic_priority` SET TAGS ('dbx_value_regex' = 'Critical|High|Medium|Low');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `sustainability_alignment` SET TAGS ('dbx_business_glossary_term' = 'Sustainability Alignment');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `sustainability_alignment` SET TAGS ('dbx_value_regex' = 'Net Zero|Energy Efficiency|Circular Economy|Emissions Reduction|Sustainable Materials|Not Applicable');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'PLC/DCS Automation|Electrification Drives|IIoT Smart Infrastructure|Industrial Robotics|Power Electronics|Edge Computing|Digital Twin|Cybersecurity|Human-Machine Interface|Other');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `technology_readiness_level` SET TAGS ('dbx_business_glossary_term' = 'Technology Readiness Level (TRL)');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `technology_readiness_level` SET TAGS ('dbx_value_regex' = '^[1-9]$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Roadmap Version Number');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_roadmap` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` SET TAGS ('dbx_subdomain' = 'portfolio_strategy');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `stage_gate_review_id` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Review ID');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `apqp_project_id` SET TAGS ('dbx_business_glossary_term' = 'Apqp Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Assessment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `action_items` SET TAGS ('dbx_business_glossary_term' = 'Gate Action Items');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'Phase 1 – Plan and Define|Phase 2 – Product Design and Development|Phase 3 – Process Design and Development|Phase 4 – Product and Process Validation|Phase 5 – Feedback Assessment and Corrective Action');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `budget_approved_amount` SET TAGS ('dbx_business_glossary_term' = 'Budget Approved Amount');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `budget_approved_amount` SET TAGS ('dbx_value_regex' = '^-?[0-9]+(.[0-9]{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `budget_approved_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Budget Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `commercial_viability_score` SET TAGS ('dbx_business_glossary_term' = 'Commercial Viability Score');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `commercial_viability_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `committee_members` SET TAGS ('dbx_business_glossary_term' = 'Review Committee Members');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `committee_size` SET TAGS ('dbx_business_glossary_term' = 'Review Committee Size');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `committee_size` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `conditions_for_go` SET TAGS ('dbx_business_glossary_term' = 'Conditions for Go');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `decision` SET TAGS ('dbx_business_glossary_term' = 'Gate Decision');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `decision` SET TAGS ('dbx_value_regex' = 'Go|No-Go|Hold|Recycle');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `decision_rationale` SET TAGS ('dbx_business_glossary_term' = 'Gate Decision Rationale');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Involved');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `external_partner_name` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Name');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `gate_name` SET TAGS ('dbx_business_glossary_term' = 'Gate Name');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `gate_number` SET TAGS ('dbx_business_glossary_term' = 'Gate Number');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `gate_number` SET TAGS ('dbx_value_regex' = 'G0|G1|G2|G3|G4|G5');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `gate_score_threshold` SET TAGS ('dbx_business_glossary_term' = 'Gate Score Threshold');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `gate_score_threshold` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `ip_risk_flag` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Risk Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `ip_risk_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `next_gate_number` SET TAGS ('dbx_business_glossary_term' = 'Next Gate Number');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `next_gate_number` SET TAGS ('dbx_value_regex' = 'G0|G1|G2|G3|G4|G5');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `next_gate_target_date` SET TAGS ('dbx_business_glossary_term' = 'Next Gate Target Date');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `next_gate_target_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Review Notes');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `open_action_item_count` SET TAGS ('dbx_business_glossary_term' = 'Open Action Item Count');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `open_action_item_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `overall_gate_score` SET TAGS ('dbx_business_glossary_term' = 'Overall Gate Score');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `overall_gate_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `planned_review_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Review Date');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `planned_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `presentation_document_ref` SET TAGS ('dbx_business_glossary_term' = 'Gate Review Presentation Document Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `project_phase` SET TAGS ('dbx_business_glossary_term' = 'R&D Project Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `project_phase` SET TAGS ('dbx_value_regex' = 'Ideation|Concept|Feasibility|Development|Validation|Launch|Post-Launch');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `resource_availability_score` SET TAGS ('dbx_business_glossary_term' = 'Resource Availability Score');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `resource_availability_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `review_chair` SET TAGS ('dbx_business_glossary_term' = 'Review Committee Chair');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'Review Date');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `review_duration_minutes` SET TAGS ('dbx_business_glossary_term' = 'Review Duration (Minutes)');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `review_duration_minutes` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `review_location` SET TAGS ('dbx_business_glossary_term' = 'Review Location');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `review_minutes_document_ref` SET TAGS ('dbx_business_glossary_term' = 'Review Minutes Document Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `review_number` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Review Number');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `review_number` SET TAGS ('dbx_value_regex' = '^SGR-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `review_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Review Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `review_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `review_type` SET TAGS ('dbx_business_glossary_term' = 'Review Type');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `review_type` SET TAGS ('dbx_value_regex' = 'Formal|Informal|Emergency|Scheduled|Ad-Hoc');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `risk_assessment_score` SET TAGS ('dbx_business_glossary_term' = 'Risk Assessment Score');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `risk_assessment_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Review Status');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'Scheduled|In Progress|Completed|Cancelled|Deferred');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `strategic_alignment_score` SET TAGS ('dbx_business_glossary_term' = 'Strategic Alignment Score');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `strategic_alignment_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `technical_readiness_score` SET TAGS ('dbx_business_glossary_term' = 'Technical Readiness Score');
ALTER TABLE `manufacturing_ecm`.`research`.`stage_gate_review` ALTER COLUMN `technical_readiness_score` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` SET TAGS ('dbx_subdomain' = 'prototype_development');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `research_prototype_id` SET TAGS ('dbx_business_glossary_term' = 'Prototype ID');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `contract_id` SET TAGS ('dbx_business_glossary_term' = 'Service Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `fmea_id` SET TAGS ('dbx_business_glossary_term' = 'Fmea Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `hazard_assessment_id` SET TAGS ('dbx_business_glossary_term' = 'Hazard Assessment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `installation_record_id` SET TAGS ('dbx_business_glossary_term' = 'Installation Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `inventory_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `ot_system_id` SET TAGS ('dbx_business_glossary_term' = 'Ot System Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `packaging_id` SET TAGS ('dbx_business_glossary_term' = 'Packaging Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `account_id` SET TAGS ('dbx_business_glossary_term' = 'Pilot Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `procurement_goods_receipt_id` SET TAGS ('dbx_business_glossary_term' = 'Goods Receipt Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `product_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Product Certification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `production_plant_id` SET TAGS ('dbx_business_glossary_term' = 'Production Plant Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `serialized_unit_id` SET TAGS ('dbx_business_glossary_term' = 'Serialized Unit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `actual_build_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Build Date');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `actual_build_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `actual_test_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Test Completion Date');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `actual_test_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `actual_test_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Test Start Date');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `actual_test_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `build_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Prototype Build Cost Amount');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `build_cost_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `build_cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Prototype Build Cost Currency');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `build_cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `build_location` SET TAGS ('dbx_business_glossary_term' = 'Prototype Build Location');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `build_site_country` SET TAGS ('dbx_business_glossary_term' = 'Build Site Country');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `build_site_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `dfmea_reference` SET TAGS ('dbx_business_glossary_term' = 'Design Failure Mode and Effects Analysis (DFMEA) Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `dimensions_mm` SET TAGS ('dbx_business_glossary_term' = 'Prototype Dimensions (mm)');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `dimensions_mm` SET TAGS ('dbx_value_regex' = '^d+(.d+)?xd+(.d+)?xd+(.d+)?$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `disposition` SET TAGS ('dbx_business_glossary_term' = 'Prototype Disposition');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `disposition` SET TAGS ('dbx_value_regex' = 'retain|test|destroy|transfer_to_engineering|archive|donate');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `experimental_bom_reference` SET TAGS ('dbx_business_glossary_term' = 'Experimental Bill of Materials (BOM) Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Involved Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `external_partner_name` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Name');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `generation_number` SET TAGS ('dbx_business_glossary_term' = 'Prototype Generation Number');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `generation_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `ip_classification` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Classification');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `ip_classification` SET TAGS ('dbx_value_regex' = 'proprietary|patent_pending|patented|trade_secret|open_source|licensed|unclassified');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `ip_classification` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `is_virtual` SET TAGS ('dbx_business_glossary_term' = 'Is Virtual Prototype Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `is_virtual` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `iteration_number` SET TAGS ('dbx_business_glossary_term' = 'Prototype Iteration Number');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `iteration_number` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Prototype Name');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `number` SET TAGS ('dbx_business_glossary_term' = 'Prototype Number');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `number` SET TAGS ('dbx_value_regex' = '^PRO-[A-Z0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `patent_application_number` SET TAGS ('dbx_business_glossary_term' = 'Patent Application Number');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `patent_application_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `planned_build_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Build Date');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `planned_build_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `planned_test_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Test Completion Date');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `planned_test_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `planned_test_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Test Start Date');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `planned_test_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `quantity_built` SET TAGS ('dbx_business_glossary_term' = 'Quantity Built');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `quantity_built` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `regulatory_compliance_scope` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Scope');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `safety_review_status` SET TAGS ('dbx_business_glossary_term' = 'Safety Review Status');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `safety_review_status` SET TAGS ('dbx_value_regex' = 'not_required|pending|in_review|approved|rejected');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'teamcenter_plm|opcenter_mes|sap_s4hana|mindsphere|manual|other');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_value_regex' = 'ideation|concept|feasibility|development|validation|launch_readiness');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Prototype Build Status');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'planned|in_build|build_complete|under_test|test_complete|on_hold|cancelled|disposed');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `storage_location` SET TAGS ('dbx_business_glossary_term' = 'Prototype Storage Location');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `target_spec_reference` SET TAGS ('dbx_business_glossary_term' = 'Target Specification Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|robotics|power_electronics|connectivity|sensing|software|other');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `test_outcome` SET TAGS ('dbx_business_glossary_term' = 'Prototype Test Outcome');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `test_outcome` SET TAGS ('dbx_value_regex' = 'pass|fail|partial_pass|inconclusive|pending');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `test_report_reference` SET TAGS ('dbx_business_glossary_term' = 'Test Report Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Prototype Type');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'proof_of_concept|engineering_prototype|pre_production_pilot|virtual_simulation|breadboard|alpha|beta');
ALTER TABLE `manufacturing_ecm`.`research`.`research_prototype` ALTER COLUMN `weight_kg` SET TAGS ('dbx_business_glossary_term' = 'Prototype Weight (kg)');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` SET TAGS ('dbx_subdomain' = 'prototype_development');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `experimental_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Experimental Bill of Materials (BOM) ID');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `chemical_substance_id` SET TAGS ('dbx_business_glossary_term' = 'Chemical Substance Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `compliance_reach_substance_declaration_id` SET TAGS ('dbx_business_glossary_term' = 'Reach Substance Declaration Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `research_prototype_id` SET TAGS ('dbx_business_glossary_term' = 'Prototype Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `engineering_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Source System BOM Identifier');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'phase_1_plan_define|phase_2_product_design|phase_3_process_design|phase_4_product_validation|phase_5_launch');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `bom_number` SET TAGS ('dbx_business_glossary_term' = 'Experimental Bill of Materials (BOM) Number');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `bom_number` SET TAGS ('dbx_value_regex' = '^EBOM-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `bom_type` SET TAGS ('dbx_business_glossary_term' = 'Experimental BOM Type');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `bom_type` SET TAGS ('dbx_value_regex' = 'prototype|pre_production|feasibility|concept|validation');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `design_maturity_level` SET TAGS ('dbx_business_glossary_term' = 'Technology Readiness Level (TRL)');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `design_maturity_level` SET TAGS ('dbx_value_regex' = 'TRL1|TRL2|TRL3|TRL4|TRL5|TRL6|TRL7|TRL8|TRL9');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `ecn_reference` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `estimated_material_cost` SET TAGS ('dbx_business_glossary_term' = 'Estimated Material Cost');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `estimated_material_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `external_partner_code` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Code');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `frozen_date` SET TAGS ('dbx_business_glossary_term' = 'BOM Frozen Date');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `frozen_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `ip_classification` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Classification');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `ip_classification` SET TAGS ('dbx_value_regex' = 'proprietary|joint_development|licensed_in|open_source|public_domain');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `ip_classification` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `line_count` SET TAGS ('dbx_business_glossary_term' = 'BOM Line Count');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'BOM Notes');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `owning_department` SET TAGS ('dbx_business_glossary_term' = 'Owning Department');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `parent_assembly_number` SET TAGS ('dbx_business_glossary_term' = 'Parent Assembly Number');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `patent_reference` SET TAGS ('dbx_business_glossary_term' = 'Patent Reference Number');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `patent_reference` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `plant_code` SET TAGS ('dbx_business_glossary_term' = 'Plant Code');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `product_line` SET TAGS ('dbx_business_glossary_term' = 'Product Line');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'BOM Header Quantity');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `regulatory_compliance_flags` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flags');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `regulatory_compliance_flags` SET TAGS ('dbx_value_regex' = 'reach|rohs|ce_marking|ul|none|multiple');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `responsible_engineer` SET TAGS ('dbx_business_glossary_term' = 'Responsible Engineer');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `revision` SET TAGS ('dbx_business_glossary_term' = 'BOM Revision Level');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `revision` SET TAGS ('dbx_value_regex' = '^[A-Z]{1,3}[0-9]{0,3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'teamcenter|sap_s4hana|opcenter|manual|other');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_value_regex' = 'ideation|concept|feasibility|development|validation|launch_readiness');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Experimental BOM Status');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|frozen|superseded|cancelled');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `target_cost` SET TAGS ('dbx_business_glossary_term' = 'Target Material Cost');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `target_cost` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|robotics|digitalization|other');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Experimental BOM Title');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|M|M2|M3|L|SET|PCE|ASY');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_business_glossary_term' = 'Valid From Date');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `valid_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_business_glossary_term' = 'Valid To Date');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom` ALTER COLUMN `valid_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` SET TAGS ('dbx_subdomain' = 'prototype_development');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `experimental_bom_line_id` SET TAGS ('dbx_business_glossary_term' = 'Experimental Bill of Materials (BOM) Line ID');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `catalog_item_id` SET TAGS ('dbx_business_glossary_term' = 'Catalog Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `component_id` SET TAGS ('dbx_business_glossary_term' = 'Component Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `experimental_bom_id` SET TAGS ('dbx_business_glossary_term' = 'Experimental Bom Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `inventory_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `procurement_material_info_record_id` SET TAGS ('dbx_business_glossary_term' = 'Material Info Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `approved_manufacturer_name` SET TAGS ('dbx_business_glossary_term' = 'Approved Manufacturer Name');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `approved_manufacturer_number` SET TAGS ('dbx_business_glossary_term' = 'Approved Manufacturer Part Number');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `approved_manufacturer_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,40}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `bom_change_reason` SET TAGS ('dbx_business_glossary_term' = 'BOM Change Reason');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `component_type` SET TAGS ('dbx_business_glossary_term' = 'Component Type');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `component_type` SET TAGS ('dbx_value_regex' = 'raw_material|purchased_component|sub_assembly|semi_finished|consumable|tooling|phantom');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Cost Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `cost_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `ecn_reference` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `ecn_reference` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,30}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_business_glossary_term' = 'Effective From Date');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `effective_from_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_business_glossary_term' = 'Effective To Date');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `effective_to_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `find_number` SET TAGS ('dbx_business_glossary_term' = 'Find Number');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `find_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `hazardous_material_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `is_critical_component` SET TAGS ('dbx_business_glossary_term' = 'Critical Component Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `is_critical_component` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `is_long_lead_item` SET TAGS ('dbx_business_glossary_term' = 'Long Lead Item Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `is_long_lead_item` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `is_substitute` SET TAGS ('dbx_business_glossary_term' = 'Substitute Component Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `is_substitute` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Component Lead Time (Days)');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_value_regex' = '^[0-9]{1,4}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `line_notes` SET TAGS ('dbx_business_glossary_term' = 'BOM Line Notes');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `line_number` SET TAGS ('dbx_business_glossary_term' = 'BOM Line Number');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `line_number` SET TAGS ('dbx_value_regex' = '^[0-9]{1,6}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `line_status` SET TAGS ('dbx_business_glossary_term' = 'BOM Line Status');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `line_status` SET TAGS ('dbx_value_regex' = 'draft|active|under_review|approved|superseded|cancelled');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `make_or_buy` SET TAGS ('dbx_business_glossary_term' = 'Make or Buy Indicator');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `make_or_buy` SET TAGS ('dbx_value_regex' = 'make|buy|either');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `material_spec_reference` SET TAGS ('dbx_business_glossary_term' = 'Material Specification Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `preferred_supplier_name` SET TAGS ('dbx_business_glossary_term' = 'Preferred Supplier Name');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `prototype_build_quantity` SET TAGS ('dbx_business_glossary_term' = 'Prototype Build Quantity');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `prototype_build_quantity` SET TAGS ('dbx_value_regex' = '^[0-9]{1,12}(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `quantity` SET TAGS ('dbx_business_glossary_term' = 'Component Quantity');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `quantity` SET TAGS ('dbx_value_regex' = '^[0-9]{1,12}(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `quantity_per_assembly` SET TAGS ('dbx_business_glossary_term' = 'Quantity Per Assembly');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `quantity_per_assembly` SET TAGS ('dbx_value_regex' = '^[0-9]{1,12}(.[0-9]{1,6})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_business_glossary_term' = 'Registration Evaluation Authorization and Restriction of Chemicals (REACH) Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `reach_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `reference_designator` SET TAGS ('dbx_business_glossary_term' = 'Reference Designator');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `revision_level` SET TAGS ('dbx_business_glossary_term' = 'Component Revision Level');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `revision_level` SET TAGS ('dbx_value_regex' = '^[A-Z0-9]{1,5}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_business_glossary_term' = 'Restriction of Hazardous Substances (RoHS) Compliant Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `rohs_compliant` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `scrap_factor_percent` SET TAGS ('dbx_business_glossary_term' = 'Scrap Factor Percentage');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `scrap_factor_percent` SET TAGS ('dbx_value_regex' = '^[0-9]{1,3}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'teamcenter|sap_s4hana|opcenter|manual');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `sourcing_status` SET TAGS ('dbx_business_glossary_term' = 'Component Sourcing Status');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `sourcing_status` SET TAGS ('dbx_value_regex' = 'available|to_be_sourced|substitute|on_order|in_stock|obsolete|under_evaluation');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_value_regex' = 'concept|feasibility|design|prototype|validation|pilot|release');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `substitute_for_component_number` SET TAGS ('dbx_business_glossary_term' = 'Substitute For Component Number');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `substitute_for_component_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,40}$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `unit_cost_estimate` SET TAGS ('dbx_business_glossary_term' = 'Unit Cost Estimate');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `unit_cost_estimate` SET TAGS ('dbx_value_regex' = '^[0-9]{1,14}(.[0-9]{1,4})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `unit_cost_estimate` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure (UoM)');
ALTER TABLE `manufacturing_ecm`.`research`.`experimental_bom_line` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_value_regex' = 'EA|KG|G|LB|M|MM|CM|L|ML|M2|M3|PC|SET|LOT|HR|MIN');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` SET TAGS ('dbx_subdomain' = 'validation_testing');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `rd_test_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Research and Development (R&D) Test Plan ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `application_id` SET TAGS ('dbx_business_glossary_term' = 'Application Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Test Engineer Employee ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `fmea_id` SET TAGS ('dbx_business_glossary_term' = 'Fmea Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `inventory_sku_id` SET TAGS ('dbx_business_glossary_term' = 'Prototype Sku Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `research_prototype_id` SET TAGS ('dbx_business_glossary_term' = 'Prototype Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `safety_audit_id` SET TAGS ('dbx_business_glossary_term' = 'Safety Audit Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `work_center_id` SET TAGS ('dbx_business_glossary_term' = 'Work Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `acceptance_criteria` SET TAGS ('dbx_business_glossary_term' = 'Acceptance Criteria');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Test End Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `actual_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Test Start Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `actual_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `applicable_standards` SET TAGS ('dbx_business_glossary_term' = 'Applicable Standards');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Test Plan Approval Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `approver_name` SET TAGS ('dbx_business_glossary_term' = 'Test Plan Approver Name');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `approver_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'plan_and_define|product_design_and_development|process_design_and_development|product_and_process_validation|launch_feedback_and_corrective_action');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `budget_currency` SET TAGS ('dbx_business_glossary_term' = 'Budget Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `budget_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `calibration_required` SET TAGS ('dbx_business_glossary_term' = 'Calibration Required Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `calibration_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `design_handoff_cleared` SET TAGS ('dbx_business_glossary_term' = 'Design Handoff Cleared Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `design_handoff_cleared` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Involved Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `external_partner_name` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Name');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `ip_classification` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Classification');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `ip_classification` SET TAGS ('dbx_value_regex' = 'proprietary|trade_secret|patent_pending|patented|open_source|confidential|public');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `number_of_test_cases` SET TAGS ('dbx_business_glossary_term' = 'Number of Test Cases');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `number_of_test_cases` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_business_glossary_term' = 'Test Plan Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `plan_number` SET TAGS ('dbx_value_regex' = '^TP-[A-Z0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `planned_end_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Test End Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `planned_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Test Start Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `planned_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `regulatory_compliance_scope` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Scope');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `required_test_equipment` SET TAGS ('dbx_business_glossary_term' = 'Required Test Equipment');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `responsible_engineer` SET TAGS ('dbx_business_glossary_term' = 'Responsible Test Engineer');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `responsible_engineer` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Test Plan Risk Level');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'low|medium|high|critical');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `scope_description` SET TAGS ('dbx_business_glossary_term' = 'Test Scope Description');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `stage_gate` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `stage_gate` SET TAGS ('dbx_value_regex' = 'gate_0|gate_1|gate_2|gate_3|gate_4|gate_5');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Test Plan Status');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|approved|active|on_hold|completed|cancelled');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|transportation|building_systems|industrial_iot|robotics|power_electronics|other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `test_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Test Plan Budget Amount');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `test_budget_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `test_location_country` SET TAGS ('dbx_business_glossary_term' = 'Test Location Country');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `test_location_country` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `test_phase` SET TAGS ('dbx_business_glossary_term' = 'Test Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `test_phase` SET TAGS ('dbx_value_regex' = 'lab|environmental|field|pilot|production_validation');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `test_result_summary` SET TAGS ('dbx_business_glossary_term' = 'Test Result Summary');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `test_result_summary` SET TAGS ('dbx_value_regex' = 'pass|fail|partial_pass|inconclusive|not_yet_executed');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `test_type` SET TAGS ('dbx_business_glossary_term' = 'Test Type');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `test_type` SET TAGS ('dbx_value_regex' = 'design_verification|design_validation|prototype_testing|environmental|performance|safety|compliance|field_trial|accelerated_life');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Test Plan Title');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Test Plan Version');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_plan` ALTER COLUMN `version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` SET TAGS ('dbx_subdomain' = 'validation_testing');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `rd_test_result_id` SET TAGS ('dbx_business_glossary_term' = 'R&D Test Result ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `characteristic_id` SET TAGS ('dbx_business_glossary_term' = 'Quality Characteristic Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `design_validation_test_id` SET TAGS ('dbx_business_glossary_term' = 'Design Validation Test Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Reviewed By Employee ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `field_service_order_id` SET TAGS ('dbx_business_glossary_term' = 'Field Service Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `product_regulatory_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Certification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `rd_test_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Test Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `research_prototype_id` SET TAGS ('dbx_business_glossary_term' = 'Prototype Identifier');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `rohs_compliance_record_id` SET TAGS ('dbx_business_glossary_term' = 'Rohs Compliance Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `case_id` SET TAGS ('dbx_business_glossary_term' = 'Test Case Identifier');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `case_id` SET TAGS ('dbx_value_regex' = '^TC-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_engineer_employee_id` SET TAGS ('dbx_business_glossary_term' = 'Test Engineer Employee ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_engineer_employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Test Equipment Identifier');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `calibration_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Calibration Certificate Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `comments` SET TAGS ('dbx_business_glossary_term' = 'Test Result Comments');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `deviation_from_nominal` SET TAGS ('dbx_business_glossary_term' = 'Deviation from Nominal');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `disposition` SET TAGS ('dbx_business_glossary_term' = 'Disposition Recommendation');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `disposition` SET TAGS ('dbx_value_regex' = 'accept|reject|use_as_is|rework|scrap|return_to_supplier|hold_for_review|deviate');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `disposition_rationale` SET TAGS ('dbx_business_glossary_term' = 'Disposition Rationale');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `failure_description` SET TAGS ('dbx_business_glossary_term' = 'Failure Description');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `failure_mode` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `lower_acceptance_limit` SET TAGS ('dbx_business_glossary_term' = 'Lower Acceptance Limit');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `measured_value` SET TAGS ('dbx_business_glossary_term' = 'Measured Value');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `ncr_number` SET TAGS ('dbx_business_glossary_term' = 'Non-Conformance Report (NCR) Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `nominal_value` SET TAGS ('dbx_business_glossary_term' = 'Nominal Target Value');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `project_code` SET TAGS ('dbx_business_glossary_term' = 'R&D Project Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `project_code` SET TAGS ('dbx_value_regex' = '^RD-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `result_status` SET TAGS ('dbx_business_glossary_term' = 'Test Result Status');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `result_status` SET TAGS ('dbx_value_regex' = 'pass|fail|conditional_pass|inconclusive|void|pending_review');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `retest_required` SET TAGS ('dbx_business_glossary_term' = 'Retest Required Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `retest_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `retest_sequence_number` SET TAGS ('dbx_business_glossary_term' = 'Retest Sequence Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `retest_sequence_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `review_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Review Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `review_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `severity_rating` SET TAGS ('dbx_business_glossary_term' = 'Failure Severity Rating');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `severity_rating` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `site_code` SET TAGS ('dbx_business_glossary_term' = 'Site Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_value_regex' = 'concept|feasibility|design|prototype|validation|pilot|launch|post_launch');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `technology_readiness_level` SET TAGS ('dbx_business_glossary_term' = 'Technology Readiness Level (TRL)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `technology_readiness_level` SET TAGS ('dbx_value_regex' = '^([1-9])$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_category` SET TAGS ('dbx_business_glossary_term' = 'Test Category');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_category` SET TAGS ('dbx_value_regex' = 'design_verification|design_validation|process_validation|first_article_inspection|qualification|certification|exploratory|regression');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_condition_humidity_pct` SET TAGS ('dbx_business_glossary_term' = 'Test Condition Relative Humidity Percentage');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_condition_humidity_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_condition_temperature_c` SET TAGS ('dbx_business_glossary_term' = 'Test Condition Temperature (Celsius)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Test End Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_end_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_engineer_name` SET TAGS ('dbx_business_glossary_term' = 'Test Engineer Full Name');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_engineer_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_engineer_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_environment` SET TAGS ('dbx_business_glossary_term' = 'Test Environment');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_environment` SET TAGS ('dbx_value_regex' = 'laboratory|field|simulation|test_bench|climatic_chamber|anechoic_chamber|clean_room|production_floor');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_execution_date` SET TAGS ('dbx_business_glossary_term' = 'Test Execution Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_execution_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_method_code` SET TAGS ('dbx_business_glossary_term' = 'Test Method Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_report_number` SET TAGS ('dbx_business_glossary_term' = 'Test Report Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Test Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_type` SET TAGS ('dbx_business_glossary_term' = 'Test Type');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `test_type` SET TAGS ('dbx_value_regex' = 'functional|performance|environmental|reliability|safety|electrical|mechanical|chemical|software|integration|regression|acceptance|destructive|non_destructive');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_test_result` ALTER COLUMN `upper_acceptance_limit` SET TAGS ('dbx_business_glossary_term' = 'Upper Acceptance Limit');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` SET TAGS ('dbx_subdomain' = 'intellectual_property');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `ip_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Asset ID');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `asset_register_id` SET TAGS ('dbx_business_glossary_term' = 'Asset Register Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `export_classification_id` SET TAGS ('dbx_business_glossary_term' = 'Export Classification Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Inventor Employee ID');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `employee_id` SET TAGS ('dbx_pii_identifier' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `abstract` SET TAGS ('dbx_business_glossary_term' = 'IP Asset Abstract');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `annuity_due_date` SET TAGS ('dbx_business_glossary_term' = 'Patent Annuity Due Date');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `application_number` SET TAGS ('dbx_business_glossary_term' = 'Patent Application Number');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `associated_product_line` SET TAGS ('dbx_business_glossary_term' = 'Associated Product Line');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `claims_summary` SET TAGS ('dbx_business_glossary_term' = 'Patent Claims Summary');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'IP Asset Confidentiality Level');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_value_regex' = 'restricted|confidential|internal|public');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `cpc_classification` SET TAGS ('dbx_business_glossary_term' = 'Cooperative Patent Classification (CPC) Code');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `estimated_commercial_value_usd` SET TAGS ('dbx_business_glossary_term' = 'Estimated Commercial Value (USD)');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `estimated_commercial_value_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'IP Asset Expiry Date');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `external_law_firm` SET TAGS ('dbx_business_glossary_term' = 'External Law Firm');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `filing_date` SET TAGS ('dbx_business_glossary_term' = 'Patent Filing Date');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `freedom_to_operate_status` SET TAGS ('dbx_business_glossary_term' = 'Freedom to Operate (FTO) Status');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `freedom_to_operate_status` SET TAGS ('dbx_value_regex' = 'cleared|at_risk|blocked|not_assessed|in_review');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `grant_date` SET TAGS ('dbx_business_glossary_term' = 'Patent Grant Date');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `invention_disclosure_date` SET TAGS ('dbx_business_glossary_term' = 'Invention Disclosure Date');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `inventors` SET TAGS ('dbx_business_glossary_term' = 'Inventor Names');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `inventors` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `ip_type` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Type');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `ip_type` SET TAGS ('dbx_value_regex' = 'patent|trade_secret|proprietary_algorithm|software_invention|know_how|trademark|copyright|utility_model|design_right');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `ipc_classification` SET TAGS ('dbx_business_glossary_term' = 'International Patent Classification (IPC) Code');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `is_licensed_externally` SET TAGS ('dbx_business_glossary_term' = 'External Licensing Indicator');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `is_licensed_externally` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `is_standard_essential` SET TAGS ('dbx_business_glossary_term' = 'Standard Essential Patent (SEP) Indicator');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `is_standard_essential` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `jurisdiction` SET TAGS ('dbx_business_glossary_term' = 'IP Jurisdiction');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `jurisdiction_office` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property Office');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `jurisdiction_office` SET TAGS ('dbx_value_regex' = 'USPTO|EPO|WIPO|CNIPA|JPO|KIPO|UKIPO|INPI|DPMA|other');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `licensing_model` SET TAGS ('dbx_business_glossary_term' = 'IP Licensing Model');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `licensing_model` SET TAGS ('dbx_value_regex' = 'exclusive|non_exclusive|cross_license|sublicense|royalty_free|not_licensed|open_source|pending');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `maintenance_fee_status` SET TAGS ('dbx_business_glossary_term' = 'Patent Maintenance Fee Status');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `maintenance_fee_status` SET TAGS ('dbx_value_regex' = 'current|overdue|paid|waived|not_applicable');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `owning_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Owning Business Unit');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `owning_legal_entity` SET TAGS ('dbx_business_glossary_term' = 'Owning Legal Entity');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `patent_number` SET TAGS ('dbx_business_glossary_term' = 'Patent Number');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `priority_date` SET TAGS ('dbx_business_glossary_term' = 'Priority Date');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `prosecution_attorney` SET TAGS ('dbx_business_glossary_term' = 'Patent Prosecution Attorney');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `reference_number` SET TAGS ('dbx_business_glossary_term' = 'IP Asset Internal Reference Number');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_value_regex' = 'ideation|concept|feasibility|development|validation|launch|post_launch');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'IP Asset Status');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'invention_disclosure|filed|granted|abandoned|licensed|expired|under_review|withdrawn');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|robotics|power_electronics|industrial_iot|software_controls|drive_systems|energy_management|digital_twin|cybersecurity|sensing_and_measurement|other');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'IP Asset Title');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `valuation_currency` SET TAGS ('dbx_business_glossary_term' = 'Valuation Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`ip_asset` ALTER COLUMN `valuation_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` SET TAGS ('dbx_subdomain' = 'intellectual_property');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `patent_filing_id` SET TAGS ('dbx_business_glossary_term' = 'Patent Filing ID');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `ip_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Ip Asset Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `abstract` SET TAGS ('dbx_business_glossary_term' = 'Patent Abstract');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `annuity_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Patent Annuity Cost Amount');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `annuity_cost_amount` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `annuity_cost_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `annuity_year` SET TAGS ('dbx_business_glossary_term' = 'Annuity Year');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `annuity_year` SET TAGS ('dbx_value_regex' = '^([1-9]|[1-2][0-9]|20)$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `application_number` SET TAGS ('dbx_business_glossary_term' = 'Patent Application Number');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `assigned_attorney` SET TAGS ('dbx_business_glossary_term' = 'Assigned Patent Attorney / Agent');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `assignee_name` SET TAGS ('dbx_business_glossary_term' = 'Patent Assignee Name');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `business_unit` SET TAGS ('dbx_business_glossary_term' = 'Business Unit');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `confidentiality_status` SET TAGS ('dbx_business_glossary_term' = 'Patent Confidentiality Status');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `confidentiality_status` SET TAGS ('dbx_value_regex' = 'confidential|published|restricted');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `cost_center_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{2,20}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `cost_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Cost Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `cost_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `cpc_classification` SET TAGS ('dbx_business_glossary_term' = 'Cooperative Patent Classification (CPC) Code');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Patent Expiry Date');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `filing_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Patent Filing Cost Amount');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `filing_cost_amount` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `filing_cost_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `filing_date` SET TAGS ('dbx_business_glossary_term' = 'Patent Filing Date');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `filing_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `filing_language` SET TAGS ('dbx_business_glossary_term' = 'Filing Language');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `filing_language` SET TAGS ('dbx_value_regex' = '^[a-z]{2,3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `filing_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Patent Filing Reference Number');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `filing_reference_number` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-/]{3,50}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `grant_date` SET TAGS ('dbx_business_glossary_term' = 'Patent Grant Date');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `grant_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `grant_number` SET TAGS ('dbx_business_glossary_term' = 'Patent Grant Number');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `inventor_names` SET TAGS ('dbx_business_glossary_term' = 'Inventor Names');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `inventor_names` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `ipc_classification` SET TAGS ('dbx_business_glossary_term' = 'International Patent Classification (IPC) Code');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `ipc_classification` SET TAGS ('dbx_value_regex' = '^[A-H][0-9]{2}[A-Z][0-9]{1,4}/[0-9]{2,6}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `is_encumbered` SET TAGS ('dbx_business_glossary_term' = 'Is Encumbered Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `is_encumbered` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `is_licensed` SET TAGS ('dbx_business_glossary_term' = 'Is Licensed Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `is_licensed` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `jurisdiction_country_code` SET TAGS ('dbx_business_glossary_term' = 'Jurisdiction Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `jurisdiction_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `last_office_action_date` SET TAGS ('dbx_business_glossary_term' = 'Last Office Action Date');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `last_office_action_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `law_firm_name` SET TAGS ('dbx_business_glossary_term' = 'Patent Law Firm Name');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `next_annuity_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Annuity Due Date');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `next_annuity_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `parent_application_number` SET TAGS ('dbx_business_glossary_term' = 'Parent Application Number');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `patent_family_code` SET TAGS ('dbx_business_glossary_term' = 'Patent Family ID');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `patent_office` SET TAGS ('dbx_business_glossary_term' = 'Patent Office');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `patent_office` SET TAGS ('dbx_value_regex' = 'USPTO|EPO|WIPO|JPO|CNIPA|KIPO|UKIPO|INPI|DPMA|CIPO|IP_AUSTRALIA|OTHER');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `patent_type` SET TAGS ('dbx_business_glossary_term' = 'Patent Type');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `patent_type` SET TAGS ('dbx_value_regex' = 'utility|design|plant|provisional|PCT|divisional|continuation|continuation_in_part|reissue');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `priority_date` SET TAGS ('dbx_business_glossary_term' = 'Priority Date');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `priority_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `prosecution_cost_amount` SET TAGS ('dbx_business_glossary_term' = 'Patent Prosecution Cost Amount');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `prosecution_cost_amount` SET TAGS ('dbx_value_regex' = '^d+(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `prosecution_cost_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `prosecution_status` SET TAGS ('dbx_business_glossary_term' = 'Prosecution Status');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `prosecution_status` SET TAGS ('dbx_value_regex' = 'draft|filed|pending_examination|under_examination|office_action_received|response_filed|allowed|granted|abandoned|withdrawn|lapsed|expired|appealed|opposition_filed|licensed');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `publication_date` SET TAGS ('dbx_business_glossary_term' = 'Patent Publication Date');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `publication_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `publication_number` SET TAGS ('dbx_business_glossary_term' = 'Patent Publication Number');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `related_rd_project_code` SET TAGS ('dbx_business_glossary_term' = 'Related R&D Project Code');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `response_deadline_date` SET TAGS ('dbx_business_glossary_term' = 'Office Action Response Deadline Date');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `response_deadline_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `standard_essential_patent_flag` SET TAGS ('dbx_business_glossary_term' = 'Standard Essential Patent (SEP) Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `standard_essential_patent_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`patent_filing` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Patent Title');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` SET TAGS ('dbx_subdomain' = 'collaboration_funding');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` SET TAGS ('dbx_original_name' = 'research_partner');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `partner_id` SET TAGS ('dbx_business_glossary_term' = 'Research Partner ID');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `sanctions_screening_id` SET TAGS ('dbx_business_glossary_term' = 'Sanctions Screening Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `active_project_count` SET TAGS ('dbx_business_glossary_term' = 'Active R&D Project Count');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `active_project_count` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `agreement_end_date` SET TAGS ('dbx_business_glossary_term' = 'Collaboration Agreement End Date');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `agreement_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `agreement_start_date` SET TAGS ('dbx_business_glossary_term' = 'Collaboration Agreement Start Date');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `agreement_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Collaboration Agreement Type');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'joint_development_agreement|research_services_agreement|consortium_agreement|memorandum_of_understanding|sponsored_research_agreement|technology_license_agreement|material_transfer_agreement|other');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `annual_collaboration_budget` SET TAGS ('dbx_business_glossary_term' = 'Annual Collaboration Budget');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `annual_collaboration_budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Budget Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `city` SET TAGS ('dbx_business_glossary_term' = 'Research Partner City');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `code` SET TAGS ('dbx_business_glossary_term' = 'Research Partner Code');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `code` SET TAGS ('dbx_value_regex' = '^RP-[A-Z0-9]{4,12}$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `collaboration_agreement_ref` SET TAGS ('dbx_business_glossary_term' = 'Collaboration Agreement Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `data_sharing_agreement_in_place` SET TAGS ('dbx_business_glossary_term' = 'Data Sharing Agreement In Place Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `data_sharing_agreement_in_place` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `due_diligence_date` SET TAGS ('dbx_business_glossary_term' = 'Due Diligence Completion Date');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `due_diligence_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `due_diligence_status` SET TAGS ('dbx_business_glossary_term' = 'Due Diligence Status');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `due_diligence_status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|waived|expired');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_value_regex' = 'EAR99|ECCN_controlled|ITAR_controlled|not_applicable|under_review');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `ip_agreement_in_place` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Agreement In Place Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `ip_agreement_in_place` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `ip_ownership_model` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Ownership Model');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `ip_ownership_model` SET TAGS ('dbx_value_regex' = 'company_owned|partner_owned|jointly_owned|licensed_to_company|licensed_to_partner|background_ip_retained|negotiated_per_project');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `last_performance_review_date` SET TAGS ('dbx_business_glossary_term' = 'Last Performance Review Date');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `last_performance_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Research Partner Organization Name');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `nda_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Non-Disclosure Agreement (NDA) Expiry Date');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `nda_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `nda_in_place` SET TAGS ('dbx_business_glossary_term' = 'Non-Disclosure Agreement (NDA) In Place Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `nda_in_place` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Research Partner Notes');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `onboarding_date` SET TAGS ('dbx_business_glossary_term' = 'Partner Onboarding Date');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `onboarding_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Research Partner Performance Rating');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `performance_rating` SET TAGS ('dbx_value_regex' = '^([0-4].[0-9]|5.0)$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `preferred_collaboration_mode` SET TAGS ('dbx_business_glossary_term' = 'Preferred Collaboration Mode');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `preferred_collaboration_mode` SET TAGS ('dbx_value_regex' = 'on_site|remote|hybrid|secondment|joint_lab');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Email Address');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_value_regex' = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `primary_contact_email` SET TAGS ('dbx_pii_email' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Full Name');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `primary_contact_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Phone Number');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_value_regex' = '^+?[0-9s-().]{7,20}$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `primary_contact_phone` SET TAGS ('dbx_pii_phone' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `primary_contact_title` SET TAGS ('dbx_business_glossary_term' = 'Primary Contact Job Title');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `region` SET TAGS ('dbx_business_glossary_term' = 'Geographic Region');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `research_focus_area` SET TAGS ('dbx_business_glossary_term' = 'Research Focus Area');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `short_name` SET TAGS ('dbx_business_glossary_term' = 'Research Partner Short Name');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Research Partner Status');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'active|inactive|pending_approval|suspended|terminated|under_review');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `technology_domains` SET TAGS ('dbx_business_glossary_term' = 'Technology Domains of Expertise');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `technology_readiness_level` SET TAGS ('dbx_business_glossary_term' = 'Technology Readiness Level (TRL)');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `technology_readiness_level` SET TAGS ('dbx_value_regex' = '^([1-9])$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Partner Relationship Termination Date');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `termination_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `tier` SET TAGS ('dbx_business_glossary_term' = 'Research Partner Tier');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `tier` SET TAGS ('dbx_value_regex' = 'strategic|preferred|standard|exploratory');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `type` SET TAGS ('dbx_business_glossary_term' = 'Research Partner Type');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `type` SET TAGS ('dbx_value_regex' = 'university|research_institute|technology_startup|national_laboratory|industry_consortium|government_agency|nonprofit_foundation|corporate_research_center|other');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `website_url` SET TAGS ('dbx_business_glossary_term' = 'Research Partner Website URL');
ALTER TABLE `manufacturing_ecm`.`research`.`partner` ALTER COLUMN `website_url` SET TAGS ('dbx_value_regex' = '^https?://[^s/$.?#].[^s]*$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` SET TAGS ('dbx_subdomain' = 'collaboration_funding');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `collaboration_agreement_id` SET TAGS ('dbx_business_glossary_term' = 'Collaboration Agreement ID');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `data_privacy_record_id` SET TAGS ('dbx_business_glossary_term' = 'Data Privacy Record Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `legal_entity_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `partner_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `procurement_contract_id` SET TAGS ('dbx_business_glossary_term' = 'Procurement Contract Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `agreement_currency` SET TAGS ('dbx_business_glossary_term' = 'Agreement Currency');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `agreement_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_business_glossary_term' = 'Collaboration Agreement Number');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `agreement_number` SET TAGS ('dbx_value_regex' = '^CA-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `agreement_owner` SET TAGS ('dbx_business_glossary_term' = 'Agreement Owner');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_business_glossary_term' = 'Agreement Type');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `agreement_type` SET TAGS ('dbx_value_regex' = 'JDA|CRA|consortium_membership|sponsored_research|NDA|MOU|technology_license|co_development');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `company_financial_commitment` SET TAGS ('dbx_business_glossary_term' = 'Company Financial Commitment');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `company_financial_commitment` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Level');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_value_regex' = 'public|internal|confidential|restricted|top_secret');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `cost_sharing_model` SET TAGS ('dbx_business_glossary_term' = 'Cost Sharing Model');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `cost_sharing_model` SET TAGS ('dbx_value_regex' = 'equal_split|proportional|company_funded|partner_funded|grant_funded|milestone_based|in_kind_contribution');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `cost_sharing_model` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `dispute_resolution_mechanism` SET TAGS ('dbx_business_glossary_term' = 'Dispute Resolution Mechanism');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `dispute_resolution_mechanism` SET TAGS ('dbx_value_regex' = 'negotiation|mediation|arbitration|litigation|expert_determination');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Effective Date');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Expiry Date');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `export_control_classification` SET TAGS ('dbx_business_glossary_term' = 'Export Control Classification Number (ECCN)');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_business_glossary_term' = 'Export Control Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `export_control_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `governing_law_country_code` SET TAGS ('dbx_business_glossary_term' = 'Governing Law Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `governing_law_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `ip_ownership_company_pct` SET TAGS ('dbx_business_glossary_term' = 'Company Intellectual Property (IP) Ownership Percentage');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `ip_ownership_company_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `ip_ownership_company_pct` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `ip_ownership_model` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Ownership Model');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `ip_ownership_model` SET TAGS ('dbx_value_regex' = 'company_owned|partner_owned|jointly_owned|background_ip_retained|field_of_use_license|negotiated_split');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `ip_ownership_model` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `legal_counsel_name` SET TAGS ('dbx_business_glossary_term' = 'Legal Counsel Name');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `nda_expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Non-Disclosure Agreement (NDA) Expiry Date');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `nda_expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `nda_included` SET TAGS ('dbx_business_glossary_term' = 'Non-Disclosure Agreement (NDA) Included');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `nda_included` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `partner_country_code` SET TAGS ('dbx_business_glossary_term' = 'Partner Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `partner_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `partner_type` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Type');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `partner_type` SET TAGS ('dbx_value_regex' = 'university|research_institute|national_laboratory|technology_company|startup|industry_consortium|government_agency|non_profit');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `publication_embargo_days` SET TAGS ('dbx_business_glossary_term' = 'Publication Embargo Period (Days)');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `publication_embargo_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `publication_rights` SET TAGS ('dbx_business_glossary_term' = 'Publication Rights');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `publication_rights` SET TAGS ('dbx_value_regex' = 'unrestricted|company_approval_required|joint_approval_required|embargo_period|restricted|no_publication');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `publication_rights` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_business_glossary_term' = 'Renewal Notice Period (Days)');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `renewal_notice_days` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `renewal_option` SET TAGS ('dbx_business_glossary_term' = 'Renewal Option Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `renewal_option` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `research_scope` SET TAGS ('dbx_business_glossary_term' = 'Research Scope Description');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `research_scope` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `responsible_department` SET TAGS ('dbx_business_glossary_term' = 'Responsible Department');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `signed_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Signed Date');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `signed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|Teamcenter_PLM|SAP_Ariba|Salesforce_CRM|manual|other');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_value_regex' = 'ideation|concept|feasibility|development|validation|launch|post_launch');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Agreement Status');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|pending_signature|active|suspended|expired|terminated|closed|renewed');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|digitalization|materials_science|power_electronics|robotics|ai_ml|cybersecurity|energy_management|other');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `termination_date` SET TAGS ('dbx_business_glossary_term' = 'Agreement Termination Date');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `termination_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `termination_reason` SET TAGS ('dbx_business_glossary_term' = 'Agreement Termination Reason');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `termination_reason` SET TAGS ('dbx_value_regex' = 'mutual_agreement|breach_of_contract|project_completion|funding_withdrawal|regulatory_issue|partner_insolvency|strategic_change|other');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Agreement Title');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `title` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `total_agreement_value` SET TAGS ('dbx_business_glossary_term' = 'Total Agreement Value');
ALTER TABLE `manufacturing_ecm`.`research`.`collaboration_agreement` ALTER COLUMN `total_agreement_value` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` SET TAGS ('dbx_subdomain' = 'collaboration_funding');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `rd_budget_id` SET TAGS ('dbx_business_glossary_term' = 'R&D Budget ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `actual_spend` SET TAGS ('dbx_business_glossary_term' = 'Actual Spend to Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `actual_spend` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `approval_date` SET TAGS ('dbx_business_glossary_term' = 'Budget Approval Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `approval_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `approved_amount` SET TAGS ('dbx_business_glossary_term' = 'Approved Budget Amount');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `approved_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `approved_amount_usd` SET TAGS ('dbx_business_glossary_term' = 'Approved Budget Amount (USD)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `approved_amount_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Budget Approved By');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'phase_1_planning|phase_2_product_design|phase_3_process_design|phase_4_product_validation|phase_5_launch|not_applicable');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `budget_category` SET TAGS ('dbx_business_glossary_term' = 'R&D Budget Category');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `budget_category` SET TAGS ('dbx_value_regex' = 'labor|materials|external_services|capital_equipment|travel|overhead|software_licenses|prototype_tooling|testing_and_validation|intellectual_property');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `budget_code` SET TAGS ('dbx_business_glossary_term' = 'R&D Budget Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `budget_code` SET TAGS ('dbx_value_regex' = '^RDB-[A-Z0-9]{4}-[0-9]{4}-[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `budget_name` SET TAGS ('dbx_business_glossary_term' = 'R&D Budget Name');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `budget_revision_number` SET TAGS ('dbx_business_glossary_term' = 'Budget Revision Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `budget_revision_number` SET TAGS ('dbx_value_regex' = '^[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `budget_type` SET TAGS ('dbx_business_glossary_term' = 'Budget Type');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `budget_type` SET TAGS ('dbx_value_regex' = 'original|supplemental|revised|carryover|contingency|emergency');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `business_unit` SET TAGS ('dbx_business_glossary_term' = 'Business Unit');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `committed_spend` SET TAGS ('dbx_business_glossary_term' = 'Committed Spend');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `committed_spend` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Budget Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_business_glossary_term' = 'Budget Effective End Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `effective_end_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_business_glossary_term' = 'Budget Effective Start Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `effective_start_date` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Foreign Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `expenditure_type` SET TAGS ('dbx_business_glossary_term' = 'Capital Expenditure (CAPEX) / Operational Expenditure (OPEX) Classification');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `expenditure_type` SET TAGS ('dbx_value_regex' = 'CAPEX|OPEX');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^(Q[1-4]|H[12]|FY|M(0[1-9]|1[0-2]))$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `funding_source` SET TAGS ('dbx_business_glossary_term' = 'R&D Funding Source');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `funding_source` SET TAGS ('dbx_value_regex' = 'internal_rd_fund|government_grant|customer_funded|joint_venture|venture_capital|innovation_fund|eu_horizon_grant|other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `grant_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Government Grant Reference Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `internal_order_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Internal Order Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}(Z|[+-][0-9]{2}:[0-9]{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Budget Notes');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `portfolio_category` SET TAGS ('dbx_business_glossary_term' = 'R&D Portfolio Category');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `portfolio_category` SET TAGS ('dbx_value_regex' = 'core_technology|adjacent_innovation|transformational|sustaining_engineering|regulatory_compliance|customer_funded|exploratory_research');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `rd_tax_credit_eligible` SET TAGS ('dbx_business_glossary_term' = 'R&D Tax Credit Eligible Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `rd_tax_credit_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `remaining_budget` SET TAGS ('dbx_business_glossary_term' = 'Remaining Budget');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `remaining_budget` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|TEAMCENTER|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_value_regex' = 'ideation|scoping|business_case|development|testing|launch|post_launch|not_applicable');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Budget Status');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|pending_approval|approved|active|on_hold|closed|cancelled|over_budget|under_review');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|digital_manufacturing|iiot|robotics|energy_management|cybersecurity|materials_science|software_platform|other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_budget` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` SET TAGS ('dbx_subdomain' = 'collaboration_funding');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `rd_expense_id` SET TAGS ('dbx_business_glossary_term' = 'R&D Expense ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `billing_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `cost_center_id` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `cost_object_internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'SAP Cost Object ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `freight_invoice_id` SET TAGS ('dbx_business_glossary_term' = 'Freight Invoice Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `gl_account_id` SET TAGS ('dbx_business_glossary_term' = 'Gl Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `internal_order_id` SET TAGS ('dbx_business_glossary_term' = 'Internal Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `rd_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Budget Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Vendor ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `amount` SET TAGS ('dbx_business_glossary_term' = 'Expense Amount (Transaction Currency)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `amount_usd` SET TAGS ('dbx_business_glossary_term' = 'Expense Amount (USD)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `amount_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `approval_status` SET TAGS ('dbx_business_glossary_term' = 'Expense Approval Status');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `approval_status` SET TAGS ('dbx_value_regex' = 'pending|approved|rejected|on_hold|cancelled');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `approved_by` SET TAGS ('dbx_business_glossary_term' = 'Approved By (Employee ID)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Expense Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `approved_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'phase_1_plan_and_define|phase_2_product_design|phase_3_process_design|phase_4_product_validation|phase_5_launch_and_feedback|not_applicable');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `capitalization_justification` SET TAGS ('dbx_business_glossary_term' = 'IAS 38 Capitalization Justification');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `cost_object_type` SET TAGS ('dbx_business_glossary_term' = 'SAP Cost Object Type');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `cost_object_type` SET TAGS ('dbx_value_regex' = 'wbs_element|internal_order|cost_center|network_activity|production_order');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Transaction Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Expense Description');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `exchange_rate` SET TAGS ('dbx_business_glossary_term' = 'Currency Exchange Rate');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `expense_category` SET TAGS ('dbx_business_glossary_term' = 'R&D Expense Category');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `expense_category` SET TAGS ('dbx_value_regex' = 'labor|materials|equipment|software_licenses|external_services|travel|prototype_fabrication|testing_and_validation|patent_and_legal|overhead|other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `expense_date` SET TAGS ('dbx_business_glossary_term' = 'Expense Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `expense_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `expense_number` SET TAGS ('dbx_business_glossary_term' = 'R&D Expense Document Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `expense_number` SET TAGS ('dbx_value_regex' = '^RDE-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `expense_subcategory` SET TAGS ('dbx_business_glossary_term' = 'R&D Expense Subcategory');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Period');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `fiscal_period` SET TAGS ('dbx_value_regex' = '^([1-9]|1[0-2])$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_business_glossary_term' = 'Fiscal Year');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `fiscal_year` SET TAGS ('dbx_value_regex' = '^[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `is_capitalized` SET TAGS ('dbx_business_glossary_term' = 'Capitalization Flag (CAPEX vs OPEX)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `is_capitalized` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `legal_entity_code` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `posting_date` SET TAGS ('dbx_business_glossary_term' = 'Accounting Posting Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `posting_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `purchase_order_number` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order (PO) Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `sap_document_number` SET TAGS ('dbx_business_glossary_term' = 'SAP Financial Document Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'SAP_S4HANA|SAP_ARIBA|MANUAL|OTHER');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `tax_credit_eligible` SET TAGS ('dbx_business_glossary_term' = 'R&D Tax Credit Eligibility Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `tax_credit_eligible` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|digital_twin|iiot|robotics|power_electronics|software_embedded|materials|other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `vendor_name` SET TAGS ('dbx_business_glossary_term' = 'Vendor Name');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_expense` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` SET TAGS ('dbx_subdomain' = 'collaboration_funding');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `grant_funding_id` SET TAGS ('dbx_business_glossary_term' = 'Grant Funding ID');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_business_glossary_term' = 'Bank Account Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `bank_account_id` SET TAGS ('dbx_pii_financial' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `credit_note_id` SET TAGS ('dbx_business_glossary_term' = 'Credit Note Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Compliance Obligation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `rd_budget_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Budget Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `agreement_signed_date` SET TAGS ('dbx_business_glossary_term' = 'Grant Agreement Signed Date');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `agreement_signed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `application_submission_date` SET TAGS ('dbx_business_glossary_term' = 'Application Submission Date');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `application_submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `audit_requirement` SET TAGS ('dbx_business_glossary_term' = 'Audit Requirement');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `audit_requirement` SET TAGS ('dbx_value_regex' = 'none|internal_only|external_auditor|agency_audit|single_audit');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `award_date` SET TAGS ('dbx_business_glossary_term' = 'Award Date');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `award_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `awarded_amount` SET TAGS ('dbx_business_glossary_term' = 'Awarded Amount');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `awarded_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `awarded_amount_usd` SET TAGS ('dbx_business_glossary_term' = 'Awarded Amount USD');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `awarded_amount_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `co_funding_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Co-Funding Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `co_funding_rate_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `compliance_standards` SET TAGS ('dbx_business_glossary_term' = 'Compliance Standards');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `consortium_role` SET TAGS ('dbx_business_glossary_term' = 'Consortium Role');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `consortium_role` SET TAGS ('dbx_value_regex' = 'coordinator|partner|associate_partner|subcontractor|observer');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `currency_code` SET TAGS ('dbx_business_glossary_term' = 'Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `currency_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `disbursement_schedule_type` SET TAGS ('dbx_business_glossary_term' = 'Disbursement Schedule Type');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `disbursement_schedule_type` SET TAGS ('dbx_value_regex' = 'upfront_lump_sum|milestone_based|periodic_installment|reimbursement|advance_plus_balance');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `eligible_cost_categories` SET TAGS ('dbx_business_glossary_term' = 'Eligible Cost Categories');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_business_glossary_term' = 'External Partner Involved Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `final_report_due_date` SET TAGS ('dbx_business_glossary_term' = 'Final Report Due Date');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `final_report_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `funding_agency` SET TAGS ('dbx_business_glossary_term' = 'Funding Agency');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `funding_instrument_type` SET TAGS ('dbx_business_glossary_term' = 'Funding Instrument Type');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `funding_instrument_type` SET TAGS ('dbx_value_regex' = 'research_grant|innovation_action|collaborative_project|framework_agreement|cooperative_agreement|loan_guarantee|tax_credit|subsidy|fellowship|prize');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `grant_end_date` SET TAGS ('dbx_business_glossary_term' = 'Grant End Date');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `grant_end_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `grant_manager` SET TAGS ('dbx_business_glossary_term' = 'Grant Manager');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `grant_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Grant Reference Number');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `grant_start_date` SET TAGS ('dbx_business_glossary_term' = 'Grant Start Date');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `grant_start_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `indirect_cost_rate_pct` SET TAGS ('dbx_business_glossary_term' = 'Indirect Cost Rate Percentage');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `indirect_cost_rate_pct` SET TAGS ('dbx_value_regex' = '^(100(.0{1,2})?|[0-9]{1,2}(.[0-9]{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `ip_ownership_terms` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Ownership Terms');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `ip_ownership_terms` SET TAGS ('dbx_value_regex' = 'manufacturing_owned|jointly_owned|agency_owned|open_access|licensed_back|to_be_negotiated');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `ip_ownership_terms` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `legal_entity_name` SET TAGS ('dbx_business_glossary_term' = 'Legal Entity Name');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `manufacturing_contribution_amount` SET TAGS ('dbx_business_glossary_term' = 'Manufacturing Co-Funding Contribution Amount');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `manufacturing_contribution_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `next_report_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Report Due Date');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `next_report_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Grant Notes');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `open_access_required` SET TAGS ('dbx_business_glossary_term' = 'Open Access Required Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `open_access_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `owning_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Owning Business Unit');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `principal_investigator` SET TAGS ('dbx_business_glossary_term' = 'Principal Investigator');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `program_name` SET TAGS ('dbx_business_glossary_term' = 'Grant Program Name');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `reporting_frequency` SET TAGS ('dbx_business_glossary_term' = 'Reporting Frequency');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `reporting_frequency` SET TAGS ('dbx_value_regex' = 'monthly|quarterly|semi_annual|annual|milestone_based|final_only');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Grant Status');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'applied|under_review|awarded|active|suspended|completed|closed|rejected|withdrawn');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|digitalization|energy_management|advanced_manufacturing|cybersecurity|materials|robotics|other');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `total_claimed_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Claimed Amount');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `total_claimed_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `total_disbursed_amount` SET TAGS ('dbx_business_glossary_term' = 'Total Disbursed Amount');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `total_disbursed_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`grant_funding` ALTER COLUMN `wbs_element` SET TAGS ('dbx_business_glossary_term' = 'Work Breakdown Structure (WBS) Element');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` SET TAGS ('dbx_subdomain' = 'validation_testing');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `lab_resource_id` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Resource ID');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Responsible Laboratory Manager Employee ID');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `employee_id` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,20}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `ppe_requirement_id` SET TAGS ('dbx_business_glossary_term' = 'Ppe Requirement Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `procurement_purchase_order_id` SET TAGS ('dbx_business_glossary_term' = 'Purchase Order Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `responsible_lab_manager_employee_id` SET TAGS ('dbx_internal' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `acquisition_cost_usd` SET TAGS ('dbx_business_glossary_term' = 'Acquisition Cost (USD)');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `acquisition_cost_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `applicable_standards` SET TAGS ('dbx_business_glossary_term' = 'Applicable Standards');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `asset_tag` SET TAGS ('dbx_business_glossary_term' = 'Asset Tag Number');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `asset_tag` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `availability_schedule` SET TAGS ('dbx_business_glossary_term' = 'Availability Schedule');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `availability_schedule` SET TAGS ('dbx_value_regex' = '24x7|weekdays_only|day_shift|night_shift|custom|on_request');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `building` SET TAGS ('dbx_business_glossary_term' = 'Building Location');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `calibration_certificate_number` SET TAGS ('dbx_business_glossary_term' = 'Calibration Certificate Number');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `calibration_interval_days` SET TAGS ('dbx_business_glossary_term' = 'Calibration Interval (Days)');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `calibration_interval_days` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `calibration_required` SET TAGS ('dbx_business_glossary_term' = 'Calibration Required Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `calibration_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `calibration_status` SET TAGS ('dbx_business_glossary_term' = 'Calibration Status');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `calibration_status` SET TAGS ('dbx_value_regex' = 'calibrated|due_for_calibration|overdue|not_required|in_calibration');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `capacity_description` SET TAGS ('dbx_business_glossary_term' = 'Resource Capacity Description');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_business_glossary_term' = 'Commissioning Date');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `commissioning_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center Code');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `cost_center` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{4,15}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `country_code` SET TAGS ('dbx_business_glossary_term' = 'Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `decommission_date` SET TAGS ('dbx_business_glossary_term' = 'Decommission Date');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `decommission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Resource Description');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `laboratory_name` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Name');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_business_glossary_term' = 'Last Calibration Date');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `last_calibration_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_business_glossary_term' = 'Last Maintenance Date');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `last_maintenance_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `manufacturer` SET TAGS ('dbx_business_glossary_term' = 'Equipment Manufacturer');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `max_concurrent_bookings` SET TAGS ('dbx_business_glossary_term' = 'Maximum Concurrent Bookings');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `max_concurrent_bookings` SET TAGS ('dbx_value_regex' = '^[1-9][0-9]*$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `model_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Model Number');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Resource Name');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `next_calibration_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Calibration Due Date');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `next_calibration_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `next_maintenance_due_date` SET TAGS ('dbx_business_glossary_term' = 'Next Maintenance Due Date');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `next_maintenance_due_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `owning_department` SET TAGS ('dbx_business_glossary_term' = 'Owning Department');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `permit_to_work_required` SET TAGS ('dbx_business_glossary_term' = 'Permit to Work Required Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `permit_to_work_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `resource_category` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Resource Category');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `resource_category` SET TAGS ('dbx_value_regex' = 'mechanical|electrical|electronic|thermal|environmental|optical|chemical|software|mixed');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `resource_code` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Resource Code');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `resource_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{3,20}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `resource_type` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Resource Type');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `resource_type` SET TAGS ('dbx_value_regex' = 'test_bench|measurement_instrument|environmental_chamber|simulation_rig|prototype_assembly_station|data_acquisition_system|climatic_chamber|vibration_rig|anechoic_chamber|other');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `room_number` SET TAGS ('dbx_business_glossary_term' = 'Room Number');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `safety_classification` SET TAGS ('dbx_business_glossary_term' = 'Safety Classification');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `safety_classification` SET TAGS ('dbx_value_regex' = 'standard|high_voltage|hazardous_materials|radiation|cryogenic|high_pressure|biological|none');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `scheduled_downtime_hours_per_week` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Downtime Hours Per Week');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `serial_number` SET TAGS ('dbx_business_glossary_term' = 'Equipment Serial Number');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `site_code` SET TAGS ('dbx_business_glossary_term' = 'Site Code');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `site_code` SET TAGS ('dbx_value_regex' = '^[A-Z0-9-]{2,10}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'Maximo|SAP_S4HANA|Teamcenter|Opcenter|MindSphere|Manual|Other');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Resource Status');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'available|in_use|under_calibration|under_maintenance|out_of_service|decommissioned|reserved');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_resource` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|power_electronics|drives|sensors|robotics|software|cross_domain|other');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` SET TAGS ('dbx_subdomain' = 'validation_testing');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `lab_booking_id` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Booking ID');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `it_asset_id` SET TAGS ('dbx_business_glossary_term' = 'It Asset Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `lab_resource_id` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Resource ID');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `rd_test_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Test Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Requested By Employee ID');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `employee_id` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual End Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `actual_end_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Actual Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `actual_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `actual_utilization_hours` SET TAGS ('dbx_business_glossary_term' = 'Actual Utilization Hours');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `actual_utilization_hours` SET TAGS ('dbx_value_regex' = '^d{1,5}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Approval Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `approval_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `approved_by_name` SET TAGS ('dbx_business_glossary_term' = 'Approved By Name');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'APQP Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'plan_and_define|product_design_and_development|process_design_and_development|product_and_process_validation|launch_feedback_assessment');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `booking_date` SET TAGS ('dbx_business_glossary_term' = 'Booking Date');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `booking_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `booking_number` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Booking Number');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `booking_number` SET TAGS ('dbx_value_regex' = '^LAB-[0-9]{4}-[0-9]{6}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `booking_type` SET TAGS ('dbx_business_glossary_term' = 'Booking Type');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `booking_type` SET TAGS ('dbx_value_regex' = 'standard|recurring|emergency|external_partner|maintenance_block|calibration_block');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `calibration_required` SET TAGS ('dbx_business_glossary_term' = 'Calibration Required Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `calibration_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_business_glossary_term' = 'Cancellation Reason');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `cancellation_reason` SET TAGS ('dbx_value_regex' = 'project_cancelled|resource_unavailable|schedule_conflict|requester_request|equipment_failure|safety_concern|other');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `conflict_description` SET TAGS ('dbx_business_glossary_term' = 'Conflict Description');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `conflict_flag` SET TAGS ('dbx_business_glossary_term' = 'Resource Conflict Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `conflict_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `cost_center` SET TAGS ('dbx_business_glossary_term' = 'Cost Center');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_business_glossary_term' = 'External Partner Involved Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `external_partner_name` SET TAGS ('dbx_business_glossary_term' = 'External Partner Name');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `hazardous_material_involved` SET TAGS ('dbx_business_glossary_term' = 'Hazardous Material Involved Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `hazardous_material_involved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `lab_location` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Location');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `lab_location_country_code` SET TAGS ('dbx_business_glossary_term' = 'Laboratory Location Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `lab_location_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Booking Notes');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Booking Priority');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `priority` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `purpose_description` SET TAGS ('dbx_business_glossary_term' = 'Booking Purpose Description');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `requested_by_name` SET TAGS ('dbx_business_glossary_term' = 'Requested By Name');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `requested_by_name` SET TAGS ('dbx_restricted' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `requested_by_name` SET TAGS ('dbx_pii_name' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `requesting_department` SET TAGS ('dbx_business_glossary_term' = 'Requesting Department');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `safety_clearance_required` SET TAGS ('dbx_business_glossary_term' = 'Safety Clearance Required Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `safety_clearance_required` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `scheduled_duration_hours` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Duration (Hours)');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `scheduled_duration_hours` SET TAGS ('dbx_value_regex' = '^d{1,5}(.d{1,2})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `scheduled_end_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled End Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `scheduled_end_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `scheduled_start_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Scheduled Start Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `scheduled_start_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}[+-]d{2}:d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_value_regex' = 'concept|feasibility|development|validation|launch|post_launch');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Booking Status');
ALTER TABLE `manufacturing_ecm`.`research`.`lab_booking` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'requested|confirmed|in_use|completed|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` SET TAGS ('dbx_subdomain' = 'validation_testing');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `rd_milestone_id` SET TAGS ('dbx_business_glossary_term' = 'R&D Milestone ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `stage_gate_review_id` SET TAGS ('dbx_business_glossary_term' = 'Stage Gate Review Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `acceptance_criteria` SET TAGS ('dbx_business_glossary_term' = 'Milestone Acceptance Criteria');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Actual Milestone Completion Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `applicable_regulation` SET TAGS ('dbx_business_glossary_term' = 'Applicable Regulation or Standard');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'phase_1_planning|phase_2_product_design|phase_3_process_design|phase_4_product_validation|phase_5_launch_feedback');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `completion_evidence_reference` SET TAGS ('dbx_business_glossary_term' = 'Completion Evidence Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `delay_description` SET TAGS ('dbx_business_glossary_term' = 'Milestone Delay Description');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `delay_reason` SET TAGS ('dbx_business_glossary_term' = 'Milestone Delay Reason');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `delay_reason` SET TAGS ('dbx_value_regex' = 'resource_constraint|technical_complexity|supplier_delay|regulatory_hold|scope_change|budget_constraint|external_partner_delay|force_majeure|other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Milestone Description');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `evidence_type` SET TAGS ('dbx_business_glossary_term' = 'Completion Evidence Type');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `evidence_type` SET TAGS ('dbx_value_regex' = 'test_report|design_review_minutes|regulatory_approval|prototype_sign_off|customer_acceptance|patent_filing|audit_report|inspection_record|other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `external_partner_name` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Name');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `external_partner_obligation` SET TAGS ('dbx_business_glossary_term' = 'External Partner Obligation Description');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `is_contractual` SET TAGS ('dbx_business_glossary_term' = 'Contractual Milestone Indicator');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `is_contractual` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `is_critical_path` SET TAGS ('dbx_business_glossary_term' = 'Critical Path Indicator');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `is_critical_path` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `is_gate_milestone` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Milestone Indicator');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `is_gate_milestone` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `is_grant_reportable` SET TAGS ('dbx_business_glossary_term' = 'Grant Reportable Milestone Indicator');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `is_grant_reportable` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `milestone_code` SET TAGS ('dbx_business_glossary_term' = 'Milestone Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `milestone_code` SET TAGS ('dbx_value_regex' = '^MS-[A-Z0-9]{3,10}-[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `milestone_sequence` SET TAGS ('dbx_business_glossary_term' = 'Milestone Sequence Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `milestone_type` SET TAGS ('dbx_business_glossary_term' = 'Milestone Type');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `milestone_type` SET TAGS ('dbx_value_regex' = 'technical|commercial|regulatory|contractual|financial|ip|safety');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `name` SET TAGS ('dbx_business_glossary_term' = 'Milestone Name');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `owning_department` SET TAGS ('dbx_business_glossary_term' = 'Owning Department');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `payment_amount` SET TAGS ('dbx_business_glossary_term' = 'Milestone Payment Amount');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `payment_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `payment_currency` SET TAGS ('dbx_business_glossary_term' = 'Payment Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `payment_currency` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `payment_trigger_flag` SET TAGS ('dbx_business_glossary_term' = 'Payment Trigger Milestone Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `payment_trigger_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `planned_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Planned Milestone Completion Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `planned_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Milestone Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `responsible_engineer` SET TAGS ('dbx_business_glossary_term' = 'Responsible Engineer');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `responsible_project_manager` SET TAGS ('dbx_business_glossary_term' = 'Responsible Project Manager');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'Milestone Review Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `review_outcome` SET TAGS ('dbx_business_glossary_term' = 'Milestone Review Outcome');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `review_outcome` SET TAGS ('dbx_value_regex' = 'approved|approved_with_conditions|rejected|deferred|pending_review');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `reviewer_name` SET TAGS ('dbx_business_glossary_term' = 'Milestone Reviewer Name');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `revised_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Revised Milestone Completion Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `revised_completion_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `schedule_variance_days` SET TAGS ('dbx_business_glossary_term' = 'Schedule Variance (Days)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'Teamcenter|Opcenter_MES|SAP_S4HANA|MindSphere|Manual|Other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_value_regex' = 'ideation|feasibility|concept|development|validation|launch|post_launch');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Milestone Status');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'not_started|in_progress|completed|delayed|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|digitalization|materials|energy_management|cybersecurity|robotics|ai_ml|other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `trl` SET TAGS ('dbx_business_glossary_term' = 'Technology Readiness Level (TRL)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_milestone` ALTER COLUMN `trl` SET TAGS ('dbx_value_regex' = '^[1-9]$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` SET TAGS ('dbx_data_type' = 'transactional_data');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` SET TAGS ('dbx_subdomain' = 'portfolio_strategy');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `technology_readiness_id` SET TAGS ('dbx_business_glossary_term' = 'Technology Readiness Assessment ID');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Lead Assessor Employee ID');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `equipment_id` SET TAGS ('dbx_business_glossary_term' = 'Equipment Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `research_prototype_id` SET TAGS ('dbx_business_glossary_term' = 'Prototype Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Assessment Approval Date');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `approver_name` SET TAGS ('dbx_business_glossary_term' = 'Assessment Approver Name');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `approver_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'Phase 1 - Plan and Define|Phase 2 - Product Design and Development|Phase 3 - Process Design and Development|Phase 4 - Product and Process Validation|Phase 5 - Feedback Assessment and Corrective Action');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `assessed_trl` SET TAGS ('dbx_business_glossary_term' = 'Assessed Technology Readiness Level (TRL)');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `assessed_trl` SET TAGS ('dbx_value_regex' = '^[1-9]$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Assessment Date');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `assessment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `assessment_number` SET TAGS ('dbx_business_glossary_term' = 'Technology Readiness Assessment Number');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `assessment_number` SET TAGS ('dbx_value_regex' = '^TRL-[A-Z0-9]{2,10}-[0-9]{4}-[0-9]{4}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `assessment_panel` SET TAGS ('dbx_business_glossary_term' = 'Assessment Panel Members');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `assessment_rationale` SET TAGS ('dbx_business_glossary_term' = 'Assessment Rationale');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `assessment_type` SET TAGS ('dbx_business_glossary_term' = 'Assessment Type');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `assessment_type` SET TAGS ('dbx_value_regex' = 'Initial|Periodic|Stage-Gate|Grant Milestone|External Audit|Self-Assessment|Exit Review');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `assessor_name` SET TAGS ('dbx_business_glossary_term' = 'Lead Assessor Name');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `assessor_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `evidence_artifacts` SET TAGS ('dbx_business_glossary_term' = 'Evidence Artifacts Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Involved Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `external_partner_name` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Name');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `fmea_reference` SET TAGS ('dbx_business_glossary_term' = 'Failure Mode and Effects Analysis (FMEA) Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `gate_decision` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Decision');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `gate_decision` SET TAGS ('dbx_value_regex' = 'Go|No-Go|Conditional Go|Hold|Redirect|Terminate');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `gate_decision_date` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Decision Date');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `gate_decision_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `grant_reference` SET TAGS ('dbx_business_glossary_term' = 'Grant Reference Number');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `ip_classification` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Classification');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `ip_classification` SET TAGS ('dbx_value_regex' = 'Confidential|Internal|Public|Restricted|Trade Secret');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `next_assessment_date` SET TAGS ('dbx_business_glossary_term' = 'Next Scheduled Assessment Date');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `next_assessment_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `owning_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Owning Business Unit');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `owning_country_code` SET TAGS ('dbx_business_glossary_term' = 'Owning Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `owning_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `previous_trl` SET TAGS ('dbx_business_glossary_term' = 'Previous Technology Readiness Level (TRL)');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `previous_trl` SET TAGS ('dbx_value_regex' = '^[1-9]$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `regulatory_compliance_scope` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Scope');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `risk_level` SET TAGS ('dbx_business_glossary_term' = 'Technology Risk Level');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `risk_level` SET TAGS ('dbx_value_regex' = 'Low|Medium|High|Critical');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'Teamcenter PLM|SAP S4HANA|MindSphere|Manual Entry|Other');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_value_regex' = 'Concept|Feasibility|Development|Validation|Pilot|Launch|Post-Launch');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Assessment Status');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'Draft|Pending Review|Approved|Rejected|Superseded|Archived');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `sustainability_alignment` SET TAGS ('dbx_business_glossary_term' = 'Sustainability Alignment');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `sustainability_alignment` SET TAGS ('dbx_value_regex' = 'Energy Efficiency|Carbon Reduction|Circular Economy|Hazardous Material Reduction|Water Conservation|Not Applicable|Multiple');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `target_trl` SET TAGS ('dbx_business_glossary_term' = 'Target Technology Readiness Level (TRL)');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `target_trl` SET TAGS ('dbx_value_regex' = '^[1-9]$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `target_trl_date` SET TAGS ('dbx_business_glossary_term' = 'Target TRL Achievement Date');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `target_trl_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'Automation|Electrification|Smart Infrastructure|IIoT|Power Electronics|Motion Control|Drive Systems|Digital Twin|Robotics|Energy Storage|Cybersecurity|Other');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `test_environment` SET TAGS ('dbx_business_glossary_term' = 'Test Environment');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `test_environment` SET TAGS ('dbx_value_regex' = 'Laboratory|Simulated Environment|Relevant Environment|Operational Environment|Field Trial|Customer Site|External Test Facility');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `version_number` SET TAGS ('dbx_business_glossary_term' = 'Assessment Version Number');
ALTER TABLE `manufacturing_ecm`.`research`.`technology_readiness` ALTER COLUMN `version_number` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` SET TAGS ('dbx_subdomain' = 'validation_testing');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `rd_document_id` SET TAGS ('dbx_business_glossary_term' = 'R&D Document ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Author Employee ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `configuration_item_id` SET TAGS ('dbx_business_glossary_term' = 'Configuration Item Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `rd_test_plan_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Test Plan Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `access_classification` SET TAGS ('dbx_business_glossary_term' = 'Access Classification');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `access_classification` SET TAGS ('dbx_value_regex' = 'restricted|confidential|internal|public');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `access_classification` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `applicable_standards` SET TAGS ('dbx_business_glossary_term' = 'Applicable Standards');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `approved_date` SET TAGS ('dbx_business_glossary_term' = 'Approved Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `approved_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `approver_name` SET TAGS ('dbx_business_glossary_term' = 'Document Approver Name');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'plan_and_define|product_design_and_development|process_design_and_development|product_and_process_validation|launch_feedback_and_corrective_action|not_applicable');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `author_name` SET TAGS ('dbx_business_glossary_term' = 'Document Author Name');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_business_glossary_term' = 'Country of Origin');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `country_of_origin` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `document_date` SET TAGS ('dbx_business_glossary_term' = 'Document Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `document_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `document_number` SET TAGS ('dbx_business_glossary_term' = 'R&D Document Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `document_number` SET TAGS ('dbx_value_regex' = '^RD-DOC-[A-Z0-9]{4,20}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `document_type` SET TAGS ('dbx_business_glossary_term' = 'Document Type');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `document_type` SET TAGS ('dbx_value_regex' = 'research_report|feasibility_study|test_protocol|experimental_data_package|invention_disclosure|technical_white_paper|regulatory_pre_submission|design_specification|literature_review|project_charter|meeting_minutes|risk_assessment|standard_operatin...');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `ecn_reference` SET TAGS ('dbx_business_glossary_term' = 'Engineering Change Notice (ECN) Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `effective_date` SET TAGS ('dbx_business_glossary_term' = 'Effective Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `effective_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Document Expiry Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_business_glossary_term' = 'External Partner Involved Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `external_partner_name` SET TAGS ('dbx_business_glossary_term' = 'External Partner Name');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `file_format` SET TAGS ('dbx_business_glossary_term' = 'File Format');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `file_format` SET TAGS ('dbx_value_regex' = 'PDF|DOCX|XLSX|PPTX|XML|HTML|TXT|ZIP|other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `ip_classification` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Classification');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `ip_classification` SET TAGS ('dbx_value_regex' = 'proprietary|trade_secret|patent_pending|patented|open_source|public_domain|licensed_third_party');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `ip_classification` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `keywords` SET TAGS ('dbx_business_glossary_term' = 'Document Keywords');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `language_code` SET TAGS ('dbx_business_glossary_term' = 'Document Language Code');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `language_code` SET TAGS ('dbx_value_regex' = '^[a-z]{2,3}(-[A-Z]{2})?$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Next Review Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `owning_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Owning Business Unit');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `owning_department` SET TAGS ('dbx_business_glossary_term' = 'Owning Department');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `prototype_identifier` SET TAGS ('dbx_business_glossary_term' = 'Prototype Identifier');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Compliance Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `regulatory_compliance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `reviewer_name` SET TAGS ('dbx_business_glossary_term' = 'Document Reviewer Name');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'Teamcenter|SAP_S4HANA|MindSphere|Manual|Other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_value_regex' = 'ideation|concept|feasibility|development|validation|launch|post_launch|not_applicable');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Document Status');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|approved|superseded|obsolete|cancelled|on_hold');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `storage_location_reference` SET TAGS ('dbx_business_glossary_term' = 'Storage Location Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `submission_date` SET TAGS ('dbx_business_glossary_term' = 'Submission Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `submission_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|robotics|power_electronics|motion_control|industrial_software|sensors_and_instrumentation|energy_management|connectivity|other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Document Title');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `version` SET TAGS ('dbx_business_glossary_term' = 'Document Version');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_document` ALTER COLUMN `version` SET TAGS ('dbx_value_regex' = '^[0-9]+.[0-9]+(.[0-9]+)?[A-Z]?$');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` SET TAGS ('dbx_subdomain' = 'portfolio_strategy');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `competitive_intelligence_id` SET TAGS ('dbx_business_glossary_term' = 'Competitive Intelligence ID');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `competitor_id` SET TAGS ('dbx_business_glossary_term' = 'Competitor Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `action_priority` SET TAGS ('dbx_business_glossary_term' = 'Action Priority');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `action_priority` SET TAGS ('dbx_value_regex' = 'immediate|short_term|medium_term|long_term|monitor_only');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `analyst_owner` SET TAGS ('dbx_business_glossary_term' = 'Analyst Owner');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `applicable_regulation` SET TAGS ('dbx_business_glossary_term' = 'Applicable Regulation or Standard');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `competitor_country_code` SET TAGS ('dbx_business_glossary_term' = 'Competitor Country Code');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `competitor_country_code` SET TAGS ('dbx_value_regex' = '^[A-Z]{3}$');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `competitor_product_category` SET TAGS ('dbx_business_glossary_term' = 'Competitor Product Category');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `competitor_product_name` SET TAGS ('dbx_business_glossary_term' = 'Competitor Product Name');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `competitor_product_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `confidence_level` SET TAGS ('dbx_business_glossary_term' = 'Intelligence Confidence Level');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `confidence_level` SET TAGS ('dbx_value_regex' = 'high|medium|low');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_business_glossary_term' = 'Confidentiality Level');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_value_regex' = 'restricted|confidential|internal|public');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `confidentiality_level` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `expiry_date` SET TAGS ('dbx_business_glossary_term' = 'Intelligence Expiry Date');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `expiry_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `freedom_to_operate_impact` SET TAGS ('dbx_business_glossary_term' = 'Freedom to Operate (FTO) Impact');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `freedom_to_operate_impact` SET TAGS ('dbx_value_regex' = 'no_impact|potential_risk|requires_fto_analysis|blocking_risk|cleared');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `freedom_to_operate_impact` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_business_glossary_term' = 'Geographic Scope');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `geographic_scope` SET TAGS ('dbx_value_regex' = 'global|north_america|europe|asia_pacific|latin_america|middle_east_africa|specific_country');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `intelligence_date` SET TAGS ('dbx_business_glossary_term' = 'Intelligence Date');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `intelligence_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `intelligence_type` SET TAGS ('dbx_business_glossary_term' = 'Intelligence Type');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `intelligence_type` SET TAGS ('dbx_value_regex' = 'patent_analysis|product_teardown|market_report|conference_intelligence|technical_publication|regulatory_filing|supplier_intelligence|customer_feedback|benchmark_study|trade_show|other');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `ip_risk_flag` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Risk Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `ip_risk_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `ipc_classification` SET TAGS ('dbx_business_glossary_term' = 'International Patent Classification (IPC) Code');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `key_findings_summary` SET TAGS ('dbx_business_glossary_term' = 'Key Findings Summary');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `key_findings_summary` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `market_segment` SET TAGS ('dbx_business_glossary_term' = 'Target Market Segment');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `market_segment` SET TAGS ('dbx_value_regex' = 'factory_automation|building_automation|transportation|energy|utilities|process_industries|discrete_manufacturing|smart_infrastructure|other');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `owning_business_unit` SET TAGS ('dbx_business_glossary_term' = 'Owning Business Unit');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `patent_reference_number` SET TAGS ('dbx_business_glossary_term' = 'Patent Reference Number');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `patent_reference_number` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `recommended_action` SET TAGS ('dbx_business_glossary_term' = 'Recommended Action');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `recommended_action` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `record_code` SET TAGS ('dbx_business_glossary_term' = 'Competitive Intelligence Record Code');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `record_code` SET TAGS ('dbx_value_regex' = '^CI-[A-Z0-9]{4,12}$');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `regulatory_relevance_flag` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Relevance Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `regulatory_relevance_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `review_date` SET TAGS ('dbx_business_glossary_term' = 'Intelligence Review Date');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `roadmap_alignment_code` SET TAGS ('dbx_business_glossary_term' = 'Technology Roadmap Alignment Code');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `source_name` SET TAGS ('dbx_business_glossary_term' = 'Intelligence Source Name');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `source_name` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `source_type` SET TAGS ('dbx_business_glossary_term' = 'Intelligence Source Type');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `source_type` SET TAGS ('dbx_value_regex' = 'patent_database|industry_report|conference|trade_publication|regulatory_database|supplier_network|customer_interview|web_scraping|internal_teardown|analyst_briefing|other');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `source_url` SET TAGS ('dbx_business_glossary_term' = 'Intelligence Source URL');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `source_url` SET TAGS ('dbx_value_regex' = '^https?://.+');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `source_url` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Intelligence Record Status');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'draft|under_review|validated|published|archived|superseded');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `strategic_impact_level` SET TAGS ('dbx_business_glossary_term' = 'Strategic Impact Level');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `strategic_impact_level` SET TAGS ('dbx_value_regex' = 'critical|high|medium|low|negligible');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `strategic_implication` SET TAGS ('dbx_business_glossary_term' = 'Strategic Implication Assessment');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `strategic_implication` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|robotics|digitalization|energy_management|motion_control|industrial_iot|cybersecurity|other');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `technology_readiness_level` SET TAGS ('dbx_business_glossary_term' = 'Technology Readiness Level (TRL)');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `technology_readiness_level` SET TAGS ('dbx_value_regex' = '^[1-9]$');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Intelligence Record Title');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `title` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `validation_status` SET TAGS ('dbx_business_glossary_term' = 'Intelligence Validation Status');
ALTER TABLE `manufacturing_ecm`.`research`.`competitive_intelligence` ALTER COLUMN `validation_status` SET TAGS ('dbx_value_regex' = 'unvalidated|partially_validated|validated|disputed');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` SET TAGS ('dbx_data_type' = 'master_data');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` SET TAGS ('dbx_subdomain' = 'portfolio_strategy');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `rd_risk_id` SET TAGS ('dbx_business_glossary_term' = 'R&D Risk ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Rd Project Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `regulatory_obligation_id` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Obligation Id (Foreign Key)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Risk Owner Employee ID');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `actual_closure_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Actual Closure Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `actual_closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_business_glossary_term' = 'Advanced Product Quality Planning (APQP) Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `apqp_phase` SET TAGS ('dbx_value_regex' = 'plan_and_define|product_design_and_development|process_design_and_development|product_and_process_validation|launch_feedback_and_corrective_action');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `contingency_plan` SET TAGS ('dbx_business_glossary_term' = 'Risk Contingency Plan');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Created Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `description` SET TAGS ('dbx_business_glossary_term' = 'Risk Description');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `detectability_rating` SET TAGS ('dbx_business_glossary_term' = 'Risk Detectability Rating');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `detectability_rating` SET TAGS ('dbx_value_regex' = 'very_high|high|moderate|low|very_low');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `escalation_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Escalation Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `escalation_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `escalation_flag` SET TAGS ('dbx_business_glossary_term' = 'Risk Escalation Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `escalation_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `estimated_cost_impact_usd` SET TAGS ('dbx_business_glossary_term' = 'Estimated Cost Impact (USD)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `estimated_cost_impact_usd` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `estimated_schedule_impact_days` SET TAGS ('dbx_business_glossary_term' = 'Estimated Schedule Impact (Days)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_business_glossary_term' = 'External Research Partner Involved Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `external_partner_involved` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `freedom_to_operate_concern` SET TAGS ('dbx_business_glossary_term' = 'Freedom to Operate (FTO) Concern Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `freedom_to_operate_concern` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `identification_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Identification Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `identification_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `identified_by` SET TAGS ('dbx_business_glossary_term' = 'Risk Identified By');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `impact_score` SET TAGS ('dbx_business_glossary_term' = 'Risk Impact Score');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `impact_score` SET TAGS ('dbx_value_regex' = '^([1-9]|10)$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `impact_severity` SET TAGS ('dbx_business_glossary_term' = 'Risk Impact Severity');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `impact_severity` SET TAGS ('dbx_value_regex' = 'negligible|minor|moderate|major|critical');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `ip_risk_flag` SET TAGS ('dbx_business_glossary_term' = 'Intellectual Property (IP) Risk Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `ip_risk_flag` SET TAGS ('dbx_value_regex' = 'true|false');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `last_modified_timestamp` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}Td{2}:d{2}:d{2}.d{3}(Z|[+-]d{2}:d{2})$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Last Reviewed Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `last_reviewed_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `mitigation_plan` SET TAGS ('dbx_business_glossary_term' = 'Risk Mitigation Plan');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `next_review_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Next Review Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `next_review_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `probability_rating` SET TAGS ('dbx_business_glossary_term' = 'Risk Probability Rating');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `probability_rating` SET TAGS ('dbx_value_regex' = 'very_low|low|medium|high|very_high');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `probability_score` SET TAGS ('dbx_business_glossary_term' = 'Risk Probability Score');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `probability_score` SET TAGS ('dbx_value_regex' = '^(0(.d{1,2})?|1(.0{1,2})?)$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `regulatory_standard_reference` SET TAGS ('dbx_business_glossary_term' = 'Regulatory Standard Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `residual_risk_score` SET TAGS ('dbx_business_glossary_term' = 'Residual Risk Score');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `risk_category` SET TAGS ('dbx_business_glossary_term' = 'Risk Category');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `risk_category` SET TAGS ('dbx_value_regex' = 'technical|commercial|regulatory|resource|ip|safety|environmental|financial|schedule|supplier');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `risk_number` SET TAGS ('dbx_business_glossary_term' = 'R&D Risk Number');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `risk_number` SET TAGS ('dbx_value_regex' = '^RD-RSK-[0-9]{4}-[0-9]{5}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `risk_owner` SET TAGS ('dbx_business_glossary_term' = 'Risk Owner');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `risk_priority_number` SET TAGS ('dbx_business_glossary_term' = 'Risk Priority Number (RPN)');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `risk_priority_number` SET TAGS ('dbx_value_regex' = '^([1-9][0-9]{0,2}|1000)$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `risk_response_strategy` SET TAGS ('dbx_business_glossary_term' = 'Risk Response Strategy');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `risk_response_strategy` SET TAGS ('dbx_value_regex' = 'avoid|mitigate|transfer|accept|escalate|monitor');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `risk_score` SET TAGS ('dbx_business_glossary_term' = 'Risk Score');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `risk_subcategory` SET TAGS ('dbx_business_glossary_term' = 'Risk Subcategory');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `risk_subcategory` SET TAGS ('dbx_value_regex' = 'trl_gap|technology_feasibility|freedom_to_operate|market_timing|ip_infringement|ce_compliance|ul_certification|rohs_reach_compliance|key_person_dependency|lab_capacity|budget_overrun|schedule_delay|supplier_dependency|cybersecurity|safety_hazard');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `source_system` SET TAGS ('dbx_business_glossary_term' = 'Source System');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `source_system` SET TAGS ('dbx_value_regex' = 'Siemens_Teamcenter|SAP_S4HANA|Siemens_Opcenter|Manual|Other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_business_glossary_term' = 'Stage-Gate Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `stage_gate_phase` SET TAGS ('dbx_value_regex' = 'concept|feasibility|development|validation|launch|post_launch');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `status` SET TAGS ('dbx_business_glossary_term' = 'Risk Status');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `status` SET TAGS ('dbx_value_regex' = 'identified|under_assessment|open|mitigating|escalated|closed|accepted|transferred');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `target_closure_date` SET TAGS ('dbx_business_glossary_term' = 'Risk Target Closure Date');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `target_closure_date` SET TAGS ('dbx_value_regex' = '^d{4}-d{2}-d{2}$');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `technology_domain` SET TAGS ('dbx_business_glossary_term' = 'Technology Domain');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `technology_domain` SET TAGS ('dbx_value_regex' = 'automation|electrification|smart_infrastructure|robotics|power_electronics|connectivity|sensing|software|materials|mechanical|thermal|cybersecurity|other');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `title` SET TAGS ('dbx_business_glossary_term' = 'Risk Title');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `trl_at_identification` SET TAGS ('dbx_business_glossary_term' = 'Technology Readiness Level (TRL) at Identification');
ALTER TABLE `manufacturing_ecm`.`research`.`rd_risk` ALTER COLUMN `trl_at_identification` SET TAGS ('dbx_value_regex' = '^([1-9])$');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` SET TAGS ('dbx_subdomain' = 'collaboration_funding');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` SET TAGS ('dbx_association_edges' = 'research.rd_project,research.research_partner');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `project_partner_assignment_id` SET TAGS ('dbx_business_glossary_term' = 'Project Partner Assignment ID');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `partner_id` SET TAGS ('dbx_business_glossary_term' = 'Project Partner Assignment - Research Partner Id');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Project Partner Assignment - Rd Project Id');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `allocated_budget_amount` SET TAGS ('dbx_business_glossary_term' = 'Allocated Budget Amount');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `allocated_budget_amount` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `assignment_status` SET TAGS ('dbx_business_glossary_term' = 'Assignment Status');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `budget_currency_code` SET TAGS ('dbx_business_glossary_term' = 'Budget Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `contribution_type` SET TAGS ('dbx_business_glossary_term' = 'Contribution Type');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Record Created Date');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `deliverable_reference` SET TAGS ('dbx_business_glossary_term' = 'Deliverable Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `end_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment End Date');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `ip_contribution_flag` SET TAGS ('dbx_business_glossary_term' = 'IP Contribution Flag');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `ip_contribution_flag` SET TAGS ('dbx_confidential' = 'true');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `last_modified_by` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified By');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `last_modified_date` SET TAGS ('dbx_business_glossary_term' = 'Record Last Modified Date');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `role_in_project` SET TAGS ('dbx_business_glossary_term' = 'Partner Role in Project');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `start_date` SET TAGS ('dbx_business_glossary_term' = 'Assignment Start Date');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `work_package_reference` SET TAGS ('dbx_business_glossary_term' = 'Work Package Reference');
ALTER TABLE `manufacturing_ecm`.`research`.`project_partner_assignment` ALTER COLUMN `created_by` SET TAGS ('dbx_business_glossary_term' = 'Record Created By');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` SET TAGS ('dbx_subdomain' = 'prototype_development');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` SET TAGS ('dbx_association_edges' = 'research.prototype,procurement.supplier');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `prototype_sourcing_id` SET TAGS ('dbx_business_glossary_term' = 'Prototype Sourcing Identifier');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `procurement_supplier_id` SET TAGS ('dbx_business_glossary_term' = 'Prototype Sourcing - Supplier Id');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `research_prototype_id` SET TAGS ('dbx_business_glossary_term' = 'Prototype Sourcing - Prototype Id');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `component_supplied` SET TAGS ('dbx_business_glossary_term' = 'Component Supplied');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `cost` SET TAGS ('dbx_business_glossary_term' = 'Component Cost');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `cost_currency` SET TAGS ('dbx_business_glossary_term' = 'Cost Currency Code');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `created_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `lead_time_days` SET TAGS ('dbx_business_glossary_term' = 'Actual Lead Time Days');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Sourcing Notes');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `performance_rating` SET TAGS ('dbx_business_glossary_term' = 'Component Performance Rating');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `prototype_phase` SET TAGS ('dbx_business_glossary_term' = 'Prototype Development Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `qualification_status` SET TAGS ('dbx_business_glossary_term' = 'Supplier Qualification Status');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `quantity_supplied` SET TAGS ('dbx_business_glossary_term' = 'Component Quantity Supplied');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `supply_date` SET TAGS ('dbx_business_glossary_term' = 'Component Supply Date');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `unit_of_measure` SET TAGS ('dbx_business_glossary_term' = 'Unit of Measure');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_sourcing` ALTER COLUMN `updated_timestamp` SET TAGS ('dbx_business_glossary_term' = 'Record Update Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` SET TAGS ('dbx_subdomain' = 'prototype_development');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` SET TAGS ('dbx_association_edges' = 'research.prototype,technology.it_asset');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ALTER COLUMN `prototype_asset_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'prototype_asset_allocation Identifier');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ALTER COLUMN `employee_id` SET TAGS ('dbx_business_glossary_term' = 'Allocated By Employee');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ALTER COLUMN `equipment_allocation_id` SET TAGS ('dbx_business_glossary_term' = 'Allocation Identifier');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ALTER COLUMN `it_asset_id` SET TAGS ('dbx_business_glossary_term' = 'Prototype Asset Allocation - It Asset Id');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ALTER COLUMN `research_prototype_id` SET TAGS ('dbx_business_glossary_term' = 'Prototype Asset Allocation - Prototype Id');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ALTER COLUMN `allocation_end` SET TAGS ('dbx_business_glossary_term' = 'Allocation End Date');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ALTER COLUMN `allocation_notes` SET TAGS ('dbx_business_glossary_term' = 'Allocation Notes');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ALTER COLUMN `allocation_start` SET TAGS ('dbx_business_glossary_term' = 'Allocation Start Date');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ALTER COLUMN `allocation_status` SET TAGS ('dbx_business_glossary_term' = 'Allocation Status');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ALTER COLUMN `test_phase` SET TAGS ('dbx_business_glossary_term' = 'Test Phase');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ALTER COLUMN `usage_purpose` SET TAGS ('dbx_business_glossary_term' = 'Usage Purpose');
ALTER TABLE `manufacturing_ecm`.`research`.`prototype_asset_allocation` ALTER COLUMN `utilization_hours` SET TAGS ('dbx_business_glossary_term' = 'Utilization Hours');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` SET TAGS ('dbx_data_type' = 'association_data');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` SET TAGS ('dbx_subdomain' = 'intellectual_property');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` SET TAGS ('dbx_association_edges' = 'research.rd_project,engineering.regulatory_certification');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `project_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Project Certification Identifier');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `engineering_regulatory_certification_id` SET TAGS ('dbx_business_glossary_term' = 'Project Certification - Regulatory Certification Id');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `rd_project_id` SET TAGS ('dbx_business_glossary_term' = 'Project Certification - Rd Project Id');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `actual_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Actual Completion Date');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `certification_scope` SET TAGS ('dbx_business_glossary_term' = 'Project-Specific Certification Scope');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `certification_status` SET TAGS ('dbx_business_glossary_term' = 'Project Certification Status');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `compliance_level` SET TAGS ('dbx_business_glossary_term' = 'Compliance Level');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `created_date` SET TAGS ('dbx_business_glossary_term' = 'Record Creation Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `estimated_cost` SET TAGS ('dbx_business_glossary_term' = 'Certification Cost Estimate');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `last_updated_date` SET TAGS ('dbx_business_glossary_term' = 'Record Last Update Timestamp');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `market_requirement_flag` SET TAGS ('dbx_business_glossary_term' = 'Market Requirement Indicator');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `notes` SET TAGS ('dbx_business_glossary_term' = 'Certification Notes');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `priority` SET TAGS ('dbx_business_glossary_term' = 'Certification Priority');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `responsible_engineer` SET TAGS ('dbx_business_glossary_term' = 'Certification Responsible Engineer');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `target_completion_date` SET TAGS ('dbx_business_glossary_term' = 'Certification Target Date');
ALTER TABLE `manufacturing_ecm`.`research`.`project_certification` ALTER COLUMN `testing_phase` SET TAGS ('dbx_business_glossary_term' = 'Certification Testing Phase');
