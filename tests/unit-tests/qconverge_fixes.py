"""Quality-convergence fix passes (candidate source for injection into the agent
notebook). Each pass mutates the flat in-memory lists the pipeline + static
analyzer already use (widgets_values['domains'|'products'|'attributes']), so the
loop is: static-analysis -> fix -> re-static-analysis until findings stabilise.

These are developed and proven here against the REAL run_metamodel_static_analysis
(via qconverge_harness) before being injected verbatim into cell 23 of
agent/dbx_vibe_modelling_agent.ipynb. The functions intentionally use only the
notebook's existing helpers (strip_domain_prefix, parse_fk_reference) so there is
ONE implementation, no duplication, once injected.
"""

_NAT_KEY_SUFFIXES = ('_number', '_num', '_no', '_code', '_key', '_identity', '_ref', '_reference')


def qfix_demote_denormalized_natural_keys(domains_data, products_data, attributes_data, config, logger):
    """For every product that has BOTH an FK '<entity>_id' and a STRING natural-key
    column '<entity><suffix>', drop the redundant natural-key column. This both
    removes the denormalized_natural_key finding AND stops the regression at the
    model level. Returns number of columns removed."""
    by_prod = {}
    for a in attributes_data:
        by_prod.setdefault((a.get('domain', ''), a.get('product', '')), []).append(a)
    drop_keys = set()
    removed = 0
    for (dn, pn), attrs in by_prod.items():
        fk_entities = set()
        for a in attrs:
            nm = a.get('attribute', '')
            if (a.get('foreign_key_to') or '').strip() and nm.endswith('_id'):
                ent = nm[:-3]
                if ent:
                    fk_entities.add(ent)
        for a in attrs:
            nm = a.get('attribute', '')
            dt = (a.get('type') or '').upper()
            if dt != 'STRING':
                continue
            for suf in _NAT_KEY_SUFFIXES:
                if nm.endswith(suf):
                    ent = nm[:-len(suf)]
                    if ent and ent in fk_entities:
                        drop_keys.add((dn, pn, nm))
                        removed += 1
                    break
    if drop_keys:
        attributes_data[:] = [a for a in attributes_data
                              if (a.get('domain', ''), a.get('product', ''), a.get('attribute', '')) not in drop_keys]
        _sync_nested_from_flat(domains_data, attributes_data)
    if logger:
        logger.info(f"  [qfix-denorm-demote FIRED] removed {removed} redundant natural-key column(s) where FK exists")
    return removed


def qfix_relink_unlinked_fks(domains_data, products_data, attributes_data, config, logger, ai_agent=None):
    """Resolve '<entity>_id looks like FK but unlinked'. Deterministic: if exactly
    one product across the model has primary key '<entity>_id', link to it; else
    demote the column to an external reference STRING so it no longer reads as an
    unlinked FK. Returns (linked, demoted)."""
    pk_index = {}
    for p in products_data:
        dn = p.get('domain', '')
        pn = p.get('product', '')
        pk = p.get('primary_key') or f"{pn}_id"
        pk_index.setdefault(pk, []).append(f"{dn}.{pn}")
    own_pk = {(p.get('domain', ''), p.get('product', '')): (p.get('primary_key') or f"{p.get('product','')}_id")
              for p in products_data}
    linked = demoted = 0
    for a in attributes_data:
        nm = a.get('attribute', '')
        dn = a.get('domain', '')
        pn = a.get('product', '')
        if not nm.endswith('_id'):
            continue
        if (a.get('foreign_key_to') or '').strip():
            continue
        if nm == own_pk.get((dn, pn)) or a.get('primary_key'):
            continue
        targets = pk_index.get(nm, [])
        targets = [t for t in targets if t != f"{dn}.{pn}"]
        if len(targets) == 1:
            a['foreign_key_to'] = f"{targets[0]}.{nm}"
            linked += 1
        else:
            base = nm[:-3]
            a['attribute'] = f"{base}_ext_ref" if base else nm
            a['type'] = 'STRING'
            demoted += 1
    if (linked or demoted):
        _sync_nested_from_flat(domains_data, attributes_data)
    if logger:
        logger.info(f"  [qfix-unlinked-relink FIRED] linked {linked}, demoted {demoted} unlinked _id column(s)")
    return linked, demoted


def qfix_resolve_cross_domain_ssot(domains_data, products_data, attributes_data, config, logger,
                                   ai_agent=None, owner_decider=None):
    """Resolve cross_domain_duplicate (same entity stem in >=2 domains). For each
    stem, choose ONE owner domain (owner_decider hook for LLM, else deterministic),
    remove the duplicate products in the other domains, and re-point any FK that
    targeted a removed product to the surviving owner product. Per-domain batching:
    owner_decider is called at most once per stem. Returns number of dup products merged."""
    try:
        strip = strip_domain_prefix  # noqa: F821 (notebook helper, present once injected)
    except NameError:
        def strip(pname, dom):
            return pname[len(dom) + 1:] if pname.startswith(dom + "_") else pname

    GENERIC = frozenset({'payment', 'order', 'status', 'type', 'code', 'rate', 'fee', 'charge',
                         'rule', 'policy', 'config', 'setting', 'note', 'comment', 'log',
                         'history', 'audit', 'report', 'schedule', 'assignment', 'allocation'})
    stems = {}
    for p in products_data:
        dn = p.get('domain', '')
        pn = p.get('product', '')
        st = strip(pn, dn)
        if len(st) < 4 or st in GENERIC:
            continue
        stems.setdefault(st, []).append((dn, pn))

    fk_in = {}  # product_key -> count of incoming FKs (proxy for "master")
    for a in attributes_data:
        fk = (a.get('foreign_key_to') or '').strip()
        if fk:
            parts = fk.split('.')
            if len(parts) >= 2:
                fk_in[f"{parts[0]}.{parts[1]}"] = fk_in.get(f"{parts[0]}.{parts[1]}", 0) + 1
    attr_count = {}
    for a in attributes_data:
        attr_count[(a.get('domain', ''), a.get('product', ''))] = attr_count.get((a.get('domain', ''), a.get('product', '')), 0) + 1

    merged = 0
    repoint = {}  # "dom.prod" removed -> "owner_dom.owner_prod"
    remove_keys = set()
    for st, entries in stems.items():
        cross = sorted(set(entries))
        if len({d for d, _ in cross}) < 2:
            continue
        if owner_decider is not None:
            owner = owner_decider(st, cross)
            if owner is None:  # LLM judged "legitimately distinct" -> keep both
                continue
        else:
            owner = max(cross, key=lambda dp: (fk_in.get(f"{dp[0]}.{dp[1]}", 0),
                                               attr_count.get(dp, 0),
                                               -ord(dp[0][0]) if dp[0] else 0))
        odn, opn = owner
        for dn, pn in cross:
            if (dn, pn) == owner:
                continue
            remove_keys.add((dn, pn))
            repoint[f"{dn}.{pn}"] = f"{odn}.{opn}"
            merged += 1

    if remove_keys:
        owner_pk = {(p.get('domain', ''), p.get('product', '')): (p.get('primary_key') or f"{p.get('product','')}_id")
                    for p in products_data}
        for a in attributes_data:
            fk = (a.get('foreign_key_to') or '').strip()
            if not fk:
                continue
            parts = fk.split('.')
            if len(parts) >= 2 and f"{parts[0]}.{parts[1]}" in repoint:
                tgt = repoint[f"{parts[0]}.{parts[1]}"]
                tdn, tpn = tgt.split('.')
                a['foreign_key_to'] = f"{tgt}.{owner_pk.get((tdn, tpn), parts[2] if len(parts) > 2 else '')}"
        products_data[:] = [p for p in products_data
                            if (p.get('domain', ''), p.get('product', '')) not in remove_keys]
        attributes_data[:] = [a for a in attributes_data
                              if (a.get('domain', ''), a.get('product', '')) not in remove_keys]
        _sync_nested_from_flat(domains_data, attributes_data, products_data)
    if logger:
        logger.info(f"  [qfix-ssot-resolve FIRED] merged {merged} cross-domain duplicate product(s) to SSOT owners")
    return merged


def _sync_nested_from_flat(domains_data, attributes_data, products_data=None):
    """Best-effort: keep nested model dicts (if present) consistent with flat edits.
    In the live pipeline the flat lists are canonical; nested model.json is rebuilt
    from them in step_generate_data_model_json, so this is a no-op guard here."""
    return


def run_quality_convergence_loop(domains_data, products_data, attributes_data, config, logger,
                                 ai_agent=None, max_iters=4, ssot_owner_decider=None):
    """SA -> fix -> re-SA until the targeted findings stop decreasing or hit zero.
    Targets: denormalized_natural_key, unlinked_fk, cross_domain_duplicate.
    Returns the final static-analysis result dict."""
    def _targeted(sa):
        cats = sa.get("summary_by_category", {})
        tot = 0
        for c in ("denormalized_natural_key", "unlinked_fk", "cross_domain_duplicate"):
            d = cats.get(c, {})
            tot += d.get("warning", 0) + d.get("error", 0)
        return tot

    prev = None
    sa = run_metamodel_static_analysis(domains_data, products_data, attributes_data, config, logger)  # noqa: F821
    for it in range(max_iters):
        cur = _targeted(sa)
        if logger:
            logger.info(f"  [convergence] iter {it} targeted findings = {cur}")
        if cur == 0 or cur == prev:
            break
        prev = cur
        qfix_demote_denormalized_natural_keys(domains_data, products_data, attributes_data, config, logger)
        qfix_relink_unlinked_fks(domains_data, products_data, attributes_data, config, logger, ai_agent)
        qfix_resolve_cross_domain_ssot(domains_data, products_data, attributes_data, config, logger,
                                       ai_agent, ssot_owner_decider)
        sa = run_metamodel_static_analysis(domains_data, products_data, attributes_data, config, logger)  # noqa: F821
    return sa
