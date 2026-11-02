#!/usr/bin/env bash
# Make $HOME use this clone's files: every tracked file under home/ (and home-posix/ on Linux/macOS)
# becomes a link at the same path under $HOME, so the clone holds the only copy. Links are symlinks on
# Linux/macOS and hard links on Windows (Git Bash), where symlinks need administrator rights.
#
#   ./setup.sh          create missing links; re-run after every git pull
#   ./setup.sh --check  change nothing; exit 1 if anything is not linked
#
# An existing file is replaced only when its content is the repo file's or already in this repository's
# history, so nothing is lost. Anything else is reported as CONFLICT and left untouched.
set -euo pipefail

repo="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd)"

check=0
case "${1:-}" in
  --check) check=1 ;;
  "") ;;
  *) echo "usage: $0 [--check]" >&2; exit 2 ;;
esac

case "$(uname -s)" in
  MINGW* | MSYS* | CYGWIN*) windows=1 ;;
  *) windows=0 ;;
esac

problems=0

# True when the content of file $1 is in this repository's history.
in_history() {
  local blob
  blob="$(git -C "$repo" hash-object --no-filters -- "$1")" && [[ -n "$blob" ]] || return 1
  [[ -n "$(git -C "$repo" log --all -1 --format=%H --find-object="$blob")" ]]
}

# link DEST TARGET REL: make DEST a link to TARGET, whose content is repo path REL.
link() {
  local dest="$1" target="$2" rel="$3" verb note=""

  if [[ "$dest" -ef "$target" ]]; then
    printf 'OK       %s\n' "$dest"
    return
  fi

  if [[ ! -e "$dest" && ! -L "$dest" ]]; then
    verb=NEW
  elif [[ -f "$dest" ]] && cmp -s "$dest" "$repo/$rel"; then
    verb=RELINK note="(same content)"
  elif [[ -f "$dest" ]] && in_history "$dest"; then
    verb=RELINK note="(was an earlier version)"
  else
    printf 'CONFLICT %s differs from %s; put the content you want in the repo file, or move the live file aside, then re-run\n' \
      "$dest" "$repo/$rel"
    problems=$((problems + 1))
    return
  fi

  if ((check)); then
    printf 'TODO     %s  %s %s\n' "$dest" "$verb" "$note"
    problems=$((problems + 1))
    return
  fi

  local tmp="$dest.setup-tmp.$$"
  mkdir -p "$(dirname "$dest")"
  if ((windows)); then
    ln -f "$target" "$tmp"
  else
    ln -sfn "$target" "$tmp"
  fi
  mv -f "$tmp" "$dest"
  printf '%-8s %s %s\n' "$verb" "$dest" "$note"
}

# Seed DEST from SRC once; afterwards DEST belongs to the machine.
seed() {
  local src="$1" dest="$2"
  if [[ -e "$dest" ]]; then
    printf 'KEEP     %s (machine-local)\n' "$dest"
  elif ((check)); then
    printf 'TODO     %s  SEED\n' "$dest"
    problems=$((problems + 1))
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    printf 'SEED     %s\n' "$dest"
  fi
}

# Make shell startup file $1 source ~/.bash_aliases.
source_aliases() {
  local rc="$1" line='[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"'
  if grep -Fqx "$line" "$rc"; then
    printf 'OK       %s\n' "$rc"
  elif ((check)); then
    printf 'TODO     %s  source .bash_aliases\n' "$rc"
    problems=$((problems + 1))
  else
    printf '\n%s\n' "$line" >>"$rc"
    printf 'APPEND   %s\n' "$rc"
  fi
}

roots=(home)
((windows)) || roots+=(home-posix)

while IFS= read -r -d '' rel; do
  link "$HOME/${rel#*/}" "$repo/$rel" "$rel"
done < <(git -C "$repo" ls-files -z -- "${roots[@]}")

# Codex reads ~/.codex/AGENTS.md: the same file as ~/.agents/AGENTS.md.
link "$HOME/.codex/AGENTS.md" "$repo/home/.agents/AGENTS.md" home/.agents/AGENTS.md

# Codex also writes machine state (trusted projects, plugins, UI) into config.toml, so it is only seeded.
seed "$repo/codex/config.portable.toml" "$HOME/.codex/config.toml"

# Hook into the first bash startup file that exists, and zsh's; never create one, since a new
# ~/.bash_profile would stop bash from reading ~/.profile.
if ((!windows)); then
  bash_rc=""
  for rc in .bashrc .bash_profile .profile; do
    if [[ -e "$HOME/$rc" ]]; then bash_rc="$HOME/$rc"; break; fi
  done
  if [[ -n "$bash_rc" ]]; then
    source_aliases "$bash_rc"
  else
    printf 'TODO     no bash startup file; source ~/.bash_aliases from yours
'
    problems=$((problems + 1))
  fi
  if [[ -e "$HOME/.zshrc" ]]; then source_aliases "$HOME/.zshrc"; fi
fi

if ((problems)); then
  printf '%d item(s) need attention.\n' "$problems" >&2
  exit 1
fi
printf 'All linked.\n'
