#!/bin/bash
# PreToolUse hook for the judge and local-review roles: Bash may only read git (diff, status, log, show).
# Argument "auto" (used from hooks.json, which fires for every agent): the mode comes from the calling
# agent's type (judge, local-review, with or without a "zstack:" prefix); any other agent or the main session passes.
# Argument "review": a git diff must be piped into ollama-review.sh. Anything else is blocked.
deny() { echo "Blocked: $1. This role may only run one plain git diff, status, log or show (no quotes, pipes or chaining; paths without spaces)." >&2; exit 2; }

mode="${1:-}"
input="$(cat)"
if [ "$mode" = auto ]; then
  # Fails open without jq: this hook is a guardrail on top of the agents' own instructions.
  command -v jq >/dev/null || { echo "zstack: jq not found, judge/local-review Bash is not restricted" >&2; exit 0; }
  case "$(printf '%s' "$input" | jq -r '.agent_type // empty')" in
    judge|zstack:judge) mode="" ;;
    local-review|zstack:local-review) mode=review ;;
    *) exit 0 ;;
  esac
fi

cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)" || deny "the hook could not read the command (is jq installed?)"
[ -n "$cmd" ] || deny "empty command"

subs='diff|status|log|show'
if [ "$mode" = review ]; then
  subs='diff'
  script='/.claude/scripts/ollama-review.sh'
  self="$(cd "$(dirname "$0")/../scripts" && pwd)/ollama-review.sh"
  for tail in " | $self" " | ~$script" " | $HOME$script" ' | $HOME'"$script" ' | "$HOME"'"$script"; do
    [ "$cmd" != "${cmd%"$tail"}" ] && { cmd="${cmd%"$tail"}"; piped=1; break; }
  done
  [ -n "${piped:-}" ] || deny "the command must end with: | $self"
fi

# Plain characters only, so no quoting trick can hide an option from the checks below.
[[ "$cmd" =~ ^[A-Za-z0-9_./:=@^~,+%\ \&-]+$ ]] || deny "only letters, digits and _ . / : = @ ^ ~ , + % - are allowed"
case "$cmd" in *--output*|*--ext*|*--no-index*) deny "that git option writes files, runs a program or reads outside the repo" ;; esac
p='[A-Za-z0-9_./:=@^~,+%-]'
[[ "$cmd" =~ ^(cd\ $p+\ \&\&\ )?git\ (-C\ $p+\ )?($subs)(\ +$p+)*$ ]] || deny "not a single read-only git command"
exit 0
