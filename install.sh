#!/usr/bin/env bash
set -euo pipefail

os="$(uname -s)"
case "$os" in
  Darwin) platform="mac";;
  Linux) platform="linux";;
  *) platform="unknown";;
esac

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

timestamp() {
  date +"%Y%m%d%H%M%S"
}

copy_file() {
  local src="$1"
  local dest="$2"
  local dest_dir

  dest_dir="$(dirname "$dest")"
  mkdir -p "$dest_dir"

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ ! -L "$dest" ]] && cmp -s "$src" "$dest"; then
      printf 'OK   %s\n' "$dest"
      return
    fi
    local backup="$dest.bak.$(timestamp)"
    if [[ -L "$dest" ]]; then
      cp -p "$(readlink -f "$dest")" "$backup"
      rm "$dest"
    else
      mv "$dest" "$backup"
    fi
    printf 'BAK %s -> %s\n' "$dest" "$backup"
  fi

  cp -p "$src" "$dest"
  printf 'COPY %s -> %s\n' "$src" "$dest"
}

copy_file_if_missing() {
  local src="$1"
  local dest="$2"

  if [[ -e "$dest" || -L "$dest" ]]; then
    printf 'SKIP %s (existing machine-local file)\n' "$dest"
    return
  fi

  mkdir -p "$(dirname "$dest")"
  cp -p "$src" "$dest"
  printf 'COPY %s -> %s\n' "$src" "$dest"
}

printf 'Platform: %s (%s)\n' "$platform" "$os"
printf 'Repo: %s\n' "$script_dir"

copy_file "$script_dir/.tmux.conf" "$HOME/.tmux.conf"
copy_file "$script_dir/.vimrc" "$HOME/.vimrc"
copy_file "$script_dir/.bash_aliases" "$HOME/.bash_aliases"
copy_file "$script_dir/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
copy_file "$script_dir/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
copy_file_if_missing "$script_dir/codex/config.portable.toml" "$HOME/.codex/config.toml"
copy_file "$script_dir/codex/profiles/full-access.config.toml" "$HOME/.codex/full-access.config.toml"

ensure_source() {
  local rc="$1"
  local line='[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"'

  if [[ ! -e "$rc" ]]; then
    printf '%s\n' "$line" >"$rc"
    printf 'INIT %s\n' "$rc"
    return
  fi

  if ! grep -Fq "$line" "$rc"; then
    printf '\n%s\n' "$line" >>"$rc"
    printf 'ADD  %s\n' "$rc"
  else
    printf 'OK   %s\n' "$rc"
  fi
}

# Inject aliases into shell startup files if present (or create if missing).
if [[ -e "$HOME/.bashrc" ]]; then
  ensure_source "$HOME/.bashrc"
else
  ensure_source "$HOME/.bash_profile"
fi

ensure_source "$HOME/.zshrc"

printf 'Done.\n'
