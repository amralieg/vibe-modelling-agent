# Databricks notebook source
# Serverless diagnostic v3: replicate the AGENT's EXACT mkdirs pattern
# (_io_with_timeout daemon worker + _suppress_dbutils_stdout lock + the subfolder loop)
# on the real new-base-model TARGET_VOLUME path. Returns per-step timing via notebook.exit.
import json, time, threading, io, sys, os, contextlib

R = {}
_suppress_stdout_lock = threading.Lock()

@contextlib.contextmanager
def _suppress_dbutils_stdout():
    acquired = _suppress_stdout_lock.acquire(timeout=30)
    if not acquired:
        yield
        return
    _orig = sys.stdout
    sys.stdout = io.StringIO()
    try:
        yield
    finally:
        sys.stdout = _orig
        _suppress_stdout_lock.release()

def _io_with_timeout(fn, timeout_s, logger=None, label="io"):
    import threading as _iot
    _box = {"done": False, "val": None, "exc": None}
    def _run():
        try:
            _box["val"] = fn()
        except BaseException as _e:
            _box["exc"] = _e
        finally:
            _box["done"] = True
    _t = _iot.Thread(target=_run, name=f"io-timeout-{label}", daemon=True)
    _t.start()
    _t.join(timeout_s)
    if not _box["done"]:
        return None, True
    if _box["exc"] is not None:
        raise _box["exc"]
    return _box["val"], False

VOL = "/Volumes/vibe_gov_transport_basemvm/_metamodel/vol_root"
TARGET = f"{VOL}/business/diagv3_{int(time.time())}/v1/mvm"

# warmup
t0=time.time()
try: dbutils.fs.ls(VOL); R["warmup"]={"ok":True,"secs":round(time.time()-t0,2)}
except Exception as e: R["warmup"]={"ok":False,"err":str(e)[:200]}

# replicate the agent rm (TARGET missing -> should raise fast / caught)
def _rm():
    with _suppress_dbutils_stdout():
        dbutils.fs.rm(TARGET, recurse=True)
t0=time.time()
try:
    _, to = _io_with_timeout(_rm, 90, None, "rm")
    R["rm"]={"timed_out":to,"secs":round(time.time()-t0,2)}
except Exception as e:
    R["rm"]={"exc":str(e)[:150],"secs":round(time.time()-t0,2)}

# replicate the agent mkdirs loop EXACTLY
mk={}
for sub in ["schemas","samples","docs","vibes","ontology"]:
    p=f"{TARGET}/{sub}"
    def _mk(_p=p):
        with _suppress_dbutils_stdout():
            dbutils.fs.mkdirs(_p)
    t0=time.time()
    _, to = _io_with_timeout(_mk, 90, None, f"mkdir-{sub}")
    mk[sub]={"timed_out":to,"secs":round(time.time()-t0,2)}
    if to:
        mk[sub]["note"]="HUNG >90s in worker thread"
        break
R["mkdirs"]=mk

try: dbutils.fs.rm(f"{VOL}/business/diagv3_x", recurse=True)
except Exception: pass

dbutils.notebook.exit(json.dumps(R))
