# Examples Catalog

Use these patterns as reusable formats, not as copy.

## Global rules
- Name examples with a verb: "Import data", "Generate report".
- Use concrete placeholders: `$TOKEN`, `<project-id>`, `<path>`.
- Every example must be runnable or explicitly marked as pseudo.

## Example pattern: quickstart
Required fields:
- Goal (1 sentence)
- Setup steps (3-5 bullets)
- Minimal import / install
- Single run example
- Expected output (1-2 lines)

## Example pattern: mechanism summary
Required fields:
- Scope paragraph (what it covers, what it doesn't)
- Steps (3-7 bullets)
- Optional Mermaid diagram

## Example pattern: interface query
Required fields:
- Summary
- Minimal usage
- Key parameters (3-5 max)
- Returns (shape only)
- Errors (2-3 common)

## Example pattern: module boundary
Required fields:
- Responsibility
- Entrypoints
- Inputs/outputs
- Failure modes
- Known constraints

## Anti-patterns
- Hidden dependencies
- Multi-step examples without outputs
- Parameters list without defaults or constraints
