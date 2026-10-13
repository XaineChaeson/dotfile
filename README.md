# Dotfile

This repo contains my personal machine configuration and bootstrap helpers.

## What's inside

- **dotfile**: Shell/editor/tooling configs that I use day-to-day.
- **codex**: Portable personal Codex defaults and global instructions.
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

Run the installer to copy the configs into `$HOME` and wire `.bash_aliases`
into your shell startup files:

```bash
./install.sh
```

What it does:

- Copies `.tmux.conf`, `.vimrc`, `.bash_aliases` into `$HOME`
- Copies the global Codex `AGENTS.md` into `~/.codex`
- Installs the portable Codex config only when `~/.codex/config.toml` does not exist
- Installs the explicit `full-access` Codex profile without making it the default
- Backs up existing files as `*.bak.<timestamp>`
- Ensures `~/.bashrc` (or `~/.bash_profile`) and `~/.zshrc` source
  `.bash_aliases`
- Does not symlink tracked repo files, so editing deployed files under `$HOME`
  will not modify this repository

## Uninstall

Remove managed copies and restore the most recent backups (if present):

```bash
./uninstall.sh
```

What it does:

- Removes old symlinks only if they point to this repo
- Removes copied files only if they still match the repo version; modified local
  files are skipped
- Restores latest `*.bak.<timestamp>` when available
- Removes the `.bash_aliases` source line from `~/.bashrc`, `~/.bash_profile`,
  and `~/.zshrc`

## Codex Configuration Boundary

`codex/config.portable.toml` contains only defaults intended to move between machines. The installer does not overwrite an existing live config because Codex also stores machine-specific project trust, MCP paths, plugin state, and UI state there.

The current machine's elevated permission choice is installed separately as `~/.codex/full-access.config.toml`. Select it explicitly with `codex --profile full-access`; it is not the automatic new-machine default.

Credentials, `auth.json`, sessions, caches, generated marketplace state, trusted-project paths, and machine-specific MCP commands are not owned by this repository.

This repository does not install or synchronize skills. Codex system skills and connected-plugin skills remain owned by Codex and their plugins. The retired personal skill manager and its installed copies were removed from this machine; see the [repository retirement record](docs/repository-retirement.md).

## Notes

If you're using this repo as a reference, adapt paths and tooling to your own environment.
