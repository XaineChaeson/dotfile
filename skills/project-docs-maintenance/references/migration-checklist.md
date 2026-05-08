# Migration Checklist

Use when restructuring docs into functional partitions.

## 1) Map
- List current docs and target destination.
- Ensure each doc has a single clear home (architecture/manual/dev/scenarios/prd/ops/reference/archive).
- Flag duplicates and pick a single source of truth.

## 2) Move
- Create target directories.
- Move files in one pass to reduce drift.

## 3) Rebuild entrypoints
- Create or update the repo/documentation entrypoints (`README.md`, `docs/README.md`, or local equivalent).
- Add layered navigation for project status, architecture, manual, dev, scenarios, ops, and reference.
- Ensure manual/user docs use a minimal action-oriented set: index, quickstart, lifecycle/operations, configuration, troubleshooting.
- Add a public entrypoint index or coverage matrix if entrypoints are split across CLI/API/SDK/config/UI.

## 4) Rewrite links
- Batch-replace old paths with new paths.
- Update in-doc references and cross-links.
- Add deprecation notes in archived docs pointing to new canonical pages.

## 5) Verify
- Grep for old paths and fix remaining references.
- Ensure archived docs point to new canonical docs.

## 6) Final review
- Confirm manual/user docs contain only usage materials.
- Confirm architecture docs are not buried inside dev docs unless the repo is too small to justify separate layers.
- Confirm dev docs contain contracts and implementation constraints.
- Confirm ops docs contain only runtime and troubleshooting.
- Confirm entrypoint coverage has one canonical matrix or index.
