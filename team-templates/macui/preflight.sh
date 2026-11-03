#!/bin/bash
# preflight.sh <fixture dir>: fails if the machine state makes synthetic UI runs flaky.
ok=1
[ "$(defaults read com.apple.WindowManager GloballyEnabled 2>/dev/null)" = 1 ] && { echo "FAIL Stage Manager is on"; ok=0; }
case "$(cd "$1" && pwd -P)" in */Desktop*|*/Documents*|*Mobile\ Documents*) echo "FAIL fixtures in an iCloud-synced folder: $1"; ok=0;; esac
# per-window loop: a whose-clause over windows errors (-1726); an osascript error counts as FAIL
full=$(osascript -e 'tell application "System Events"
set out to ""
repeat with p in (every process whose visible is true)
try
repeat with w in windows of p
if value of attribute "AXFullScreen" of w is true then set out to out & name of p & " "
end repeat
end try
end repeat
return out
end tell') || { echo "FAIL full-screen check errored"; ok=0; }
[ -n "$full" ] && { echo "FAIL full-screen apps: $full"; ok=0; }
[ $ok = 1 ] && echo "preflight OK"; [ $ok = 1 ]
