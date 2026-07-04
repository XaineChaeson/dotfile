# Refactor SOP Reference

Load this file only for large structural or architectural refactors that need a written design artifact.

## Design Brief

- Goal:
- Non-goals:
- Current debt:
- Target contract:
- Target owners:
- Layer direction:
- Source of truth:
- Compatibility decision:
- Razor check:
- Deleted surfaces:
- Complexity budget:
- Verification plan:
- Docs or schema updates:
- Rollback or follow-up trigger:

## Owner Map

| Concern | Current owner | Target owner | Allowed operations | Forbidden operations |
| --- | --- | --- | --- | --- |
| Public entrypoint |  |  |  |  |
| Validation |  |  |  |  |
| Authoritative fact |  |  |  |  |
| Transformation |  |  |  |  |
| Side effect |  |  |  |  |
| Persistence |  |  |  |  |
| Presentation |  |  |  |  |

## Source-Of-Truth Map

| Fact/state | Authority | Readers | Writers | Derived copies | Guard |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

## Batch Split Cues

- Contract batch: one public API, CLI, config, schema, or event contract.
- Fact batch: one authoritative fact and all old read/write paths.
- Boundary batch: one package, layer, adapter, or dependency direction.
- Flow batch: one path from entrypoint to side effect.
- Compatibility batch: one alias, fallback, shim, or legacy route removed or sunset.

## Verification Matrix

| Claim | Check | Evidence | Gap |
| --- | --- | --- | --- |
| Behavior preserved |  |  |  |
| Target owner handles the path |  |  |  |
| Old bypass path is gone or guarded |  |  |  |
| Fact source is authoritative |  |  |  |
| Docs/examples match live behavior |  |  |  |

Useful guards: focused goldens, import-boundary tests, forbidden-string searches, CLI/API smoke checks, schema/config examples, project quality-gate scripts.

## Completion Note

- Target design reached:
- Deleted debt:
- Complexity budget before/after:
- Guards added:
- Verification run:
- Residual risk:
