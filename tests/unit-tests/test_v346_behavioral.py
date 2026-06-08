import json
import re

NB = "/Users/amr.ali/Documents/projects/vibe-modelling-agent/agent/dbx_vibe_modelling_agent.ipynb"


def _cell_src(idx):
    nb = json.load(open(NB))
    return "".join(nb["cells"][idx]["source"])


def _full():
    nb = json.load(open(NB))
    return "".join("".join(c.get("source", [])) for c in nb["cells"])


# ---- version anchor (exact for the current version) ----
def test_v346_version_constant():
    src = _cell_src(1)
    m = re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', src)
    assert m, "version constant not found"
    assert tuple(int(x) for x in m.groups()) >= (3, 4, 6)


# ---- domain-closed-no-shared: alias + gate present at all three sites ----
def test_v346_alias_present():
    full = _full()
    assert full.count("domain-closed-no-shared") >= 3
    assert full.count("USER_DOMAINS_EXHAUSTIVE") >= 3


# ---- behavioral: _ensure_shared_domain is a no-op when the roster is closed ----
def _exec_ensure_shared_domain():
    full = _full()
    i = full.index("def _ensure_shared_domain(domains_data, config=None, logger=None):")
    # slice to just before the next top-level def
    j = full.index("\ndef _cleanup_phantom_domains", i)
    block = full[i:j]
    # the slice came from the joined notebook source where each physical line still
    # ends in \n; it is already valid python. exec it.
    ns = {
        "SHARED_DOMAIN_TEMPLATE": {"domain": "shared", "database_name": "shared",
                                   "description": "shared", "products": []},
    }
    exec(block, ns)
    return ns["_ensure_shared_domain"]


def test_v346_closed_roster_suppresses_shared():
    fn = _exec_ensure_shared_domain()
    doms = [{"domain": "hr"}, {"domain": "project"}]
    # CLOSED roster -> must NOT add shared, returns False, domains unchanged
    created = fn(doms, {"USER_DOMAINS_EXHAUSTIVE": True}, None)
    assert created is False
    assert all(d["domain"] != "shared" for d in doms)
    assert len(doms) == 2


def test_v346_open_roster_still_creates_shared_nontautology():
    # NON-TAUTOLOGY: the gate must ONLY fire when closed. Open roster keeps the
    # original behavior (shared IS created) so healthcare/automotive SSOT survives.
    fn = _exec_ensure_shared_domain()
    doms = [{"domain": "claims"}, {"domain": "member"}]
    created = fn(doms, {"USER_DOMAINS_EXHAUSTIVE": False}, None)
    assert created is True
    assert any(d.get("domain") == "shared" for d in doms)


def test_v346_open_roster_idempotent_when_shared_exists():
    fn = _exec_ensure_shared_domain()
    doms = [{"domain": "claims"}, {"domain": "shared"}]
    created = fn(doms, {"USER_DOMAINS_EXHAUSTIVE": False}, None)
    assert created is False  # already present
    assert sum(1 for d in doms if d.get("domain") == "shared") == 1


# ---- dedup keeps 'shared' out of the valid-merge set when closed ----
def test_v346_dedup_excludes_shared_when_closed():
    full = _full()
    i = full.index("# v3.4.6 alias=domain-closed-no-shared: when the user fixed the domain roster")
    seg = full[i:i + 900]
    # closed -> shared NOT added to valid set
    assert "if not _closed_roster:" in seg
    assert "valid_domains_set.add('shared')" in seg
    # last-resort fallback is a real user domain when closed, never 'shared'
    assert "_last_resort" in seg
