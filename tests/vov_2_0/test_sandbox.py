import pytest
from agent.vov_2_0.sandbox import (
    UnsafeCodeError,
    execute_in_sandbox,
    required_function_present,
    validate_ast,
)


SAFE_NOOP_MUTATOR = """def mutator(model, data):
    return model
"""

SAFE_NOOP_VERIFIER = """def verifier(model, data):
    return (True, "")
"""


def test_validate_safe_noop():
    validate_ast(SAFE_NOOP_MUTATOR)
    validate_ast(SAFE_NOOP_VERIFIER)


def test_validate_real_mutator_fk_addition():
    src = """def mutator(model, data):
    mdl = model.get("model", model)
    for d in mdl.get("domains", []):
        if d.get("name") == "encounter":
            for p in d.get("products", []):
                for a in p.get("attributes", []):
                    if a.get("name") == "patient_id" and not a.get("foreign_key_to"):
                        a["foreign_key_to"] = "patient.patient.patient_id"
    return model
"""
    validate_ast(src)


def test_reject_import_statement():
    src = "import os\ndef mutator(model, data):\n    return model\n"
    with pytest.raises(UnsafeCodeError):
        validate_ast(src)


def test_reject_open_call():
    src = """def mutator(model, data):
    f = open("/etc/passwd")
    return model
"""
    with pytest.raises(UnsafeCodeError):
        validate_ast(src)


def test_reject_eval_call():
    src = """def mutator(model, data):
    return eval("model")
"""
    with pytest.raises(UnsafeCodeError):
        validate_ast(src)


def test_reject_exec_call():
    src = """def mutator(model, data):
    exec("model['x'] = 1")
    return model
"""
    with pytest.raises(UnsafeCodeError):
        validate_ast(src)


def test_reject_dunder_attribute_access():
    src = """def mutator(model, data):
    return model.__class__.__bases__
"""
    with pytest.raises(UnsafeCodeError):
        validate_ast(src)


def test_reject_dunder_import():
    src = """def mutator(model, data):
    m = __import__("os")
    return model
"""
    with pytest.raises(UnsafeCodeError):
        validate_ast(src)


def test_reject_globals_access():
    src = """def mutator(model, data):
    g = globals()
    return model
"""
    with pytest.raises(UnsafeCodeError):
        validate_ast(src)


def test_reject_subprocess_via_attr():
    src = """def mutator(model, data):
    return os.system("ls")
"""
    with pytest.raises(UnsafeCodeError):
        validate_ast(src)


def test_reject_re_undocumented_method():
    src = """def mutator(model, data):
    return re.purge()
"""
    with pytest.raises(UnsafeCodeError):
        validate_ast(src)


def test_allow_re_search():
    src = """def mutator(model, data):
    if re.search("foo", "foobar"):
        return model
    return model
"""
    validate_ast(src)


def test_allow_json_dumps():
    src = """def mutator(model, data):
    s = json.dumps(model)
    return json.loads(s)
"""
    validate_ast(src)


def test_allow_copy_deepcopy():
    src = """def mutator(model, data):
    return copy.deepcopy(model)
"""
    validate_ast(src)


def test_required_function_present():
    src = "def mutator(model, data):\n    return model\n"
    assert required_function_present(src, "mutator")
    assert not required_function_present(src, "verifier")


def test_required_function_present_invalid_syntax():
    assert not required_function_present("def mutator(:\n", "mutator")


def test_execute_safe_noop_returns_model():
    model = {"agent_version": "2.0.0", "model": {"domains": []}}
    result = execute_in_sandbox(SAFE_NOOP_MUTATOR, SAFE_NOOP_VERIFIER, model)
    assert result.ok, f"sandbox refused safe code: {result.error}"
    assert result.new_model == model
    assert result.verifier_ok


def test_execute_actual_mutation_idempotent():
    model = {"model": {"domains": [{"name": "patient", "products": [
        {"name": "patient", "attributes": [{"name": "patient_id", "type": "BIGINT", "tags": ""}]}
    ]}]}}

    mutator = """def mutator(model, data):
    for d in model["model"]["domains"]:
        for p in d.get("products", []):
            for a in p.get("attributes", []):
                tags = a.get("tags", "") or ""
                if "pii=true" not in tags.split(","):
                    a["tags"] = (tags + ",pii=true") if tags else "pii=true"
    return model
"""
    verifier = """def verifier(model, data):
    for d in model["model"]["domains"]:
        for p in d.get("products", []):
            for a in p.get("attributes", []):
                if "pii=true" not in (a.get("tags", "") or "").split(","):
                    return (False, "missing pii=true on " + a.get("name", ""))
    return (True, "")
"""
    r1 = execute_in_sandbox(mutator, verifier, model)
    assert r1.ok
    assert r1.verifier_ok
    assert "pii=true" in r1.new_model["model"]["domains"][0]["products"][0]["attributes"][0]["tags"]

    r2 = execute_in_sandbox(mutator, verifier, r1.new_model)
    assert r2.ok
    assert r2.verifier_ok
    assert r2.new_model["model"]["domains"][0]["products"][0]["attributes"][0]["tags"].count("pii=true") == 1


def test_execute_blocks_unsafe_at_validation():
    bad_mutator = """def mutator(model, data):
    f = open("/etc/passwd")
    return model
"""
    result = execute_in_sandbox(bad_mutator, SAFE_NOOP_VERIFIER, {})
    assert not result.ok
    assert "unsafe_ast" in (result.error or "")


def test_execute_subprocess_does_not_inherit_env():
    leaky_mutator = """def mutator(model, data):
    return {"leaked": "should not happen"}
"""
    leaky_verifier = """def verifier(model, data):
    return (True, "")
"""
    import os
    os.environ["VOV_SECRET"] = "topsecret"
    try:
        result = execute_in_sandbox(leaky_mutator, leaky_verifier, {})
        assert result.ok
        assert result.new_model == {"leaked": "should not happen"}
    finally:
        del os.environ["VOV_SECRET"]


def test_subprocess_timeout():
    slow_mutator = """def mutator(model, data):
    x = 0
    for i in range(10**10):
        x = x + 1
    return model
"""
    result = execute_in_sandbox(slow_mutator, SAFE_NOOP_VERIFIER, {}, timeout=2.0)
    assert not result.ok
    assert "timeout" in (result.error or "").lower() or "exit" in (result.error or "").lower()


def test_missing_mutator_function_rejected():
    src_no_mutator = """def helper(model, data):
    return model
"""
    result = execute_in_sandbox(src_no_mutator, SAFE_NOOP_VERIFIER, {})
    assert not result.ok
    assert "mutator" in (result.error or "")


def test_missing_verifier_function_rejected():
    result = execute_in_sandbox(SAFE_NOOP_MUTATOR, "def helper():\n    return None\n", {})
    assert not result.ok
    assert "verifier" in (result.error or "")


def test_verifier_failure_does_not_block_execution():
    verifier_returns_false = """def verifier(model, data):
    return (False, "intentional failure to flag retry")
"""
    result = execute_in_sandbox(SAFE_NOOP_MUTATOR, verifier_returns_false, {"x": 1})
    assert result.ok
    assert not result.verifier_ok
    assert "intentional" in result.verifier_diag


def test_verifier_exception_caught():
    verifier_raises = """def verifier(model, data):
    return ({}["missing"], "won't reach")
"""
    result = execute_in_sandbox(SAFE_NOOP_MUTATOR, verifier_raises, {})
    assert result.ok
    assert not result.verifier_ok
    assert "raised" in result.verifier_diag.lower()


def test_data_payload_passed_to_mutator():
    src = """def mutator(model, data):
    if data and len(data) > 0:
        model["last_data_keys"] = sorted(list(data[0].keys()))
    return model
"""
    verifier = """def verifier(model, data):
    return ("last_data_keys" in model, model.get("last_data_keys", "missing"))
"""
    result = execute_in_sandbox(src, verifier, {}, data=[{"a": 1, "b": 2}])
    assert result.ok
    assert result.verifier_ok
    assert result.new_model["last_data_keys"] == ["a", "b"]


def test_mutator_returning_none_keeps_model():
    src = """def mutator(model, data):
    model["touched"] = True
    return None
"""
    verifier = """def verifier(model, data):
    return (model.get("touched") is True, "expected touched=True")
"""
    result = execute_in_sandbox(src, verifier, {})
    assert result.ok
    assert result.verifier_ok
    assert result.new_model["touched"] is True


def test_dict_comprehension_allowed():
    src = """def mutator(model, data):
    model["lookup"] = {str(i): i*2 for i in range(5)}
    return model
"""
    verifier = """def verifier(model, data):
    return (len(model.get("lookup", {})) == 5, "len wrong")
"""
    r = execute_in_sandbox(src, verifier, {})
    assert r.ok and r.verifier_ok


def test_lambda_allowed():
    src = """def mutator(model, data):
    sq = lambda x: x*x
    model["s9"] = sq(9)
    return model
"""
    verifier = """def verifier(model, data):
    return (model.get("s9") == 81, "")
"""
    r = execute_in_sandbox(src, verifier, {})
    assert r.ok and r.verifier_ok


def test_print_does_not_break():
    src = """def mutator(model, data):
    print("debug")
    return model
"""
    r = execute_in_sandbox(src, SAFE_NOOP_VERIFIER, {})
    assert r.ok


def test_writes_to_filesystem_blocked_via_validation():
    src = """def mutator(model, data):
    fh = open("/tmp/leak.txt", "w")
    fh.write("oops")
    fh.close()
    return model
"""
    with pytest.raises(UnsafeCodeError):
        validate_ast(src)


def test_circular_reference_in_data_handled():
    src = """def mutator(model, data):
    return {"k": list(range(3))}
"""
    verifier = """def verifier(model, data):
    return (model.get("k") == [0,1,2], "")
"""
    r = execute_in_sandbox(src, verifier, {})
    assert r.ok and r.verifier_ok
