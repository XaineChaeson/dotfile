# Migration Checklist

Use when restructuring docs into functional partitions.

## 1) Map
- List current docs and target destination.
- Ensure each doc has a single clear home (user/dev/ops/reference/archive).

## 2) Move
- Create target directories.
- Move files in one pass to reduce drift.

## 3) Rebuild entrypoints
- Create a single `docs/index.md` entry.
- Add user-first navigation followed by dev/ops/reference.

## 4) Rewrite links
- Batch-replace old paths with new paths.
- Update in-doc references and cross-links.

## 5) Verify
- Grep for old paths and fix remaining references.
- Ensure archived docs point to new canonical docs.

## 6) Final review
- Confirm user docs contain only usage materials.
- Confirm dev docs contain contracts and boundaries.
- Confirm ops docs contain only runtime and troubleshooting.
