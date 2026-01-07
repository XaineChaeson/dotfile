# Documentation System Outline

## Common goals
- Fast user onboarding and easy lookup.
- Precise developer contracts and boundaries.
- Clear mapping to code entrypoints.

## S scope (small project)
- README.md: quickstart + minimal examples + links.
- docs/ARCHITECTURE.md: short overview of modules and data flow.
- docs/API.md or docs/CONFIG.md: key interfaces, params, examples.

## M scope (medium project)
- S scope, plus:
- docs/INDEX.md: layered navigation and doc map.
- docs/modules/: module-level docs.
- docs/ops/RUNBOOK.md: operations and troubleshooting.
- CHANGELOG.md or docs/devlog.md: change tracking.

## L scope (large project)
- M scope, plus:
- docs/prd/: contracts, boundaries, decisions.
- docs/design/: mechanisms, state flows, and invariants.
- Overview tables and scenario path index.

## Required navigation
- Index page lists user docs first, then ops, then design/PRD.
- Each doc includes a short Related links section.

## Recommended doc partition
- docs/index.md as the single entry.
- docs/user/: user onboarding, overview, API overview, scenarios.
- docs/dev/: architecture, modules, contracts, PRD, mechanisms.
- docs/ops/: runbook, troubleshooting.
- docs/reference/: structure, glossary, conventions.
- docs/archive/: historical docs.
