# Mechanism Spec: <name>

Use this to document non-trivial decision logic and behavior. This spec is the
single source of truth for mechanism rules. Do not copy implementation details.

## Design overview (narrative)
- Write 1-3 short paragraphs.
- Explain why this mechanism exists, what it solves, and how it fits the system.
- Keep it readable for non-implementation readers.

## Scope / non-goals
- Scope:
- Non-goals:

## System context
- Upstream inputs (data/config/state).
- Downstream effects (side effects, outputs).
- External dependencies (if any).

## Mechanism map (sub-mechanisms)
| Sub-mechanism | Purpose | Trigger | Outputs | Notes |
|--------------|---------|---------|---------|-------|
|              |         |         |         |       |

## Terminology (link to glossary)
| Term | Meaning | Why it matters | Glossary link |
|------|---------|----------------|---------------|
|      |         |                |               |

## Inputs and invariants
- Inputs:
- Required state:
- Invariants and guardrails:

## Decision rules (detailed)
> For each rule, include purpose, inputs, steps, state updates, outputs, and edge cases.

### Rule: <name>
**Purpose**
- <why this rule exists>

**Inputs**
- <inputs and required state>

**Steps**
1) <step>
2) <step>

**State updates**
- <state changes, if any>

**Outputs**
- <behavior/result>

**Edge cases / guardrails**
- <conditions and handling>

**Observability (optional)**
- <signals or logs that reflect this rule>

## Mode matrix (if applicable)
| Mode | Inputs | Decision logic | Output behavior | Constraints | Related rules |
|------|--------|----------------|-----------------|-------------|---------------|
|      |        |                |                 |             |               |

## Input coverage matrix
| Input / parameter | Decision rule(s) | Behavior impact |
|-------------------|------------------|-----------------|
|                   |                  |                 |

## Math-level example (reproducible)
> Use concrete numbers and show the steps to reach the output.

## Real-world example (config-driven)
> Use realistic parameters and show the resulting behavior.

## Failure and recovery
- Known failure modes.
- Recovery or fallback behavior.

## Observability semantics
- Key signals, what they mean, and how to interpret them.

## Related docs
- Architecture
- Module overview
- Interfaces / contracts
- Glossary
