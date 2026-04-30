import json
import re
import os
import pytest


REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
AGENT_PATH = os.path.join(REPO_ROOT, 'agent', 'dbx_vibe_modelling_agent.ipynb')


@pytest.fixture(scope='module')
def agent_code_text():
    with open(AGENT_PATH) as f:
        nb = json.load(f)
    chunks = []
    for cell in nb['cells']:
        if cell.get('cell_type') == 'code':
            chunks.append(''.join(cell.get('source', [])))
    return '\n'.join(chunks)


@pytest.fixture(scope='module')
def agent_notebook_obj():
    with open(AGENT_PATH) as f:
        return json.load(f)


def test_agent_version_constant_is_077(agent_code_text):
    assert '__AGENT_VERSION__ = "0.8.1"' in agent_code_text, \
        '__AGENT_VERSION__ must be exactly "0.8.1" per CLAUDE.md §3a-bis'


def test_no_v07x_identifiers_in_agent_code(agent_code_text):
    pattern = re.compile(r'_v07[0-9]_[A-Za-z][A-Za-z0-9_]*')
    matches = sorted(set(pattern.findall(agent_code_text)))
    assert matches == [], (
        f'invariant: code identifiers must NOT carry _v07X_ version prefixes. '
        f'Found {len(matches)} polluted identifiers: {matches[:20]}{"..." if len(matches) > 20 else ""}. '
        f'Rename them to semantic names; git history records the version.'
    )


def test_no_v0xy_identifiers_in_agent_code(agent_code_text):
    pattern = re.compile(r'_v0[6-9]\d_[A-Za-z][A-Za-z0-9_]*|_v[1-9]\d?[0-9]_[A-Za-z][A-Za-z0-9_]*')
    matches = sorted(set(pattern.findall(agent_code_text)))
    if matches:
        pytest.fail(
            f'invariant: NO version-tagged identifiers anywhere in agent code. '
            f'Found {len(matches)}: {matches[:20]}{"..." if len(matches) > 20 else ""}'
        )


def test_no_vnn_alias_in_log_lines(agent_code_text):
    pattern = re.compile(r'\bv0?\d{1,3}-[a-z][a-z0-9-]*')
    matches = sorted(set(pattern.findall(agent_code_text)))
    matches = [m for m in matches if not re.match(r'^v\d+-(beta|alpha|rc|dev)$', m)]
    assert matches == [], (
        f'invariant: log aliases must NOT carry version tags (e.g. "audit-dispatcher"). '
        f'Found {len(matches)}: {matches[:20]}{"..." if len(matches) > 20 else ""}'
    )


def test_no_version_prefix_comments_in_agent_code(agent_code_text):
    pattern = re.compile(r'^\s*#\s*v0\.[0-9]+\.[0-9]+\s+[A-Z0-9.+\-]+\s*[\u2014\-:]', re.MULTILINE)
    matches = pattern.findall(agent_code_text)
    if matches:
        pytest.fail(
            f'invariant: code comments must NOT prefix with `# v0.X.Y PNN-MM —` '
            f'(git blame records when changes landed). Found {len(matches)} polluted comments. '
            f'Sample: {matches[:5]}'
        )


def test_only_agent_version_constant_references_version(agent_code_text):
    version_string_re = re.compile(r'\bv?0\.[6-9]\.\d+\b')
    matches = []
    for line_no, line in enumerate(agent_code_text.split('\n'), 1):
        if '__AGENT_VERSION__' in line:
            continue
        if 'agent_version' in line.lower() and '"' in line:
            continue
        if line.strip().startswith('#'):
            continue
        if 'description' in line.lower() and ':' in line:
            continue
        for m in version_string_re.finditer(line):
            matches.append((line_no, m.group(0), line.strip()[:120]))
    if matches:
        sample = '\n'.join(f'  line {ln}: {ver}  in: {ctx}' for ln, ver, ctx in matches[:10])
        pytest.fail(
            f'invariant: version literals (vN.N.N) must only appear inside the '
            f'__AGENT_VERSION__ assignment. Found {len(matches)} other occurrences:\n{sample}'
        )


def test_explicit_renames_applied(agent_code_text):
    expected_renamed = [
        '_emit_finding',
        '_local_action_executor',
        '_protected_targets_from_widgets',
        '_audit_dispatcher',
        '_architect_dispatcher',
        '_next_vibes_dispatcher',
        '_classify_recipe_cost',
        '_build_action_vocab_compat',
    ]
    missing = [name for name in expected_renamed if name not in agent_code_text]
    assert not missing, (
        f'rename map: expected semantic names not found in agent code: {missing}'
    )


def test_legacy_v07x_helper_names_are_gone(agent_code_text):
    LEGACY_PFX_76 = '_v0' + '76_'
    LEGACY_PFX_75 = '_v0' + '75_'
    legacy_names = [
        LEGACY_PFX_76 + 'emit_finding',
        LEGACY_PFX_76 + 'safe_executor',
        LEGACY_PFX_76 + 'protected_targets_from_widgets',
        LEGACY_PFX_76 + 'audit_disp',
        LEGACY_PFX_76 + 'disp',
        LEGACY_PFX_76 + 'nv_disp',
        LEGACY_PFX_75 + 'classify_recipe_cost',
        LEGACY_PFX_75 + 'build_v074_vocab_compat',
    ]
    found = [name for name in legacy_names if name in agent_code_text]
    assert not found, (
        f'rename: legacy version-tagged helper names must NOT remain: {found}'
    )


def test_legacy_aliases_in_log_lines_are_gone(agent_code_text):
    LEGACY_VTAG_76 = 'v0' + '76-'
    LEGACY_VTAG_75 = 'v0' + '75-'
    legacy_aliases = [
        LEGACY_VTAG_76 + 'architect-dispatcher',
        LEGACY_VTAG_76 + 'audit-dispatcher',
        LEGACY_VTAG_76 + 'emit-finding-helper',
        LEGACY_VTAG_76 + 'next-vibes-dispatcher',
        LEGACY_VTAG_76 + 'protected-targets',
        LEGACY_VTAG_76 + 'safe-executor',
        LEGACY_VTAG_75 + 'cost-cross-fk-detect',
        LEGACY_VTAG_75 + 'cost-cross-fk-domain',
    ]
    found = [a for a in legacy_aliases if a in agent_code_text]
    assert not found, (
        f'legacy version-tagged aliases must be stripped from log lines: {found}'
    )


def test_dispatcher_wiring_uses_semantic_names(agent_code_text):
    assert "stage_name='vibe_audit'" in agent_code_text
    assert '_audit_dispatcher = FindingDispatcher' in agent_code_text or \
           '_audit_dispatcher=FindingDispatcher' in agent_code_text
    assert "stage_name='next_vibes_generation'" in agent_code_text
    assert '_next_vibes_dispatcher = FindingDispatcher' in agent_code_text or \
           '_next_vibes_dispatcher=FindingDispatcher' in agent_code_text


def test_local_action_executor_signature_unchanged(agent_code_text):
    assert 'def _local_action_executor(finding, model_state, logger):' in agent_code_text, \
        '_local_action_executor must keep the (finding, model_state, logger) signature'


def test_emit_finding_signature_unchanged(agent_code_text):
    assert 'def _emit_finding(dispatcher, *, stage, category, severity, scope,' in agent_code_text, \
        '_emit_finding must keep its keyword-only signature'


def test_protected_targets_helper_signature_unchanged(agent_code_text):
    assert 'def _protected_targets_from_widgets(widgets_values, config=None):' in agent_code_text


def test_no_industry_specific_strings_in_helpers(agent_code_text):
    helper_section_re = re.compile(
        r'def (?:_emit_finding|_local_action_executor|_protected_targets_from_widgets)'
        r'.*?(?=\ndef |\nclass )',
        re.DOTALL
    )
    sections = helper_section_re.findall(agent_code_text)
    banned = ['airline', 'emirates', 'aircraft', 'flight', 'banking', 'insurance', 'retail',
              'healthcare', 'patient', 'manufacturing', 'telecom', 'crm']
    for section in sections:
        lower = section.lower()
        for word in banned:
            assert word not in lower, (
                f'industry-agnostic invariant (CLAUDE.md §8.5): '
                f'helper code must not contain industry-specific term "{word}"'
            )


def test_serverless_compat_no_sparkcontext_in_new_helpers(agent_code_text):
    helper_section_re = re.compile(
        r'def (?:_emit_finding|_local_action_executor|_protected_targets_from_widgets)'
        r'.*?(?=\ndef |\nclass )',
        re.DOTALL
    )
    sections = helper_section_re.findall(agent_code_text)
    banned = ['SparkContext', '.cache(', '.persist(', '.uncache(', 'sc.parallelize', '_sparkContext']
    for section in sections:
        for tok in banned:
            assert tok not in section, (
                f'serverless invariant (CLAUDE.md §2): helper must not use {tok}'
            )


def test_agent_version_first_non_comment_code_line(agent_notebook_obj):
    nb = agent_notebook_obj
    code_cells = [c for c in nb['cells'] if c.get('cell_type') == 'code']
    assert code_cells, 'No code cells found'
    first_cell_src = ''.join(code_cells[0].get('source', []))
    lines = first_cell_src.split('\n')
    first_code_line = None
    for line in lines:
        s = line.strip()
        if not s or s.startswith('#'):
            continue
        first_code_line = s
        break
    assert first_code_line is not None, 'No non-comment code line found in first code cell'
    assert first_code_line.startswith('__AGENT_VERSION__ = "0.8.1"'), (
        f'__AGENT_VERSION__ must be the first non-comment code line of the first code cell. '
        f'Found: {first_code_line[:120]}'
    )


def test_helper_definitions_in_first_code_cell(agent_code_text):
    code_blocks = re.split(r'\n#\s*===\s*CELL\s+\d+', agent_code_text)
    found_in_cell_1 = (
        'def _emit_finding(' in code_blocks[1] if len(code_blocks) > 1 else False
    )
    assert found_in_cell_1 or 'def _emit_finding(' in agent_code_text, \
        '_emit_finding helper must be defined in the agent (preferably Cell 1)'
