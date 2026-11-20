# Dotfile

Personal shell/editor setup and minimal global agent constitution. Each managed file lives once in this repository; `setup.sh` links it under `$HOME` so there is no second copy to drift.

## Layout

| Root | Behavior | Contents |
| --- | --- | --- |
| `home/` | Linked under `$HOME` on every OS | `~/.agents/AGENTS.md` (also linked to `~/.codex/AGENTS.md`, `~/.gemini/AGENTS.md`, imported by `~/.claude/CLAUDE.md`) |
| `home-posix/` | Linked under `$HOME` on Linux/macOS | `~/.bash_aliases`, `~/.tmux.conf`, `~/.vimrc` |

### Scope boundary (what does NOT live here)

- **Executor tiers & model routing** (`operate / execute / decide`): single source of truth in Tycho Accounts.
- **Skills** (`<slug>/SKILL.md`): managed in `XaineChaeson/personal-skills` (personal/home) or company Git (work) and distributed via Tycho Host (`machine_ids`).
- **Credentials & machine-specific configs**: API keys, `auth.json`, `.credentials.json`, executor base configs (`~/.codex/config.toml`, `~/.claude/settings.json`, `~/.dsh/`), `~/.claude/rules/`, and project-specific rules (managed in Tycho).

## Set up a machine

Clone into `~/code/dotfile` and run `setup.sh`. On Windows run it from Git Bash on the same drive as `$HOME` (hard links cannot cross drives).

```bash
git clone https://github.com/XaineChaeson/dotfile.git ~/code/dotfile
~/code/dotfile/setup.sh
```

`setup.sh --check` previews changes without modifying files (`OK`, `NEW`, `RELINK`, `CONFLICT`).

## Update

Edit either the live path or the clone (same file), commit, and push from any machine with GitHub push access. On other machines:

```bash
git -C ~/code/dotfile pull --ff-only && ~/code/dotfile/setup.sh
```

## Tmux modes

Defined in `home-posix/.tmux.conf` and shown in the left status bar via `@mode` and `@mode_hint`:

- **Layout Mode** (`prefix + g`): `1` even-horizontal, `2` even-vertical, `3` main-horizontal, `4` main-vertical, `5` tiled; `prefix + G` opens popup menu.
- **Resize Mode** (`prefix + r`): `h/j/k/l` by 1 cell, `H/J/K/L` by 5 cells.
- **Pane Mode** (`prefix + p`): `h/j/k/l` focus, `v` split right, `b` split down, `m` mark, `x` kill marked, `C` clear marks, `s` enter Swap Mode.
- **Swap Mode** (`prefix + p` then `s`): `h/j/k/l` swap with neighbor.
- **Copy Mode** (`prefix + [`): Vim-style selection and copy.
