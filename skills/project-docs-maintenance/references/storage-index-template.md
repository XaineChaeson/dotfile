# Storage Index

## Purpose
- What this storage system supports.
- How to navigate the domains.

## Domain map
| Domain | Focus | Tables | Primary producers | Primary consumers |
| --- | --- | --- | --- | --- |
| event_ledger | Event ledger | `events` | all services | analytics |
| market | Market data | `crypto_klines_1m`, `poly_book_snapshots` | market_data | modeling, strategy |
| decision | Predictions + signals | `predictions`, `signals` | modeling, strategy | execution |
| orders | Orders | `orders` | execution | ops |

## Cross-domain relationships
- Link to the relationships page.

## Entry points
- Per-domain overview links.
- Per-table links.

## Related docs
- Storage overview:
- Data relationships:
- Conventions:
