from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any, Callable, Optional


@dataclass(frozen=True)
class VibeSection:
    section_id: str
    title: str
    byte_start: int
    byte_end: int
    summary: str
    declared_entities: tuple[str, ...]
    cross_references: tuple[str, ...]
    constraints: tuple[str, ...]


@dataclass(frozen=True)
class VibeOutline:
    sections: tuple[VibeSection, ...]
    full_text: str
    global_constraints: tuple[str, ...]
    declared_entities_global: tuple[str, ...]

    def section(self, section_id: str) -> Optional[VibeSection]:
        for s in self.sections:
            if s.section_id == section_id:
                return s
        return None

    def section_text(self, section_id: str) -> str:
        s = self.section(section_id)
        if not s:
            return ""
        return self.full_text[s.byte_start:s.byte_end]

    def find_entity(self, name: str) -> tuple[VibeSection, ...]:
        out = []
        n = name.lower()
        for s in self.sections:
            if any(n == e.lower() or n in e.lower() for e in s.declared_entities):
                out.append(s)
        return tuple(out)


@dataclass(frozen=True)
class VibeChunk:
    chunk_id: str
    section_ids: tuple[str, ...]
    text: str
    byte_start: int
    byte_end: int


@dataclass(frozen=True)
class RawVREQ:
    vreq_id: str
    intent: str
    target: str
    source_quote: str
    source_chunk_id: str

    def fingerprint(self) -> str:
        import hashlib
        h = hashlib.sha256()
        h.update(self.intent.encode())
        h.update(b"|")
        h.update(self.target.encode())
        return h.hexdigest()[:16]


@dataclass(frozen=True)
class Batch:
    batch_id: str
    vreq_ids: tuple[str, ...]
    intent_summary: str
    target_entities: tuple[tuple[str, str], ...]
    data_payload: tuple[dict, ...]


@dataclass(frozen=True)
class Handler:
    batch_id: str
    mutator_src: str
    verifier_src: str
    expected_changes_summary: str
    target_entities: tuple[tuple[str, str], ...]


@dataclass(frozen=True)
class ExecResult:
    ok: bool
    new_model: Optional[dict]
    diagnostic: str
    rejection_reason: Optional[str]
    pre_invariants_hash: str
    post_invariants_hash: str


@dataclass(frozen=True)
class VReqOutcome:
    batch_id: str
    vreq_ids: tuple[str, ...]
    status: str
    diagnostic: str
    attempts: int


@dataclass
class PipelineResult:
    initial_model: dict
    final_model: dict
    outline: VibeOutline
    raw_vreqs: list[RawVREQ]
    batches: list[Batch]
    outcomes: list[VReqOutcome]
    coverage_pct: float
    rejected_handlers: list[tuple[str, str]] = field(default_factory=list)
