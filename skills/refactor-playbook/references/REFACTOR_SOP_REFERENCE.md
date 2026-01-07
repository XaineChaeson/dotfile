# Refactor Playbook Reference

## Entry Checklist

- Read repo constraints and contribution guidelines.
- Confirm scope (directories, services, modules).
- Capture current test/verification status.
- Confirm refactor depth level and resolve any required decisions before work starts.

## Inventory Checklist

- Entry points: CLI, jobs, HTTP handlers, event consumers.
- Core flows: main request/processing paths and side effects.
- Observability map: logs, metrics, traces used for ops.
- Tests map: coverage and known gaps.

## Refactor Heuristics

- Split large functions into focused helpers.
- Reduce deep nesting with early exits.
- Extract shared logic to remove duplication.
- Avoid behavior or contract changes without explicit approval.
- Keep observability stable unless explicitly approved.

## Verification Tactics (Minimal)

- Golden outputs: capture baseline outputs before changes.
- Diff snapshots: compare outputs or serialized results after changes.
- Focused scripts: run one or two core paths repeatedly.

## Minimal Verification Checklist

- Baseline captured for a known input or flow.
- One repeatable check script or command documented.
- Output/behavior comparison method defined (diff, snapshot, logs).
- Smoke path executed after each batch.

## Batch Strategy

- Call path batches: refactor one entry path at a time.
- Surface batches: keep the behavior slice small and reviewable.
- Structure batches: isolate a module or layer before deeper changes.

## Batch Split Example (Template)

- Target scope: <module/path>
- Entry path: <CLI/HTTP/worker/queue>
- Behavior slice: <describe small user/system behavior>
- Expected invariants: <must remain true>
- Verification: <tests/checks run>

## Risk Levels

- Low: local refactor, behavior unchanged, easy to verify.
- Medium: shared logic or multiple callers; add checks.
- High: broad behavior surface or weak verification; reduce batch size.

## Depth Selection Cues

- Level 1 (Hygiene): rename, extract helpers, reduce nesting, remove dead code.
- Level 2 (Structural): split modules, isolate side effects, introduce seams for testing.
- Level 3 (Architectural): redesign boundaries or core abstractions.
- Declare the depth level before starting and justify any escalation.

## Decision Log Template

- Decision: <why split/merge/remove>
- Impact: <modules/tests/observability affected>
- Compatibility: <behavior unchanged?>
- Rollback: <how to revert>
- Evidence: <tests or checks run>

## Risk List Template

- Risk: <what could break>
- Trigger: <conditions>
- Mitigation: <tests/monitoring>
- Owner: <who confirms>

## Documentation Sync Triggers

- Contract changes: update API docs or schemas.
- Config changes: update examples and references.
- Workflow changes: update runbooks or onboarding notes.

## Exit Checklist

- Tests/checks pass for the touched surface.
- External contracts unchanged (or explicitly approved).
- Observability still reliable.
- Decisions and risks recorded.
