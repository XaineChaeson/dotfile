# Lifecycle Phase Template

Use this for a phase or product-specific page linked from the lifecycle index.
Do not repeat the full lifecycle; keep this page focused.

## Goal
- <Phase or product goal in one sentence>

## Preconditions
- Auth/config required.
- Required environment state.

## Interfaces in this phase
> Must include every interface used in this phase and mark runnable status.

| Interface | Role | Runnable? | Preconditions / Notes | Link |
|----------|------|-----------|-----------------------|------|
| <module.Class.method> | <role> | <yes/no/conditional> | <constraints> | <doc link> |

## Steps (annotated)
1) **<step name>**
   **Call**: `<module.method(...)>`
   **Inputs**: <key params>
   **Output**: <return shape>
   **State change**: <state transition or side effects>
   **Why this interface**: <role in lifecycle>
   **Runnable**: <yes/no/conditional>
   **Preconditions**: <assumptions/limits>

## Example (annotated)
> Must be runnable or explicitly labeled as pseudo.

```pseudo
<phase example>
```

## Error + recovery path
- <error> -> <recovery interface> -> <post state>

## Related docs
- <Lifecycle index>
- <Interface contracts>
