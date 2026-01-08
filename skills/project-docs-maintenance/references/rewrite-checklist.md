# Rewrite Checklist

Use when doing a full documentation rewrite.

## 1) Establish source of truth
- Treat code and tests as authoritative.
- Ignore legacy docs unless explicitly verified.

## 1.5) Define scope
- List user/dev/ops/reference docs in scope.
- Identify single-source docs (API overview, interfaces, contracts).

## 2) Decide keep/remove
- Keep only docs that match current code.
- Move outdated docs to archive with clear labels.

## 3) Rebuild core docs
- Recreate index and navigation first.
- Rewrite overview, architecture, and contracts from scratch.
- Rebuild user docs with minimal set (index, quickstart, scenario index, API overview, troubleshooting).

## 4) Re-derive examples
- Regenerate examples from code entrypoints.
- Mark pseudocode explicitly if not runnable.

## 5) Contract verification
- Ensure strict IO specs match implementation.
- Add adapter delta docs for deviations.
- Ensure API overview table matches interfaces list.

## 6) Consistency pass
- Validate links and doc map.
- Run the consistency checklist.
