#!/bin/bash
# Copy zstack into ~/.claude. Existing files with the same name are kept as <file>.bak.
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)"
dest="${CLAUDE_HOME:-$HOME/.claude}"

for dir in skills agents team-templates hooks; do
  (cd "$src/$dir" && find . -type f) | while read -r f; do
    target="$dest/$dir/${f#./}"
    mkdir -p "$(dirname "$target")"
    if [ -f "$target" ] && ! cmp -s "$src/$dir/$f" "$target"; then cp "$target" "$target.bak"; fi
    cp "$src/$dir/$f" "$target"
  done
done
chmod +x "$dest"/hooks/zstack-guard.sh "$dest"/hooks/team-resume.sh

cat <<MSG
zstack installed into $dest.

Add these hooks to $dest/settings.json (merge with any hooks you already have):

  "hooks": {
    "SessionStart":     [{ "hooks": [{ "type": "command", "command": "$dest/hooks/team-resume.sh", "timeout": 10 }] }],
    "UserPromptSubmit": [{ "hooks": [{ "type": "command", "command": "$dest/hooks/zstack-guard.sh", "timeout": 5 }] }],
    "Stop":             [{ "hooks": [{ "type": "command", "command": "$dest/hooks/zstack-guard.sh", "timeout": 5 }] }]
  }

Then open a project in ~/claude-work/projects/<name> and type /z.
MSG
