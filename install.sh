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

resolve_link() {
  local link
  link="$(readlink "$1")"
  if [[ "$link" = /* ]]; then
    printf '%s\n' "$link"
  else
    printf '%s\n' "$(cd "$(dirname "$1")" && pwd)/$link"
  fi
}

link_file() {
  local src="$1"
  local dest="$2"
  local dest_dir

  dest_dir="$(dirname "$dest")"
  mkdir -p "$dest_dir"

  if [[ -L "$dest" ]]; then
    if [[ "$(resolve_link "$dest")" = "$src" ]]; then
      printf 'OK  %s -> %s\n' "$dest" "$src"
      return
    fi
  elif [[ -e "$dest" ]]; then
    local backup="$dest.bak.$(timestamp)"
    mv "$dest" "$backup"
    printf 'BAK %s -> %s\n' "$dest" "$backup"
  fi

  ln -s "$src" "$dest"
  printf 'LINK %s -> %s\n' "$dest" "$src"
}

printf 'Platform: %s (%s)\n' "$platform" "$os"
printf 'Repo: %s\n' "$script_dir"

link_file "$script_dir/.tmux.conf" "$HOME/.tmux.conf"
link_file "$script_dir/.vimrc" "$HOME/.vimrc"
link_file "$script_dir/.bash_aliases" "$HOME/.bash_aliases"

ensure_source() {
  local rc="$1"
  local line='[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"'

  if [[ ! -e "$rc" ]]; then
    printf '%s\n' "$line" >"$rc"
    printf 'INIT %s\n' "$rc"
    return
  fi

  if ! rg -qF "$line" "$rc"; then
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
