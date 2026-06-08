import json
import re

NB = "/Users/amr.ali/Documents/projects/vibe-modelling-agent/agent/dbx_vibe_modelling_agent.ipynb"


def _cell_src(idx):
    nb = json.load(open(NB))
    return "".join(nb["cells"][idx]["source"])


def _full():
    nb = json.load(open(NB))
    return "".join("".join(c.get("source", [])) for c in nb["cells"])


def test_v347_version_constant():
    src = _cell_src(1)
    m = re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', src)
    assert m, "version constant not found"
    assert tuple(int(x) for x in m.groups()) >= (3, 4, 7)


def test_v347_physical_mirror_wired_into_finalize():
    full = _full()
    # the mirror must be CALLED inside step_finalize (before physical apply), not just defined
    fin_i = full.index("def step_finalize_model_before_physical_schema(")
    fin_seg = full[fin_i:fin_i + 6000]
    assert "_mirror_trace_tags_into_tags_string(products_data, attributes_data" in fin_seg
    assert "trace-tag-physical-mirror" in full


def test_v347_shared_harvest_helper_is_dry():
    full = _full()
    # one shared module-level harvester used by both enrich (tag_set) and mirror (tags string)
    assert full.count("def _harvest_trace_tags(") == 1
    assert "_harvest_trace_tags(" in full
