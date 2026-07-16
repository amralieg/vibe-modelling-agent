# Example Business Prompt — Vibe Modeling Agent

This is a **worked example** of the input a business provides to the vibe-modeling agent to
generate a brand-new (`new base model`) Expanded Coverage Model (ECM). It uses a **fictional
company, "Harborline Marine & Power,"** deliberately constructed to exercise the same modeling
surface as real engagements: a multi-brand manufacturer with a component master, multiple
go-to-market channels, connected/telematics products, and a real regulatory + systems-of-record
footprint.

**How to use it:**
1. Read the `description` field below — that free-text business narrative is the single most
   important input. The richer and more specific it is (business processes, **systems of record**,
   channels, industry jargon, regulations, and the domains already in use), the better the
   generated model. Don't worry about writing it by hand: hand this file to your coding agent of
   choice and ask it to produce an equivalent narrative for **your** business — it can pull a lot
   of the public context (industry standards, typical systems) for you; you supply the internal
   specifics (your systems of record, your channels, your jargon).
2. Fill in the scalar config fields (`business_domains`, `org_divisions`, conventions, etc.) to
   match your organization's naming and governance standards.
3. Generate a fresh `vibe_session_id` per the integration guide (step 1) before running.

> Swap every "Harborline" specific for your own. The **shape** is what matters — mirror the depth,
> not the content.

---

## `model_requirements` (the agent input)

```json
{
  "business_name": "Harborline Marine & Power",
  "description": "Harborline Marine & Power is a fictional North American manufacturer of marine propulsion, onboard power, and recreational watercraft systems, headquartered in Charleston, South Carolina. The business operates three major segments that the data model must distinguish cleanly — Marine Propulsion (outboard, sterndrive, and inboard engines plus electric-drive systems across acquired brands Tidewater, Halyard, BlueFin, and the recently acquired (March 2025) electric-drive startup VoltWake), Onboard Power & Systems (marine generators, inverters, shore-power, battery management, and the connected NavHub telemetry platform), and Recreational Craft (pontoon, bay, and center-console boats built on the Harborline hull platform, sold as engineered configurations). Harborline's go-to-market is bifurcated across two dominant channels the data model must separate: (1) Dealer / Replacement, sold through ~600 independent marine dealers who hold Harborline inventory, sell on to boat owners and marinas, and feed back point-of-sale (POS) sell-out and warranty-registration data enabling dealer churn analysis, overstock detection, and rigging-kit trend analytics; and (2) OEM / Boatbuilder, where Harborline propulsion and power systems are spec'd into third-party boatbuilder production lines under multi-year supply agreements, engineered-to-order, flowing through direct fulfillment without dealer stocking. Additional channels: direct / national accounts (government, commercial fleet, and rental operators), e-commerce parts and accessories, and NavHub SaaS subscriptions for connected-fleet monitoring. Core business processes include: raw-material and component procurement (aluminum castings, stainless hardware, lithium cells, power electronics, wiring harnesses, propellers); a multi-source component master where ~55,000 purchased parts live across SAP and an aging Access-based Legacy Parts Register (LPR) of ~250 spreadsheets, currently being rationalized into Teamcenter PLM; supplier consolidation (a CFO-priority initiative to reduce from ~5 suppliers per category down to ~2 via cross-supplier price comparison); BOM engineering and ECN management; finished-goods manufacturing across US plants (Charleston SC, Neenah WI, Mooresville NC) and a Monterrey Mexico plant plus Asian contract manufacturing; finished-goods logistics to regional distribution centers; dealer fulfillment against stock orders and OEM fulfillment against engineered supply agreements; return and warranty handling; connected-product telemetry ingestion from NavHub-equipped engines (hours, fault codes, GPS, fuel burn); ABYC and NMEA compliance reporting; EPA and CARB marine-engine emissions certification with a model-year certification deadline that drives engine-family + emissions-family + fuel-system feeds to a 3P certification vendor; and quarterly financial close in SAP S/4HANA. Industry jargon: hin (hull identification number), engine_family, emissions_family, sku, mpn (manufacturer part number), lpr (legacy parts register), outboard, sterndrive, inboard, kicker, rigging_kit, propeller, pitch, wot (wide-open throttle), nmea_2000, can_bus, tpms-equivalent (tank/level senders), shore_power, bms (battery management system), soc (state of charge), pos (dealer point of sale), sell_in, sell_out, sell_through, oem_order, stock_order, dealer, marina, boatbuilder, spec, submittal, abyc, nmea, epa_marine, carb, ce_rcd (EU Recreational Craft Directive), dot (trailer), bom, ecn, plm, mes, wip, oee, capa, ncr, 8d, fmea. Operational systems of record: SAP S/4HANA (primary ERP, source of truth for parts, POs, BOM, financial close, and post-sale manufacturing and shipping); a legacy on-prem SQL Server order-management system (OMS) for dealer and OEM order processing plus custom supply-chain applications; Salesforce (CRM, B2B dealer and boatbuilder accounts, plus CPQ for OEM supply agreements); Teamcenter PLM (target north-star for component and finished-good specifications, migration in progress); PDM (SQL Server, master data for finished-good product series, marketing, options, variants); an Items Datastore (master item data for finished goods and parts); a Partner Master (master data for dealers, boatbuilders, and marinas); NavHub telemetry operational store (connected-engine event streams on cloud object storage); Blue Yonder (demand planning); a procurement-pricing feed shared via Delta Sharing; a 3P emissions-certification portal; 3P component-enrichment services (SiliconExpert-equivalent); and Lakebase (application backend for an internal Rigging Configurator). A long tail includes ServiceNow, Workday, and legacy Power BI and Tableau reporting. Regulatory environment: EPA and CARB marine spark-ignition and compression-ignition emissions standards; US Coast Guard and ABYC electrical and fuel-system safety standards; NMEA 2000 interoperability; EU Recreational Craft Directive (RCD) and CE marking; California Prop 65; RoHS and REACH (chemical compliance); DOT (trailered-craft components); SOX (financial reporting); PCI DSS (dealer and e-commerce payments); and ISO 9001 / IATF-style quality management. Known data domains in use at Harborline: product_lifecycle, component_master, manufacturing, quality, supply_chain_planning, procurement, logistics, product_catalog, pricing, quote, sales_order (split OEM versus stock), oem_program, dealer (with POS event streams), customer, connected_product (NavHub telemetry), billing, finance, and compliance.",
  "operation": "new base model",
  "data_model_scopes": "Expanded Coverage Model - ECM",
  "business_domains": "product_lifecycle, component_master, manufacturing, quality, supply_chain_planning, procurement, logistics, product_catalog, pricing, quote, sales_order, oem_program, dealer, customer, connected_product, billing, finance, compliance",
  "org_divisions": "Operations, Business and Corporate",
  "org_divisions_value": "operations, business, corporate",
  "deployment_catalog": "harborline_ecm",
  "cataloging_style": "one_catalog",
  "generate_samples": "0",
  "model_conventions": {
    "data_classification_levels": "restricted=restricted, confidential=confidential, internal=Internal, public=public",
    "data_asset_naming_convention": "snake_case",
    "primary_key_suffix": "_id",
    "foreign_key_suffix": "",
    "schema_prefix": "",
    "schema_suffix": "",
    "tag_prefix": "dbx_",
    "tag_suffix": "",
    "catalog_prefix": "",
    "catalog_suffix": "",
    "table_id_type": "BIGINT",
    "boolean_format": "Boolean (True/False)",
    "date_format": "yyyy-MM-dd",
    "timestamp_format": "yyyy-MM-dd'T'HH:mm:ss.SSSXXX",
    "add_house_keeping_columns": "No",
    "add_history_tracking_columns": "No"
  },
  "vibe_session_id": "<GENERATE A FRESH SESSION ID PER THE INTEGRATION GUIDE>"
}
```

---

# The `description` field, section by section (readable version)

The single `description` string above is dense on purpose — the agent reads it as one narrative.
But it is built from **eight distinct sections**, and it's easiest to author your own by writing
each section below and then concatenating them. Each block shows what the section is *for*, then
the Harborline text for that section.

### 1. Company overview & segments
*What it's for:* Anchor the model in who the company is and its distinct **lines of business**.
Each major segment usually maps to clusters of domains. Name acquired brands and recent
acquisitions — they hint at where the model needs to reconcile overlapping data.

> Harborline Marine & Power is a fictional North American manufacturer of marine propulsion,
> onboard power, and recreational watercraft systems, headquartered in Charleston, South Carolina.
> The business operates **three major segments** that the data model must distinguish cleanly —
> **Marine Propulsion** (outboard, sterndrive, and inboard engines plus electric-drive systems
> across acquired brands Tidewater, Halyard, BlueFin, and the recently acquired (March 2025)
> electric-drive startup VoltWake), **Onboard Power & Systems** (marine generators, inverters,
> shore-power, battery management, and the connected NavHub telemetry platform), and
> **Recreational Craft** (pontoon, bay, and center-console boats built on the Harborline hull
> platform, sold as engineered configurations).

### 2. Go-to-market channels
*What it's for:* Channels drive some of the most important modeling decisions — especially where
the same "order" or "customer" concept behaves differently per channel. Call out any channel the
model must **separate cleanly** (this is what produced Acuity's Stock-vs-Project split). Mention
the feedback data each channel produces (POS, warranty registration, telemetry).

> Harborline's go-to-market is **bifurcated across two dominant channels the data model must
> separate**: (1) **Dealer / Replacement**, sold through ~600 independent marine dealers who hold
> Harborline inventory, sell on to boat owners and marinas, and feed back point-of-sale (POS)
> sell-out and warranty-registration data enabling dealer churn analysis, overstock detection, and
> rigging-kit trend analytics; and (2) **OEM / Boatbuilder**, where Harborline propulsion and power
> systems are spec'd into third-party boatbuilder production lines under multi-year supply
> agreements, engineered-to-order, flowing through direct fulfillment without dealer stocking.
> Additional channels: direct / national accounts (government, commercial fleet, and rental
> operators), e-commerce parts and accessories, and NavHub SaaS subscriptions for connected-fleet
> monitoring.

### 3. Core business processes
*What it's for:* This is the backbone of the domain map — each process tends to become one or
more domains/facts. Walk the value chain end to end (procure → engineer → make → move → sell →
service). Include priority initiatives (e.g., supplier consolidation) and any **hard deadlines**
(a regulatory cutoff signals a domain that must exist).

> Core business processes include: raw-material and component procurement (aluminum castings,
> stainless hardware, lithium cells, power electronics, wiring harnesses, propellers); a
> **multi-source component master** where ~55,000 purchased parts live across SAP and an aging
> Access-based Legacy Parts Register (LPR) of ~250 spreadsheets, currently being rationalized into
> Teamcenter PLM; **supplier consolidation** (a CFO-priority initiative to reduce from ~5 suppliers
> per category down to ~2 via cross-supplier price comparison); BOM engineering and ECN management;
> finished-goods manufacturing across US plants (Charleston SC, Neenah WI, Mooresville NC) and a
> Monterrey Mexico plant plus Asian contract manufacturing; finished-goods logistics to regional
> distribution centers; dealer fulfillment against stock orders and OEM fulfillment against
> engineered supply agreements; return and warranty handling; **connected-product telemetry
> ingestion** from NavHub-equipped engines (hours, fault codes, GPS, fuel burn); ABYC and NMEA
> compliance reporting; **EPA and CARB marine-engine emissions certification with a model-year
> certification deadline** that drives engine-family + emissions-family + fuel-system feeds to a 3P
> certification vendor; and quarterly financial close in SAP S/4HANA.

### 4. Industry jargon
*What it's for:* Gives the agent your vocabulary so table/column names and comments use terms your
people recognize. Include acronyms with expansions. This directly improves the "legible" quality
of the output. List the terms flat, comma-separated.

> Industry jargon: hin (hull identification number), engine_family, emissions_family, sku, mpn
> (manufacturer part number), lpr (legacy parts register), outboard, sterndrive, inboard, kicker,
> rigging_kit, propeller, pitch, wot (wide-open throttle), nmea_2000, can_bus, tpms-equivalent
> (tank/level senders), shore_power, bms (battery management system), soc (state of charge), pos
> (dealer point of sale), sell_in, sell_out, sell_through, oem_order, stock_order, dealer, marina,
> boatbuilder, spec, submittal, abyc, nmea, epa_marine, carb, ce_rcd (EU Recreational Craft
> Directive), dot (trailer), bom, ecn, plm, mes, wip, oee, capa, ncr, 8d, fmea.

### 5. Operational systems of record (SoR)
*What it's for:* **This is the section that most improves the assess/build loop later.** The agent
uses your named SoRs to reason about where data actually comes from and, in the Genie-Code assess
phase, to call out **missing tables** for SoRs it doesn't see represented. Name each system, its
role, and its status (source of truth, legacy, target/north-star, migration-in-progress). Note
Delta Sharing feeds and any app backends (Lakebase).

> Operational systems of record: **SAP S/4HANA** (primary ERP, source of truth for parts, POs,
> BOM, financial close, and post-sale manufacturing and shipping); a legacy on-prem **SQL Server
> order-management system (OMS)** for dealer and OEM order processing plus custom supply-chain
> applications; **Salesforce** (CRM, B2B dealer and boatbuilder accounts, plus CPQ for OEM supply
> agreements); **Teamcenter PLM** (target north-star for component and finished-good
> specifications, migration in progress); **PDM** (SQL Server, master data for finished-good
> product series, marketing, options, variants); an **Items Datastore** (master item data for
> finished goods and parts); a **Partner Master** (master data for dealers, boatbuilders, and
> marinas); **NavHub telemetry operational store** (connected-engine event streams on cloud object
> storage); **Blue Yonder** (demand planning); a procurement-pricing feed shared via **Delta
> Sharing**; a 3P emissions-certification portal; 3P component-enrichment services
> (SiliconExpert-equivalent); and **Lakebase** (application backend for an internal Rigging
> Configurator). A long tail includes ServiceNow, Workday, and legacy Power BI and Tableau
> reporting.

### 6. Regulatory environment
*What it's for:* Regulations generate compliance domains, classification requirements, and
mandatory attributes. List the standards that actually apply to your industry and geographies.

> Regulatory environment: **EPA and CARB** marine spark-ignition and compression-ignition emissions
> standards; **US Coast Guard and ABYC** electrical and fuel-system safety standards; **NMEA 2000**
> interoperability; **EU Recreational Craft Directive (RCD) and CE marking**; California Prop 65;
> RoHS and REACH (chemical compliance); DOT (trailered-craft components); **SOX** (financial
> reporting); **PCI DSS** (dealer and e-commerce payments); and ISO 9001 / IATF-style quality
> management.

### 7. Known data domains in use
*What it's for:* Tells the agent which domains you *already* recognize, so the output aligns with
your mental model and the agent can spot **white space** (domains you're missing). This should be
consistent with the `business_domains` field. Note where a domain splits (e.g., sales_order split
OEM vs. stock) or carries event streams.

> Known data domains in use at Harborline: product_lifecycle, component_master, manufacturing,
> quality, supply_chain_planning, procurement, logistics, product_catalog, pricing, quote,
> **sales_order (split OEM versus stock)**, oem_program, **dealer (with POS event streams)**,
> customer, **connected_product (NavHub telemetry)**, billing, finance, and compliance.

---

# The scalar config fields, explained

These sit alongside `description` in `model_requirements`. Only a few are truly
organization-specific — the rest are safe to copy as-is for a first ECM run.

| Field | Harborline value | What to put / why it matters |
|---|---|---|
| `business_name` | `Harborline Marine & Power` | Your company name. Names the run and the generated job (`dbx_vibe_modelling_<business_name>`). |
| `description` | *(the narrative above)* | **The single most important input.** See the eight sections above. |
| `operation` | `new base model` | Generate from scratch. (Other ops: `install model`, `vibe modeling of version`.) |
| `data_model_scopes` | `Expanded Coverage Model - ECM` | ECM = full breadth. Use `Minimum Viable Model - MVM` for a leaner first pass. |
| `business_domains` | *(17 domains)* | Comma-separated domain hints — optional but strongly recommended. Seeds the one-schema-per-domain structure; keep consistent with section 7. |
| `org_divisions` | `Operations, Business and Corporate` | Breadth of divisions the model spans. Options: `Operations` / `Operations and Business` / `Operations, Business and Corporate`. |
| `org_divisions_value` | `operations, business, corporate` | Machine-readable form of the above. |
| `deployment_catalog` | `harborline_ecm` | Target Unity Catalog name the model lands in. |
| `cataloging_style` | `one_catalog` | How catalogs are split. Options: `One Catalog` / `Catalog per Division` / `Catalog per Domain`. |
| `generate_samples` | `0` | `0` = metadata-only model. Bump to `5`/`10`/`15`/… to have the agent synthesize sample rows. |
| `model_conventions.data_classification_levels` | `restricted=…, confidential=…, internal=Internal, public=public` | Your governance classification key=label pairs; applied as tags. |
| `model_conventions.data_asset_naming_convention` | `snake_case` | Naming style for tables/columns. Options: `snake_case` / `camelCase` / `PascalCase` / `SCREAMING_CASE`. |
| `model_conventions.primary_key_suffix` | `_id` | PK column suffix. |
| `model_conventions.foreign_key_suffix` | `` (empty) | FK column suffix (empty = FK columns aren't suffix-marked). |
| `model_conventions.schema_prefix` / `schema_suffix` | `` (empty) | Optional affixes on schema names. |
| `model_conventions.tag_prefix` / `tag_suffix` | `dbx_` / `` | Prefix/suffix for governed tags. |
| `model_conventions.catalog_prefix` / `catalog_suffix` | `` (empty) | Optional affixes on catalog names. |
| `model_conventions.table_id_type` | `BIGINT` | Surrogate key type. Options: `BIGINT` / `INT` / `LONG` / `STRING`. |
| `model_conventions.boolean_format` | `Boolean (True/False)` | How booleans are represented. Options: `Boolean (True/False)` / `Int (0/1)` / `String (Y/N)`. |
| `model_conventions.date_format` | `yyyy-MM-dd` | Date format string. |
| `model_conventions.timestamp_format` | `yyyy-MM-dd'T'HH:mm:ss.SSSXXX` | Timestamp format string. |
| `model_conventions.add_house_keeping_columns` | `No` | Add ingestion/audit housekeeping columns? `No` / `Yes`. |
| `model_conventions.add_history_tracking_columns` | `No` | Add SCD/history-tracking columns? `No` / `Yes`. |
| `vibe_session_id` | *(generate fresh)* | **Required.** Ties the run to its session and the end-of-run count tags (domains, products, attributes, foreign_keys, tags, metrics). Generate per the integration guide before running. |

---

## TL;DR for building your own

1. **Write the eight `description` sections** (overview/segments → channels → processes → jargon →
   systems of record → regulations → domains-in-use). Hand this file to your coding agent and ask
   it to draft the equivalent for your company; you fill in the internal specifics — especially the
   **systems of record**, which most improve the downstream assess/build loop.
2. **Set the org-specific scalars:** `business_name`, `business_domains`, `deployment_catalog`,
   `org_divisions`, and `model_conventions` to match your standards.
3. **Generate a fresh `vibe_session_id`** and run `operation: new base model` at ECM scope.
4. Expect to iterate — a first run often surfaces a missing system of record or domain. Re-running
   the modeling agent for wholesale changes is cheap; once a domain is close, switch to the
   Genie-Code assess loop to refine it in place against your real bronze data.
