#!/bin/bash
# Maintainer tool, the reverse of install.sh: copy the live zstack files from ~/.claude into this repo.
# ./sync.sh --check only reports drift (exit 1 if any). Review `git status` before committing.
set -euo pipefail
repo="$(cd "$(dirname "$0")" && pwd)"
live="${CLAUDE_HOME:-$HOME/.claude}"

dirs=(agents hooks scripts team-templates)
for d in "$live"/skills/z "$live"/skills/z-*; do dirs+=("skills/$(basename "$d")"); done

if [ "${1:-}" = "--check" ]; then
  drift=0
  for d in "${dirs[@]}"; do diff -rq -x '*.bak' "$live/$d" "$repo/$d" || drift=1; done
  [ "$drift" = 0 ] && echo "zstack: repo matches $live" || { echo "zstack: drift found; run ./sync.sh" >&2; exit 1; }
  exit 0
fi

for d in "${dirs[@]}"; do rsync -a --delete --exclude '*.bak' "$live/$d/" "$repo/$d/"; done
git -C "$repo" status --short
