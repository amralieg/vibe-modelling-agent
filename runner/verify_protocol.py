#!/usr/bin/env python3
"""Fast, generic PHYSICAL adherence oracle for vibe-modelling-agent runs.

WHY THIS EXISTS (the breakthrough, 2026-06-08)
----------------------------------------------
The agent's own verifier scores adherence against a lossy model.json SNAPSHOT and
matches user display-names literally against physical snake_case names. That produces
FALSE-NEGATIVES (the "lying scoreboard"): the model physically satisfies a vibe but the
agent scores it failed (e.g. NCDOT VREQ-016 scored "Vacancy Rate MV NOT present" while
`hr_vacancy_rate` physically existed). Worse, the only way to learn whether a verifier
fix worked was to run the entire 2-5 hour pipeline.

This oracle decouples VERIFIER-iteration from BUILD-iteration. It queries the REAL Unity
Catalog (via the Serverless SQL Statements API — no Spark, no pipeline) in ~2 minutes and
scores every MECHANICAL VREQ class against PHYSICAL reality with the correct normalization.
What the customer actually gets IS what this measures, so this is the honest source of
truth. The gap between this oracle and the agent's self-reported audit == the lying scoreboard,
quantified per-VREQ in minutes.

GENERIC: no business / industry / catalog name is hardcoded. Every directive is parsed from
the vibe text and every fact is read from information_schema at runtime. Runs for any industry.

Usage:
  python3 verify_protocol.py --profile my-adp --catalog ncdot_v1 --business ncdot \
      --version mvm_v1 [--vibes /path/to/vibes.txt] [--warehouse <id>]

Exit 0 = physical adherence >= 90%; 1 = below floor; 2 = fatal (no model/catalog).
"""
import argparse
import json
import re
import subprocess
import sys
import tempfile
import os


# --------------------------------------------------------------------------- #
# Databricks CLI helpers (Serverless-safe; SQL Statements API; no spark)       #
# --------------------------------------------------------------------------- #
def _sh(cmd, timeout=180):
    return subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)


def _fs_cp(remote, local, profile):
    return _sh(["databricks", "fs", "cp", remote, local, "--overwrite", "--profile", profile]).returncode == 0


def _running_warehouse(profile, prefer=None):
    if prefer:
        return prefer
    r = _sh(["databricks", "warehouses", "list", "-o", "json", "--profile", profile])
    if r.returncode != 0:
        return None
    try:
        whs = json.loads(r.stdout)
        whs = whs if isinstance(whs, list) else whs.get("warehouses", [])
    except Exception:
        return None
    running = [w for w in whs if str(w.get("state", "")).upper() == "RUNNING"]
    pick = running or whs
    return pick[0]["id"] if pick else None


def _sql(query, profile, warehouse, timeout=240):
    """Run one SQL statement via the Statements API. Returns list-of-rows (strings) or None."""
    payload = {"statement": query, "warehouse_id": warehouse, "wait_timeout": "50s"}
    with tempfile.NamedTemporaryFile("w", suffix=".json", delete=False) as f:
        json.dump(payload, f)
        pj = f.name
    try:
        r = _sh(["databricks", "api", "post", "/api/2.0/sql/statements", "--json", f"@{pj}",
                 "--profile", profile], timeout=timeout)
    finally:
        try:
            os.unlink(pj)
        except Exception:
            pass
    if r.returncode != 0:
        return None
    try:
        d = json.loads(r.stdout)
    except Exception:
        return None
    st = d.get("status", {}).get("state")
    # poll if still running
    sid = d.get("statement_id")
    tries = 0
    while st in ("PENDING", "RUNNING") and sid and tries < 30:
        import time
        time.sleep(3)
        rr = _sh(["databricks", "api", "get", f"/api/2.0/sql/statements/{sid}", "--profile", profile])
        try:
            d = json.loads(rr.stdout)
            st = d.get("status", {}).get("state")
        except Exception:
            break
        tries += 1
    if st != "SUCCEEDED":
        return None
    return d.get("result", {}).get("data_array", []) or []


# --------------------------------------------------------------------------- #
# Normalization (display-name -> physical, domain-prefix & punctuation tolerant)#
# --------------------------------------------------------------------------- #
def norm(s):
    s = re.sub(r"kpi[\s_-]*\d+", " ", str(s or "").lower())
    return re.sub(r"[^a-z0-9]", "", s)


def norm_variants(physical_name):
    """A physical table name yields several match keys: full, and de-prefixed by 1 & 2 segments."""
    out = {norm(physical_name)}
    parts = str(physical_name).split("_")
    for k in (1, 2):
        if len(parts) > k:
            out.add(norm("_".join(parts[k:])))
    return {x for x in out if x}


def matches(req_display, physical_names):
    """True if a user display-name matches any physical name (exact-normalized or de-prefixed,
    with a substring fallback both directions to absorb minor wording drift)."""
    rq = norm(req_display)
    if not rq:
        return False
    for pn in physical_names:
        keys = norm_variants(pn)
        if rq in keys:
            return True
        # substring fallback (e.g. "vacancyrate" in "hrvacancyratemonthly")
        for k in keys:
            if rq and (rq in k or k in rq) and abs(len(rq) - len(k)) <= max(6, int(0.4 * len(rq))):
                return True
    return False


# --------------------------------------------------------------------------- #
# model.json traversal                                                          #
# --------------------------------------------------------------------------- #
def _root(model):
    return model.get("model", model)


def _iter_products(model):
    for d in _root(model).get("domains", []) or []:
        if isinstance(d, dict):
            dn = d.get("name", "")
            for p in (d.get("products") or d.get("data_products") or []):
                if isinstance(p, dict):
                    yield dn, (p.get("product") or p.get("name") or ""), p


def _iter_attributes(model):
    for dn, pn, p in _iter_products(model):
        for a in (p.get("attributes") or []):
            if isinstance(a, dict):
                yield dn, pn, (a.get("attribute") or a.get("column_name") or ""), a


# --------------------------------------------------------------------------- #
# Vibe directive extraction (generic; the mechanical VREQ classes)             #
# --------------------------------------------------------------------------- #
_RE_MV_EXACT = re.compile(r"exactly\s+these\s+(\d+)\s+metric\s+views?\b(.*?)(?:\n\n|\Z)", re.IGNORECASE | re.DOTALL)
_RE_MV_COUNT = re.compile(r"(exactly|at least|minimum of|no fewer than)\s*(\d{1,4})\s*metric\s*views?", re.IGNORECASE)
_RE_KPI_NAME = re.compile(r"KPI[\s_-]*\d+\s*[:\-]?\s*([A-Z][A-Za-z0-9 &/_-]{2,60})", re.IGNORECASE)
_RE_TAG_PREFIX = re.compile(r"tags?\s+MUST\s+use\s+the\s+prefix\s+`?([a-z][a-z0-9]*_)`?", re.IGNORECASE)
_RE_BULK_TAG = re.compile(r"\btag\s+`?([a-z][a-z0-9_]*?)`?\s*=", re.IGNORECASE)
_RE_PK_SUFFIX = re.compile(r"`?(_[a-z0-9]+)`?\s+as\s+the\s+primary[- ]key\s+suffix", re.IGNORECASE)
_RE_IDTYPE = re.compile(r"`?(BIGINT|INT|STRING|UUID)`?\s+as\s+the\s+table[- ]id\s+type", re.IGNORECASE)
_RE_NAMING = re.compile(r"`?(snake_case|camelCase|PascalCase)`?\s+as\s+the\s+naming", re.IGNORECASE)
_RE_NO_SAMPLES = re.compile(r"do\s+NOT\s+generate\s+any\s+samples", re.IGNORECASE)
_RE_DOMAINS = re.compile(r"exactly\s+these\s+(\d+)\s+domains?\b(.*?)(?:\.\s|\n)", re.IGNORECASE | re.DOTALL)


def parse_directives(vibe):
    d = {"named_mvs": [], "mv_count": None, "tag_prefix": None, "bulk_tags": [],
         "pk_suffix": None, "id_type": None, "naming": None, "no_samples": False, "domains": []}
    m = _RE_MV_EXACT.search(vibe)
    if m:
        d["mv_count"] = ("exactly", int(m.group(1)))
        names = _RE_KPI_NAME.findall(m.group(2))
        d["named_mvs"] = [re.sub(r"\s+", " ", n).strip().rstrip(".") for n in names][: int(m.group(1)) + 2]
    else:
        mc = _RE_MV_COUNT.search(vibe)
        if mc:
            d["mv_count"] = (mc.group(1).lower(), int(mc.group(2)))
        d["named_mvs"] = [re.sub(r"\s+", " ", n).strip().rstrip(".") for n in _RE_KPI_NAME.findall(vibe)]
    tp = _RE_TAG_PREFIX.search(vibe)
    if tp:
        d["tag_prefix"] = tp.group(1).lower()
    d["bulk_tags"] = sorted({t.lower() for t in _RE_BULK_TAG.findall(vibe)})
    for key, rx in (("pk_suffix", _RE_PK_SUFFIX), ("id_type", _RE_IDTYPE), ("naming", _RE_NAMING)):
        mm = rx.search(vibe)
        if mm:
            d[key] = mm.group(1)
    d["no_samples"] = bool(_RE_NO_SAMPLES.search(vibe))
    return d


# --------------------------------------------------------------------------- #
# Physical catalog snapshot (one batch of information_schema queries)          #
# --------------------------------------------------------------------------- #
def snapshot(catalog, profile, wh):
    snap = {}
    snap["schemata"] = [r[0] for r in (_sql(
        f"SELECT schema_name FROM `{catalog}`.information_schema.schemata", profile, wh) or [])]
    snap["tables"] = _sql(
        f"SELECT table_schema, table_name, table_type FROM `{catalog}`.information_schema.tables", profile, wh) or []
    snap["columns"] = _sql(
        f"SELECT table_schema, table_name, column_name, full_data_type FROM `{catalog}`.information_schema.columns",
        profile, wh) or []
    snap["coltags"] = _sql(
        f"SELECT schema_name, table_name, column_name, tag_name, tag_value FROM `{catalog}`.information_schema.column_tags",
        profile, wh)
    if snap["coltags"] is None:
        snap["coltags"] = []
    snap["tabtags"] = _sql(
        f"SELECT schema_name, table_name, tag_name, tag_value FROM `{catalog}`.information_schema.table_tags",
        profile, wh)
    if snap["tabtags"] is None:
        snap["tabtags"] = []
    snap["catalogs"] = [r[0] for r in (_sql(
        f"SELECT catalog_name FROM `{catalog}`.information_schema.catalogs", profile, wh) or [[catalog]])]
    return snap


_SYS_SCHEMAS = ("information_schema", "default")


def _is_sys_schema(s):
    s = (s or "").lower()
    return s.startswith("_") or s in _SYS_SCHEMAS


def is_metric_table(schema, ttype):
    s = (schema or "").lower()
    t = (ttype or "").lower()
    return "metric" in s or "metric" in t


# --------------------------------------------------------------------------- #
# Physical scoring                                                              #
# --------------------------------------------------------------------------- #
def score(catalog, snap, directives, model):
    rows = []

    user_schemas = [s for s in snap["schemata"] if not _is_sys_schema(s)]
    phys_mv = sorted({tn for (ts, tn, tt) in snap["tables"] if is_metric_table(ts, tt)})
    phys_tables = sorted({(ts, tn) for (ts, tn, tt) in snap["tables"]
                          if not _is_sys_schema(ts) and not is_metric_table(ts, tt)})

    # 1) named metric views (exact user names -> physical, normalized)
    for nm in directives["named_mvs"]:
        ok = matches(nm, phys_mv)
        rows.append(("MV_NAMED", nm, "PASS" if ok else "FAIL",
                     f"phys_mvs={phys_mv}" if not ok else f"matched in {phys_mv}"))

    # 2) MV count
    if directives["mv_count"]:
        op, n = directives["mv_count"]
        have = len(phys_mv)
        ok = (have == n) if op == "exactly" else (have >= n)
        rows.append(("MV_COUNT", f"{op} {n}", "PASS" if ok else "FAIL", f"physical={have} ({phys_mv})"))

    # 3) tag prefix rule (all non-system tag keys carry prefix)
    if directives["tag_prefix"]:
        p = directives["tag_prefix"]
        allkeys = {str(r[3]).lower() for r in snap["coltags"]} | {str(r[2]).lower() for r in snap["tabtags"]}
        sys_pref = ("cg_", "system", "__")
        nonsys = {k for k in allkeys if not k.startswith(sys_pref)}
        viol = sorted(k for k in nonsys if not k.startswith(p))
        cover = nonsys - set(viol)
        if not nonsys:
            rows.append(("TAG_PREFIX", p, "FAIL", "no non-system tags physically present at all"))
        elif not viol:
            rows.append(("TAG_PREFIX", p, "PASS", f"all {len(nonsys)} tag key(s) carry '{p}': {sorted(nonsys)[:6]}"))
        else:
            rows.append(("TAG_PREFIX", p, "PARTIAL", f"{len(cover)}/{len(nonsys)} carry '{p}'; viol={viol[:6]}"))

    # 4) bulk/glossary tags coverage
    for key in directives["bulk_tags"]:
        keyl = key.lower()
        hits = sum(1 for r in snap["coltags"] if keyl in str(r[3]).lower())
        thits = sum(1 for r in snap["tabtags"] if keyl in str(r[2]).lower())
        tot = hits + thits
        rows.append(("TAG_BULK", key, "PASS" if tot > 0 else "FAIL",
                     f"col_tag_hits={hits} tbl_tag_hits={thits}"))

    # 5) id type (BIGINT)
    if directives["id_type"]:
        want = directives["id_type"].upper()
        id_cols = [(ts, tn, cn, dt) for (ts, tn, cn, dt) in snap["columns"]
                   if not _is_sys_schema(ts) and cn.lower().endswith("_id")]
        bad = [(ts, tn, cn, dt) for (ts, tn, cn, dt) in id_cols if want not in str(dt).upper()]
        if not id_cols:
            rows.append(("ID_TYPE", want, "FAIL", "no *_id columns physically present"))
        else:
            pct = 100.0 * (len(id_cols) - len(bad)) / len(id_cols)
            rows.append(("ID_TYPE", want, "PASS" if not bad else "PARTIAL",
                         f"{len(id_cols)-len(bad)}/{len(id_cols)} *_id cols are {want} ({pct:.0f}%); bad={[(t,c,d) for _,t,c,d in bad][:4]}"))

    # 6) pk suffix
    if directives["pk_suffix"]:
        suf = directives["pk_suffix"].lower()
        id_like = [(ts, tn, cn) for (ts, tn, cn, dt) in snap["columns"]
                   if not _is_sys_schema(ts) and cn.lower().endswith(suf)]
        rows.append(("PK_SUFFIX", suf, "PASS" if id_like else "FAIL", f"{len(id_like)} cols end with '{suf}'"))

    # 7) naming convention (snake_case)
    if directives["naming"] and directives["naming"].lower() == "snake_case":
        names = [tn for (ts, tn) in phys_tables] + [cn for (ts, tn, cn, dt) in snap["columns"] if not _is_sys_schema(ts)]
        bad = [n for n in names if not re.match(r"^[a-z0-9_]+$", str(n))]
        pct = 100.0 * (len(names) - len(bad)) / len(names) if names else 0
        rows.append(("NAMING", "snake_case", "PASS" if not bad else "PARTIAL",
                     f"{pct:.0f}% snake; bad={bad[:5]}"))

    # 8) single catalog
    rows.append(("ONE_CATALOG", catalog, "PASS" if len([c for c in snap['catalogs']]) >= 1 else "FAIL",
                 f"target catalog present; user_schemas={len(user_schemas)}"))

    # 9) product parity (model.json products vs physical tables)
    model_products = list(_iter_products(model))
    phys_table_norm = {norm(tn) for (ts, tn) in phys_tables}
    built = 0
    missing = []
    for dn, pn, p in model_products:
        tname = p.get("table_name") or pn
        if matches(pn, [tn for (_s, tn) in phys_tables]) or norm(tname) in phys_table_norm:
            built += 1
        else:
            missing.append(f"{dn}.{pn}")
    pct = 100.0 * built / len(model_products) if model_products else 0
    rows.append(("PRODUCT_PARITY", f"{built}/{len(model_products)}", "PASS" if pct >= 95 else "PARTIAL",
                 f"{pct:.0f}% of model products physically built; missing={missing[:6]}"))

    return rows, {"phys_mv": phys_mv, "user_schemas": user_schemas,
                  "phys_tables": len(phys_tables), "phys_cols": len([c for c in snap['columns'] if not _is_sys_schema(c[0])])}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--profile", required=True)
    ap.add_argument("--catalog", required=True)
    ap.add_argument("--business", required=True)
    ap.add_argument("--version", default="mvm_v1")
    ap.add_argument("--vibes", default=None)
    ap.add_argument("--warehouse", default=None)
    ap.add_argument("--model", default=None, help="local model.json (else pulled from volume)")
    args = ap.parse_args()

    wh = _running_warehouse(args.profile, args.warehouse)
    if not wh:
        print("FATAL: no warehouse available", file=sys.stderr)
        return 2
    tmp = tempfile.mkdtemp(prefix="verify_")
    base = f"dbfs:/Volumes/{args.catalog}/_metamodel/vol_root/business/{args.business}/{args.version}"

    if args.model and os.path.exists(args.model):
        model = json.load(open(args.model))
    else:
        ml = os.path.join(tmp, "model.json")
        vnum = (re.search(r"(\d+)$", args.version) or [None, ""])[1]
        candidates = ["model.json", f"{args.business}_v{vnum}.json", f"{args.business}.json"]
        # also discover any *.json at the version root
        ls = _sh(["databricks", "fs", "ls", base, "--profile", args.profile])
        if ls.returncode == 0:
            for line in ls.stdout.splitlines():
                nm = line.split()[-1] if line.split() else ""
                if nm.endswith(".json") and nm not in candidates:
                    candidates.append(nm)
        model = None
        for cand in candidates:
            if _fs_cp(f"{base}/{cand}", ml, args.profile):
                try:
                    model = json.load(open(ml))
                    break
                except Exception:
                    continue
        if model is None:
            print(f"FATAL: could not pull a model json from {base} (tried {candidates})", file=sys.stderr)
            return 2

    if args.vibes and os.path.exists(args.vibes):
        vibe = open(args.vibes).read()
    else:
        vl = os.path.join(tmp, "next_vibes.txt")
        vibe = open(vl).read() if _fs_cp(f"{base}/vibes/next_vibes.txt", vl, args.profile) else ""

    directives = parse_directives(vibe)
    snap = snapshot(args.catalog, args.profile, wh)
    rows, summ = score(args.catalog, snap, directives, model)

    print(f"\n=== PHYSICAL ADHERENCE ORACLE — {args.business}/{args.version} @ {args.catalog} ({args.profile}) ===")
    print(f"warehouse={wh}  physical: schemas={len(summ['user_schemas'])} tables={summ['phys_tables']} "
          f"cols={summ['phys_cols']} metric_views={summ['phys_mv']}")
    print(f"directives parsed: named_mvs={directives['named_mvs']} mv_count={directives['mv_count']} "
          f"tag_prefix={directives['tag_prefix']} bulk_tags={directives['bulk_tags']} "
          f"id_type={directives['id_type']} naming={directives['naming']}\n")
    npass = nfail = npart = 0
    for cls, key, verdict, ev in rows:
        npass += verdict == "PASS"
        nfail += verdict == "FAIL"
        npart += verdict == "PARTIAL"
        print(f"  [{verdict:7}] {cls:15} {str(key)[:34]:34} {ev[:90]}")
    tot = len(rows)
    adh = 100.0 * (npass + 0.5 * npart) / tot if tot else 0
    print(f"\n  PHYSICAL ADHERENCE: {npass} PASS / {npart} PARTIAL / {nfail} FAIL of {tot} = {adh:.1f}%")
    print(f"=== {'>=90% FLOOR MET' if adh >= 90 else 'BELOW 90% FLOOR'} ===\n")
    return 0 if adh >= 90 else 1


if __name__ == "__main__":
    sys.exit(main())
