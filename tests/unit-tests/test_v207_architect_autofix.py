"""Behavioural tests for v207 architect-review product-name autofix.

Per CLAUDE.md §8.10: every alias has [FIRED] emission AND a behavioural test that
proves the patch changes observable state. These tests verify:

1. The architect validator now TUNES proposed product names that violate the
   ^[a-z0-9][a-z0-9_]*$ regex / 30-char cap / 2-underscore cap, instead of
   appending an error (which previously caused 3 retries -> F2).
2. The closure-captured state holder _architect_autofix_tunes is in place.
3. _apply_architect_autofix_tunes is wired as response_postprocess_func on the
   architect smart_worker_loop call.
4. The helper _v207_tune_product_name reduces 4+ segments to 2 underscores
   correctly.
5. The helper _v207_tune_domain_name reduces multi-word names to single-word.

Cycle 4 RT failure mode (the bug this fixes):
  LLM proposed: 'global_trade_item_registry'
  Validator: rejected ('more than 3 segments') 3x
  Soft-accept refused on critical step -> F2 -> architect review skipped
  This patch: tunes 'global_trade_item_registry' -> 'global_trade_registry'
  (first 2 tokens + last token, 2 underscores, within 30 chars).
"""

import json
import os


NB = os.path.join(
    os.path.dirname(__file__),
    "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb",
)


def _read_nb():
    with open(NB, "r", encoding="utf-8") as f:
        return json.load(f)


def _all_code() -> str:
    nb = _read_nb()
    out = []
    for c in nb.get("cells", []):
        if c.get("cell_type") == "code":
            out.append("".join(c.get("source", [])))
    return "\n".join(out)


def _find_architect_cell_src() -> str:
    nb = _read_nb()
    for c in nb.get("cells", []):
        if c.get("cell_type") != "code":
            continue
        s = "".join(c.get("source", []))
        if "def validate_architect_review" in s and "architect-product-name-tune" in s:
            return s
    raise AssertionError("architect validator cell not found")


def _exec_tune_helpers():
    """Exec the two pure helper functions in isolation (no side effects).
    Extract by tracking indentation: the function body ends when we hit a line
    with the SAME or LESS indentation as the `def` line that isn't blank.
    """
    src = _find_architect_cell_src()
    import textwrap

    def _extract_fn(fn_name: str) -> str:
        lines = src.split("\n")
        start_idx = None
        base_indent = None
        for i, ln in enumerate(lines):
            stripped = ln.lstrip()
            if stripped.startswith(f"def {fn_name}("):
                start_idx = i
                base_indent = len(ln) - len(stripped)
                break
        if start_idx is None:
            raise AssertionError(f"could not find {fn_name}")
        out = [lines[start_idx]]
        for ln in lines[start_idx + 1:]:
            if ln.strip() == "":
                out.append(ln)
                continue
            cur_indent = len(ln) - len(ln.lstrip())
            if cur_indent <= base_indent:
                break
            out.append(ln)
        return "\n".join(out)

    helper1 = _extract_fn("_v207_tune_product_name")
    helper2 = _extract_fn("_v207_tune_domain_name")
    ns = {}
    exec(textwrap.dedent(helper1), ns)
    exec(textwrap.dedent(helper2), ns)
    return ns


# ============================================================================
# 1. Static-grep: aliases + wiring present
# ============================================================================

def test_architect_autofix_aliases_present():
    s = _all_code()
    for alias in ("architect-name-tune-helper",
                  "architect-product-name-tune",
                  "architect-autofix-postprocess"):
        assert alias in s, f"missing alias {alias}"


def test_architect_autofix_state_holder_present():
    s = _find_architect_cell_src()
    assert '_architect_autofix_tunes = {"product_renames": {}, "product_adds": {}, "domain_renames": {}, "domain_adds": {}}' in s


def test_architect_autofix_postprocess_wired():
    s = _find_architect_cell_src()
    assert "response_postprocess_func=_apply_architect_autofix_tunes" in s, (
        "_apply_architect_autofix_tunes must be passed to smart_worker_loop "
        "or in-validator tunes will be lost on re-parse"
    )


def test_architect_autofix_hard_fail_demoted_to_tune():
    """The legacy 'has more than 3 segments' error MUST only fire as a fallback when tune fails."""
    s = _find_architect_cell_src()
    # The tune block should preempt the error.append
    # Specifically: error.append for 'has more than 3 segments' should be inside an `else:` branch
    # under the tune-failed condition.
    # Cheap check: the tune-fired log MUST appear in the same function
    assert "[architect-product-name-tune FIRED v2.0.7] product_rename" in s
    assert "[architect-product-name-tune FIRED v2.0.7] product_add" in s


def test_architect_autofix_helper_function_defined():
    s = _find_architect_cell_src()
    assert "def _v207_tune_product_name(_name):" in s
    assert "def _v207_tune_domain_name(_name):" in s


# ============================================================================
# 2. Pure-function behavior of _v207_tune_product_name
# ============================================================================

def test_tune_product_global_trade_item_registry():
    """The exact failure case from cycle 4 RT."""
    ns = _exec_tune_helpers()
    fn = ns["_v207_tune_product_name"]
    tuned = fn("global_trade_item_registry")
    assert tuned != "global_trade_item_registry"
    assert tuned.count("_") <= 2
    assert len(tuned) <= 30
    # Expected: first 2 + last = "global_trade_registry"
    assert tuned == "global_trade_registry"


def test_tune_product_5_segments():
    ns = _exec_tune_helpers()
    fn = ns["_v207_tune_product_name"]
    tuned = fn("a_b_c_d_e")
    assert tuned.count("_") <= 2
    assert tuned == "a_b_e"


def test_tune_product_idempotent_when_valid():
    """If already valid, return as-is."""
    ns = _exec_tune_helpers()
    fn = ns["_v207_tune_product_name"]
    assert fn("order_line") == "order_line"
    assert fn("customer") == "customer"


def test_tune_product_too_long():
    ns = _exec_tune_helpers()
    fn = ns["_v207_tune_product_name"]
    tuned = fn("promoting_interoperability_measure_score")  # 40 chars
    assert len(tuned) <= 30
    assert tuned.count("_") <= 2


def test_tune_product_handles_uppercase():
    ns = _exec_tune_helpers()
    fn = ns["_v207_tune_product_name"]
    tuned = fn("GlobalTradeItemRegistry")
    # Should lowercase + sanitize. Has no underscores so stays as-is post-lower
    assert tuned == "globaltradeitemregistry"  # 23 chars OK


def test_tune_product_handles_invalid_chars():
    ns = _exec_tune_helpers()
    fn = ns["_v207_tune_product_name"]
    tuned = fn("order-line.item")  # hyphens + dots
    # Non-alnum -> _, then dedup, no segments > 2 underscores expected
    assert "-" not in tuned and "." not in tuned
    assert tuned.count("_") <= 2


def test_tune_product_returns_original_when_untunable():
    """Empty/None -> original."""
    ns = _exec_tune_helpers()
    fn = ns["_v207_tune_product_name"]
    assert fn("") == ""
    assert fn(None) is None


# ============================================================================
# 3. Pure-function behavior of _v207_tune_domain_name
# ============================================================================

def test_tune_domain_digital_health_to_digital():
    ns = _exec_tune_helpers()
    fn = ns["_v207_tune_domain_name"]
    tuned = fn("digital_health")
    assert tuned == "digital"


def test_tune_domain_idempotent_when_valid():
    ns = _exec_tune_helpers()
    fn = ns["_v207_tune_domain_name"]
    assert fn("customer") == "customer"
    assert fn("order") == "order"


def test_tune_domain_handles_space_separator():
    ns = _exec_tune_helpers()
    fn = ns["_v207_tune_domain_name"]
    tuned = fn("supply chain")
    assert tuned == "supply"


def test_tune_domain_strips_punctuation():
    ns = _exec_tune_helpers()
    fn = ns["_v207_tune_domain_name"]
    tuned = fn("order-line")
    # First valid part of split is "order-line" -> sanitize to "orderline"
    assert tuned == "orderline" or tuned == "order"


# ============================================================================
# 4. Integration: the autofix should be invoked when validator processes
#    a known-bad input shape that previously fired F2
# ============================================================================

def test_static_grep_cycle4_failure_pattern_explicitly_called_out():
    """The patch must reference the cycle-4 failure mode in a comment so future
    audits can grep for the linkage."""
    s = _find_architect_cell_src()
    assert "global_trade_item_registry" in s, (
        "patch comment must cite the cycle-4 failure case for traceability"
    )


def test_pattern_match_architect_autofix_emits_FIRED_logs():
    """[architect-product-name-tune FIRED v2.0.7] AND [architect-autofix-postprocess FIRED v2.0.7] both exist."""
    s = _all_code()
    assert "[architect-product-name-tune FIRED v2.0.7]" in s
    assert "[architect-autofix-postprocess FIRED v2.0.7]" in s


# ============================================================================
# 5. In-vivo validator behavior (§8.10 — proves the patch changes observable
#    state, not just emits a log line). Extracts and executes the actual
#    `validate_architect_review` closure body against a known-bad data dict
#    and asserts:
#      a) errors is empty for the previously-failing case (autofix kicked in)
#      b) the in-validator mutation `pr['new_name']` reflects the tuned value
#      c) the closure-captured `_architect_autofix_tunes['product_renames']`
#         contains the tune mapping so the postprocess hook can re-apply
# ============================================================================

def _build_validator_namespace():
    """Construct a namespace with the minimum dependencies (re, json, helpers,
    state holder, mock logger + _coerce_list_of_dicts), then exec the validator
    function body so we can call it directly.
    """
    import re as _re
    import json as _json
    import textwrap
    import logging as _logging

    # Mock logger that just accumulates messages
    class _MockLogger:
        def __init__(self):
            self.msgs = []
        def info(self, msg, *a, **k): self.msgs.append(("info", str(msg)))
        def warning(self, msg, *a, **k): self.msgs.append(("warn", str(msg)))
        def error(self, msg, *a, **k): self.msgs.append(("error", str(msg)))

    def _coerce_list_of_dicts(x):
        if not isinstance(x, list):
            return []
        return [e for e in x if isinstance(e, dict)]

    def _coerce_dict(x):
        return x if isinstance(x, dict) else {}

    # SmartWorkerValidator minimal stub: only validate_json_structure is called
    class _StubValidator:
        def __init__(self, *a, **k): pass
        def validate_json_structure(self, txt):
            data = _json.loads(txt) if isinstance(txt, str) else txt
            return True, [], data

    # Build the namespace that the validator closure expects.
    # The validator references many outer-scope variables — stub them with
    # empty/neutral values so the validator's name/length checks are the only
    # branches exercised.
    ns = {
        "re": _re,
        "json": _json,
        "logger": _MockLogger(),
        "_coerce_list_of_dicts": _coerce_list_of_dicts,
        "_coerce_dict": _coerce_dict,
        "SmartWorkerValidator": _StubValidator,
        "config": {"PROMPT_VARIABLES": {}, "MODEL_SCOPE": "mvm"},
        "user_protected_domains": [],
        "protected_products": [],
        "widgets_values": {"_user_specified_domains": []},
        # Outer-scope data the validator inspects for projection / ceiling checks
        "domains_data": [],
        "products_data": [],
    }
    # Inject the two tune helpers from the actual cell source
    src = _find_architect_cell_src()

    def _extract_fn(fn_name: str) -> str:
        lines = src.split("\n")
        start_idx = None
        base_indent = None
        for i, ln in enumerate(lines):
            stripped = ln.lstrip()
            if stripped.startswith(f"def {fn_name}("):
                start_idx = i
                base_indent = len(ln) - len(stripped)
                break
        out = [lines[start_idx]]
        for ln in lines[start_idx + 1:]:
            if ln.strip() == "":
                out.append(ln)
                continue
            cur_indent = len(ln) - len(ln.lstrip())
            if cur_indent <= base_indent:
                break
            out.append(ln)
        return textwrap.dedent("\n".join(out))

    exec(_extract_fn("_v207_tune_product_name"), ns)
    exec(_extract_fn("_v207_tune_domain_name"), ns)

    # State holder
    ns["_architect_autofix_tunes"] = {
        "product_renames": {}, "product_adds": {},
        "domain_renames": {}, "domain_adds": {},
    }
    # `validator` reference used in the function body
    ns["validator"] = _StubValidator()

    # Extract the validator function body
    src_v = _extract_fn("validate_architect_review")
    exec(src_v, ns)
    return ns


def test_in_vivo_validator_tunes_4segment_product_rename():
    """The exact cycle-4 RT failure case: products_to_rename with new_name='global_trade_item_registry'
    must (a) return valid=True with errors=[], and (b) mutate the dict in place to the tuned name."""
    ns = _build_validator_namespace()
    data = {
        "assessment": {"summary": "test", "completeness_score": 80, "coverage_score": 80,
                       "duplication_score": 80, "usefulness_score": 80, "overall_score": 80},
        "products_to_rename": [
            {"domain": "product", "old_name": "item", "new_name": "global_trade_item_registry"},
        ],
        "products_to_add": [],
        "products_to_remove": [],
        "domains_to_remove": [],
        "domains_to_rename": [],
        "domains_to_add": [],
        "domains_to_merge": [],
        "domains_to_split": [],
    }
    payload = ns["json"].dumps(data)
    valid, errors = ns["validate_architect_review"](payload)
    # Autofix should have engaged -> no errors
    assert valid is True, f"expected valid=True after autofix, got errors={errors}"
    assert errors == [], f"expected no errors after autofix, got {errors}"
    # The in-validator mutation may not survive into the data dict above because
    # validate_architect_review re-parses payload internally. The STATE HOLDER
    # however must record the tune mapping for the postprocess hook.
    tunes = ns["_architect_autofix_tunes"]["product_renames"]
    assert "global_trade_item_registry" in tunes, f"state holder missing tune; got {tunes}"
    assert tunes["global_trade_item_registry"] == "global_trade_registry"
    # Log emission MUST have occurred
    fired_msgs = [m for _, m in ns["logger"].msgs if "architect-product-name-tune FIRED" in m]
    assert len(fired_msgs) >= 1, f"FIRED log line missing; all msgs: {ns['logger'].msgs}"


def test_in_vivo_validator_tunes_overlong_product_add():
    """products_to_add with name='promoting_interoperability_measure_score_extended' (>30 chars
    AND >2 underscores) must be tuned, not error-appended."""
    ns = _build_validator_namespace()
    data = {
        "assessment": {"summary": "x", "overall_score": 70},
        "products_to_rename": [],
        "products_to_add": [
            {"name": "promoting_interoperability_measure_score_extended", "domain": "interop"},
        ],
        "products_to_remove": [],
        "domains_to_remove": [],
        "domains_to_rename": [],
        "domains_to_add": [],
        "domains_to_merge": [],
        "domains_to_split": [],
    }
    payload = ns["json"].dumps(data)
    valid, errors = ns["validate_architect_review"](payload)
    assert valid is True, f"expected valid=True, errors={errors}"
    assert errors == []
    tunes = ns["_architect_autofix_tunes"]["product_adds"]
    assert "promoting_interoperability_measure_score_extended" in tunes
    tuned = tunes["promoting_interoperability_measure_score_extended"]
    assert tuned.count("_") <= 2 and len(tuned) <= 30


def test_in_vivo_validator_pre_patch_would_have_failed():
    """Sanity: confirm the validator IS gating on the 30-char/2-underscore rules so the
    autofix has something to defend against. If we pass an invalid name AND the autofix
    is somehow disabled, errors would surface. This is a positive-control test."""
    ns = _build_validator_namespace()
    # Disable the autofix by clearing the helper (simulates pre-patch)
    def _identity(_n): return _n
    ns["_v207_tune_product_name"] = _identity
    # Re-exec validator with the identity helper bound in
    import textwrap
    src = _find_architect_cell_src()
    def _extract_fn(fn_name):
        lines = src.split("\n")
        start_idx = None; base_indent = None
        for i, ln in enumerate(lines):
            stripped = ln.lstrip()
            if stripped.startswith(f"def {fn_name}("):
                start_idx = i; base_indent = len(ln) - len(stripped); break
        out = [lines[start_idx]]
        for ln in lines[start_idx + 1:]:
            if ln.strip() == "":
                out.append(ln); continue
            cur_indent = len(ln) - len(ln.lstrip())
            if cur_indent <= base_indent: break
            out.append(ln)
        return textwrap.dedent("\n".join(out))
    exec(_extract_fn("validate_architect_review"), ns)

    data = {
        "assessment": {"summary": "x", "overall_score": 70},
        "products_to_rename": [
            {"domain": "p", "old_name": "i", "new_name": "global_trade_item_registry"},
        ],
        "products_to_add": [],
        "products_to_remove": [],
        "domains_to_remove": [],
        "domains_to_rename": [],
        "domains_to_add": [],
        "domains_to_merge": [],
        "domains_to_split": [],
    }
    payload = ns["json"].dumps(data)
    valid, errors = ns["validate_architect_review"](payload)
    # When the tune-helper is identity (returns original), the validator should fall
    # through to the hard-fail path and emit an error.
    assert valid is False, "expected validator to reject when tune is disabled"
    assert any("has more than 3 segments" in e for e in errors), (
        f"expected segment-count error; got {errors}"
    )
