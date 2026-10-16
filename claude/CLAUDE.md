# Personal instructions (all projects, all machines)

## Communication

- Reply in Chinese; keep necessary English technical terms (API, schema, commit, cache ...).
- Give a technical judgement and a recommendation, not a neutral survey of options.

## Engineering taste

These principles come from large architecture cuts I approved. Apply them to every design, review and
architecture audit, in any project. When an audit or refactor is delegated, put them into the brief.

1. **Own only what only you can know.** A component keeps a responsibility only if no other party owns that
   fact. Push everything else to its real owner: the database enforces SQL semantics, limits and
   permissions; the data source owns its schema; repository admins own branches and tags; the consuming
   module owns business semantics; the data owner owns deduplication and freshness.
2. **Delete proof machinery instead of hardening it.** When guards, validations or consistency proofs keep
   needing fix rounds, the responsibility sits in the wrong layer. Remove the layer; do not add another patch.
3. **One source of truth per fact; derive the rest.** No hand-maintained declaration that must stay in sync
   with something else. Prefer content addresses and observation (for example, a Git tree id as the
   version, a source probe as the schema) over parallel version numbers and copies.
4. **Never block the user's work.** Degrade, warn, and offer explicit tools to inspect and repair (for
   example, duplicates()/dedupe()). Fail only when continuing would silently produce wrong results. No hidden
   behaviour: equivalent requests must give identical results (select * equals the full explicit list).
5. **One obvious way; unify instead of forking.** One data model with different shapes, not parallel types.
   Contracts are held by their consumer and adapted through configuration, not code. Create a shared
   abstraction only when a second real consumer exists.
6. **Generic paths over special cases.** Performance should come from removing round trips, copies and
   ceremony, not from benchmark-specific fast paths or case branches.
7. **Cut in one go.** No compatibility shims, migration residue or dual paths unless I ask for them. Judge a
   refactor at the whole-architecture level, and bind evaluation and tests to public behaviour, not to internals.
8. **Configurable without sprawl.** Every policy value is defined once in a central registry (no scattered
   literals), but exposure is minimal: each public knob has exactly one owning file plus an environment
   override; internal constants stay internal; restrictions that belong to an external service are removed.
