# Interface Contract (IO Spec)

Use this for strict interface-level IO contracts. Keep instance-specific deviations out.

## Summary
- Purpose and boundary of the interface.

## Global constraints
- Required runtime assumptions (auth, default account, env, etc.).
- Input normalization rules.

## Functions
For each function:

### <function_name>
- Inputs:
  - Types, required/optional, ranges.
- Constraints:
  - Valid combinations, boundary conditions.
- Outputs:
  - Structure and semantics.
- Errors:
  - Validation errors vs runtime errors.

## Notes
- Link to adapter deltas and relevant PRD/design docs.
