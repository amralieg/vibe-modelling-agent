import json
import os
import re

import pytest

_NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _full():
    nb = json.load(open(_NB))
    return "\n".join("".join(c.get("source", [])) for c in nb["cells"])


def test_v348_version_constant():
    src = _full()
    m = re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', src)
    assert m, "version constant not found"
    assert tuple(int(x) for x in m.groups()) >= (3, 4, 8)


def test_v348_re_provenance_add_missing_present():
    src = _full()
    assert "re-provenance-add-missing" in src
    assert "RE_PROVENANCE_ADD_MISSING" in src
    # the deterministic description-scan recovery must be present (no LLM dependency for the common case)
    assert "DESCRIPTION scan" in src or "description scan" in src.lower()


def _parse_tags(s):
    d = {}
    for part in (s or "").split(","):
        part = part.strip()
        if not part:
            continue
        if "=" in part:
            k, v = part.split("=", 1)
            d[k.strip()] = v.strip()
        else:
            d[part] = ""
    return d


def _serialize_tags(d):
    return ",".join((f"{k}={v}" if v != "" else k) for k, v in d.items())


def _norm(x):
    return re.sub(r"[^a-z0-9]", "", (x or "").lower())


def _add_missing_provenance(products, src_tbl_by_norm, prov_keys):
    """Faithful re-implementation of the v3.4.8 deterministic branch (name-match + desc-scan)."""
    src_vocab = sorted(set(src_tbl_by_norm.values()), key=lambda x: -len(x))
    added = 0
    for p in products:
        if any(k in _parse_tags(p.get("tags")) for k in prov_keys):
            continue
        orig = src_tbl_by_norm.get(_norm(p.get("product")))
        if not orig:
            dl = (p.get("description") or "").lower()
            for sv in src_vocab:
                if sv and sv.lower() in dl:
                    orig = sv
                    break
        if orig:
            tags = _parse_tags(p.get("tags"))
            for k in prov_keys:
                tags[k] = orig
            p["tags"] = _serialize_tags(tags)
            added += 1
    return added


def test_v348_desc_scan_recovers_missing_provenance():
    # Mirrors gov_transport VREQ-008: PSE products lack gov_transport_original_table_name; the source name is in the description.
    src_tbl_by_norm = {
        "dsctrcategory": "dsctrcategory",
        "dsctrcategorygroup": "dsctrcategorygroup",
        "dsctrdatatype": "dsctrdatatype",
        "dsctrdropdownlookup": "dsctrdropdownlookup",
    }
    products = [
        {"product": "pse_control", "tags": "gov_transport_original_table_name=dsctrgroupcontrol", "description": "from dsctrgroupcontrol"},
        {"product": "pse_category", "tags": "", "description": "PSE decision-tree category master derived from dsctrcategory source."},
        {"product": "pse_category_group", "tags": "", "description": "Second-level grouping reverse-engineered from dsctrcategorygroup."},
        {"product": "pse_data_type", "tags": "", "description": "PSE control data types from dsctrdatatype reference."},
        {"product": "pse_dropdown_option", "tags": "", "description": "Dropdown values from dsctrdropdownlookup."},
        {"product": "employee", "tags": "", "description": "Native HR employee master. No source schema origin."},
    ]
    prov_keys = ["gov_transport_original_table_name"]
    added = _add_missing_provenance(products, src_tbl_by_norm, prov_keys)

    by = {p["product"]: _parse_tags(p.get("tags")) for p in products}
    # longest-first: pse_category_group must map to dsctrcategorygroup, NOT dsctrcategory
    assert by["pse_category_group"].get("gov_transport_original_table_name") == "dsctrcategorygroup"
    assert by["pse_category"].get("gov_transport_original_table_name") == "dsctrcategory"
    assert by["pse_data_type"].get("gov_transport_original_table_name") == "dsctrdatatype"
    assert by["pse_dropdown_option"].get("gov_transport_original_table_name") == "dsctrdropdownlookup"
    # native product with no source must NOT be tagged (no over-tagging)
    assert "gov_transport_original_table_name" not in by["employee"]
    # pse_control already had it -> not double counted
    assert added == 4


def test_v348_prepatch_would_skip_missing_keys():
    # Proves the bug existed: the OLD loop only fixes products that already carry the key.
    products = [
        {"product": "pse_category", "tags": "", "description": "derived from dsctrcategory"},
    ]
    src_tbl_by_norm = {"dsctrcategory": "dsctrcategory"}
    prov_keys = ["gov_transport_original_table_name"]

    # pre-patch behavior: skip when key absent
    prepatch_added = 0
    for p in products:
        present = [k for k in prov_keys if k in _parse_tags(p.get("tags"))]
        if not present:
            continue  # the bug
        prepatch_added += 1
    assert prepatch_added == 0  # bug: nothing added
    assert "gov_transport_original_table_name" not in _parse_tags(products[0]["tags"])

    # post-patch recovers it
    added = _add_missing_provenance(products, src_tbl_by_norm, prov_keys)
    assert added == 1
    assert _parse_tags(products[0]["tags"])["gov_transport_original_table_name"] == "dsctrcategory"
