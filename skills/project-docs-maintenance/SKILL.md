---
name: project-docs-maintenance
description: Use when a project needs documentation created, reorganized, rewritten, or aligned with code, including architecture docs, user manuals, developer specs, API/CLI/config entrypoint coverage, storage docs, or drift-control rules.
---

# Project Docs Maintenance

## Core Principle

Documentation is an engineering interface. It must help users act quickly, help developers change code safely, and preserve one source of truth for decisions that would otherwise drift.

Prefer a clear doc system over isolated pages. Do not preserve an old structure merely because it exists.

## Default Doc Layers

Adapt names to the repo, but keep responsibilities separate:

| Layer | Answers | Must Not Carry |
| --- | --- | --- |
| root entry | where to start | detailed module facts |
| docs index | navigation and layer map | duplicated facts |
| project status | current phase, frozen facts, fact-source index | general rules |
| prd | user needs, product boundary, acceptance criteria | implementation details |
| architecture | stable module boundaries, components, data flow, tradeoffs | concrete instances, runbooks, CLI tutorials |
| manual or user | setup, quickstart, lifecycle, operations, troubleshooting | architecture rationale, full IO contracts |
| dev | implementation design, contracts, config governance, extension rules | usage tutorials, product goals |
| scenarios | concrete source/vendor/market/task/table/examples and acceptance data | generic architecture rules |
| ops | deployment, runbook, incident response, handoff | product or architecture decisions |
| reference | glossary, conventions, schemas shared across docs | volatile status |
| archive | superseded docs with migration notes | active facts |

For substantial systems, treat `architecture/` and `manual/` as first-class layers. Do not bury architecture in `dev/`, and do not turn manual pages into design docs.

## Source Of Truth Rules

- Each fact has exactly one owner page.
- Other pages link to the owner instead of copying details.
- Code, config, schemas, migrations, tests, and actual CLI/API help beat stale docs.
- Confirmed design must be written into docs before it becomes future implementation authority.
- Missing fields, unknown identifiers, and unsupported capabilities should be documented as explicit errors when that is the system contract.

## Workflow

### 1. Establish Scope And Mode

Identify whether the user wants:

- **Recommendations**: structure and advice only.
- **Delivery**: edit project docs.
- **Template/skill work**: edit this skill or reusable templates.

Before delivery work, read local agent rules and current project status when present (`AGENTS.md`, `docs/AGENTS.md`, `docs/project-status.md`, equivalent files).

### 2. Inventory Before Designing

Collect only enough evidence to design the doc system:

- existing docs and current links;
- public entrypoints: CLI commands, APIs, SDK functions, UI flows, config files, env templates, migrations, schemas, scripts, jobs, tasks, webhooks, queues, storage tables;
- user roles: user, developer, operator, maintainer, auditor;
- runtime dependencies and external services;
- existing tests, acceptance scripts, smoke commands, or real verification paths.

Do not assume entrypoints live in `docs/dev/interfaces/`. Discover them from the repo and tooling.

### 3. Choose Scale

Score these as Low / Medium / High:

- entrypoints;
- modules and adapters;
- stateful mechanisms;
- storage and schema surface;
- external dependencies;
- roles and operational needs;
- current doc drift.

Scope guidance:

- **Small**: root README, docs index, quickstart/manual, architecture overview, core contracts.
- **Medium**: Small plus lifecycle coverage matrix, scenarios, troubleshooting, dev contracts, config docs, storage overview.
- **Large**: Medium plus module docs, mechanism specs, reference conventions, ops runbook, storage domains, migration/archive plan.

Use judgment. A small codebase with high operational risk can need Medium docs.

### 4. Partition Facts

Map old docs to the target layers before moving files. For each ambiguous section, ask what question it answers:

- "why this boundary exists" -> architecture;
- "how to run it" -> manual;
- "what exact IO/config/error contract exists" -> dev;
- "which concrete vendor/task/table/example proves it" -> scenarios;
- "what is current and frozen" -> project status;
- "what to do during production operation" -> ops.

If one paragraph answers multiple questions, split it.

### 5. Build Navigation First

Create or update:

- root README when the repo lacks a real entrypoint;
- docs index with the layer map;
- architecture index for system and module architecture;
- manual/user index for usage paths;
- dev index for implementation and contract paths;
- scenario index when concrete examples exist;
- project-status or equivalent fact-source index when the project uses frozen decisions;
- AGENTS or equivalent rules when drift prevention depends on future agents.

### 6. Cover Public Entrypoints

For modules with multi-step usage or many public entrypoints, add a lifecycle page with a coverage matrix:

| Entrypoint | User Doc | Design / Contract Source | Validation Evidence |
| --- | --- | --- | --- |

Entrypoints may be CLI commands, routes, exported APIs, config files, env keys, migrations, queues, tables, scheduled jobs, scripts, or UI workflows.

The lifecycle page must include:

- a minimal runnable happy path;
- a complete entrypoint coverage matrix;
- conditional steps labeled with preconditions;
- failure / recovery notes for common errors;
- links to dev contracts instead of repeating full IO specs.

Split lifecycle docs only by module, product, role, or phase when the lifecycle is genuinely distinct. Never split based on line count alone.

### 7. Write Core Content

Use templates from `references/` only when they fit the repo. Load only the specific template needed.

Architecture docs:

- include Mermaid diagrams for component boundaries and data flow;
- describe stable abstractions, responsibilities, and tradeoffs;
- link to dev contracts and scenarios;
- avoid concrete vendor/task/table examples except as outbound links.

Manual docs:

- start with quick success;
- document config, operations, lifecycle, troubleshooting;
- mark pseudo or conditional steps explicitly;
- avoid duplicated parameter tables when dev contracts own them.

Dev docs:

- define strict contracts, errors, invariants, config semantics, extension rules;
- keep implementation design separate from product goals and scenario instances.

Scenario docs:

- record concrete vendor/source/market/task/topic/table/example/acceptance evidence;
- link back to generic architecture and contracts without redefining them.

Storage docs:

- keep a system-level storage overview for table roles, relationships, and record flow;
- add per-table docs when schema details matter: columns, nullability/defaults, keys, indexes, lifecycle, quality rules, example row;
- split by business object domain when storage spans multiple domains.

Mechanism specs:

- create when decision logic is non-trivial: multi-path decisions, state/time dependence, guardrails, config interactions, irreversible effects;
- include narrative, terms, inputs, steps, state changes, outputs, edge cases, examples, and observability.

### 8. Add Drift Controls

When the doc system changes, update agent/project rules if present. At minimum encode:

- which layer owns architecture, manual, dev contracts, scenarios, and status;
- what must be updated when CLI/API/config/schema/migration/runtime behavior changes;
- where lifecycle coverage matrices live;
- that generated outputs or untracked artifacts cannot be the sole durable source when docs must survive checkout or machine changes.

### 9. Align With Code

Use lightweight, targeted validation. This is not "automation as author"; it is evidence collection.

Good checks:

- CLI `--help`, route lists, public export search;
- config/env key search;
- migration/schema file inspection;
- markdown link check;
- stale path/name search with `rg`;
- targeted tests or smoke scripts when docs claim behavior.

Avoid heavy or destructive commands unless the user asked for delivery-grade verification and the environment is ready.

### 10. Consistency Pass

Before completion, verify:

- all Markdown links resolve;
- old paths and old names are not referenced;
- public entrypoints are represented in a coverage matrix or documented reason for exclusion;
- examples are runnable or labeled pseudo/conditional;
- architecture diagrams match text;
- one fact has one owner;
- AGENTS or equivalent drift rules match the new doc system;
- remaining gaps are explicitly reported.

## Reference Files

Load only what the task needs.

Structure and migration:
- `references/doc-system-outline.md`
- `references/doc-index-template.md`
- `references/migration-checklist.md`
- `references/rewrite-checklist.md`
- `references/consistency-checklist.md`
- `references/change-sync-rules.md`

Architecture, modules, mechanisms:
- `references/architecture-template.md`
- `references/module-template.md`
- `references/design-template.md`
- `references/mechanism-spec-template.md`

Manual and lifecycle:
- `references/user-doc-template.md`
- `references/scenario-path-index.md`
- `references/lifecycle-example-template.md`
- `references/lifecycle-index-template.md`
- `references/lifecycle-phase-template.md`

Developer contracts and config:
- `references/contracts-template.md`
- `references/interface-contract-template.md`
- `references/interface-index-template.md`
- `references/api-config-template.md`
- `references/config-reference-template.md`
- `references/adapters-delta-template.md`

Storage:
- `references/storage-overview-template.md`
- `references/storage-schema-template.md`
- `references/storage-index-template.md`
- `references/storage-domain-overview-template.md`
- `references/storage-relationships-template.md`

Ops and reference:
- `references/ops-doc-structure.md`
- `references/ops-runbook-template.md`
- `references/ops-troubleshooting-template.md`
- `references/ops-handoff-template.md`
- `references/reference-glossary-template.md`
- `references/reference-conventions-template.md`
- `references/reference-structure-template.md`
- `references/writing-style.md`
