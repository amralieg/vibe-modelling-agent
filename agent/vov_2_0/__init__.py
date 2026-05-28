__VOV_VERSION__ = "2.0.0"

from .types import (
    Batch,
    Handler,
    PipelineResult,
    RawVREQ,
    VReqOutcome,
    VibeChunk,
    VibeOutline,
    VibeSection,
)
from .llm import LLMClient, MockLLM, DatabricksLLM
from .invariants import InvariantSnapshot, capture_invariants, verify_invariants, diff_models_summary, diff_within_summary_scope
from .sandbox import execute_in_sandbox, validate_ast, UnsafeCodeError
from .chunker import chunk_vibe, find_section_offsets
from .outline import build_outline
from .extractor import extract_from_chunk, extract_all, make_tool_handlers
from .deduper import dedupe_vreqs, cluster_vreqs, jaccard
from .batcher import batch_vreqs, deterministic_pre_group
from .synthesizer import synthesize_handler, synthesize_batch_handlers
from .planner import plan_waves
from .pipeline import run_vov_pipeline

__all__ = [
    "__VOV_VERSION__",
    "Batch", "Handler", "PipelineResult", "RawVREQ", "VReqOutcome",
    "VibeChunk", "VibeOutline", "VibeSection",
    "LLMClient", "MockLLM", "DatabricksLLM",
    "InvariantSnapshot", "capture_invariants", "verify_invariants",
    "diff_models_summary", "diff_within_summary_scope",
    "execute_in_sandbox", "validate_ast", "UnsafeCodeError",
    "chunk_vibe", "find_section_offsets",
    "build_outline",
    "extract_from_chunk", "extract_all", "make_tool_handlers",
    "dedupe_vreqs", "cluster_vreqs", "jaccard",
    "batch_vreqs", "deterministic_pre_group",
    "synthesize_handler", "synthesize_batch_handlers",
    "plan_waves",
    "run_vov_pipeline",
]
