# Refactor SOP Reference

## Entry Checklist

- Read project constraints and logging rules.
- Confirm scope (which directories are in-scope).
- Capture current test status.

## Inventory Checklist

- Entry points: CLI/run scripts, config loaders.
- Core mechanisms: reconcile/rolling/round/takeover/shutdown.
- Logging map: ops/orders/market events.
- Tests map: key behavior coverage and gaps.

## Refactor Heuristics

- Split functions > 60 lines into: precheck, compute, commit/log.
- Make helpers single-purpose; keep names precise.
- Avoid new config fields or behavior changes without explicit approval.
- Preserve log event names and fields.
- Keep external API responses available on errors (raw_response).

## Decision Log Template

- Decision: <why split/merge/remove>
- Impact: <modules/logs/tests affected>
- Compatibility: <behavior unchanged?>
- Rollback: <how to revert>
- Evidence: <tests run>

## Risk List Template

- Risk: <what could break>
- Trigger: <conditions>
- Mitigation: <tests/logs>
- Owner: <who confirms>

## Documentation Sync Triggers

- Config changes: update schema/README/examples.
- Log changes: update logging guide.
- Core mechanism changes: update execution docs/runbook.

## Exit Checklist

- Unit tests pass.
- No new config fields.
- Logs still searchable by legacy event names.
- SOP updated with decisions + risks.
