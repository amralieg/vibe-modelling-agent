"""
v1.0.7 behavioral test — qa-widgets-values-via-config

Reproduces NCDOT install_base run 584523372060026 crash:
  NameError: name 'widgets_values' is not defined
  at run_quality_assurance_checks Step 7A-0 (Remove Empty/Siloed Domains)

Root cause: the `_vov_user_new_entities` lookup at cell-relative L5952 referenced
bare `widgets_values` while the function does NOT take it as a parameter.
Every other widgets-values access in the function correctly goes through
`config.get("_widgets_values")`. The latent NameError only fired when the
for-loop reached a non-user-protected domain (HC and RT had every domain in
business_domains, so they hit the L5949 `continue` and never reached L5952).

v1.0.7 fix: replace bare `widgets_values` with `config.get("_widgets_values")`
plus a sentinel log line `[qa-widgets-values-via-config FIRED v1.0.7]`.
"""
import json
import re
from pathlib import Path

NB_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_nb_source():
    with open(NB_PATH) as f:
        nb = json.load(f)
    return nb


def _qa_function_source(nb):
    """Return the source of run_quality_assurance_checks as a single string."""
    for cell in nb["cells"]:
        if cell.get("cell_type") != "code":
            continue
        src = "".join(cell["source"]) if isinstance(cell["source"], list) else cell["source"]
        if "def run_quality_assurance_checks" in src:
            return src
    raise AssertionError("run_quality_assurance_checks not found in any cell")


def _slice_function(src, fn_name):
    lines = src.split("\n")
    start = None
    for i, ln in enumerate(lines):
        if f"def {fn_name}" in ln:
            start = i
            break
    assert start is not None
    base_indent = len(lines[start]) - len(lines[start].lstrip())
    end = len(lines)
    for i in range(start + 1, len(lines)):
        s = lines[i]
        if s.strip() and (len(s) - len(s.lstrip())) <= base_indent and s.strip().startswith("def "):
            end = i
            break
    return "\n".join(lines[start:end])


def test_agent_version_bumped_to_107():
    nb = _load_nb_source()
    found = None
    for cell in nb["cells"]:
        if cell.get("cell_type") != "code":
            continue
        src = "".join(cell["source"]) if isinstance(cell["source"], list) else cell["source"]
        m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', src)
        if m:
            found = m.group(1)
            break
    assert found is not None, "__AGENT_VERSION__ constant must exist in some code cell"
    # v1.0.7 fix must remain present in any version >= 1.0.7
    parts = tuple(int(p) for p in found.split("."))
    assert parts >= (1, 0, 7), f"expected version >= 1.0.7 (v1.0.7 fix must be retained), got {found}"


def test_sentinel_present_in_qa_function():
    """The fix must emit [qa-widgets-values-via-config FIRED v1.0.7] inside the QA function."""
    nb = _load_nb_source()
    qa_cell_src = _qa_function_source(nb)
    qa_fn = _slice_function(qa_cell_src, "run_quality_assurance_checks")
    assert "[qa-widgets-values-via-config FIRED v1.0.7]" in qa_fn, (
        "v1.0.7 sentinel must appear inside run_quality_assurance_checks"
    )
    assert "alias=qa-widgets-values-via-config" in qa_fn, (
        "alias tag must appear inside run_quality_assurance_checks"
    )


def test_no_bare_widgets_values_in_qa_code_paths():
    """No code path inside run_quality_assurance_checks may reference bare `widgets_values`.
    The function does not accept `widgets_values` as a parameter; every access must go through
    `config.get("_widgets_values")`. Logger string literals containing the word are OK
    (they don't bind to a name)."""
    nb = _load_nb_source()
    qa_src = _qa_function_source(nb)
    qa_fn = _slice_function(qa_src, "run_quality_assurance_checks")
    bad = []
    for i, ln in enumerate(qa_fn.split("\n"), start=1):
        m = re.search(r'(?<![\w_])widgets_values\b', ln)
        if not m:
            continue
        if "config.get" in ln:
            continue
        if "_widgets_values" in ln:
            continue
        # Allow logger.info / logger.warning literals where the word appears inside an f-string
        # but is not used as a name reference. Detect: token surrounded by quotes/brackets only.
        # A safe heuristic: if the word is inside a string (between two quote chars), allow.
        before = ln[:m.start()]
        # count un-escaped quotes before the match
        n_dq = before.count('"') - before.count('\\"')
        n_sq = before.count("'") - before.count("\\'")
        inside_string = (n_dq % 2 == 1) or (n_sq % 2 == 1)
        if inside_string:
            continue
        bad.append((i, ln.strip()[:200]))
    assert not bad, (
        f"v1.0.7 must remove every bare widgets_values code reference in run_quality_assurance_checks; "
        f"found {len(bad)}:\n" + "\n".join(f"  qa_line {ln_no}: {ln}" for ln_no, ln in bad)
    )


def test_canonical_pattern_used_at_fix_site():
    """The fix site must use `config.get("_widgets_values")` and assign to a local."""
    nb = _load_nb_source()
    qa_src = _qa_function_source(nb)
    qa_fn = _slice_function(qa_src, "run_quality_assurance_checks")
    assert '_wv_p074_qa = (config.get("_widgets_values") or {})' in qa_fn, (
        "the fix must use the canonical config._widgets_values pattern"
    )
    # And the downstream comprehension must read from _wv_p074_qa, not from widgets_values
    assert '(_wv_p074_qa or {}).get("_vov_user_new_entities")' in qa_fn, (
        "the comprehension must read _vov_user_new_entities from _wv_p074_qa"
    )


def test_pre_v107_head_would_have_failed():
    """Anti-tautology check (§8.10): without the v1.0.7 fix, the QA loop's L5952
    references bare `widgets_values` — confirm the OLD pattern is gone so a future
    regressor that re-introduces it would be caught.

    We assert the OLD bug pattern is absent."""
    nb = _load_nb_source()
    qa_src = _qa_function_source(nb)
    qa_fn = _slice_function(qa_src, "run_quality_assurance_checks")
    OLD_BUG = '(widgets_values or {}).get("_vov_user_new_entities")'
    assert OLD_BUG not in qa_fn, (
        f"v1.0.7 must remove the v0.7.4 bug pattern: {OLD_BUG!r}"
    )


def test_qa_function_signature_does_not_take_widgets_values():
    """Documenting the invariant: the function signature MUST NOT silently grow a
    widgets_values parameter to 'fix' this bug, because every caller would need to
    pass it. The fix is config-routing, not signature-changing."""
    nb = _load_nb_source()
    qa_src = _qa_function_source(nb)
    sig_match = re.search(r'def\s+run_quality_assurance_checks\(([^)]*)\)', qa_src)
    assert sig_match is not None
    sig = sig_match.group(1)
    assert "widgets_values" not in sig, (
        "run_quality_assurance_checks signature must NOT take widgets_values; "
        "every widgets-values access must route through config._widgets_values."
    )


def test_canonical_pattern_used_at_l5798_unchanged():
    """Defense-in-depth: confirm the pre-existing L5798 canonical pattern still exists
    and the v1.0.7 fix simply mirrors it. If this disappears, the whole function is at risk."""
    nb = _load_nb_source()
    qa_src = _qa_function_source(nb)
    qa_fn = _slice_function(qa_src, "run_quality_assurance_checks")
    assert '(config.get("_widgets_values") or {})' in qa_fn, (
        "the canonical config._widgets_values pattern must remain present in QA function"
    )


def test_simulate_namebinding_in_isolated_scope():
    """Behavioral simulation: synthesize the post-v1.0.7 expression as a single
    expression and eval it in an isolated namespace where `widgets_values` is NOT
    defined but `config` IS. The fix must NOT raise NameError. This proves the
    runtime semantics changed on v1.0.7 (vs the pre-v1.0.7 form which raises)."""
    code = (
        '_wv_p074_qa = (config.get("_widgets_values") or {})\n'
        '_vov_new_domain_names_qa = {'
        '(t[0] if isinstance(t, (tuple, list)) and len(t) == 1 else str(t)).lower() '
        'for t in ((_wv_p074_qa or {}).get("_vov_user_new_entities") or set()) if t}\n'
    )
    ns = {"config": {"_widgets_values": {"_vov_user_new_entities": {("foo",), "bar"}}}}
    try:
        exec(code, ns)
    except NameError as e:
        if "widgets_values" in str(e):
            raise AssertionError(
                f"v1.0.7 fix is incomplete — bare widgets_values still raises NameError: {e}"
            )
        raise
    assert ns["_vov_new_domain_names_qa"] == {"foo", "bar"}, ns["_vov_new_domain_names_qa"]


def test_simulate_pre_v107_would_raise_nameerror():
    """Anti-tautology counter-test (§8.3): verify that the OLD pattern, in the same
    isolated namespace, raises NameError. Without this, the fix could be a no-op."""
    OLD_CODE = (
        '_vov_new_domain_names_qa = {'
        '(t[0] if isinstance(t, (tuple, list)) and len(t) == 1 else str(t)).lower() '
        'for t in ((widgets_values or {}).get("_vov_user_new_entities") or set()) if t}'
    )
    ns = {"config": {"_widgets_values": {"_vov_user_new_entities": set()}}}
    try:
        exec(OLD_CODE, ns)
    except NameError as e:
        assert "widgets_values" in str(e), f"unexpected NameError: {e}"
        return
    raise AssertionError(
        "OLD pre-v1.0.7 code must raise NameError without widgets_values defined; "
        "if this test passes silently, the v1.0.7 fix is a no-op tautology."
    )


def test_v106_sentinel_still_present():
    """v1.0.6 division-filter-user-domain-bypass must remain (no regression of prior fix)."""
    with open(NB_PATH) as f:
        raw = f.read()
    assert "[division-filter-user-domain-bypass FIRED v1.0.6]" in raw, (
        "v1.0.6 sentinel must remain in agent notebook"
    )
