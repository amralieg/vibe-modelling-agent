"""Canned `_call_ai_query` stub keyed by prompt_name (hybrid with vibe-business-data-models)."""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Optional

_FIXTURES_ROOT = Path(__file__).resolve().parent
_INDEX_PATH = _FIXTURES_ROOT / "index.json"


def _load_index() -> dict:
    return json.loads(_INDEX_PATH.read_text(encoding="utf-8"))


def load_canned_response(prompt_name: str, industry: Optional[str] = None) -> Any:
    idx = _load_index()
    industry = industry or idx.get("_default_industry", "airlines")
    rel = (idx.get("responses") or {}).get(prompt_name)
    if not rel:
        raise KeyError(f"No canned LLM response for prompt_name={prompt_name!r}")
    path = _FIXTURES_ROOT / rel
    if not path.exists():
        raise FileNotFoundError(f"Canned response missing: {path}")
    return json.loads(path.read_text(encoding="utf-8"))


def make_canned_call_ai_query(industry: Optional[str] = None):
    """Return a callable suitable for monkeypatching AIAgent._call_ai_query_impl."""

    def _canned_call_ai_query_impl(
        self,
        prompt_name: str,
        prompt_vars: Optional[dict] = None,
        **kwargs: Any,
    ) -> Any:
        del self, prompt_vars, kwargs
        return load_canned_response(prompt_name, industry=industry)

    return _canned_call_ai_query_impl
