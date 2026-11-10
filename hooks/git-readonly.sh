#!/bin/bash
# PreToolUse hook for the judge and local-review roles: Bash may only read git (diff, status, log, show).
# With the "review" argument, a git diff must be piped into ollama-review.sh. Anything else is blocked.
deny() { echo "Blocked: $1. This role may only run one plain git diff, status, log or show (no quotes, pipes or chaining; paths without spaces)." >&2; exit 2; }

cmd="$(jq -r '.tool_input.command // empty' 2>/dev/null)" || deny "the hook could not read the command (is jq installed?)"
[ -n "$cmd" ] || deny "empty command"

subs='diff|status|log|show'
if [ "${1:-}" = "review" ]; then
  subs='diff'
  script='/.claude/scripts/ollama-review.sh'
  for tail in " | ~$script" " | $HOME$script" ' | $HOME'"$script" ' | "$HOME"'"$script"; do
    [ "$cmd" != "${cmd%"$tail"}" ] && { cmd="${cmd%"$tail"}"; piped=1; break; }
  done
  [ -n "${piped:-}" ] || deny "the command must end with: | ~/.claude/scripts/ollama-review.sh"
fi

# Plain characters only, so no quoting trick can hide an option from the checks below.
[[ "$cmd" =~ ^[A-Za-z0-9_./:=@^~,+%\ \&-]+$ ]] || deny "only letters, digits and _ . / : = @ ^ ~ , + % - are allowed"
case "$cmd" in *--output*|*--ext-diff*) deny "that git option writes files or runs a program" ;; esac
p='[A-Za-z0-9_./:=@^~,+%-]'
[[ "$cmd" =~ ^(cd\ $p+\ \&\&\ )?git\ (-C\ $p+\ )?($subs)(\ +$p+)*$ ]] || deny "not a single read-only git command"
exit 0
