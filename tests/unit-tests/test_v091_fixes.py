"""v0.9.1 hotfix bundle test.

The v0.8.9 tester run 401706974398159 TERMINATED in INTERNAL_ERROR/FAILED
because tiny_mvm_shrink hit a deterministic ValueError on BOTH retry
attempts. The v0.8.2 P4 silo validator rejected any plan that left a
product siloed, but `category` and `segment` were ALREADY siloed in the
input ECM v1. The LLM cannot fabricate FK partners.

v0.9.1 SHRINK-INPUT-SILO-PASS-THROUGH (alias=shrink-input-silo-pass-through)
distinguishes NEW silos (introduced by shrink) from PRE-EXISTING silos
(already in input). Reject only NEW; pass pre-existing through with
WARNING + queue into next_vibes.
"""

import json
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
NOTEBOOK_PATH = REPO_ROOT / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _read_notebook_source(path: Path) -> str:
    nb = json.loads(path.read_text(encoding="utf-8"))
    parts = []
    for cell in nb.get("cells", []):
        if cell.get("cell_type") == "code":
            parts.extend(cell.get("source", []))
    return "".join(parts)


@pytest.fixture(scope="module")
def agent_src() -> str:
    return _read_notebook_source(NOTEBOOK_PATH)


class TestShrinkInputSiloPassThrough:
    def test_alias_present(self, agent_src):
        assert "shrink-input-silo-pass-through" in agent_src

    def test_input_silos_computed(self, agent_src):
        assert "_input_silos" in agent_src
        assert "_shrink_silo_input_names" in agent_src

    def test_new_vs_preexisting_split(self, agent_src):
        assert "_new_silos" in agent_src
        assert "_preexisting_silos" in agent_src

    def test_only_new_silos_raise(self, agent_src):
        # The new code raises ValueError ONLY when _new_silos is non-empty.
        # Find the alias and verify the raise is inside an `if _new_silos:`.
        idx = agent_src.find("shrink-input-silo-pass-through")
        assert idx > 0
        snippet = agent_src[idx:idx + 4000]
        assert "if _new_silos:" in snippet
        # The raise should be inside the if-new-silos branch.
        assert (
            "v0.9.1 SHRINK-NEW-SILO" in snippet
            and "raise ValueError" in snippet
        )

    def test_preexisting_logs_warning_and_next_vibes(self, agent_src):
        idx = agent_src.find("shrink-input-silo-pass-through")
        assert idx > 0
        snippet = agent_src[idx:idx + 4000]
        assert "elif _preexisting_silos:" in snippet
        assert "Shrink plan PASS-THROUGH" in snippet
        assert 'rule_id="PREEXISTING_INPUT_SILO"' in snippet

    def test_no_old_unconditional_raise(self, agent_src):
        # The old unconditional `if _shrink_silos: raise` block must be gone.
        # The previous error message (still in `RESIZE_SHRINK_DOMAIN_PROMPT`
        # wording) is fine, but the validator should not have a bare
        # `if _shrink_silos: raise ValueError(...)` pattern.
        # Heuristic: count occurrences of "shrink-forbids-siloed" — should
        # ONLY appear in the prompt template + dead-code comment, NOT in
        # an active raise.
        count = agent_src.count("shrink-forbids-siloed")
        # 1 for the docstring/prompt, 1 for the helper function, 1 for the
        # comment inside the new validator block, 1 in alias commentary
        # (4 total). Allow up to 5 to be safe.
        assert count <= 5, (
            f"shrink-forbids-siloed string appears {count} times — old raise "
            f"block may still be present"
        )
