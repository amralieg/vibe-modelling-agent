"""Behavioral tests for v3.0.0 healthcare 88%-ceiling root-cause fix (user audit 2026-06-01).

CAUSE-1 (alias=v300-allow-usub): ALLOWED_AST_NODES banned ast.USub/ast.UAdd (unary -x/+x) while
allowing ast.Invert (~x). LLM mutators containing negative literals (`-1`, `x * -1`, `x < -100`)
were sandbox-rejected -> 3 synth retries -> time_budget_exceeded on healthcare residuals (0 landed,
stuck at 88%). FIX: USub/UAdd added (numeric-only, sandbox-safe).

CAUSE-2 (alias=v300-residual-small-batch): the residual apply-loop re-sent 25-VREQ mega-batches; each
failed-validation batch re-synthesised a mutator via a ~80K-char LLM call (~170s) x3 retries =
300-820s, blowing the 300s per-batch budget. FIX: iter-aware sizing (iter-1 wide @25, residual
iters >=2 @4).

These tests slice the REAL validate_ast from the notebook and exercise it end-to-end.
test_pre_patch_allowlist_would_reject proves the fix is load-bearing (a pre-patch allowlist WITHOUT
USub rejects `-1`), so the suite is non-tautological per CLAUDE.md 8.10.
"""
import ast as _ast_mod
import re
import textwrap

import pytest

from notebook_source_util import notebook_concat_source

SRC = notebook_concat_source()


def _load_validator():
    """Slice ALLOWED_AST_NODES + UnsafeCodeError + validate_ast as real code and exec it."""
    m = re.search(r"ALLOWED_AST_NODES = frozenset\(\{.*?(?=\ndef required_function_present)", SRC, re.DOTALL)
    assert m, "validate_ast block not found in agent notebook"
    block = textwrap.dedent(m.group(0))

    class _Log:
        def info(self, *a, **k):
            pass

        def warning(self, *a, **k):
            pass

    ns = {"ast": _ast_mod, "logger": _Log()}
    exec(compile(block, "agent_notebook", "exec"), ns)
    return ns


NS = _load_validator()
validate_ast = NS["validate_ast"]
UnsafeCodeError = NS["UnsafeCodeError"]
ALLOWED = NS["ALLOWED_AST_NODES"]


# --- FIX-1: USub/UAdd now allowed -----------------------------------------

def test_usub_uadd_in_allowlist():
    assert _ast_mod.USub in ALLOWED, "v300 must add ast.USub to ALLOWED_AST_NODES"
    assert _ast_mod.UAdd in ALLOWED, "v300 must add ast.UAdd to ALLOWED_AST_NODES"


def test_negative_literal_mutator_validates():
    # exactly the mutator shape that was sandbox-rejected pre-v300
    src = (
        "def mutator(model, data):\n"
        "    x = -1\n"
        "    y = +2\n"
        "    if x < -100:\n"
        "        x = x * -1\n"
        "    return model\n"
    )
    validate_ast(src)  # must NOT raise


def test_invert_still_allowed_consistency():
    # ~x (Invert) was always allowed; -x (USub) is strictly less exotic and now also allowed
    validate_ast("def mutator(model, data):\n    z = ~5\n    return model\n")


def test_forbidden_nodes_still_rejected():
    with pytest.raises(UnsafeCodeError):
        validate_ast("import os\n")
    with pytest.raises(UnsafeCodeError):
        validate_ast("def mutator(model, data):\n    eval('1')\n    return model\n")


def test_pre_patch_allowlist_would_reject():
    """Non-tautology proof (CLAUDE.md 8.10): a pre-patch allowlist WITHOUT USub/UAdd rejects `-1`,
    proving the added nodes are load-bearing rather than a no-op."""
    pre = ALLOWED - {_ast_mod.USub, _ast_mod.UAdd}

    def _validate_pre(source):
        tree = _ast_mod.parse(source)
        for node in _ast_mod.walk(tree):
            if type(node) not in pre:
                raise UnsafeCodeError(f"forbidden AST node: {type(node).__name__}")

    with pytest.raises(UnsafeCodeError):
        _validate_pre("def mutator(model, data):\n    x = -1\n    return model\n")


# --- FIX-2B + wiring static contracts -------------------------------------

def test_iter_aware_residual_batch_sizing():
    assert "_max_per_call=(25 if _eloop == 1 else 4)" in SRC, \
        "residual loop must use small batches (4) for iter>=2, wide (25) for iter 1"


def test_fired_aliases_present():
    assert "[v300-allow-usub FIRED]" in SRC
    assert "[v300-residual-small-batch FIRED]" in SRC


def test_obsolete_usub_hint_removed():
    assert "The bare USub node is forbidden by the AST validator" not in SRC, \
        "obsolete USub self-fix hint must be removed now that USub is allowed"


def test_version_at_least_300():
    # v300 features (USub allowlist, residual batch sizing) require version >= 3.0.0.
    # Pin a floor, not an exact literal, so the test stays valid across later bumps.
    m = re.search(r'__AGENT_VERSION__ = "(\d+)\.(\d+)\.(\d+)"', SRC)
    assert m, "agent version constant not found"
    assert tuple(int(g) for g in m.groups()) >= (3, 0, 0)
