Tiers for `claude -p` (owner, 2026-11-08: `decide` for analysis and review, `execute` for implementation and verification): `claude -p --settings ~/.claude/tiers/<tier>.json ...`.
Each file is the only place that sets its tier's model and effort. Models are Claude Code aliases (resolved by
Claude Code to the current model); `claude --help` lists the effort levels.
