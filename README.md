# Dotfile

This repo contains my personal dotfile setup plus a couple of helper components.

## What's inside

- **dotfile**: Shell/editor/tooling configs that I use day-to-day.
- **skills**: Custom Codex skills I use for my own workflows.
- **chrome-devtool-remote**: A solution for running remote Chrome DevTools on Linux.

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

## Install

Run the installer to symlink the configs and wire `.bash_aliases` into your
shell startup files:

```bash
./install.sh
```

What it does:

- Links `.tmux.conf`, `.vimrc`, `.bash_aliases` into `$HOME`
- Backs up existing files as `*.bak.<timestamp>`
- Ensures `~/.bashrc` (or `~/.bash_profile`) and `~/.zshrc` source
  `.bash_aliases`

## Uninstall

Remove the symlinks and restore the most recent backups (if present):

```bash
./uninstall.sh
```

What it does:

- Unlinks files only if they point to this repo
- Restores latest `*.bak.<timestamp>` when available
- Removes the `.bash_aliases` source line from `~/.bashrc`, `~/.bash_profile`,
  and `~/.zshrc`

## Skill Sync

Sync Codex skills between this repo and your local Codex skills directory:

```bash
./sync-skills.sh to-codex
./sync-skills.sh from-codex --skill project-docs-maintenance
./sync-skills.sh to-codex --dry-run
./sync-skills.sh from-codex --delete
```

Options:

- `to-codex` sync from this repo to local Codex skills
- `from-codex` sync from local Codex skills to this repo
- `--skill NAME` sync only specific skills (repeatable); if omitted, syncs all skills from the source
- `--dry-run` preview what would change without writing
- `--delete` remove files in the destination that do not exist in source

Environment overrides:

- `REPO_SKILLS_DIR` (default: `<repo>/skills`)
- `CODEX_HOME` (default: `~/.codex`)
- `CODEX_SKILLS_DIR` (default: `$CODEX_HOME/skills`)

## Notes

If you're using this repo as a reference, adapt paths and tooling to your own environment.
