# Dotfile

The single source of my agent instructions, executor tier profiles and shell/editor configs. Each file exists
once, in a clone of this repository; `setup.sh` makes the live path under `$HOME` a link to it, so there is no
second copy to drift.

## What's inside

Everything under `home/` is linked at the same path under `$HOME` on every machine; `home-posix/` only on
Linux/macOS.

| Live path | What it is |
| --- | --- |
| `~/.agents/AGENTS.md` | Global instructions shared by every agent (Claude, Codex, DeepSeek Harness) |
| `~/.codex/AGENTS.md` | The same file, so Codex reads it too (not stored twice; `setup.sh` links it) |
| `~/.claude/CLAUDE.md` | Imports `~/.agents/AGENTS.md` and adds the Claude-only Delegation section |
| `~/.codex/{strong,cheap}.config.toml` | Codex tiers: `codex --profile <tier>` |
| `~/.claude/tiers/{strong,cheap}.json` | Claude tiers: `claude -p --settings ~/.claude/tiers/<tier>.json` |
| `~/.dsh/tiers/{strong,cheap}.patch.yml` | DeepSeek Harness tiers: `dsh --profile headless --patch ~/.dsh/tiers/<tier>.patch.yml` |
| `~/.codex/full-access.config.toml` | Explicit Codex permission profile: `codex --profile full-access` |
| `~/.tmux.conf`, `~/.vimrc`, `~/.bash_aliases` | Shell and editor configs (Linux/macOS) |

Each tier profile is the only place that sets its tier's model and reasoning effort; rules, skills and launch
commands name only the executor and the tier.

`codex/config.portable.toml` is different: it seeds `~/.codex/config.toml` once on a machine that has none, because
Codex writes machine state (trusted projects, plugins, UI) into that file. After that the file belongs to the
machine.

Not here, on purpose: credentials and keys (`~/.dsh/.env`, Codex `auth.json`, Claude `.credentials.json`),
executor base configs (`~/.codex/config.toml` after seeding, dsh `profiles/`, Claude `settings.json`),
machine-specific rules such as `~/.claude/rules/`, and skills.

## Set up a machine

Clone into `~/code/dotfile` and run the setup script. On Windows run it from Git Bash, with the clone on the same
drive as your user folder (hard links cannot cross drives). On the cluster, Home is shared by all instances, so this
is needed once.

```bash
git clone https://github.com/XaineChaeson/dotfile.git ~/code/dotfile
```

```bash
~/code/dotfile/setup.sh
```

It prints one line per path: `OK` already linked, `NEW` created, `RELINK` an existing file replaced by the link
(only when its content is the repo file's or already in this repository's history, so nothing is lost), `CONFLICT`
an existing file with other content, left untouched. It also reports `SEED`/`KEEP` for the Codex base config and
`APPEND`/`OK` for the shell startup files that source `~/.bash_aliases` (it appends to the first existing one of
`.bashrc`, `.bash_profile`, `.profile`, plus `.zshrc`, and never creates one). On a conflict, put the content you
want into the repo file (or move the live file aside) and run it again. The script exits non-zero while anything
is unresolved; `setup.sh --check` changes nothing and reports `TODO` for what a run would do.

Links are symlinks on Linux/macOS and hard links on Windows, where symlinks need administrator rights.

## Change a file

Edit it at its live path or in the clone: it is the same file. Commit and push from the controller workstation
(the cluster cannot push to GitHub). Then on each other machine:

```bash
git -C ~/code/dotfile pull --ff-only && ~/code/dotfile/setup.sh
```

Re-running `setup.sh` picks up new files everywhere. On Windows it also repairs hard links: a `git pull`,
`checkout` or `stash` that rewrites a file leaves the live path holding the old version, which `setup.sh` then
relinks. A tool that saves by writing a new file and renaming it over the old one (`sed -i`, some editors) breaks
the link on any platform; the live file then holds your new text, so `setup.sh` reports a conflict: copy the live
file over the repo file, commit, and run it again.

## Tmux modes

These modes are defined in `.tmux.conf` and are shown in the left status bar
via `@mode` and `@mode_hint`.

### Layout Mode

- Enter: `prefix + g`
- Purpose: Switch window layouts quickly.
- Keys: `1` even-horizontal, `2` even-vertical, `3` main-horizontal, `4`
  main-vertical, `5` tiled
- Exit: `q` / `Esc` / `Enter`
- Alternate: `prefix + G` opens a layout popup menu (no mode).

### Resize Mode

- Enter: `prefix + r`
- Purpose: Repeatedly resize panes.
- Keys: `h/j/k/l` move by 1 cell, `H/J/K/L` move by 5 cells
- Exit: `q` / `Esc` / `Enter`

### Pane Mode

- Enter: `prefix + p`
- Purpose: Pane management (switch, split, mark, batch ops).
- Keys:
  - `h/j/k/l` switch focus
  - `v` split right (keep cwd)
  - `b` split down (keep cwd)
  - `m` toggle mark on current pane (red dot indicator)
  - `x` kill all marked panes in current window
  - `C` clear all marks in current window
  - `s` enter swap sub-mode
- Exit: `q` / `Esc` / `Enter`

### Swap Mode (Pane sub-mode)

- Enter: in Pane Mode, press `s`
- Purpose: Swap with adjacent panes while keeping focus on the carried pane.
- Keys: `h/j/k/l` swap with left/down/up/right neighbor
- Exit: `q` / `Esc` / `Enter` (back to Pane Mode)

### Copy Mode (Vim style)

- Enter: tmux default (for example `prefix + [`)
- Purpose: Select and copy text to tmux buffer.
- Keys: `v` begin selection, `V` select line, `y` copy and exit

