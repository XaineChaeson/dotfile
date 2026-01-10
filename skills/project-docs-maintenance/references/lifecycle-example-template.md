# Lifecycle Example Template

Use this to show a full module lifecycle: all public entrypoints, call order,
and each interface's role in the lifecycle.

## Goal
- <User goal in one sentence>

## Scope / Non-goals
- Scope: <what this walkthrough covers>
- Non-goals: <what it does not cover>

## Preconditions
- Auth/config required.
- Required environment state.
- Required setup steps.

## Interface coverage (must be complete)
| Interface | Phase | Role in lifecycle | Side effects | Link |
|----------|-------|-------------------|--------------|------|
| <module.Class.method> | <init/setup/run/teardown> | <why it exists> | <state/external changes> | <doc link> |

## Lifecycle sequence (annotated)
> Each step must explain the interface role and the output or state change.

1) **[Phase: Init]**
   **Call**: `<module.init(config)>`
   **Inputs**: <key params>
   **Output**: <return shape>
   **State change**: <state transition or side effects>
   **Why this interface**: <role in lifecycle>

2) **[Phase: Setup]**
   **Call**: `<module.prepare(handle, options)>`
   **Inputs**: <key params>
   **Output**: <return shape>
   **State change**: <state transition or side effects>
   **Why this interface**: <role in lifecycle>

3) **[Phase: Run]**
   **Call**: `<module.execute(handle, payload)>`
   **Inputs**: <key params>
   **Output**: <result>
   **State change**: <state transition or side effects>
   **Why this interface**: <role in lifecycle>

4) **[Phase: Teardown]**
   **Call**: `<module.close(handle)>`
   **Inputs**: <key params>
   **Output**: <result>
   **State change**: <resources released>
   **Why this interface**: <role in lifecycle>

## End-to-end runnable example (annotated)
> Mark as pseudo if not runnable.

```pseudo
# 1) init: create module context and validate config
ctx = Module.init(config)

# 2) setup: prepare resources
Module.prepare(ctx, options)

# 3) run: core execution
result = Module.execute(ctx, payload)

# 4) teardown: release resources
Module.close(ctx)
```

## Error + recovery path
- <error in setup> -> <rollback interface> -> <state after rollback>
- <error in run> -> <retry/compensate interface> -> <state after recovery>

## Cleanup / Idempotency
- What must be cleaned up.
- Which interfaces are safe to retry.

## Observability (optional)
- Key logs/metrics per phase.

## Related docs
- <API overview>
- <Interface contracts>
- <Config reference>
