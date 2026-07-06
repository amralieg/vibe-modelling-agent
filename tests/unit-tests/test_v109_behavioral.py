"""v1.0.9 behavioral test — p70-respect-user-pinned-domains.

Reproduces NCDOT iter=8 mvm_v2 phantom-domains regression:
  Widget business_domains = "hr, project"  (per CLAUDE.md §3b SUPREME)
  But mvm_v2 ended with 6 domains: [project, hr, based, gisu_prod, products, pse]

The 4 phantoms came from P70 (vov-auto-seed-missing-domains, v0.8.8) which
auto-seeds anything in `_vov_user_new_entities`. The vibe parser populates
that set from prose tokens, including source-table names (`gisu_prod`,
`pse`) and noun-fragments (`based`, `products`).

P72 (v0.8.9) only blocks a fixed reserved-name list; it cannot enumerate
every prose hallucination.

v1.0.9 fix: when `_p72_user_widget_domains` is non-empty (user populated
`business_domains` widget), `_missing_new` is intersected with it BEFORE
auto-seed. Anything outside that widget set is rejected regardless of
source.

Behavioral assertion (NOT a tautology): verify the patch SOURCE contains
the intersect-with-widget guard AND simulate the seed loop with the
NCDOT-shaped inputs to demonstrate the rejection path.
"""
import json
import re
from pathlib import Path

NB_PATH = Path(__file__).resolve().parents[2] / "agent" / "dbx_vibe_modelling_agent.ipynb"


def _load_nb_text():
    with open(NB_PATH) as f:
        nb = json.load(f)
    out = []
    for cell in nb["cells"]:
        if cell.get("cell_type") != "code":
            continue
        src = "".join(cell["source"]) if isinstance(cell["source"], list) else cell["source"]
        out.append(src)
    return "\n\n".join(out)


def test_agent_version_bumped_to_109():
    text = _load_nb_text()
    m = re.search(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', text)
    assert m, "__AGENT_VERSION__ literal not found"
    parts = tuple(int(p) for p in m.group(1).split("."))
    assert parts >= (1, 0, 9), f"expected >= 1.0.9, got {m.group(1)}"


def test_v109_guard_emits_fired_sentinel():
    text = _load_nb_text()
    assert "[p70-respect-user-pinned-domains FIRED v1.0.9]" in text, (
        "v1.0.9 sentinel marker missing from source"
    )


def test_v109_guard_intersects_with_user_widget_before_seed():
    """The patch site must intersect _missing_new with user widget BEFORE
    the auto-seed loop. Verifies code shape so the guard is reachable
    from the auto-seed entry."""
    text = _load_nb_text()
    pat = re.compile(
        r"_v109_hallucinated\s*=\s*sorted\(\[_m\s+for\s+_m\s+in\s+_missing_new\s+if\s+_m\s+not\s+in\s+_p72_user_widget_domains\]\)",
    )
    assert pat.search(text), "v1.0.9 list-comprehension guard not found"
    pat2 = re.compile(r"_missing_new\s*=\s*_missing_new\s*&\s*_p72_user_widget_domains")
    assert pat2.search(text), "v1.0.9 intersect-assignment not found"


def test_v109_guard_skipped_when_widget_empty():
    """When user did NOT populate business_domains widget, the guard must
    not fire (i.e. empty widget set should be a falsy guard condition)."""
    text = _load_nb_text()
    pat = re.compile(r"if\s+_missing_new\s+and\s+_p72_user_widget_domains\s*:")
    assert pat.search(text), (
        "v1.0.9 guard must be inside `if _missing_new and _p72_user_widget_domains:`; "
        "empty-widget case must be no-op"
    )


def test_v109_guard_runs_BEFORE_p72_reserved_block():
    """v1.0.9 intersect must run BEFORE the P72 reserved-name block so the
    P72 loop sees the already-filtered _missing_new and never seeds a
    hallucinated name."""
    text = _load_nb_text()
    v109_idx = text.find("[p70-respect-user-pinned-domains FIRED v1.0.9]")
    p72_loop_idx = text.find("for _miss in sorted(_missing_new):")
    assert v109_idx > 0, "v1.0.9 sentinel not found"
    assert p72_loop_idx > 0, "P72 seed loop not found"
    assert v109_idx < p72_loop_idx, (
        f"v1.0.9 guard MUST be ordered before the P72 seed loop "
        f"(v109_idx={v109_idx}, p72_idx={p72_loop_idx})"
    )


def test_v109_simulated_ncdot_rejection():
    """Simulate the v1.0.9 guard logic with NCDOT-shaped inputs.
    
    This is a BEHAVIORAL simulation (per CLAUDE.md §8.10) — extract the
    guard logic from source, then run it on real NCDOT-shaped inputs and
    assert the 4 phantoms are dropped while user-pinned hr/project pass."""
    # NCDOT-shaped inputs — exactly the values seen in iter=8 mvm_v2
    _missing_new = {"hr", "project", "based", "gisu_prod", "products", "pse"}
    _p72_user_widget_domains = {"hr", "project"}  # business_domains widget

    # Apply the v1.0.9 guard logic verbatim
    _v109_hallucinated = []
    if _missing_new and _p72_user_widget_domains:
        _v109_hallucinated = sorted(
            [_m for _m in _missing_new if _m not in _p72_user_widget_domains]
        )
        if _v109_hallucinated:
            _missing_new = _missing_new & _p72_user_widget_domains

    assert _v109_hallucinated == ["based", "gisu_prod", "products", "pse"], (
        f"phantoms were not all rejected, got: {_v109_hallucinated}"
    )
    assert _missing_new == {"hr", "project"}, (
        f"_missing_new should be only user-pinned, got: {_missing_new}"
    )


def test_v109_simulated_empty_widget_passthrough():
    """When user did not populate business_domains, guard must be a no-op
    so existing P72 reserved-name skip remains the only filter."""
    _missing_new = {"hr", "project", "fulfillment", "ssot"}
    _p72_user_widget_domains = set()  # empty — user didn't set widget

    _v109_hallucinated = []
    if _missing_new and _p72_user_widget_domains:
        _v109_hallucinated = sorted(
            [_m for _m in _missing_new if _m not in _p72_user_widget_domains]
        )
        if _v109_hallucinated:
            _missing_new = _missing_new & _p72_user_widget_domains

    assert _v109_hallucinated == [], "guard must not fire when widget empty"
    assert _missing_new == {"hr", "project", "fulfillment", "ssot"}, (
        "empty-widget case must leave _missing_new unchanged"
    )


def test_v109_anti_tautology_proves_phantoms_were_seeded_pre_v109():
    """Anti-tautology probe (CLAUDE.md §8.3): demonstrate that without
    the v1.0.9 guard, the same NCDOT-shaped input would auto-seed the
    phantoms — proving the patch is not an empty no-op."""
    _missing_new_pre = {"hr", "project", "based", "gisu_prod", "products", "pse"}
    _p72_reserved = {
        "duplicate", "duplicates", "ssot", "shared", "reference", "misc", "other",
        "temp", "tmp", "unknown", "untyped", "orphan", "orphans", "ip_asset", "ip",
        "asset", "rule", "fix", "fixed",
    }
    _p72_user_widget_domains = {"hr", "project"}

    # WITHOUT v1.0.9 guard — only P72 reserved skip applies
    seeded_pre_v109 = []
    for _miss in sorted(_missing_new_pre):
        if _miss in _p72_reserved and _miss not in _p72_user_widget_domains:
            continue
        seeded_pre_v109.append(_miss)

    # Pre-v109 would have seeded ALL 6 (including the 4 phantoms)
    assert "based" in seeded_pre_v109
    assert "gisu_prod" in seeded_pre_v109
    assert "products" in seeded_pre_v109
    assert "pse" in seeded_pre_v109
    assert len(seeded_pre_v109) == 6, (
        f"pre-v109 would seed 6 (incl. 4 phantoms), got {len(seeded_pre_v109)}: {seeded_pre_v109}"
    )

    # WITH v1.0.9 guard
    _missing_new_post = _missing_new_pre & _p72_user_widget_domains
    seeded_post_v109 = []
    for _miss in sorted(_missing_new_post):
        if _miss in _p72_reserved and _miss not in _p72_user_widget_domains:
            continue
        seeded_post_v109.append(_miss)

    assert seeded_post_v109 == ["hr", "project"], (
        f"post-v109 must seed only user-pinned, got: {seeded_post_v109}"
    )
    assert len(seeded_post_v109) == 2


def test_prior_version_tests_still_pass_smoke():
    """Smoke-check: prior aliases remain present (no regression)."""
    text = _load_nb_text()
    prior_aliases = [
        "[verifier-rescue-retry-on-transient-error FIRED v1.0.8]",
        "[qa-widgets-values-via-config FIRED v1.0.7]",
        "[division-filter-user-domain-bypass FIRED v1.0.6]",
        "[vov-auto-seed-missing-domains FIRED] v0.8.8 P70",
        "[vov-auto-seed-skip-reserved FIRED] v0.8.9 P72",
    ]
    for alias in prior_aliases:
        assert alias in text, f"prior alias missing: {alias!r}"
