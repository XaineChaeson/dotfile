# Documentation System Outline

## Common goals
- Fast user onboarding and easy lookup.
- Precise developer contracts and boundaries.
- Clear mapping to code entrypoints.

## S scope (small project)
- README.md: quickstart + minimal examples + links.
- docs/user/index.md
- docs/user/quickstart.md
- docs/user/api-overview.md
- docs/dev/architecture.md: short overview of modules and data flow.
- docs/dev/interfaces/: core entrypoints only.

## M scope (medium project)
- S scope, plus:
- docs/index.md: layered navigation and doc map.
- docs/user/scenario-index.md
- docs/user/troubleshooting.md
- docs/dev/modules/: module-level docs with directory layout.
- docs/dev/contracts/: cross-module contracts.
- docs/ops/RUNBOOK.md: operations and troubleshooting.
- CHANGELOG.md or docs/devlog.md: change tracking.

## L scope (large project)
- M scope, plus:
- docs/dev/design/: mechanisms, state flows, and invariants.
- docs/dev/interfaces/index.md: full interface index.
- docs/reference/: glossary, conventions, structure.
- docs/ops/troubleshooting.md
- docs/ops/handoff.md

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

## User docs (minimal, low-duplication)
- index.md: user navigation and entry points only.
- quickstart.md: shortest path to first success.
- scenario-index.md: tasks to entrypoints and examples.
- api-overview.md: entrypoint overview + API scan table.
- troubleshooting.md: common issues and self-checks.
- Optional: feature guides for high-frequency tasks only.

## Reference docs (shared definitions)
- glossary.md: canonical term definitions.
- conventions.md: naming, formats, and placeholder rules.
- structure.md: doc layout and ownership.
