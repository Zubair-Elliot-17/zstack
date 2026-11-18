#!/bin/bash
# Maintainer tool, the reverse of install.sh: mirror the live zstack folders from ~/.claude into this repo.
# ./sync.sh --check only reports drift (exit 1 if any). Nothing is committed: review `git status` first.
set -euo pipefail
repo="$(cd "$(dirname "$0")" && pwd)"
live="${CLAUDE_HOME:-$HOME/.claude}"
case "${1:-}" in ""|--check) ;; *) echo "usage: ./sync.sh [--check]" >&2; exit 2 ;; esac

dirs=(agents hooks scripts team-templates)
for d in "$live"/skills/z "$live"/skills/z-*; do [ -d "$d" ] && dirs+=("skills/$(basename "$d")"); done
skip=(.DS_Store __pycache__ '*.bak')

if [ "${1:-}" = "--check" ]; then
  drift=0
  for d in "${dirs[@]}"; do diff -rq "${skip[@]/#/-x}" "$live/$d" "$repo/$d" || drift=1; done
  [ "$drift" = 0 ] || { echo "zstack: drift found; run ./sync.sh" >&2; exit 1; }
  echo "zstack: repo matches $live"; exit 0
fi

for d in "${dirs[@]}"; do rsync -a --delete "${skip[@]/#/--exclude=}" "$live/$d/" "$repo/$d/"; done
git -C "$repo" status --short
# This repo is public: everything in those live folders gets mirrored, so flag what needs a human look.
new="$(git -C "$repo" ls-files --others --exclude-standard -- "${dirs[@]}")"
[ -z "$new" ] || printf 'NEW files, check each belongs in a public repo:\n%s\n' "$new" >&2
if grep -rnF -e "$HOME" -e "$(id -un)@" "${dirs[@]/#/$repo/}" >&2; then
  echo "zstack: personal paths found above; fix them in $live before committing" >&2; exit 1
fi
