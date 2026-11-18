#!/bin/bash
# Manual install without the plugin system: copy zstack into ~/.claude (or $CLAUDE_HOME).
# Existing files with the same name are kept as <file>.bak. Prefer the plugin install (see README).
set -euo pipefail
src="$(cd "$(dirname "$0")" && pwd)"
dest="${CLAUDE_HOME:-$HOME/.claude}"
esc="${dest//[\\&#]/\\&}"
tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT

for dir in skills agents team-templates hooks scripts; do
  (cd "$src/$dir" && find . -type f ! -name hooks.json ! -name .DS_Store) | while read -r f; do
    target="$dest/$dir/${f#./}"
    mkdir -p "$(dirname "$target")"
    # ${CLAUDE_PLUGIN_ROOT} only expands inside a plugin, so point it at the install folder here.
    sed "s#\${CLAUDE_PLUGIN_ROOT}#$esc#g" "$src/$dir/$f" > "$tmp"
    if [ -f "$target" ] && ! cmp -s "$tmp" "$target"; then cp "$target" "$target.bak"; fi
    cp "$tmp" "$target"; chmod 644 "$target"; [ ! -x "$src/$dir/$f" ] || chmod +x "$target"
  done
done
chmod +x "$dest"/hooks/zstack-guard.sh "$dest"/hooks/team-resume.sh "$dest"/hooks/git-readonly.sh "$dest"/scripts/ollama-review.sh "$dest"/scripts/local-llm

cat <<MSG
zstack installed into $dest.

Add these hooks to $dest/settings.json (merge with any hooks you already have):

  "hooks": {
    "SessionStart":     [{ "hooks": [{ "type": "command", "command": "$dest/hooks/team-resume.sh", "timeout": 10 }] }],
    "UserPromptSubmit": [{ "hooks": [{ "type": "command", "command": "$dest/hooks/zstack-guard.sh", "timeout": 5 }] }],
    "Stop":             [{ "hooks": [{ "type": "command", "command": "$dest/hooks/zstack-guard.sh", "timeout": 5 }] }],
    "PreToolUse":       [{ "matcher": "Bash", "hooks": [{ "type": "command", "command": "$dest/hooks/git-readonly.sh auto", "timeout": 5 }] }]
  }

The PreToolUse entry is what keeps the judge and local-review roles read-only (it replaces the old per-agent hook), so do not skip it.
Do not also install the plugin: you would get every hook and role twice.

Then open a project under ~/claude-work/projects (or set ZSTACK_PROJECTS) and type /z.
MSG
