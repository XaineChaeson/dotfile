# Rewrite Checklist

Use when doing a full documentation rewrite.

## 1) Establish source of truth
- Treat code and tests as authoritative.
- Ignore legacy docs unless explicitly verified.

## 1.5) Define scope
- List architecture/manual/dev/scenarios/prd/ops/reference docs in scope.
- Identify single-source docs: architecture, manual, contracts, config, scenarios, storage, ops, reference.

## 2) Decide keep/remove
- Keep only docs that match current code.
- Move outdated docs to archive with clear labels.

## 3) Rebuild core docs
- Recreate index and navigation first.
- Rewrite overview, architecture, manual, and contracts from current code and accepted design.
- Rebuild manual/user docs with a minimal set: index, quickstart, lifecycle/operations, configuration, troubleshooting.

## 4) Re-derive examples
- Regenerate examples from code entrypoints.
- Mark pseudocode explicitly if not runnable.
- Add a full lifecycle walkthrough when modules have multi-step lifecycles.
- If the lifecycle is split, ensure the index page includes a full coverage matrix and a runnable happy-path subset.

## 5) Contract verification
- Ensure strict IO specs match implementation.
- Add adapter delta docs for deviations.
- Ensure public entrypoint coverage matches code/tooling inventory and links to design/contract sources.

## 6) Consistency pass
- Validate links and doc map.
- Run the consistency checklist.
