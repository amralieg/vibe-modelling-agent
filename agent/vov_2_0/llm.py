from __future__ import annotations

import hashlib
import json
import os
from dataclasses import dataclass
from typing import Any, Callable, Optional, Protocol


class LLMClient(Protocol):
    def complete_json(self, system: str, user: str, temperature: float = 0.0) -> Any:
        ...

    def complete_with_tools(
        self,
        system: str,
        user: str,
        tools: list[dict],
        tool_handlers: dict[str, Callable[..., Any]],
        max_iters: int = 6,
        temperature: float = 0.0,
    ) -> Any:
        ...


@dataclass
class CannedResponse:
    fingerprint_predicate: Callable[[str], bool]
    response: Any


class MockLLM:
    def __init__(self, canned: Optional[list[CannedResponse]] = None, default: Any = None):
        self.canned = list(canned or [])
        self.default = default
        self.call_log: list[dict] = []

    @staticmethod
    def _fp(system: str, user: str) -> str:
        h = hashlib.sha256()
        h.update(system.encode())
        h.update(b"|||")
        h.update(user.encode())
        return h.hexdigest()[:32]

    def complete_json(self, system: str, user: str, temperature: float = 0.0) -> Any:
        fp = self._fp(system, user)
        self.call_log.append({"fp": fp, "system_len": len(system), "user_len": len(user)})
        for c in self.canned:
            if c.fingerprint_predicate(fp) or c.fingerprint_predicate(user) or c.fingerprint_predicate(system):
                return c.response
        if self.default is not None:
            return self.default
        raise RuntimeError(f"MockLLM: no canned match for fp={fp}, user_preview={user[:200]!r}")

    def complete_with_tools(
        self,
        system: str,
        user: str,
        tools: list[dict],
        tool_handlers: dict[str, Callable[..., Any]],
        max_iters: int = 6,
        temperature: float = 0.0,
    ) -> Any:
        return self.complete_json(system, user, temperature)


class DatabricksLLM:
    def __init__(self, endpoint: str, token: Optional[str] = None, workspace: Optional[str] = None):
        self.endpoint = endpoint
        self.token = token or os.environ.get("DATABRICKS_TOKEN")
        self.workspace = workspace or os.environ.get("DATABRICKS_HOST")

    def complete_json(self, system: str, user: str, temperature: float = 0.0) -> Any:
        try:
            from openai import OpenAI
        except ImportError as e:
            raise RuntimeError("DatabricksLLM requires `openai` package; install or use MockLLM in tests") from e
        client = OpenAI(api_key=self.token, base_url=f"{self.workspace}/serving-endpoints")
        resp = client.chat.completions.create(
            model=self.endpoint,
            messages=[{"role": "system", "content": system}, {"role": "user", "content": user}],
            temperature=temperature,
            response_format={"type": "json_object"},
        )
        return json.loads(resp.choices[0].message.content)

    def complete_with_tools(
        self,
        system: str,
        user: str,
        tools: list[dict],
        tool_handlers: dict[str, Callable[..., Any]],
        max_iters: int = 6,
        temperature: float = 0.0,
    ) -> Any:
        try:
            from openai import OpenAI
        except ImportError as e:
            raise RuntimeError("DatabricksLLM requires `openai` package") from e
        client = OpenAI(api_key=self.token, base_url=f"{self.workspace}/serving-endpoints")
        messages = [{"role": "system", "content": system}, {"role": "user", "content": user}]
        oai_tools = [{"type": "function", "function": t} for t in tools]
        for _ in range(max_iters):
            resp = client.chat.completions.create(
                model=self.endpoint,
                messages=messages,
                tools=oai_tools,
                temperature=temperature,
            )
            msg = resp.choices[0].message
            if not msg.tool_calls:
                content = msg.content or "{}"
                try:
                    return json.loads(content)
                except json.JSONDecodeError:
                    return {"raw": content}
            messages.append({"role": "assistant", "content": msg.content, "tool_calls": [tc.model_dump() for tc in msg.tool_calls]})
            for tc in msg.tool_calls:
                fn_name = tc.function.name
                args = json.loads(tc.function.arguments or "{}")
                handler = tool_handlers.get(fn_name)
                if not handler:
                    result = {"error": f"unknown tool {fn_name}"}
                else:
                    try:
                        result = handler(**args)
                    except Exception as e:
                        result = {"error": str(e)}
                messages.append({"role": "tool", "tool_call_id": tc.id, "content": json.dumps(result)})
        raise RuntimeError("LLM exceeded max_iters in tool-use loop")
