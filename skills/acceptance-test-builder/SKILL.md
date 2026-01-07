---
name: acceptance-test-builder
description: Generate and run business-meaningful acceptance tests using Python scripts and chrome-devtools. Use when users ask to validate interface functionality, perform user-journey verification, run real-environment acceptance tests, or diagnose logic bugs from real usage results. Triggered by requests involving interface testing, login UI verification, chrome-devtools usage, or online scenario validation.
---

# Acceptance Test Builder

## Overview

Create and run user-perspective acceptance tests, starting from a confirmed acceptance criteria document, then generating scripts and iterating until the tests pass.

## Workflow

### 1) Collect inputs

Request only what is necessary to run a user-perspective acceptance flow:
- Feature checklist (user-visible capabilities)
- Environment base URL / RPC / API endpoint
- Accounts or credentials (or confirm unauthenticated flow)
- Required secrets/tokens/headers and how to provide them
- Expected outcomes per step (what a user should observe)
 - Parameter choices and defaults (env vars, flags, or config file)

If external info is required for validation, ask for permission to use network access and request any needed keys or endpoints.

### 2) Generate acceptance criteria document (multi-round)

Acceptance criteria define test effectiveness, so do not proceed without explicit user confirmation.

Process:
1. Draft an acceptance criteria document.
2. Review with the user and revise until confirmed.
3. Only after confirmation, proceed to test script generation.

Include in the document:
- Scope and non-scope
- Preconditions (accounts, data, balances, environment)
- Feature checklist with expected results
- Negative/edge cases if applicable
- Observability requirements (logs, UI, API responses)

Store this as `references/acceptance-template.md` or a project-specific variant the user provides.

### 3) Prepare test data

After acceptance criteria are confirmed:
- Identify required test data (accounts, balances, entities, fixtures)
- Ask the user to confirm data creation steps or provide inputs
- Document any data setup so the script can be rerun consistently

### 4) Build acceptance scripts

Generate Python scripts that follow this structure:
1. Config + env injection
2. Connection or session setup
3. User-journey steps (ordered, numbered)
4. Assertions or checks for each step
5. Cleanup or exit summary

Step format must be consistent:
- `STEP <n>: <action>`
- `EXPECTED: <user-visible result>`
- `OBSERVED: <actual result or signal>`
- `RESULT: PASS | FAIL`

Behavior rules:
- Prefer end-to-end flows over isolated unit logic
- Each step must log a concise, human-readable status line
- Stop on failure with a clear error message in each run
- Allow dry-run or no-op modes when destructive actions exist
- Use chrome-devtools only when a UI flow is explicitly required
- Print an environment snapshot at start (critical env vars, URLs, versions)
- Cleanup is limited to non-destructive local actions or explicitly approved reversals

Parameterization:
- Prefer a config JSON file for runtime choices; use env vars only for overrides
- Document accepted parameters in the acceptance criteria doc or the script header
- Always log the config path in the environment snapshot

Script placement:
- Default output path: `tests/manual/acceptance.py`
- Keep project acceptance scripts under `tests/manual/` for consistent separation from unit tests

If tools or libraries are missing, explicitly tell the user what to install and why.

### 5) Run, debug, and iterate until passing

- Run the script and output a text summary
- Save a full log for each run (stdout + summary) for diffing and debugging
- If failures occur, propose likely root causes and the next debugging action
- Fix or suggest fixes (including code changes), then re-run until the acceptance criteria pass
- Only stop early if the user explicitly requests it

## Bundled resources

- `scripts/generate_tests.py`: create a runnable test skeleton from a feature list
- `scripts/run_acceptance.py`: single entry point for execution and summary
- `references/acceptance-template.md`: generic acceptance checklist format
- `references/env-contract.md`: permissions, secrets, environment variables required
- `assets/test_templates/`: script templates (if present)
