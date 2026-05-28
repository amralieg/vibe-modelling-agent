
# Holistic Critique — Retail Customer Schema (MVM v1)


# Holistic Critique — retail/mvm_v1/schemas/retail_customer_schema_v1_mvm.sql

Source: vibe-business-data-models / retail / mvm_v1 / customer schema
Reviewer: Ruslan Dautkhanov
Date: 2026-05-21
File metrics: 10 tables · 335 columns · 49 cross-domain FK references · 896 lines
Top-line verdict: Impressive breadth and clear domain knowledge in the comments. But it is not minimum-viable — it is a full enterprise CDP/MDM/CRM rolled together, opinionated on specific vendors, with real correctness bugs and architectural smells that would make it hard to adopt as a neutral reference.
---

## 1. Hard correctness bugs (must fix)

These are not taste issues — they are wrong.

### 1a. Data type errors (13 columns)

| Column | Declared | Should be | Why |
| contact.contact_value | DECIMAL(18,2) | STRING | Comment says "email address, phone number, or social media handle" |
| preference.preference_value | DECIMAL(18,2) | STRING | Comment lists examples: "email", "organic produce", "Nike", "Store #1234", "Spanish", "weekly" |
| profile.nps_score | STRING | INT (or SMALLINT) | NPS is -100 to +100, numeric |
| service_case.nps_score | STRING | INT | Same |
| contact.bounce_count, contact.priority_rank | STRING | INT | Counts and ranks |
| segment.max_rfm_score, segment.min_rfm_score | STRING | INT | RFM is 3–15 numeric |
| preference.application_count, preference.priority_rank | STRING | INT |  |
| service_case.contact_attempts, service_case.interaction_count | STRING | INT |  |
| payment_method.usage_count | STRING | INT |  |
| account.total_lifetime_orders | STRING | INT |  |
| payment_method.expiry_month, expiry_year | STRING | TINYINT / SMALLINT |  |
These break SUM/AVG/comparison and force casts in every downstream query. They are the giveaway that the LLM generated columns by description without checking the type.

### 1b. Schema/database name mismatch

File is named _v1_mvm.sql but the DDL uses ` retail_ecm.customer ` — i.e., it writes into the ECM catalog. The MVM and ECM schema files target the same catalog, which means deploying both blows away the first. Probably an agent bug.

### 1c. Comment for customer database promises "households" but there is no household table

Database comment says: "Single source of truth for all customer identity, profiles, households, segments…" — no household table exists. Either the comment lies or a table was dropped.
---

## 2. Vendor opinion is everywhere

Counted vendor-name occurrences across the file:
| Vendor | Mentions |
| Informatica MDM | 7 |
| Salesforce Commerce Cloud | 6 |
| Salesforce Service Cloud | 5 |
| USPS | 4 |
| SAP CAR | 3 |
| Nike (as example brand) | 3 |
| BNPL providers (Affirm, Afterpay, Klarna, Zip, Sezzle) | each in enum constraint |
| Card brands (Visa, Mastercard, Amex, Discover, JCB, UnionPay) | each in enum constraint |
| Wallet providers (Apple Pay, Google Pay, PayPal, Samsung Pay, Venmo) | each in enum constraint |
| Payment processors (Stripe, Adyen, Braintree, Cybersource) | named in comment |
| Oracle Retail | 1 |
Two distinct problems:
(a) Comments naming specific vendors — e.g., profile.profile_id: "Primary key for the golden customer record in Informatica MDM." These should be vendor-neutral: "Primary key for the master customer record." Implementation detail of which MDM tool you happen to use does not belong in a reference data model.
(b) Enum constraints baking in vendor lists — e.g., payment_method.card_brand constrained to visa|mastercard|amex|discover|jcb|unionpay. This is half a real constraint and half marketing copy. Real retail data must also accommodate Maestro, Diners, RuPay, regional cards, store cards, EBT in the US. Either expand to ~20+ valid values (impractical) or stop trying to enum-constrain it. Same problem with BNPL providers (Klarna, Affirm, Afterpay, Zip, Sezzle — but not Sunbit, Splitit, PayPal Pay-in-4, Apple Pay Later, etc.) and wallets.
Suggested fix: keep enum constraints only for type categories (payment_method_type ∈ {credit_card, debit_card, wallet, gift_card, store_credit, bnpl}), not for specific brands or providers. Store card_brand and wallet_provider as free STRING with a comment listing "common values include…".
---

## 3. Over-engineering — "minimum viable" is anything but

For a model labeled Minimum Viable, 335 columns across 10 tables is the opposite of minimum. The Google Retail Data Model covers customer in ~60 attributes total. ARTS ODM 7.3 covers it in ~80. This MVM covers it in 335. The "minimum viable" claim is misleading.

### 3a. Four separate places to declare marketing consent

The same logical fact ("customer agreed to receive emails") is modeled in four tables:
profile.email_opt_in_flag, profile.sms_opt_in_flag, profile.marketing_consent_flag, profile.gdpr_consent_flag, profile.ccpa_opt_out_flag
account.marketing_opt_in, account.data_sharing_consent, account.marketing_opt_in_date, account.marketing_opt_out_date
contact.opt_in_marketing, contact.opt_in_transactional, contact.opt_in_date, contact.opt_out_date
consent table (the actual right place — 32 columns dedicated to it)
If you've got a consent table with full GDPR/CCPA scaffolding, the redundant flags on profile / account / contact are pure denormalization and a guaranteed consistency-bug source. Pick one (the consent table) and delete the rest.

### 3b. The preference table is a god-table

preference.preference_category can be any of: communication_channel | product_category_affinity | dietary_restriction | brand_preference | store_preference | language | notification_frequency | privacy_consent | marketing_opt_in | delivery_preference | payment_method_preference | shopping_time_preference.
That is 12 unrelated concepts crammed into one EAV-ish table. Communication channel preference, dietary restriction, and delivery preference are not the same kind of thing and should not share a row schema. This is the kind of model an LLM produces when asked "what could a preference look like?" — it union-types every example into one table.
For a clean model: separate communication_preference, dietary_restriction, and a small customer_attribute(key, value) extensibility table for the long tail.

### 3c. service_case belongs in its own domain

52 columns. 18+ FKs reaching into compliance, ecommerce, fulfillment, supplychain, supplier, store, merchandising, pricing, promotion, loyalty. This is not customer master data — it is customer-service operational data. Put it in a service domain. Same for customer_membership and segment — these are marketing-analytics constructs, not identity.
The customer domain currently contains:
Identity (profile) — belongs here
Commercial relationship (account) — debatable, see 3e
Contact methods (contact) — belongs here
Addresses (address) — belongs here
Saved payment methods (payment_method) — debatable, see 3f
consent — probably belongs in a compliance or privacy domain (regulator-facing, not identity)
preference — split it up; not master data
segment — marketing domain
customer_membership — marketing domain
service_case — service domain
A real minimum-viable customer schema is 4-5 tables, not 10.

### 3d. Computed-from-transactions metrics stored on master tables

profile.last_interaction_date, profile.last_purchase_date, profile.cltv_score, profile.cac_amount, profile.nps_score, account.total_lifetime_orders, account.last_transaction_date, account.outstanding_balance — all derivable from other tables.
Putting derived metrics on master records means every transaction has to update profile, which is the classic OLAP-bleed-into-OLTP smell. These should be metric views or materialized views, not columns. The metrics/ folder in this repo presumably has them — they should not be duplicated.

### 3e. profile vs account overlap

profile (39 cols) and account (38 cols) share huge overlap: both have preferred_channel, both have marketing opt-in flags, both have status. The split makes sense for B2B (one corporate account → multiple users), but it is awkward for B2C where everyone is a 1:1.
Cleaner pattern: keep profile as the identity entity. account becomes optional and exists only for B2B/wholesale relationships — most B2C rows have null or default account rows.

### 3f. payment_method on the customer schema

PCI DSS scope: storing cardholder_name (column 338) puts this table in PCI scope, which means everything joined to it transitively becomes audit territory. Industry practice is to keep tokenized payment instruments in a vault-adjacent schema (often finance.payment_instrument), not on customer master tables, so non-payment workloads stay out of PCI scope.
---

## 4. Tags and metadata smell

The file ends with ~500 ALTER ... SET TAGS statements (lines 410–896 are mostly tags). Pattern is:
Every column gets dbx_business_glossary_term = '' — but those values are mostly just the column name capitalized. E.g., account_id → 'Account ID'. That is noise, not glossary.
PII tags (dbx_pii_name, dbx_pii_phone, dbx_pii_email, dbx_pii_dob, dbx_pii_address, dbx_pii_financial) — these are useful. Keep.
dbx_value_regex tags duplicate what is already in the column comment as text. Pick one source.
If you can cut the auto-generated glossary noise, the file gets ~40% shorter.
---

## 5. Architectural smells


### 5a. 49 cross-domain FKs from one schema

The customer schema reaches into product, pricing, promotion, supplier, supplychain, store, merchandising, fulfillment, loyalty, finance, ecommerce. Essentially every other domain. This is the LLM optimistically adding plausible joins everywhere.
Real customer data should depend on almost nothing. Customer is the root. Transactions depend on customer, not the other way around. A profile.location_id FK into store makes sense (preferred store). A consent.promo_campaign_id FK into promotion does not — campaigns reference consent records, not the other way.
The dependency arrow direction looks reversed in many of these FKs.

### 5b. No SCD pattern consistency

Some tables (preference, contact, segment, customer_membership) have effective_start_date / effective_end_date / status — proper SCD Type 2 vibes.
Other tables (profile, account, address) just have last_modified_timestamp — i.e., destructive update, no history.
For a model claiming to be a "golden record" with audit trails for GDPR, the master tables (profile, account) need SCD-2 or change-data-capture, not destructive update.

### 5c. customer_type confusion

profile.customer_type ∈ {individual, corporate, employee, vip, wholesale} — mixes:
Entity type (individual vs corporate) — should determine which subtype table to look at
Classification (vip) — also exists as vip_flag and account_tier='vip'. Redundant.
Relationship (employee) — also exists as employee_flag. Redundant.
A cleaner schema separates what kind of legal entity (individual/organization) from what role they play to us (consumer/employee/wholesale_buyer/...).
---

## 6. What's actually good (keep these)

Don't throw the whole thing out:
Domain decomposition at the top level (customer/loyalty/order/fulfillment/...) is sensible.
MVM/ECM split is a great product framing.
PII tagging with consistent dbx_pii_* tag values is useful for masking and access control.
GDPR/CCPA scaffolding in the consent table is genuinely thorough — keep this table almost as-is, just move it to a privacy or compliance domain.
Most enum constraints are reasonable category lists (status values, lifecycle stages) — only the vendor-flavored ones (card brands, BNPL providers, wallet providers) need rework.
Column comments are domain-aware — they read like someone who knows retail wrote them (or guided the LLM well). Just need to strip vendor names.
Cross-domain FK *justifications* in comments — when accurate, these are gold. They explain why the relationship exists, which is exactly what's missing from ARTS ODM.
---

## 7. Concrete asks to take back to the author

Frame it as five concrete asks:
Vendor-strip pass: regex-replace ~15 vendor names with neutral descriptors in column comments. Specifically: Informatica MDM → "the customer master data system", Salesforce Commerce Cloud → "the e-commerce platform", Salesforce Service Cloud → "the case management system", SAP CAR → "the retail analytics platform", drop "Nike" examples entirely. Restrict enum constraints to abstract type categories only.
Fix the 13 data type bugs listed in section 1a. These are correctness, not opinion.
De-duplicate consent: pick the consent table as the single source of truth, delete the 11 redundant opt-in flags scattered across profile / account / contact.
Split god-tables and re-home: preference → break into focused tables; service_case → move to a service domain; segment / customer_membership → move to a marketing or customer_intelligence domain. Truly minimum-viable customer = profile + address + contact + consent (+ optional account for B2B).
Remove derived columns from master tables: cltv_score, cac_amount, nps_score, last_purchase_date, total_lifetime_orders, outstanding_balance should be metric views or materialized views, not stored on profile / account. They invite write amplification and staleness.
Plus the broader points already covered:
Add a LICENSE (Apache 2.0) so it can be referenced or forked.
Add a provenance disclosure ("LLM-generated, last human-reviewed YYYY-MM-DD by …") so adopters know to vet.
Clarify catalog name discipline (retail_mvm / retail_ecm distinct catalogs, not both writing to retail_ecm).
---

## 8. The deeper question

The LLM has produced a plausibly comprehensive retail customer model that reads as if it was written by someone who consulted with five different retailers (each with their own MDM/CRM stack) and tried to satisfy all of them. The result has the union of everyone's opinions — which is exactly what you don't want in a reference model. A reference model needs the intersection of universal concepts, with extensibility hooks for everything else.
If the goal is Databricks Open Retail Data Model — vendor-neutral, opinionated only where the industry has genuine consensus, minimal in MVM — this needs substantial editing, not just polishing. The bones are good; the muscles are bloated.