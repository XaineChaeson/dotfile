---
name: refactor-playbook
description: Use when planning or executing refactors involving structural debt, unclear ownership, boundary leakage, duplicated flows, stale compatibility paths, or architecture/code organization drift.
metadata:
  short-description: Structural refactoring and complexity control
---

# Refactor Playbook

Use this skill to remove structural drag, not just reshape code.

Core principle: a refactor is complete only when necessary behavior is preserved, unnecessary complexity is removed, and future changes require fewer concepts, branches, and files.

## When To Use

- Code organization makes the system hard to explain or extend.
- A module mixes parsing, validation, routing, execution, persistence, and presentation.
- Public APIs, CLIs, configs, docs, or schemas expose implementation details.
- The same fact can be changed through multiple write paths.
- The same data is reshaped repeatedly across layers.
- Stale aliases, legacy branches, or dual schemas create semantic drift.
- Existing abstractions increase indirection without reducing decisions.

## When Not To Use

- Pure feature work with a local, clear implementation path.
- Isolated bug fixes without structural symptoms.
- Formatting-only cleanup with no ownership or complexity issue.

## First-Principles Lens

Before choosing a design, answer the smallest useful set of these questions:

1. **User contract**: who relies on this behavior, and what must remain true for them?
2. **Internal mechanism**: which concepts are implementation details that should not leak into public APIs, configs, CLIs, or docs?
3. **Fact source**: which data is authoritative, derived, cached, or runtime-only?
4. **Write ownership**: which component is allowed to create, validate, mutate, or delete each fact?
5. **Flow ownership**: which layer owns parsing, validation, planning, execution, persistence, and presentation?
6. **Necessary complexity**: what complexity comes from real domain rules, and what comes from code organization?
7. **Compatibility reality**: which old paths are real rollout constraints, and which are development residue?
8. **Proof**: what is the smallest real check that proves the new boundary or invariant works?

If these answers are unclear, do not start by extracting helpers. First clarify ownership, source of truth, and public surface.

## Debt Model

Classify the debt before changing code. Use one or more buckets.

- **Structural debt**: boundary leakage, oversized modules, layer violations, duplicated modules.
- **Contract debt**: public contracts reflect implementation details or outdated concepts.
- **Source-of-truth debt**: multiple write paths, unclear authority, mixed config/runtime/cache state.
- **Ownership debt**: no clear owner for validation, mutation, persistence, or presentation.
- **Flow debt**: repeated reshaping, scattered branching, orchestration layers holding domain logic.
- **Behavioral debt**: hidden side effects, non-deterministic flows, implicit defaults.
- **Compatibility debt**: stale aliases, legacy routes, dual schemas without a sunset rule.
- **Verification debt**: tests or docs cannot prove the boundary that matters.

## Refactor Depth Levels

Pick the minimum level that can remove the diagnosed debt. Escalate only when the lower level cannot fix the root cause.

### Level 1: Hygiene

Use for local readability issues where ownership and contracts are already correct.

- Examples: clearer names, dead code deletion, reduced nesting, local helper extraction.
- Do not change public behavior, source of truth, or cross-module ownership.
- Required output: scope, debt removed, before/after complexity note, verification evidence.
- Stop if the issue turns out to be boundary or ownership debt; escalate to Level 2.

### Level 2: Structural

Use when code organization, module boundaries, or flow ownership are wrong but the user-facing contract can stay mostly stable.

- Examples: split mixed-responsibility modules, isolate adapters, collapse duplicate paths, move validation to the owner, hide internal mechanisms.
- Define ownership for create/validate/transform/execute/persist/present responsibilities.
- Reduce at least one measurable complexity budget item.
- Required output: first-principles answers, ownership changes, complexity budget, verification evidence.
- Stop if the public contract or core architecture is the debt source; escalate to Level 3.

### Level 3: Architectural

Use when the current contract, source-of-truth model, or core boundary causes the debt.

- Examples: redesign a public contract, consolidate authoritative storage, remove harmful compatibility models, change runtime/control-plane boundaries.
- Preserve necessary external behavior, not harmful internal contracts.
- Document compatibility decisions explicitly: keep, migrate, sunset, or delete.
- Required output: decision log, source-of-truth model, public-surface changes, risk plan, verification evidence.

## Target Shape Patterns

Use these patterns when they reduce real decisions for future callers.

- **Thin Entrypoint**: entrypoints parse and route; owners perform business logic.
- **Single Source Of Truth**: each fact has one authority and one controlled write path.
- **Adapter Boundary**: shared mechanics stay common; domain interpretation stays in the owning module.
- **Internal Mechanism Hiding**: implementation details stay behind private modules, adapters, or typed interfaces.
- **Ownership Reassignment**: move validation, mutation, or persistence to the component that owns the invariant.
- **Flow Alignment**: data flow and control flow follow the same responsibility model.
- **Compatibility Collapse**: delete stale aliases and paths unless a real rollout constraint exists.
- **Delete Before Abstracting**: remove duplicate paths before adding a new abstraction.

## Complexity Budget

Track before/after metrics that match the debt. Useful metrics include:

- Number of public entrypoints for one behavior.
- Number of write paths for one fact.
- Number of transformation hops for one payload.
- Number of branching points in the critical flow.
- Number of modules that must change for one feature.
- Number of duplicated builders, parsers, validators, or adapters.
- Number of stale aliases, legacy routes, or dual schemas.
- Number of cross-layer imports or domain-specific branches in orchestration code.

If no meaningful budget improves, the refactor is incomplete or the wrong debt was targeted.

## Workflow

1. Read local repository constraints and current architecture notes.
2. Declare level, debt categories, scope, non-goals, and verification baseline.
3. Apply the First-Principles Lens to identify contract, fact source, ownership, and proof.
4. Inventory entrypoints, call paths, data flow, write paths, tests, and docs.
5. Define the target shape and complexity budget.
6. Refactor in reversible batches split by flow, boundary, or ownership.
7. Delete obsolete paths and stale compatibility layers when no real constraint requires them.
8. Verify each batch with checks that prove the changed boundary or invariant.
9. Sync docs, examples, schemas, and generated references when public behavior changes.
10. Report debt removed, debt retained, evidence, and residual risk.

## Contract And Compatibility Rules

- Preserve necessary user-facing behavior unless the user approves a behavior change.
- Do not preserve harmful internal contracts just because they are old.
- Do not keep aliases, dual paths, or old schemas without a real rollout constraint.
- If compatibility must remain, name the owner, sunset condition, and verification path.
- Unknown defaults and hidden fallbacks are debt unless the project contract explicitly allows them.

## Verification

Choose verification based on the claim:

- Hygiene claim: run focused tests, lint/typecheck, or targeted smoke checks.
- Boundary claim: test the caller-to-owner path and the forbidden bypass path if possible.
- Source-of-truth claim: verify reads and writes hit the intended authority.
- Contract claim: verify public API/CLI/config/docs examples against live behavior.
- Compatibility claim: verify both current and sunset paths, or delete the obsolete path.
- Weak-test baseline: add small goldens, snapshots, scripted assertions, or scenario checks before large edits.

Prefer the smallest real scenario that proves the invariant. Do not replace structural proof with large-volume work unless volume is the risk.

## Artifacts

Scale artifacts to risk. Keep them concise and auditable.

- **Fast**: scope, level, debt removed, verification evidence.
- **Standard**: first-principles summary, ownership changes, complexity budget before/after, residual risks.
- **Deep**: decision log, source-of-truth model, compatibility plan, risk plan, verification matrix.

Detailed templates and checklists: `references/REFACTOR_SOP_REFERENCE.md`.

## Anti-Patterns To Avoid

- Moving files while preserving the same coupling.
- Adding wrappers or managers that increase indirection without reducing decisions.
- Letting orchestration layers absorb domain rules.
- Exposing internal mechanisms through public contracts.
- Keeping legacy compatibility paths indefinitely.
- Creating multiple write paths for the same fact.
- Treating unchanged contracts as success when the contract is the debt source.
- Running broad tests that do not prove the changed invariant.

## Exit Criteria

A refactor is complete only when all are true:

- The diagnosed root cause was addressed at the chosen level.
- Complexity budget improved.
- Ownership and source-of-truth rules are clearer and enforceable.
- Public contracts and internal mechanisms are separated.
- Required tests/checks/docs were updated and verified.
- Obsolete paths were deleted or given an explicit sunset rule.
- Residual debt is explicit and actionable.

## Quick Execution Template

### Input

- Scope:
- Level (1/2/3) and reason:
- Debt categories:
- First-principles findings:
- Non-goals:
- Compatibility constraints:
- Verification baseline:

### Output

- Changes made:
- Debt removed:
- Target shape reached:
- Complexity budget before/after:
- Ownership/source-of-truth changes:
- Compatibility decisions:
- Verification evidence:
- Residual risks:
