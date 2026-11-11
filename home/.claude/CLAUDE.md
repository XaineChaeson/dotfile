# Claude-only instructions

The instructions shared by every agent live in `~/.agents/AGENTS.md`:

@~/.agents/AGENTS.md

## Delegation

- Treat every executor the environment offers as one pool: other AI models through installed plugins,
  agents or CLIs, and Claude subagents. When work splits into self-contained pieces with a clear brief and
  a checkable result (implementation, refactors, tests, investigations, data runs), spread them across the
  pool so they run in parallel; do not leave an available executor idle while Claude does work it could
  take. Weigh by quota where the owner has stated it. If one cannot run, use another and note it in the report.
- A brief is a contract: complete cases, the source of expected values, what must not change, a checkable
  result. A case the contract missed is the design's defect.
- Keep with Claude the work that needs this conversation's context, cross-piece coordination or judgement
  calls. Verify every delegate's result the same way.
- Route each piece by its role, then use the role's tier; do not judge per dispatch how hard a piece is, and
  never let a free slot or a quota change what a piece is. Roles: **analyse** (design, research, diagnosis;
  read-only, a report) and **review** (read-only, a verdict on a given commit or package, by an executor that did
  not write it, in a new session, without the author's conclusions) take the `decide` tier; **implement**
  (commits and tests) and **verify** (test and data runs, reproductions, bulk mechanical edits; a report) take the
  `execute` tier. A root cause nobody has verified is analysis, not implementation. Override a role's tier only
  with a stated reason. When execute-tier output fails review, redo it on the `decide` tier; when decide-tier
  output fails review, stop and bring it to the owner.
- A dispatch picks a role, an executor and the role's tier. Every executor (Codex, `claude -p`, DeepSeek Harness
  `dsh`) offers both tiers as a profile named `decide` or `execute` in its own config on the machine where it
  runs; the launch commands are in the cluster-controller skill. Pick the executor by quota and load: Codex, then
  `claude -p`, then `dsh`; `dsh` has no quota limit, so bulk execute-tier work can go there directly. Review of
  every result stays the same whichever executor did the work.
- Rules, skills, briefs and launch scripts name executors and tiers, never models: no `-m`/`--model` flags and no
  model ids. Each tier profile is the one place that sets its model and reasoning effort. Effort belongs to the tier,
  not to the task or the role: more effort is not more ability, and a piece that needs more thought is analysis or
  review. When you need to know what a tier runs, or what else an executor offers, ask the executor: `codex debug models`, the DeepSeek `/models` API, Claude Code's
  `--model` aliases. Changing a tier's model or effort means editing that one profile, nothing else.
