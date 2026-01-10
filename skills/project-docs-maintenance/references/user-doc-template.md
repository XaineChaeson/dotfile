# User Doc Template

Use this for `docs/user/` pages to keep structure and tone consistent.

## Purpose
- What this page helps the user do.
- Who this page is for.
 - Core question this page answers (single responsibility).

## Minimal example
```bash
<short runnable example>
```

## Main content
- <primary steps or explanation>
- <key options or constraints>

## Full lifecycle example
- Required when the module has multiple public entrypoints or a multi-step lifecycle.
- Use annotated steps and explain each API's role in the lifecycle.
- Coverage must include all public entrypoints in `docs/dev/interfaces/*`.
- Keep a single-page walkthrough when possible.
- If split, link to a lifecycle index that includes a full coverage matrix and a runnable happy-path subset.

## Common pitfalls
- <what breaks, why, and how to avoid it>

## Related docs
- <links to deeper docs>
