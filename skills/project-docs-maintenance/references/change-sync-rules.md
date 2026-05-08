# Change Sync Rules

Use these as a project-specific checklist. Replace placeholder paths with the repo's actual layout.

| Change | Check / Update |
| --- | --- |
| Public CLI/API/SDK/UI entrypoint added, removed, or renamed | manual lifecycle coverage matrix, user operations page, API/entrypoint overview, validation evidence |
| Config key, env var, profile, or default changes | manual configuration, dev config contract, examples/templates, troubleshooting |
| Schema, migration, table, topic, queue, or event format changes | storage docs, dev contracts, scenario docs, lifecycle validation evidence |
| Module boundary, component responsibility, or data flow changes | architecture docs and Mermaid diagrams, dev implementation design, affected scenarios |
| Runtime behavior, scheduling, retry, recovery, or state semantics change | architecture mechanism/model docs, manual lifecycle/troubleshooting, dev contracts, state/reference docs |
| Product boundary or acceptance criterion changes | PRD, scenario acceptance docs, manual happy path if user-visible |
| Concrete vendor/source/market/task instance changes | scenario docs and examples; generic architecture only links to the scenario |
| Documentation structure changes | docs index, project-status/fact-source index, AGENTS or project rules |
| Generated or untracked artifact becomes evidence | move durable summary into tracked docs or records; do not rely on untracked output paths |
