---
name: refactor-playbook
description: Use when asked to plan or execute codebase refactors, set up a repeatable refactor workflow, or apply refactor principles with explicit risk control.
metadata:
  short-description: Refactor workflow + principles
---

# Refactor Playbook

Use this skill to drive safe, repeatable refactors with explicit depth levels, clear principles, and verification. This playbook also covers core code-level refactoring principles.

## When To Use

- Planning or executing refactors of any scale.
- Establishing a repeatable refactor process.
- Applying refactor principles to simplify code safely.

## When Not To Use

- Feature work that only needs small, local edits.
- Pure bug-fixing without structural changes.

## Entry Signals

- Functions or files growing past readability (roughly 50-100+ lines).
- Repeated logic in two or more places.
- Deep nesting that hides the main intent.
- Changes repeatedly touching the same fragile area.
- Tests are weak and changes are hard to verify.

## Refactor Depth Levels

Pick the minimum depth needed; escalate only with explicit justification.

- **Level 1: Hygiene**: rename for clarity, extract small helpers, reduce nesting, remove dead code.
- **Level 2: Structural**: split large modules, isolate side effects, reorder responsibilities, introduce seams for testing.
- **Level 3: Architectural**: redesign flows or boundaries, replace patterns, rework core abstractions.

Always declare the depth level before starting; only escalate with explicit justification.

## Core Principles (Code-Level)

- Decompose large functions; keep each function focused on one responsibility.
- Reduce nesting by handling edge cases early.
- Eliminate redundancy by extracting shared logic.
- Simplify complex logic into readable, testable steps.
- Prefer small, named helpers over long inline expressions.
- Aim for clear, predictable control flow over cleverness.

## Examples (Code-Level)

- Split a large function into helpers focused on one task.
- Extract duplicated logic into a shared helper or module.

## Workflow

1) Read repo instructions and constraints.
2) Declare the refactor depth level and expected impact.
3) Inventory entry points, call paths, and tests.
4) Identify complexity hotspots and duplication.
5) Flag any decisions required and resolve them before starting refactor work.
6) Refactor in small batches, preserving behavior.
7) Verify each batch (tests or lightweight checks).
8) Sync documentation and record decisions.

## Guardrails

- Preserve external behavior and public contracts.
- Keep observability stable (log names, metrics, traces).
- Avoid changing configuration interfaces.
- Prefer minimal, reversible changes per batch.

If any of these guardrails must be violated, raise it during inventory and resolve before refactor work begins.

## Verification

- If tests exist: run the relevant subset per batch.
- If tests are weak or missing: create lightweight checks (golden outputs, manual runbook, diff snapshots).

## Artifacts

- Decision log (why/impact/compat/rollback).
- Risk list (behavioral changes, test gaps).
- Notes on verification evidence.

## Batch Strategy

- Split by call path: refactor one entry path at a time.
- Split by surface area: limit each batch to a small, reviewable behavior slice.
- Split by structure: isolate a module or layer before deeper changes.

## Risk Guidance

- Low: local refactor, no behavior change, easy to verify.
- Medium: touches shared logic, requires added checks.
- High: broad behavior surface or weak verification; reduce batch size.

## Scenario Guidance

- **Small codebase**: use larger batches, but keep changes reversible.
- **Medium codebase**: use smaller batches; add lightweight checks.
- **Large codebase**: isolate by subsystem; require explicit rollback paths.
- **No tests**: prioritize safety nets (goldens, diff outputs, canary scripts).
- **Some tests**: add targeted tests around changed seams.
- **Strong tests/observability**: allow deeper refactors with faster feedback loops.

## Depth Selection Guide

- **Small + strong tests**: start at Level 2; escalate to Level 3 only with explicit scope and rollback.
- **Small + weak tests**: stay at Level 1 or Level 2 with extra verification.
- **Medium + some tests**: Level 1 or Level 2; prefer incremental seams.
- **Large + mixed quality**: start at Level 1; treat Level 2 as a series of isolated moves.
- **Large + strong observability**: Level 2 is feasible with strict batching and monitoring.

## Depth Selection Table

This table provides default guidance; final decisions should account for business risk and team context.

| Codebase Size | Quality Baseline | Default Depth | Notes |
| --- | --- | --- | --- |
| Small | Strong tests | Level 2 | Escalate to Level 3 only with explicit scope. |
| Small | Weak tests | Level 1 | Add lightweight verification before Level 2. |
| Medium | Some tests | Level 1-2 | Prefer incremental seams and batch limits. |
| Large | Mixed quality | Level 1 | Break into isolated moves before Level 2. |
| Large | Strong observability | Level 2 | Require strict batching and monitoring. |

## Rollback

- Keep changes small and rely on local VCS backups for safe rollback.

## References

- Detailed checklists and templates: `references/REFACTOR_SOP_REFERENCE.md`
- Includes minimal verification checklist and batch split template.
