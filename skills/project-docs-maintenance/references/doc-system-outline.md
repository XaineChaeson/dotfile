# Documentation System Outline

Use this as a starting shape, not a mandatory tree. Adapt names to the repo.

## Common goals
- Users find the shortest correct path to first success.
- Developers find exact contracts, invariants, and extension rules.
- Operators find runbooks and recovery paths.
- Stable decisions have one durable source of truth.
- Navigation maps every public entrypoint to usage docs, design/contract docs, and validation evidence.

## Recommended partition

```text
README.md                    # repository entrypoint
docs/
  README.md                  # documentation map
  project-status.md          # current phase and fact-source index, when useful
  prd/                       # product goals and acceptance criteria
  architecture/              # stable boundaries, components, data flow, tradeoffs
  manual/                    # setup, quickstart, lifecycle, operations, troubleshooting
  dev/                       # contracts, implementation design, config governance
  scenarios/                 # concrete examples, instances, acceptance evidence
  ops/                       # deployment, runbooks, incident response
  reference/                 # glossary, conventions, shared schemas
  archive/                   # superseded docs
```

## Scope guide

Small:
- root README;
- docs index;
- quickstart/manual page;
- architecture overview;
- core contracts or API overview.

Medium:
- Small plus lifecycle coverage matrix;
- scenario index;
- troubleshooting;
- dev contracts and config docs;
- storage overview if persistence exists.

Large:
- Medium plus module docs;
- mechanism specs;
- storage domains and per-table docs;
- reference conventions;
- ops runbook and handoff;
- archive/migration plan.

## Layer ownership rules

- Architecture owns stable boundaries and diagrams.
- Manual owns executable usage paths.
- Dev owns strict IO/config/error contracts and implementation constraints.
- Scenarios own concrete vendors, markets, tasks, topic names, tables, fixtures, acceptance data.
- Project status owns current phase and fact-source index.
- Reference owns shared terms and conventions.

If a section answers more than one layer's question, split it.

## Required navigation

- Root entry points to docs index, project status, architecture, manual, and dev docs.
- Docs index explains layers and links to the most common reading paths.
- Each major layer has an index page.
- Lifecycle pages include an entrypoint coverage matrix:
  `Entrypoint | User Doc | Design / Contract Source | Validation Evidence`.
