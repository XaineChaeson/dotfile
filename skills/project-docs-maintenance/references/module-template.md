# Module: <name>

## Purpose
- One sentence describing responsibility and boundary.
- What this module does not do.

## Entrypoints
- Classes/functions/commands exposed.

## Inputs and outputs
- Inputs: types and constraints.
- Outputs: structures and semantics.
- Link to interface contracts for full IO details.

## Dependencies
- Upstream dependencies and required services.
- Downstream consumers.

## Directory layout
```text
<module>/
  <subdir>/
  <key_file>.py
```

## State and lifecycle
- Key states and transitions.

## Mechanism summary
- 3-5 sentences describing the decisions this module makes and why.
- Keep this at behavior level; avoid implementation details.

## Mechanism spec (link)
- Required when decision logic is non-trivial or stateful.
- Link to the mechanism spec; do not duplicate rule details.

## Error handling
- Common failures and recovery paths.

## Performance and limits
- Throughput/latency considerations.
- Rate limits or size bounds.

## Examples
- Minimal and typical usage (2-3 examples max, not full API coverage).
- Link to a full lifecycle example when the module has a multi-step lifecycle.

## Full lifecycle example (link)
- Required when the module exposes multiple public entrypoints or recovery flows.
- Link to the user-facing lifecycle example (single page or lifecycle index); do not duplicate full IO details.

## Related docs
- Links to PRD, design, interface contracts, or other modules.
