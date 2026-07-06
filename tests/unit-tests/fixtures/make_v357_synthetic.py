#!/usr/bin/env python3
"""Generate the v3.5.7 synthetic defect model + its companion next_vibes.

Deterministic. 5 domains / exactly 50 products, deliberately INDUSTRY-MIXED (healthcare,
automotive, retail, banking, + one JUNK sentinel domain) so the same fixture doubles as the
industry-bias probe: every fix must behave identically regardless of the industry label.

Embedded defects (each maps to a v3.5.7 root-cause fix or an audit miss class):
  RC1  move_product   : products whose vibe says 'move to <domain>' (bare, no 'domain' word)
  RC2  preservation   : v1 products dropped from v2 (companion v2 omits them)
  RC3  junk domain    : a 'partially' domain (sentinel) with live products
  SEC3A stubs         : products with only PK (+maybe FK), no real attributes
  SEC3B thin          : products with < 12 non-key attributes
  SEC3C remove_fk     : product carrying a self/bogus FK to strip
  SEC3C rename_attr   : a column the vibe renames
  SEC3C rename_product: a product the vibe renames
  conflict            : same product targeted by BOTH a rename and a move (ordering conflict)
"""
import json
import os

HERE = os.path.dirname(os.path.abspath(__file__))


def attr(name, dtype="STRING", fk=None, pk=False):
    a = {"name": name, "data_type": dtype}
    if fk:
        a["foreign_key_to"] = fk
    if pk:
        a["primary_key"] = True
    return a


def prod(name, attrs):
    return {"name": name, "primary_key": f"{name}_id", "attributes": attrs}


def rich(name, dom, n=14, fks=None):
    """A healthy product: PK + n descriptive attrs + optional FKs."""
    a = [attr(f"{name}_id", "BIGINT", pk=True)]
    for fk in (fks or []):
        a.append(attr(f"{fk.split('.')[1]}_id", "BIGINT", fk=fk))
    for i in range(n):
        dt = ["STRING", "DECIMAL(18,2)", "TIMESTAMP", "INT", "BOOLEAN"][i % 5]
        a.append(attr(f"{name}_field_{i}", dt))
    return prod(name, a)


def stub(name, fk=None):
    """A STUB: only PK (+ maybe one FK), no descriptive attributes."""
    a = [attr(f"{name}_id", "BIGINT", pk=True)]
    if fk:
        a.append(attr(f"{fk.split('.')[1]}_id", "BIGINT", fk=fk))
    return prod(name, a)


def thin(name, fk=None):
    """THIN: PK + a couple of attrs (< 12 non-key)."""
    a = [attr(f"{name}_id", "BIGINT", pk=True)]
    if fk:
        a.append(attr(f"{fk.split('.')[1]}_id", "BIGINT", fk=fk))
    a += [attr(f"{name}_name"), attr(f"{name}_status")]
    return prod(name, a)


def build():
    domains = []

    # 1) clinical_care (HEALTHCARE)
    clinical = []
    clinical.append(rich("patient", "clinical_care", 16))
    clinical.append(rich("encounter", "clinical_care", 14, ["clinical_care.patient.patient_id", "clinical_care.provider.provider_id"]))
    clinical.append(rich("diagnosis", "clinical_care", 12, ["clinical_care.encounter.encounter_id"]))
    clinical.append(rich("procedure", "clinical_care", 12, ["clinical_care.encounter.encounter_id"]))
    clinical.append(rich("medication", "clinical_care", 13))
    clinical.append(stub("lab_result", "clinical_care.encounter.encounter_id"))            # STUB
    clinical.append(thin("provider"))                                                       # THIN
    # remove_fk defect: claim_clinical has a self-FK that should be stripped
    claim = rich("claim_clinical", "clinical_care", 12, ["clinical_care.patient.patient_id"])
    claim["attributes"].append(attr("claim_clinical_self_id", "BIGINT", fk="clinical_care.claim_clinical.claim_clinical_id"))  # SELF-FK to remove
    clinical.append(claim)
    clinical.append(rich("care_plan", "clinical_care", 11))
    clinical.append(rich("allergy", "clinical_care", 10))
    clinical.append(rich("immunization", "clinical_care", 10))
    clinical.append(rich("vital_sign", "clinical_care", 9, ["clinical_care.encounter.encounter_id"]))
    domains.append({"name": "clinical_care", "products": clinical})

    # 2) aftersales (AUTOMOTIVE) -- contains MOVE candidates + rename/move CONFLICT
    after = []
    # nameplate: vibe says move_product to merchandising (bare 'move to merchandising')
    after.append(rich("nameplate", "aftersales", 12))
    # body_style: vibe says move_product to merchandising
    after.append(rich("body_style", "aftersales", 11))
    after.append(rich("repair_order", "aftersales", 14, ["aftersales.dealer.dealer_id"]))
    after.append(rich("warranty_claim", "aftersales", 13, ["aftersales.repair_order.repair_order_id"]))
    after.append(rich("dealer", "aftersales", 12))
    after.append(rich("vehicle_service", "aftersales", 12))
    after.append(thin("service_part"))                                                       # THIN
    after.append(stub("recall_notice"))                                                      # STUB
    # rename_product candidate: 'svc_appt' -> 'service_appointment'
    after.append(rich("svc_appt", "aftersales", 10))
    after.append(rich("technician", "aftersales", 11))
    after.append(rich("loaner_vehicle", "aftersales", 10, ["aftersales.dealer.dealer_id"]))
    domains.append({"name": "aftersales", "products": after})

    # 3) merchandising (RETAIL) -- move TARGET domain
    merch = []
    merch.append(rich("sku", "merchandising", 15))
    merch.append(rich("inventory_lot", "merchandising", 13, ["merchandising.sku.sku_id"]))
    merch.append(rich("store", "merchandising", 14))
    merch.append(rich("promotion", "merchandising", 12))
    merch.append(rich("basket", "merchandising", 12, ["merchandising.store.store_id"]))
    merch.append(thin("price_point"))                                                        # THIN
    merch.append(stub("planogram_slot", "merchandising.store.store_id"))                     # STUB
    merch.append(rich("supplier", "merchandising", 12))
    merch.append(rich("category", "merchandising", 10))
    merch.append(rich("loyalty_member", "merchandising", 13))
    merch.append(rich("return_order", "merchandising", 11, ["merchandising.basket.basket_id"]))
    domains.append({"name": "merchandising", "products": merch})

    # 4) settlement (BANKING)
    setl = []
    setl.append(rich("trade", "settlement", 16))
    setl.append(rich("position", "settlement", 13, ["settlement.trade.trade_id"]))
    setl.append(rich("custody_account", "settlement", 14))
    setl.append(rich("reconciliation", "settlement", 12, ["settlement.position.position_id"]))
    setl.append(rich("ledger_entry", "settlement", 13, ["settlement.custody_account.custody_account_id"]))
    setl.append(rich("counterparty", "settlement", 12))
    setl.append(thin("fee_schedule"))                                                        # THIN
    setl.append(stub("corporate_action"))                                                    # STUB
    setl.append(rich("instrument", "settlement", 14))
    setl.append(rich("cash_flow", "settlement", 11, ["settlement.trade.trade_id"]))
    setl.append(rich("margin_call", "settlement", 10, ["settlement.position.position_id"]))
    domains.append({"name": "settlement", "products": setl})

    # 5) partially  <-- JUNK SENTINEL DOMAIN (RC3 defect) with live products
    junk = []
    junk.append(rich("orphan_alpha", "partially", 9))
    junk.append(rich("orphan_beta", "partially", 8))
    junk.append(thin("orphan_gamma"))
    junk.append(stub("orphan_delta"))
    junk.append(rich("orphan_epsilon", "partially", 7))
    domains.append({"name": "partially", "products": junk})

    model = {
        "agent_version": "synthetic-v357",
        "business": "synthetic_defect_co",
        "model": {"domains": domains, "metric_views": []},
    }
    return model


def companion_v2_with_drops(v1):
    """A simulated v2 that DROPPED 2 v1 products (preservation-gate negative case)."""
    import copy
    v2 = copy.deepcopy(v1)
    doms = v2["model"]["domains"]
    # drop 'care_plan' (clinical) and 'cash_flow' (settlement)
    for d in doms:
        d["products"] = [p for p in d["products"] if p["name"] not in ("care_plan", "cash_flow")]
    return v2


def next_vibes():
    return (
        "SECTION 3 — PRIORITIZED ACTIONS\n"
        "3c. PRIORITIES\n"
        "- PRIORITY 1 — move_product: aftersales.nameplate — move to merchandising because nameplate is retail master data\n"
        "- PRIORITY 2 — move_product: aftersales.body_style — move to merchandising because body style is product catalog data\n"
        "- PRIORITY 3 — rename_product: aftersales.svc_appt — rename to service_appointment for clarity\n"
        "- PRIORITY 4 — rename_attribute: clinical_care.patient — rename column patient_field_0 to mrn\n"
        "- PRIORITY 5 — remove_fk: clinical_care.claim_clinical — remove FK on column claim_clinical_self_id (self reference)\n"
        "- PRIORITY 6 — connect_table: merchandising.planogram_slot — add column sku_id (BIGINT) with FK to merchandising.sku\n"
        "3a. STUBS\n"
        "- clinical_care.lab_result\n"
        "- aftersales.recall_notice\n"
        "3b. THIN\n"
        "- aftersales.service_part\n"
        "- settlement.fee_schedule\n"
    )


def main():
    v1 = build()
    n_dom = len(v1["model"]["domains"])
    n_prod = sum(len(d["products"]) for d in v1["model"]["domains"])
    assert n_dom == 5, n_dom
    assert n_prod == 50, n_prod
    json.dump(v1, open(os.path.join(HERE, "v357_synthetic_model.json"), "w"), indent=2)
    json.dump(companion_v2_with_drops(v1), open(os.path.join(HERE, "v357_synthetic_v2_dropped.json"), "w"), indent=2)
    open(os.path.join(HERE, "v357_synthetic_next_vibes.txt"), "w").write(next_vibes())
    print(f"wrote synthetic model: {n_dom} domains, {n_prod} products")


if __name__ == "__main__":
    main()
