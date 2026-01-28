# Storage Domain: <domain_name>

## Summary
- Business focus:
- Why this domain is separate:
- Owners:

## Tables
| Table | Role | Producer (writes) | Consumers (reads) | Source event |
| --- | --- | --- | --- | --- |
| | | | | |

## Domain record flow
```mermaid
flowchart TB
  A["input"] --> E["event"]
  E --> T1["table_1"]
```

## Domain relationships
```mermaid
erDiagram
  table_a ||--o{ table_b : "key"
```

## Write pattern
- Insert strategy and idempotency.
- Conflict handling rules.

## Conventions
- Time, units, and ID usage.
- JSONB payload linkage.

## Related docs
- Storage index:
- Storage overview:
- Cross-domain relationships:
- Table docs:
