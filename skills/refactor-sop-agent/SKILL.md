---
name: refactor-sop-agent
description: Use when asked to plan or execute periodic codebase cleanup/refactor, produce a refactor SOP, or set up a repeatable refactor workflow across projects.
metadata:
  short-description: Codebase refactor SOP workflow
---

# Refactor SOP Agent

Use this skill to drive periodic codebase cleanup with stable behavior, strong logging, and test-backed changes.

## Quick Start

1) Read repo instructions (AGENTS.md, docs/INDEX.md) and constraints.
2) Inventory entry points, core mechanisms, and logging events.
3) Identify long/complex functions and duplicated logic.
4) Refactor in small batches, preserving behavior and log event names.
5) Run unit tests after each batch.
6) Sync documentation and record decisions.

## Guardrails

- Do NOT change external config fields or their behavior without explicit approval.
- Preserve log event names and field structure; external API errors must log raw_response.
- Keep I/O in execution hubs; strategy/controllers should be decision-only.

## Workflow

- **Inventory**: map modules, call paths, log events, tests.
- **Refactor**: split long functions into precheck/compute/commit segments.
- **Cleanup**: remove dead code only after verifying no references.
- **Verification**: run unit tests and sanity checks.
- **Documentation**: update SOP and docs triggered by changes.

## Artifacts

- Decision log (why/impact/compat/rollback).
- Risk list (behavioral changes, test gaps).
- Updated SOP and changelog when required.

## References

- Detailed checklists and templates: `references/REFACTOR_SOP_REFERENCE.md`
