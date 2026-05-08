# Dev Docs Index Template

One-paragraph summary of developer-facing documentation and where to start. Do not place architecture rationale or user tutorials here unless this repo intentionally has no separate layer.

## Developer Reading Order

1. Architecture boundary: `<architecture module doc>`
2. Implementation design: `<implementation design>`
3. Contracts: `<contracts path>`
4. Config/schema governance: `<config or persistence docs>`
5. Scenario / acceptance evidence: `<scenario path>`

## Engineering References

| Document | Purpose |
| --- | --- |
| `<implementation design>` | directories, runtime shape, module ownership, implementation sequencing |
| `<contracts>` | IO, errors, validation rules, extension points |
| `<config contract>` | env/config/default/error semantics |
| `<storage contract>` | table descriptor, schema, lifecycle, migrations |
| `<interface index>` | public API/CLI/SDK entrypoints, if split |

## Drift Rules

- Public entrypoint changes update manual lifecycle coverage.
- Config changes update manual configuration and dev config contract.
- Schema/migration changes update storage docs and scenarios.
- Boundary/data-flow changes update architecture diagrams.

## Related Docs

- Architecture: `<architecture index>`
- Manual: `<manual index>`
- Scenarios: `<scenario index>`
- Operations: `<ops index>`
