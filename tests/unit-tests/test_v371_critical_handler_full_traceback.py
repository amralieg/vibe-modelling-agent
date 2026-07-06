"""Behavioral tests for v3.7.1 alias=critical-handler-full-traceback.

ROOT CAUSE this fixes: the top-level pipeline exception handler logged ONLY
`short_error` (first line of str(e)) via logger.critical, plus
`error_details=f"[{error_type}] {str(e)[:2000]}"` to VibeWriter. For an
AttributeError the message is just "'str' object has no attribute 'get'" with NO
file:line frame. So when gov_transport v3.7.0 (run <run_id> @ <profile>) crashed with
exactly that AttributeError inside step_create_logical_schema, the raising frame
was never written to the error log and the bug could not be root-caused.

THE FIX: the handler now also logs `traceback.format_exc()`, so any future crash
(this run / healthcare / the 13-industry marathon) writes the exact raising frame
for deterministic RCA.

Test 1 (structural / shipped-proof): the notebook's top-level except block contains
the FIRED marker AND logs traceback.format_exc via logger.critical.
Test 2 (behavioral / mechanism-proof): the format_exc() pattern, run inside an
except that catches the EXACT BUG-B exception raised from a NESTED helper, yields a
string containing the exception type, the 'Traceback' header, AND the raising
function name + the .get() source line. This proves the new log line surfaces the
site that the old short_error path hid.
"""
import json
import os
import re
import traceback

NB = os.path.join(os.path.dirname(__file__), "..", "..", "agent", "dbx_vibe_modelling_agent.ipynb")


def _src():
    nb = json.load(open(NB))
    return "".join("".join(c["source"]) for c in nb["cells"] if c.get("cell_type") == "code")


def test_notebook_critical_handler_logs_full_traceback():
    """STRUCTURAL — the shipped notebook critical handler logs format_exc with the FIRED marker."""
    src = _src()
    # the FIRED marker must exist
    assert "critical-handler-full-traceback FIRED" in src, "FIRED marker missing from notebook"
    # it must be wired to format_exc via a critical log, in the SAME region as the existing
    # 'A critical error occurred' top-level handler (not some unrelated site).
    m = re.search(r"A critical error occurred, halting execution\.[\s\S]{0,800}?critical-handler-full-traceback FIRED[\s\S]{0,200}?format_exc\(\)", src)
    assert m, "format_exc not logged within the top-level critical handler block"


def _level3_raises_bugb(x):
    # mirrors the BUG-B failure: code expects a dict variant but got a str and calls .get()
    return x.get("name")


def _level2(x):
    return _level3_raises_bugb(x)


def test_format_exc_surfaces_bugb_raising_frame():
    """BEHAVIORAL — format_exc() captures the exact raising frame for the BUG-B exception,
    which the OLD short_error path (str(e) only) would NOT have contained."""
    captured = {}

    class _Log:
        def critical(self, m):
            captured["msg"] = m

    log = _Log()
    bad_variant = "this is a bare string, not a dict"  # the BUG-B condition
    try:
        _level2(bad_variant)
    except Exception as e:
        error_type = type(e).__name__
        short_error = str(e).splitlines()[0][:500]
        # OLD behavior (what the handler used to log) — assert it HIDES the site
        old_line = f"A critical error occurred, halting execution. [{error_type}] {short_error}"
        assert "_level3_raises_bugb" not in old_line
        assert "Traceback" not in old_line
        # NEW behavior (the fix) — full traceback to logger.critical
        log.critical(f"[critical-handler-full-traceback FIRED] full traceback follows:\n{traceback.format_exc()}")

    msg = captured.get("msg", "")
    assert "AttributeError" in msg, msg
    assert "'str' object has no attribute 'get'" in msg, msg
    assert "Traceback (most recent call last)" in msg, msg
    # the exact raising frame + the offending source line are now visible
    assert "_level3_raises_bugb" in msg, "raising frame name missing from traceback"
    assert "x.get(" in msg, "offending source line missing from traceback"
