#!/usr/bin/env bash
# Lists optional tools zstack can use. Nothing here is required.
home="${CLAUDE_HOME:-$HOME/.claude}"
have() { command -v "$1" >/dev/null 2>&1; }
plugin() { compgen -G "$home/plugins/cache/*/$1" >/dev/null || [ -d "$home/plugins/$1" ] || [ -d "$home/skills/$1" ]; }
row() { printf '  %-9s %-22s %s\n' "$1" "$2" "$3"; }
check() { if "${@:3}"; then row present "$1" "$2"; else row missing "$1" "$2"; fi; }

echo "zstack optional tools (built-in steps cover anything missing):"
check gstack "/office-hours, /ship, /qa-only, /retro..." test -d "$home/skills/gstack"
check ponytail "stricter smallest-change rule" plugin ponytail
check mattpocock-skills "tdd, diagnosing-bugs" plugin mattpocock-skills
check ollama "local-review, local-llm" have ollama
check jq "git-readonly guard, local-llm" have jq
check gh "PR sync, ship" have gh
check playwright "z-test UI screenshots" have playwright
exit 0
