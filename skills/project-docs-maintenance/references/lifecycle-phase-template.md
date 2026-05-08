# Lifecycle Phase Template

Use this for a phase or product-specific page linked from the lifecycle index.
Do not repeat the full lifecycle; keep this page focused.

## Goal
- <Phase or product goal in one sentence>

## Preconditions
- Auth/config required.
- Required environment state.

## Entrypoints in this phase
> Must include every public entrypoint used in this phase and mark runnable status.

| Entrypoint | Role | Runnable? | Preconditions / Notes | Design / Contract Source | Validation Evidence |
| --- | --- | --- | --- | --- | --- |
| <entrypoint> | <role> | <yes/no/conditional> | <constraints> | <doc link> | <command/test/link> |

## Steps (annotated)
1) **<step name>**
   **Call**: `<module.method(...)>`
   **Inputs**: <key params>
   **Output**: <return shape>
   **State change**: <state transition or side effects>
   **Why this entrypoint**: <role in lifecycle>
   **Runnable**: <yes/no/conditional>
   **Preconditions**: <assumptions/limits>

## Example (annotated)
> Must be runnable or explicitly labeled as pseudo.

```pseudo
<phase example>
```

## Error + recovery path
- <error> -> <recovery entrypoint> -> <post state>

## Related docs
- <Lifecycle index>
- <Dev contracts>
