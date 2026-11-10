#!/bin/bash
# PreToolUse hook for the judge and local-review roles: Bash may only read git (diff, status, log, show).
# With the "review" argument, a git diff may also be piped into ollama-review.sh. Anything else is blocked.
deny() { echo "Blocked: $1. This role may only run git diff, git status, git log and git show." >&2; exit 2; }

cmd="$(jq -r '.tool_input.command // empty' 2>/dev/null)" || deny "the hook could not read the command (is jq installed?)"
[ -n "$cmd" ] || deny "empty command"

subs='diff|status|log|show'
if [ "${1:-}" = "review" ]; then
  subs='diff'
  for tail in ' | ~/.claude/scripts/ollama-review.sh' " | $HOME/.claude/scripts/ollama-review.sh"; do
    [ "$cmd" != "${cmd%"$tail"}" ] && { cmd="${cmd%"$tail"}"; piped=1; break; }
  done
  [ -n "${piped:-}" ] || deny "the command must end with: | ~/.claude/scripts/ollama-review.sh"
fi

# No chaining, substitution or redirection; --output would write a file.
case "$cmd" in *$'\n'*|*--output*) deny "not a single read-only git command" ;; esac
safe='[^;&|`$<>]'
[[ "$cmd" =~ ^(cd\ $safe+\ \&\&\ )?git\ (-C\ [^[:space:]\;\&\|\`\$\<\>]+\ )?($subs)([[:space:]]$safe*)?$ ]] ||
  deny "not a single read-only git command"
exit 0
