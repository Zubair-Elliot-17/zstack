#!/bin/bash
# build.sh [out dir]: compiles the kit into out dir (default ~/.cache/macui, survives /clear); skips if up to date.
set -e; cd "$(dirname "$0")"; out="${1:-$HOME/.cache/macui}"; mkdir -p "$out"
for t in ev axfind axpress axbtn; do [ "$out/$t" -nt "$t.swift" ] || swiftc -O "$t.swift" -o "$out/$t"; done
cp pos.sh preflight.sh repeat.sh menu.sh "$out/"; echo "built into $out"
