# Storage Overview

## Goal
- What this storage layer exists to support.
- What it does not attempt to solve.

## Table roles
- `events`:
- <derived table>:

## Table inventory
| Table | Role | Producer (writes) | Consumers (reads) | Source event |
| --- | --- | --- | --- | --- |
| | | | | |

## Event to table mapping
| Event type | Table |
| --- | --- |
| | |

## Record-flow diagram (end-to-end)
Show how a full business flow writes into storage. Indicate one-row-per-event assumptions and where they diverge.
```mermaid
flowchart TB
  subgraph S1["producer A"]
    A1["input"]
  end
  subgraph S2["producer B"]
    B1["input"]
  end
  subgraph DB["storage"]
    T1["events"]
    T2["table_a"]
  end
  A1 --> E1["event.a"]
  E1 --> T1
  E1 --> T2
  B1 --> E2["event.b"]
  E2 --> T1
```

## Relationships
- Key linkages and join paths.
- Include a logical ER diagram when multiple derived tables exist.

```mermaid
erDiagram
  table_a ||--o{ table_b : "key"
```

## Write pattern
- Insert strategy and idempotency.
- Conflict handling or dedupe rules.

## Conventions
- Time, units, encoding, and ID conventions.
- Any JSONB payload linkage to event contracts or schemas.

## Gaps / TODO
- Missing indexes, retention rules, or backfill notes.

## Related docs
- Storage contract:
- Data relationships:
- Conventions:
- Module docs:
