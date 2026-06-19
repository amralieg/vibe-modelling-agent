import json, ast, os, re, pytest

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _gate_namespace(src_transform=None):
    nb = json.load(open(NB))
    s = "".join(nb["cells"][3]["source"])
    a = s.find("ALLOWED_AST_NODES = frozenset")
    b = s.find("def required_function_present")
    span = s[a:b]
    assert "def validate_ast" in span
    if src_transform:
        span = src_transform(span)
    ns = {"ast": ast}
    class _L:
        def info(self, *a, **k): pass
        def warning(self, *a, **k): pass
    ns["logger"] = _L()
    exec(compile(span, "<gate>", "exec"), ns)
    return ns


# A mutator that uses a LOCAL variable named `nt` (a denylisted module name) and calls .upper().
# This is exactly the live failure: 6x `forbidden module reference: nt.upper` across travel/restaurants.
LOCAL_SHADOW = (
    "def mutator(model, data):\n"
    "    nt = (model or {}).get('x', '')\n"
    "    io = str(nt).strip()\n"
    "    return {'a': nt.upper(), 'b': io.lower()}\n"
)

# Genuine escape attempts that MUST still be rejected.
REAL_OPEN = "def mutator(model, data):\n    return open('/etc/passwd').read()\n"
REAL_OS = "def mutator(model, data):\n    return os.system('rm -rf /')\n"
REAL_SPARK = "def mutator(model, data):\n    return spark.sql('DROP TABLE t')\n"
REAL_DUNDER = "def mutator(model, data):\n    return ().__class__.__bases__\n"


def _prefix_strip_block():
    # Mirror the production import-strip that runs BEFORE validate_ast, so REAL_OS reaches the gate
    # with `os` as a bare name (no import line), exactly like the live sandbox path.
    return None


def test_post_fix_allows_local_shadow_of_module_name():
    ns = _gate_namespace()
    # Must NOT raise: nt/io are locally bound, so .upper()/.lower() are benign string methods.
    ns["validate_ast"](LOCAL_SHADOW)


def test_post_fix_still_rejects_real_escapes():
    ns = _gate_namespace()
    UCE = ns["UnsafeCodeError"]
    with pytest.raises(UCE):
        ns["validate_ast"](REAL_OPEN)      # open() builtin
    with pytest.raises(UCE):
        ns["validate_ast"](REAL_OS)        # os.system, os NOT locally bound
    with pytest.raises(UCE):
        ns["validate_ast"](REAL_SPARK)     # spark bare runtime handle
    with pytest.raises(UCE):
        ns["validate_ast"](REAL_DUNDER)    # dunder escape


def test_pre_fix_would_have_rejected_local_shadow():
    # §8.10: prove the failure mode existed pre-patch. Reconstruct the pre-fix gate by removing the
    # local-binding guard, and assert it FALSE-rejects the benign local `nt.upper()`.
    def to_prefix(span):
        span = span.replace(" and mod not in _v390_local_bound", "")
        return span
    ns = _gate_namespace(src_transform=to_prefix)
    UCE = ns["UnsafeCodeError"]
    with pytest.raises(UCE):
        ns["validate_ast"](LOCAL_SHADOW)


if __name__ == "__main__":
    test_pre_fix_would_have_rejected_local_shadow()
    print("PRE-FIX: local-shadow rejected (failure mode reproduced) OK")
    test_post_fix_allows_local_shadow_of_module_name()
    print("POST-FIX: local-shadow allowed OK")
    test_post_fix_still_rejects_real_escapes()
    print("POST-FIX: real escapes still rejected OK")
    print("ALL PASS")
