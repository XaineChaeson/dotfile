#!/usr/bin/env bash
set -euo pipefail

os="$(uname -s)"
case "$os" in
  Darwin) platform="mac";;
  Linux) platform="linux";;
  *) platform="unknown";;
esac

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

resolve_link() {
  local link
  link="$(readlink "$1")"
  if [[ "$link" = /* ]]; then
    printf '%s\n' "$link"
  else
    printf '%s\n' "$(cd "$(dirname "$1")" && pwd)/$link"
  fi
}

restore_backup() {
  local dest="$1"
  local backup
  backup="$(ls -t "$dest".bak.* 2>/dev/null | head -n 1 || true)"
  if [[ -n "$backup" ]]; then
    mv "$backup" "$dest"
    printf 'RESTORE %s -> %s\n' "$backup" "$dest"
  fi
}

unlink_file() {
  local src="$1"
  local dest="$2"

  if [[ -L "$dest" ]]; then
    if [[ "$(resolve_link "$dest")" = "$src" ]]; then
      rm "$dest"
      printf 'UNLINK %s\n' "$dest"
      if [[ ! -e "$dest" ]]; then
        restore_backup "$dest"
      fi
      return
    fi
  fi

  printf 'SKIP %s\n' "$dest"
}

remove_source_line() {
  local rc="$1"
  local line='[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"'

  if [[ ! -e "$rc" ]]; then
    return
  fi

  if grep -Fq "$line" "$rc"; then
    local tmp
    tmp="$(mktemp)"
    grep -Fv "$line" "$rc" >"$tmp"
    mv "$tmp" "$rc"
    printf 'CLEAN %s\n' "$rc"
  fi
}

printf 'Platform: %s (%s)\n' "$platform" "$os"
printf 'Repo: %s\n' "$script_dir"

unlink_file "$script_dir/.tmux.conf" "$HOME/.tmux.conf"
unlink_file "$script_dir/.vimrc" "$HOME/.vimrc"
unlink_file "$script_dir/.bash_aliases" "$HOME/.bash_aliases"

remove_source_line "$HOME/.bashrc"
remove_source_line "$HOME/.bash_profile"
remove_source_line "$HOME/.zshrc"

printf 'Done.\n'
