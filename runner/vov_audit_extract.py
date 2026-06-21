#!/usr/bin/env python3
"""Per-industry VReq audit extractor for the v2 vibe-modeling marathon.

Reads the ECM vov info log for one industry, pulls the final vibe_orchestrator_scored
payload (VReqs extracted / fulfilled / partial / failed + per-VReq evidence), the
SelfFixer application events, and the exported model.json counts, then writes a single
structured JSON audit file per industry to AUDIT_DIR. This is the explicit marathon
deliverable ("file with next vibes, which vreqs extracted/applied/failed, thoughts")
that v3 will consume. Industry-agnostic: everything is read from logs + artifacts.
"""
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import vov_v2_marathon as M  # cat_name / db / OUT_DIR / profiles

AUDIT_DIR = os.path.expanduser("~/claude/vibe-agent/v2_audit")


def fetch_log(profile, ind, scope, ver="v2"):
    # v4.0.7 alias=marathon-harvest-latest-version -- audit the LATEST vov generation, not stale v2
    # (install-once-reuse lands the newest model at v3/v4/...). Version supplied by the caller via
    # M.latest_version so the scored log matches the harvested model.json (no cross-version mismatch).
    cat = M.cat_name(ind)
    src = f"dbfs:/Volumes/{cat}/_metamodel/vol_root/logs/{ind}/{ver}/{scope}/{ind}_info_{ver}_{scope}.log"
    lf = f"/tmp/audit_{ind}_{scope}.log"
    M.db(["fs", "cp", src, lf, "--overwrite"], profile, timeout=300)
    return lf


def last_scored(logfile):
    """Return the final vibe_orchestrator_scored payload dict (most complete VReq view)."""
    last = None
    with open(logfile, errors="ignore") as fh:
        for line in fh:
            if "vibe_orchestrator_scored" not in line:
                continue
            m = re.search(r'(\{.*"event"\s*:\s*"vibe_orchestrator_scored".*\})\s*$', line)
            if not m:
                m = re.search(r'(\{.*vibe_orchestrator_scored.*\})', line)
            if m:
                try:
                    last = json.loads(m.group(1)).get("payload", {})
                except Exception:
                    pass
    return last


def selffixer_events(logfile):
    out = []
    pat = re.compile(r"\[selffixer-applied FIRED[^\]]*\]\s*req=(VREQ-\d+)\s*attempt=(\d+)\s*rationale=(.*)")
    with open(logfile, errors="ignore") as fh:
        for line in fh:
            m = pat.search(line)
            if m:
                out.append({"vreq": m.group(1), "attempt": int(m.group(2)),
                            "rationale": m.group(3).strip()[:300]})
    return out


def counts(model_json):
    try:
        m = json.load(open(model_json))
    except Exception:
        return None
    model = m.get("model", {})
    ds = model.get("domains", [])
    def prods(d):
        return d.get("products") or d.get("data_products", [])
    np_ = sum(len(prods(d)) for d in ds)
    na = sum(len(p.get("attributes", [])) for d in ds for p in prods(d))
    nfk = sum(1 for d in ds for p in prods(d) for a in p.get("attributes", []) if a.get("foreign_key_to"))
    return {"agent_version": m.get("agent_version"), "domains": len(ds), "products": np_,
            "attributes": na, "foreign_keys": nfk, "metric_views": len(model.get("metric_views", []))}


def extract(ind, profile):
    os.makedirs(AUDIT_DIR, exist_ok=True)
    ver = M.latest_version(profile, ind)  # v4.0.7 marathon-harvest-latest-version (DRY: same resolver)
    log = fetch_log(profile, ind, "ecm", ver=ver)
    scored = last_scored(log) or {}
    fixes = selffixer_events(log)
    details = scored.get("unfulfilled_details", [])
    by_status = {}
    for d in details:
        by_status.setdefault(d.get("status", "?"), []).append(
            {"id": d.get("id"), "text": d.get("text", "")[:240], "evidence": d.get("evidence", "")[:300]})
    # verifier-false-negative heuristic: failed but evidence says snapshot truncated / not visible
    fn_markers = ("not visible", "truncated", "only show", "do not include", "snapshots show only",
                  "not appear in", "no evidence in the model state snapshot")
    likely_false_neg = [d["id"] for d in details
                        if d.get("status") == "failed"
                        and any(k in d.get("evidence", "").lower() for k in fn_markers)]
    ecm_counts = counts(f"{M.OUT_DIR}/{ind}/{ver}/ecm/model.json")
    mvm_counts = counts(f"{M.OUT_DIR}/{ind}/{ver}/mvm/model.json")
    audit = {
        "industry": ind,
        "profile": profile,
        "scope": "ecm->mvm",
        "scoreboard": {k: scored.get(k) for k in (
            "total_requirements", "fulfilled", "partial", "failed", "informational",
            "precision", "recall", "coverage", "hard_constraint_compliance",
            "false_fulfilled", "scope_leakage_rate")},
        "selffixer_applied": fixes,
        "unfulfilled_by_status": by_status,
        "likely_verifier_false_negatives": likely_false_neg,
        "v3_notes": [
            "Verifier snapshot is truncated for large (>300 product) ECMs -> failed VReqs whose "
            "evidence says 'not visible/truncated' are LYING-SCOREBOARD false-negatives, not real misses.",
            "Product-move VReqs scored 'partial' (intent unconfirmable from counts) -> verifier needs "
            "domain-membership delta, not just domain/table/attr totals.",
            "Measure-level VReqs (e.g. RevPAR mislabel) unverifiable because snapshot lacks measure-level "
            "detail -> v3 must ground measure VReqs against the physical _metrics views.",
        ],
        "model_counts": {"ecm": ecm_counts, "mvm": mvm_counts},
    }
    out = os.path.join(AUDIT_DIR, f"{ind}.json")
    json.dump(audit, open(out, "w"), indent=2)
    sb = audit["scoreboard"]
    print(f"[{ind}] audit -> {out}")
    print(f"  VReqs total={sb.get('total_requirements')} fulfilled={sb.get('fulfilled')} "
          f"partial={sb.get('partial')} failed={sb.get('failed')} "
          f"precision={sb.get('precision')} recall={sb.get('recall')}")
    print(f"  selffixer_applied={len(fixes)} likely_false_negatives={len(likely_false_neg)} "
          f"({','.join(likely_false_neg)})")
    print(f"  ecm={ecm_counts}")
    print(f"  mvm={mvm_counts}")
    return audit


if __name__ == "__main__":
    extract(sys.argv[1], sys.argv[2])
