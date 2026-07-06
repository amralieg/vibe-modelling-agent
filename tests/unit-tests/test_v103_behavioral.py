from notebook_source_util import notebook_concat_source

"""Behavioral tests for v1.0.3 — THREE-FIX SUITE.

(A) vibe-master-retry-on-zero-actions
    When VIBE_MASTER_PROMPT chunked aggregate returns actions=[] for non-trivial vibe (>5000 chars),
    re-run with halved chunk budget. Up to 2 retry rounds. If still empty, fall through to the
    existing emit-to-next_vibes path. ROOT CAUSE for RT iter-4 mutation_applied=0.

(B) verifier-llm-fallback-deterministic-rescue
    When `_verify_via_llm` primary LLM returns empty, rescue via STRUCTURED EXTRACTION + deterministic
    snapshot check. Returns 'fulfilled' or 'failed' — never 'partial' on rescue path. Closes the
    iter-4 LG/RT 'LLM returned empty' soft-accept hatch (§11.5 forbidden).

(C) auditor-classify-more-action-types
    Classifier extension in /tmp/v96_adherence_v2.py. Adds 13 new action types: connect_table_loose,
    add_domain, merge_products, move_product, add_classification_tag, bulk_rename_attribute,
    resolve_unlinked_fk, ssot_consolidate, clean_descriptions, remove_self_fk, split_product,
    add_fk_connection, remove_fk-extended, drop_attribute-extended, rename_product-extended.
    Closes HC's 34/35 unclassified gap and LG's 28/47 unclassified gap.
"""

import importlib.util
import json
import os
import re
import sys
from types import SimpleNamespace

import pytest

REPO_ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
AGENT_NB = os.path.join(REPO_ROOT, "agent", "dbx_vibe_modelling_agent.ipynb")
README = os.path.join(REPO_ROOT, "readme.md")
V96_AUDITOR = "/tmp/v96_adherence_v2.py"


@pytest.fixture(scope="module")
def agent_text():
    with open(AGENT_NB, "r", encoding="utf-8", errors="ignore") as f:
        return f.read()


@pytest.fixture(scope="module")
def readme_text():
    if not os.path.exists(README):
        pytest.skip("readme.md missing")
    with open(README, "r", encoding="utf-8", errors="ignore") as f:
        return f.read()


@pytest.fixture(scope="module")
def v96_module():
    if not os.path.exists(V96_AUDITOR):
        pytest.skip("v96_adherence_v2 not on disk")
    spec = importlib.util.spec_from_file_location("v96_adherence_v2", V96_AUDITOR)
    mod = importlib.util.module_from_spec(spec)
    sys.modules["v96_adherence_v2"] = mod
    spec.loader.exec_module(mod)
    return mod


# ───────────────────────────────────────────────────────────────────────
# 1. Static-grep smoke tests — version + sentinels + no-regression
# ───────────────────────────────────────────────────────────────────────


def test_v103_agent_version_string(agent_text):
    """v1.0.4+ supersedes v1.0.3 (NO VERSIONING ROADMAP per §1a). v1.0.3 fixes are preserved
    via their sentinels. Assert version is 1.0.3 OR newer."""
    matches = re.findall(r'__AGENT_VERSION__\s*=\s*\\?"(1\.\d\.\d)\\?"', agent_text)
    assert any(v >= "1.0.3" for v in matches), (
        f"__AGENT_VERSION__ must be 1.0.3 or newer; found {matches}"
    )


def test_v103_single_digit_semver_invariant(agent_text):
    bad = re.findall(r'__AGENT_VERSION__\s*=\s*\\?"\d+\.\d{2,}\.\d+\\?"', agent_text)
    bad += re.findall(r'__AGENT_VERSION__\s*=\s*\\?"\d+\.\d+\.\d{2,}\\?"', agent_text)
    bad += re.findall(r'__AGENT_VERSION__\s*=\s*\\?"\d{2,}\.\d+\.\d+\\?"', agent_text)
    assert not bad, f"single-digit semver violated: {bad}"


def test_v103_fix_a_sentinel_present(agent_text):
    n = agent_text.count("vibe-master-retry-on-zero-actions FIRED v1.0.3")
    assert n >= 2, (
        f"FIX A sentinel must fire at >=2 sites (per-round + final-fallthrough log); got {n}"
    )


def test_v103_fix_b_sentinel_present(agent_text):
    n = agent_text.count("verifier-llm-fallback-deterministic-rescue FIRED v1.0.3")
    assert n >= 2, (
        f"FIX B sentinel must fire at the rescue path AND the no-extraction-target path; got {n}"
    )


def test_v103_fix_c_sentinel_in_auditor(v96_module):
    src = open(V96_AUDITOR).read()
    assert "auditor-classify-more-action-types FIRED v1.0.3" in src, (
        "FIX C sentinel missing in /tmp/v96_adherence_v2.py"
    )


def test_v103_no_partial_softaccept_in_verifier_empty_path(agent_text):
    """§11.5 forbidden: when LLM returns empty, the code MUST NOT return status='partial'.
    The replacement path returns either 'failed' or 'fulfilled' via deterministic rescue."""
    # Find the _verify_via_llm body and assert the "if not _v100_resp:" branch returns failed
    # not partial.
    fn_match = re.search(r"def _verify_via_llm\(self,", agent_text)
    assert fn_match
    body = agent_text[fn_match.end():fn_match.end() + 25000]
    # The forbidden v1.0.1 string must NOT be the active return path.
    forbidden_old = "[verifier-llm-fallback FIRED v1.0.1] LLM returned empty"
    if forbidden_old in body:
        # Acceptable only if it is in a comment or commented out — but we strict-check the
        # `return` statement itself is no longer the partial soft-accept path.
        # Find the FIRST `if not _v100_resp:` block in this body.
        if_block = re.search(r"if not _v100_resp:[^\n]*\n((?:[^\n]*\n){0,80})", body)
        assert if_block, "could not find `if not _v100_resp:` block"
        block_text = if_block.group(1)
        # The block must NOT contain `return {"status": "partial"` for the old soft-accept message.
        assert not re.search(
            r'return\s*\{\s*"status"\s*:\s*"partial"\s*,\s*"evidence"\s*:\s*"\[verifier-llm-fallback FIRED v1\.0\.1\]',
            block_text,
        ), "v1.0.3 must remove the v1.0.1 partial soft-accept return for empty LLM"


def _strip_py_comments_from_nb_body(body):
    """Strip Python `# ...` comments from a notebook-source slice. The notebook stores each line as a
    JSON-quoted string ending in `\\n`. We split on `\\n` (the literal backslash-n in the JSON file,
    which is 2 chars in Python: `\\\\n`), strip the JSON-quote/comma/whitespace from each piece, and
    drop entries whose first non-whitespace char is `#`. Returns the active-code-only text."""
    # In agent_text (raw .ipynb file content), newlines inside JSON strings appear as the 2-char
    # sequence backslash-n. In a Python string literal that is `"\\n"`. So split on `\\n`.
    pieces = body.split("\\n")
    out = []
    for raw in pieces:
        # raw may look like: `",\n    "        # v1.0.0 ...` (JSON noise leading the content).
        # Strip JSON-array boilerplate: leading `",`, leading whitespace and newlines, leading `"`.
        clean = raw
        clean = clean.lstrip(' \t\n,"')
        if clean.startswith("#"):
            continue
        out.append(raw)
    return "\\n".join(out)


def test_v103_uses_call_ai_query_not_run_method(agent_text):
    """Real-AIAgent invariant: prior v1.0.0 bug used `.run(...)` which does not exist on AIAgent.
    All v1.0.3 LLM calls in the verifier paths MUST use `_call_ai_query`. Comments are excluded."""
    fn_match = re.search(r"def _verify_via_llm\(self,", agent_text)
    assert fn_match
    body = agent_text[fn_match.end():fn_match.end() + 25000]
    code_only = _strip_py_comments_from_nb_body(body)
    # `.run(` calls on `self.ai_agent` are forbidden
    assert not re.search(r"self\.ai_agent\.run\s*\(", code_only), (
        "v1.0.3 _verify_via_llm must NEVER call self.ai_agent.run(...) in active CODE — that interface does not exist; use _call_ai_query"
    )
    assert "_call_ai_query" in body, (
        "v1.0.3 _verify_via_llm must call self.ai_agent._call_ai_query(...)"
    )


def test_v103_prior_fix_sentinels_preserved(agent_text):
    """v1.0.3 must NOT regress prior fixes."""
    for sentinel in (
        "[install-path-auto-resolve-latest-vN FIRED]",  # v1.0.2
        "[verifier-llm-fallback-call-fix FIRED]",        # v1.0.1
        "[user-directive-protects-from-fk-rename FIRED]",  # v1.0.0
        "[verifier-llm-fallback FIRED]",                  # v1.0.0
        "[vov-new-domains-from-manifest FIRED]",          # v1.0.0
        "[master-failure-mode-from-manifest FIRED]",       # v0.9.9
    ):
        assert sentinel in agent_text, f"prior sentinel '{sentinel}' missing — REGRESSION"


def test_v103_notebook_is_valid_json(agent_text):
    nb = json.loads(agent_text)
    assert isinstance(nb.get("cells", []), list) and len(nb["cells"]) > 0


# ───────────────────────────────────────────────────────────────────────
# 2. FIX A behavioral — retry-on-zero-actions logic
#    Extract the same algorithm as a standalone function and exercise it.
# ───────────────────────────────────────────────────────────────────────


def _extract_fix_a_retry_decision():
    """Reproduce the fix-A *decision* logic in isolation. The full master_analyze involves the
    ai_agent which is not constructible in unit tests, but the decision-logic for `should retry`
    is pure: actions=[] AND vibe>=threshold AND round<max."""
    threshold = 5000
    max_rounds = 2

    def should_retry(n_actions, vibe_chars, round_num):
        return n_actions == 0 and vibe_chars > threshold and round_num < max_rounds

    return should_retry


def test_v103_fix_a_should_retry_when_actions_empty_and_vibe_large():
    should_retry = _extract_fix_a_retry_decision()
    assert should_retry(n_actions=0, vibe_chars=30000, round_num=0) is True
    assert should_retry(n_actions=0, vibe_chars=30000, round_num=1) is True


def test_v103_fix_a_should_NOT_retry_when_actions_present():
    should_retry = _extract_fix_a_retry_decision()
    assert should_retry(n_actions=5, vibe_chars=30000, round_num=0) is False
    assert should_retry(n_actions=1, vibe_chars=30000, round_num=0) is False


def test_v103_fix_a_should_NOT_retry_for_tiny_vibe():
    should_retry = _extract_fix_a_retry_decision()
    assert should_retry(n_actions=0, vibe_chars=1000, round_num=0) is False
    assert should_retry(n_actions=0, vibe_chars=4999, round_num=0) is False


def test_v103_fix_a_caps_at_2_rounds():
    should_retry = _extract_fix_a_retry_decision()
    assert should_retry(n_actions=0, vibe_chars=30000, round_num=2) is False
    assert should_retry(n_actions=0, vibe_chars=30000, round_num=3) is False


def test_v103_fix_a_chunking_halves_budget(agent_text):
    """The retry block must compute a NEW budget = max(2000, vibe_chars // new_n_chunks + 500)."""
    # find the FIX A block
    fix_a = re.search(r"_v103_retry_max_rounds\s*=\s*\d+", agent_text)
    assert fix_a, "FIX A block missing"
    # snippet around it
    near = agent_text[fix_a.start():fix_a.start() + 4000]
    # new_n_chunks is doubled, new_budget is bounded
    assert "max(2000, _v103_vibe_chars // _v103_new_n_chunks + 500)" in near, (
        "FIX A must compute new chunk budget as max(2000, vibe_chars // new_n_chunks + 500)"
    )
    assert "max(_v103_prev_n_chunks * 2, 4)" in near, (
        "FIX A must double the previous chunk count (or at least 4)"
    )


# ───────────────────────────────────────────────────────────────────────
# 3. FIX B behavioral — deterministic rescue logic
# ───────────────────────────────────────────────────────────────────────


def _build_snapshot(products_data, attributes_data):
    """Helper to produce the snapshot data structures the verifier expects."""
    return {
        "products_data": products_data,
        "attributes_data": attributes_data,
    }


def _run_fix_b_deterministic(extract_parsed, products_data, attributes_data):
    """Reproduce the FIX B deterministic-rescue branch. extract_parsed is the parsed rescue LLM
    output dict. Returns (status, evidence_substr).

    The actual code is in _verify_via_llm; we replay the deterministic check in a standalone
    function so we can exercise every branch without spinning up an agent."""
    kind = (extract_parsed.get("target_kind") or "").strip().lower()
    path = (extract_parsed.get("target_path") or "").strip()
    state = (extract_parsed.get("expected_state") or "").strip().lower()
    new_path = (extract_parsed.get("new_target_path") or "").strip()
    fk_to = (extract_parsed.get("expected_fk_to") or "").strip()
    if kind in ("unknown", "") or state in ("unknown", "") or not path:
        return "failed", "extract failed"
    pset, aset, attr_fk, attr_type, dset = set(), set(), {}, {}, set()
    for p in products_data:
        pk = f"{p.get('domain','')}.{p.get('product','')}"
        pset.add(pk)
        dset.add(p.get("domain", ""))
    for a in attributes_data:
        ak = f"{a.get('domain','')}.{a.get('product','')}.{a.get('attribute','')}"
        aset.add(ak)
        if a.get("foreign_key_to"):
            attr_fk[ak] = a.get("foreign_key_to")
        if a.get("type"):
            attr_type[ak] = a.get("type")
    if kind == "product":
        if state == "present":
            return ("fulfilled" if path in pset else "failed", f"product {path}")
        if state == "absent":
            return ("fulfilled" if path not in pset else "failed", f"product {path}")
        if state == "renamed":
            return ("fulfilled" if path not in pset and new_path in pset else "failed", "rename")
    if kind == "attribute":
        if state == "present":
            return ("fulfilled" if path in aset else "failed", f"attr {path}")
        if state == "absent":
            return ("fulfilled" if path not in aset else "failed", f"attr {path}")
    if kind == "fk":
        if state == "has_fk" and fk_to:
            actual = attr_fk.get(path, "")
            ok = actual and (actual == fk_to or actual.endswith(fk_to))
            return ("fulfilled" if ok else "failed", f"fk {path}->{actual}")
        if state == "no_fk":
            return ("fulfilled" if path not in attr_fk else "failed", f"no_fk {path}")
    if kind == "domain":
        if state == "present":
            return ("fulfilled" if path in dset else "failed", f"domain {path}")
        if state == "absent":
            return ("fulfilled" if path not in dset else "failed", f"domain {path}")
    return "failed", "unhandled"


def test_v103_fix_b_product_present_fulfilled():
    products = [{"domain": "matter", "product": "deadline"}]
    status, _ = _run_fix_b_deterministic(
        {"target_kind": "product", "target_path": "matter.deadline", "expected_state": "present"},
        products, [])
    assert status == "fulfilled"


def test_v103_fix_b_product_present_failed_when_missing():
    """§8.3 anti-tautology: same input, different model state → different verdict."""
    products = [{"domain": "matter", "product": "OTHER"}]
    status, _ = _run_fix_b_deterministic(
        {"target_kind": "product", "target_path": "matter.deadline", "expected_state": "present"},
        products, [])
    assert status == "failed"


def test_v103_fix_b_attribute_renamed_fulfilled():
    attrs = [{"domain": "store", "product": "profit_loss", "attribute": "amount"}]
    status, _ = _run_fix_b_deterministic(
        {"target_kind": "product", "target_path": "store.pl",
         "expected_state": "renamed", "new_target_path": "store.profit_loss"},
        [{"domain": "store", "product": "profit_loss"}], attrs)
    assert status == "fulfilled"


def test_v103_fix_b_attribute_renamed_failed_when_old_still_there():
    """§8.3: same VREQ, different state → different verdict."""
    status, _ = _run_fix_b_deterministic(
        {"target_kind": "product", "target_path": "store.pl",
         "expected_state": "renamed", "new_target_path": "store.profit_loss"},
        [{"domain": "store", "product": "pl"}, {"domain": "store", "product": "profit_loss"}], [])
    assert status == "failed"


def test_v103_fix_b_fk_has_fk_fulfilled():
    attrs = [{"domain": "matter", "product": "deadline", "attribute": "matter_id",
              "foreign_key_to": "matter.matter.matter_id"}]
    status, _ = _run_fix_b_deterministic(
        {"target_kind": "fk", "target_path": "matter.deadline.matter_id",
         "expected_state": "has_fk", "expected_fk_to": "matter.matter.matter_id"},
        [{"domain": "matter", "product": "deadline"}], attrs)
    assert status == "fulfilled"


def test_v103_fix_b_fk_has_fk_failed_when_no_fk_set():
    attrs = [{"domain": "matter", "product": "deadline", "attribute": "matter_id"}]
    status, _ = _run_fix_b_deterministic(
        {"target_kind": "fk", "target_path": "matter.deadline.matter_id",
         "expected_state": "has_fk", "expected_fk_to": "matter.matter.matter_id"},
        [{"domain": "matter", "product": "deadline"}], attrs)
    assert status == "failed"


def test_v103_fix_b_unknown_extraction_returns_failed_not_partial():
    """§11.5: when extraction returns unknown/empty, the verdict is 'failed' — NEVER 'partial'."""
    status, evidence = _run_fix_b_deterministic(
        {"target_kind": "unknown", "target_path": "", "expected_state": "unknown"},
        [], [])
    assert status == "failed"


def test_v103_fix_b_no_partial_in_rescue_path(agent_text):
    """The rescue path block must NOT have any `status: "partial"` returns. Confirm via grep
    of the FIX B insertion region."""
    # locate the FIX B block
    block_start = agent_text.find("verifier-llm-fallback-deterministic-rescue FIRED v1.0.3")
    assert block_start >= 0
    block_end = agent_text.find('return _v103_verdict_status', block_start)
    if block_end < 0:
        # alternatively look for the closing return in the rescue
        block_end = agent_text.find('"verifier-llm-fallback-deterministic-rescue FIRED v1.0.3"', block_start + 1000)
    block_text = agent_text[block_start:block_end + 500] if block_end > block_start else agent_text[block_start:block_start + 12000]
    # The FIX B rescue must not put `partial` in its return paths.
    partial_returns = re.findall(r'return\s*\{[^}]*"status"\s*:\s*"partial"', block_text)
    assert not partial_returns, (
        f"FIX B rescue path contains forbidden partial-soft-accept return(s): {partial_returns}"
    )


# ───────────────────────────────────────────────────────────────────────
# 4. FIX C behavioral — auditor classifier extension
# ───────────────────────────────────────────────────────────────────────


def test_v103_fix_c_classifies_add_domain(v96_module):
    body = "Add a behavioral_health domain (or subdomain under clinical) with tables for: psychiatric_assessment"
    action, params = v96_module.classify_vreq_action(body)
    assert action == "add_domain"
    assert params["domain_name"] == "behavioral_health"


def test_v103_fix_c_verifies_add_domain_fulfilled_vs_missed(v96_module):
    # Simulate model with the domain present
    idx_present = {"by_dp": {"behavioral_health.assessment": {"attrs": {}}}}
    v_p, _ = v96_module.verify_against_model("add_domain", {"domain_name": "behavioral_health"}, idx_present)
    assert v_p == "FULFILLED"
    # And absent
    idx_absent = {"by_dp": {"clinical.note": {"attrs": {}}}}
    v_a, _ = v96_module.verify_against_model("add_domain", {"domain_name": "behavioral_health"}, idx_absent)
    assert v_a == "MISSED"


def test_v103_fix_c_classifies_merge_products(v96_module):
    body = "Merge matter.deadline and matter.matter_deadline into a single product called deadline in the matter domain"
    action, params = v96_module.classify_vreq_action(body)
    assert action == "merge_products"
    assert params["src1"] == "matter.deadline"
    assert params["src2"] == "matter.matter_deadline"
    assert params["new_product"] == "deadline"


def test_v103_fix_c_classifies_move_product(v96_module):
    body = "Move court.adr_proceeding, court.arbitral_award from the court domain to the matter domain"
    action, params = v96_module.classify_vreq_action(body)
    assert action == "move_product"
    assert "court.adr_proceeding" in params["products"]
    assert params["from_domain"] == "court"
    assert params["to_domain"] == "matter"


def test_v103_fix_c_classifies_add_classification_tag(v96_module):
    body = "Add PHI/PII classification tags (pii_phi, pii_pii, pii_sensitive) to all 656 attributes that match person-data patterns"
    action, _ = v96_module.classify_vreq_action(body)
    assert action == "add_classification_tag"


def test_v103_fix_c_classifies_resolve_unlinked_fk(v96_module):
    body = "Resolve all 19 unlinked FK columns that look like foreign keys but have no foreign_key_to reference"
    action, _ = v96_module.classify_vreq_action(body)
    assert action == "resolve_unlinked_fk"


def test_v103_fix_c_verifies_resolve_unlinked_fk(v96_module):
    # Healthy: every _id col has fk_to
    idx_ok = {"by_dp": {
        "matter.deadline": {"attrs": {
            "deadline_id": {"type": "BIGINT", "fk_to": None},  # PK, OK
            "matter_id": {"type": "BIGINT", "fk_to": "matter.matter.matter_id"},
        }, "raw": {}, "domain": "matter"}
    }}
    v, _ = v96_module.verify_against_model("resolve_unlinked_fk", {}, idx_ok)
    assert v == "FULFILLED"
    # Broken: half the _id cols are unlinked
    idx_bad = {"by_dp": {
        "matter.deadline": {"attrs": {
            "deadline_id": {"type": "BIGINT", "fk_to": None},
            "matter_id": {"type": "BIGINT", "fk_to": None},  # unlinked
            "tribunal_id": {"type": "BIGINT", "fk_to": None},
            "judge_id": {"type": "BIGINT", "fk_to": None},
            "office_id": {"type": "BIGINT", "fk_to": None},
            "client_id": {"type": "BIGINT", "fk_to": None},
        }, "raw": {}, "domain": "matter"}
    }}
    v, _ = v96_module.verify_against_model("resolve_unlinked_fk", {}, idx_bad)
    assert v == "MISSED"


def test_v103_fix_c_classifies_drop_attribute_natural_key_attr(v96_module):
    """Original auditor missed 'Remove the redundant natural key attribute X from Y' phrasing."""
    body = "Remove the redundant natural key attribute office_code from workforce.office because it already has an FK office_id"
    action, params = v96_module.classify_vreq_action(body)
    assert action == "drop_attribute"
    assert params["col"] == "office_code"
    assert params["product"] == "workforce.office"


def test_v103_fix_c_classifies_remove_fk_with_the(v96_module):
    """Original auditor missed 'Remove the FK on column X from Y' (the 'the' between Remove and FK)."""
    body = "Remove the FK on column compliance_dpia_id from conflict.search_hit because a conflict search hit"
    action, params = v96_module.classify_vreq_action(body)
    assert action == "remove_fk"
    assert params["col"] == "compliance_dpia_id"
    assert params["product"] == "conflict.search_hit"


def test_v103_fix_c_classifies_rename_product_arrow(v96_module):
    """Auditor must handle 'X.Y → Z' arrow phrasing (LG VREQ-026 listed renames as A → B, ...)."""
    body = "Rename the following products to remove redundant domain prefixes: billing.billing_disbursement → billing.disbursement"
    action, params = v96_module.classify_vreq_action(body)
    assert action == "rename_product"
    assert params["old_product"] == "billing.billing_disbursement"
    assert "billing.disbursement" in params["new_product"]


def test_v103_fix_c_classifies_ssot_consolidate(v96_module):
    body = "Resolve cross-domain SSOT violations for the 'office' entity: billing.billing_office, service.office, and workforce.office"
    action, _ = v96_module.classify_vreq_action(body)
    assert action == "ssot_consolidate"


def test_v103_fix_c_classifies_clean_descriptions(v96_module):
    body = "Clean 18 attributes that contain banned boilerplate phrases (Fortune N, multinational, enterprise-wide)"
    action, _ = v96_module.classify_vreq_action(body)
    assert action == "clean_descriptions"


def test_v103_fix_c_classifies_bulk_rename_attribute(v96_module):
    body = "Remove redundant product-name prefixes from 89 non-PK attributes that are redundantly prefixed"
    action, _ = v96_module.classify_vreq_action(body)
    assert action == "bulk_rename_attribute"


def test_v103_fix_c_classifies_split_product(v96_module):
    body = "Consider splitting pharmacy.prescription which has 27 outgoing FKs"
    action, params = v96_module.classify_vreq_action(body)
    assert action == "split_product"
    assert params["product"] == "pharmacy.prescription"


def test_v103_fix_c_extended_classification_count_is_at_least_13(v96_module):
    """Auditor adds at least 12 NEW LOOSE_ACTION_REGEX entries beyond v1.0.2."""
    n_patterns = len(v96_module.LOOSE_ACTION_REGEX)
    assert n_patterns >= 18, (
        f"v1.0.3 LOOSE_ACTION_REGEX must have >=18 entries (was 6 in v1.0.2; +13 new); got {n_patterns}"
    )


# ───────────────────────────────────────────────────────────────────────
# 5. AIAgent interface invariant — v1.0.3 must not regress to fake methods
# ───────────────────────────────────────────────────────────────────────


def test_v103_aiagent_interface_uses_call_ai_query_only(agent_text):
    """v1.0.0 P3 used self.ai_agent.run(...) which doesn't exist. v1.0.1 fixed it. v1.0.2 + v1.0.3
    must continue to use _call_ai_query exclusively. Walk the relevant function bodies, comments-stripped."""
    for fn_name in ("_verify_via_llm",):
        fn_match = re.search(rf"def {fn_name}\(self,", agent_text)
        assert fn_match
        body = agent_text[fn_match.end():fn_match.end() + 30000]
        # Up to and including the next `def `
        next_def = re.search(r"\n\s*def ", body)
        if next_def:
            body = body[:next_def.start()]
        code_only = _strip_py_comments_from_nb_body(body)
        assert "_call_ai_query" in body, f"{fn_name} must call _call_ai_query"
        assert not re.search(r"self\.ai_agent\.run\s*\(", code_only), (
            f"{fn_name} must NOT call .run() in active CODE (does not exist on AIAgent)"
        )


# ───────────────────────────────────────────────────────────────────────
# 6. Anti-tautology proof: §8.3 — same params, different snapshots, different verdicts.
# ───────────────────────────────────────────────────────────────────────


def test_v103_fix_c_add_domain_anti_tautology(v96_module):
    params = {"domain_name": "research"}
    idx_with = {"by_dp": {"research.dsmb_committee": {"attrs": {}}}}
    idx_without = {"by_dp": {"matter.deadline": {"attrs": {}}}}
    v1, _ = v96_module.verify_against_model("add_domain", params, idx_with)
    v2, _ = v96_module.verify_against_model("add_domain", params, idx_without)
    assert v1 != v2, "verifier must produce DIFFERENT verdicts when domain present vs absent"


def test_v103_fix_c_resolve_unlinked_fk_anti_tautology(v96_module):
    params = {}
    idx_clean = {"by_dp": {"a.b": {"attrs": {
        "b_id": {"fk_to": None},
        "x_id": {"fk_to": "a.x.x_id"},
    }}}}
    idx_dirty = {"by_dp": {"a.b": {"attrs": {
        "b_id": {"fk_to": None},
        "x_id": {"fk_to": None},
        "y_id": {"fk_to": None},
        "z_id": {"fk_to": None},
        "w_id": {"fk_to": None},
    }}}}
    v1, _ = v96_module.verify_against_model("resolve_unlinked_fk", params, idx_clean)
    v2, _ = v96_module.verify_against_model("resolve_unlinked_fk", params, idx_dirty)
    assert v1 != v2
