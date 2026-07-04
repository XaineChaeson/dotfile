---
name: refactor-playbook
description: Use when planning or executing refactors involving structural debt, unclear ownership, boundary leakage, duplicated flows, stale compatibility paths, source-of-truth drift, architecture/code organization drift, or over-abstracted redesign risk.
metadata:
  short-description: Top-down structural refactoring
---

# Refactor Playbook

Use this skill to remove structural drag. A refactor is complete only when the target design is explicit, behavior is preserved or deliberately changed, obsolete paths are removed, and future changes require fewer concepts and less code.

## Core Doctrine

- Design first, then execute. Do not begin by opportunistically extracting helpers, moving files, or tidying long modules.
- Refactor top-down: define the target contract, layer direction, owners, source of truth, public surfaces, and deletion plan before edits.
- Use first principles and the razor: keep only concepts required by the real contract or invariant; delete intermediaries that do not reduce decisions.
- Treat ad hoc cleanup and speculative frameworks as smells. If the work cannot be explained as boundary, ownership, source-of-truth, compatibility, or flow repair, it is probably not this skill.
- Preserve necessary external behavior, not harmful internal contracts.
- Prefer deletion and direct caller migration over new facades, wrappers, aliases, or compatibility shims.
- Design for simple, efficient, precise, stable code; abstraction must earn its cost by removing decisions, duplication, or risk.
- Encode important new boundaries in tests, static checks, scripts, docs, or schemas so the debt cannot quietly return.

## Scope Levels

Pick the smallest level that fixes the root cause.

- **Local**: ownership and contracts are already right; clean names, dead code, duplication, or nesting.
- **Structural**: code organization, module boundaries, flow ownership, or dependency direction is wrong; public behavior mostly stays stable.
- **Architectural**: the public contract, runtime boundary, source-of-truth model, or compatibility model is the debt source.

Escalate before editing if a local cleanup uncovers ownership, fact-source, or public-contract debt.

## Design Gate

Before code edits, write a compact design for any structural or architectural refactor:

- Scope and non-goals.
- Current debt in one sentence.
- Target shape: public contract, internal mechanisms, layer direction, and owners.
- Source-of-truth model: authoritative facts, readers, writers, derived copies.
- Compatibility decision: keep, migrate, sunset, or delete each old path.
- Razor check: what concepts, files, branches, or fallbacks disappear, and why each new abstraction is necessary.
- Complexity budget: one to three before/after measures that should improve.
- Verification plan: tests/checks/docs that prove the changed boundary, not just broad regression.

If this design cannot be written clearly, do not refactor yet; investigate until the design is clear.

## Execution Rules

- Execute the design directly in planned batches split by contract, fact, boundary, flow, or compatibility path.
- Lock weakly protected behavior with focused tests or goldens before moving it.
- Move callers to the target owner instead of preserving old import paths.
- Keep entrypoints thin: parse and route at the edge; business rules live with their owner.
- Keep composition roots explicit: concrete adapters, env, filesystem, network, process, and runtime wiring stay at the outer edge.
- Keep domain/policy code free of infrastructure, subprocess, filesystem, network, and UI concerns.
- Add no abstraction unless it replaces repeated real decisions or enforces a real invariant; otherwise inline, delete, or keep the simpler owner.
- Delete obsolete paths once callers are migrated unless a real rollout constraint requires them.
- Update tracked docs when public contracts, runtime semantics, schemas, operator workflows, or research conclusions change.

## Verification

Choose checks that prove the refactor claim:

- Behavior preservation: focused unit/integration/golden tests around moved behavior.
- Boundary repair: import/layer tests, forbidden-path searches, or static checks.
- Source of truth: tests for the only allowed writer and for removed fallback/write paths.
- Public contract: CLI/API/config/schema examples exercised against live code.
- Compatibility: either verify the kept path with a sunset rule, or prove the obsolete path is gone.
- Completion gate: run the project quality gate or the smallest documented equivalent for the changed surface.

Do not rely only on broad tests when the risk is structural. Add a guard that catches the specific boundary regression.

## Completion Report

Report only what matters:

- Design reached.
- Behavior preserved or intentionally changed.
- Debt removed, including deleted compatibility paths.
- Complexity budget before/after.
- Boundary/source-of-truth guards added.
- Verification evidence.
- Remaining risks or explicit follow-up triggers.

## Skill Maintenance

Keep this skill small. When adding lessons, merge them into the doctrine or rules above, replace weaker wording, and delete obsolete guidance. Do not append case-specific war stories to the main skill.

Use `references/REFACTOR_SOP_REFERENCE.md` only when a larger refactor needs a reusable design template or checklist.
