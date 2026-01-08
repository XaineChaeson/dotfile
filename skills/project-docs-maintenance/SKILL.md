---
name: project-docs-maintenance
description: Build, update, or rewrite project documentation to reflect current code and support doc-driven development. Use when a project needs a documentation system, when rewriting documentation, when developing a module from docs, or when aligning docs to implementation. Focus on fast user onboarding, precise developer specs, and code-doc consistency without running automation.
---

# Project Docs Maintenance

## Principles
- Prioritize user speed: make it easy to locate usage and examples fast.
- Prioritize developer precision: define boundaries, decisions, and contracts.
- Keep docs aligned to code; do not run automation.
- Minimize duplication: a single source of truth with links elsewhere.
- Default to recommendations unless the user explicitly requests template edits or doc changes.

## Workflow

### 1) Assess complexity and choose scope
Score each dimension as Low/Med/High based on current repo state:
- Entrypoints: number of APIs/CLIs/config entrypoints.
- Modules: number of core modules and adapters.
- Mechanisms: state machines, async flows, reconciliation, retries.
- External deps: exchanges, platforms, third-party services.
- Roles: user types (user/dev/ops) and their needs.

Pick scope:
- S (small): README + docs/user (index/quickstart/api-overview) + dev architecture + core interfaces.
- M (medium): S + docs/index + scenario index + troubleshooting + modules + contracts + ops runbook + changelog/devlog.
- L (large): M + design docs + interface index + reference docs + ops troubleshooting + ops handoff.

Heuristic only (not strict): use counts to support judgment.
- S: most dimensions Low (e.g., entrypoints <= 3, modules <= 3, simple mechanisms).
- M: several Medium (e.g., entrypoints 4-8, modules 4-8, some complex mechanisms).
- L: multiple High (e.g., entrypoints >= 9, modules >= 9, multiple complex mechanisms).

### 2) Plan doc boundaries and migration (if needed)
- Choose the target doc partition: user/dev/ops/reference/archive.
- Enforce single-responsibility pages: each page answers one core question.
- Keep user docs minimal: index, quickstart, scenario index, API overview, troubleshooting.
- Map existing docs to the new structure before moving anything.
- Use references/migration-checklist.md to execute moves and link rewrites.

### 3) Build doc map (navigation first)
- Create or update the single entry index and add a short navigation summary.
- Add overview tables for large APIs to improve discoverability.

### 4) Rewrite flow (use when docs are unreliable or outdated)
- Set source of truth: code and tests, not existing docs.
- Decide keep/remove rules for legacy docs; archive clearly.
- Rebuild core docs from scratch using templates.
- Re-derive examples from code paths and update all interface specs.
- Finish with a full consistency pass against code entrypoints.
- Use references/rewrite-checklist.md for full rewrites.

### 5) Refactor flow (use when docs are mostly correct)
- Keep content, reorganize structure and navigation.
- Fix links, update minor mismatches, and add missing sections.

### 6) Fill core documents
- Follow templates from references/.
- Prefer minimal runnable examples and explicit constraints.
- Put strict interface IO contracts in dev/contracts.
- Keep user-facing API pages as a short "API overview" only.
- Keep parameters and IO specs only in dev/interfaces; user docs link instead of repeating.
- Maintain full config parameters in a dedicated dev config doc (`docs/dev/config.md` or `docs/dev/config/`) when any of the following apply:
  - Config parameters > 8–10.
  - Config is shared across multiple modules/services.
  - Config changes are frequent or impact behavior materially.
  - Multiple environments or profiles require different defaults.
- For small/simple configs, an interface doc may include config details, but still keep a single source of truth.
- Add adapter delta docs for instance-specific deviations when needed.

### 7) Align with code
- Verify entrypoints, configs, defaults, and error conditions.
- Update docs to match current code paths and naming.

### 8) Consistency pass
- Use references/consistency-checklist.md.
- Apply references/change-sync-rules.md if present.

## Output expectations
- Users: quick usage, clear overview, and readable API/config queries.
- Developers: precise definitions, decision points, and boundaries.
- Docs are organized, searchable, and mapped to code entrypoints.
- User-facing docs avoid repeated IO details and link to dev sources.

## Output modes
- Recommendations: provide structure and advice without editing files.
- Templates: update skill templates in `references/` and `SKILL.md`.
- Delivery: apply changes directly to project docs.
- If the user specifies a mode, follow it.

## Reference files
- references/doc-system-outline.md
- references/doc-index-template.md
- references/architecture-template.md
- references/module-template.md
- references/design-template.md
- references/api-config-template.md
- references/interface-contract-template.md
- references/contracts-template.md
- references/adapters-delta-template.md
- references/overview-table-template.md
- references/scenario-path-index.md
- references/user-doc-template.md
- references/migration-checklist.md
- references/consistency-checklist.md
- references/change-sync-rules.md
- references/writing-style.md
- references/examples-catalog.md
- references/rewrite-checklist.md
- references/ops-runbook-template.md
- references/ops-troubleshooting-template.md
- references/dev-index-template.md
- references/interface-index-template.md
- references/ops-handoff-template.md
- references/config-reference-template.md
- references/reference-glossary-template.md
- references/reference-conventions-template.md
- references/reference-structure-template.md
