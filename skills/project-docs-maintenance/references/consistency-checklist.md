# Consistency Checklist

## Navigation
- Root README and docs index exist when the repo needs them.
- Major layers have index pages.
- Project status or equivalent fact-source index points to current owners.
- No links point to removed paths.
- Old names and old paths do not remain in active docs.

## Entrypoints
- Public CLI/API/SDK/UI/config/schema/job/table/queue/script entrypoints are inventoried.
- Lifecycle coverage matrix maps entrypoints to user docs, design/contract source, and validation evidence.
- Examples are runnable or explicitly labeled pseudo/conditional with preconditions.
- Defaults, required fields, and errors match code behavior.

## Layer Boundaries
- Architecture docs contain stable boundaries, data flow, diagrams, and tradeoffs.
- Manual docs contain usage, configuration, operations, lifecycle, and troubleshooting.
- Dev docs contain contracts, implementation constraints, config semantics, and extension rules.
- Scenario docs contain concrete vendors/sources/tasks/tables/examples and acceptance evidence.
- One fact has one owner; other pages link to it.

## Architecture And Mechanisms
- Architecture diagrams align with current modules and text.
- Module runtime/data dependency diagrams match actual state stores and entrypoints when present.
- Mechanism specs exist for non-trivial decision logic.
- Mechanism specs include terms, inputs, steps, state updates, outputs, edge cases, examples, and observability.
- Terms used in mechanism specs appear in glossary/reference docs when those exist.

## Storage And State
- Storage overview exists when persistent storage is material.
- Per-table docs include columns, nullability/defaults, keys/indexes, relationships, lifecycle, quality rules, and example rows when table-level details matter.
- State semantics include producer, consumers, meaning, and example when state is part of behavior.

## Drift Controls
- AGENTS/project rules reflect the current doc layers and update triggers.
- Change-sync rules exist for CLI/API/config/schema/migration/runtime changes.
- Generated or untracked artifacts are not the only durable evidence for conclusions.
