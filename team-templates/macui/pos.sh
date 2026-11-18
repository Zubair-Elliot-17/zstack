#!/bin/bash
# pos.sh <filename>: centre of its icon in the front Finder window (icon view, 64 px icons).
cd "$(dirname "$0")"
./axfind com.apple.finder | grep "AXImage \[$1 " | head -1 | sed -E 's/.*@([0-9]+),([0-9]+) 64x64/\1 \2/' | awk '{print $1+32, $2+32}'
