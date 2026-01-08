# Migration Checklist

Use when restructuring docs into functional partitions.

## 1) Map
- List current docs and target destination.
- Ensure each doc has a single clear home (user/dev/ops/reference/archive).
- Flag duplicates and pick a single source of truth.

## 2) Move
- Create target directories.
- Move files in one pass to reduce drift.

## 3) Rebuild entrypoints
- Create a single `docs/index.md` entry.
- Add user-first navigation followed by dev/ops/reference.
- Ensure `docs/user/` uses the minimal set (index, quickstart, scenario index, API overview, troubleshooting).
- Add `docs/dev/interfaces/` index if interfaces are split.

## 4) Rewrite links
- Batch-replace old paths with new paths.
- Update in-doc references and cross-links.
- Add deprecation notes in archived docs pointing to new canonical pages.

## 5) Verify
- Grep for old paths and fix remaining references.
- Ensure archived docs point to new canonical docs.

## 6) Final review
- Confirm user docs contain only usage materials.
- Confirm dev docs contain contracts and boundaries.
- Confirm ops docs contain only runtime and troubleshooting.
- Confirm API overview table is the only capability scan table.
