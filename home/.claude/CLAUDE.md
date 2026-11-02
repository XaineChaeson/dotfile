# Claude-only instructions

The instructions shared by every agent live in `~/.agents/AGENTS.md`:

@~/.agents/AGENTS.md

## Delegation

- Treat every executor the environment offers as one pool: other AI models through installed plugins,
  agents or CLIs, and Claude subagents. When work splits into self-contained pieces with a clear brief and
  a checkable result (implementation, refactors, tests, investigations, data runs), spread them across the
  pool so they run in parallel; do not leave an available executor idle while Claude does work it could
  take. Weigh by quota where the owner has stated it. If one cannot run, use another and note it in the report.
- Keep with Claude the work that needs this conversation's context, cross-piece coordination or judgement
  calls. Verify every delegate's result the same way.
- Route each piece by difficulty to a capability tier, not to a model. Strong tier: design, judgement calls,
  ambiguous briefs, deep cross-component reasoning, and reviewing or accepting other executors' output. Cheap
  tier: mechanical, well-specified work with a checkable result (bulk edits, test and data runs, reproductions).
  When cheap-tier output fails review, rerun that piece on the strong tier instead of retrying it on the cheap one.
- A dispatch picks an executor and a tier. Every executor (Codex, `claude -p`, DeepSeek Harness `dsh`) offers both
  tiers as a profile named `strong` or `cheap` in its own config on the machine where it runs; the launch commands
  are in the cluster-controller skill. Pick the executor by quota and load: Codex, then `claude -p`, then `dsh`;
  `dsh` has no quota limit, so bulk cheap-tier work can go there directly. Strong-tier review of every result
  stays the same whichever executor did the work.
- Rules, skills, briefs and launch scripts name executors and tiers, never models: no `-m`/`--model` flags and no
  model ids. Each tier profile is the one place that sets its model and reasoning effort. Effort belongs to the tier,
  not to the task: a piece that needs more thought goes to the strong tier. When you need to know what a tier runs, or
  what else an executor offers, ask the executor: `codex debug models`, the DeepSeek `/models` API, Claude Code's
  `--model` aliases. Changing a tier's model or effort means editing that one profile, nothing else.
