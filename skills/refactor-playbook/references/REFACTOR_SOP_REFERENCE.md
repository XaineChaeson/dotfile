# Refactor Playbook Reference

Use this reference only when the main playbook needs concrete templates or checklists.

## Entry Checklist

- Read local agent, contribution, architecture, and documentation constraints.
- Confirm scope: directories, modules, services, public surfaces, and non-goals.
- Capture current verification status and known weak spots.
- Declare refactor level and debt categories before editing.
- Identify whether the goal is hygiene, structural boundary repair, or architectural contract repair.

## First-Principles Worksheet

- User contract: who depends on the behavior, and what must remain true?
- Public surface: which APIs, CLIs, configs, schemas, docs, or events expose this behavior?
- Internal mechanism: which concepts should remain private implementation details?
- Fact source: which data is authoritative, derived, cached, or runtime-only?
- Write path: which component can create, update, delete, or migrate the fact?
- Flow owner: who owns parsing, validation, planning, execution, persistence, and presentation?
- Necessary complexity: which branches come from real domain rules?
- Accidental complexity: which branches come from history, coupling, or duplicate paths?
- Compatibility: which old paths are real rollout constraints, and which are stale residue?
- Proof: what smallest real check proves the new invariant?

## Structural Diagnosis Checklist

- Does one module own multiple unrelated reasons to change?
- Does an entrypoint contain business logic instead of routing to an owner?
- Does orchestration code branch on domain-specific fields?
- Can the same fact be written or interpreted through multiple paths?
- Is a field or type used for more than one meaning?
- Is data repeatedly reshaped between layers?
- Are public contracts named after implementation details?
- Are adapters, helpers, or managers adding decisions instead of removing them?
- Do tests prove implementation details while missing boundary behavior?
- Are docs/examples describing a path different from live code?

## Ownership Matrix Template

Use this for Level 2 and Level 3 refactors.

| Concern | Current owner | Target owner | Allowed operations | Forbidden operations |
| --- | --- | --- | --- | --- |
| Parse input |  |  |  |  |
| Validate contract |  |  |  |  |
| Create authoritative fact |  |  |  |  |
| Transform derived data |  |  |  |  |
| Execute side effects |  |  |  |  |
| Persist state |  |  |  |  |
| Present output |  |  |  |  |

## Source-Of-Truth Template

| Fact/state | Authority | Readers | Writers | Derived/cached copies | Verification |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |

Rules:

- One fact should have one authority.
- Derived copies must identify their source and refresh path.
- Runtime state and configuration state should not share write semantics unless that is the explicit contract.

## Complexity Budget Examples

Choose metrics that match the debt.

- Public entrypoints for one behavior: before `<n>`, after `<n>`.
- Write paths for one fact: before `<n>`, after `<n>`.
- Transformation hops for one payload: before `<n>`, after `<n>`.
- Critical-flow branch points: before `<n>`, after `<n>`.
- Files touched for one common feature: before `<n>`, after `<n>`.
- Duplicate parser/builder/validator implementations: before `<n>`, after `<n>`.
- Stale aliases or compatibility paths: before `<n>`, after `<n>`.
- Cross-layer imports or domain branches in orchestration: before `<n>`, after `<n>`.

## Depth Selection Cues

- **Level 1: Hygiene**
  - Symptoms: local naming, dead code, nested logic, small duplication.
  - Root cause: local readability.
  - Avoid: changing ownership, public contracts, or fact sources.

- **Level 2: Structural**
  - Symptoms: mixed responsibilities, duplicated flows, leaky modules, unclear ownership.
  - Root cause: wrong code organization or boundary placement.
  - Required: ownership matrix and complexity budget.

- **Level 3: Architectural**
  - Symptoms: harmful public contract, multiple fact authorities, wrong runtime/control-plane split, long-lived false compatibility.
  - Root cause: wrong abstraction or source-of-truth model.
  - Required: decision log, compatibility plan, source-of-truth model, verification matrix.

## Batch Split Patterns

- Flow batch: one user/system path from entrypoint to side effect.
- Boundary batch: one module ownership boundary at a time.
- Fact batch: one authoritative fact and its read/write paths.
- Contract batch: one public API/CLI/config/schema behavior.
- Compatibility batch: delete or sunset one stale path at a time.

Keep each batch reversible unless the user explicitly approved an irreversible cleanup.

## Verification Matrix Template

| Claim | Check | Evidence | Gap |
| --- | --- | --- | --- |
| Public behavior preserved |  |  |  |
| New owner handles valid path |  |  |  |
| Old bypass path removed or blocked |  |  |  |
| Fact source is authoritative |  |  |  |
| Compatibility path kept/deleted as planned |  |  |  |
| Docs/examples match live behavior |  |  |  |

Verification tactics:

- Golden outputs for stable behavior.
- Focused integration checks for boundary movement.
- Scripted assertions for source-of-truth and write-path claims.
- Smoke checks for public commands or API examples.
- Static search for deleted aliases, duplicate paths, or forbidden imports.

## Decision Log Template

- Decision:
- Level:
- Debt categories:
- First-principles reason:
- Alternatives rejected:
- Public behavior impact:
- Compatibility decision:
- Rollback or sunset path:
- Verification evidence:

## Risk List Template

- Risk:
- Trigger:
- Impact:
- Mitigation:
- Verification:
- Follow-up owner or condition:

## Documentation Sync Triggers

- Public contract changes: update API docs, schemas, examples, or generated references.
- Config changes: update examples and migration notes.
- CLI or workflow changes: update user guides and command references.
- Storage/source-of-truth changes: update architecture or operations docs.
- Runtime semantics changes: update lifecycle or runbook documentation.

## Exit Checklist

- Refactor level matched the root cause.
- Complexity budget improved.
- Ownership and source-of-truth rules are explicit.
- Public surface no longer leaks unnecessary internal mechanisms.
- Obsolete paths were deleted or have a real sunset rule.
- Verification proves the changed invariant, not just unrelated behavior.
- Docs and examples match live code paths.
- Residual debt is named with a concrete follow-up trigger.
