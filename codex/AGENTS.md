## Multi-agent orchestration

Codex is authorized to decide autonomously, without waiting for an explicit
request, whether subagents would materially improve the current task. The main
agent should judge this from the task's complexity, decomposability, context
isolation needs, and the expected speed or quality gain relative to token and
coordination cost. Use no subagents when their marginal value is unclear.

When delegating:

- Determine the number of subagents dynamically from the independent
  workstreams that are actually useful. Treat the configured concurrency limit
  as a safety ceiling, not a target.
- Select each subagent's model and reasoning effort dynamically for its bounded
  workstream. Prefer the least expensive combination likely to complete it
  reliably, and increase capability or effort for ambiguity, high-risk work,
  deep cross-component reasoning, or difficult synthesis.
- Give every subagent a distinct, non-overlapping outcome. Do not duplicate the
  main agent's work. Have the main agent integrate and verify all results.
- Give each subagent the smallest useful context. Prefer a bounded recent-turn
  fork or no inherited turns when the workstream can be stated self-contained;
  use full-history forks only when the full conversation is essential.

Stop spawning when another subagent would not add independent evidence or
execution capacity. Subagents must not spawn further subagents unless I
explicitly request recursive delegation.

## Local sudo authentication

- When an authorized task on this machine genuinely requires `sudo`, first try
  the existing non-interactive credential cache. If authentication is still
  required, the local-only file `~/.codex/secrets/sudo.env` contains exactly one
  env-style record named `sudo` for this purpose. The password may contain shell
  quote characters, so do not `source` the file; split the single line at its
  first `=` and treat the remainder as the literal password.
- Before use, require that `~/.codex/secrets` is a real directory owned by the
  current user with mode `0700`, and that the credential is a non-symlink
  regular file owned by the current user with mode `0600` and exactly one hard
  link. Keep the credential outside every Git worktree. Never print its value,
  include it in a command argument, export it to a child environment, or place
  it in logs, snapshots, reports, tests, documentation, commits, or chat output.
- Read it only into a non-exported variable in the short-lived controller
  shell, pass the value to `sudo -S -p ''` through the shell builtin `printf`,
  and unset it immediately. If the file or its safety properties are invalid,
  stop rather than falling back to an exposed credential path.
