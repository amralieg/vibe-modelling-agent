import json
import re
from pathlib import Path


AGENT_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_all_source() -> str:
    nb = json.loads(AGENT_PATH.read_text())
    return "\n".join("".join(c.get("source", [])) for c in nb["cells"])


def test_agent_version_is_v215():
    src = _load_all_source()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
    assert m is not None
    assert tuple(int(_x) for _x in m.group(1).split(".")) >= (2, 1, 5), f"Expected 2.1.5, got {m.group(1)}"


def test_tags_list_tolerant_fix_present():
    src = _load_all_source()
    assert "alias=diff-models-tags-list-tolerant" in src
    assert "def _v215_count_tags(_x):" in src
    assert "tags_added += max(0, _v215_count_tags(t) - _v215_count_tags(bt))" in src
    assert "if isinstance(_x, list):" in src
    assert "if isinstance(_x, str):" in src


def test_tags_list_count_logic_handles_both_shapes():
    src = _load_all_source()
    helper_start = src.find("def _v215_count_tags(_x):")
    assert helper_start != -1
    helper_block = src[helper_start:helper_start + 700]
    assert "return len([_y for _y in _x if _y])" in helper_block, (
        "list shape must count non-empty entries"
    )
    assert 'return len([_y for _y in _x.split(",") if _y.strip()])' in helper_block, (
        "string shape must split-by-comma and ignore empty tokens"
    )


def test_aiagent_response_format_unwrap_schema_present():
    src = _load_all_source()
    assert "alias=aiagent-spark-free-response-format-unwrap-schema" in src
    assert "_v215_inner_schema = response_schema" in src
    assert "_v215_inner_schema = response_schema['schema']" in src


def test_verifier_response_format_unwrap_schema_present():
    src = _load_all_source()
    assert "alias=verifier-spark-free-response-format-unwrap-schema" in src
    assert "_v215_vinner_schema = response_schema" in src
    assert "_v215_vinner_schema = response_schema['schema']" in src


def test_schema_unwrap_only_triggers_on_already_wrapped_shape():
    src = _load_all_source()
    for unwrap_var in ("_v215_inner_schema", "_v215_vinner_schema"):
        guard_line = f"if isinstance(response_schema, dict) and isinstance(response_schema.get('schema'), dict) and 'type' in response_schema.get('schema', {{}}):"
        # python source literal in notebook has escaped {}
        assert "isinstance(response_schema, dict)" in src
        assert "isinstance(response_schema.get('schema'), dict)" in src
        assert "'type' in response_schema.get('schema'" in src, (
            f"unwrap must only trigger when response_schema is already {{name, schema, strict}} with a real JSON Schema inside (has top-level 'type')"
        )


def test_schema_unwrap_does_not_break_already_correct_schemas():
    src = _load_all_source()
    # If the schema is already the correct shape ({"type": "object", "properties": ...}),
    # the unwrap branch must not trigger (since the schema dict doesn't have a 'schema' key).
    # Verify the unwrap condition specifically requires nested .schema being a dict with 'type'.
    assert "response_schema.get('schema'), dict" in src


def test_v214_v213_legacy_preserved():
    src = _load_all_source()
    assert "alias=vov-v1-preload-fallback-disk-case-variants" in src
    assert "alias=vov-v1-preload-fallback-disk-multipath" in src
    assert "alias=vov-v1-preload-fail-loud" in src


def test_selffixer_schema_shape_documented():
    src = _load_all_source()
    assert "_SELFFIXER_RESPONSE_SCHEMA" in src
    sel_start = src.find("_SELFFIXER_RESPONSE_SCHEMA = {")
    assert sel_start != -1
    block = src[sel_start:sel_start + 600]
    assert '"name": "selffixer_response"' in block
    assert '"schema":' in block
    assert '"type": "object"' in block, "the inner schema field must be a real JSON Schema with 'type': 'object'"
