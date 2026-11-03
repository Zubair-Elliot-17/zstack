#!/bin/bash
# menu.sh <bundle-id> [item]: real-clicks the app's menu-bar extra (activates it, unlike axpress), then the named item.
# Needs ev + axfind built next to it (build.sh). Exit 1 if the icon or item isn't found.
d=$(dirname "$0")
centre() { awk -v want="$1" '$1==want { split($NF,s,"x"); sub(/^@/,"",$(NF-1)); split($(NF-1),p,","); if (s[1]>0) { print int(p[1]+s[1]/2), int(p[2]+s[2]/2); exit } }'; }
click() { "$d/ev" move "$1" "$2" sleep 150 down "$1" "$2" sleep 100 up "$1" "$2"; }
read -r x y < <("$d/axfind" "$1" --menubar | centre AXMenuBarItem)
[ -n "$x" ] || { echo "menu-bar extra not found for $1"; exit 1; }
click "$x" "$y"; sleep 0.6
[ -z "$2" ] && exit 0
read -r x y < <("$d/axfind" "$1" --menubar | grep -F "AXMenuItem [$2]" | centre AXMenuItem)
[ -n "$x" ] || { echo "item not found: $2"; "$d/ev" move 0 0; osascript -e 'tell application "System Events" to key code 53'; exit 1; }
click "$x" "$y"
