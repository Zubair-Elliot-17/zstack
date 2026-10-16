#!/bin/bash
# Projects in ~/claude-work/projects: nudge into zstack and enforce a checkpoint every 30 min.
# UserPromptSubmit prints context; Stop blocks once if the checkpoint is stale.
input=$(cat)
event=$(jq -r '.hook_event_name // empty' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")
root="$HOME/claude-work/projects"
case "$cwd" in "$root"/*) ;; *) exit 0 ;; esac
proj="$root/$(cut -d/ -f1 <<<"${cwd#"$root"/}")"
state="$proj/.claude/team/STATE.md"

if [ ! -f "$state" ]; then
  [ "$event" = "UserPromptSubmit" ] && echo "zstack: no .claude/team/STATE.md in $proj. Project work here uses zstack; run /z first unless this is a small one-off (Solo) task."
  exit 0
fi

age=$(( ( $(date +%s) - $(stat -f %m "$state") ) / 60 ))
[ "$age" -lt 30 ] && exit 0
# only due if project files changed since the last checkpoint
changed=$(find "$proj" -newer "$state" -type f -not -path '*/node_modules/*' -not -path '*/.git/*' \
  -not -path '*/.claude/team/*' -not -path '*/dist/*' -not -path '*/.venv/*' -not -path '*/.next/*' -print -quit 2>/dev/null)
[ -z "$changed" ] && exit 0
msg="Checkpoint due: STATE.md last saved ${age} min ago. Checkpoint now (see CLAUDE.md # Projects): update STATE.md + your role logs, then a local WIP commit (not on main, no push)."
if [ "$event" = "Stop" ]; then
  [ "$(jq -r '.stop_hook_active // false' <<<"$input")" = "true" ] && exit 0
  echo "$msg" >&2; exit 2
fi
echo "$msg"
