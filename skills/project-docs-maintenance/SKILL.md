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
- Mechanism docs prioritize decision logic and narrative overview, not code-level detail.
- Define terminology once in the glossary when used in mechanism specs.
- Default to recommendations unless the user explicitly requests template edits or doc changes.
- Lifecycle examples default to a single page with full public entrypoint coverage plus a runnable happy-path subset.
- Full coverage means every public entrypoint listed in `docs/dev/interfaces/*` appears in the coverage matrix and the walkthrough.
- Steps that are not directly runnable must be labeled as conditional/pseudo and include preconditions.
- Split lifecycle examples only by module/product/phase when there are distinct lifecycles or many entrypoints with branching phases.
- If split, use an index + phase pages (max depth 2); the index must include full coverage matrix, sequence summary, and a runnable happy-path subset.
- Never split based on line count alone.

## Workflow

### 1) Assess complexity and choose scope
Score each dimension as Low/Med/High based on current repo state:
- Entrypoints: number of APIs/CLIs/config entrypoints.
- Modules: number of core modules and adapters.
- Mechanisms: decision logic complexity, state machines, async flows, reconciliation, retries.
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
- Prefer annotated examples with explicit constraints and preconditions.
- For modules with multi-step lifecycles or multiple public entrypoints, add one full coverage lifecycle walkthrough in user docs (use references/lifecycle-example-template.md).
- The walkthrough must cover all public entrypoints in `docs/dev/interfaces/*` and include a runnable happy-path subset.
- Keep lifecycle walkthroughs on a single page by default; split only when the lifecycle becomes distinct by module/product/phase.
- If split, create a lifecycle index and phase pages (use references/lifecycle-index-template.md and references/lifecycle-phase-template.md).
- When non-trivial decision logic exists, create a mechanism spec (use references/mechanism-spec-template.md).
  - Trigger when any two apply: multi-path decisions; state/time dependence; guardrails/thresholds; config interactions; irreversible side effects.
  - Mechanism specs must include narrative overview, terminology, detailed decision rules (purpose/inputs/steps/state/outputs/edge cases), mode matrix (if applicable), input coverage matrix, math-level example, real-world example, and observability semantics.
  - Link mechanism specs from design, module, and architecture docs; avoid duplicating rule details.
  - Ensure terms used in mechanism specs appear in the glossary.
- For modules with any of: background threads/processes, state store reads/writes, multiple entrypoints, or a mechanism spec, add Module Flow Diagrams to the module doc (use references/module-template.md).
  - Provide two diagrams: Runtime/Startup Dependencies and Data Dependencies (Read/Write).
  - Split data dependencies into 2–3 lanes; label store edges with `read`/`write`.
  - Avoid cross-lane edges by using node annotations; keep 6–10 nodes per diagram.
  - Mermaid labels: wrap labels in quotes, avoid parentheses, use `<br/>` for line breaks, and keep labels short.
    If parentheses are unavoidable, use HTML entities `&#40;` and `&#41;`.
  - In module docs, split state stores into 2–4 semantic nodes (e.g., snapshot, schedule, locks, orders).
  - List full state keys below the diagram (do not cram into nodes) using a table with Key/Access/Purpose/Example.
- Maintain a reference conventions page with a full state semantics table (Key/Meaning/Producer/Consumers/Example)
  and link to it from architecture and module docs.
- Put strict interface IO contracts in dev/contracts.
- Keep user-facing API pages as a short "API overview" only.
- Keep parameters and IO specs only in dev/interfaces; user docs link instead of repeating.
- When persistent storage exists (Postgres or equivalent), maintain two layers of storage docs:
  - A storage overview that explains the data system as a whole (tables, roles, event-to-table mapping, relationships, record flow).
  - Per-table docs that define columns, keys, and lifecycle details.
- If storage spans multiple business domains, split storage docs by business object domain:
  - Domains are defined by what the data represents (e.g., market data, decisions, orders), not by service ownership.
  - Keep `events` as a separate "event ledger" domain when it stores the full event envelope for all event types.
  - Merge tightly coupled decision artifacts (e.g., predictions + signals) into a single "decision" domain when they form one business flow.
  - Always add a cross-domain relationships page when domains are split.
- Maintain full config parameters in a dedicated dev config doc (`docs/dev/config.md` or `docs/dev/config/`) when any of the following apply:
  - Config parameters > 8–10.
  - Config is shared across multiple modules/services.
  - Config changes are frequent or impact behavior materially.
  - Multiple environments or profiles require different defaults.
- For small/simple configs, an interface doc may include config details, but still keep a single source of truth.
- Add adapter delta docs for instance-specific deviations when needed.
- Storage docs guidance:
  - Use references/storage-overview-template.md for the system-level storage view.
  - Use references/storage-schema-template.md for per-table docs.
  - The overview must include a record-flow diagram that shows how events write into tables across the full business flow.
  - Per-table docs must include nullability/defaults, keys/indexes, relationships, lifecycle, data quality rules, and an example row.
  - If domains exist, add:
    - references/storage-index-template.md for the storage landing page.
    - references/storage-domain-overview-template.md for per-domain overviews.
    - references/storage-relationships-template.md for cross-domain relationships.

### 7) Align with code
- Verify entrypoints, configs, defaults, and error conditions.
- Update docs to match current code paths and naming.

### 8) Consistency pass
- Use references/consistency-checklist.md.
- Apply references/change-sync-rules.md if present.

## Output expectations
- Users: quick usage, clear overview, and readable API/config queries, plus a full coverage lifecycle example with annotated roles.
- Lifecycle examples include a complete coverage matrix, a full annotated walkthrough, and a runnable happy-path subset (main page or index when split).
- Developers: precise definitions, decision points, and boundaries.
- Module docs include flow diagrams when concurrency or stateful stores exist.
- Module docs list full state keys touched with access level and examples; conventions define canonical meaning.
- Storage docs include a system overview (table roles, mappings, relationships, record-flow diagram) and per-table definitions (schema, keys, lifecycle).
- For multi-domain storage, docs include a storage index, per-domain overviews, and a cross-domain relationships page.
- Mechanism specs include narrative overview, detailed decision rules, and reproducible examples; terms are defined in the glossary.
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
- references/mechanism-spec-template.md
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
- references/ops-doc-structure.md
- references/config-reference-template.md
- references/storage-overview-template.md
- references/storage-schema-template.md
- references/storage-index-template.md
- references/storage-domain-overview-template.md
- references/storage-relationships-template.md
- references/lifecycle-example-template.md
- references/lifecycle-index-template.md
- references/lifecycle-phase-template.md
- references/reference-glossary-template.md
- references/reference-conventions-template.md
- references/reference-structure-template.md
