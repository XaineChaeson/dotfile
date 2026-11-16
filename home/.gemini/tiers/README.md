Tiers for the Antigravity CLI `agy` (owner, 2026-11-16: `decide` for analysis and review, `execute` for
implementation and verification). Each file is the only place that sets its tier's model; the slug carries the
reasoning level, and an optional `"effort"` key overrides it. List the slugs with `agy models`.

A launcher reads the tier file and hands its `model` to `agy --model`, because `agy` fails on an unknown `--model`,
whereas a model written into a settings file (`--settings`, `settings.json`) falls back to the saved default without
an error. The launcher itself never names a model.
