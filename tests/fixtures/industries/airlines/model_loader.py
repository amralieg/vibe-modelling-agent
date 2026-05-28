"""Load airline (or other) model.json from vibe-business-data-models checkout."""
from __future__ import annotations

import json
import os
from pathlib import Path
from typing import Any

_REPO_ENV = "VIBE_BUSINESS_MODELS_REPO"
_DEFAULT_CLONE = Path("/tmp/vibe-business-data-models")


def resolve_models_repo() -> Path:
    env = os.environ.get(_REPO_ENV, "").strip()
    if env:
        p = Path(env)
        if p.is_dir():
            return p
    if _DEFAULT_CLONE.is_dir():
        return _DEFAULT_CLONE
    raise FileNotFoundError(
        f"Set {_REPO_ENV} to a vibe-business-data-models clone "
        f"(or clone to {_DEFAULT_CLONE})"
    )


def load_industry_model(
    industry: str = "airlines",
    version: str = "mvm_v1",
) -> dict[str, Any]:
    path = resolve_models_repo() / industry / version / "model.json"
    if not path.exists():
        raise FileNotFoundError(f"model.json not found: {path}")
    return json.loads(path.read_text(encoding="utf-8"))


def load_industry_next_vibes(
    industry: str = "airlines",
    version: str = "mvm_v1",
) -> str:
    bundled = Path(__file__).resolve().parent / "next_vibes.txt"
    if bundled.exists() and bundled.stat().st_size > 100:
        return bundled.read_text(encoding="utf-8")
    path = resolve_models_repo() / industry / version / "vibes" / "next_vibes.txt"
    return path.read_text(encoding="utf-8")
