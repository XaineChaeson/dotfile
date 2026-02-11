---
name: refactor-playbook
description: Use when asked to plan or execute codebase refactors, set up a repeatable refactor workflow, or apply refactor principles with explicit risk control.
metadata:
  short-description: Technical debt reduction + complexity control
---

# Refactor Playbook

Use this skill to reduce technical debt and complexity while preserving delivery velocity.  
This playbook is not only about changing code shape. It is about removing structural drag.

## Core Objective

- Primary: reduce technical debt.
- Secondary: improve readability and maintainability.
- Constraint: avoid introducing new hidden complexity.

A refactor is not complete unless complexity is lower than before.

## When To Use

- Planning or executing refactors of any scale.
- Repeated complexity in the same area slows feature work.
- Existing contracts or abstractions now create coupling or confusion.
- Team conventions and implementation have started to drift.

## When Not To Use

- Pure feature work with local, clear changes.
- Isolated bug fixes without structural symptoms.

## Debt Model

Classify debt before changing code. Use one or more buckets.

- Structural debt: boundary leakage, layer violations, duplicated modules.
- Data debt: mixed field semantics, unstable payloads, repeated reshaping.
- Behavioral debt: branch explosion, hidden side effects, non-deterministic flows.
- Compatibility debt: stale aliases, legacy paths, double schemas with no sunset.
- Documentation debt: implementation no longer matches contracts or guides.

## Complexity Signals

- The same data is transformed repeatedly across layers.
- A field is used for multiple meanings.
- Service/orchestration layers hold domain-specific logic.
- New work requires touching many unrelated files.
- Naming and contracts drift from implementation over time.

## Refactor Depth Levels

Pick the minimum depth needed; escalate only with explicit justification.

- **Level 1: Hygiene**: rename for clarity, remove dead code, reduce nesting.
- **Level 2: Structural**: isolate responsibilities, split modules, remove duplicated paths.
- **Level 3: Architectural**: redesign boundaries, contracts, and ownership models.

Always declare depth before starting and tie it to debt categories.

## Contract Principle

Contracts are tools, not sacred artifacts.

- If a contract keeps boundaries clear and complexity low, stabilize it.
- If a contract causes coupling, mixed semantics, or repeated reshaping, refactor it.
- Do not preserve harmful contracts in the name of stability.
- Avoid long-lived dual contracts unless there is a hard rollout constraint.

## Invariants And Ownership

Define invariants before edits:

- Which structures are produced by which layer.
- Which layers may append context.
- Which layers are forbidden to reinterpret or branch on specific fields.

Use a simple ownership matrix:

- `owned_by_layer`: fields this layer can set/change.
- `append_only`: fields this layer may add but not rewrite upstream values.
- `read_only`: fields this layer can consume only.

## Workflow

1) Read repository constraints and architecture docs.
2) Declare depth level and debt categories in scope.
3) Inventory entry points, call paths, contracts, tests, and docs.
4) Create a baseline complexity budget.
5) Define invariants and field/layer ownership.
6) Decide whether contracts should be stabilized or redesigned.
7) Refactor in small batches that reduce debt measurably.
8) Remove obsolete paths and dead compatibility layers.
9) Verify each batch (tests + targeted behavior checks).
10) Sync docs/contracts/storage mappings to implementation.
11) Produce a debt ledger and residual risk list.

## Complexity Budget

Track before/after metrics suitable for the refactor scope, for example:

- Number of transformation hops for the same payload.
- Number of branching points in critical flow.
- Number of modules participating in a single behavior.
- Number of duplicate builders/parsers for the same structure.

If budget does not improve, the refactor is incomplete.

## Guardrails

- Preserve required behavior unless behavior change is explicitly approved.
- Keep observability stable or improve it.
- Minimize surprise in runtime and operational semantics.
- Prefer deleting complexity over moving it.

If a guardrail must be violated, record decision + risk + rollback.

## Verification

- Run the most relevant tests per batch.
- Add focused tests where boundaries or contracts changed.
- If tests are weak, add lightweight checks (goldens, snapshots, scripted assertions).
- Verify docs and contracts are consistent with live code paths.

## Artifacts

Produce explicit outputs for handoff and future refactors.

- Refactor decision log (scope, depth, reasoning).
- Debt ledger:
  - debt removed
  - debt intentionally retained
  - rationale and follow-up trigger
- Complexity budget before/after.
- Contract ownership matrix.
- Verification evidence.

## Batch Strategy

- Split by call path to keep impact reviewable.
- Split by contract boundary for data-flow changes.
- Split by layer ownership to avoid cross-layer confusion.
- Keep each batch reversible.

## Risk Guidance

- Low: local cleanup, clear ownership, tests cover behavior.
- Medium: shared modules or contract changes with bounded impact.
- High: architecture-wide contract redesign or weak verification baseline.

For high risk, reduce batch size and increase verification density.

## Anti-Patterns To Avoid

- Refactor that only renames files but keeps coupling intact.
- Adding wrappers that increase shape-shifting without reducing debt.
- Keeping legacy compatibility paths indefinitely.
- Allowing service/orchestration layers to absorb domain logic.
- Treating unchanged contracts as success when they are the debt source.

## Exit Criteria

A refactor is complete only when all are true:

- Complexity budget improved.
- Layer boundaries are clearer and enforceable.
- Contracts match implementation and reduce ambiguity.
- Tests/docs are updated and passing.
- Residual debt is explicit (not implicit).

## Rollback

- Keep batches small and reversible.
- Keep a clear rollback note for each non-trivial batch.

## References

- Detailed templates and checklists: `references/REFACTOR_SOP_REFERENCE.md`

## Quick Execution Template

Use this template to keep output quality consistent without adding process overhead.

### Input Block (fill before work)

- Scope:
- Depth level (1/2/3):
- Debt categories in scope:
- Non-goals:
- Constraints (runtime/config/compatibility):
- Verification baseline:

### Output Block (must provide at handoff)

- Changes made:
- Debt removed:
- Debt retained (with reason):
- Complexity budget before/after:
- Contract/boundary changes:
- Verification evidence:
- Residual risks:

## Stability Checklist (10-Point)

Before declaring completion, confirm all items:

1) Scope stayed within declared debt categories.
2) Complexity budget improved.
3) No new redundant transformation layer was introduced.
4) Layer ownership is clearer than before.
5) Contracts and implementation are aligned.
6) Compatibility paths were removed or explicitly sunset.
7) Tests/checks cover changed seams.
8) Documentation reflects actual behavior.
9) Residual debt is explicit and actionable.
10) Rollback path is clear for non-trivial changes.

## Lightweight Modes

Use one mode based on task size to avoid over-process:

- `Fast` (small/local): Input Block + 10-point checklist only.
- `Standard` (most refactors): Input/Output Blocks + checklist.
- `Deep` (architectural): full workflow + debt ledger + complexity metrics + contract ownership matrix.

## User Experience Rule

Keep collaboration lightweight:

- Do not force full artifacts for trivial changes.
- Scale process depth to refactor risk.
- Prefer concise, auditable outputs over long narrative reports.
