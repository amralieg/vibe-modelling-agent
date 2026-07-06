#!/usr/bin/env python3
"""Render the ground-truth audit JSONs into a per-VReq miss report + improvement aggregate."""
import json
import os
import glob

GT = os.path.expanduser("~/claude/vibe-agent/v2_groundtruth")


def main():
    files = sorted(glob.glob(os.path.join(GT, "*.json")))
    files = [f for f in files if not f.endswith("_aggregate.json")]
    src_tot, src_ful, src_part, src_miss = {}, {}, {}, {}
    act_miss = {}
    imp_tot = imp_ful = 0
    sec1_drop = []
    misses = []  # improvement misses (partial+missed, excl SEC1 fulfilled)
    per_ind = []
    for f in files:
        a = json.load(open(f))
        ind = a["industry"]
        ift, iff = a["improvement_total"], a["improvement_fulfilled"]
        imp_tot += ift; imp_ful += iff
        per_ind.append((ind, ift, iff, a["improvement_adherence"], a["total_vreqs"], a["adherence_all"]))
        for r in a["results"]:
            s = r["source"]; st = r["status"]
            src_tot[s] = src_tot.get(s, 0) + 1
            if st == "fulfilled":
                src_ful[s] = src_ful.get(s, 0) + 1
            elif st == "partial":
                src_part[s] = src_part.get(s, 0) + 1
            else:
                src_miss[s] = src_miss.get(s, 0) + 1
            if s == "SEC1" and st != "fulfilled":
                sec1_drop.append((ind, r["target"], r["reason"]))
            if s != "SEC1" and st != "fulfilled":
                key = f"{r['source']}/{r['action']}"
                act_miss[key] = act_miss.get(key, 0) + 1
                misses.append({"ind": ind, "id": r["id"], "source": r["source"],
                               "action": r["action"],
                               "target": r.get("target") or f"{r.get('domain','')}.{r.get('product','')}".strip("."),
                               "entity": r.get("entity"), "status": st, "reason": r["reason"],
                               "raw": r.get("raw", "")[:140]})
    print("=== IMPROVEMENT ADHERENCE (excl SEC1 preservation) ===")
    print(f"{'industry':<20}{'impr_ful':>9}{'impr_tot':>9}{'impr%':>8}{'  ALL%':>8}")
    for ind, ift, iff, ia, tt, aa in per_ind:
        print(f"{ind:<20}{iff:>9}{ift:>9}{ia:>8}{aa:>8}")
    print(f"{'AGGREGATE':<20}{imp_ful:>9}{imp_tot:>9}{round(100.0*imp_ful/imp_tot,1):>8}")
    print("\n=== BY SOURCE (fulfilled / partial / missed / total) ===")
    for s in sorted(src_tot):
        print(f"  {s:<8} {src_ful.get(s,0):>5} / {src_part.get(s,0):>4} / {src_miss.get(s,0):>4} / {src_tot[s]:>5}")
    print("\n=== MISS COUNT BY action ===")
    for k, n in sorted(act_miss.items(), key=lambda x: -x[1]):
        print(f"  {k:<28} {n}")
    print(f"\n=== SEC1 PRESERVATION DROPS (regressions): {len(sec1_drop)} ===")
    for ind, t, why in sec1_drop:
        print(f"  [{ind}] {t}: {why}")
    print(f"\n=== ALL IMPROVEMENT MISSES (partial+missed): {len(misses)} ===")
    cur = None
    for m in sorted(misses, key=lambda x: (x["ind"], x["source"], x["id"])):
        if m["ind"] != cur:
            cur = m["ind"]; print(f"\n--- {cur} ---")
        tgt = m["entity"] or m["target"]
        print(f"  [{m['status']:<8}] {m['id']:<10} {m['action']:<16} {tgt:<40} | {m['reason']}")
    json.dump({"improvement": {"fulfilled": imp_ful, "total": imp_tot,
               "adherence": round(100.0*imp_ful/imp_tot,1)},
               "by_source": {s: {"ful": src_ful.get(s,0), "partial": src_part.get(s,0),
                                 "missed": src_miss.get(s,0), "total": src_tot[s]} for s in src_tot},
               "miss_by_action": act_miss, "sec1_drops": sec1_drop, "misses": misses},
              open(os.path.join(GT, "_report.json"), "w"), indent=2)


if __name__ == "__main__":
    main()
