#!/usr/bin/env python3
"""Generic structural-quality auditor for vibe-modelling model.json artifacts.

INDUSTRY-AGNOSTIC. Nothing hardcoded per industry — every signal is read from
the model.json structure + attribute name tokens. Three modes:

  1. Single model:   vov_structural_audit.py --model path/to/model.json
  2. Improvement gate (VOV MUST IMPROVE): --v1 v1.json --v2 v2.json
        exit 0 only if v2 does NOT regress any structural metric vs v1.
  3. Fork scan:      vov_structural_audit.py --fork /path/to/data-models

Checks (the "empty / thin domains & products pass"):
  - empty domains          : domain with 0 products
  - thin/stub domains      : domain with <5 products
  - empty products         : product with 0 attributes
  - thin/stub products     : product with <5 attributes total
  - skeleton products      : product whose only attributes are PK/FK (0-1 data attrs)
  - wrong attribute types  : high-precision token rules (money/rate/temporal/bool/geo)
  - untagged critical PII   : person/sensitive columns with no sensitivity tag

Exit code: 0 = pass gate, 1 = gate failed (regression or critical findings).
"""
import argparse, json, os, re, sys

STR = {"STRING", "VARCHAR", "CHAR", "TEXT", "NVARCHAR", "CHARACTER"}
INTISH = {"BIGINT", "INT", "INTEGER", "LONG", "SMALLINT", "TINYINT", "SHORT", "BYTE"}

def base_type(t):
    t = (t or "").upper().strip()
    t = re.sub(r"\(.*$", "", t)
    return t.split("<")[0].strip()

def toks(nm):
    return [t for t in re.split(r"[^a-z0-9]+", nm.lower()) if t]

MONEY_NOUN = {"amount", "amt", "cost", "price", "fee", "charge", "total", "subtotal",
              "balance", "premium", "salary", "wage", "revenue", "income", "profit",
              "expense", "fare", "deductible", "copay", "copayment", "refund", "payout"}
MONEY_EXCLUDE = {"points", "point", "loyalty", "reward", "rewards", "findings", "usage",
                 "life", "normal", "count", "leave", "vacation", "pto", "items", "item",
                 "units", "unit", "attempts", "retries", "logins", "visits", "clicks",
                 "views", "calls", "steps", "days", "hours", "minutes", "seconds"}
RATE_NOUN = {"rate", "ratio", "percent", "percentage", "pct"}
TEMPORAL_NOUN = {"date", "datetime", "timestamp", "time", "dt", "ts", "dob"}
GEO_NOUN = {"latitude", "longitude", "lat", "lon", "lng"}
BOOL_FIRST = {"is", "has", "can", "was", "does", "did"}
BOOL_LAST = {"flag", "flg", "bool", "boolean"}
ORG_CTX = {"institution", "bank", "company", "entity", "legal", "corporate", "corp",
           "organization", "organisation", "org", "vendor", "supplier", "merchant",
           "employer", "firm", "agency", "department", "team", "franchise", "brand",
           "product", "file", "system", "event", "table", "field", "role", "type",
           "code", "status", "group", "unit", "branch", "office", "store", "facility"}
PERSON_CTX = {"patient", "customer", "employee", "person", "contact", "beneficiary",
              "member", "applicant", "guardian", "spouse", "dependent", "payee",
              "holder", "donor", "passenger", "guest", "tenant", "owner", "driver",
              "student", "staff", "individual", "subscriber", "policyholder",
              "insured", "claimant", "borrower", "client", "user"}
SENS_TAG = re.compile(r"(sensitiv|\bpii\b|\bphi\b|\bpci\b|confidential|restricted|gdpr|"
                      r"hipaa|classification|personal_data|data_class)", re.I)

def products_of(d):
    return d.get("products") or d.get("data_products") or []

def attr_name(a):
    return (a.get("column_name") or a.get("name") or "").strip()

def is_pk_or_fk(a):
    if a.get("foreign_key_to") or a.get("is_primary_key"):
        return True
    t = a.get("tags")
    return isinstance(t, str) and "primary_key" in t.lower()

def attr_tags(a):
    parts = []
    t = a.get("tags")
    if isinstance(t, str):
        parts.append(t)
    elif isinstance(t, list):
        parts.append(",".join(map(str, t)))
    if isinstance(a.get("tag_set"), list):
        parts.append(json.dumps(a["tag_set"]))
    if a.get("business_glossary_term"):
        parts.append("glossary")
    return " ".join(parts)

def wrong_type_reason(nm, bt, keyish):
    if keyish:
        return None
    tk = toks(nm)
    if not tk:
        return None
    last, s = tk[-1], set(tk)
    if last in MONEY_NOUN and bt in (STR | INTISH) and not (s & MONEY_EXCLUDE):
        return f"money->{bt}(want DECIMAL)"
    if last in RATE_NOUN and bt in STR:
        return f"rate/pct->{bt}(want DECIMAL/DOUBLE)"
    if last in GEO_NOUN and bt in (STR | INTISH):
        return f"geo->{bt}(want DOUBLE)"
    if (last in TEMPORAL_NOUN or re.search(r"_(at|dt|ts|on)$", nm.lower())
            or ("birth" in s and "date" in s)) and bt in STR:
        return f"temporal->{bt}(want DATE/TIMESTAMP)"
    if (tk[0] in BOOL_FIRST or last in BOOL_LAST) and bt in STR:
        return f"bool->{bt}(want BOOLEAN)"
    return None

def _adj(tk, a, bset):
    return any(tk[i] == a and tk[i + 1] in bset for i in range(len(tk) - 1))

def pii_kind(nm):
    tk = toks(nm)
    if not tk:
        return None
    s, last = set(tk), tk[-1]
    ID_NOUN = {"id", "identifier", "identification", "number", "no"}
    if "email" in s and "verified" not in s:
        return "email"
    if "ssn" in s or ("social" in s and "security" in s):
        return "ssn"
    if "passport" in s:
        return "passport"
    if _adj(tk, "national", ID_NOUN) or "nid" in s:
        return "national_id"
    if "taxpayer" in s or "tin" in s or _adj(tk, "tax", {"id", "identifier", "identification"}):
        return "tax_id"
    if (("drivers" in s or "driver" in s) and ("license" in s or "licence" in s)):
        return "drivers_license"
    if (("card" in s and "number" in s) or "cvv" in s or "iban" in s
            or ("routing" in s and "number" in s)):
        return "card/bank"
    if last in ("phone", "mobile", "fax") or ("phone" in s and "number" in s) or "telephone" in s:
        return "phone"
    if not (s & ORG_CTX):
        if "name" in s and ({"first", "last", "middle", "full", "maiden", "given"} & s):
            return "person_name"
        if "surname" in s:
            return "person_name"
        if last == "name" and (set(tk[:-1]) & PERSON_CTX):
            return "person_name"
    if "dob" in s or ("date" in s and "birth" in s) or ("birth" in s and last == "date"):
        return "dob"
    if "address" in s and ({"home", "mailing", "street", "residential", "permanent"} & s):
        return "address"
    if {"gender", "race", "ethnicity", "religion", "biometric"} & s:
        return "special_category"
    if "fingerprint" in s and last in ("fingerprint", "data", "scan", "image", "template"):
        return "special_category"
    if last in ("salary", "compensation", "wage"):
        return "financial_personal"
    if ("medical" in s and "record" in s) or "diagnosis" in s or ("patient" in s and "name" in s):
        return "health"
    return None

def audit_model(mj):
    model = mj.get("model", mj)
    domains = model.get("domains", [])
    r = {"n_domains": len(domains), "n_products": 0, "n_attributes": 0,
         "empty_domains": [], "stub_domains": [], "empty_products": [],
         "stub_products": [], "skeleton_products": [], "wrong_types": [], "untagged_pii": []}
    for d in domains:
        dn = d.get("name", "?")
        prods = products_of(d)
        r["n_products"] += len(prods)
        if len(prods) == 0:
            r["empty_domains"].append(dn)
        elif len(prods) < 5:
            r["stub_domains"].append(f"{dn}({len(prods)})")
        for p in prods:
            pn = p.get("name") or p.get("table_name") or "?"
            attrs = p.get("attributes", []) or []
            r["n_attributes"] += len(attrs)
            data_attrs = [a for a in attrs if not is_pk_or_fk(a)]
            if len(attrs) == 0:
                r["empty_products"].append(f"{dn}.{pn}")
            elif len(attrs) < 5:
                r["stub_products"].append(f"{dn}.{pn}({len(attrs)})")
            if len(attrs) >= 1 and len(data_attrs) <= 1:
                r["skeleton_products"].append(f"{dn}.{pn}(data={len(data_attrs)}/{len(attrs)})")
            for a in attrs:
                nm = attr_name(a)
                if not nm:
                    continue
                bt = base_type(a.get("type"))
                keyish = is_pk_or_fk(a)
                w = wrong_type_reason(nm, bt, keyish)
                if w:
                    r["wrong_types"].append(f"{dn}.{pn}.{nm}:{w}")
                k = pii_kind(nm)
                if k and not SENS_TAG.search(attr_tags(a)):
                    r["untagged_pii"].append(f"{dn}.{pn}.{nm}:{k}")
    return r

def counts(r):
    return {k: len(r[k]) for k in ("empty_domains", "stub_domains", "empty_products",
                                   "stub_products", "skeleton_products", "wrong_types",
                                   "untagged_pii")}

def print_one(tag, r):
    c = counts(r)
    print(f"[{tag}] D={r['n_domains']} P={r['n_products']} A={r['n_attributes']} | "
          + " ".join(f"{k}={v}" for k, v in c.items()))

def load(p):
    return json.load(open(p))

GATE_KEYS = ["empty_domains", "empty_products", "skeleton_products",
             "stub_products", "stub_domains"]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--model")
    ap.add_argument("--v1")
    ap.add_argument("--v2")
    ap.add_argument("--fork")
    ap.add_argument("--json", action="store_true", help="emit machine-readable JSON")
    a = ap.parse_args()

    if a.fork:
        out = {}
        for ind in sorted(os.listdir(a.fork)):
            mp = os.path.join(a.fork, ind, "v1", "ecm", "model.json")
            if os.path.exists(mp):
                try:
                    out[ind] = audit_model(load(mp))
                except Exception as e:
                    out[ind] = {"error": str(e)[:120]}
        if a.json:
            print(json.dumps(out, indent=2))
        else:
            for ind, r in sorted(out.items(), key=lambda kv: -sum(counts(kv[1]).values()) if "error" not in kv[1] else 0):
                if "error" in r:
                    print(f"[{ind}] ERROR {r['error']}")
                else:
                    print_one(ind, r)
        return 0

    if a.v1 and a.v2:
        r1, r2 = audit_model(load(a.v1)), audit_model(load(a.v2))
        c1, c2 = counts(r1), counts(r2)
        print_one("v1", r1)
        print_one("v2", r2)
        regressed = []
        for k in GATE_KEYS:
            if c2[k] > c1[k]:
                regressed.append(f"{k}: v1={c1[k]} -> v2={c2[k]} (+{c2[k]-c1[k]})")
        # model must not get structurally thinner on net
        thinner = r2["n_attributes"] < r1["n_attributes"]
        print("\nIMPROVEMENT GATE (VOV MUST IMPROVE THE MODEL):")
        for k in GATE_KEYS:
            arrow = "REGRESSED" if c2[k] > c1[k] else ("improved" if c2[k] < c1[k] else "same")
            print(f"  {k:<18} v1={c1[k]:<4} v2={c2[k]:<4} {arrow}")
        print(f"  attributes        v1={r1['n_attributes']:<4} v2={r2['n_attributes']:<4} "
              f"{'THINNER' if thinner else 'ok'}")
        if regressed or thinner:
            print("\nGATE: FAIL — v2 regressed vs v1:")
            for x in regressed:
                print("   -", x)
            if thinner:
                print(f"   - attributes dropped {r1['n_attributes']} -> {r2['n_attributes']}")
            return 1
        print("\nGATE: PASS — v2 does not regress any structural metric vs v1.")
        return 0

    if a.model:
        r = audit_model(load(a.model))
        if a.json:
            print(json.dumps(r, indent=2))
            return 0
        print_one("model", r)
        for k in ("empty_domains", "empty_products", "skeleton_products", "stub_products",
                  "stub_domains", "wrong_types", "untagged_pii"):
            if r[k]:
                print(f"\n{k} ({len(r[k])}):")
                for x in r[k]:
                    print("   -", x)
        crit = len(r["empty_domains"]) + len(r["empty_products"]) + len(r["skeleton_products"])
        return 1 if crit else 0

    ap.print_help()
    return 2

if __name__ == "__main__":
    sys.exit(main())
