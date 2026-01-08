# Interface Contract (IO Spec)

Use this for strict interface-level IO contracts. Keep instance-specific deviations out.
For large projects, split interfaces by domain or capability and add an index page that links to each interface file.

## Summary
- Purpose and boundary of the interface.
- Stability and versioning policy.

## Global constraints
- Required runtime assumptions (auth, default account, env, etc.).
- Input normalization rules.
- Rate limits, pagination, and idempotency rules (if applicable).
- Side effects and consistency guarantees.

## Functions
For each function:

### <function_name>

**Signature**: `module.Class.method(arg1, arg2=...)`

**Purpose**: <one sentence>

**Inputs**
| Name | Type | Required | Default | Constraints | Notes |
|------|------|----------|---------|-------------|-------|
|      |      |          |         |             |       |

**Outputs**
| Field | Type | Description |
|-------|------|-------------|
|       |      |             |

**Errors**
| Code | Trigger | Handling |
|------|---------|----------|
|      |         |          |

**Examples**
```json
{"request": "...", "response": "..."}
```

## Notes
- Link to adapter deltas and relevant PRD/design docs.
