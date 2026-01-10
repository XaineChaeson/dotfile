# Lifecycle Phase Template

Use this for a phase or product-specific page linked from the lifecycle index.
Do not repeat the full lifecycle; keep this page focused.

## Goal
- <Phase or product goal in one sentence>

## Preconditions
- Auth/config required.
- Required environment state.

## Interfaces in this phase
| Interface | Role | Side effects | Link |
|----------|------|--------------|------|
| <module.Class.method> | <role> | <state/external changes> | <doc link> |

## Steps (annotated)
1) **<step name>**
   **Call**: `<module.method(...)>`
   **Inputs**: <key params>
   **Output**: <return shape>
   **State change**: <state transition or side effects>
   **Why this interface**: <role in lifecycle>

## Example (annotated)
> Mark as pseudo if not runnable.

```pseudo
<phase example>
```

## Error + recovery path
- <error> -> <recovery interface> -> <post state>

## Related docs
- <Lifecycle index>
- <Interface contracts>
