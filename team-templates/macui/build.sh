#!/bin/bash
# build.sh <out dir>: compiles the kit's tools into <out dir> (use the session scratchpad).
set -e; cd "$(dirname "$0")"; mkdir -p "$1"
for t in ev axfind axpress axbtn; do swiftc -O "$t.swift" -o "$1/$t"; done
cp pos.sh preflight.sh repeat.sh menu.sh "$1/"; echo "built into $1"
