from typing import Any, Callable
from vov_2_0.llm import CannedResponse, MockLLM


def predicate_contains(needle: str) -> Callable[[str], bool]:
    n = needle.lower()
    return lambda s: n in s.lower()


def make_outline_canned(needle: str, outline_response: dict) -> CannedResponse:
    return CannedResponse(
        fingerprint_predicate=lambda s: needle in s and "STRUCTURED OUTLINE" in s,
        response=outline_response,
    )


def make_extraction_canned(chunk_needle: str, vreqs: list[dict]) -> CannedResponse:
    return CannedResponse(
        fingerprint_predicate=lambda s: chunk_needle in s and "RawVREQ" in s,
        response={"vreqs": vreqs},
    )


def make_batching_canned(needle: str, batches: list[dict]) -> CannedResponse:
    return CannedResponse(
        fingerprint_predicate=lambda s: needle in s and "group VREQs into BATCHES" in s,
        response={"batches": batches},
    )


def make_synthesis_canned(needle: str, mutator_src: str, verifier_src: str, summary: str = "") -> CannedResponse:
    return CannedResponse(
        fingerprint_predicate=lambda s: needle in s and "mutator_source" in s,
        response={
            "mutator_source": mutator_src,
            "verifier_source": verifier_src,
            "expected_changes_summary": summary,
        },
    )


def make_generic_canned(predicate: Callable[[str], bool], response: Any) -> CannedResponse:
    return CannedResponse(fingerprint_predicate=predicate, response=response)
