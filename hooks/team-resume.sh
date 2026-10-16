#!/bin/bash
# SessionStart: load saved team state so work resumes where it stopped.
# Output stays under ~9,000 chars (hook cap is 10,000) with Next action first.
dir="${CLAUDE_PROJECT_DIR:-$(jq -r '.cwd // empty' 2>/dev/null)}"
dir="${dir:-$PWD}"
state="$dir/.claude/team/STATE.md"
[ -f "$state" ] || exit 0
logs="$dir/.claude/team/logs"

{
  echo "# Saved team state ($state)"
  echo "Resume from Next action (or run /z). Teammates from the last session are gone; respawn roles if needed."
  echo
  # header lines (Mode, Stage, Branch) and the Next action section
  grep -E '^(Last updated|Mode|Stage|Branch)' "$state"
  echo
  awk '/^## Next action/{f=1} f&&/^## /&&!/^## Next action/{exit} f' "$state" | head -c 1200
  echo
  echo "## Full STATE.md"
  head -c 5000 "$state"
  if [ -d "$logs" ]; then
    echo; echo "## Role logs (latest entry each; full logs in $logs)"
    for f in "$logs"/*.md; do
      [ -f "$f" ] || continue
      echo; echo "### $(basename "$f" .md)"
      # last entry starts at the final '## ' heading
      awk '/^## /{buf=""} {buf=buf $0 "\n"} END{printf "%s", buf}' "$f" | head -c 600
    done
  fi
} | head -c 9000
