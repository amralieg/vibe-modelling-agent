import json
import os
import re

import pytest


REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
AGENT_PATH = os.path.join(REPO_ROOT, 'agent', 'dbx_vibe_modelling_agent.ipynb')


@pytest.fixture(scope='module')
def agent_notebook():
    with open(AGENT_PATH) as f:
        return json.load(f)


@pytest.fixture(scope='module')
def agent_code_text(agent_notebook):
    chunks = []
    for cell in agent_notebook['cells']:
        if cell.get('cell_type') == 'code':
            chunks.append(''.join(cell.get('source', [])))
    return '\n'.join(chunks)


@pytest.fixture(scope='module')
def cell1_code(agent_notebook):
    for cell in agent_notebook['cells']:
        if cell.get('cell_type') == 'code':
            return ''.join(cell.get('source', []))
    raise AssertionError('No code cell found')


def test_agent_version_constant_is_078(agent_code_text):
    assert '__AGENT_VERSION__ = "0.8.0"' in agent_code_text, (
        '__AGENT_VERSION__ must be exactly "0.8.0" per CLAUDE.md §3a-bis '
        '(deploy verification grep target).'
    )


def test_agent_version_is_first_non_comment_statement_in_cell1(cell1_code):
    lines = cell1_code.split('\n')
    seen_first_code_line = False
    for line in lines:
        stripped = line.strip()
        if not stripped:
            continue
        if stripped.startswith('#'):
            continue
        assert stripped.startswith('__AGENT_VERSION__'), (
            f'first non-comment statement in cell 1 must be __AGENT_VERSION__ '
            f'per CLAUDE.md §3a-bis; found instead: {stripped[:120]!r}'
        )
        seen_first_code_line = True
        break
    assert seen_first_code_line, 'cell 1 has no non-comment code'


def test_no_other_version_in_agent_constant_value(agent_code_text):
    matches = re.findall(r'__AGENT_VERSION__\s*=\s*"([^"]+)"', agent_code_text)
    assert matches, '__AGENT_VERSION__ assignment not found'
    for v in matches:
        assert v == '0.8.0', f'all __AGENT_VERSION__ assignments must equal "0.8.0"; found {v!r}'


def test_audit_all_filter_is_strategy_agnostic(agent_code_text):
    src = agent_code_text
    assert 'def audit_all(self,' in src, 'audit_all method must exist on VibeOrchestrator'
    bad_pattern = re.compile(
        r'\.requirements\s*\n\s*if\s+r\.status\s+not\s+in\s+\("fulfilled",\)\s+and\s+r\.verification_strategy\s*==\s*"llm_verify"\s*\]'
    )
    assert not bad_pattern.search(src), (
        'audit_all MUST NOT filter on r.verification_strategy == "llm_verify". '
        'Per v0.7.9 root-cause fix (alias=llm-audit-residual), the LLM safety-net '
        'must consider EVERY unfulfilled requirement regardless of parser-assigned '
        'verification_strategy. The bug this fixes: deterministic-strategy reqs '
        'that the limited deterministic verifier could not match got stuck at '
        'status=partial and never reached the LLM, tanking precision.'
    )


def test_audit_all_uses_strategy_agnostic_filter(agent_code_text):
    src = agent_code_text
    new_pattern = re.compile(
        r'llm_verify_reqs\s*=\s*\[r\s+for\s+r\s+in\s+self\.manifest\.requirements\s*\n\s*if\s+r\.status\s+not\s+in\s+\("fulfilled",\)\]'
    )
    assert new_pattern.search(src), (
        'expected new strategy-agnostic filter `if r.status not in ("fulfilled",)]` '
        'in audit_all (no strategy clause).'
    )


def test_llm_audit_residual_alias_present(agent_code_text):
    assert '[llm-audit-residual FIRED]' in agent_code_text, (
        'v0.7.9 alias=llm-audit-residual must appear at least once in audit_all '
        'as a [FIRED] log line so deploy-verification grep can confirm this fix '
        'is active in the live run logs.'
    )
    fired_count = agent_code_text.count('[llm-audit-residual FIRED]')
    assert fired_count >= 2, (
        f'expected the [llm-audit-residual FIRED] log line in BOTH the no-residual '
        f'and the dispatching branches of audit_all so the alias fires regardless '
        f'of whether there are unfulfilled reqs to audit. Found {fired_count}.'
    )


def test_audit_all_does_not_swap_log_to_silent_no_op(agent_code_text):
    src = agent_code_text
    assert '"[VibeOrchestrator] No LLM-verify requirements to audit"' not in src, (
        'the legacy log line that confused operators ("No LLM-verify reqs") '
        'must be replaced by the new alias-bearing log line so audit-trace is '
        'consistent with the [llm-audit-residual FIRED] sentinel.'
    )


def test_audit_all_still_calls_vibe_audit_prompt(agent_code_text):
    src = agent_code_text
    in_audit_all = src.split('def audit_all(self,', 1)
    assert len(in_audit_all) == 2, 'audit_all method body could not be isolated'
    body = in_audit_all[1].split('def ', 1)[0]
    assert 'PROMPT_TEMPLATES["VIBE_AUDIT_PROMPT"]' in body, (
        'audit_all must still build the VIBE_AUDIT_PROMPT after the v0.7.9 filter widen — '
        'broadening the input set was the only intended behaviour change.'
    )
    assert 'self.ai_agent._call_ai_query' in body, (
        'audit_all must still actually CALL the LLM via self.ai_agent._call_ai_query.'
    )
    for marker in ('mark_fulfilled', 'mark_partial', 'mark_failed'):
        assert marker in body, (
            f'audit_all must still update req status via {marker} based on LLM verdict — '
            f'otherwise broadening the filter has no effect on the scorecard.'
        )


def test_audit_all_response_handler_unchanged(agent_code_text):
    src = agent_code_text
    body = src.split('def audit_all(self,', 1)[1].split('def ', 1)[0]
    pattern = re.compile(r'if\s+status\s*==\s*"fulfilled":\s*\n\s*req\.mark_fulfilled\(evidence,\s*"unified_audit"\)')
    assert pattern.search(body), (
        'response-handling logic in audit_all must still treat LLM verdict "fulfilled" '
        'as authoritative and mark the req fulfilled with evidence.'
    )


def test_no_new_regex_on_vibe_text_added(agent_code_text):
    src = agent_code_text
    new_audit_block = src.split('def audit_all(self,', 1)
    assert len(new_audit_block) == 2
    body = new_audit_block[1].split('def ', 1)[0]
    risky = re.findall(r're\.compile\(|re\.search\(|re\.match\(|re\.findall\(', body)
    assert len(risky) == 0, (
        'v0.7.9 must NOT introduce regex calls inside audit_all — '
        'per CLAUDE.md §3d the LLM is the authoritative interpreter of vibe text. '
        f'Found regex calls: {risky}'
    )


def test_validate_method_still_calls_audit_all(agent_code_text):
    src = agent_code_text
    assert 'self.audit_all(domains, products, attributes)' in src, (
        'validate() must still call self.audit_all(...) at the end. The v0.7.9 fix '
        'broadens the FILTER inside audit_all — the call site is unchanged. '
        'If this assertion fails, the wiring has been broken.'
    )


def test_score_uses_real_fulfilled_count_not_regex_shortcut(agent_code_text):
    src = agent_code_text
    body = src.split('def score(self):', 1)
    assert len(body) == 2
    score_body = body[1].split('def ', 1)[0]
    assert 'len(self.manifest.fulfilled_requirements)' in score_body, (
        'score() must compute fulfilled count from manifest.fulfilled_requirements '
        '— the LLM audit updates these via mark_fulfilled, so removing this would '
        'silently disconnect the v0.7.9 fix from the scorecard.'
    )


def test_v078_marker_in_agent_version_description(cell1_code):
    assert ('v0.7.9' in cell1_code or 'v0.8.0' in cell1_code) and ('audit_all' in cell1_code or 'llm-audit-residual' in cell1_code), (
        '__AGENT_VERSION__ comment must mention v0.7.9 + audit_all so '
        'CHANGELOG-via-version-string and operator audit can confirm the fix '
        'shipped vs the prior 0.7.7 codebase.'
    )
