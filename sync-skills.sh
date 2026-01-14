#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  sync-skills.sh to-codex [--skill NAME]... [--delete] [--dry-run]
  sync-skills.sh from-codex [--skill NAME]... [--delete] [--dry-run]

Defaults to syncing all skills in the source directory.

Environment:
  REPO_SKILLS_DIR  default: <repo>/skills
  CODEX_HOME       default: ~/.codex
  CODEX_SKILLS_DIR default: $CODEX_HOME/skills
USAGE
}

die() {
  echo "error: $*" >&2
  exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${REPO_ROOT:-$SCRIPT_DIR}"
REPO_SKILLS_DIR="${REPO_SKILLS_DIR:-$REPO_ROOT/skills}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
CODEX_SKILLS_DIR="${CODEX_SKILLS_DIR:-$CODEX_HOME/skills}"

direction=""
delete=false
dry_run=false
skills=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    to-codex|from-codex)
      direction="$1"
      shift
      ;;
    --skill)
      [[ $# -ge 2 ]] || die "--skill requires a name"
      skills+=("$2")
      shift 2
      ;;
    --delete)
      delete=true
      shift
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown argument: $1"
      ;;
  esac
done

[[ -n "$direction" ]] || die "direction is required"

if [[ "$direction" == "to-codex" ]]; then
  src_dir="$REPO_SKILLS_DIR"
  dst_dir="$CODEX_SKILLS_DIR"
elif [[ "$direction" == "from-codex" ]]; then
  src_dir="$CODEX_SKILLS_DIR"
  dst_dir="$REPO_SKILLS_DIR"
else
  die "unsupported direction: $direction"
fi

[[ -d "$src_dir" ]] || die "source directory not found: $src_dir"
mkdir -p "$dst_dir"

if [[ ${#skills[@]} -eq 0 ]]; then
  mapfile -t skills < <(find "$src_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
fi

[[ ${#skills[@]} -gt 0 ]] || die "no skills to sync from: $src_dir"

if command -v rsync >/dev/null 2>&1; then
  rsync_flags=(-a)
  $delete && rsync_flags+=("--delete")
  $dry_run && rsync_flags+=("--dry-run" "--itemize-changes")
  for skill in "${skills[@]}"; do
    src_skill="$src_dir/$skill"
    dst_skill="$dst_dir/$skill"
    [[ -d "$src_skill" ]] || die "skill not found in source: $skill"
    rsync "${rsync_flags[@]}" "$src_skill"/ "$dst_skill"/
  done
else
  for skill in "${skills[@]}"; do
    src_skill="$src_dir/$skill"
    dst_skill="$dst_dir/$skill"
    [[ -d "$src_skill" ]] || die "skill not found in source: $skill"
    $dry_run && {
      echo "Would sync $src_skill -> $dst_skill"
      continue
    }
    if $delete; then
      rm -rf "$dst_skill"
    fi
    mkdir -p "$dst_skill"
    cp -a "$src_skill"/. "$dst_skill"/
  done
fi
