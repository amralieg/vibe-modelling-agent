#!/usr/bin/env python3
"""
sync_to_repo: post-sector hook for orchestrate_sectors.py.

Mirrors completed-industry artifacts from the Databricks workspace folder
`/Users/<user>@databricks.com/vibe_runner_models/<industry>/` into a local
git working copy of `amralieg/vibe-business-data-models`, then commits and
pushes one commit per industry.

Industries already present in the local repo are skipped (idempotent).

The hook is intentionally tolerant: any failure surfaces as a log line and
returns a structured result dict. It NEVER raises, so the orchestrator's
sector loop is never blocked by a repo-sync error.
"""

import json
import os
import subprocess
from pathlib import Path
from typing import Callable, Dict, List, Optional


DEFAULT_WORKSPACE_ROOT = "/Users/amr.ali@databricks.com/vibe_runner_models"
DEFAULT_REPO_PATH = os.path.expanduser("~/Documents/projects/vibe-business-data-models")
DEFAULT_REPO_REMOTE = "https://github.com/amralieg/vibe-business-data-models.git"
DEFAULT_REPO_BRANCH = "main"
GIT_OP_TIMEOUT_S = 600
EXPORT_TIMEOUT_S = 600
WS_LIST_TIMEOUT_S = 60


def _run(cmd: List[str], timeout: int = GIT_OP_TIMEOUT_S, cwd: Optional[str] = None) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, capture_output=True, text=True, timeout=timeout, cwd=cwd)


def _ensure_repo_clone(repo_path: str, repo_remote: str, branch: str, log: Callable[[str], None]) -> bool:
    if os.path.isdir(os.path.join(repo_path, ".git")):
        return True
    Path(os.path.dirname(repo_path)).mkdir(parents=True, exist_ok=True)
    log(f"  [repo-sync] cloning {repo_remote} -> {repo_path}")
    p = _run(["git", "clone", "--branch", branch, repo_remote, repo_path], timeout=GIT_OP_TIMEOUT_S)
    if p.returncode != 0:
        log(f"  [repo-sync] clone failed: {p.stderr[:300]}")
        return False
    return True


def _list_workspace_industries(workspace_root: str, profile: str, log: Callable[[str], None]) -> List[str]:
    p = _run(
        ["databricks", "workspace", "list", workspace_root, "--profile", profile, "-o", "json"],
        timeout=WS_LIST_TIMEOUT_S,
    )
    if p.returncode != 0:
        log(f"  [repo-sync] workspace list failed: {p.stderr[:300]}")
        return []
    try:
        items = json.loads(p.stdout) if p.stdout.strip() else []
        if isinstance(items, dict):
            items = items.get("objects") or items.get("items") or []
    except Exception as e:
        log(f"  [repo-sync] could not parse workspace list JSON: {str(e)[:200]}")
        return []
    industries: List[str] = []
    for it in items:
        if it.get("object_type") != "DIRECTORY":
            continue
        path = it.get("path") or ""
        ind = path.rstrip("/").split("/")[-1]
        if ind:
            industries.append(ind)
    return industries


def _extract_counts(model_json_path: str) -> str:
    try:
        with open(model_json_path) as f:
            m = json.load(f)
        model = m.get("model") or m
        domains = model.get("domains", []) or []
        n_d = len(domains)
        n_p = sum(len(d.get("products") or d.get("data_products") or []) for d in domains)
        n_a = sum(
            len(p.get("attributes", []) or [])
            for d in domains
            for p in (d.get("products") or d.get("data_products") or [])
        )
        n_mv = len(model.get("metric_views", []) or [])
        return f"{n_d}d/{n_p}p/{n_a}a/{n_mv}mv"
    except Exception:
        return "?"


def _quality_score(vibes_path: str) -> Optional[str]:
    try:
        txt = open(vibes_path, errors="ignore").read()
    except Exception:
        return None
    import re
    m = re.search(r"Model Quality Score:\s*\**\s*([\d.]+)\s*/\s*100", txt)
    return m.group(1) if m else None


def _export_industry(workspace_root: str, industry: str, dest_path: str,
                     profile: str, log: Callable[[str], None]) -> bool:
    src = f"{workspace_root}/{industry}"
    log(f"  [repo-sync FIRED] exporting {industry} from workspace -> {dest_path}")
    p = _run(
        ["databricks", "workspace", "export-dir", src, dest_path, "--profile", profile],
        timeout=EXPORT_TIMEOUT_S,
    )
    if p.returncode != 0:
        log(f"  [repo-sync] export-dir failed for {industry}: {p.stderr[:300]}")
        return False
    return True


def _commit_and_push(repo_path: str, industry: str, branch: str,
                     log: Callable[[str], None]) -> bool:
    pretty = industry.replace("_", " ").title()
    ecm_counts = _extract_counts(os.path.join(repo_path, industry, "ecm_v1", "model.json"))
    mvm_counts = _extract_counts(os.path.join(repo_path, industry, "mvm_v1", "model.json"))
    ecm_score = _quality_score(os.path.join(repo_path, industry, "ecm_v1", "vibes", "next_vibes.txt"))
    mvm_score = _quality_score(os.path.join(repo_path, industry, "mvm_v1", "vibes", "next_vibes.txt"))
    score_line = ""
    if ecm_score or mvm_score:
        parts = []
        if ecm_score:
            parts.append(f"ECM: {ecm_score}/100")
        if mvm_score:
            parts.append(f"MVM: {mvm_score}/100")
        score_line = "\n\nModel quality score (next_vibes):\n  - " + "\n  - ".join(parts)

    msg = (
        f"Add {pretty} (ECM {ecm_counts}, MVM {mvm_counts})\n\n"
        f"Generated by vibe-modelling-agent (auto-pushed by orchestrator hook)."
        f"{score_line}\n\n"
        f"Co-authored-by: Isaac <isaac@databricks.com>"
    )

    add = _run(["git", "-C", repo_path, "add", industry])
    if add.returncode != 0:
        log(f"  [repo-sync] git add failed for {industry}: {add.stderr[:200]}")
        return False
    has_changes = _run(["git", "-C", repo_path, "diff", "--cached", "--quiet"])
    if has_changes.returncode == 0:
        log(f"  [repo-sync] no staged changes for {industry} — already up to date")
        return True
    commit = _run(["git", "-C", repo_path, "commit", "-m", msg])
    if commit.returncode != 0:
        log(f"  [repo-sync] git commit failed for {industry}: {commit.stderr[:300]}")
        return False
    push = _run(["git", "-C", repo_path, "push", "origin", branch], timeout=GIT_OP_TIMEOUT_S)
    if push.returncode != 0:
        log(f"  [repo-sync] git push failed for {industry}: {push.stderr[:300]}")
        return False
    log(f"  [repo-sync FIRED] pushed {industry} to origin/{branch}")
    return True


def sync_completed_industries(
    repo_path: str = DEFAULT_REPO_PATH,
    workspace_root: str = DEFAULT_WORKSPACE_ROOT,
    profile: str = "emirates-gcp",
    repo_remote: str = DEFAULT_REPO_REMOTE,
    branch: str = DEFAULT_REPO_BRANCH,
    log: Optional[Callable[[str], None]] = None,
    industry_allowlist: Optional[List[str]] = None,
) -> Dict[str, object]:
    """
    Sync any workspace industry not yet present in the local repo, commit+push each.
    """
    if log is None:
        log = print
    result = {"synced": [], "skipped_existing": [], "failed": [], "error": None}

    if not _ensure_repo_clone(repo_path, repo_remote, branch, log):
        result["error"] = "clone_failed"
        return result

    industries = _list_workspace_industries(workspace_root, profile, log)
    if industry_allowlist:
        allow = set(industry_allowlist)
        industries = [i for i in industries if i in allow]
    if not industries:
        log(f"  [repo-sync] no industries found under {workspace_root}")
        return result

    for ind in industries:
        local = os.path.join(repo_path, ind)
        if os.path.isdir(local) and os.listdir(local):
            result["skipped_existing"].append(ind)
            continue
        ok = _export_industry(workspace_root, ind, local, profile, log)
        if not ok:
            result["failed"].append(ind)
            continue
        ok = _commit_and_push(repo_path, ind, branch, log)
        if ok:
            result["synced"].append(ind)
        else:
            result["failed"].append(ind)
    return result


if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", default=DEFAULT_REPO_PATH)
    ap.add_argument("--workspace-root", default=DEFAULT_WORKSPACE_ROOT)
    ap.add_argument("--profile", default="emirates-gcp")
    ap.add_argument("--branch", default=DEFAULT_REPO_BRANCH)
    ap.add_argument("--industry", action="append", default=None,
                    help="Optional allowlist (repeat flag); default = sync all new")
    args = ap.parse_args()
    out = sync_completed_industries(
        repo_path=args.repo,
        workspace_root=args.workspace_root,
        profile=args.profile,
        branch=args.branch,
        industry_allowlist=args.industry,
    )
    print(json.dumps(out, indent=2))
